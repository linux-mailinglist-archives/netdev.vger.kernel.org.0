Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6A9AFFD7
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 17:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728522AbfIKPVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 11:21:49 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35433 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727581AbfIKPVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 11:21:49 -0400
Received: by mail-wr1-f68.google.com with SMTP id g7so25109921wrx.2
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 08:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=wM/fE7uLX2CbNn9bWyqVffeZcPFxspNS8yhmNj/vLt8=;
        b=K6UVDsBqTG1qruaj1mGWDZSDurRAtURtx2LEEB0Tz5AULUKmKVLsJAYqp4pqiygGlP
         vHLc1mWQXmOUZFB0OcmpO9EGHBPuksH7GFEsbUm7tSvTTeGRSP1WAQlmkjYou0Ls0Qwz
         h4SL3q45RehUT8w0L7YlU952ZnP+Z3HbAMVhTlmQ5KQn5HJx8JU28Vew/5fHv3wDKLkM
         Cikd2NK+9PUUIIaxnzfMahr1iMh4pIMsA/7zxXca6G+T4f6q1GHCUgeKGB+OZQoLyaVs
         MpjREzw8JaL9XtO7qjuV5815uxy72hfS29kpSnTerpOol3K0IemLjJGpMt/Slz43nSXt
         YbqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wM/fE7uLX2CbNn9bWyqVffeZcPFxspNS8yhmNj/vLt8=;
        b=oqqFhjevfMWMuZ3ymT/ut3xY27hhVmdNmMfrEJExcFPUgTTKsmx2EQy7Kf/Lhup+sT
         dUqS+EQfsU/dPUPui36MU8DVXjktV6NP05NksWvIoD/pfy/tfJGAuXMCZ1SLcYdMDjiS
         uGTyraG0QMX7iWVsHTtyMMzkpZLeEfWzLZMcbWfQ8W+mo16rz5Kua4Y3ZwZF4SHi2Ub0
         GKBc15Q3AAzV0R6iUaIyqZig31NEthko+8v5BPipIygn6N0EqbEF5j7wivPJycJ+SQYm
         1l7XI3s0FMYOXm7iuJt7UgvYiyyGXE+SXV6zsyNs0Y/zIAF5Q9L8GmflS29v+qW4/xxe
         4mKQ==
X-Gm-Message-State: APjAAAUlEEIFbzsfOiFBTN+VhH73makfrrGEXO2kjM2uSCCsqlxA9bra
        DHrC7FWKQHlk7NCJe6Tgin1Y5w==
X-Google-Smtp-Source: APXvYqwzNvxvyDwZCwm3mqyIr/4SGMHQHtFG9Bn0TEREpInH9QB9V8FfT+SR24rZ1j+uDkvgkJIRAQ==
X-Received: by 2002:a5d:4b46:: with SMTP id w6mr22217828wrs.223.1568215306891;
        Wed, 11 Sep 2019 08:21:46 -0700 (PDT)
Received: from penelope.horms.nl ([148.69.85.38])
        by smtp.gmail.com with ESMTPSA id r17sm20556858wrt.68.2019.09.11.08.21.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 08:21:45 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next] nfp: read chip model from the PluDevice register
Date:   Wed, 11 Sep 2019 16:21:18 +0100
Message-Id: <20190911152118.30698-1-simon.horman@netronome.com>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

The PluDevice register provides the authoritative chip model/revision.

Since the model number is purely used for reporting purposes, follow
the hardware team convention of subtracting 0x10 from the PluDevice
register to obtain the chip model/revision number.

Suggested-by: Francois H. Theron <francois.theron@netronome.com>
Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cpplib.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cpplib.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cpplib.c
index 3cfecf105bde..85734c6badf5 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cpplib.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cpplib.c
@@ -24,8 +24,9 @@
 /* NFP6000 PL */
 #define NFP_PL_DEVICE_ID			0x00000004
 #define   NFP_PL_DEVICE_ID_MASK			GENMASK(7, 0)
-
-#define NFP6000_ARM_GCSR_SOFTMODEL0		0x00400144
+#define   NFP_PL_DEVICE_PART_MASK		GENMASK(31, 16)
+#define NFP_PL_DEVICE_MODEL_MASK		(NFP_PL_DEVICE_PART_MASK | \
+						 NFP_PL_DEVICE_ID_MASK)
 
 /**
  * nfp_cpp_readl() - Read a u32 word from a CPP location
@@ -120,22 +121,17 @@ int nfp_cpp_writeq(struct nfp_cpp *cpp, u32 cpp_id,
  */
 int nfp_cpp_model_autodetect(struct nfp_cpp *cpp, u32 *model)
 {
-	const u32 arm_id = NFP_CPP_ID(NFP_CPP_TARGET_ARM, 0, 0);
 	u32 reg;
 	int err;
 
-	err = nfp_cpp_readl(cpp, arm_id, NFP6000_ARM_GCSR_SOFTMODEL0, model);
-	if (err < 0)
-		return err;
-
-	/* The PL's PluDeviceID revision code is authoratative */
-	*model &= ~0xff;
 	err = nfp_xpb_readl(cpp, NFP_XPB_DEVICE(1, 1, 16) + NFP_PL_DEVICE_ID,
 			    &reg);
 	if (err < 0)
 		return err;
 
-	*model |= (NFP_PL_DEVICE_ID_MASK & reg) - 0x10;
+	*model = reg & NFP_PL_DEVICE_MODEL_MASK;
+	if (*model & NFP_PL_DEVICE_ID_MASK)
+		*model -= 0x10;
 
 	return 0;
 }
-- 
2.11.0

