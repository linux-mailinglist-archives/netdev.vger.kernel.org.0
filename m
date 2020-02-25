Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7937C16B692
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 01:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgBYART (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 19:17:19 -0500
Received: from gateway30.websitewelcome.com ([192.185.196.18]:47448 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728011AbgBYARS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 19:17:18 -0500
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id 91E5A1133F
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 18:15:39 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 6NsxjOiU1XVkQ6NsxjkK2i; Mon, 24 Feb 2020 18:15:39 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LktvCqqFjAA8rDcg5ByaBgBcVMdxrLSTLQa6siIf2JM=; b=pKNLiHChSa57IuH8C+BZVIHDFS
        aqbfjtyx0N/KX80jSPbfkyRg3Kinl606snDgyjpldW8hmNoGBylzcyC9KOsfjUIKxIefbEGCd9ezj
        Kl5Idd37G/ZU8bkfgspAK2mDX9BnKt8C5dz5dlb2r8Yd4vYzw9OmQpJ3tU7FpbyShJE4cckTcv8ih
        nZT1ZJ/IB9WvZukUDk3L2F+yBsQo5FTDiSe8YUPrbtxJ8MJItPPBKITxL5CjXKS1WFyYpIkzk9aA6
        B5UpSthtpvXbRx7eD6dDTqAOr+7jL7HsMPuy96HZIctLtVeXLxe39J9IpZThqS7L7H40lsrbg/8wp
        06nIXcjg==;
Received: from [201.166.191.14] (port=54580 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j6Nsv-002Rza-GF; Mon, 24 Feb 2020 18:15:38 -0600
Date:   Mon, 24 Feb 2020 18:18:26 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Parvi Kaustubhi <pkaustub@cisco.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] net: cisco: Replace zero-length array with
 flexible-array member
Message-ID: <20200225001826.GA22765@embeddedor>
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
X-Source-IP: 201.166.191.14
X-Source-L: No
X-Exim-ID: 1j6Nsv-002Rza-GF
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.166.191.14]:54580
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 31
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

Lastly, fix the following checkpatch warning:
CHECK: Prefer kernel type 'u32' over 'u_int32_t'
#61: FILE: drivers/net/ethernet/cisco/enic/vnic_devcmd.h:653:
+	u_int32_t val[];

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/ethernet/cisco/enic/vnic_devcmd.h | 8 ++++----
 drivers/net/ethernet/cisco/enic/vnic_vic.h    | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/cisco/enic/vnic_devcmd.h b/drivers/net/ethernet/cisco/enic/vnic_devcmd.h
index fef5a0a0663d..fcc4a3ccdd94 100644
--- a/drivers/net/ethernet/cisco/enic/vnic_devcmd.h
+++ b/drivers/net/ethernet/cisco/enic/vnic_devcmd.h
@@ -541,7 +541,7 @@ struct vnic_devcmd_notify {
 struct vnic_devcmd_provinfo {
 	u8 oui[3];
 	u8 type;
-	u8 data[0];
+	u8 data[];
 };
 
 /* These are used in flags field of different filters to denote
@@ -648,9 +648,9 @@ enum {
 #define FILTER_MAX_BUF_SIZE 100
 
 struct filter_tlv {
-	u_int32_t type;
-	u_int32_t length;
-	u_int32_t val[0];
+	u32 type;
+	u32 length;
+	u32 val[];
 };
 
 enum {
diff --git a/drivers/net/ethernet/cisco/enic/vnic_vic.h b/drivers/net/ethernet/cisco/enic/vnic_vic.h
index 9ef81f148351..057776908828 100644
--- a/drivers/net/ethernet/cisco/enic/vnic_vic.h
+++ b/drivers/net/ethernet/cisco/enic/vnic_vic.h
@@ -59,7 +59,7 @@ struct vic_provinfo {
 		u16 type;
 		u16 length;
 		u8 value[0];
-	} tlv[0];
+	} tlv[];
 } __packed;
 
 #define VIC_PROVINFO_ADD_TLV(vp, tlvtype, tlvlen, data) \
-- 
2.25.0

