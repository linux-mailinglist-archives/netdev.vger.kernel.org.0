Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A073176588
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 22:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgCBVBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 16:01:38 -0500
Received: from gateway34.websitewelcome.com ([192.185.149.77]:40926 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725911AbgCBVBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 16:01:38 -0500
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 2F2F19AABDF
        for <netdev@vger.kernel.org>; Mon,  2 Mar 2020 15:01:37 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 8sC1jgHm9vBMd8sC1jb6Fi; Mon, 02 Mar 2020 15:01:37 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=zN3rMtGrk/Zs5GdX97JZqsBoFoWxHWo9zxihuTDfHA0=; b=qbLLolwoTYSiwhnOJDcHHRchiL
        X8Tnxyqk7vYdE/ErRr7J2QChPJTT/FCLEt5Zhl3g5breiKvoIbPjoKG0wqeyfWAgqcn4hoS8XPSBg
        YfI7ZLZnQpDJAKaYtQOkYcx7rmrqPEMx+LKNoB8G9p/1q7TiVEXhslR1w3id/Zkkfvn/+LzJkro2O
        qe3CzdrzteN1gu1PKoS8Kmi7yPj+svFQSC5ZR8TDGQk4kJ5TqnNrx7AyAvX7o5oBcyAHPmka3XsOq
        8/2/Xq/jcnYZp6WL2Ffjn0yRldfDiU3zIOW3qWcH+eiJn7hIYv/mco1DZWUS653vmbxdCoNPjeHmb
        QS1sO7GA==;
Received: from [201.166.169.19] (port=16672 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j8sBz-0004O8-4B; Mon, 02 Mar 2020 15:01:35 -0600
Date:   Mon, 2 Mar 2020 15:04:37 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "mlxsw@mellanox.com David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] net: mlxfw: Replace zero-length array with
 flexible-array member
Message-ID: <20200302210437.GA30285@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 201.166.169.19
X-Source-L: No
X-Exim-ID: 1j8sBz-0004O8-4B
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.166.169.19]:16672
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 2
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2.c     | 2 +-
 drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2_tlv.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2.c b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2.c
index 79057af4fe99..5d9ddf36fb4e 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2.c
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2.c
@@ -496,7 +496,7 @@ mlxfw_mfa2_file_component_tlv_get(const struct mlxfw_mfa2_file *mfa2_file,
 
 struct mlxfw_mfa2_comp_data {
 	struct mlxfw_mfa2_component comp;
-	u8 buff[0];
+	u8 buff[];
 };
 
 static const struct mlxfw_mfa2_tlv_component_descriptor *
diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2_tlv.h b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2_tlv.h
index 33c971190bba..2014a5de5a01 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2_tlv.h
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2_tlv.h
@@ -11,7 +11,7 @@ struct mlxfw_mfa2_tlv {
 	u8 version;
 	u8 type;
 	__be16 len;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 static inline const struct mlxfw_mfa2_tlv *
-- 
2.25.0

