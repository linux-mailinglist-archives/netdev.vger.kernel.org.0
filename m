Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701DE4121E0
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 20:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359866AbhITSKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 14:10:53 -0400
Received: from lizzy.crudebyte.com ([91.194.90.13]:44745 "EHLO
        lizzy.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359287AbhITSJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 14:09:28 -0400
X-Greylist: delayed 3266 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Sep 2021 14:09:27 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:References:In-Reply-To:
        Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version:Content-ID:
        Content-Description; bh=Cqx/q/n6hrY5Ps1ipX2QJFZ34qH2P2+3lxddoYfsBeQ=; b=C8DWS
        nm5XFVvn+wcj0ASjGzbv+8lAnVOswP9JUiYGrqKEZl7EofbEDrjquCBK+LHg/qnxMkpyerTD8gljt
        w0iq+go39AzEL+FG7nw1GnOgkky1be3NVLIaBd3I1j5UKpe1jzArU8fipKWl4uesW88w8kV7WiweR
        wPQ4YzUWyya/YR55ZWDPncRHaPkqHLFpZs9Jb0yeCBLdx5TwuwSEKFDIIN4lPDtBcbvDuVhmD3iJO
        SJbMl/FC9hCQhKPiWgjcmKxMyJZFI+qChrSjiD2loWn5L4tSZ5eWjs3FIDPh7ZtAtdeIFVlUjal4p
        gduFM2dwt1PwABBh1UtKDroLCPs7g==;
Message-Id: <f7b1e09dcc15e91d7172ca91ca7990d39e6bb9de.1632156835.git.linux_oss@crudebyte.com>
In-Reply-To: <cover.1632156835.git.linux_oss@crudebyte.com>
References: <cover.1632156835.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Mon, 20 Sep 2021 18:43:34 +0200
Subject: [PATCH v2 1/7] net/9p: show error message if user 'msize' cannot be
 satisfied
To:     v9fs-developer@lists.sourceforge.net
Cc:     netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If user supplied a large value with the 'msize' option, then
client would silently limit that 'msize' value to the maximum
value supported by transport. That's a bit confusing for users
of not having any indication why the preferred 'msize' value
could not be satisfied.

Reported-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
---
 net/9p/client.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index 213f12ed76cd..4f4fd2098a30 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1044,8 +1044,13 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 	if (err)
 		goto put_trans;
 
-	if (clnt->msize > clnt->trans_mod->maxsize)
+	if (clnt->msize > clnt->trans_mod->maxsize) {
 		clnt->msize = clnt->trans_mod->maxsize;
+		pr_info("Limiting 'msize' to %d as this is the maximum "
+			"supported by transport %s\n",
+			clnt->msize, clnt->trans_mod->name
+		);
+	}
 
 	if (clnt->msize < 4096) {
 		p9_debug(P9_DEBUG_ERROR,
-- 
2.20.1

