Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E580175A9C
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 13:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbgCBMfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 07:35:10 -0500
Received: from gateway23.websitewelcome.com ([192.185.47.80]:12127 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727519AbgCBMfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 07:35:10 -0500
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 5A7C724FCC
        for <netdev@vger.kernel.org>; Mon,  2 Mar 2020 06:25:26 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 8k8UjzGFBEfyq8k8Uj3qXd; Mon, 02 Mar 2020 06:25:26 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tmrBVwLF1GrBgphU2OaUU3NzXEY7Y/RAayCavGXGVGQ=; b=qz6i/Gf6gzF9Rkyk5oV4G6UY5L
        9sZXGU2DwebYfe2FbT2Cj+HtAoGeyltfzNE1fC6vNSX4bAVUVMdBCnnBzfIqRkbgYpyA1/YfZgXvB
        G4Ogb1LHC/+TknvTiat+IjgId8UVeV1Y3ebxibbHV4z9ExXNr7AAzc58ZmiDKCN5saaJshi11/LHe
        r6cStESS3nNpT1nYm8AMUCTCwpPKjDn+PxbfRLdTnmjqVFs25/sSjDJkXjzeMhDzxoyS24EUYGpAQ
        EroyvBqaXgRXacXBSdrD5bW4KN3a+jwEVyoxwoD5SPovTNts5+k8dPrnnwhOSuddRuFc+NR+H0ZV8
        I8+7RZ+w==;
Received: from [201.162.161.240] (port=42570 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j8k8S-004BHO-Md; Mon, 02 Mar 2020 06:25:24 -0600
Date:   Mon, 2 Mar 2020 06:28:26 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] tehuti: Replace zero-length array with flexible-array
 member
Message-ID: <20200302122826.GA2300@embeddedor>
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
X-Source-IP: 201.162.161.240
X-Source-L: No
X-Exim-ID: 1j8k8S-004BHO-Md
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.162.161.240]:42570
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 32
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
 drivers/net/ethernet/tehuti/tehuti.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/tehuti/tehuti.h b/drivers/net/ethernet/tehuti/tehuti.h
index 5fc03c8eba0c..909e7296cecf 100644
--- a/drivers/net/ethernet/tehuti/tehuti.h
+++ b/drivers/net/ethernet/tehuti/tehuti.h
@@ -330,7 +330,7 @@ struct txd_desc {
 	u16 length;
 	u32 va_lo;
 	u32 va_hi;
-	struct pbl pbl[0];	/* Fragments */
+	struct pbl pbl[];	/* Fragments */
 } __packed;
 
 /* Register region size */
-- 
2.25.0

