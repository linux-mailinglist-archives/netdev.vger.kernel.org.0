Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E83364AA415
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 00:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377887AbiBDXPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 18:15:23 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:44250 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378011AbiBDXPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 18:15:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A8B56CE24B9;
        Fri,  4 Feb 2022 23:15:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A97C004E1;
        Fri,  4 Feb 2022 23:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644016518;
        bh=pLxkcGPvu1HilxtYZWiOuXKZ4HHdXlhZYggbeedegY8=;
        h=Date:From:To:Cc:Subject:From;
        b=gxVDSfcEzhnIk3vlbJV6q3zukKT+CBf31XqdUYm9lHJZE8Uv66HCVT1c5uPHD1nIE
         Kc/X6SAKguuQLHJ1spTq67w3U+EkYYcU/pIcxa/j79rIZXzO52DytDv+FaoGz0aK9i
         pFHqYEVvzuQgA19AT/kScPKNPlNbZmAiS9NvX9NwxY4XWy/VZfZuPVpH7v2ZFdcnxs
         2m9nN7cEqRsQohBij47o49WCKqyDaMLfprHyIsuKT6KXZPzCF/GDHSfwupS2AgvieB
         BOljl7nuKUoiJ69RxVY7F3+EuJ01QzrE1OVXDdIxYil/rZOHeifr403+hpzEsGqJto
         GC0k6I4LC3p8Q==
Date:   Fri, 4 Feb 2022 17:22:28 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] brcmfmac: p2p: Replace one-element arrays with
 flexible-array members
Message-ID: <20220204232228.GA442895@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a regular need in the kernel to provide a way to declare having
a dynamically sized set of trailing elements in a structure. Kernel code
should always use “flexible array members”[1] for these cases. The older
style of one-element or zero-length arrays should no longer be used[2].

This helps with the ongoing efforts to globally enable -Warray-bounds
and get us closer to being able to tighten the FORTIFY_SOURCE routines
on memcpy().

This issue was found with the help of Coccinelle and audited and fixed,
manually.

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays

Link: https://github.com/KSPP/linux/issues/79
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c   | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index 4735063e4c03..d3f08d4f380b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -158,7 +158,7 @@ struct brcmf_p2p_pub_act_frame {
 	u8	oui_type;
 	u8	subtype;
 	u8	dialog_token;
-	u8	elts[1];
+	u8	elts[];
 };
 
 /**
@@ -177,7 +177,7 @@ struct brcmf_p2p_action_frame {
 	u8	type;
 	u8	subtype;
 	u8	dialog_token;
-	u8	elts[1];
+	u8	elts[];
 };
 
 /**
@@ -192,7 +192,7 @@ struct brcmf_p2psd_gas_pub_act_frame {
 	u8	category;
 	u8	action;
 	u8	dialog_token;
-	u8	query_data[1];
+	u8	query_data[];
 };
 
 /**
@@ -225,7 +225,7 @@ static bool brcmf_p2p_is_pub_action(void *frame, u32 frame_len)
 		return false;
 
 	pact_frm = (struct brcmf_p2p_pub_act_frame *)frame;
-	if (frame_len < sizeof(struct brcmf_p2p_pub_act_frame) - 1)
+	if (frame_len < sizeof(*pact_frm))
 		return false;
 
 	if (pact_frm->category == P2P_PUB_AF_CATEGORY &&
@@ -253,7 +253,7 @@ static bool brcmf_p2p_is_p2p_action(void *frame, u32 frame_len)
 		return false;
 
 	act_frm = (struct brcmf_p2p_action_frame *)frame;
-	if (frame_len < sizeof(struct brcmf_p2p_action_frame) - 1)
+	if (frame_len < sizeof(*act_frm))
 		return false;
 
 	if (act_frm->category == P2P_AF_CATEGORY &&
@@ -280,7 +280,7 @@ static bool brcmf_p2p_is_gas_action(void *frame, u32 frame_len)
 		return false;
 
 	sd_act_frm = (struct brcmf_p2psd_gas_pub_act_frame *)frame;
-	if (frame_len < sizeof(struct brcmf_p2psd_gas_pub_act_frame) - 1)
+	if (frame_len < sizeof(*sd_act_frm))
 		return false;
 
 	if (sd_act_frm->category != P2PSD_ACTION_CATEGORY)
-- 
2.27.0

