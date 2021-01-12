Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4B82F2A13
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 09:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405554AbhALIae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 03:30:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405068AbhALIad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 03:30:33 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 117DDC061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 00:29:49 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id a12so1490115wrv.8
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 00:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cePMcyi0KtDrhtKJT1Dly10onkOcNFFKNROUVgRJ3aw=;
        b=flyV+i6+WyvJPnUl2PvZbOfhLZRzmRTC8E0vXgoDQdXTkBR91Fr1iZd1OBuMBolAII
         XkrtA1QHlMWxH0Idk/UJ+1stT1jhFQ/fEzC4Sc2/lyNMa7zclQmb/ZZHKxAQ2QXSkMhb
         Stf/iOX7zNV1DgwWPNyFJ7HC32R3ikV7EKfcgBEfJNGmdqUDmCq/W3swwizp936iV4vd
         JOvgaDagNDqLYhgDEwK97Rfq0TslgPgOYwOJIw0QRuY+e9i/2rNzoLIO1OqHCbUSF2Oe
         GlFnP8UzJP9Fr6MyEdKBt8vEnC189zvHzcmmHi1W5xe2GjplEhWAvTGPgCWgeV1bv28u
         HjoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cePMcyi0KtDrhtKJT1Dly10onkOcNFFKNROUVgRJ3aw=;
        b=Npl+tbjEx1DYOCqfg6Lgt1OxmURe4LUDaVtPXGxglAtcd+uakHR46u9D5vum9Y+u4D
         oo6KB6AlaZj9mxaCZwBSw2hcUyytcUGuwS4WjNkz7BNeatLtKhxm2bHyz4UujCkul9hu
         /JVN41JC20/cK7Z4T3nLMVglCRwbtcHty4lWHu2/BwLxpN1sqU+M1lic5Uleixl1Oy4x
         NjiDyndzSaduvmOmL2nneudi5F+PEEnkiNVimMBWg5unpNBH+m8EYK1wd37GjFcqY/24
         ld8J6GInQpavFMDU94j6NHVj37ZQEp0vJwh/7cAJN/9ejYOFMFn0blx02jNbmBfJpJEs
         1Zrg==
X-Gm-Message-State: AOAM531WM7SOcG4H7GIBo8tYc1dqqMNJYlZfn46BK54uFJsU1Z0ss/+I
        zHREdFKYoLbznaKxFnfcg/ipwV5MjZ4=
X-Google-Smtp-Source: ABdhPJxM8TU3NGQKWe/5JLFtV5EI1dg7oYtLQCLl9oYmmuODd9qC1tflDMjD5u+SqBxUWv5g9+9CMw==
X-Received: by 2002:a5d:690d:: with SMTP id t13mr2998698wru.410.1610440187620;
        Tue, 12 Jan 2021 00:29:47 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:d420:a714:6def:4af7? (p200300ea8f065500d420a7146def4af7.dip0.t-ipconnect.de. [2003:ea:8f06:5500:d420:a714:6def:4af7])
        by smtp.googlemail.com with ESMTPSA id z8sm1376462wrh.65.2021.01.12.00.29.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jan 2021 00:29:47 -0800 (PST)
Subject: [PATCH net-next 2/3] r8169: improve rtl8169_rx_csum
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1bc3b7ef-b54a-d517-df54-27d61ca7ba94@gmail.com>
Message-ID: <ab2f84ca-c832-dca8-ff17-bc3a69cf4865@gmail.com>
Date:   Tue, 12 Jan 2021 09:29:45 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1bc3b7ef-b54a-d517-df54-27d61ca7ba94@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the mask to include the checksum failure bits. This allows to
simplify the condition in rtl8169_rx_csum().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 84f488d1c..b4c080cc6 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -533,6 +533,9 @@ enum rtl_rx_desc_bit {
 	IPFail		= (1 << 16), /* IP checksum failed */
 	UDPFail		= (1 << 15), /* UDP/IP checksum failed */
 	TCPFail		= (1 << 14), /* TCP/IP checksum failed */
+
+#define RxCSFailMask	(IPFail | UDPFail | TCPFail)
+
 	RxVlanTag	= (1 << 16), /* VLAN tag available */
 };
 
@@ -4377,10 +4380,9 @@ static inline int rtl8169_fragmented_frame(u32 status)
 
 static inline void rtl8169_rx_csum(struct sk_buff *skb, u32 opts1)
 {
-	u32 status = opts1 & RxProtoMask;
+	u32 status = opts1 & (RxProtoMask | RxCSFailMask);
 
-	if (((status == RxProtoTCP) && !(opts1 & TCPFail)) ||
-	    ((status == RxProtoUDP) && !(opts1 & UDPFail)))
+	if (status == RxProtoTCP || status == RxProtoUDP)
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 	else
 		skb_checksum_none_assert(skb);
-- 
2.30.0


