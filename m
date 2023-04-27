Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3E706F04EE
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 13:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243525AbjD0LX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 07:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243485AbjD0LX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 07:23:56 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBC34C00;
        Thu, 27 Apr 2023 04:23:55 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 341F2C020; Thu, 27 Apr 2023 13:23:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1682594634; bh=XE5XD0Y2KMfY2VWjCTGCAbFyRUZoNpeelcS15tqOd2c=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=UTjLPfBEKm3VwuvvVgE8DvyBsgqd8/dGffZZdI6rJy8jINzh1zCXNtBTI2KBCAE1p
         hCSi0r9+hX8SsYKb6VTVRr81KT2ATBRB/gaj4ElMXa4QdUbVaeVm3ptqkoxOc1ASWx
         1jl6igxJvlYtMWnkkquO9qzdm/w3hypBsCiuy/p5d1eLlDEXwoWcgE9rznZ6OpatE7
         g7wldRNwMrEm1Xfk3DfOcZ4lfDNRqnCv/e0rc2PocgQ8f/r8U1Nkuci/SOBfuC65Ye
         EESRhLa5tLmAERAulF2XBykdYTkTjdiAygDjHYqtqalXooIn99fKrytxwbWua08yW7
         MAOhYKJE/4WLA==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 41E5FC022;
        Thu, 27 Apr 2023 13:23:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1682594633; bh=XE5XD0Y2KMfY2VWjCTGCAbFyRUZoNpeelcS15tqOd2c=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=H2wykJYBIe2MyU/j9JHCjTRak3S+WYIII6QDn1/NJVNvyJwoDlcjERlyXJ992v41V
         zbFqJNtQbqufnDnAm3Cg/K3NytYMCar5nO1lG8yrhoZiP3Vb1c+0X7OjRoaaEooD/D
         DFeokklU8RjWnCyqhHMGo1tsxErMtzzYPqXxUH6RKylDCZnvG4rxpaZaAiOTFlhbEU
         fsGxWlbGlvIPb2+oTHTOh1gvJ0URGNtq7cDT2bjpjkxOW7eTG5zKXrVpjsotQkZJcx
         EJfGRyA7J8p9E1jnGhquv0kAJeH+SrKFme28CE1WMerR27WQR1YAyT/p6XPaY7Zqfo
         EidKLs8R8TVcg==
Received: from [127.0.0.2] (localhost [::1])
        by odin.codewreck.org (OpenSMTPD) with ESMTP id 36370512;
        Thu, 27 Apr 2023 11:23:38 +0000 (UTC)
From:   Dominique Martinet <asmadeus@codewreck.org>
Date:   Thu, 27 Apr 2023 20:23:34 +0900
Subject: [PATCH 1/5] 9p: fix ignored return value in v9fs_dir_release
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230427-scan-build-v1-1-efa05d65e2da@codewreck.org>
References: <20230427-scan-build-v1-0-efa05d65e2da@codewreck.org>
In-Reply-To: <20230427-scan-build-v1-0-efa05d65e2da@codewreck.org>
To:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     v9fs@lists.linux.dev, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Dominique Martinet <asmadeus@codewreck.org>
X-Mailer: b4 0.13-dev-f371f
X-Developer-Signature: v=1; a=openpgp-sha256; l=1335;
 i=asmadeus@codewreck.org; h=from:subject:message-id;
 bh=RUrHjm09yOZeR53rq5HPPNCIO2yy4QcgPbGLIejJm5I=;
 b=owEBbQKS/ZANAwAIAatOm+xqmOZwAcsmYgBkSls6SD/j9mD1STx6vrnIP0mSXa6M3O2m5VS+g
 yolZS1hCoqJAjMEAAEIAB0WIQT8g9txgG5a3TOhiE6rTpvsapjmcAUCZEpbOgAKCRCrTpvsapjm
 cPkFD/9/tTKymkW7WrHAmUNNzET2COeBpFW8CxETv/feWu+NQ4/5Y1kssQiC3J/JiPDz2sCSfOv
 hu8eD0TaZNvGcck9w+kx6QowkDpIN+FyQKAuXJvm4ILc4Hy/skXWcScNCpbvy7pJyst6ohfsLny
 LpsdT54rxQcPJ4xFraC6HtsoXCR7W12hUIaJPSRt86oIX6xqMY+OY6kfoY+CFzpD5lm2b9bcq6G
 5qhVUNnbcysV++mqsT0ptTFI/1qIDnOQSMjVwbSu4u03ZgMHpWt5L5a+7OIAdoAcEH195sR7F54
 hd954Oj1wnd25tqvoP16mH8hg9tSvnAaURWB07Ma/r88WC1J+nNPe47i7lxbOV3G2w45JtOewBk
 3YvZWRvT2SxYiOnho1Df85qg5pMtodCaTW+ZNwvYoEU3O6meiCcTm3ld7U/4sPhkLmdInXCLvdX
 6b6VW62YbmaBemTrUprDX/ILMdRkEA/cLBvqQB2enYnjk81ViVvX1MweZcHaIFO2+h2+PRobQPw
 hPPm2EuZYpfvQK1StrrkIXzb2w/2MU1ZWuiKnLeUOYvlxWnvbU6cH+Jgu20aGKfeZULteeU+Iv8
 0/VuJX0DaMV0KRczcmKFTn6NPISsbr4ioKPen3ut/qxjsUx1Tivi0yxRLZhEUloF4kZFk4ViqCG
 5GCE/NbXVsS6wPQ==
X-Developer-Key: i=asmadeus@codewreck.org; a=openpgp;
 fpr=B894379F662089525B3FB1B9333F1F391BBBB00A
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

retval from filemap_fdatawrite was immediately overwritten by the
following p9_fid_put: preserve any error in fdatawrite if there
was any first.

This fixes the following scan-build warning:
fs/9p/vfs_dir.c:220:4: warning: Value stored to 'retval' is never read [deadcode.DeadStores]
                        retval = filemap_fdatawrite(inode->i_mapping);
                        ^        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---
 fs/9p/vfs_dir.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/9p/vfs_dir.c b/fs/9p/vfs_dir.c
index 289b58cb896e..54bb99f12390 100644
--- a/fs/9p/vfs_dir.c
+++ b/fs/9p/vfs_dir.c
@@ -209,7 +209,7 @@ int v9fs_dir_release(struct inode *inode, struct file *filp)
 	struct p9_fid *fid;
 	__le32 version;
 	loff_t i_size;
-	int retval = 0;
+	int retval = 0, put_err;
 
 	fid = filp->private_data;
 	p9_debug(P9_DEBUG_VFS, "inode: %p filp: %p fid: %d\n",
@@ -222,7 +222,8 @@ int v9fs_dir_release(struct inode *inode, struct file *filp)
 		spin_lock(&inode->i_lock);
 		hlist_del(&fid->ilist);
 		spin_unlock(&inode->i_lock);
-		retval = p9_fid_put(fid);
+		put_err = p9_fid_put(fid);
+		retval = retval < 0 ? retval : put_err;
 	}
 
 	if ((filp->f_mode & FMODE_WRITE)) {

-- 
2.39.2

