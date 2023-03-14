Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44CB86B90A9
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 11:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjCNKxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 06:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjCNKxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 06:53:13 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183AA1CADA
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 03:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=PFWRE/I5fsxNEryuVloHW3E+e5Lfhok41nQroPHFwhk=; b=pfqogIwF/3ALZvN18MlQxQtKRm
        8oiwm7EQYLEUAy2jvbchG84Rr5AMh2rQJr06kalTbYjyHgaStdhnLJJJPOhXITMCYL5BWgwE44nd8
        cZM2kcL+Ehu1zj0VHPpusyq/cXSho8s6xuf/tHE9l/G3zOgur6ugiMZtYdIJod6HWNFs=;
Received: from p54ae9730.dip0.t-ipconnect.de ([84.174.151.48] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pc1vh-001pnc-N0; Tue, 14 Mar 2023 11:30:53 +0100
Message-ID: <4a229d53-f058-115a-afc6-dd544a0dedf2@nbd.name>
Date:   Tue, 14 Mar 2023 11:30:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [BUG] MTK SoC Ethernet throughput TX only ~620Mbit/s since
 6.2-rc1
Content-Language: en-US
To:     Frank Wunderlich <frank-w@public-files.de>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Daniel Golle <daniel@makrotopia.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
References: <trinity-92c3826f-c2c8-40af-8339-bc6d0d3ffea4-1678213958520@3c-app-gmx-bs16>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <trinity-92c3826f-c2c8-40af-8339-bc6d0d3ffea4-1678213958520@3c-app-gmx-bs16>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.03.23 19:32, Frank Wunderlich wrote:
> Hi,
> 
> i've noticed that beginning on 6.2-rc1 the throughput on my Bananapi-R2 and Bananapi-R3 goes from 940Mbit/s down do 620Mbit/s since 6.2-rc1.
> Only TX (from SBC PoV) is affected, RX is still 940Mbit/s.
> 
> i bisected this to this commit:
> 
> f63959c7eec3151c30a2ee0d351827b62e742dcb ("net: ethernet: mtk_eth_soc: implement multi-queue support for per-port queues")
> 
> Daniel reported me that this is known so far and they need assistance from MTK and i should report it officially.
> 
> As far as i understand it the commit should fix problems with clients using non-GBE speeds (10/100 Mbit/s) on the Gbit-capable dsa
> interfaces (mt753x connected) behind the mac, but now the Gigabit speed is no more reached.
> I see no CRC/dropped packets, retransmitts or similar.
> 
> after reverting the commit above i get 940Mbit like in rx direction, but this will introduce the problems mentioned above so this not a complete fix.
I don't have a BPI-R2, but I tested on BPI-R3 and can't reproduce this 
issue. Do you see it on all ports, or only on specific ones?

- Felix
