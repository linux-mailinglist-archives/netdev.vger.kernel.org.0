Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 016131499B4
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 10:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbgAZJDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 04:03:37 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:55971 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgAZJDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 04:03:36 -0500
Received: by mail-pj1-f67.google.com with SMTP id d5so1749539pjz.5
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 01:03:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=th/aVVhQNvMbxhvlv5IN61IX1K2lXZ94hFaZRwDbL08=;
        b=IvEva/RYisyXJ6/6eXDk+k/BKe2jcNCQfrKZP6KOOsC++BnawenfYGbscQ7Z/m1/uU
         tDv8dPJisNyGlu88WOZeN3JoT5RrDmBiRc2hCPkM8j4SEmEPhOHaaoBb4uzGpRAvxiH9
         Yk2brsKVIKh1tNxeZjQQV/cj4qOWYgOCVIgII=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=th/aVVhQNvMbxhvlv5IN61IX1K2lXZ94hFaZRwDbL08=;
        b=eiG6pGoKYORSfBbcFaQyIZ679By/JOrW8UMHFowv4ma3WKfP0aSXkWOJHX6USAxrfa
         KiWCt0kMFXS40m4uhcl2wxGZPHUcg0y7yzjXOFJmtRlKq7FmIAGV4uDOh5ApZNLb/Y1e
         VqMcu7gxZjR+7FtPYDDgnWUvY/HMsqi9KVEqUaPjKZfOJxP5DnBGarE0YbRJ0GAiGmiA
         XVUcxVCgCsJNaMivWyuWcPvQ+3C4PYkQhn9x36eR/HWTj3Bo9IJcAm3a7LGbsJgL/4Cr
         eJaqpUcmaBKz+9rNjTREKBvCVz6Lo751VqiTAhAmkDswZ3+iMDiujLn+O2dvjocj3oLE
         Oebw==
X-Gm-Message-State: APjAAAXSWJGLKrMD3v/Ui668AMUBLRM4fG5yl42RUpZvU+dAj+wwyyP+
        eOQR5je3TwrWBm6hcmWAiKnQsQ==
X-Google-Smtp-Source: APXvYqxWGd4T7zwacynOkdAv/BaleQNsxNtGtXWlycWO5BjixI/mgK7VYz+Ze+hRKbJEFzyjaKZAvQ==
X-Received: by 2002:a17:902:ba97:: with SMTP id k23mr11420855pls.19.1580029415727;
        Sun, 26 Jan 2020 01:03:35 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i17sm11856315pfr.67.2020.01.26.01.03.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jan 2020 01:03:35 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 06/16] bnxt_en: Do not accept fragments for aRFS flow steering.
Date:   Sun, 26 Jan 2020 04:03:00 -0500
Message-Id: <1580029390-32760-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
References: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
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

