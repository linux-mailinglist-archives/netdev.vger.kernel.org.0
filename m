Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E80B5927C3
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 04:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbiHOCZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 22:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiHOCZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 22:25:11 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1D81180E
        for <netdev@vger.kernel.org>; Sun, 14 Aug 2022 19:25:09 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id m2so5329460pls.4
        for <netdev@vger.kernel.org>; Sun, 14 Aug 2022 19:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=mNR9lYtfL2bKL7qVCrno1CdLLHFaDLR8vOJa4qM/a/o=;
        b=bhEdszPr6Rc0k6WQaeSKV8B5wF0QckO+6w/ZCxPohu13QDaBdjQ2v+hfOKc3ERwFgu
         whFjGS1oEUqqnjpbTriEs7Ylml9GU67B/D9CIVU1BkKzOsQxyaCzCtR4gD6AjWVA6NE6
         Mtb3FI9G4Z2HpkLTGyskLmUPlIML2Ie4+INcKQZj9GY8h9S888cHo4yGjrjS1ACtamSt
         i9J7IIdB8k9y/s0entG8Ct3MoopFl2EEuHFVAWr9BvwoqGTXYSdAP9dunu5lW1Xgd8JG
         dnBoxKVOLUR0Re04JnbFCl0Xnz4J9YM2GKvvCwOgkvw6PhLk/qHJr3Ioj4uzbxtspTnC
         Uebw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=mNR9lYtfL2bKL7qVCrno1CdLLHFaDLR8vOJa4qM/a/o=;
        b=YPOJZcNvyDIvg+354fC30AjuAPbjdrOMDOo7VUSDLWWi2l02WLIsp68XtN7/WUMJBA
         xBGfJDDFA6w7Xu1oSuSubjM5nLoPZYOaITW6ez7O0WwFDKoUWhiCmhGdGtIRQsZzv8Dg
         m4R20qjvyOZFistVu2efzBAY9gCP1bWE+oNLpVifuoXJMSLynNMg/08XAmkBHxVqRPr1
         ppAo3wWVRecEmcXRWYo1n/VBypQm7aJ854mv2HKlh6ZU/H8kdF06JNzM9BlirukKkajt
         0uCp8YZ+eevdZj4V1Uwi7ztgxBTytKdp0fv83rnQJMa9piOGeskZoanP15qkUIoLNIrG
         yaQQ==
X-Gm-Message-State: ACgBeo1YyhMnV57AQKEg4vSyQ1AQC1ERYYW8ZsJfa8ytwinHXF2KwEvM
        dwaCnesDKwi7wcDI0p0YRMvOMJIYFylJuQ==
X-Google-Smtp-Source: AA6agR57QHLppOZzqZvJ0FadChQukPr7GBLNs41AEDUFXTDkVr2lN7Ux3nfWtpc23+kZgTr7igERxQ==
X-Received: by 2002:a17:90b:e12:b0:1f7:68e9:2da4 with SMTP id ge18-20020a17090b0e1200b001f768e92da4mr15532660pjb.245.1660530309214;
        Sun, 14 Aug 2022 19:25:09 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id 143-20020a630595000000b004296719538esm500252pgf.40.2022.08.14.19.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Aug 2022 19:25:08 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2] vdpa: fix statistics API mismatch
Date:   Sun, 14 Aug 2022 19:25:05 -0700
Message-Id: <20220815022505.13839-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The final vdpa.h header from upstream has slightly different
definition of VDPA stats get, causing compilation failure.

Fixes: 6f97e9c9337b ("vdpa: Add support for reading vdpa device statistics")
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 vdpa/vdpa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
index 6ded1030273b..b73e40b4b695 100644
--- a/vdpa/vdpa.c
+++ b/vdpa/vdpa.c
@@ -949,7 +949,7 @@ static int cmd_dev_vstats_show(struct vdpa *vdpa, int argc, char **argv)
 		return -EINVAL;
 	}
 
-	nlh = mnlu_gen_socket_cmd_prepare(&vdpa->nlg, VDPA_CMD_DEV_STATS_GET,
+	nlh = mnlu_gen_socket_cmd_prepare(&vdpa->nlg, VDPA_CMD_DEV_VSTATS_GET,
 					  flags);
 
 	err = vdpa_argv_parse_put(nlh, vdpa, argc, argv,
-- 
2.35.1

