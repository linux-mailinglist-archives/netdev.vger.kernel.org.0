Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD5E620BFB
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 10:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbiKHJUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 04:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232929AbiKHJUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 04:20:17 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E211B24080;
        Tue,  8 Nov 2022 01:20:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=YvWOIeTi71vabpR6493wGrzLeEBRKv4j+zJ6SoJE8jA=; b=Ht7+vQH7kQeKDWAOw7T1p8pXNv
        rmAFDdlK9cAx0c2Yz5jJ2hAm5uHvmRZaOChXwO1HNLB0q6IvIKAE9Cgfs4f4iuqZVnpuYb+OgmH96
        wPJ2eCjc3mxdKm9wo3FWETneYsonVU8NW4Hz/39u8+OhRilw1E5sNrOZamR+rHmpmnpM=;
Received: from p200300daa72ee1006d973cebf3767a25.dip0.t-ipconnect.de ([2003:da:a72e:e100:6d97:3ceb:f376:7a25] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1osKm2-000Tnt-BU; Tue, 08 Nov 2022 10:20:02 +0100
Message-ID: <d881b744-539b-b625-60d2-6e44a2ce52b2@nbd.name>
Date:   Tue, 8 Nov 2022 10:20:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.2
Subject: Re: [PATCH 05/14] net: dsa: tag_mtk: assign per-port queues
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20221107185452.90711-1-nbd@nbd.name>
 <20221107185452.90711-5-nbd@nbd.name> <20221107212209.4pmoctkze4m2ggbv@skbuf>
 <f714f3e2-44b0-e0f9-0b99-2878ec12cb56@nbd.name>
 <20221108075816.wsn2olii2lzcq7tf@skbuf>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <20221108075816.wsn2olii2lzcq7tf@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.11.22 08:58, Vladimir Oltean wrote:
> On Tue, Nov 08, 2022 at 07:01:29AM +0100, Felix Fietkau wrote:
>> On 07.11.22 22:22, Vladimir Oltean wrote:
>> > On Mon, Nov 07, 2022 at 07:54:43PM +0100, Felix Fietkau wrote:
>> > > Keeps traffic sent to the switch within link speed limits
>> > > 
>> > > Signed-off-by: Felix Fietkau <nbd@nbd.name>
>> > > ---
>> > >  net/dsa/tag_mtk.c | 3 +++
>> > >  1 file changed, 3 insertions(+)
>> > > 
>> > > diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
>> > > index 415d8ece242a..445d6113227f 100644
>> > > --- a/net/dsa/tag_mtk.c
>> > > +++ b/net/dsa/tag_mtk.c
>> > > @@ -25,6 +25,9 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
>> > >  	u8 xmit_tpid;
>> > >  	u8 *mtk_tag;
>> > > +	/* Reserve the first three queues for packets not passed through DSA */
>> > > +	skb_set_queue_mapping(skb, 3 + dp->index);
>> > > +
>> > 
>> > Should DSA have to care about this detail, or could you rework your
>> > mtk_select_queue() procedure to adjust the queue mapping as needed?
>> I'm setting the queue here so that I don't have to add the extra overhead of
>> parsing the payload in the ethernet driver.
>> For passing the queue, I used a similar approach as tag_brcm.c and
>> drivers/net/ethernet/broadcom/bcmsysport.c
> 
> I was just asking if you can't add the 3 elsewhere, since the DSA
> tagging protocol shouldn't care how many MAC IDs the DSA master has.
Sure, that would work. I'll change it in v2.

- Felix
