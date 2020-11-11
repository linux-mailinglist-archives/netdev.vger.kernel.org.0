Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9EF2AFAE3
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 22:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbgKKV4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 16:56:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725949AbgKKV4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 16:56:36 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E733C0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 13:56:36 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id za3so4837388ejb.5
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 13:56:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=AFKBPHIduuf4st0QmFGiVpMHUPPFJbT1J63pBPlHOtI=;
        b=njnN02kXpDLX0ZWJheCfpSlKo9wE0TOQGFz+gcvUrwnPDn7QZfiYS4lo2vutORe7DP
         CsRdRL9Dxk0+XtIec9ID1j+GH3PHrlRIBrL8iK1chbcew7aDt+SKy1ehkw+biNrh1khy
         WQYYEEpaDgiGtriBoTPZ3km2KemNjspc1sKtTDbRHDbUqpaPUHcyxYRDWhw3g7PlnFsV
         gcmVo612NoKaruGhDD7TAlYaOZRCJPSJOFv5B69i8NaNYkU4AU8PbukEJGKDOD5wmHIb
         FWa+OWC+X8bIMhMBFT0YnSDznzUlPSGHH0pjmiT5VLOHY+dpMaudmGFHJ4qiI+W3+Puf
         z0eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=AFKBPHIduuf4st0QmFGiVpMHUPPFJbT1J63pBPlHOtI=;
        b=Jp7REaglSGO+BciYiellBtm1D5ecZoPipfASE8VKAVJQpGVLusbe0go3DYGXN3i30y
         Pt2lPttHqfabOcuuaNbngGhHNwR3SA9bDyb4z1OzxjwRVgVDejKBLrxW9L+z2zG6pMOT
         q8EG2GpXciJblXM5LR7CfyIHpAKLG2Xu8WNmvEovfXtrggU8IsBuoL7VyvfGMn0aGjhC
         7IW0UYvT38CgpomZkThPGP+O3MkNdQ3HPaREcjOf2Q1ZfyZoFlsf2+NRsSBVNACOA4YN
         zGLZsd5qfUffwfXFsAw8Opq4u3cN3zJy394FalpZnkjspmUaDlt6lQn3sqZXWNSkOH63
         XWQg==
X-Gm-Message-State: AOAM530lwUGqOYTH/HRdKXIkZ1+gzBkDSDDS6nz53QM1Or9FaF3+XmXy
        erxatEsMLpwiuqBk2GycZssB3HygIzljQw==
X-Google-Smtp-Source: ABdhPJyEibb1aaXBu/hcFPpzZdTogEvezBvIf96HFLl70zjbCJlFrSGiQalwJZKgtqz66cTg8mr7Tg==
X-Received: by 2002:a17:906:170f:: with SMTP id c15mr28020618eje.347.1605131794400;
        Wed, 11 Nov 2020 13:56:34 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:b8a2:2ad2:2cb8:3612? (p200300ea8f232800b8a22ad22cb83612.dip0.t-ipconnect.de. [2003:ea:8f23:2800:b8a2:2ad2:2cb8:3612])
        by smtp.googlemail.com with ESMTPSA id y18sm1321119ejq.69.2020.11.11.13.56.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2020 13:56:33 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next] r8169: use READ_ONCE in rtl_tx_slots_avail
Message-ID: <5676fee3-f6b4-84f2-eba5-c64949a371ad@gmail.com>
Date:   Wed, 11 Nov 2020 22:14:27 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tp->dirty_tx and tp->cur_tx may be changed by a racing rtl_tx() or
rtl8169_start_xmit(). Use READ_ONCE() to annotate the races and ensure
that the compiler doesn't use cached values.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index aa6f8b16d..641c94a46 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4144,7 +4144,8 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
 static bool rtl_tx_slots_avail(struct rtl8169_private *tp,
 			       unsigned int nr_frags)
 {
-	unsigned int slots_avail = tp->dirty_tx + NUM_TX_DESC - tp->cur_tx;
+	unsigned int slots_avail = READ_ONCE(tp->dirty_tx) + NUM_TX_DESC
+					- READ_ONCE(tp->cur_tx);
 
 	/* A skbuff with nr_frags needs nr_frags+1 entries in the tx queue */
 	return slots_avail > nr_frags;
-- 
2.29.2

