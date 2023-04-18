Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 929EB6E642B
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 14:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbjDRMql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 08:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232018AbjDRMqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 08:46:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE17914F4E
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 05:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681821957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pDXDjF1nYY/KD56jlqYvE6WKgtxK7sp+U3MRycfCfiA=;
        b=X0mdOLUZphru6oWf3HZuDdwA43COkv/8YA8IKKOQre4A3GatajIy4yxcjSkyMz8GvVps/c
        FgmcTWjYRBCw/62pGq3nbn/Lu2QsxtEobOBBO8YQMmcn0HP8CahQthbLWa5mmBuR6+5Rhn
        yb7AmZF3Zu8kVrjhtEDDhTcH122KB+w=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-488-8gf0u-U8Pn60n4BKxLNoYQ-1; Tue, 18 Apr 2023 08:45:56 -0400
X-MC-Unique: 8gf0u-U8Pn60n4BKxLNoYQ-1
Received: by mail-ed1-f69.google.com with SMTP id u19-20020a50a413000000b0050670a8cb7dso8563192edb.13
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 05:45:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681821955; x=1684413955;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pDXDjF1nYY/KD56jlqYvE6WKgtxK7sp+U3MRycfCfiA=;
        b=NjlpQc/tXsBW/r9Xmaz7nR9cqc0tXOCAqVCc94yC6sN+Hm8/zKofrlIXCRMF8wB17S
         Sph59q9SvO50PeuYQXLSKqN0YTjSx+zArnSbGiX04ktmiOrnbUWXOMSKBbxDEVzJRyLT
         iXTqWwGAgYfuBJrOHsyIxw3IuMT6zxKH7Q6kZIPgh/+nssTiXVh4JYCRIgGyN/cJfZ1H
         UbDwqEcSnVlSWRmVn3BMJLhE9fMsKOvH40Ia5d6+y2pRnkhF955JgNJoGHkg9vZpAedz
         KDDHUF2Lk04EdjJyElBqmBwOCWASu2WHD509hgYhKGUT7HtGgLQdK0tAECw7BFl0pa1o
         ivfA==
X-Gm-Message-State: AAQBX9euZPllKsofJwEx4FLfTU2G1ssqAnG5yVbFWxHbntMZuP/PYRGk
        1qlD5aJ2tJLA/ey/uYqRvYKoAII/MvC5l+ZGsC5Jf84G2aQeis3isvyP0oGkQlUYbGW8b8Q7ozE
        Ss0i7d6M3KqHAJiPB
X-Received: by 2002:a17:907:20c8:b0:93c:efaf:ba75 with SMTP id qq8-20020a17090720c800b0093cefafba75mr10178442ejb.37.1681821955283;
        Tue, 18 Apr 2023 05:45:55 -0700 (PDT)
X-Google-Smtp-Source: AKy350aiC5zCA5YAs3FTtyCXVLr/PBTq902GZqsOW+OujaYsI0J5kBFLBO9dijp8pa5nkXMHxAU4EA==
X-Received: by 2002:a17:907:20c8:b0:93c:efaf:ba75 with SMTP id qq8-20020a17090720c800b0093cefafba75mr10178419ejb.37.1681821954909;
        Tue, 18 Apr 2023 05:45:54 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id rx22-20020a1709068e1600b0094f968ecc97sm2304338ejc.13.2023.04.18.05.45.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 05:45:54 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <6b04def5-a3aa-1f77-b29d-bea4845e2678@redhat.com>
Date:   Tue, 18 Apr 2023 14:45:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "martin.lau@kernel.org" <martin.lau@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "Lobakin, Aleksander" <aleksander.lobakin@intel.com>,
        "Zaremba, Larysa" <larysa.zaremba@intel.com>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH bpf-next V1 2/5] igc: add igc_xdp_buff wrapper for
 xdp_buff in driver
Content-Language: en-US
To:     "Song, Yoong Siang" <yoong.siang.song@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>
References: <168174338054.593471.8312147519616671551.stgit@firesoul>
 <168174343294.593471.10523474360770220196.stgit@firesoul>
 <PH0PR11MB5830DD3BA9F6CBDA648F5AF8D89D9@PH0PR11MB5830.namprd11.prod.outlook.com>
