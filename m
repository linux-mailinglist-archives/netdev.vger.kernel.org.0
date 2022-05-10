Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03DEA52269B
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 00:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbiEJWGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 18:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiEJWGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 18:06:44 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870451E7;
        Tue, 10 May 2022 15:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:
        From:References:Cc:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe
        :List-Post:List-Owner:List-Archive;
        bh=BhPDuCZhU013enU/ezL39tFkaksHmV+NLwg0WAYz1Ww=; b=KOt0bgXFpEGiFG29hcGikLWsBW
        kCtuR/Jf4HUtRukiWGZZ1fBe+6W/yhShGpA69RR/Y72BX/9p/jbPkkuYkMJpxrcEXQ3SA/KurEZnb
        vuhmwEz1Tmy5Qm5pElBsb3TqqpBXYHmILip3WOveBFZhHS7IAQSoX8W7oAiPasydoDkQ=;
Received: from p200300daa70ef200adfdb724d8b39c56.dip0.t-ipconnect.de ([2003:da:a70e:f200:adfd:b724:d8b3:9c56] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1noXzv-0001pa-2S; Wed, 11 May 2022 00:06:27 +0200
Message-ID: <bc4bde22-c2d6-1ded-884a-69465b9d1dc7@nbd.name>
Date:   Wed, 11 May 2022 00:06:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20220510094014.68440-1-nbd@nbd.name>
 <20220510123724.i2xqepc56z4eouh2@skbuf>
 <5959946d-1d34-49b9-1abe-9f9299cc194e@nbd.name>
 <20220510165233.yahsznxxb5yq6rai@skbuf>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v2] net: dsa: tag_mtk: add padding for tx packets
In-Reply-To: <20220510165233.yahsznxxb5yq6rai@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10.05.22 18:52, Vladimir Oltean wrote:
> On Tue, May 10, 2022 at 04:52:16PM +0200, Felix Fietkau wrote:
>> 
>> On 10.05.22 14:37, Vladimir Oltean wrote:
>> > On Tue, May 10, 2022 at 11:40:13AM +0200, Felix Fietkau wrote:
>> > > Padding for transmitted packets needs to account for the special tag.
>> > > With not enough padding, garbage bytes are inserted by the switch at the
>> > > end of small packets.
>> > 
>> > I don't think padding bytes are guaranteed to be zeroes. Aren't they
>> > discarded? What is the issue?
>> With the broken padding, ARP requests are silently discarded on the receiver
>> side in my test. Adding the padding explicitly fixes the issue.
>> 
>> - Felix
> 
> Ok, I'm not going to complain too much about the patch, but I'm still
> curious where are the so-called "broken" packets discarded.
> I think the receiving MAC should be passing up to software a buffer
> without the extra padding beyond the L2 payload length (at least that's
> the behavior I'm familiar with).

I don't know where exactly these packets are discarded.
After digging through the devices I used during the tests, I just found 
some leftover pcap files that show the differences in the received 
packets. Since the packets are bigger after my patch, I can't rule out 
that packet size instead of the padding may have made a difference here 
in getting the ARP requests accepted by the receiver.

I've extracted the ARP requests and you can find them here:
http://nbd.name/arp-broken.pcap
http://nbd.name/arp-working.pcap

- Felix
