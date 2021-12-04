Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E994686CD
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 18:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385302AbhLDRzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 12:55:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385207AbhLDRzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 12:55:39 -0500
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F55C061751;
        Sat,  4 Dec 2021 09:52:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mVm0eifmz8RdIj10Mwm+9KkTNvgkzEf2FRbG+abQdDs=; b=WhzLYDXfVIHsYWm/Wu89gTyxGu
        lkn0ml71cSVnNmy9weUUNcmgnP1YRaFrEKQAtTStQ648SxMncHDk7Q6vECPQmWWqZQtVRrFoYYK2S
        I7AM6ORevMJCVaH6MKNrgTZ1ThwqVpffe2Wmcfd+Y5+NlY1mThEnX8IkOiWa2MkE0jX4=;
Received: from p54ae911a.dip0.t-ipconnect.de ([84.174.145.26] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1mtZCX-0004Ca-EA; Sat, 04 Dec 2021 18:51:57 +0100
Message-ID: <36891e25-2896-f351-726c-26e308b808fa@nbd.name>
Date:   Sat, 4 Dec 2021 18:51:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH 3/3] mt76: mt7921: fix build regression
Content-Language: en-US
To:     Arnd Bergmann <arnd@kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Soul Huang <Soul.Huang@mediatek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20211204173848.873293-1-arnd@kernel.org>
 <20211204173848.873293-3-arnd@kernel.org>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <20211204173848.873293-3-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-04 18:38, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> After mt7921s got added, there are two possible build problems:
> 
> a) mt7921s does not get built at all if mt7921e is not also enabled
> 
> b) there is a link error when mt7921e is a loadable module, but mt7921s
> configured as built-in:
> 
> ERROR: modpost: "mt7921_mac_sta_add" [drivers/net/wireless/mediatek/mt76/mt7921/mt7921e.ko] undefined!
> ERROR: modpost: "mt7921_mac_sta_assoc" [drivers/net/wireless/mediatek/mt76/mt7921/mt7921e.ko] undefined!
> ERROR: modpost: "mt7921_mac_sta_remove" [drivers/net/wireless/mediatek/mt76/mt7921/mt7921e.ko] undefined!
> ERROR: modpost: "mt7921_mac_write_txwi" [drivers/net/wireless/mediatek/mt76/mt7921/mt7921e.ko] undefined!
> ERROR: modpost: "mt7921_mcu_drv_pmctrl" [drivers/net/wireless/mediatek/mt76/mt7921/mt7921e.ko] undefined!
> ERROR: modpost: "mt7921_mcu_fill_message" [drivers/net/wireless/mediatek/mt76/mt7921/mt7921e.ko] undefined!
> ERROR: modpost: "mt7921_mcu_parse_response" [drivers/net/wireless/mediatek/mt76/mt7921/mt7921e.ko] undefined!
> ERROR: modpost: "mt7921_ops" [drivers/net/wireless/mediatek/mt76/mt7921/mt7921e.ko] undefined!
> ERROR: modpost: "mt7921_queue_rx_skb" [drivers/net/wireless/mediatek/mt76/mt7921/mt7921e.ko] undefined!
> ERROR: modpost: "mt7921_update_channel" [drivers/net/wireless/mediatek/mt76/mt7921/mt7921e.ko] undefined!
> 
> Fix both by making sure that Kbuild enters the subdirectory when
> either one is enabled.
> 
> Fixes: 48fab5bbef40 ("mt76: mt7921: introduce mt7921s support")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Felix Fietkau <nbd@nbd.name>
