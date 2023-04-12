Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C84846DFD12
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 19:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjDLRxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 13:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbjDLRxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 13:53:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D94E6193
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 10:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681321970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iI47pUzxcqmCcEC2rps2dXJyXHbQhHmBAwXMcIIXiyw=;
        b=FkNaT9OQE8iWQTmt3viPdmnXMM+sKHryT2xzWhkv1tPHNsF3LZaqKE9nA/0JYrfMtx42ZQ
        7ZDGJEsgqndP6OlCGwlBGyZFAHk8PSp35Lk17Z5/WPXww8TnjJH5v/xdRkV8MNgEB2Cxua
        NYHA1OsTIzK9iYV564z+i91YQ6utzFc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-46-HXodC2uIOwuLzkaBWqWQrQ-1; Wed, 12 Apr 2023 13:52:49 -0400
X-MC-Unique: HXodC2uIOwuLzkaBWqWQrQ-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5048993067dso9537082a12.0
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 10:52:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681321967; x=1683913967;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iI47pUzxcqmCcEC2rps2dXJyXHbQhHmBAwXMcIIXiyw=;
        b=HEthhQST9aMS3JOKRPeuk+ZsEZ6cqr92ObxQ0UU3TAABhEf3kx/StWhucUBrUe1nCz
         tX7bDSnw9mmr++Ohtx49gI33ax9oNeNlbJF9x3i/mQtpXCj1Z7xcAOL7nqAuvoaejaOL
         IiarYRWPOqPnURWkZjyodo90c+aTqn0hehDnWre1RNEWKrxKGfzGjQTiNv5beJXgldhU
         9D0KQXxcucBHpTJ9SC0k5lI0vvCxFjEh6QfdP/Ms6YEnFuE+wMyxDYh+4LlB1qYv4Ay1
         JhXbor+eulcAgK8+NcHD61dTjoz6/RJEsBYd7Zwgngj/+aoPLOdBiCGBmyMz6eB+gIo9
         i/Rg==
X-Gm-Message-State: AAQBX9e+hhP3TStghiY6DJX08KWjMIYkAtnKrLh5Xqs0HtU9F2cmAjtc
        /jj9sOD3NF8h/xwURi72v7D13dlRE/NPhWmDAzBAq/8SEB/itHYbHyzfyPXlm/wNjPA3Wf0qmva
        wl/SQ7OXr9CiQtiyo
X-Received: by 2002:a05:6402:5186:b0:4bf:b2b1:84d8 with SMTP id q6-20020a056402518600b004bfb2b184d8mr3511167edd.19.1681321967064;
        Wed, 12 Apr 2023 10:52:47 -0700 (PDT)
X-Google-Smtp-Source: AKy350Y0MTpGveF2HoFghji3+UpGQyjGIi40MatPabg821fgSW3yWZotqgAFPc2Jo3Kxr8gD41BAKQ==
X-Received: by 2002:a05:6402:5186:b0:4bf:b2b1:84d8 with SMTP id q6-20020a056402518600b004bfb2b184d8mr3511145edd.19.1681321966733;
        Wed, 12 Apr 2023 10:52:46 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id e14-20020a50d4ce000000b00502b0b0d75csm7149567edj.46.2023.04.12.10.52.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Apr 2023 10:52:46 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <34152b76-88c8-0848-9f30-bd9755b1ee25@redhat.com>
Date:   Wed, 12 Apr 2023 19:52:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, bpf@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        alexandr.lobakin@intel.com, larysa.zaremba@intel.com,
        xdp-hints@xdp-project.net, anthony.l.nguyen@intel.com,
        yoong.siang.song@intel.com, boon.leong.ong@intel.com,
        intel-wired-lan@lists.osuosl.org, pabeni@redhat.com,
        jesse.brandeburg@intel.com, kuba@kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, hawk@kernel.org, davem@davemloft.net,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH bpf V8 2/7] selftests/bpf: Add counters to xdp_hw_metadata
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>
References: <168130333143.150247.11159481574477358816.stgit@firesoul>
 <168130336725.150247.12193228778654006957.stgit@firesoul>
 <ZDbiofWhQhFEfIsr@google.com>
In-Reply-To: <ZDbiofWhQhFEfIsr@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/04/2023 18.56, Stanislav Fomichev wrote:
> On 04/12, Jesper Dangaard Brouer wrote:
>> Add counters for skipped, failed and redirected packets.
>> The xdp_hw_metadata program only redirects UDP port 9091.
>> This helps users to quickly identify then packets are
>> skipped and identify failures of bpf_xdp_adjust_meta.
>>
>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>> ---
>>   .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |   15 +++++++++++++--
>>   tools/testing/selftests/bpf/xdp_hw_metadata.c      |    4 +++-
>>   2 files changed, 16 insertions(+), 3 deletions(-)
>>
>> diff --git a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
>> index b0104763405a..a07ef7534013 100644
>> --- a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
>> +++ b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
>> @@ -25,6 +25,10 @@ struct {
>>   	__type(value, __u32);
>>   } xsk SEC(".maps");
>>   
>> +volatile __u64 pkts_skip = 0;
>> +volatile __u64 pkts_fail = 0;
>> +volatile __u64 pkts_redir = 0;
>> +
>>   extern int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx,
>>   					 __u64 *timestamp) __ksym;
>>   extern int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx,
>> @@ -59,16 +63,21 @@ int rx(struct xdp_md *ctx)
>>   			udp = NULL;
>>   	}
>>   
>> -	if (!udp)
>> +	if (!udp) {
>> +		pkts_skip++;
>>   		return XDP_PASS;
>> +	}
>>   
>>   	/* Forwarding UDP:9091 to AF_XDP */
>> -	if (udp->dest != bpf_htons(9091))
>> +	if (udp->dest != bpf_htons(9091)) {
>> +		pkts_skip++;
>>   		return XDP_PASS;
>> +	}
>>   
>>   	ret = bpf_xdp_adjust_meta(ctx, -(int)sizeof(struct xdp_meta));
>>   	if (ret != 0) {
> 
> [..]
> 
>>   		bpf_printk("bpf_xdp_adjust_meta returned %d", ret);
> 
> Maybe let's remove these completely? Merge patch 1 and 2, remove printk,
> add counters. We can add more counters in the future if the existing
> ones are not enough.. WDYT?
> 

Sure, lets just remove all of the bpf_printk, and add these counter instead.
Rolling V9.

>> +		pkts_fail++;

This fail counter should be enough for driver devel to realize that they
also need to implement/setup XDP metadata pointers correctly (for
bpf_xdp_adjust_meta to work).

>>   		return XDP_PASS;
>>   	}

