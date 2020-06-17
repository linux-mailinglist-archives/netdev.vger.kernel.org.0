Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA821FD686
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 22:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgFQU4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 16:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgFQU4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 16:56:50 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E9FC061755
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 13:56:48 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id e1so3843299wrt.5
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 13:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vYmfE6PX4DJYsHGd18sDMKqYyAIabImqTJD+c5+0RT8=;
        b=F1QrE7lMGGfokEKBUV5MeuaBzuF9lySShD7jaYITJqUuP5M+IWb6wgDAfT8xMY4pEh
         YtkU8x3TAvX/NLc9ooJ7uotGjRrAsEsMUJ5238znXeFEv/LM1FZlnbP2jC7NCzoueYyK
         lgiaEKar0DdjaQvUzoWmYFV/huaowhHsa4LLnyeuI0as3Xl1z2tavaCmN45RQlL2zZ6t
         FHfxfpew659jy5pTLBxfMuNYLMYX5JlRkRp37Wh8mhUNoQ2i8KTOJNcGh9CPW4SjjRYE
         WmwREO51eJf9PrkVSdYk4aLhQm6b3Umsfzz5yEmBl+c5yCLSwsA0nDMYpOgJVmfave83
         SfDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vYmfE6PX4DJYsHGd18sDMKqYyAIabImqTJD+c5+0RT8=;
        b=ROTo0hnY1LcQKq2nieS1A9TfJq+L9UxgIqSh83fAD/vubmCrY4U3UqCGYE5Q0ZqOU6
         FR2nqAzMyzTiNpH/S3Hgh70lVu4rtFkW+nlch25LgaoeG89chT3Fo8aPWcHVZk416/Ks
         igip1kXjJtd0IiOCSpS/RtkKXGJ2XbCuGhBAoNCcOuqxPmp7HziR9nSuAn1faHihhuVz
         N3lSdXwArOOWSMjr7C+kR1CLpTM/i7d/PO8LDLCv50Eb4SrkLPxIkGJn8jQPlpgevibD
         ++bYzafK7fYFrkwlNcjSSJQ75D7nS+m3GU7s9SPowCfMdYFj8UYiGU9Mf6UmY4VZmQpe
         11MQ==
X-Gm-Message-State: AOAM5303oMblE7mXheZwt8zVqpCkcLs9B/Wwuc3tra7HmBh0Y95tXuja
        rV9F6NIqyNPXK8EOPZS6LfC4TvrD
X-Google-Smtp-Source: ABdhPJzeko5TovMMD2pWxwhCJFbdM3x4BVwF8gZFyeYqW4agPi/ZB0JNEvq6UjcwoI3/Fk0MiqXQeA==
X-Received: by 2002:adf:97d3:: with SMTP id t19mr1177487wrb.116.1592427407226;
        Wed, 17 Jun 2020 13:56:47 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:c06e:b26:fa7c:aab? (p200300ea8f235700c06e0b26fa7c0aab.dip0.t-ipconnect.de. [2003:ea:8f23:5700:c06e:b26:fa7c:aab])
        by smtp.googlemail.com with ESMTPSA id o6sm899130wrp.3.2020.06.17.13.56.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2020 13:56:46 -0700 (PDT)
Subject: [PATCH net-next 5/8] r8169: move napi_disable call and rename
 rtl8169_hw_reset
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ef2a4cd4-1492-99d8-f94f-319eeb129137@gmail.com>
Message-ID: <a9f75e8a-f5c5-edc9-1e83-ec75de95ea5c@gmail.com>
Date:   Wed, 17 Jun 2020 22:54:18 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <ef2a4cd4-1492-99d8-f94f-319eeb129137@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rtl8169_hw_reset() meanwhile does more than a hw reset, therefore rename
it to rtl8169_cleanup(). In addition move calling napi_disable() to this
function.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 0d3e58ae1..afcdaace2 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3926,8 +3926,10 @@ static void rtl8169_tx_clear(struct rtl8169_private *tp)
 	netdev_reset_queue(tp->dev);
 }
 
-static void rtl8169_hw_reset(struct rtl8169_private *tp, bool going_down)
+static void rtl8169_cleanup(struct rtl8169_private *tp, bool going_down)
 {
+	napi_disable(&tp->napi);
+
 	/* Give a racing hard_start_xmit a few cycles to complete. */
 	synchronize_net();
 
@@ -3970,10 +3972,9 @@ static void rtl_reset_work(struct rtl8169_private *tp)
 	struct net_device *dev = tp->dev;
 	int i;
 
-	napi_disable(&tp->napi);
 	netif_stop_queue(dev);
 
-	rtl8169_hw_reset(tp, false);
+	rtl8169_cleanup(tp, false);
 
 	for (i = 0; i < NUM_RX_DESC; i++)
 		rtl8169_mark_to_asic(tp->RxDescArray + i);
@@ -4636,9 +4637,8 @@ static void rtl8169_down(struct rtl8169_private *tp)
 	bitmap_zero(tp->wk.flags, RTL_FLAG_MAX);
 
 	phy_stop(tp->phydev);
-	napi_disable(&tp->napi);
 
-	rtl8169_hw_reset(tp, true);
+	rtl8169_cleanup(tp, true);
 
 	rtl_pll_power_down(tp);
 
-- 
2.27.0


