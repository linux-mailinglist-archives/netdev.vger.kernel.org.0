Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A70E9528506
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 15:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243819AbiEPNLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 09:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243775AbiEPNLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 09:11:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 47FF9165A1
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 06:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652706672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hWqbVpSXlRnUW98z3sLnmKnw5Je1+k/fACI3ag9jrI4=;
        b=ei4V7HHZBsZ9c5h7x9z/3tOt8SKfQTYiR4qps91sZc/Q4M5Pn+Whs11buH4Q8/hyY5sEtL
        K4FXBeXPCbB6SL9qPrFO85+FBnPHdO4ys5ElLpqM5/sPaFcCF2xXB3J70Le+iy1TXHUpGY
        HgzXFH/ZkUzoc/NoxlwRWuJq7BxJC8Q=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-647-NuuZzQqjPNG1qC8elQ8jeg-1; Mon, 16 May 2022 09:11:10 -0400
X-MC-Unique: NuuZzQqjPNG1qC8elQ8jeg-1
Received: by mail-wm1-f72.google.com with SMTP id e9-20020a05600c4e4900b00394779649b1so10352586wmq.3
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 06:11:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=hWqbVpSXlRnUW98z3sLnmKnw5Je1+k/fACI3ag9jrI4=;
        b=Kdaq7Kb9g+uVsV0UslsqbtB3iv24iKcDgRNhmw1wTHjBO/InUcq5GwPTlh4uIaSGA0
         NgsbhG1+PHZLME7ftVMfuyMYG3mOlzlMhcWXCxDpe7Ye5Ax0GNbhQges3gsKuVT6T7GB
         OKhoeQ9Jwwcq9lCUT0TFl1/E0PeIXUdSHmXSFXZaH1gIDOZQqYbNkMlnJRh0tFRuE+Ty
         XDSUEI7tI+qP1Zw2qjtvx0Xl+PKnP/9y9eP8Lq766sgcXB96lzYB/I7lJPaaxTGx9djD
         t70NfuBkCPBuLzUhKjBzTCmaXrdYWgp8a06rQMrn4+mw80/vKn7a6Fm59LRGMP61FK9V
         n7zg==
X-Gm-Message-State: AOAM532YaIqjnW1ea0iTeJmkEkJhPWjbuO2rsQRlDNIR/mHQPhpU3OGy
        6AlWMFf0ZwTG6BIisNUilycRu6jCehCORcNLh1Tbya+Fcai+Ez6Cg5kCzsLAkSSMzAkJruoVOcT
        DUb3cBrMf8WwALMP5
X-Received: by 2002:a5d:6c64:0:b0:20d:599:ac5 with SMTP id r4-20020a5d6c64000000b0020d05990ac5mr5817860wrz.188.1652706669676;
        Mon, 16 May 2022 06:11:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxMIpxXZkSv8yNPofszxOJdJeN+qIyr7YJ2LBcjlLRnEL3eW+abpUDrUBz1fM+68QQmFMF1HA==
X-Received: by 2002:a5d:6c64:0:b0:20d:599:ac5 with SMTP id r4-20020a5d6c64000000b0020d05990ac5mr5817836wrz.188.1652706669339;
        Mon, 16 May 2022 06:11:09 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id l20-20020a1c7914000000b00394538d039esm13126585wme.6.2022.05.16.06.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 06:11:09 -0700 (PDT)
Message-ID: <b9844f3ce486c5aff8547e79abf4344488db6568.camel@redhat.com>
Subject: Re: [PATCH net-next v3 02/10] udp/ipv6: move pending section of
 udpv6_sendmsg
From:   Paolo Abeni <pabeni@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org
Date:   Mon, 16 May 2022 15:11:07 +0200
In-Reply-To: <a0e7477985ef08c5f08f35b8c7336587c8adce12.1652368648.git.asml.silence@gmail.com>
References: <cover.1652368648.git.asml.silence@gmail.com>
         <a0e7477985ef08c5f08f35b8c7336587c8adce12.1652368648.git.asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-05-13 at 16:26 +0100, Pavel Begunkov wrote:
> Move up->pending section of udpv6_sendmsg() to the beginning of the
> function. Even though it require some code duplication for sin6 parsing,
> it clearly localises the pending handling in one place, removes an extra
> if and more importantly will prepare the code for further patches.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  net/ipv6/udp.c | 70 ++++++++++++++++++++++++++++++--------------------
>  1 file changed, 42 insertions(+), 28 deletions(-)
> 
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index 11d44ed46953..85bff1252f5c 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -1318,6 +1318,46 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
>  	ipc6.sockc.tsflags = sk->sk_tsflags;
>  	ipc6.sockc.mark = sk->sk_mark;
>  
> +	/* Rough check on arithmetic overflow,
> +	   better check is made in ip6_append_data().
> +	   */
> +	if (unlikely(len > INT_MAX - sizeof(struct udphdr)))
> +		return -EMSGSIZE;
> +
> +	getfrag  =  is_udplite ?  udplite_getfrag : ip_generic_getfrag;
> +
> +	/* There are pending frames. */
> +	if (up->pending) {
> +		if (up->pending == AF_INET)
> +			return udp_sendmsg(sk, msg, len);
> +
> +		/* Do a quick destination sanity check before corking. */
> +		if (sin6) {
> +			if (msg->msg_namelen < offsetof(struct sockaddr, sa_data))
> +				return -EINVAL;
> +			if (sin6->sin6_family == AF_INET6) {
> +				if (msg->msg_namelen < SIN6_LEN_RFC2133)
> +					return -EINVAL;
> +				if (ipv6_addr_any(&sin6->sin6_addr) &&
> +				    ipv6_addr_v4mapped(&np->saddr))
> +					return -EINVAL;

It looks like 'any' destination with ipv4 mapped source is now
rejected, while the existing code accept it.

/P

