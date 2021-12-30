Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34C8E481CDB
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 15:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239865AbhL3OM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 09:12:59 -0500
Received: from lizzy.crudebyte.com ([91.194.90.13]:54907 "EHLO
        lizzy.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239876AbhL3OM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 09:12:56 -0500
X-Greylist: delayed 2530 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Dec 2021 09:12:56 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:References:In-Reply-To:
        Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version:Content-ID:
        Content-Description; bh=HRgmsvyQc5R1HqZKiatrCeJDIA/6CkbTdpYiY2zKJhY=; b=hTnCe
        o1Whg/tS14T1EiCLIom1oN1Ymow2h360wlmsCPKFdW1o/E5jptO/jc3ghECy5x4oQTjfcjE9V3rNi
        0XAFV6+W5SrHqQ6aJQYfrKplD83GIyH4bYiuyYW+tjOuslK4OJ9ydyS6dCF/51Rb0L7qFvSU6wEaN
        3LAjPKYsozzUVWObI3ORKU1/0FC2rLvt25DSnFm7pifvUqvG6/L0hynnnQas04uFC3s9IMPYR67h0
        Cki9svDG1l1vps8GsTZj27pUZdMuIFL8QeQebWepy/AH2b//jwyskrQghftOFaBxUc3FC/0zjZ8sY
        40+ogM7lMXi3lpZWsGjpSmHcM3U5g==;
Message-Id: <fcf4aeac8e33bff5580b4841165739352498013d.1640870037.git.linux_oss@crudebyte.com>
In-Reply-To: <cover.1640870037.git.linux_oss@crudebyte.com>
References: <cover.1640870037.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Thu, 30 Dec 2021 14:23:18 +0100
Subject: [PATCH v4 05/12] net/9p: add trans_maxsize to struct p9_client
To:     v9fs-developer@lists.sourceforge.net
Cc:     netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>,
        Nikolay Kichukov <nikolay@oldum.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This new field 'trans_maxsize' optionally allows transport to
update it to reflect the actual maximum msize supported by
allocated transport channel.

Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
---
 include/net/9p/client.h |  2 ++
 net/9p/client.c         | 12 ++++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index ec1d1706f43c..f5718057fca4 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -87,6 +87,7 @@ struct p9_req_t {
  * struct p9_client - per client instance state
  * @lock: protect @fids and @reqs
  * @msize: maximum data size negotiated by protocol
+ * @trans_maxsize: actual maximum msize supported by transport channel
  * @proto_version: 9P protocol version to use
  * @trans_mod: module API instantiated with this client
  * @status: connection state
@@ -101,6 +102,7 @@ struct p9_req_t {
 struct p9_client {
 	spinlock_t lock;
 	unsigned int msize;
+	unsigned int trans_maxsize;
 	unsigned char proto_version;
 	struct p9_trans_module *trans_mod;
 	enum p9_trans_status status;
diff --git a/net/9p/client.c b/net/9p/client.c
index 8bba0d9cf975..20054addd81b 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1031,6 +1031,14 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 		goto free_client;
 	}
 
+	/*
+	 * transport will get a chance to increase trans_maxsize (if
+	 * necessary) and it may update trans_maxsize in create() function
+	 * below accordingly to reflect the actual maximum size supported by
+	 * the allocated transport channel
+	 */
+	clnt->trans_maxsize = clnt->trans_mod->maxsize;
+
 	p9_debug(P9_DEBUG_MUX, "clnt %p trans %p msize %d protocol %d\n",
 		 clnt, clnt->trans_mod, clnt->msize, clnt->proto_version);
 
@@ -1038,8 +1046,8 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 	if (err)
 		goto put_trans;
 
-	if (clnt->msize > clnt->trans_mod->maxsize) {
-		clnt->msize = clnt->trans_mod->maxsize;
+	if (clnt->msize > clnt->trans_maxsize) {
+		clnt->msize = clnt->trans_maxsize;
 		pr_info("Limiting 'msize' to %d as this is the maximum "
 			"supported by transport %s\n",
 			clnt->msize, clnt->trans_mod->name
-- 
2.30.2

