Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A8A405667
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359677AbhIINTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 09:19:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:54080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358827AbhIINJo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 09:09:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DD30632B9;
        Thu,  9 Sep 2021 12:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188874;
        bh=szX6G5SkYjqrpSOViwJuOIG2sbRiHaH5KfPb32e85l0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RssiTH08SVxX1G+aPdtylFr3HW+Y6CeRlqv+1xrBTD7vqD+XZGS5sC5Yf903KuoX1
         UE3+8Lcbbonmh0G5i77VCXHUyrlBlKGSslnoR9ZH6MBpGbChhMGl8424uRn9cLcimK
         RZP7Vj4EGHDbtJtNzx6Mh2P3P2mPyTEINbK8IfbaVrLDLFOg1e8XfKsmZEPQ4AxWHk
         YTWPRL8Sedt5L9rF+y5u1oUf2O3Jz7gHv17qSXlr8BjgnDMnnEZfiGPDQjXXwmTykj
         xl8UTiv4f/YEpRTKuakhiVEkLTXWYLSb9sQCdcU7BEBSEJmsTZe+nxVN4A1RSSJAlx
         G95NrlyfMK8Vw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?=E7=8E=8B=E8=B4=87?= <yun.wang@linux.alibaba.com>,
        Abaci <abaci@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 47/48] net: fix NULL pointer reference in cipso_v4_doi_free
Date:   Thu,  9 Sep 2021 08:00:14 -0400
Message-Id: <20210909120015.150411-47-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909120015.150411-1-sashal@kernel.org>
References: <20210909120015.150411-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: 王贇 <yun.wang@linux.alibaba.com>

[ Upstream commit 733c99ee8be9a1410287cdbb943887365e83b2d6 ]

In netlbl_cipsov4_add_std() when 'doi_def->map.std' alloc
failed, we sometime observe panic:

  BUG: kernel NULL pointer dereference, address:
  ...
  RIP: 0010:cipso_v4_doi_free+0x3a/0x80
  ...
  Call Trace:
   netlbl_cipsov4_add_std+0xf4/0x8c0
   netlbl_cipsov4_add+0x13f/0x1b0
   genl_family_rcv_msg_doit.isra.15+0x132/0x170
   genl_rcv_msg+0x125/0x240

This is because in cipso_v4_doi_free() there is no check
on 'doi_def->map.std' when 'doi_def->type' equal 1, which
is possibe, since netlbl_cipsov4_add_std() haven't initialize
it before alloc 'doi_def->map.std'.

This patch just add the check to prevent panic happen for similar
cases.

Reported-by: Abaci <abaci@linux.alibaba.com>
Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlabel/netlabel_cipso_v4.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netlabel/netlabel_cipso_v4.c b/net/netlabel/netlabel_cipso_v4.c
index 7fd1104ba900..d17a8f3d3387 100644
--- a/net/netlabel/netlabel_cipso_v4.c
+++ b/net/netlabel/netlabel_cipso_v4.c
@@ -163,8 +163,8 @@ static int netlbl_cipsov4_add_std(struct genl_info *info,
 		return -ENOMEM;
 	doi_def->map.std = kzalloc(sizeof(*doi_def->map.std), GFP_KERNEL);
 	if (doi_def->map.std == NULL) {
-		ret_val = -ENOMEM;
-		goto add_std_failure;
+		kfree(doi_def);
+		return -ENOMEM;
 	}
 	doi_def->type = CIPSO_V4_MAP_TRANS;
 
-- 
2.30.2

