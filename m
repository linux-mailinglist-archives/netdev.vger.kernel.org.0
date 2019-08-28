Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93190A0B7F
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 22:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbfH1U3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 16:29:33 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35725 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727164AbfH1U3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 16:29:31 -0400
Received: by mail-wm1-f66.google.com with SMTP id l2so1452206wmg.0
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 13:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EbXh4ddYz6TARFMi2XUURwqh1TgZvehKpIM9ZBR2Ftw=;
        b=G1COOZChGgzyq7K1tYlynzI86JZZk6+B9qPuFvld26F45N2zbcAOSoC+0w+iJ3IFjc
         XV+lfJaAtDgTiJrJWR1KgA+i6iSMo2IYLzlwt5V5vEvjdqb1Zc+qrUVwdu4W+877NWbO
         poptnYTieQE3Rx0GitQPbsVRL8iHN3d/myIKMrusxMw2lIcPfG67yU9QQWKkfEGeYcJ5
         zUbk6pBKAfsproTggS9SKr8FYzGcl7JCwd0lIHUQ6dNzz6jecPbSAmnJX/mZG+eUQtJK
         LY/vH0xjUsLmq/RkQz+9vbs8peH97NyH1K0AJ+hKjv09kYIJK3mRVa3QiVyCogDUUlis
         z8MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EbXh4ddYz6TARFMi2XUURwqh1TgZvehKpIM9ZBR2Ftw=;
        b=iFnnii9431ul2lHIT+TqkQQpjp3Wn6nWBj/alDJU5zDEkxvqg7BkZxNygSlUP8LVjc
         dKgGdtnhs4O4g3aP4uM8deS9/wEExHsZAW4h+U7Efllc5kIuGdDsserMYhj8ojG5srkh
         ePRJDObyRMI1Q9Gj/NofDYSPlRS3fceeCaDyg6kOKpaKwHlSItJv/OESif8Gl4VMACX1
         TIiRDTeZ8p0iqcOuAAZz4KQ9u++ZUU/aHTjAujRHPnRv9ES61Em4/2rVtQhc/2Fp5xAF
         6xCscgbq0pI2tnMVRZnWgXi7SI4WmgZ4jcny1WUogVf3dZTpCmZ1hrK0vQagDkXPTVSr
         rWrQ==
X-Gm-Message-State: APjAAAWTWuQuKYWH37wPjSIZ4yakzTDt38yAH0SnkNig68mInj0n8tja
        HFmpy+V9n9rDiAt9peNY9Nw=
X-Google-Smtp-Source: APXvYqx1N/+wIryb39zTG2hDS6wo04re+9ZCc5jTvvQDnOGIYEJHfGJdbk0M3/rpkEthpGEfv0wh7Q==
X-Received: by 2002:a1c:9950:: with SMTP id b77mr7332956wme.46.1567024169782;
        Wed, 28 Aug 2019 13:29:29 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f04:7c00:ac08:eff5:e9d6:77a9? (p200300EA8F047C00AC08EFF5E9D677A9.dip0.t-ipconnect.de. [2003:ea:8f04:7c00:ac08:eff5:e9d6:77a9])
        by smtp.googlemail.com with ESMTPSA id w8sm10906209wmc.1.2019.08.28.13.29.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2019 13:29:29 -0700 (PDT)
Subject: [PATCH net-next v2 6/9] r8169: don't use bit LastFrag in tx
 descriptor after send
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chun-Hao Lin <hau@realtek.com>
References: <8181244b-24ac-73e2-bac7-d01f644ebb3f@gmail.com>
Message-ID: <5b4c94bf-4571-7b36-1d83-c169980a6867@gmail.com>
Date:   Wed, 28 Aug 2019 22:27:30 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <8181244b-24ac-73e2-bac7-d01f644ebb3f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On RTL8125 this bit is always cleared after send. Therefore check for
tx_skb->skb being set what is functionally equivalent.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 652bacf62..4489cd9f2 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5713,7 +5713,7 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 
 		rtl8169_unmap_tx_skb(tp_to_dev(tp), tx_skb,
 				     tp->TxDescArray + entry);
-		if (status & LastFrag) {
+		if (tx_skb->skb) {
 			pkts_compl++;
 			bytes_compl += tx_skb->skb->len;
 			napi_consume_skb(tx_skb->skb, budget);
-- 
2.23.0


