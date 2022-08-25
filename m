Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 404565A0DD6
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 12:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240378AbiHYKXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 06:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240103AbiHYKXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 06:23:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BC9A9249
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 03:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661423009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WH7taTCKmHhuYCwZLHEgb0LTKexAdXTqWZqun01kso0=;
        b=YGRxZjl0SxuIRLYE/f/o6nZwkYciwsROvr79CLq+d8s+s1/i8VxPNzYvqTkgGxuNRZXfJ0
        1hY9NY5F0A0+4SbBZtj9S2ksURIRmyn7qddcEi97xOW0/A118RZ/bRbEqGKxDJIRv9H+IU
        zvv0oQqAOwIIrRDSSEJ/BaLZiipKpYI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-501-qhACoqsQOWqXq9iDKdeung-1; Thu, 25 Aug 2022 06:23:28 -0400
X-MC-Unique: qhACoqsQOWqXq9iDKdeung-1
Received: by mail-wr1-f69.google.com with SMTP id a7-20020adfbc47000000b002257209590cso785186wrh.12
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 03:23:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc;
        bh=WH7taTCKmHhuYCwZLHEgb0LTKexAdXTqWZqun01kso0=;
        b=h5jKxhJ7ADMmzuWhm219t2si9MaGZXN5ZDEq3MIpEgRX2p58IbNM9PkW/IR1Ll+44S
         uoY7WP/iupQ9PsKs1w70j1k1TVV036qwrUAVII49EUCOoB9V7VVXdydv41ILkDtYffSf
         +AMBBXKLbHSPJQtWGwZE4CXT14EXY7gRz/fPzT6pLW43o0xRL46PohpGIMAxiCSRgOfM
         Ws6tCMy6CqpjOMpdMa6X++whEiO/bpZnWvzCo9sVhGlomGZ6tnli3BdOpK9SjamJqnQT
         4g8WJmb0//xnd6Eqvb/R+90nfIYge0Js0iUgK2mlEuyNjoJTw5+JA21QIIlcnNlpOGRC
         7NqQ==
X-Gm-Message-State: ACgBeo2vwSvWgEoBy/vJWhTKOMWOLgezScih796xSFjsb4tF3amJhrE0
        iqCniKEdqnYzzVXZQUGGjd/BXtbGti0p5ub9Y3swGsIc5Ke66HBCiIYNzv014CYY9r018YJVKim
        31reOu1TBaZbNzUnO
X-Received: by 2002:adf:e78c:0:b0:225:2de2:940d with SMTP id n12-20020adfe78c000000b002252de2940dmr1720295wrm.686.1661423006804;
        Thu, 25 Aug 2022 03:23:26 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7I/udlXuzBQfb1iz6j/c98FOh+7cGbAF94ssXlH0Q/dmrb0fVVr9YMo2s6UFmkY5wko7BPGw==
X-Received: by 2002:adf:e78c:0:b0:225:2de2:940d with SMTP id n12-20020adfe78c000000b002252de2940dmr1720278wrm.686.1661423006540;
        Thu, 25 Aug 2022 03:23:26 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-176.dyn.eolo.it. [146.241.97.176])
        by smtp.gmail.com with ESMTPSA id s6-20020a1cf206000000b003a50924f1c0sm4898073wmc.18.2022.08.25.03.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 03:23:25 -0700 (PDT)
Message-ID: <97b1225e848caf6034aa68ef8bc6ded3823a8149.camel@redhat.com>
Subject: Re: [PATCH net v3] l2tp: Serialize access to sk_user_data with
 sk_callback_lock
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, netdev@vger.kernel.org
Cc:     kernel-team@cloudflare.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tom Parkin <tparkin@katalix.com>,
        Haowei Yan <g1042620637@gmail.com>
Date:   Thu, 25 Aug 2022 12:23:24 +0200
In-Reply-To: <20220823101459.211986-1-jakub@cloudflare.com>
References: <20220823101459.211986-1-jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello,

On Tue, 2022-08-23 at 12:14 +0200, Jakub Sitnicki wrote:
> sk->sk_user_data has multiple users, which are not compatible with each
> other. Writers must synchronize by grabbing the sk->sk_callback_lock.
> 
> l2tp currently fails to grab the lock when modifying the underlying tunnel
> socket. Fix it by adding appropriate locking.
> 
> We don't to grab the lock when l2tp clears sk_user_data, because it happens
> only in sk->sk_destruct, when the sock is going away.

l2tp can additionally clears sk_user_data in sk->sk_prot->close() via 
udp_lib_close() -> sk_common_release() -> sk->sk_prot->destroy() -> 
udp_destroy_sock() -> up->encap_destroy() -> l2tp_udp_encap_destroy().

That still happens at socket closing time, but when network has still
access to the sock itself. It should be safe as the other sk_user_data
users touch it only via fd, but perhaps a 'better safe the sorry'
approach could be relevant there?

Thanks!

Paolo

