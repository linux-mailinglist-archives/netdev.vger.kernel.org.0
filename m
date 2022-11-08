Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00459620954
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 07:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232736AbiKHGI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 01:08:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiKHGIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 01:08:55 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086A11903F;
        Mon,  7 Nov 2022 22:08:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:From
        :References:Cc:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lX5dMwSe9Rd96LMOZpp+mMM/r5G59N9f2OpAHzfo0S8=; b=TqDgqa/uRNm3NQaCoOHCBw2D9F
        D5ZwGLJ1KIbRl1UGDVy3ISajP1Z66EbqD8/RSxrFKIWLBTGu0Vq+uY/JdmkUGH260KZJ+pQrYNouT
        1cFRrfxb6UYA2POZJuzK4oyknOtNPX2RXuR9+MuuRoJ7p1WKOgW75vnOhGjCTssK0x8Q=;
Received: from p200300daa72ee1006d973cebf3767a25.dip0.t-ipconnect.de ([2003:da:a72e:e100:6d97:3ceb:f376:7a25] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1osHmw-000S3b-VA; Tue, 08 Nov 2022 07:08:47 +0100
Message-ID: <3b275dda-39ac-282d-8a46-d3a95fdfc766@nbd.name>
Date:   Tue, 8 Nov 2022 07:08:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.2
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
References: <20221107185452.90711-1-nbd@nbd.name>
 <20221107185452.90711-8-nbd@nbd.name> <20221107215745.ascdvnxqrbw4meuv@skbuf>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH 08/14] net: vlan: remove invalid VLAN protocol warning
In-Reply-To: <20221107215745.ascdvnxqrbw4meuv@skbuf>
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

On 07.11.22 22:57, Vladimir Oltean wrote:
> On Mon, Nov 07, 2022 at 07:54:46PM +0100, Felix Fietkau wrote:
>> On MTK SoC ethernet, using NETIF_F_HW_VLAN_CTAG_RX in combination with hardware
>> special tag parsing can pass the special tag port metadata as VLAN protocol ID.
>> When the results is added as a skb hwaccel VLAN tag, it triggers a warning from
>> vlan_do_receive before calling the DSA tag receive function.
>> Remove this warning in order to properly pass the tag to the DSA receive function,
>> which will parse and clear it.
>> 
>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>> ---
>>  net/8021q/vlan.h | 1 -
>>  1 file changed, 1 deletion(-)
>> 
>> diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
>> index 5eaf38875554..3f9c0406b266 100644
>> --- a/net/8021q/vlan.h
>> +++ b/net/8021q/vlan.h
>> @@ -44,7 +44,6 @@ static inline int vlan_proto_idx(__be16 proto)
>>  	case htons(ETH_P_8021AD):
>>  		return VLAN_PROTO_8021AD;
>>  	default:
>> -		WARN(1, "invalid VLAN protocol: 0x%04x\n", ntohs(proto));
> 
> Why would you ever want to remove a warning that's telling you you're
> doing something wrong?
> 
> Aren't you calling __vlan_hwaccel_put_tag() with the wrong thing (i.e.
> htons(RX_DMA_VPID()) as opposed to VPID translated to something
> digestible by the rest of the network stack.. ETH_P_8021Q, ETH_P_8021AD
> etc)?
The MTK ethernet hardware treats the DSA special tag as a VLAN tag and 
reports it as such. The ethernet driver passes this on as a hwaccel tag, 
and the MTK DSA tag parser consumes it. The only thing that's sitting in 
the middle looking at the tag is the VLAN device lookup with that warning.

Whenever DSA is not being used, the MTK ethernet device can also process 
regular VLAN tags. For those tags, htons(RX_DMA_VPID()) will contain the 
correct VPID.

- Felix
