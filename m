Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3C0E6A956A
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 11:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjCCKj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 05:39:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjCCKj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 05:39:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C63214492
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 02:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677839950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/ZYISymnHUJzQ9oGrozV91eykhzhId/Ob9/Pj/GYOnU=;
        b=hyjGT557X7VACNKsyfzpzz5wJXZxGtv8D7YIKCcHo8JGcKvlFgQ45hoDLs9c7cMl7SpAro
        SjEWsf96SW0pDfSN+hua1qJ+qTmeyJeLQ2Z8jJRbFmUFh+88Yn3zYuuNQ90AJPC4CI41WZ
        DOQDknR86xssLrMPKNl24FCLDY89tEQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-634-cbBVnu9OPe-YUP6CD5X0Pg-1; Fri, 03 Mar 2023 05:39:09 -0500
X-MC-Unique: cbBVnu9OPe-YUP6CD5X0Pg-1
Received: by mail-ed1-f70.google.com with SMTP id w7-20020a056402268700b004bbcdf3751bso3400467edd.1
        for <netdev@vger.kernel.org>; Fri, 03 Mar 2023 02:39:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/ZYISymnHUJzQ9oGrozV91eykhzhId/Ob9/Pj/GYOnU=;
        b=wD3R1O3fhfoAJA21LgwYl7efYuguXKs8hYQ7aQIwQk5QvmWPPNwgpUd5v2xyBYdapx
         5sDOXpLhdiQrPGyHZOu2Bhrw1q8o/EOw40abrEMCph/PXBt8jnvl1h4Bxx9AnETXgbsi
         oruo6vsAKG6auZKQDvrHPjx1tWiAaMwlZt03ACpiixYdxxHkzZLrlJ0f1CvNNhslpswU
         N6x3lC2oPKPWE0NU0U4iqFz/Q7ZlzUv8qtMcsWAs7xHMM3i0NNlBTbZjKnR5RMLtRGQ4
         xjwxewNQeN8S2ki8uk4l2xVSZ9CQE7WfLTEWzONPZkwJXEHZ8toDXlWFonIn3vYhr1o3
         Tcbg==
X-Gm-Message-State: AO0yUKWvEe+r91shHbyUuBBEv4UG+4nJs+B8N/MNCSh8zGTfaLUiztYH
        Ioe74JALXGmLVkWNDdp/hpyri8kprX3KhKX9vbtZ9LKvD/OGhxFSKQNN2zkdWGWoK0HiSGt2LJi
        ZSncR4Cy6ylkyauYF
X-Received: by 2002:a17:906:d0ca:b0:88d:ba89:183a with SMTP id bq10-20020a170906d0ca00b0088dba89183amr4943413ejb.11.1677839948356;
        Fri, 03 Mar 2023 02:39:08 -0800 (PST)
X-Google-Smtp-Source: AK7set8plnpvyHVS2XtWbo4Yk9SK76K0Al5X/5xZLNnTMe4Kr7DlrMRSAMoG9vBm5d4bxXIduPqHdQ==
X-Received: by 2002:a17:906:d0ca:b0:88d:ba89:183a with SMTP id bq10-20020a170906d0ca00b0088dba89183amr4943389ejb.11.1677839948109;
        Fri, 03 Mar 2023 02:39:08 -0800 (PST)
Received: from [192.168.42.100] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id h17-20020a170906399100b008d1dc5f5692sm808927eje.76.2023.03.03.02.39.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Mar 2023 02:39:07 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <22ca47ca-325f-f4df-af5d-344be6b372d8@redhat.com>
Date:   Fri, 3 Mar 2023 11:39:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v1 0/2] xdp: recycle Page Pool backed skbs built
 from XDP frames
Content-Language: en-US
To:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>
References: <20230301160315.1022488-1-aleksander.lobakin@intel.com>
In-Reply-To: <20230301160315.1022488-1-aleksander.lobakin@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 01/03/2023 17.03, Alexander Lobakin wrote:
> Yeah, I still remember that "Who needs cpumap nowadays" (c), but anyway.
> 
> __xdp_build_skb_from_frame() missed the moment when the networking stack
> became able to recycle skb pages backed by a Page Pool. This was making
                                                ^^^^^^^^^
When talking about page_pool, can we write "page_pool" instead of
capitalized "Page Pool", please. I looked through the git log, and here
we all used "page_pool".

> e.g. cpumap redirect even less effective than simple %XDP_PASS. veth was
> also affected in some scenarios.

Thanks for working on closing this gap :-)

> A lot of drivers use skb_mark_for_recycle() already, it's been almost
> two years and seems like there are no issues in using it in the generic
> code too. {__,}xdp_release_frame() can be then removed as it losts its
> last user.
> Page Pool becomes then zero-alloc (or almost) in the abovementioned
> cases, too. Other memory type models (who needs them at this point)
> have no changes.
> 
> Some numbers on 1 Xeon Platinum core bombed with 27 Mpps of 64-byte
> IPv6 UDP:

What NIC driver?

> 
> Plain %XDP_PASS on baseline, Page Pool driver:
> 
> src cpu Rx     drops  dst cpu Rx
>    2.1 Mpps       N/A    2.1 Mpps
> 
> cpumap redirect (w/o leaving its node) on baseline:
> 
>    6.8 Mpps  5.0 Mpps    1.8 Mpps
> 
> cpumap redirect with skb PP recycling:
> 
>    7.9 Mpps  5.7 Mpps    2.2 Mpps   +22%
> 

It is of cause awesome, that cpumap SKBs are faster than normal SKB path.
I do wonder where the +22% number comes from?

> Alexander Lobakin (2):
>    xdp: recycle Page Pool backed skbs built from XDP frames
>    xdp: remove unused {__,}xdp_release_frame()
> 
>   include/net/xdp.h | 29 -----------------------------
>   net/core/xdp.c    | 19 ++-----------------
>   2 files changed, 2 insertions(+), 46 deletions(-)
> 

