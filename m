Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBE5D561B95
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 15:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbiF3NpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 09:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234184AbiF3NpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 09:45:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6C07321E24
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 06:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656596699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hmiyqrALBK4w6YMjE9/PPjw+5KLdyggL+3cKN8iImGM=;
        b=dC0nmp55G3CcHksMQazFvftOfwLXxAFNgNVSusnQse6YIxriEBQqndzTjjiXM95L4p8fCp
        r2hAAByKwG/kakB0vH/JBFtgJ1QzL6PH20nCyuWon+dLdTIyqd5ZXKD9+AfW7cMAmOUYcT
        wVLLXV2eh21P/erbV9EegoSakrHH6xs=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-6-27GLaxqeP-ueWlnCSVm7vw-1; Thu, 30 Jun 2022 09:44:58 -0400
X-MC-Unique: 27GLaxqeP-ueWlnCSVm7vw-1
Received: by mail-lj1-f200.google.com with SMTP id 1-20020a2eb941000000b0025bf383b681so647052ljs.1
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 06:44:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=hmiyqrALBK4w6YMjE9/PPjw+5KLdyggL+3cKN8iImGM=;
        b=Dekxvpm7jVo2F6bOCcJ817g59ez2MrStcXK2eP/fAQFQ1mRJGhCR+SDBjNNZYRD2Yd
         0cOFKLvnZ4qSxQSL0OGmf4NDnISNRxga+ZC6UKmg53IIwodReRRlgO7QvXNL0zRdZtDl
         7uz3iG6yJzWw7GtKN1/x2bZdBw9l/LI+Mf+blt3awLRMzNeEgtmUXeD6zHcBwFcdRQbV
         Z02oa9lB1L4eKsR4+b/NzkVF4L9f6bq/oshneWrQgSa/piLmhO1ULsfb9/dK/QmisShq
         FhakUq5VVNbpy91MfH6A/TFLAZHO30KW4D6EicB67uEEWooWFYve8V85nGZLGiYsUbuZ
         wlGw==
X-Gm-Message-State: AJIora+oF9TGBfA8H8nH1+pE6DChOcQrK6KARf9Tn5HvXCRzEcjQ7wE8
        d7Iz5Vfe0Czd4hC3OgyFD1J4S62Lzh4ydR9Cm3EU3+eBMvPVJtbG1Kq6kcb0uJ6kzLgMwU8+L3u
        XhRVdPYpReH9hCd2f
X-Received: by 2002:a2e:83c6:0:b0:25a:d2c4:76c8 with SMTP id s6-20020a2e83c6000000b0025ad2c476c8mr5009222ljh.336.1656596695582;
        Thu, 30 Jun 2022 06:44:55 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vF59U2396jCMOcoH957hsj6kOjYeFktuehvWto7PorzaCjIxeQ4NPmAQLOvXE6DPG8b6KT5A==
X-Received: by 2002:a2e:83c6:0:b0:25a:d2c4:76c8 with SMTP id s6-20020a2e83c6000000b0025ad2c476c8mr5009218ljh.336.1656596695380;
        Thu, 30 Jun 2022 06:44:55 -0700 (PDT)
Received: from [192.168.0.50] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id j16-20020a056512109000b00477cc3fa475sm3098833lfg.204.2022.06.30.06.44.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 06:44:54 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <fa929729-6122-195f-aa4b-e5d3fedb1887@redhat.com>
Date:   Thu, 30 Jun 2022 15:44:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Cc:     brouer@redhat.com, bpf@vger.kernel.org,
        Xdp <xdp-newbies@vger.kernel.org>
Subject: Re: [PATCH bpf-next] selftests, bpf: remove AF_XDP samples
Content-Language: en-US
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        andrii@kernel.org, hawk@kernel.org, toke@redhat.com
References: <20220630093717.8664-1-magnus.karlsson@gmail.com>
In-Reply-To: <20220630093717.8664-1-magnus.karlsson@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 30/06/2022 11.37, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Remove the AF_XDP samples from samples/bpf as they are dependent on
> the AF_XDP support in libbpf. This support has now been removed in the
> 1.0 release, so these samples cannot be compiled anymore. Please start
> to use libxdp instead. It is backwards compatible with the AF_XDP
> support that was offered in libbpf. New samples can be found in the
> various xdp-project repositories connected to libxdp and by googling.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Will you (or Maciej) be submitting these samples to XDP-tools[1] which 
is the current home for libxdp or maybe BPF-examples[2] ?

  [1] https://github.com/xdp-project/xdp-tools
  [2] https://github.com/xdp-project/bpf-examples

I know Toke is ready to take over maintaining these, but we will 
appreciate someone to open a PR with this code...

> ---
>   MAINTAINERS                     |    2 -
>   samples/bpf/Makefile            |    9 -
>   samples/bpf/xdpsock.h           |   19 -
>   samples/bpf/xdpsock_ctrl_proc.c |  190 ---
>   samples/bpf/xdpsock_kern.c      |   24 -
>   samples/bpf/xdpsock_user.c      | 2019 -------------------------------
>   samples/bpf/xsk_fwd.c           | 1085 -----------------

The code in samples/bpf/xsk_fwd.c is interesting, because it contains a
buffer memory manager, something I've seen people struggle with getting
right and performant (at the same time).

You can get my ACK if someone commits to port this to [1] or [2], or a
3rd place that have someone what will maintain this in the future.

--Jesper

