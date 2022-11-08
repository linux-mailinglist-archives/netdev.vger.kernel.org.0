Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7384E62186C
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 16:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbiKHPf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 10:35:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233615AbiKHPfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 10:35:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F7D27CF1
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 07:35:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5620BB81B24
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 15:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E9BC433C1;
        Tue,  8 Nov 2022 15:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667921709;
        bh=9W62wkiBIJwgYm2R3r001PMWs+weWSD+6CSITYOLeJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VFTXH32IHKfUGHlW44qUnG3fGNJNOKpWYHPY5GY/ztMw8tNfVVr/wDrtn1UpFgKhg
         1CdW8baiMcJsEaWVsHtN5Q3kkcG2zPchI+z/7sDQK+6LYpq5DjXgCw/p9XapF1i8dS
         loOSwR2AcxWA9yn4PmCPyP7p5hX5Tu9mfoIfX41U4qHQT3U3aQlamr/xCN1nWxZ2Oe
         j/MBAVBVeiA5ZLF5o1m6AZAsWrGVmdRcEOTGBNB2LaNelq1ATec8FpDKp7+Hq4U8Mk
         UVsty1spw1KjJFSUNWTdq+b2UfnktpZuiPelCNa9IxWaYyNC0Ng4hUJLOj/Aauso1h
         WdD7TWNCEO+FA==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Antoine Tenart <atenart@kernel.org>, sd@queasysnail.net,
        irusskikh@marvell.com, netdev@vger.kernel.org
Subject: [PATCH net 2/2] net: atlantic: macsec: clear encryption keys from the stack
Date:   Tue,  8 Nov 2022 16:34:59 +0100
Message-Id: <20221108153459.811293-3-atenart@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108153459.811293-1-atenart@kernel.org>
References: <20221108153459.811293-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit aaab73f8fba4 ("macsec: clear encryption keys from the stack after
setting up offload") made sure to clean encryption keys from the stack
after setting up offloading, but the atlantic driver made a copy and did
not clear it. Fix this.

[4 Fixes tags below, all part of the same series, no need to split this]

Fixes: 9ff40a751a6f ("net: atlantic: MACSec ingress offload implementation")
Fixes: b8f8a0b7b5cb ("net: atlantic: MACSec ingress offload HW bindings")
Fixes: 27736563ce32 ("net: atlantic: MACSec egress offload implementation")
Fixes: 9d106c6dd81b ("net: atlantic: MACSec egress offload HW bindings")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 .../net/ethernet/aquantia/atlantic/aq_macsec.c |  2 ++
 .../aquantia/atlantic/macsec/macsec_api.c      | 18 +++++++++++-------
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
index a0180811305d..7eb5851eb95d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
@@ -570,6 +570,7 @@ static int aq_update_txsa(struct aq_nic_s *nic, const unsigned int sc_idx,
 
 	ret = aq_mss_set_egress_sakey_record(hw, &key_rec, sa_idx);
 
+	memzero_explicit(&key_rec, sizeof(key_rec));
 	return ret;
 }
 
@@ -899,6 +900,7 @@ static int aq_update_rxsa(struct aq_nic_s *nic, const unsigned int sc_idx,
 
 	ret = aq_mss_set_ingress_sakey_record(hw, &sa_key_record, sa_idx);
 
+	memzero_explicit(&sa_key_record, sizeof(sa_key_record));
 	return ret;
 }
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c b/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c
index 36c7cf05630a..431924959520 100644
--- a/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c
+++ b/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c
@@ -757,6 +757,7 @@ set_ingress_sakey_record(struct aq_hw_s *hw,
 			 u16 table_index)
 {
 	u16 packed_record[18];
+	int ret;
 
 	if (table_index >= NUMROWS_INGRESSSAKEYRECORD)
 		return -EINVAL;
@@ -789,9 +790,12 @@ set_ingress_sakey_record(struct aq_hw_s *hw,
 
 	packed_record[16] = rec->key_len & 0x3;
 
-	return set_raw_ingress_record(hw, packed_record, 18, 2,
-				      ROWOFFSET_INGRESSSAKEYRECORD +
-					      table_index);
+	ret = set_raw_ingress_record(hw, packed_record, 18, 2,
+				     ROWOFFSET_INGRESSSAKEYRECORD +
+				     table_index);
+
+	memzero_explicit(packed_record, sizeof(packed_record));
+	return ret;
 }
 
 int aq_mss_set_ingress_sakey_record(struct aq_hw_s *hw,
@@ -1739,14 +1743,14 @@ static int set_egress_sakey_record(struct aq_hw_s *hw,
 	ret = set_raw_egress_record(hw, packed_record, 8, 2,
 				    ROWOFFSET_EGRESSSAKEYRECORD + table_index);
 	if (unlikely(ret))
-		return ret;
+		goto clear_key;
 	ret = set_raw_egress_record(hw, packed_record + 8, 8, 2,
 				    ROWOFFSET_EGRESSSAKEYRECORD + table_index -
 					    32);
-	if (unlikely(ret))
-		return ret;
 
-	return 0;
+clear_key:
+	memzero_explicit(packed_record, sizeof(packed_record));
+	return ret;
 }
 
 int aq_mss_set_egress_sakey_record(struct aq_hw_s *hw,
-- 
2.38.1

