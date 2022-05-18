Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3793352BF4D
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 18:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234924AbiERPue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 11:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239576AbiERPu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 11:50:28 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BBD81AD5A6;
        Wed, 18 May 2022 08:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=AxGKppWlRg07ibPtm9JtC/mczsyRpsvSQ8tFDglsXkw=; b=gLgVc4J/yJJ6I9i9le3X3m8ocP
        g8B0aRhnJJKgV/FnkAQ8YDl1dsHgwts2s2Rk0L99d//q1BnosO5EFzL1iZdoOI0wx4ABtIcrlNw3j
        T+1t5YsxXZTouDGmLUoHYqZ4z9bY0oCtJsR6BeNWJ6uxSAgyoXtGkMLq4OLWck4KlbyI=;
Received: from p200300daa70ef200246e420c06f77770.dip0.t-ipconnect.de ([2003:da:a70e:f200:246e:420c:6f7:7770] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1nrLwD-0007J1-I9; Wed, 18 May 2022 17:50:13 +0200
Message-ID: <4b3283c7-772f-9969-b3c6-d28b4c032326@nbd.name>
Date:   Wed, 18 May 2022 17:50:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH v2 net-next 12/15] net: ethernet: mtk_eth_soc: introduce
 MTK_NETSYS_V2 support
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        robh@kernel.org, lorenzo.bianconi@redhat.com
References: <cover.1652716741.git.lorenzo@kernel.org>
 <cc1bd411e3028e2d6b0365ed5d29f3cea66223f8.1652716741.git.lorenzo@kernel.org>
 <20220517184433.3cb2fd5a@kernel.org> <YoTCCAKpE5ijiom0@lore-desk>
 <20220518084740.7947b51b@kernel.org>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <20220518084740.7947b51b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.05.22 17:47, Jakub Kicinski wrote:
> On Wed, 18 May 2022 11:53:12 +0200 Lorenzo Bianconi wrote:
>> > > +	WRITE_ONCE(desc->txd7, 0);
>> > > +	WRITE_ONCE(desc->txd8, 0);  
>> > 
>> > Why all the WRITE_ONCE()? Don't you just need a barrier between writing
>> > the descriptor and kicking the HW?   
>> 
>> I used this approach just to be aligned with current codebase:
>> https://github.com/torvalds/linux/blob/master/drivers/net/ethernet/mediatek/mtk_eth_soc.c#L1006
>> https://github.com/torvalds/linux/blob/master/drivers/net/ethernet/mediatek/mtk_eth_soc.c#L1031
>> 
>> but I guess we can even convert the code to use barrier instead. Agree?
> 
> Oh, I didn't realize. No preference on converting the old code
> but it looks like a cargo cult to me so in the new code let's
> not WRITE_ONCE() all descriptor writes unless there's a reason.
If I remember correctly, the existing places use WRITE_ONCE to prevent 
write tearing to uncached memory.

- Felix
