Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2EA522F39
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 11:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236591AbiEKJUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 05:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239576AbiEKJUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 05:20:20 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6E69B18F
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 02:20:19 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id cu23-20020a17090afa9700b001d98d8e53b7so3647022pjb.0
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 02:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=VocA58IeyI2uukCAYnVaaxkVzHhnSR0onge4nBYywA0=;
        b=XqBt0TtwzuaJu1nZiOtPdh49FBWJDDoYWZY5kVNyNMaBftTEvlEI3+trcHjyLXe+Gf
         zNTXDW0xtwOq1AVwKN00s0zgWvoUH2oBhgRC9V9ixh8c4fqND+f/Rky4Wpltupz9qUiT
         Skkn7vhhdliUCw9Zeuu7Ozl7EvWH7NLf3n0A3Vmc7EVyA8HfbZr0uyjDGywHOpwrDyXU
         eax65ijUGWyYN4/SuOLe4RsHKdqOSs5fHnQv5MzVyCCeKP9ZHk9PzhmPW3iNQFA6rY5u
         OyGNZMgEG2MbAGtaI+l9oxlRK0Q1tz7qV2KU8W8+w2DVoUyg7JJJF4H+8NLHzqDD+pGP
         9r0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=VocA58IeyI2uukCAYnVaaxkVzHhnSR0onge4nBYywA0=;
        b=CksZY1UOOjPZRJijfkprD9F3tmHd6ICeW4YIzg3SZe0CiImlecGeOHIh8nnVTxKf2W
         1auL4zIElntG8vXtPNhFoerZ1jphAA02Wks/utJXT9XgCIvbJTq7MXjuMMkcXiXBo8JV
         PTnHXtQq+6PYlFvDPXDmGY4/3VxV/9qMsAI9kk9T7OGBqH6JUmYEGvURjLVJCcejQS+q
         BlDvZLJyvbe88IV86yRRQp8Uzl8BpADfU4JQUCNqvps9fzZZZR6gQFF9IPVhkBcoNkFo
         74yoCuRCTNcNcnJaUNgkrc0FXrXEuAXQd8Cns01tFQ0PM0bad6WFzuuVQIlrdUs+yf+E
         /OCw==
X-Gm-Message-State: AOAM532ILpbaONktfhwTr7caPGi22Vn2QiVYxYTLj+tfvZ7mapF6y6RW
        FcO23GDwFcMMCcPxZ3Ymwrc=
X-Google-Smtp-Source: ABdhPJwqZNBxmRZ2CvD/00FfhB10XL9Q7L5+sAevj7huytOPrUDSY+oZEdFhQcKGK4/9si4qDf1Juw==
X-Received: by 2002:a17:903:240c:b0:153:c8df:7207 with SMTP id e12-20020a170903240c00b00153c8df7207mr24186051plo.44.1652260819403;
        Wed, 11 May 2022 02:20:19 -0700 (PDT)
Received: from localhost.localdomain ([23.91.97.158])
        by smtp.gmail.com with ESMTPSA id o10-20020a170903210a00b0015e8d4eb23dsm1229546ple.135.2022.05.11.02.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 02:20:19 -0700 (PDT)
From:   xiaolinkui <xiaolinkui@gmail.com>
X-Google-Original-From: xiaolinkui <xiaolinkui@kylinos.cn>
To:     pmenzel@molgen.mpg.de, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, Linkui Xiao <xiaolinkui@kylinos.cn>
Subject: [PATCH] igb: Convert a series of if statements to switch case
Date:   Wed, 11 May 2022 17:20:04 +0800
Message-Id: <20220511092004.30173-1-xiaolinkui@kylinos.cn>
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

From: Linkui Xiao <xiaolinkui@kylinos.cn>

Convert a series of if statements that handle different events to a switch
case statement to simplify the code.

V2: fix patch description and email format.

Signed-off-by: Linkui Xiao <xiaolinkui@kylinos.cn>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 34b33b21e0dc..4ce0718eeff6 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -4588,13 +4588,17 @@ static inline void igb_set_vf_vlan_strip(struct igb_adapter *adapter,
 	struct e1000_hw *hw = &adapter->hw;
 	u32 val, reg;
 
-	if (hw->mac.type < e1000_82576)
+	switch (hw->mac.type) {
+	case e1000_undefined:
+	case e1000_82575:
 		return;
-
-	if (hw->mac.type == e1000_i350)
+	case e1000_i350:
 		reg = E1000_DVMOLR(vfn);
-	else
+		break;
+	default:
 		reg = E1000_VMOLR(vfn);
+		break;
+	}
 
 	val = rd32(reg);
 	if (enable)
-- 
2.17.1

