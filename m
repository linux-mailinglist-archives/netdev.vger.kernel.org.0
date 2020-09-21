Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023FB2718EE
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 03:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgIUBJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 21:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbgIUBJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 21:09:24 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33929C061755
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 18:09:24 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 34so7505284pgo.13
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 18:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ifa1kfCGMDEbztGkaaw8oAQMP2MNzCYZiuiTMyKsoSw=;
        b=dh39rSBeBciCJRw8lsnAll4FAJokxDJt6Vpj1Wm1sFTQEKNcqvmp7cE3IOsu29b7Xv
         OPVXlft+PBebx2EQVz2Yv39bnoGT8H6I27t3tgysC3ugcLLy6qeJK67LoVoUifxFRbFe
         Uw5uXb6QhjUcF0fIkDKdeD+Hxjk1OrtDlM49w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ifa1kfCGMDEbztGkaaw8oAQMP2MNzCYZiuiTMyKsoSw=;
        b=JhYj6N8btTbQErtf+8/ORzyeWfQ6/g4nO1dU5dTsfyVaT7NKguvkDlxb3C4o2JTkT7
         lYVQ3qn+CEUJW4QZH3aQPBQda2m6yeZgNEDvZBm6KdGoN0xYw7SwervIdfakTOjk6e+2
         JxLlbNEl3HvOZk6o9REFHv6t4lrfn6huS9VE4M5H+veZHury1EVVuqddR41vDr6UEpqD
         7n8A/PU3FI0LaZsghXi/zAZHT2tP0HU204oGC7ik7O4CYsHOhaObX4oWEwK1S8q5nvmd
         h2ayoviUVbcP359CqSpFVT5mn8uiJBDzmAfKroR+FfzDNaz5C0Lh+pLtLBB59VlR1GXi
         J/+w==
X-Gm-Message-State: AOAM531MkwtAnrexd0AJmi6cY9EmnnrSJLR2kaBRUD6lBQ3W2xXcltu8
        rN3Nnv0dbkac6a+oKHfJGnzeqw==
X-Google-Smtp-Source: ABdhPJxkGJnP2mTpxQraOZKtXGqYY/WFYCggDXy34hThi+5miwK5S2ftKHJVpRiSe3lj77TGnP5Sfg==
X-Received: by 2002:aa7:908b:0:b029:142:2501:34ee with SMTP id i11-20020aa7908b0000b0290142250134eemr25148088pfa.71.1600650563609;
        Sun, 20 Sep 2020 18:09:23 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bt13sm9098095pjb.23.2020.09.20.18.09.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Sep 2020 18:09:22 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net 4/6] bnxt_en: Return -EOPNOTSUPP for ETHTOOL_GREGS on VFs.
Date:   Sun, 20 Sep 2020 21:08:57 -0400
Message-Id: <1600650539-19967-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600650539-19967-1-git-send-email-michael.chan@broadcom.com>
References: <1600650539-19967-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Debug firmware commands are not supported on VFs to read registers.
This patch avoids logging unnecessary access_denied error on VFs
when user calls ETHTOOL_GREGS.

By returning error in get_regs_len() method on the VF, the get_regs()
method will not be called.

Fixes: b5d600b027eb ("bnxt_en: Add support for 'ethtool -d'")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 6c75101..fecdfd8 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1322,6 +1322,9 @@ static int bnxt_get_regs_len(struct net_device *dev)
 	struct bnxt *bp = netdev_priv(dev);
 	int reg_len;
 
+	if (!BNXT_PF(bp))
+		return -EOPNOTSUPP;
+
 	reg_len = BNXT_PXP_REG_LEN;
 
 	if (bp->fw_cap & BNXT_FW_CAP_PCIE_STATS_SUPPORTED)
-- 
1.8.3.1

