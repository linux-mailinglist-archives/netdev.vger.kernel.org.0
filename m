Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4716C32E4
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 14:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbjCUNaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 09:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbjCUNaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 09:30:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534DE2FCE9
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 06:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679405350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KBT69eGsdJbkXc2Kqm0JT5NVzfmXd6DGRkgXONrvjXA=;
        b=NEATk7I3roWkghVc2kf8Qzupqn+XEUGPRpugcljYj+qQLUNcT9t0Y2/7d2ct5TGFQqyr1J
        Tt7Tlb2RnaOFuQVlqoBTxEDxR/zXdN7yIvZ5X99AEQuAkysUiZPatxLEHT+7OyvkoG/xW2
        zRvgnQaQ5fQcTcRVcPorzIqyza06qL0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-411-NhIUXzGlONeDFAzbQQMQxQ-1; Tue, 21 Mar 2023 09:29:07 -0400
X-MC-Unique: NhIUXzGlONeDFAzbQQMQxQ-1
Received: by mail-ed1-f70.google.com with SMTP id b1-20020aa7dc01000000b004ad062fee5eso21819300edu.17
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 06:29:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679405346;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KBT69eGsdJbkXc2Kqm0JT5NVzfmXd6DGRkgXONrvjXA=;
        b=mGyC8POeScDeY5HkH+f8uBKrXC3SKhvCcIaUIQd7EvZwSBjSpbOGzsXrxJUOXbn5om
         X+Hzj6+o9caG/Mq0xP0dcUW6DqC6YXmnsWWEqEAYfDXidCWrkvQI5TNsjkpd2M7jGpHz
         pWwJSMmPkjYfSur01XA5VcvT/OB1wsjBan46/99Frpgf+Oe1boNQKANol7ZvsB5jUIYg
         +SwUcmlW0dTqld+Eb5nOLGTyHYHJ3RhD2iJFAF2Z1zrCKv7COgp7MnGczWC+uXtadfqo
         SGyzdFEVuCDwP6veHwjsvTKruLt5C+Mp+0cvg14ghXHH2obBPhGv2qAKituulHMiHDWC
         yxnA==
X-Gm-Message-State: AO0yUKVqxfE45Z0V2B853LRO62/bGXX5IiEEU7iVxQBHfx0nZwCi5xKR
        A5WkOVNZGZGKSj7d4VqCqmEezhSDIh3skzGFrUEpxCAM8G+L2Q5TG+XmNTkj3dEi3qULKwuOfF9
        MBUZvCoSy5xRbNaFz
X-Received: by 2002:a17:906:2a90:b0:8aa:1f89:122e with SMTP id l16-20020a1709062a9000b008aa1f89122emr2522984eje.39.1679405346360;
        Tue, 21 Mar 2023 06:29:06 -0700 (PDT)
X-Google-Smtp-Source: AK7set8N84f6PrcisRryVo+0pO6902MzYLtcEeH0RYnzA6yc8t+iHYhhZWknIh8hdyjLeghVEQuPjQ==
X-Received: by 2002:a17:906:2a90:b0:8aa:1f89:122e with SMTP id l16-20020a1709062a9000b008aa1f89122emr2522964eje.39.1679405346081;
        Tue, 21 Mar 2023 06:29:06 -0700 (PDT)
Received: from [192.168.42.100] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id z9-20020a1709067e4900b0092be390b51asm5811868ejr.113.2023.03.21.06.29.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 06:29:05 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <5655574a-71b5-79df-890e-81f3bd5e1cc2@redhat.com>
Date:   Tue, 21 Mar 2023 14:29:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        alexandr.lobakin@intel.com, larysa.zaremba@intel.com,
        xdp-hints@xdp-project.net, anthony.l.nguyen@intel.com,
        yoong.siang.song@intel.com, boon.leong.ong@intel.com
Subject: Re: [PATCH bpf-next V1 3/7] selftests/bpf: xdp_hw_metadata track more
 timestamps
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>
References: <167906343576.2706833.17489167761084071890.stgit@firesoul>
 <167906360589.2706833.6188844928251441787.stgit@firesoul>
 <ZBTW+NP1pLPlXRqa@google.com>
In-Reply-To: <ZBTW+NP1pLPlXRqa@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 17/03/2023 22.09, Stanislav Fomichev wrote:
>> diff --git a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c 
>> b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
>> index 4c55b4d79d3d..f2a3b70a9882 100644
>> --- a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
>> +++ b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
>> @@ -69,9 +69,11 @@ int rx(struct xdp_md *ctx)
>>           return XDP_PASS;
>>       }
> 
>> -    if (!bpf_xdp_metadata_rx_timestamp(ctx, &meta->rx_timestamp))
>> -        bpf_printk("populated rx_timestamp with %llu", meta->rx_timestamp);
>> -    else
>> +    if (!bpf_xdp_metadata_rx_timestamp(ctx, &meta->rx_timestamp)) {
>> +        meta->xdp_timestamp = bpf_ktime_get_tai_ns();
>> +        bpf_printk("populated rx_timestamp with  %llu", meta->rx_timestamp);
>> +        bpf_printk("populated xdp_timestamp with %llu", meta->xdp_timestamp);
>> +    } else
>>           meta->rx_timestamp = 0; /* Used by AF_XDP as not avail signal */
> 
> Nit: curly braces around else {} block as well?

Good point, fixed in V2