In-Reply-To: <PH0PR11MB5830DD3BA9F6CBDA648F5AF8D89D9@PH0PR11MB5830.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 18/04/2023 06.34, Song, Yoong Siang wrote:
> On Monday, April 17, 2023 10:57 PM, Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>> Driver specific metadata data for XDP-hints kfuncs are propagated via tail
>> extending the struct xdp_buff with a locally scoped driver struct.
>>
>> Zero-Copy AF_XDP/XSK does similar tricks via struct xdp_buff_xsk. This
>> xdp_buff_xsk struct contains a CB area (24 bytes) that can be used for extending
>> the locally scoped driver into. The XSK_CHECK_PRIV_TYPE define catch size
>> violations build time.
>>
> 
> Since the main purpose of this patch is to introduce igc_xdp_buff, and
> you have another two patches for timestamp and hash,
> thus, suggest to move timestamp and hash related code into respective patches.
> 
>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>> ---
>> drivers/net/ethernet/intel/igc/igc.h      |    6 ++++++
>> drivers/net/ethernet/intel/igc/igc_main.c |   30 ++++++++++++++++++++++-------
>> 2 files changed, 29 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/igc/igc.h
>> b/drivers/net/ethernet/intel/igc/igc.h
>> index f7f9e217e7b4..c609a2e648f8 100644
>> --- a/drivers/net/ethernet/intel/igc/igc.h
>> +++ b/drivers/net/ethernet/intel/igc/igc.h
>> @@ -499,6 +499,12 @@ struct igc_rx_buffer {
>> 	};
>> };
>>
>> +/* context wrapper around xdp_buff to provide access to descriptor
>> +metadata */ struct igc_xdp_buff {
>> +	struct xdp_buff xdp;
>> +	union igc_adv_rx_desc *rx_desc;
> 
> Move rx_desc to 4th patch (Rx hash patch)
> 

Hmm, rx_desc is also needed by 3rd patch (Rx timestamp), so that would 
break...

I can reorder patches, and have "Rx hash patch" come before "Rx 
timestamp" patch.


>> +};
>> +
>> struct igc_q_vector {
>> 	struct igc_adapter *adapter;    /* backlink */
>> 	void __iomem *itr_register;
>> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c
>> b/drivers/net/ethernet/intel/igc/igc_main.c
>> index bfa9768d447f..3a844cf5be3f 100644
>> --- a/drivers/net/ethernet/intel/igc/igc_main.c
>> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
>> @@ -2236,6 +2236,8 @@ static bool igc_alloc_rx_buffers_zc(struct igc_ring
>> *ring, u16 count)
>> 	if (!count)
>> 		return ok;
>>
>> +	XSK_CHECK_PRIV_TYPE(struct igc_xdp_buff);
>> +
>> 	desc = IGC_RX_DESC(ring, i);
>> 	bi = &ring->rx_buffer_info[i];
>> 	i -= ring->count;
>> @@ -2520,8 +2522,8 @@ static int igc_clean_rx_irq(struct igc_q_vector
>> *q_vector, const int budget)
>> 		union igc_adv_rx_desc *rx_desc;
>> 		struct igc_rx_buffer *rx_buffer;
>> 		unsigned int size, truesize;
>> +		struct igc_xdp_buff ctx;
>> 		ktime_t timestamp = 0;
>> -		struct xdp_buff xdp;
>> 		int pkt_offset = 0;
>> 		void *pktbuf;
>>
>> @@ -2555,13 +2557,14 @@ static int igc_clean_rx_irq(struct igc_q_vector
>> *q_vector, const int budget)
>> 		}
>>
>> 		if (!skb) {
>> -			xdp_init_buff(&xdp, truesize, &rx_ring->xdp_rxq);
>> -			xdp_prepare_buff(&xdp, pktbuf - igc_rx_offset(rx_ring),
>> +			xdp_init_buff(&ctx.xdp, truesize, &rx_ring->xdp_rxq);
>> +			xdp_prepare_buff(&ctx.xdp, pktbuf - igc_rx_offset(rx_ring),
>> 					 igc_rx_offset(rx_ring) + pkt_offset,
>> 					 size, true);
>> -			xdp_buff_clear_frags_flag(&xdp);
>> +			xdp_buff_clear_frags_flag(&ctx.xdp);
>> +			ctx.rx_desc = rx_desc;
> 
> Move rx_desc to 4th patch (Rx hash patch)

Again would break 3rd patch.

> 
>>
>> -			skb = igc_xdp_run_prog(adapter, &xdp);
>> +			skb = igc_xdp_run_prog(adapter, &ctx.xdp);
>> 		}
>>
>> 		if (IS_ERR(skb)) {
>> @@ -2583,9 +2586,9 @@ static int igc_clean_rx_irq(struct igc_q_vector
>> *q_vector, const int budget)
>> 		} else if (skb)
>> 			igc_add_rx_frag(rx_ring, rx_buffer, skb, size);
>> 		else if (ring_uses_build_skb(rx_ring))
>> -			skb = igc_build_skb(rx_ring, rx_buffer, &xdp);
>> +			skb = igc_build_skb(rx_ring, rx_buffer, &ctx.xdp);
>> 		else
>> -			skb = igc_construct_skb(rx_ring, rx_buffer, &xdp,
>> +			skb = igc_construct_skb(rx_ring, rx_buffer, &ctx.xdp,
>> 						timestamp);
>>
>> 		/* exit if we failed to retrieve a buffer */ @@ -2686,6 +2689,15
>> @@ static void igc_dispatch_skb_zc(struct igc_q_vector *q_vector,
>> 	napi_gro_receive(&q_vector->napi, skb);  }
>>
>> +static struct igc_xdp_buff *xsk_buff_to_igc_ctx(struct xdp_buff *xdp) {
>> +	/* xdp_buff pointer used by ZC code path is alloc as xdp_buff_xsk. The
>> +	 * igc_xdp_buff shares its layout with xdp_buff_xsk and private
>> +	 * igc_xdp_buff fields fall into xdp_buff_xsk->cb
>> +	 */
>> +       return (struct igc_xdp_buff *)xdp; }
>> +
> 
> Move xsk_buff_to_igc_ctx to 3th patch (timestamp patch), which is first patch
> adding xdp_metadata_ops support to igc.
> 

Hmm, maybe, but that make the "wrapper" patch incomplete and then it
gets "completed" in the first patch that adds a xdp_metadata_ops.

>> static int igc_clean_rx_irq_zc(struct igc_q_vector *q_vector, const int budget)  {
>> 	struct igc_adapter *adapter = q_vector->adapter; @@ -2704,6 +2716,7
>> @@ static int igc_clean_rx_irq_zc(struct igc_q_vector *q_vector, const int
>> budget)
>> 	while (likely(total_packets < budget)) {
>> 		union igc_adv_rx_desc *desc;
>> 		struct igc_rx_buffer *bi;
>> +		struct igc_xdp_buff *ctx;
>> 		ktime_t timestamp = 0;
>> 		unsigned int size;
>> 		int res;
>> @@ -2721,6 +2734,9 @@ static int igc_clean_rx_irq_zc(struct igc_q_vector
>> *q_vector, const int budget)
>>
>> 		bi = &ring->rx_buffer_info[ntc];
>>
>> +		ctx = xsk_buff_to_igc_ctx(bi->xdp);
> 
> Move xsk_buff_to_igc_ctx to 3th patch (timestamp patch), which is first patch
> adding xdp_metadata_ops support to igc.
>
Sure, but it feels wrong to no "complete" the wrapper work in the
wrapper patch.

>> +		ctx->rx_desc = desc;
> 
> Move rx_desc to 4th patch (Rx hash patch)
> 

I'll reorder patch 3 and 4, else it doesn't make any sense to gradually
introduce the members in wrapper struct igc_xdp_buff.

--Jesper

