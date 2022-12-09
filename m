Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCBA648715
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 17:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiLIQzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 11:55:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiLIQzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 11:55:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D2B24BF6
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 08:54:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670604898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=58/VjDZZoily/fkCPVeQuHIo3U3CJ3NHBYhVURQ6msE=;
        b=Yd+y+3RxOX41ySqFUi9gdtAxxGSuOWzgwo0O5sjuTSA4KciVcl7tzgMDhJYhruFN8JN4kJ
        v013RmpxhxBOjGB90nlFQbRyj/pdQBOMtbv6ammJ7PpxZi6WuBcMWZY+7av5+Q0vw8NVUj
        1kA2YjYajTzoGTgSdAPrZX7g6i6Xsd0=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-557-BsV_17coMvCASvxAqJbWFQ-1; Fri, 09 Dec 2022 11:54:57 -0500
X-MC-Unique: BsV_17coMvCASvxAqJbWFQ-1
Received: by mail-qt1-f200.google.com with SMTP id cj6-20020a05622a258600b003a519d02f59so4818177qtb.5
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 08:54:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:user-agent:date:mime-version:references
         :in-reply-to:cc:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=58/VjDZZoily/fkCPVeQuHIo3U3CJ3NHBYhVURQ6msE=;
        b=znrMMRKcl/gesm5mZ4hkQuG66/Tqd6eVL1mZdOYakjn/RqKRpPB8yr9ilmAG2S8yQM
         Pr1cjGf1w7fsYq76khQ2XEvt09tKwTQpuOjZx2Jzr1vg99RLxBKTolAsw2HNvI7ubvJw
         IoXvNv/5M+c4iTCvXqiV8mznlMHmPAme4czHotcDu4MK8d+pVHZgOMJnFN6U40MQs5hy
         eH22PfPtshUTRKU4c2izeoovYpHLoccfz03ZlDJxHa/jxDEKhfYvvT+u+11VHSBQ4e+S
         ig5Y4Awuvwx+CnU3bVQSG1mbwBiXqaxfhB/L0QYD2wMYR5ssy35mbLeAH534rfsSbCd2
         hQhA==
X-Gm-Message-State: ANoB5pmfy+Ord5hySAmj3SzM222rmjRZPUYAsyChkDr66fB80NqAkV2Q
        uFmVpHeBu0kp4397RMeOFLGSL6U0wsu3qNT03z7qM2I/8rDTB19myUnjxQ8GmOj5Iu+sE375aX+
        ncO/0icOpPk5+hZOw
X-Received: by 2002:a05:622a:598f:b0:3a5:108b:4c0a with SMTP id gb15-20020a05622a598f00b003a5108b4c0amr8948878qtb.49.1670604896742;
        Fri, 09 Dec 2022 08:54:56 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6OgXBm3yGAsctZK8WpJQz8t/1WUERRG3j0tTCoChZ3j4+dlJmSbvENPqDxg4y3AhOx9sGyBQ==
X-Received: by 2002:a05:622a:598f:b0:3a5:108b:4c0a with SMTP id gb15-20020a05622a598f00b003a5108b4c0amr8948861qtb.49.1670604896470;
        Fri, 09 Dec 2022 08:54:56 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-105-105.dyn.eolo.it. [146.241.105.105])
        by smtp.gmail.com with ESMTPSA id h4-20020ac85484000000b0039cc64bcb53sm1192355qtq.27.2022.12.09.08.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 08:54:56 -0800 (PST)
Message-ID: <9bb1cb8eff7d0e41230a48e01b1190a20602eb6a.camel@redhat.com>
Subject: Re: [PATCH v1 3/3] net: simplify sk_page_frag
From:   Paolo Abeni <pabeni@redhat.com>
To:     Benjamin Coddington <bcodding@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
In-Reply-To: <79b1009812b753c3a82d09271c4d655d644d37a6.1669036433.git.bcodding@redhat.com>
References: <cover.1669036433.git.bcodding@redhat.com>
         <79b1009812b753c3a82d09271c4d655d644d37a6.1669036433.git.bcodding@redhat.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Date:   Fri, 09 Dec 2022 17:42:06 +0100
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
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

