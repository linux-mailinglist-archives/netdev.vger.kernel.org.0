Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDFD30BB5A
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 10:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbhBBJsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 04:48:21 -0500
Received: from mga14.intel.com ([192.55.52.115]:6152 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229991AbhBBJrX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 04:47:23 -0500
IronPort-SDR: 4Fyu+IrhxSqPnifDRK/Q3zvPNX2N5xvmh0rIBrJDBjCqXP6mgB4fGGQrMKBYJtkAhCIJjqysqW
 /BuhxIKUcalA==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="180052377"
X-IronPort-AV: E=Sophos;i="5.79,394,1602572400"; 
   d="scan'208";a="180052377"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 01:46:39 -0800
IronPort-SDR: fxRyLiaEZcrflCRdHtzz8PIx1GCvFdNGJhab52XBo3WN03cvyZcjK/pAD1xqVQHwR0WhLJff8E
 uTWLXNLbc5zw==
X-IronPort-AV: E=Sophos;i="5.79,394,1602572400"; 
   d="scan'208";a="391393427"
Received: from shao2-debian.sh.intel.com (HELO localhost) ([10.239.13.11])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 01:46:36 -0800
From:   Rong Chen <rong.a.chen@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>, netdev@vger.kernel.org,
        Rong Chen <rong.a.chen@intel.com>,
        kernel test robot <oliver.sang@intel.com>
Subject: [PATCH] selftests/tls: fix compile errors after adding CHACHA20-POLY1305
Date:   Tue,  2 Feb 2021 17:45:00 +0800
Message-Id: <20210202094500.679761-1-rong.a.chen@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel test robot reported the following errors:

tls.c: In function ‘tls_setup’:
tls.c:136:27: error: storage size of ‘tls12’ isn’t known
  union tls_crypto_context tls12;
                           ^~~~~
tls.c:150:21: error: ‘tls12_crypto_info_chacha20_poly1305’ undeclared (first use in this function)
   tls12_sz = sizeof(tls12_crypto_info_chacha20_poly1305);
                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tls.c:150:21: note: each undeclared identifier is reported only once for each function it appears in
tls.c:153:21: error: ‘tls12_crypto_info_aes_gcm_128’ undeclared (first use in this function)
   tls12_sz = sizeof(tls12_crypto_info_aes_gcm_128);

Fixes: 4f336e88a870 ("selftests/tls: add CHACHA20-POLY1305 to tls selftests")
Reported-by: kernel test robot <oliver.sang@intel.com>
Link: https://lore.kernel.org/lkml/20210108064141.GB3437@xsang-OptiPlex-9020/
Signed-off-by: Rong Chen <rong.a.chen@intel.com>
---
 include/net/tls.h                 | 9 ---------
 include/uapi/linux/tls.h          | 9 +++++++++
 tools/testing/selftests/net/tls.c | 4 ++--
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 3eccb525e8f7..54f7863ad915 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -212,15 +212,6 @@ struct cipher_context {
 	char *rec_seq;
 };
 
-union tls_crypto_context {
-	struct tls_crypto_info info;
-	union {
-		struct tls12_crypto_info_aes_gcm_128 aes_gcm_128;
-		struct tls12_crypto_info_aes_gcm_256 aes_gcm_256;
-		struct tls12_crypto_info_chacha20_poly1305 chacha20_poly1305;
-	};
-};
-
 struct tls_prot_info {
 	u16 version;
 	u16 cipher_type;
diff --git a/include/uapi/linux/tls.h b/include/uapi/linux/tls.h
index 0d54baea1d8d..9933dd425571 100644
--- a/include/uapi/linux/tls.h
+++ b/include/uapi/linux/tls.h
@@ -124,6 +124,15 @@ struct tls12_crypto_info_chacha20_poly1305 {
 	unsigned char rec_seq[TLS_CIPHER_CHACHA20_POLY1305_REC_SEQ_SIZE];
 };
 
+union tls_crypto_context {
+	struct tls_crypto_info info;
+	union {
+		struct tls12_crypto_info_aes_gcm_128 aes_gcm_128;
+		struct tls12_crypto_info_aes_gcm_256 aes_gcm_256;
+		struct tls12_crypto_info_chacha20_poly1305 chacha20_poly1305;
+	};
+};
+
 enum {
 	TLS_INFO_UNSPEC,
 	TLS_INFO_VERSION,
diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index e0088c2d38a5..6951c8524a27 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -147,10 +147,10 @@ FIXTURE_SETUP(tls)
 	tls12.info.cipher_type = variant->cipher_type;
 	switch (variant->cipher_type) {
 	case TLS_CIPHER_CHACHA20_POLY1305:
-		tls12_sz = sizeof(tls12_crypto_info_chacha20_poly1305);
+		tls12_sz = sizeof(struct tls12_crypto_info_chacha20_poly1305);
 		break;
 	case TLS_CIPHER_AES_GCM_128:
-		tls12_sz = sizeof(tls12_crypto_info_aes_gcm_128);
+		tls12_sz = sizeof(struct tls12_crypto_info_aes_gcm_128);
 		break;
 	default:
 		tls12_sz = 0;
-- 
2.20.1

