Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51FC735CF5
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 14:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727642AbfFEMfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 08:35:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55420 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727273AbfFEMfz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 08:35:55 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8ABA585541;
        Wed,  5 Jun 2019 12:35:54 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.32.181.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9B0E117CE5;
        Wed,  5 Jun 2019 12:35:53 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, mcroce@redhat.com
Subject: [PATCH net] pktgen: do not sleep with the thread lock held.
Date:   Wed,  5 Jun 2019 14:34:46 +0200
Message-Id: <7fed17636f7a9d51b0603c8a4cfdd2111cd946e1.1559737968.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Wed, 05 Jun 2019 12:35:54 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the process issuing a "start" command on the pktgen procfs
interface, acquires the pktgen thread lock and never release it, until
all pktgen threads are completed. The above can blocks indefinitely any
other pktgen command and any (even unrelated) netdevice removal - as
the pktgen netdev notifier acquires the same lock.

The issue is demonstrated by the following script, reported by Matteo:

ip -b - <<'EOF'
	link add type dummy
	link add type veth
	link set dummy0 up
EOF
modprobe pktgen
echo reset >/proc/net/pktgen/pgctrl
{
	echo rem_device_all
	echo add_device dummy0
} >/proc/net/pktgen/kpktgend_0
echo count 0 >/proc/net/pktgen/dummy0
echo start >/proc/net/pktgen/pgctrl &
sleep 1
rmmod veth

Fix the above releasing the thread lock around the sleep call.
After re-acquiring the lock we must check again for the relevant
thread existence, as some other pktgen command could have
terminated it meanwhile.

In the caller, we can't continue walking the threads list, for the
same reason. Instead, let's pick the first running thread 'till we
can find any of them.

Note: the issue predates the commit reported in the fixes tag, but
this fix can't be applied before the mentioned commit.

Fixes: 6146e6a43b35 ("[PKTGEN]: Removes thread_{un,}lock() macros.")
Reported-and-tested-by: Matteo Croce <mcroce@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/core/pktgen.c | 38 +++++++++++++++++++++++++++++++++++---
 1 file changed, 35 insertions(+), 3 deletions(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 319ad5490fb3..09ce399986e2 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -3062,20 +3062,49 @@ static int thread_is_running(const struct pktgen_thread *t)
 	return 0;
 }
 
-static int pktgen_wait_thread_run(struct pktgen_thread *t)
+static bool pktgen_lookup_thread(struct pktgen_net *pn, struct pktgen_thread *t)
+{
+	struct pktgen_thread *tmp;
+
+	list_for_each_entry(tmp, &pn->pktgen_threads, th_list)
+		if (tmp == t)
+			return true;
+	return false;
+}
+
+static int pktgen_wait_thread_run(struct pktgen_net *pn,
+				  struct pktgen_thread *t)
 {
 	while (thread_is_running(t)) {
 
+		mutex_unlock(&pktgen_thread_lock);
 		msleep_interruptible(100);
+		mutex_lock(&pktgen_thread_lock);
 
 		if (signal_pending(current))
 			goto signal;
+
+		/* in the meanwhile 't' can be dead, removed, etc, check again
+		 * its existence
+		 */
+		if (!pktgen_lookup_thread(pn, t))
+			break;
 	}
 	return 1;
 signal:
 	return 0;
 }
 
+static struct pktgen_thread *pktgen_find_first_running(struct pktgen_net *pn)
+{
+	struct pktgen_thread *t;
+
+	list_for_each_entry(t, &pn->pktgen_threads, th_list)
+		if (thread_is_running(t))
+			return t;
+	return NULL;
+}
+
 static int pktgen_wait_all_threads_run(struct pktgen_net *pn)
 {
 	struct pktgen_thread *t;
@@ -3083,8 +3112,11 @@ static int pktgen_wait_all_threads_run(struct pktgen_net *pn)
 
 	mutex_lock(&pktgen_thread_lock);
 
-	list_for_each_entry(t, &pn->pktgen_threads, th_list) {
-		sig = pktgen_wait_thread_run(t);
+	while (1) {
+		t = pktgen_find_first_running(pn);
+		if (!t)
+			break;
+		sig = pktgen_wait_thread_run(pn, t);
 		if (sig == 0)
 			break;
 	}
-- 
2.20.1

