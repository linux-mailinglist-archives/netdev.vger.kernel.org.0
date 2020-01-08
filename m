Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E695E134176
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 13:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbgAHMNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 07:13:21 -0500
Received: from mga01.intel.com ([192.55.52.88]:14791 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726252AbgAHMNV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 07:13:21 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2020 04:13:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,409,1571727600"; 
   d="scan'208";a="246327364"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga004.fm.intel.com with ESMTP; 08 Jan 2020 04:13:17 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id E2FA014B; Wed,  8 Jan 2020 14:13:16 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        ocfs2-devel@oss.oracle.com, Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 1/1] ocfs2/dlm: Move BITS_TO_BYTES() to bitops.h for wider use
Date:   Wed,  8 Jan 2020 14:13:16 +0200
Message-Id: <20200108121316.22411-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are users already and will be more of BITS_TO_BYTES() macro.
Move it to bitops.h for wider use.

In the case of ocfs2 the replacement is identical.

As for bnx2x, there are two places where floor version is used.
In the first case to calculate the amount of structures that can fit
one memory page. In this case obviously the ceiling variant is correct and
original code might have a potential bug, if amount of bits % 8 is not 0.
In the second case the macro is used to calculate bytes transmitted in one
microsecond. This will work for all speeds which is multiply of 1Gbps without
any change, for the rest new code will give ceiling value, for instance 100Mbps
will give 13 bytes, while old code gives 12 bytes and the arithmetically
correct one is 12.5 bytes. Further the value is used to setup timer threshold
which in any case has its own margins due to certain resolution. I don't see
here an issue with slightly shifting thresholds for low speed connections, the
card is supposed to utilize highest available rate, which is usually 10Gbps.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Acked-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
---
- Add Ack
- resend as requested by Andrew (Cc'ing him as well)
- should prepend Yuri's series (hope no conflicts, though easy to fix)
base-commit: 7ddd09fc4b745fb1d8942f95389583e08412e0cd (next-20191220)

 drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h | 1 -
 fs/ocfs2/dlm/dlmcommon.h                         | 4 ----
 include/linux/bitops.h                           | 1 +
 3 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h
index 066765fbef06..0a59a09ef82f 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h
@@ -296,7 +296,6 @@ static inline void bnx2x_dcb_config_qm(struct bnx2x *bp, enum cos_mode mode,
  *    possible, the driver should only write the valid vnics into the internal
  *    ram according to the appropriate port mode.
  */
-#define BITS_TO_BYTES(x) ((x)/8)
 
 /* CMNG constants, as derived from system spec calculations */
 
diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index aaf24548b02a..0463dce65bb2 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -688,10 +688,6 @@ struct dlm_begin_reco
 	__be32 pad2;
 };
 
-
-#define BITS_PER_BYTE 8
-#define BITS_TO_BYTES(bits) (((bits)+BITS_PER_BYTE-1)/BITS_PER_BYTE)
-
 struct dlm_query_join_request
 {
 	u8 node_idx;
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index e479067c202c..6c7c4133c25c 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -13,6 +13,7 @@
 
 #define BITS_PER_TYPE(type) (sizeof(type) * BITS_PER_BYTE)
 #define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_TYPE(long))
+#define BITS_TO_BYTES(nr)	DIV_ROUND_UP(nr, BITS_PER_TYPE(char))
 
 extern unsigned int __sw_hweight8(unsigned int w);
 extern unsigned int __sw_hweight16(unsigned int w);

base-commit: 7ddd09fc4b745fb1d8942f95389583e08412e0cd
prerequisite-patch-id: 8c46b63287f964be053ed632f2a46d969997d355
prerequisite-patch-id: f4e7e58f97b8888751046488215a7a685dcc95b6
prerequisite-patch-id: 3915ce7ccc2aff558098fcf25d8e52b5df91a7d1
prerequisite-patch-id: 2f30eabc11e9dc27282f5b27b8055bc0422cf4f1
prerequisite-patch-id: b1424a21c7e4d242d7222686b19a3ac9852f70d3
prerequisite-patch-id: 546242d21e0b3275ce19c417d590c760cffc1e7a
prerequisite-patch-id: cafa11f9ed5e3c097e3201ba6a8562c586fd2582
prerequisite-patch-id: 426e6a9acac90f4af0533e96c8cc5efa550b5c7b
prerequisite-patch-id: 084a1c28a6b02fb4d3745c327f34d5b5bbac9317
prerequisite-patch-id: 2c4f0219d05eb9de76b41aa4ba219520f827c6ad
prerequisite-patch-id: 711fb0ffe8e903684291c2573501cf598e0a5d69
prerequisite-patch-id: d449e74889256c65157523a97e30f4d71b47c140
prerequisite-patch-id: 9bed4a5a30d4cc9960305b16b1a88542bd362fc3
prerequisite-patch-id: c8f5b1df1da5250ad7a27e909ee83958678fbf3d
prerequisite-patch-id: e49955e8470a591ba1a32920368407b8eeb49b84
prerequisite-patch-id: 52086fa30b52c5fa844773023051c056e52b62e5
prerequisite-patch-id: d3987cd14576577c34a20b667b9f0f70baf40282
prerequisite-patch-id: 9910494d95cb01c209d4ed53570206217ab7f6c9
prerequisite-patch-id: d465cb41c42f4058c5da1ee7c055b07c5d96ce99
prerequisite-patch-id: c0d7d0591fa8d4a9e555eb6f45ab684501064277
prerequisite-patch-id: 54bb5fac9b837cfbeeec5e03e06aff23caf5978a
prerequisite-patch-id: 761dd682febe454edcffcf43a0f44729292a27bd
prerequisite-patch-id: 96cd088ad86e4c5b88870e3a301b211d1c9cde89
prerequisite-patch-id: 6531853d54a97753692a39311bfa6df65d4cb9d3
prerequisite-patch-id: 535b317ebc7bb8d8331b76be353592b75e6cc64d
prerequisite-patch-id: 3318c2c0c82b3111769521f50f7716f424897b3f
prerequisite-patch-id: db3fa96489a55d25a0f64add2cf3f3cefa659534
prerequisite-patch-id: 61090c00690a2138d4c1721011d65e9fd2b1cc38
prerequisite-patch-id: 11bc0049783ccb6c81323525efd219178ecfdab8
prerequisite-patch-id: 639e8bf0212078dd96fe9358592d31c22cfebe18
prerequisite-patch-id: 5a48c1cd87c5458e8495b7c00148fcf8fe4fbaee
prerequisite-patch-id: 298de587b3611266560fd0363627cf28aa123ffd
prerequisite-patch-id: 9fc4caf7cce4844174486f91d84ab2b6f7f8494a
prerequisite-patch-id: fa0d16350ea839b8e1896fd6d61d6f2e7413e276
prerequisite-patch-id: 445ecbc737af75d4140efea40ae6e0b0126e75b1
prerequisite-patch-id: 250a47bb62525f422d52f942dd95fea375d80cde
prerequisite-patch-id: 6e2f1a3215d6ca7a31c83f158c015065fc36ea9d
prerequisite-patch-id: 1bfcf5bc5a583a61db57906d40e11f70254dc2ff
prerequisite-patch-id: 9e4e8d1f13b743ebfa2568b9c4bc50febe925a6e
prerequisite-patch-id: c6a46453cf296a6f9f72d586fc0261c910889cf1
prerequisite-patch-id: 9aaf65f1232acb252c82d47fb588badcdc3c5df3
prerequisite-patch-id: 45e9f78620bdcea63bed6308575caaed82da8d66
prerequisite-patch-id: 980447357d87531b2403a17c1e14674bcce9c5a9
prerequisite-patch-id: 354b62bba651c8ec0ab0b00e21e9848c5c849fff
prerequisite-patch-id: 6259439a900d8556e48cbfe51a24c13196cbdfed
prerequisite-patch-id: 437274000542d567d3518a732939565b5c74fcd4
prerequisite-patch-id: 539078a0bfb6001145652a4c0ce2a30f6b8e3128
prerequisite-patch-id: adfbb2fe373f626e7f060ab7d357abc554911ffe
prerequisite-patch-id: aed0c10fa87e9ede8eb354ea1949084060138a8c
prerequisite-patch-id: d1a37752b3091aea0191c549698f22c1344aa064
prerequisite-patch-id: 19b18513c00d0bcc0dcdacf66842be1c58fb2be4
prerequisite-patch-id: fa96d9111dfca6f82c2af092115d4dcb454c9a29
prerequisite-patch-id: c655f03d165b1190317706b6c2e9929234baed2c
prerequisite-patch-id: 0d67e631e04a839ed7c3a209a062af24d3bd0c08
prerequisite-patch-id: 22940d4ae6d1e568060f557e9410b694943490c8
prerequisite-patch-id: a09ed014ab229db10ba30f7c3892fdb408cb61c3
prerequisite-patch-id: 6ca5d7335f589574535331563d7965e170484f01
prerequisite-patch-id: 60823a6a82d2a2bd8e9b8eae670918a27148fead
prerequisite-patch-id: e7dc2bcd6c0d418fbcbe42da2699fba3e537ebcb
prerequisite-patch-id: 7726fdcf47609e43ba55b413737be4cc82afe9b1
prerequisite-patch-id: fe812e1831b58149f7adf23de48365a2954ae3bc
prerequisite-patch-id: f22e58cc59c579fdd23a20f131679674a58e78a7
prerequisite-patch-id: d0242c9c33aa3b0eacfbd556e3194dafcbafc490
prerequisite-patch-id: beacb3ec64dc9712f31590b641f1bfb0fb3284a5
prerequisite-patch-id: 6dcd1f4c5eb15ba76bd26c90704cfc796d209e19
prerequisite-patch-id: 5c53f6dffc7d47c62dfbaa76c041092606d0809d
prerequisite-patch-id: c3ad41a1bdfff661656d49d18d922a12c781135a
prerequisite-patch-id: aec5c401060b4c186c10f22fe7e0dc4281aed8d2
prerequisite-patch-id: 6f0de4ed92c9022d94429f3612bce9a16ab0b114
prerequisite-patch-id: 9fdcf1bd133d3019e956bb4deb931cf2af551bdb
prerequisite-patch-id: 33d2bd29562d07a1610c345d783d545df33ce11b
prerequisite-patch-id: 90bd8ae4ffac5f9ca05cd372138da8475a66ab81
prerequisite-patch-id: 2df7c38b75c82abec437a1b62296f3910db33efc
prerequisite-patch-id: 410a2b543f4be1140ee360af0d7091d3f6815247
prerequisite-patch-id: 4c0581ac30bda9f83f39d5b00f6b7ed55d42f1ae
prerequisite-patch-id: 7db88039be613c02e3150d0e8f5bb7670789f6a1
prerequisite-patch-id: 9c6f9f0534c60da294109ed02e13e2fcf2315a0e
prerequisite-patch-id: da3c18cc5b992e68714ae8cacbc4d45b8ab522de
prerequisite-patch-id: 8a4d6c01907b808bc12520c9d13dfcda0166891c
prerequisite-patch-id: d867005a4a1671d56c0003c48d1f66aa7d403857
prerequisite-patch-id: 237b0bfe258dda31d1089fc5170d3a94d6bb604f
prerequisite-patch-id: 660007eaccbc5f98e2f8f3e9da0723f1c159c430
prerequisite-patch-id: 46120f7232e5a66dc08db473e15fea7b9053edc0
prerequisite-patch-id: 95eb66644e87ebb009521cd8b4201dbb0ce09849
prerequisite-patch-id: 1b3cb7a85b3bdb2de921945d9d80f503bc907bfa
prerequisite-patch-id: 84548c75e7643070fbb058a7d8f8ef00ad138b04
prerequisite-patch-id: 0d938183249fe8ce76fac840c37d249988f89380
prerequisite-patch-id: 245a6261ce8646dc2ae2d66cd7e7e6b1c13243b2
prerequisite-patch-id: 9a9f1c3930fefde9d08efee2fcf7d950e7970a49
prerequisite-patch-id: 8043e900aa7cdf954401dda2cb251ca9a5aa16c5
prerequisite-patch-id: fc89f2721f08ab0f1245d528d70da4788054c9e8
prerequisite-patch-id: 22b3aca902ba8b6b14cb296071b398574019062b
prerequisite-patch-id: 2136aa36a6dcb927128e2dc7f839e848a169d126
prerequisite-patch-id: 69a7efecf0ec8374c211f5f92e2703ec34538701
prerequisite-patch-id: bfd5115d16d329e8a17018b1ebf1d29461cb7e11
prerequisite-patch-id: 69734ff8ba0e90455d139c879354c16661fbea59
prerequisite-patch-id: 21e4496ad6b72e80e77bf542a1c7f1d39683195d
-- 
2.24.1

