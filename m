Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 203D85E562A
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 00:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbiIUWQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 18:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbiIUWQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 18:16:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71FD8A7A8A
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 15:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663798568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7ZRGiWjzNsukpIy4rJrNhhNAZ8Z3hkyqCLJbxu1V8pM=;
        b=JSBO/cyQJVErmAIwY1k9jLZ1MA5zgCY8/1x2w8HAHJqwdG4x1uaeXs2/0iH3fYra7PkAwP
        NsiJoK0l5iuOp7SjmzApaMTALp2IRe6+M35Gy+I+tEFsRUBsVpy4J6t9HUysJqXQVgzE/a
        +hL7EgAFaEE5SeHA2rz6qd5k9C0/6+o=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-343-jblX7UvbMaemjclRCkfBlA-1; Wed, 21 Sep 2022 18:16:07 -0400
X-MC-Unique: jblX7UvbMaemjclRCkfBlA-1
Received: by mail-ed1-f70.google.com with SMTP id dz21-20020a0564021d5500b0045217702048so5268677edb.5
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 15:16:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=7ZRGiWjzNsukpIy4rJrNhhNAZ8Z3hkyqCLJbxu1V8pM=;
        b=X/CnDQDYInsJb3vb8LKIc5aSH4HjuKoOjeJCZ5CemaaNe48kKM7MDV0P8DyVQIdcbG
         REULG+VFhuQxaJPRuWfS5jTeH/YOUVyo+YUrRs4yOWMmsOGoNXpBaLUqXBbEaEAN8icY
         gf6A5ZFeUQrKMYbC2CTFvbuO7d9HjRqS7iez106qcVJKcJbG1AmDMaEwy/Omq4WhKvnI
         FrfLvr8t3g1jnv+w1uUj/1ZTi+pWC4X7E1LUqGSqqs6K77ew35pBDyDNyu6MADd2CUx8
         VdV0EuajbXnpf3hl9M4u3FqDsXpE6K6I6AmlEvmT95zd7wiMKlG75dYykW6fC4HcG/qg
         c3Kw==
X-Gm-Message-State: ACrzQf3jBLgtZpScFfxKgAycPZOax0dUeaVMyalN8MDG1yuzG+R9r9cT
        c/OMkEmJNTkmYfJjHOJ2yIAcSSe1LrhERd3Y8SBY7zSGbwP/EVH0UXWmtmIejpWxJTeyQQP8IqR
        sn9BCF1+bUoG9tZvR
X-Received: by 2002:a05:6402:3486:b0:451:b8d3:c52c with SMTP id v6-20020a056402348600b00451b8d3c52cmr260515edc.406.1663798565048;
        Wed, 21 Sep 2022 15:16:05 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4KK6qJt+QCAEnmFM3fpiRKiITb7AsV70ttximoQ8OLk9eZKgy+daUivYutQXzjpoiAK8nURA==
X-Received: by 2002:a05:6402:3486:b0:451:b8d3:c52c with SMTP id v6-20020a056402348600b00451b8d3c52cmr260454edc.406.1663798564188;
        Wed, 21 Sep 2022 15:16:04 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id i18-20020a056402055200b0044841a78c70sm2439770edx.93.2022.09.21.15.16.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 15:16:03 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 07BA461C5A7; Thu, 22 Sep 2022 00:16:03 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        mtahhan@redhat.com, mcroce@microsoft.com
Subject: Re: [PATCH net-next] xdp: improve page_pool xdp_return performance
In-Reply-To: <166377993287.1737053.10258297257583703949.stgit@firesoul>
References: <166377993287.1737053.10258297257583703949.stgit@firesoul>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 22 Sep 2022 00:16:02 +0200
Message-ID: <87v8pgv0f1.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> During LPC2022 I meetup with my page_pool co-maintainer Ilias. When
> discussing page_pool code we realised/remembered certain optimizations
> had not been fully utilised.
>
> Since commit c07aea3ef4d4 ("mm: add a signature in struct page") struct
> page have a direct pointer to the page_pool object this page was
> allocated from.
>
> Thus, with this info it is possible to skip the rhashtable_lookup to
> find the page_pool object in __xdp_return().
>
> The rcu_read_lock can be removed as it was tied to xdp_mem_allocator.
> The page_pool object is still safe to access as it tracks inflight pages
> and (potentially) schedules final release from a work queue.
>
> Created a micro benchmark of XDP redirecting from mlx5 into veth with
> XDP_DROP bpf-prog on the peer veth device. This increased performance
> 6.5% from approx 8.45Mpps to 9Mpps corresponding to using 7 nanosec
> (27 cycles at 3.8GHz) less per packet.
>
> Suggested-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Nice! The two of you should get together in person more often ;)

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

