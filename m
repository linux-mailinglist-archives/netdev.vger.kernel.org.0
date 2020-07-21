Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 333F32286EB
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730392AbgGUROa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729967AbgGURO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:14:28 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1958AC061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:14:28 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id a23so9444044pfk.13
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JKn+NFVY7BYS/UiTq3/4UtHvhCNPOFQTVrJMU0d5GoA=;
        b=DedW9GlVoYux+SfS3NUj8P+5oSovYH0qOIoE1vsclSQVYrccM/810okK5Rd7IpSQWi
         LI+DjluEYJuD5TsWrQuGj8xAitYOEQvWaEoMOXzDKkfIMQQIPF+edpRAuMw6aninsDS/
         nBmsacIlca7hAsBa98VWvCp6BWVJDOvz++X5RsMXxG6h7wksgAw3OoaCSBUMnwEIiZiH
         rUVOU4h6ycCb3zLuxx8IsDjkiNB1mRxx0y0+ZcLCHleKSuxMoFcLVOxaIhpUC+B/Q9Iu
         TT97WT4T/nn+CiK19u1iB99tG3JFTslXECJUR+4I6jpUQs1u+jnBqKbPUgayY98JW1a5
         KvHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JKn+NFVY7BYS/UiTq3/4UtHvhCNPOFQTVrJMU0d5GoA=;
        b=seBJPffnVRdpdN9G7g6IVT9xUG3tWzE08ZRBOCAFvyayaTpTQhmxLbnxDYVlxoXayq
         hRky4T8kTEw1NX0IySMpWYBi3P9hiq0ZTEapPegksExpotGNKpxarQKd0U9mvhsjlg/D
         xFU3dbWgTlMPLehffOotBN7vJmATdSkys0xFfH1EibjIe/5bRfFhNpOEeP71SELeGaRu
         XYpa8ggKYqYhLF48lNrU71jJvU+ATy0aDVSqBviOlguss7wkzCWmttVk3vTVLPZXuRMd
         n5vHs6AjnndQz0IC0J4tzWxp6uyAF94fyn7jMlpv/UW9k/CweyAVQibWDFD5NDAP8M1K
         tUnw==
X-Gm-Message-State: AOAM531TQwPvxF1EheQWMqitmHna5RsDmMtdMSnVvM7+QOx40G1QccXj
        RrxwQn+q/5y2/WcYgVoMxPU=
X-Google-Smtp-Source: ABdhPJzdFNkmhhitoOJiCLUqMZfEV+18VkuvNrEMgHoDFy47+E0xHLzjbYTGHJjg/rlTrGsMkjb0dA==
X-Received: by 2002:a63:5a20:: with SMTP id o32mr23726912pgb.15.1595351667644;
        Tue, 21 Jul 2020 10:14:27 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id z20sm2982305pjr.43.2020.07.21.10.14.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jul 2020 10:14:26 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     sgoutham@marvell.com, sbhatta@marvell.com
Subject: [PATCH net 2/3] octeontx2-pf: cancel reset_task work
Date:   Tue, 21 Jul 2020 22:44:07 +0530
Message-Id: <1595351648-10794-3-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595351648-10794-1-git-send-email-sundeep.lkml@gmail.com>
References: <1595351648-10794-1-git-send-email-sundeep.lkml@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

During driver exit cancel the queued
reset_task work in VF driver.

Fixes: 3184fb5ba96e ("octeontx2-vf: Virtual function driver support")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index f422751..c1c263d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -617,6 +617,7 @@ static void otx2vf_remove(struct pci_dev *pdev)
 
 	vf = netdev_priv(netdev);
 
+	cancel_work_sync(&vf->reset_task);
 	otx2vf_disable_mbox_intr(vf);
 
 	otx2_detach_resources(&vf->mbox);
-- 
2.7.4

