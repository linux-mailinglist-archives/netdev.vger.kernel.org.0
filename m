Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C496C9656
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 17:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbjCZP44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 11:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjCZP44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 11:56:56 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE18421A
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 08:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=+AXPiAWza00ARkOCvCqKwSYXvCy2JgFcE6OKdkwmmoU=; b=MJenijjLiKPQZ6HyJHqzeax5PA
        xV3XKKAxboCO2yGJ1C5cQEq5/3xkEtAtLlwf7XQb33DJzgX1buqpHlGsbarl/svSHATykGfbNrmbq
        3EojSki8NtLzEHknmamsKYZ9Ais7W+e3oWyHOC5+SHS9viiSHoHv0WyXNsYHZL9KwKDI=;
Received: from p54ae9730.dip0.t-ipconnect.de ([84.174.151.48] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pgSjj-0073hR-EV; Sun, 26 Mar 2023 17:56:51 +0200
Message-ID: <2e7464a7-a020-f270-4bc7-c8ef47188dcd@nbd.name>
Date:   Sun, 26 Mar 2023 17:56:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: Aw: [PATCH net] net: ethernet: mtk_eth_soc: fix tx throughput
 regression with direct 1G links
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     netdev@vger.kernel.org, Daniel Golle <daniel@makrotopia.org>
References: <20230324140404.95745-1-nbd@nbd.name>
 <trinity-84b79570-2de7-496a-870e-a9678a55f4a4-1679736481816@3c-app-gmx-bap48>
Content-Language: en-US
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <trinity-84b79570-2de7-496a-870e-a9678a55f4a4-1679736481816@3c-app-gmx-bap48>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.03.23 10:28, Frank Wunderlich wrote:
>> Gesendet: Freitag, 24. März 2023 um 15:04 Uhr
>> Von: "Felix Fietkau" <nbd@nbd.name>
>> An: netdev@vger.kernel.org
>> Cc: "Frank Wunderlich" <frank-w@public-files.de>, "Daniel Golle" <daniel@makrotopia.org>
>> Betreff: [PATCH net] net: ethernet: mtk_eth_soc: fix tx throughput regression with direct 1G links
>>
>> Using the QDMA tx scheduler to throttle tx to line speed works fine for
>> switch ports, but apparently caused a regression on non-switch ports.
>> 
>> Based on a number of tests, it seems that this throttling can be safely
>> dropped without re-introducing the issues on switch ports that the
>> tx scheduling changes resolved.
>> 
>> Link: https://lore.kernel.org/netdev/trinity-92c3826f-c2c8-40af-8339-bc6d0d3ffea4-1678213958520@3c-app-gmx-bs16/
>> Fixes: f63959c7eec3 ("net: ethernet: mtk_eth_soc: implement multi-queue support for per-port queues")
>> Reported-by: Frank Wunderlich <frank-w@public-files.de>
>> Reported-by: Daniel Golle <daniel@makrotopia.org>
>> Tested-by: Daniel Golle <daniel@makrotopia.org>
>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>> ---
>>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 --
>>  1 file changed, 2 deletions(-)
>> 
>> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
>> index a94aa08515af..282f9435d5ff 100644
>> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
>> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
>> @@ -763,8 +763,6 @@ static void mtk_mac_link_up(struct phylink_config *config,
>>  		break;
>>  	}
>>  
>> -	mtk_set_queue_speed(mac->hw, mac->id, speed);
>> -
>>  	/* Configure duplex */
>>  	if (duplex == DUPLEX_FULL)
>>  		mcr |= MAC_MCR_FORCE_DPX;
> 
> thx for the fix, as daniel already checked it on mt7986/bpi-r3 i tested bpi-r2/mt7623
> 
> but unfortunately it does not fix issue on bpi-r2 where the gmac0/mt7530 part is affected.
> 
> maybe it needs a special handling like you do for mt7621? maybe it is because the trgmii mode used on this path?
Could you please test if making it use the MT7621 codepath brings back 
performance? I don't have any MT7623 hardware for testing right now.

- Felix
