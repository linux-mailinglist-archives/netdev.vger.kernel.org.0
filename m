Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C457F5A074B
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 04:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233321AbiHYC3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 22:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiHYC3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 22:29:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF5C923CC
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 19:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661394542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3jF59bnxqmLklAHzEtiDUVdu2dFyXPidcFRU+bKjDi8=;
        b=fzrZk6zDD6cTCwsb8Svu/5mCF6WPncS4iIHhY5vZQH/jlqJlT2MLZgfh6uulsbgYbE+75F
        PlrLHIFbayr4qPhD/UQl32SwZKpLeZQstM8Gzslz+8Uv6he8vdAYKN2VZcOfwh0bCuEZfE
        eiTMf7Q66GlH2rfsWYqzSOqi9nkQ6Xg=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-675-pz3AZLGuOmCEbPuD9WFgEQ-1; Wed, 24 Aug 2022 22:29:01 -0400
X-MC-Unique: pz3AZLGuOmCEbPuD9WFgEQ-1
Received: by mail-qt1-f200.google.com with SMTP id k9-20020ac80749000000b0034302b53c6cso14365084qth.22
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 19:29:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=3jF59bnxqmLklAHzEtiDUVdu2dFyXPidcFRU+bKjDi8=;
        b=nVd85r2QLUCa38dQsqk+sEYUKWx5QwE6kfOjzamXOrLPgpNFyPlaQZNa+g1sVCc2c1
         76SB5+zTnB8lJio7aBK67b3pZsekKnX1IqlIPq2902tUAah6WEk50xLheKpH+OaHWLl4
         Bb8DFZNmOm5Hvq1MbBf+EFn+x/9ByxN06kOIpuqkes0dNiJUq3T4SgxcwGThjga0TqaE
         mTOBtbKYfg0i/iz/aSZ8JXSwc85T6EAgUn6OW0r2mrUT9r3BGUoe29gPMx6MPk/rrECj
         KZKLu1C80eaE07G3LbRpvwst89FIsUQi8NSWt2GIbhE5K3OljE/3EKZAVi5jojfuUzAH
         jGoA==
X-Gm-Message-State: ACgBeo0E/WUYF2cA7hm0G8P3dyZ8d3xWb6fLaXj2KZjvSy/L2iauxqf/
        XQ5t2IdKomVW4j0En3X+NxoZpn80EvRAR6Z3IfMJOg+1ie1eiMAk7kfaeGhmGcnADoVrmQXs4/z
        cXaXTO3htqF/8lZJa
X-Received: by 2002:a05:620a:15d8:b0:6ba:c5e3:871c with SMTP id o24-20020a05620a15d800b006bac5e3871cmr1623881qkm.572.1661394540635;
        Wed, 24 Aug 2022 19:29:00 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7bG3MtOEQ+X7T87Nh1NCt7nYPw5iq5/sxiSvBa1Ay1+p2Ifdl6EoR7sD1MulRuITnPNRG2bw==
X-Received: by 2002:a05:620a:15d8:b0:6ba:c5e3:871c with SMTP id o24-20020a05620a15d800b006bac5e3871cmr1623874qkm.572.1661394540422;
        Wed, 24 Aug 2022 19:29:00 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id j12-20020a05620a288c00b006b61b2cb1d2sm16492780qkp.46.2022.08.24.19.28.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Aug 2022 19:28:59 -0700 (PDT)
Message-ID: <320c2a05-e99a-88b4-2f67-11210ae37903@redhat.com>
Date:   Wed, 24 Aug 2022 22:28:58 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH net-next v2] bonding: Remove unnecessary check
Content-Language: en-US
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>
Cc:     vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        huyd12@chinatelecom.cn, Jay Vosburgh <j.vosburgh@gmail.com>
References: <20220824111712.5999-1-sunshouxin@chinatelecom.cn>
 <CAAoacNmKa5oM10J6DTLJ6PANmdS8k80Lcxygv_vXd_0DduXM4A@mail.gmail.com>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <CAAoacNmKa5oM10J6DTLJ6PANmdS8k80Lcxygv_vXd_0DduXM4A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/24/22 14:07, Jay Vosburgh wrote:
> On 8/24/22, Sun Shouxin <sunshouxin@chinatelecom.cn> wrote:
>> This code is intended to support bond alb interface added to
>> Linux bridge by modifying MAC, however, it doesn't work for
>> one bond alb interface with vlan added to bridge.
>> Since commit d5410ac7b0ba("net:bonding:support balance-alb
>> interface with vlan to bridge"), new logic is adapted to handle
>> bond alb with or without vlan id, and then the code is deprecated.
> 
> I think this could still be clearer; the actual changes relate to the stack of
> interfaces (e.g., eth0 -> bond0 -> vlan123 -> bridge0), not what VLAN tags
> incoming traffic contains.
> 
> The code being removed here is specifically for the case of
> eth0 -> bond0 -> bridge0, without an intermediate VLAN interface
> in the stack (because, if memory serves, netif_is_bridge_port doesn't
> transfer through to the bond if there's a VLAN interface in between).
> 
> Also, this code is for incoming traffic, assigning the bond's MAC to
> traffic arriving on interfaces other than the active interface (which bears
> the bond's MAC in alb mode; the other interfaces have different MACs).
> Commit d5410ac7b0ba affects the balance assignments for outgoing ARP
> traffic.  I'm not sure that d5410 is an exact replacement for the code this
> patch removes.

I would be more comfortable with a change like this if it can be 
demonstrated that an example test case functions as expected before and 
after the change. Could a selftests test be written with veths to 
demonstrate this code is indeed redundant?

-Jon

> 
>>
>> Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
>> Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
>> ---
>>   drivers/net/bonding/bond_main.c | 13 -------------
>>   1 file changed, 13 deletions(-)
>>
>> diff --git a/drivers/net/bonding/bond_main.c
>> b/drivers/net/bonding/bond_main.c
>> index 50e60843020c..6b0f0ce9b9a1 100644
>> --- a/drivers/net/bonding/bond_main.c
>> +++ b/drivers/net/bonding/bond_main.c
>> @@ -1578,19 +1578,6 @@ static rx_handler_result_t bond_handle_frame(struct
>> sk_buff **pskb)
>>
>>   	skb->dev = bond->dev;
>>
>> -	if (BOND_MODE(bond) == BOND_MODE_ALB &&
>> -	    netif_is_bridge_port(bond->dev) &&
>> -	    skb->pkt_type == PACKET_HOST) {
>> -
>> -		if (unlikely(skb_cow_head(skb,
>> -					  skb->data - skb_mac_header(skb)))) {
>> -			kfree_skb(skb);
>> -			return RX_HANDLER_CONSUMED;
>> -		}
>> -		bond_hw_addr_copy(eth_hdr(skb)->h_dest, bond->dev->dev_addr,
>> -				  bond->dev->addr_len);
>> -	}
>> -
>>   	return ret;
>>   }
>>
>> --
>> 2.27.0
>>
>>
> 

