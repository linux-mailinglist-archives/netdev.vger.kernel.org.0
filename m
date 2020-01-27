Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5902614A146
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 10:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgA0J5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 04:57:08 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41515 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgA0J5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 04:57:07 -0500
Received: by mail-pf1-f196.google.com with SMTP id w62so4666112pfw.8
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 01:57:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=th/aVVhQNvMbxhvlv5IN61IX1K2lXZ94hFaZRwDbL08=;
        b=XNeAhcIutB2PJ6BeZBMP8zHcjAOLUM9eA4ig8FpeAqEd83Y2RA6NCLFDWa2G192O0e
         07W95nec7lQz9KjFh6A51GiOlRtuNCE17u2nzXxOKveSNiGNQ3vlvtQ4HiikQHdkFktN
         8XIweSPLXNXmQEk2vg1VuuSU8Qwt+prxtz6Nc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=th/aVVhQNvMbxhvlv5IN61IX1K2lXZ94hFaZRwDbL08=;
        b=gxEStuFeKVPDEBenktLXffK94l4IfoSWxfDyb2sL3SmVLmSu/SApbmfr08xEieoKq2
         0RaMUcImtK60KKWhTCFH8TMJQqMcMGdt7TLeHPBDrz/GZOGL8mACqG4no5QIUmpvE0Di
         UaD7PFqQc1pQyMvkh7umBAXd7YPokYqeAGIQwhrmklwkr/BNrSn4BQogIgmiu6GIPmui
         t8yAx6EvmEZEyPkqolO1UxXOCEKa07OqmbmKclVPHti47msnUKPRy2rNfHg7Q2nqGk8K
         hDMbKZbv1+BbxAdJbdP1szxGyksE7Q6mpFOU6fLqHUuQnHsWTgdVgMZ1MX6551RTlry3
         xziw==
X-Gm-Message-State: APjAAAUmgQRlwy9l9B45TpCK2LY8tVpctfoCS2cKn25Fg9p6y15Bf97+
        9TSNejJk+XntSsNd85FiTK3LaIIVx4w=
X-Google-Smtp-Source: APXvYqwUT3rMfwdSEpTXiU80XOL7EFfuUusfbsWejqU8x3JOLepfNQ4BFU1ICUD+sqJ0opTuHkyIng==
X-Received: by 2002:aa7:8544:: with SMTP id y4mr15831197pfn.100.1580119027121;
        Mon, 27 Jan 2020 01:57:07 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r3sm15232594pfg.145.2020.01.27.01.57.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jan 2020 01:57:06 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v2 05/15] bnxt_en: Do not accept fragments for aRFS flow steering.
Date:   Mon, 27 Jan 2020 04:56:17 -0500
Message-Id: <1580118987-30052-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580118987-30052-1-git-send-email-michael.chan@broadcom.com>
References: <1580118987-30052-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In bnxt_rx_flow_steer(), if the dissected packet is a fragment, do not
proceed to create the ntuple filter and return error instead.  Otherwise
we would create a filter with 0 source and destination ports because
the dissected ports would not be available for fragments.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index fb4a65f..fb67e66 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11100,6 +11100,7 @@ static int bnxt_rx_flow_steer(struct net_device *dev, const struct sk_buff *skb,
 	struct ethhdr *eth = (struct ethhdr *)skb_mac_header(skb);
 	int rc = 0, idx, bit_id, l2_idx = 0;
 	struct hlist_head *head;
+	u32 flags;
 
 	if (!ether_addr_equal(dev->dev_addr, eth->h_dest)) {
 		struct bnxt_vnic_info *vnic = &bp->vnic_info[0];
@@ -11139,8 +11140,9 @@ static int bnxt_rx_flow_steer(struct net_device *dev, const struct sk_buff *skb,
 		rc = -EPROTONOSUPPORT;
 		goto err_free;
 	}
-	if ((fkeys->control.flags & FLOW_DIS_ENCAPSULATION) &&
-	    bp->hwrm_spec_code < 0x10601) {
+	flags = fkeys->control.flags;
+	if (((flags & FLOW_DIS_ENCAPSULATION) &&
+	     bp->hwrm_spec_code < 0x10601) || (flags & FLOW_DIS_IS_FRAGMENT)) {
 		rc = -EPROTONOSUPPORT;
 		goto err_free;
 	}
-- 
2.5.1

