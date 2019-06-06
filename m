Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73ABD37597
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 15:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728207AbfFFNqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 09:46:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49818 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727133AbfFFNqA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 09:46:00 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5E0AB7E428;
        Thu,  6 Jun 2019 13:45:55 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.32.181.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D18868422;
        Thu,  6 Jun 2019 13:45:53 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, mcroce@redhat.com
Subject: [PATCH net v2] pktgen: do not sleep with the thread lock held.
Date:   Thu,  6 Jun 2019 15:45:03 +0200
Message-Id: <011e3de13ea55a66d55024b5555cefd9dd8ec4c3.1559828069.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 06 Jun 2019 13:46:00 +0000 (UTC)
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

Additionally we must prevent racing with forcefull rmmod - as the
thread lock no more protects from them. Instead, acquire a self-reference
before waiting for any thread. As a side effect, running

rmmod pktgen

while some thread is running now fails with "module in use" error,
before this patch such command hanged indefinitely.

Note: the issue predates the commit reported in the fixes tag, but
this fix can't be applied before the mentioned commit.

v1 -> v2:
 - no need to check for thread existence after flipping the lock,
   pktgen threads are freed only at net exit time
 -

Fixes: 6146e6a43b35 ("[PKTGEN]: Removes thread_{un,}lock() macros.")
Reported-and-tested-by: Matteo Croce <mcroce@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/core/pktgen.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 319ad5490fb3..a33d03c05ed6 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -3066,7 +3066,13 @@ static int pktgen_wait_thread_run(struct pktgen_thread *t)
 {
 	while (thread_is_running(t)) {
 
+		/* note: 't' will still be around even after the unlock/lock
+		 * cycle because pktgen_thread threads are only cleared at
+		 * net exit
+		 */
+		mutex_unlock(&pktgen_thread_lock);
 		msleep_interruptible(100);
+		mutex_lock(&pktgen_thread_lock);
 
 		if (signal_pending(current))
 			goto signal;
@@ -3081,6 +3087,10 @@ static int pktgen_wait_all_threads_run(struct pktgen_net *pn)
 	struct pktgen_thread *t;
 	int sig = 1;
 
+	/* prevent from racing with rmmod */
+	if (!try_module_get(THIS_MODULE))
+		return sig;
+
 	mutex_lock(&pktgen_thread_lock);
 
 	list_for_each_entry(t, &pn->pktgen_threads, th_list) {
@@ -3094,6 +3104,7 @@ static int pktgen_wait_all_threads_run(struct pktgen_net *pn)
 			t->control |= (T_STOP);
 
 	mutex_unlock(&pktgen_thread_lock);
+	module_put(THIS_MODULE);
 	return sig;
 }
 
-- 
2.20.1

