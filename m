Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0494B5505
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 16:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344557AbiBNPk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 10:40:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231735AbiBNPk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 10:40:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E56BF60A9F
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 07:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644853249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NsyCA1by/ak8R1lwSMjCXJyyH1qXb4V0zf8axMvxNR8=;
        b=XDa3c6ZmWMAXwM4c14Fkr/iSD+nrXszouhLrskeRbxOzm8JT25P3hXd6upWZP1at3Meh9u
        7uauYVEQ9XzwAAppY7FV80N9sDCshOp+sAAB63hxwQ1jMvR/B23ypEwo4bHAZ5tuX6kzF9
        5E37X5NPJD091EqDGDK1tlbIVYhEi1M=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-wrnUdghrO_O6xhldM6M8iw-1; Mon, 14 Feb 2022 10:40:48 -0500
X-MC-Unique: wrnUdghrO_O6xhldM6M8iw-1
Received: by mail-oo1-f70.google.com with SMTP id r12-20020a4aea8c000000b002fd5bc5d365so10807456ooh.18
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 07:40:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NsyCA1by/ak8R1lwSMjCXJyyH1qXb4V0zf8axMvxNR8=;
        b=k7XgA8s4+HtYYCx/gobj+4AHwrkWata1wJzWWGHAjA+JC0Iyh5uggd50GdGNdUKBTD
         Dt/vX5qHhf/ztBMg65LXqjC26q99PTWveh61Tr815eRwB6G4mJsOSalEuOsdpQm/TjdE
         c0OYUwNxRnmEDdJvQqBhKoCGgFqR1spfMrZyXc6Q1WmvuBAX7kE3SMPuyCKVM0N9Oq1c
         7lpvbPwO1maQvY76Wo4Rc7nvB/037UH6T+YTvRnTogiPq/SthLx0K5iVTziXNwbNG1LT
         bC6KzIvNO7s/sH3he1TBUvViFQc/HMYPr0Rv3Br6zozfduX3O579SkR9ZoktKQbk5JQP
         rbyA==
X-Gm-Message-State: AOAM530yisnYbuQWeJfafZBlKOUZBC3rnHpjxTRMpCdM0DD19BccbTKR
        rjATIH6AdNwJ4akhJCSrsSVlw4CADOg2BuQTcHD7YwGy1i9Xh0SjIwEftg8h3qyt1maMg8sEy58
        AKbjyE9T1pCiI2uTZ
X-Received: by 2002:a05:6808:30a0:: with SMTP id bl32mr34570oib.262.1644853248080;
        Mon, 14 Feb 2022 07:40:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyuAZBJGNoWdrA+012X1djizbpdOBot5gLyfgpONhsQ6+8gC+0JtSILPzlYULjoQUEuunFbBw==
X-Received: by 2002:a05:6808:30a0:: with SMTP id bl32mr34562oib.262.1644853247928;
        Mon, 14 Feb 2022 07:40:47 -0800 (PST)
Received: from localhost.localdomain.com (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id n11sm4432445oal.1.2022.02.14.07.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 07:40:47 -0800 (PST)
From:   trix@redhat.com
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, paul.greenwalt@intel.com,
        evan.swanson@intel.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] ice: initialize local variable 'tlv'
Date:   Mon, 14 Feb 2022 07:40:43 -0800
Message-Id: <20220214154043.2891024-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Clang static analysis reports this issues
ice_common.c:5008:21: warning: The left expression of the compound
  assignment is an uninitialized value. The computed value will
  also be garbage
  ldo->phy_type_low |= ((u64)buf << (i * 16));
  ~~~~~~~~~~~~~~~~~ ^

When called from ice_cfg_phy_fec() ldo is the unintialized local
variable tlv.  So initialize.

Fixes: ea78ce4dab05 ("ice: add link lenient and default override support")
Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index c57e5fc41cf8..0e4434e3c290 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -3379,7 +3379,7 @@ ice_cfg_phy_fec(struct ice_port_info *pi, struct ice_aqc_set_phy_cfg_data *cfg,
 
 	if (fec == ICE_FEC_AUTO && ice_fw_supports_link_override(hw) &&
 	    !ice_fw_supports_report_dflt_cfg(hw)) {
-		struct ice_link_default_override_tlv tlv;
+		struct ice_link_default_override_tlv tlv = { 0 };
 
 		status = ice_get_link_default_override(&tlv, pi);
 		if (status)
-- 
2.26.3

