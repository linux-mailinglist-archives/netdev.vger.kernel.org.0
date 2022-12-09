Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C80406486B4
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 17:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiLIQpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 11:45:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbiLIQp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 11:45:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D83D2FC21
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 08:44:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670604270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=58/VjDZZoily/fkCPVeQuHIo3U3CJ3NHBYhVURQ6msE=;
        b=D2gLwC6E3d2a8enEKcJg8w7k9az63humzKoB6fUo5n4rTCrz7Z86cRwVAtCfHTLLrBOhfW
        NaWzKxL6FfObmFSJzyIL8kzc/HV/AGL1LVQ6ZZglCpRMbsuIH8osuxFhxQoXD7fpEFV+F5
        PqmR6wckPkCUvXoGT+kSnYwg85W4ly0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-443-dTPBpYfGO1K8SWnD8DwgaQ-1; Fri, 09 Dec 2022 11:44:28 -0500
X-MC-Unique: dTPBpYfGO1K8SWnD8DwgaQ-1
Received: by mail-ed1-f70.google.com with SMTP id j6-20020a05640211c600b0046d6960b266so1695008edw.6
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 08:44:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=58/VjDZZoily/fkCPVeQuHIo3U3CJ3NHBYhVURQ6msE=;
        b=kz0aMMPPF0GNQdc49PCxT7d8LaBclao+gDhCDL/wHxotze6zQHPD1dLiIUuMYauRa1
         3h6zS6eJBIsGcfpoT8JJZrDGDUh5DwkzxG2uUbdfFANqDS0NHzkjJFDZ3wARLlTydHVR
         kMBhPXXawdikJnDh3tTzdmMZuzFqyLnxqsrv//wHQPCc4XeN3hNDnxTb7iSj570y3Bmr
         e27FhCnlv1a71bwwaxI/as5ElUC9fNXwwrFFzeCmbTAzMXBbCdssgePA5X6dJ5QDEA65
         S2cgaQS21b6aOnmDcAFTFbQHbbotcxlICOg0JGHXjuRjNs6RFFQNenQlPHb+Qy2IA3gD
         1O+A==
X-Gm-Message-State: ANoB5pnvXxqLuSu0KtC1tRBuLHz03rTV0vX3Q1/KgtxLEPgSgRdI1Xno
        wjbJ+Gjk6rJppX91dnVtuDohCJXWzvcAuv8hJehiYq+8uGblELJDF/NMNnmagPpVrxjyVBBHvCh
        DPMS8I/L73GwDfX2k
X-Received: by 2002:a17:906:d922:b0:7c1:31c:e884 with SMTP id rn2-20020a170906d92200b007c1031ce884mr5297334ejb.17.1670604267891;
        Fri, 09 Dec 2022 08:44:27 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6sOrFT1Dy7qofyt7/dF4dvCQavTcB/nflqFBCIwEfJJ9SkPN3Lgfjdbp7iCrpqqFOYh+boyA==
X-Received: by 2002:a17:906:d922:b0:7c1:31c:e884 with SMTP id rn2-20020a170906d92200b007c1031ce884mr5297324ejb.17.1670604267713;
        Fri, 09 Dec 2022 08:44:27 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-105-105.dyn.eolo.it. [146.241.105.105])
        by smtp.gmail.com with ESMTPSA id t18-20020a1709063e5200b007c1175334basm113194eji.78.2022.12.09.08.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 08:44:27 -0800 (PST)
Message-ID: <59973b017cbd927b69d24f32cbac15f8245cc29c.camel@redhat.com>
Subject: Re: [PATCH v1 3/3] net: simplify sk_page_frag
From:   Paolo Abeni <pabeni@redhat.com>
To:     Benjamin Coddington <bcodding@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Fri, 09 Dec 2022 17:44:25 +0100
In-Reply-To: <79b1009812b753c3a82d09271c4d655d644d37a6.1669036433.git.bcodding@redhat.com>
References: <cover.1669036433.git.bcodding@redhat.com>
         <79b1009812b753c3a82d09271c4d655d644d37a6.1669036433.git.bcodding@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-11-21 at 08:35 -0500, Benjamin Coddington wrote:
> Now that in-kernel socket users that may recurse during reclaim have benn
> converted to sk_use_task_frag = false, we can have sk_page_frag() simply
> check that value.
> 
> Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
> ---
>  include/net/sock.h | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index ffba9e95470d..fac24c6ee30d 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -2539,19 +2539,14 @@ static inline void sk_stream_moderate_sndbuf(struct sock *sk)
>   * Both direct reclaim and page faults can nest inside other
>   * socket operations and end up recursing into sk_page_frag()
>   * while it's already in use: explicitly avoid task page_frag
> - * usage if the caller is potentially doing any of them.
> - * This assumes that page fault handlers use the GFP_NOFS flags or
> - * explicitly disable sk_use_task_frag.
> + * when users disable sk_use_task_frag.
>   *
>   * Return: a per task page_frag if context allows that,
>   * otherwise a per socket one.
>   */
>  static inline struct page_frag *sk_page_frag(struct sock *sk)
>  {
> -	if (sk->sk_use_task_frag &&
> -	    (sk->sk_allocation & (__GFP_DIRECT_RECLAIM | __GFP_MEMALLOC |
> -				  __GFP_FS)) ==
> -	    (__GFP_DIRECT_RECLAIM | __GFP_FS))
> +	if (sk->sk_use_task_frag)
>  		return &current->task_frag;
>  
>  	return &sk->sk_frag;

To make the above as safe as possible I think we should double-check
the in-kernel users explicitly setting sk_allocation to GFP_ATOMIC, as
that has the side effect of disabling the task_frag usage, too.

Patch 2/3 already catches some of such users, and we can safely leave
alone few others, (specifically l2tp, fou and inet_ctl_sock_create()).

Even wireguard and tls looks safe IMHO.

So the only left-over should be espintcp, I suggest updating patch 2/3
clearing sk_use_task_frag even in espintcp_init_sk().

Other than that LGTM.

Cheers,

Paolo

