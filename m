Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A36944E74BD
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 15:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359258AbiCYOGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 10:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359257AbiCYOGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 10:06:32 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9BB5D8F48
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 07:04:57 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id r7so9915502wrc.0
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 07:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/Nv9j1e4+IUpQrNAPBL9SKDMzyA/AU6XhoGzvZ4sFzY=;
        b=SPrtQCcMqgzJTwdsDPLBcBPWVT3nB5H5ZXb8GGCy+oaYgzbFW5cU7jok4OpZWAwm+4
         OyEjd/uhpV5C4P/cT/iPa2wR/fN2VMTRByg3VJeNZjRUtjAsycDZh7GCj4WESx9bT6Kp
         f6ERyJoUhDX6h0KL0SqyMHVE2wIt+nCixbY8hUBCZJx4YVeO0PRmTYS0kUBu6IVfNPLT
         Cxt89UJTFxKk9OuCWFQRId7rGUNVsJFDLHAY+03QN2XT0xAT07tM5fTC9GGXJb0KUpSn
         vtz/S7cNimKrDQR/TaPIvtG+uvuKn9CL022Pnc53odCvP5ZWZq/JuVx0xpF9EM/59DzH
         8G1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/Nv9j1e4+IUpQrNAPBL9SKDMzyA/AU6XhoGzvZ4sFzY=;
        b=CCOaaoQWV0j+SnV2pEXaPZhUGB7dzyOSxgU9CCKoktR8h53nns0k2700PzqFgBbaAc
         XK8frtHbbBlGm57B/iRiXCGUEA+GXRJujW500Y7oqWJ/iQmd6QsnDFUmdDJ33iaAXASb
         s/XIyE1+vjDhSGgIgm8xiMd7isZtCh3VTyIGkcJP+GJQFc5sRbSKsE6/h6jxG/dRdTmz
         EMmaCRHJ9MHDu1OvQuiYqZR/EXNmC1LsVsZCETWq/sy1naSIqV4Yg5YmLS2CmYuRC4yw
         5tf+GFn/VItD53eyzZC57mA83197iRo2OMxdgaWut6FPt9pehzEaJkHzOVHM1qNt4HL9
         QeBg==
X-Gm-Message-State: AOAM532GAyt9T533LY+YjVuwzcsHfoAjqstZjbNcSrw5iPiTvaxt4OKJ
        BPtnX1E5e/eXRZgYF3rQcSkhSSiE1afHkg==
X-Google-Smtp-Source: ABdhPJwQbqQ9FiF/nP0DA/h9UtBxy3aIsPOkxKlnHke76yQrdqMFCyCGIAgHv9OuG249apV/XRG3Dw==
X-Received: by 2002:a5d:64ed:0:b0:205:9805:1e0a with SMTP id g13-20020a5d64ed000000b0020598051e0amr7382318wri.362.1648217096458;
        Fri, 25 Mar 2022 07:04:56 -0700 (PDT)
Received: from gojira.dev.6wind.com ([185.13.181.2])
        by smtp.gmail.com with ESMTPSA id o8-20020a5d6488000000b002051f1028f6sm6347642wri.111.2022.03.25.07.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 07:04:56 -0700 (PDT)
From:   Olivier Matz <olivier.matz@6wind.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, stable@vger.kernel.org,
        Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net 1/2] ixgbe: fix bcast packets Rx on VF after promisc removal
Date:   Fri, 25 Mar 2022 15:02:49 +0100
Message-Id: <20220325140250.21663-2-olivier.matz@6wind.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220325140250.21663-1-olivier.matz@6wind.com>
References: <20220325140250.21663-1-olivier.matz@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After a VF requested to remove the promiscuous flag on an interface, the
broadcast packets are not received anymore. This breaks some protocols
like ARP.

In ixgbe_update_vf_xcast_mode(), we should keep the IXGBE_VMOLR_BAM
bit (Broadcast Accept) on promiscuous removal.

This flag is already set by default in ixgbe_set_vmolr() on VF reset.

Fixes: 8443c1a4b192 ("ixgbe, ixgbevf: Add new mbox API xcast mode")
Cc: stable@vger.kernel.org
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Olivier Matz <olivier.matz@6wind.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
index 7f11c0a8e7a9..8d108a78941b 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
@@ -1184,9 +1184,9 @@ static int ixgbe_update_vf_xcast_mode(struct ixgbe_adapter *adapter,
 
 	switch (xcast_mode) {
 	case IXGBEVF_XCAST_MODE_NONE:
-		disable = IXGBE_VMOLR_BAM | IXGBE_VMOLR_ROMPE |
+		disable = IXGBE_VMOLR_ROMPE |
 			  IXGBE_VMOLR_MPE | IXGBE_VMOLR_UPE | IXGBE_VMOLR_VPE;
-		enable = 0;
+		enable = IXGBE_VMOLR_BAM;
 		break;
 	case IXGBEVF_XCAST_MODE_MULTI:
 		disable = IXGBE_VMOLR_MPE | IXGBE_VMOLR_UPE | IXGBE_VMOLR_VPE;
-- 
2.30.2

