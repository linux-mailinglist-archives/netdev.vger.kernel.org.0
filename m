Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83A586CEF06
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 18:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjC2QQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 12:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbjC2QQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 12:16:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1655B92
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 09:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680106476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eyuZmyKTv1NKroiSP9E43EgXTfIl/At4weexpT2NlGU=;
        b=Eg53YjKDDuos1oXQ+XOZVRvofaXMbZn+E9nGWsgGHqQV7T+yBRgTQ8DNuhG9WgIzg3Ry5E
        /NZVu5hOr1Awb30TYU/Tyupyxro04sXK1IxlABNfxpSzhqvCkwsk/rdM/Zrw2K3a4hzPht
        Jopo/tajV8sni8mNnjX1Qb+C6uMT8n4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-573-nFj3ufeBO-SijZkbzPq6ug-1; Wed, 29 Mar 2023 12:14:35 -0400
X-MC-Unique: nFj3ufeBO-SijZkbzPq6ug-1
Received: by mail-ed1-f70.google.com with SMTP id c1-20020a0564021f8100b004acbe232c03so22731776edc.9
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 09:14:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680106474;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eyuZmyKTv1NKroiSP9E43EgXTfIl/At4weexpT2NlGU=;
        b=gl1BoDfBv9CBm9zyLVx/vaTEET7YB7A7m0DTyPEv0U6tHW9T2rdGzkBvivkIPwsyRt
         bdGms2sTNDNvDRLgxvU75cosygb0fM1V8v2S6jOgrd2KFSHlrC30hWYb3+qtE3agdPXk
         qu5lLzZqMxZ0CCoPZsLJID5So6ECHzhdipbC8LFTXulcghGmAKoVfp0C6frqctyIJVT/
         i+a+RFkbMkWu47b1uqaZmViXSVsMU418BC6sJ1ViyibFz/ylm3P6X58Fz98LH7NNAozh
         VWOdsdfj/ixb5enVyev7gN4dAlWc9nUPO99ZB+ZOGqZu3o2RjNoW7mWNEsKDOLCQvz+e
         m5bA==
X-Gm-Message-State: AAQBX9eNH8ijYM2o8pqB6hQ730PD31/uNwhlCREpfXj6AU932FHgEuT+
        TjRQbEWDFqyVyq/8BKfOUgygvZw0eQZoWwBORSNFl3O1vZAqnwcvk0v1FXHHTBNxXVXQCEE61N0
        hJxMoCS10tvmkPpbz
X-Received: by 2002:a17:906:9411:b0:925:1d1d:6825 with SMTP id q17-20020a170906941100b009251d1d6825mr21570209ejx.42.1680106474351;
        Wed, 29 Mar 2023 09:14:34 -0700 (PDT)
X-Google-Smtp-Source: AKy350YWn1fLYGN+5GeSKK1DW+HePeJbJT5ZwcOpb0zI8ZYIwSr/zNcckx2CqhPDc0EazVwOjtorMw==
X-Received: by 2002:a17:906:9411:b0:925:1d1d:6825 with SMTP id q17-20020a170906941100b009251d1d6825mr21570188ejx.42.1680106473980;
        Wed, 29 Mar 2023 09:14:33 -0700 (PDT)
Received: from [192.168.42.100] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id e19-20020a170906c01300b009373f1b5c4esm12603786ejz.161.2023.03.29.09.14.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Mar 2023 09:14:33 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <193501d0-094a-cc5a-c3ae-4553a56e3a3a@redhat.com>
Date:   Wed, 29 Mar 2023 18:14:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dave Taht <dave.taht@gmail.com>
Subject: Re: [PATCH net-next] net/core: add optional threading for backlog
 processing
Content-Language: en-US
To:     Felix Fietkau <nbd@nbd.name>, Jakub Kicinski <kuba@kernel.org>
References: <20230324171314.73537-1-nbd@nbd.name>
 <20230324102038.7d91355c@kernel.org>
 <2d251879-1cf4-237d-8e62-c42bb4feb047@nbd.name>
In-Reply-To: <2d251879-1cf4-237d-8e62-c42bb4feb047@nbd.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 24/03/2023 18.35, Felix Fietkau wrote:
> On 24.03.23 18:20, Jakub Kicinski wrote:
>> On Fri, 24 Mar 2023 18:13:14 +0100 Felix Fietkau wrote:
>>> When dealing with few flows or an imbalance on CPU utilization, static RPS
>>> CPU assignment can be too inflexible. Add support for enabling threaded NAPI
>>> for backlog processing in order to allow the scheduler to better balance
>>> processing. This helps better spread the load across idle CPUs.
>>
>> Can you explain the use case a little bit more?
> 
> I'm primarily testing this on routers with 2 or 4 CPUs and limited 
> processing power, handling routing/NAT. RPS is typically needed to 
> properly distribute the load across all available CPUs. When there is 
> only a small number of flows that are pushing a lot of traffic, a static 
> RPS assignment often leaves some CPUs idle, whereas others become a 
> bottleneck by being fully loaded. Threaded NAPI reduces this a bit, but 
> CPUs can become bottlenecked and fully loaded by a NAPI thread alone.
> 
> Making backlog processing threaded helps split up the processing work 
> even more and distribute it onto remaining idle CPUs.
> 
> It can basically be used to make RPS a bit more dynamic and 
> configurable, because you can assign multiple backlog threads to a set 
> of CPUs and selectively steer packets from specific devices / rx queues 
> to them and allow the scheduler to take care of the rest.
> 

My experience with RPS was that it was too slow on the RX-CPU.  Meaning
that it doesn't really scale, because the RX-CPU becomes the scaling
bottleneck. (My data is old and it might scale differently on your ARM
boards).

This is why I/we created the XDP "cpumap".  It also creates a kernel
threaded model via a kthread on "map-configured" CPUs.  It scales
significantly better than RPS, but it doesn't handle flows and packet
Out-of-Order (OoO) situations automatically like RPS.  That is left up
to the BPF-programmer.  The kernel samples/bpf xdp_redirect_cpu[0] have
code that shows strategies of load-balancing flows.

The project xdp-cpumap-tc[1] runs in production (3 ISPs using this) and
works in concert with netstack Traffic Control (TC) for scaling
bandwidth shaping at the ISPs.  OoO is solved by redirecting all
customers IPs to the same TX/egress CPU. As the README[1] describes it
is recommended to reduce the number of RX-CPUs processing packets, and
have more TX-CPUs that basically runs netstack/TC.  One ISP with
2x25Gbit/s is using 2 CPUs for RX and 6 CPUs for TX.

--Jesper

[0] 
https://github.com/torvalds/linux/blob/master/samples/bpf/xdp_redirect_cpu.bpf.c
[1] https://github.com/xdp-project/xdp-cpumap-tc

