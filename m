Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99D3C573503
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 13:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235843AbiGMLMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 07:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiGMLMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 07:12:31 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142F0100CC0;
        Wed, 13 Jul 2022 04:12:30 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id z12-20020a17090a7b8c00b001ef84000b8bso3094511pjc.1;
        Wed, 13 Jul 2022 04:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R3j6t7oPeXFLjhrbi+QAqbOvyaU9gHal8+lBJxi7A/4=;
        b=WZwjyI7V5QGyVjGhnpjZJcakRO0bgyFXIRVKSQPFMQ+/4ujxfOCeaMdZbfMAv+pxKy
         5hZ3f9/miomMaMtKILEMVP1rPwhy56itokbXK/CCaZWWNC2DTqxVntJA1bpAlxSPlNsT
         HSKSgllRXQpnZdwO3lPQc9O3fR+dbJADkzIX8L28VzuCihBlx3jLWO50p1Ol3vN1Ztor
         mva7UUaBeb5ACXPXuF3JNGiBjwEY0fCvsxcEJQwpkqlz8KJW5SsBlKT0GMg4LOYxWBVQ
         dcCvTJUD6Nndm5D77TM066auV9OWHY5QX9ZCe8weSi8/CK2Z6xMiIFSiaH9JwhQs7nBF
         NySg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=R3j6t7oPeXFLjhrbi+QAqbOvyaU9gHal8+lBJxi7A/4=;
        b=ZM9iTim788tBtXv5uZ2zvLWrDc1no5vRF3AIeFYtJMEmKOZ13BsIu27v6pkGgYlpsI
         9CV02RKvKUl/AyV3WlEW9XVmr8Fbg5xcEdZ0Q8KOK1GX1depi/YBmqqT7Mzh5OiAzMk4
         q+5h3q7d21XLOl3GG9TqR47/1rCmPvOflef+85kc+1MShqtoHI0FOXAlON1k2Bb0XZrK
         6APYm0Sa+uaU3EuFv4sAH+FjdCJUoq+OFHZUbbyBJNek+mVufGYTXpIESaB9OmPUnON6
         r9jQ1GJ1w+g5zMxMshpERRkp3BlMrRRVERaYN/EkTdzIP0lt+1Q+yl64OHScmSy9AINQ
         1Zpw==
X-Gm-Message-State: AJIora8mUS197Fc0hnNlcybC9jNkmYHh25ddOo4Cnq1f8yo3/vyFPjpy
        whHYMM6GqKTEG9HF8A7gN2w=
X-Google-Smtp-Source: AGRyM1tY6oR3MZL8vQQ11xnmuuzvLUVVQCbxnmjeU5BC+SCjRmiiucPVNo/U9YLkCQvSKmfBPij1cQ==
X-Received: by 2002:a17:902:cec2:b0:16c:3deb:a062 with SMTP id d2-20020a170902cec200b0016c3deba062mr3044222plg.136.1657710749524;
        Wed, 13 Jul 2022 04:12:29 -0700 (PDT)
Received: from localhost (220-135-95-34.hinet-ip.hinet.net. [220.135.95.34])
        by smtp.gmail.com with ESMTPSA id c5-20020a170902b68500b0016bdea07b8asm8560123pls.236.2022.07.13.04.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 04:12:29 -0700 (PDT)
Sender: AceLan Kao <acelan@gmail.com>
From:   AceLan Kao <acelan.kao@canonical.com>
To:     Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Manuel Ullmann <labre@posteo.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] net: atlantic: remove aq_nic_deinit() when resume
Date:   Wed, 13 Jul 2022 19:12:24 +0800
Message-Id: <20220713111224.1535938-2-acelan.kao@canonical.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220713111224.1535938-1-acelan.kao@canonical.com>
References: <20220713111224.1535938-1-acelan.kao@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>

aq_nic_deinit() has been called while suspending, so we don't have to call
it again on resume.
Actually, call it again leads to another hang issue when resuming from
S3.

Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992345] Call Trace:
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992346] <TASK>
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992348] aq_nic_deinit+0xb4/0xd0 [atlantic]
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992356] aq_pm_thaw+0x7f/0x100 [atlantic]
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992362] pci_pm_resume+0x5c/0x90
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992366] ? pci_pm_thaw+0x80/0x80
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992368] dpm_run_callback+0x4e/0x120
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992371] device_resume+0xad/0x200
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992373] async_resume+0x1e/0x40
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992374] async_run_entry_fn+0x33/0x120
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992377] process_one_work+0x220/0x3c0
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992380] worker_thread+0x4d/0x3f0
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992382] ? process_one_work+0x3c0/0x3c0
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992384] kthread+0x12a/0x150
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992386] ? set_kthread_struct+0x40/0x40
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992387] ret_from_fork+0x22/0x30
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992391] </TASK>
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992392] ---[ end trace 1ec8c79604ed5e0d ]---
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992394] PM: dpm_run_callback(): pci_pm_resume+0x0/0x90 returns -110
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992397] atlantic 0000:02:00.0: PM: failed to resume async: error -110

Fixes: 1809c30b6e5a ("net: atlantic: always deep reset on pm op, fixing up my null deref regression")
Signed-off-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
index dbd5263130f9..8647125d60ae 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -413,9 +413,6 @@ static int atl_resume_common(struct device *dev)
 	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
 
-	/* Reinitialize Nic/Vecs objects */
-	aq_nic_deinit(nic, !nic->aq_hw->aq_nic_cfg->wol);
-
 	if (netif_running(nic->ndev)) {
 		ret = aq_nic_init(nic);
 		if (ret)
-- 
2.25.1

