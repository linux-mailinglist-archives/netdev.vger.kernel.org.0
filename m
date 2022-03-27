Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AEEF4E8650
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 08:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234620AbiC0Gpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 02:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiC0Gpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 02:45:32 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6326D22E;
        Sat, 26 Mar 2022 23:43:53 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id o3-20020a17090a3d4300b001c6bc749227so12542185pjf.1;
        Sat, 26 Mar 2022 23:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=e8S/Lyqv6Pi/Bg7S559e3B2rX5AZSz5Qk3MEM2LeHrM=;
        b=qLUZbUcbpG+h9aKNF+ZR827zt7SoWtsAEtJHVhRIUvlby5kZQQ2hwh1DV1e2WH/xb6
         Y4uccsA0hdFPel5mZuwbeOoOANygi67MsN8dP2qX4ynJoCxSmtlUT14Z5Inp+M6SNRBR
         oGAG4/gej0/fTo8pW652BYzPLCCL9TdV3kiP8HCTLtOcMyK5FWQdx1AFDvSjSQm2vrTf
         NnvsTLFrMf63Uk57hwv6mFfvjPbxVySLESi/lXDen6mRAMMM/+ybUUev8rFd0dG0RTod
         eS4bdP2WKkPYlmSdOnrag+vfJonraIzaaTVQYpgv0Y7BGSHN1xxkcsRUR765XvEH7OqL
         jCMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=e8S/Lyqv6Pi/Bg7S559e3B2rX5AZSz5Qk3MEM2LeHrM=;
        b=1p5ciskAVHSotJSTcwlFIRtJ16Aq1Aw4fRIj8cgdFex0xafmcj96J+E/VxVdP6XSQb
         qFyNF2SzSvZrmF8REwnAfT7+NPFAme9RALIOAsxX7GbPXKECEDiHc2pKTIROvYSzoyrr
         lm64f/F6sXYTEvq29ztITuQKnOlKfBQzEU4r/LnUeg6vrJdfTV7ifGkEtYLTCOVsvIjc
         DrAwI/U5lJo3nMGKMLBws+C5/Tdko+cmyJeww9fceJWmHy+Dg45ZZ0yANxKZ+r3qqHZi
         oDfzQXfEe3vbopFX3CRpdQkTo0B8biUI/8+0MGqVtjE9WEysQQohe/i2vfF/oqb/x3U0
         pHjw==
X-Gm-Message-State: AOAM530lK17h+HM6z3zlEOkaBAcH4fbnxtLdWl8ZP6G3jPclyFx9AuPy
        F8l7lGJ2Ta6Z/mZq6A7wutU=
X-Google-Smtp-Source: ABdhPJwxW+jGQuknVXQY++N1loHtcJ440DIqeuetFmg2lQ2R9iXwPAi/1v/mkY2Ctju2+R3boNuF3A==
X-Received: by 2002:a17:903:192:b0:151:8df9:6cdb with SMTP id z18-20020a170903019200b001518df96cdbmr20778157plg.20.1648363432913;
        Sat, 26 Mar 2022 23:43:52 -0700 (PDT)
Received: from localhost ([115.220.243.108])
        by smtp.gmail.com with ESMTPSA id l20-20020a056a00141400b004f65cedfb09sm11451945pfu.48.2022.03.26.23.43.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 26 Mar 2022 23:43:52 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     jesse.brandeburg@intel.com
Cc:     anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, victor.raj@intel.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] ice: ice_sched: fix an incorrect NULL check on list iterator
Date:   Sun, 27 Mar 2022 14:43:44 +0800
Message-Id: <20220327064344.7573-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bugs are here:
	if (old_agg_vsi_info)
	if (old_agg_vsi_info && !old_agg_vsi_info->tc_bitmap[0]) {

The list iterator value 'old_agg_vsi_info' will *always* be set
and non-NULL by list_for_each_entry_safe(), so it is incorrect
to assume that the iterator value will be NULL if the list is
empty or no element found (in this case, the check
'if (old_agg_vsi_info)' will always be true unexpectly).

To fix the bug, use a new variable 'iter' as the list iterator,
while use the original variable 'old_agg_vsi_info' as a dedicated
pointer to point to the found element.

Cc: stable@vger.kernel.org
Fixes: 37c592062b16d ("ice: remove the VSI info from previous agg")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 drivers/net/ethernet/intel/ice/ice_sched.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index 7947223536e3..fba524148a09 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -2757,6 +2757,7 @@ ice_sched_assoc_vsi_to_agg(struct ice_port_info *pi, u32 agg_id,
 			   u16 vsi_handle, unsigned long *tc_bitmap)
 {
 	struct ice_sched_agg_vsi_info *agg_vsi_info, *old_agg_vsi_info = NULL;
+	struct ice_sched_agg_vsi_info *iter;
 	struct ice_sched_agg_info *agg_info, *old_agg_info;
 	struct ice_hw *hw = pi->hw;
 	int status = 0;
@@ -2774,11 +2775,13 @@ ice_sched_assoc_vsi_to_agg(struct ice_port_info *pi, u32 agg_id,
 	if (old_agg_info && old_agg_info != agg_info) {
 		struct ice_sched_agg_vsi_info *vtmp;
 
-		list_for_each_entry_safe(old_agg_vsi_info, vtmp,
+		list_for_each_entry_safe(iter, vtmp,
 					 &old_agg_info->agg_vsi_list,
 					 list_entry)
-			if (old_agg_vsi_info->vsi_handle == vsi_handle)
+			if (iter->vsi_handle == vsi_handle) {
+				old_agg_vsi_info = iter;
 				break;
+			}
 	}
 
 	/* check if entry already exist */
-- 
2.17.1

