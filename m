Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31741175205
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 04:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgCBDHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 22:07:33 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41843 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbgCBDHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 22:07:33 -0500
Received: by mail-pf1-f193.google.com with SMTP id j9so4820418pfa.8
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 19:07:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KObYUU7nIQU7SuZCRb5UuHkJa/KA/XBSKzNZDdj/MQg=;
        b=X/oz59TWX7EHyAiPuozjNyMZhl4NGvTjlL4/W38x2tYRDgEVWyqhc51fFeZnN7ksmI
         tEuNRaJmeFMLDcl7rvEjwJJFsMhf7ZRRf6CLX/BdbWiYkuD0JE0L5mS5CsVo69NqZ1N0
         3GA115XJLCoYBystcUKl7e6CJKOdPdGCitSr0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KObYUU7nIQU7SuZCRb5UuHkJa/KA/XBSKzNZDdj/MQg=;
        b=MXkOfVXGB/RnS8GWEP22XquVGd7drGIY4Zp2SqR/dNuU2ya3e/YhTCLHwGjULtRYR9
         MNwXn53yWYITOwEVj6g4KlacP1xVADEEsQ+giYTnN2SuH45cT1v3Z089otBHUIhe8vIZ
         XDhjrhi5f4O7mKV/XUpHouf6gnja8POEfx69E9mkqBrCmqMiXzsistCZsryvDoWXdlLr
         CBRqHiTQVrp84cHFZi7W8MI07ApsJsam39UMkafS4mJourHgQ4O7ZpVZZs54K40ifE2g
         pBC9CGS4lMpJtvlkAOcHBS4WJCCiYePmjOdD+kY1e6FqzPyjBO82NIvFXDs/RuoImh05
         bQ5w==
X-Gm-Message-State: APjAAAUi3ebU98bU9Uoj9N2Fw4ZOQkMQTiJSH/6s4c2yrO9M7fzvox/A
        Kmm8qTfZOPkJUe/zi6QQXpbVu1cM4JI=
X-Google-Smtp-Source: APXvYqw8ehvbIr+OFTtJg2UJMUkqb6m+ddTRme+PsRY8CGmH3jrR+3H1OC3z/g/tGOPtN5xqTzGb5g==
X-Received: by 2002:aa7:9218:: with SMTP id 24mr15798481pfo.145.1583118452127;
        Sun, 01 Mar 2020 19:07:32 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f1sm9809278pjq.31.2020.03.01.19.07.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 01 Mar 2020 19:07:31 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 1/2] bnxt_en: reinitialize IRQs when MTU is modified
Date:   Sun,  1 Mar 2020 22:07:17 -0500
Message-Id: <1583118438-18829-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1583118438-18829-1-git-send-email-michael.chan@broadcom.com>
References: <1583118438-18829-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

MTU changes may affect the number of IRQs so we must call
bnxt_close_nic()/bnxt_open_nic() with the irq_re_init parameter
set to true.  The reason is that a larger MTU may require
aggregation rings not needed with smaller MTU.  We may not be
able to allocate the required number of aggregation rings and
so we reduce the number of channels which will change the number
of IRQs.  Without this patch, it may crash eventually in
pci_disable_msix() when the IRQs are not properly unwound.

Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f9a8151..c5c8eff 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10982,13 +10982,13 @@ static int bnxt_change_mtu(struct net_device *dev, int new_mtu)
 	struct bnxt *bp = netdev_priv(dev);
 
 	if (netif_running(dev))
-		bnxt_close_nic(bp, false, false);
+		bnxt_close_nic(bp, true, false);
 
 	dev->mtu = new_mtu;
 	bnxt_set_ring_params(bp);
 
 	if (netif_running(dev))
-		return bnxt_open_nic(bp, false, false);
+		return bnxt_open_nic(bp, true, false);
 
 	return 0;
 }
-- 
2.5.1

