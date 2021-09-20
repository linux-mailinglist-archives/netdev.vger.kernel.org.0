Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5935412152
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 20:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357390AbhITSEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 14:04:09 -0400
Received: from lizzy.crudebyte.com ([91.194.90.13]:44745 "EHLO
        lizzy.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356822AbhITSBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 14:01:52 -0400
X-Greylist: delayed 2780 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Sep 2021 14:01:52 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:References:In-Reply-To:
        Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version:Content-ID:
        Content-Description; bh=xGiunjavhziw/hR6JJjI0G+puRHTGyjYNaa0pMUw2PY=; b=E0SOp
        TTlBPScvhXtgv3NiN6z/fuhWAj2TcJHu79KfKD9ub4Uwr7b0mfeGCfK50BLKh+/1mCzKUPGBS20+P
        duxwMaZyukRoKR4L4O+tVDxRMoFkFt7JrmsHxEek59+BK8x7C88riDEt6RJ1QnDA00akrn6c8sPoS
        8BYFLTR4PrIajqVpqi5Jnz93k5K5WwGXSPQbKCwDPOVPaOoYE7zoU7Jp2JX4VG1vNhVNocUSYqeQV
        XaCoCq2x2PdtMbLLW95ZDqI7kekFFusmhnPizp2AQHMrR4qxC68i/Vuwy0AHeLfyShIk49inR0E2R
        xiGu+glS+pNZF+aQsaENUrkE1EsPg==;
Message-Id: <5ddf3d27d79ba6b3c0893099e7fe465d49c05c45.1632156835.git.linux_oss@crudebyte.com>
In-Reply-To: <cover.1632156835.git.linux_oss@crudebyte.com>
References: <cover.1632156835.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Mon, 20 Sep 2021 18:44:07 +0200
Subject: [PATCH v2 5/7] net/9p: add trans_maxsize to struct p9_client
To:     v9fs-developer@lists.sourceforge.net
Cc:     netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
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
index e1c308d8d288..e48c4cdf9be0 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -89,6 +89,7 @@ struct p9_req_t {
  * struct p9_client - per client instance state
  * @lock: protect @fids and @reqs
  * @msize: maximum data size negotiated by protocol
+ * @trans_maxsize: actual maximum msize supported by transport channel
  * @proto_version: 9P protocol version to use
  * @trans_mod: module API instantiated with this client
  * @status: connection state
@@ -103,6 +104,7 @@ struct p9_req_t {
 struct p9_client {
 	spinlock_t lock;
 	unsigned int msize;
+	unsigned int trans_maxsize;
 	unsigned char proto_version;
 	struct p9_trans_module *trans_mod;
 	enum p9_trans_status status;
diff --git a/net/9p/client.c b/net/9p/client.c
index 4f4fd2098a30..a75034fa249b 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1037,6 +1037,14 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
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
 
@@ -1044,8 +1052,8 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
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
2.20.1

