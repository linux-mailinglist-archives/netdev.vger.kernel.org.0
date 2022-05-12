Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDB652484B
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 10:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351724AbiELIvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 04:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351742AbiELIvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 04:51:19 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A1356F96;
        Thu, 12 May 2022 01:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:
        From:References:Cc:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe
        :List-Post:List-Owner:List-Archive;
        bh=xx9m5dm8MmD9z6KyI04KVvncdp5gOEhfIk9XzqJfOxg=; b=eRgiK+ggyPqj6IGjUVzf59mDDq
        XpWwjL7Vau9dZb/Lwy3EXBhz8YWsnZ62iBAo3kpWt03/kIwEeOr/fw48fHnUimA0TGDpB6J0e0F0Y
        2HTjAmNI2g5ljskIURDyyufHxpJCi6dSKIuH6K+GETZqT/FG/Bp+6ikLtW9SniX5egb4=;
Received: from p200300daa70ef20035fe11ecec42601a.dip0.t-ipconnect.de ([2003:da:a70e:f200:35fe:11ec:ec42:601a] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1np4XI-0001va-5j; Thu, 12 May 2022 10:51:04 +0200
Message-ID: <0ef1e0c2-1623-070d-fbf5-e7f09fc199ca@nbd.name>
Date:   Thu, 12 May 2022 10:51:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
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
 <bc4bde22-c2d6-1ded-884a-69465b9d1dc7@nbd.name>
 <20220510222101.od3n7gk3cofwhbks@skbuf>
 <376b13ac-d90b-24e0-37ed-a96d8e5f80da@nbd.name>
 <20220511093245.3266lqdze2b4odh5@skbuf> <YnvJFmX+BRscJOtm@lunn.ch>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v2] net: dsa: tag_mtk: add padding for tx packets
In-Reply-To: <YnvJFmX+BRscJOtm@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11.05.22 16:32, Andrew Lunn wrote:
>> Let's see what others have to say. I've been wanting to make the policy
>> of whether to call __skb_put_padto() standardized for all tagging protocol
>> drivers (similar to what is done in dsa_realloc_skb() and below it).
>> We pad for tail taggers, maybe we can always pad and this removes a
>> conditional, and simplifies taggers. Side note, I already dislike that
>> the comment in tag_brcm.c is out of sync with the code. It says that
>> padding up to ETH_ZLEN is necessary, but proceeds to pad up until
>> ETH_ZLEN + tag len, only to add the tag len once more below via skb_push().
>> It would be nice if we could use the simple eth_skb_pad().
> 
> There are some master devices which will perform padding on their own,
> in hardware. So for taggers which insert the header at the head,
> forcing such padding would be a waste of CPU time.
> 
> For tail taggers, padding short packets by default does however make
> sense. The master device is probably going to pad in the wrong way if
> it does padding.
I just ran some more tests, here's what I found:
The switch automatically pads all forwarded packets to 64 bytes.
When packets are forwarded from one external port to another, the 
padding is all zero.
Only when packets are sent from a CPU port to an external port, the last 
4 bytes contain garbage. The garbage bytes are different for every 
packet, and I can't tell if it's leaking contents of previous packets or 
what else is in there.
Based on that, I'm pretty sure that the hardware simply has a quirk 
where it does not account for the special tag when generating its own 
padding internally.

I found that replacing my __skb_put_padto call with eth_skb_pad also 
works, so I'm going to send v3 with that and an updated comment.

- Felix
