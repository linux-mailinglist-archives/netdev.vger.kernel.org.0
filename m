Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9D4B5389D9
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 04:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243514AbiEaCMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 22:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237934AbiEaCMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 22:12:13 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174626D1B7;
        Mon, 30 May 2022 19:12:10 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id n10so12393516pjh.5;
        Mon, 30 May 2022 19:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Y9NpA244q+Ie2cq2saBG14XgicSc5nrLNVGgmrMt+GA=;
        b=f1FcxdztfrWaE6q/q8Ufqq6gaV+5X0i4mDaOYkz0dj+Xy2ace4+KYKZdum2KcpjSSw
         RWhR2xv5megWa63y3JZCyUsZiWnI8/whQLZa5syOATHWZ979yziCp698s7APaqgDnlB7
         +oFxJwcC2Q6wOfMt4h0Wj2UOR8v9Wycc3mxs24+a114TuwOMcGAnxGJq9Tt1wUqOr+qD
         SwPqti2glx2QV0ZtKslccmqgosqkkMkHVVI9lXYPKpnD9w1D1+PakmyOfmsRzPdbssK8
         N8kYVtf64TnnkUAPN09zv1fqLXlHQoAUm3zRyqcEEf2NYYiUSPYmCuzr+OBoDCwONpc4
         9v5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Y9NpA244q+Ie2cq2saBG14XgicSc5nrLNVGgmrMt+GA=;
        b=vSqGu5YVvhSaEJqBmvG2qcWZ43c1FMuziPKQ6wSocf9c4QOEHJPynBQUvr93xKjWVY
         /bpAoRFtjP8Z0q8myuIHZlsYabwAWTfRiVkykWiepoFU1RESEOsAzzYK5zzTdAi5JzuT
         ZEGuGEa510aJmJWMgdgpGbZrOOCac9n2VlQb9pL/3zKdUa3j5D6Sf1XCXJuli4NnHGzc
         WS8e60ndAXOb56qcIgScIzW4AV7HZ8l8BGuIbmuiyJMHceonEkrmzooM4qrdfEAlf+og
         ZtTO1M3ugSjZxsPUssd8r4rB28R7J9ra55GbyMT4x6J5dYaiq70nCOYX/u0yUzZ/Ujhy
         NB9w==
X-Gm-Message-State: AOAM532+GcroJM0DaXNzEroHJrGAujGeAym/pWWrStxKjIGSeRbDoSqS
        +t3cL2FDyaZfBXA+9d+8+F4=
X-Google-Smtp-Source: ABdhPJwLOWEWOmn2m2tJxf+EfxNAA0hyWWh/wOr+aHWR+zFkdT0Gi6tmevwnlE4P2e89lpnD73Hxxw==
X-Received: by 2002:a17:902:9b84:b0:161:db34:61ef with SMTP id y4-20020a1709029b8400b00161db3461efmr57642504plp.138.1653963129471;
        Mon, 30 May 2022 19:12:09 -0700 (PDT)
Received: from [192.168.50.247] ([103.84.139.165])
        by smtp.gmail.com with ESMTPSA id y11-20020a62b50b000000b0051849315ecdsm9237110pfe.48.2022.05.30.19.12.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 May 2022 19:12:09 -0700 (PDT)
Message-ID: <17ce0028-cbf2-20cd-c9ae-16b37ed61924@gmail.com>
Date:   Tue, 31 May 2022 10:12:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] xfrm: xfrm_input: fix a possible memory leak in
 xfrm_input()
Content-Language: en-US
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220530102046.41249-1-hbh25y@gmail.com>
 <20220530103734.GD2517843@gauss3.secunet.de>
From:   Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <20220530103734.GD2517843@gauss3.secunet.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/5/30 18:37, Steffen Klassert wrote:
> On Mon, May 30, 2022 at 06:20:46PM +0800, Hangyu Hua wrote:
>> xfrm_input needs to handle skb internally. But skb is not freed When
>> xo->flags & XFRM_GRO == 0 and decaps == 0.
>>
>> Fixes: 7785bba299a8 ("esp: Add a software GRO codepath")
>> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
>> ---
>>   net/xfrm/xfrm_input.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
>> index 144238a50f3d..6f9576352f30 100644
>> --- a/net/xfrm/xfrm_input.c
>> +++ b/net/xfrm/xfrm_input.c
>> @@ -742,7 +742,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
>>   			gro_cells_receive(&gro_cells, skb);
>>   			return err;
>>   		}
>> -
>> +		kfree_skb(skb);
>>   		return err;
>>   	}
> 
> Did you test this? The function behind the 'afinfo->the transport_finish()'
> pointer handles this skb and frees it in that case.

int xfrm4_transport_finish(struct sk_buff *skb, int async)
{
	struct xfrm_offload *xo = xfrm_offload(skb);
	struct iphdr *iph = ip_hdr(skb);

	iph->protocol = XFRM_MODE_SKB_CB(skb)->protocol;

#ifndef CONFIG_NETFILTER
	if (!async)
		return -iph->protocol;		<--- [1]
#endif
...
	NF_HOOK(NFPROTO_IPV4, NF_INET_PRE_ROUTING,
		dev_net(skb->dev), NULL, skb, skb->dev, NULL,
		xfrm4_rcv_encap_finish);	<--- [2]
	return 0;
}

int xfrm6_transport_finish(struct sk_buff *skb, int async)
{
	struct xfrm_offload *xo = xfrm_offload(skb);
	int nhlen = skb->data - skb_network_header(skb);

	skb_network_header(skb)[IP6CB(skb)->nhoff] =
		XFRM_MODE_SKB_CB(skb)->protocol;

#ifndef CONFIG_NETFILTER
	if (!async)
		return 1;			<--- [3]
#endif
...
	NF_HOOK(NFPROTO_IPV6, NF_INET_PRE_ROUTING,
		dev_net(skb->dev), NULL, skb, skb->dev, NULL,
		xfrm6_transport_finish2);
	return 0;				<--- [4]
}

If transport_finish() return in [1] or [3], there will be a memory leak. 
If it return return in [2] and [4], there will not be a memory leak. It 
look like my patch is incorrect.

How do you think i modify the patch as follows?

    			gro_cells_receive(&gro_cells, skb);
    			return err;
    		}
  -
  +		if (err != 0)
  +			kfree_skb(skb);
    		return err;
    	}



