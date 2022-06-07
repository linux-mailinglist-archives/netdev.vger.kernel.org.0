Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8910553FD62
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 13:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242748AbiFGLUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 07:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243169AbiFGLUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 07:20:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2E0766D1BA
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 04:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654600719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KveuBdGtFJ9vmpEfG9GqwQPGCYjA8kI0FyjUNOuLN+o=;
        b=eKqcXTFXuNUrnlrFZp3zFEx3H54YPJvU0jg5RZFBFy+JspD4cmj8B7IApWho2UzmvqWOOD
        RtWfolEaLP96DrGf/+W09Eh9E+idnJrxmU1TcAOaeikzJ8rrpFCNNfhyxfOVhBehDbXJsA
        DeqNmd3p5WCdL3wiXW9/6EiOJcx+2Wk=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-67-dfAPjRBtOtW6CWg0NrdHlA-1; Tue, 07 Jun 2022 07:18:38 -0400
X-MC-Unique: dfAPjRBtOtW6CWg0NrdHlA-1
Received: by mail-qk1-f198.google.com with SMTP id q7-20020a05620a0d8700b006a6b5428cb1so5391582qkl.2
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 04:18:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=KveuBdGtFJ9vmpEfG9GqwQPGCYjA8kI0FyjUNOuLN+o=;
        b=FBCP1pL/oyoJDVVfVPxsoRzQ4HINVrrZt+JAT7m/GlOcrOOE5M2tCLqcvDMLZFNNkh
         B5Q3HKwkpsq+/RnyK2E+XpY+1LmQiLI04yyp+b3qiQEpiAKF1aq3XQf5Q2zRH+I8NDIg
         5oiyPz/8WWDnOmmFJpn+wAqGTKwfaHm4+Ds39RzFEqtivrLZZyOrGrkMglOxESDZ7lUv
         qP9UwMllW4kEIJPvSgvDwyuKhwBybH+Sx4g0jq4Tf+a4kfnKwgRUSQy6YiS2C1AvfOBE
         EYepRS+17+pBs/4W5HYhNKxxBZeb/mQ8TlHWj7BqqH1vcDF7hZTZHXiUK+7C6SKk6Z5q
         7SOA==
X-Gm-Message-State: AOAM530H/QcQcF/InvfuG9IB39XwUvRoaxmqp8yqPvP9I3LOnRB/OHu/
        //03chYLNmTefOrNpKlUSENIuE0pEziDVmFfDEizlg5x/f29SJXXORnpaHBP/7j5xpwtw5C1UKI
        Fnw3djm5TBR2MZZnz
X-Received: by 2002:ac8:5989:0:b0:304:fcb8:f3c1 with SMTP id e9-20020ac85989000000b00304fcb8f3c1mr853573qte.520.1654600718460;
        Tue, 07 Jun 2022 04:18:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxqmTf47d0DplaahPzB82zvXlTqHsG3V3+k02H/FTJ7wL51qaKESs/0TO5rP9+tJeHmOGicQQ==
X-Received: by 2002:ac8:5989:0:b0:304:fcb8:f3c1 with SMTP id e9-20020ac85989000000b00304fcb8f3c1mr853553qte.520.1654600718172;
        Tue, 07 Jun 2022 04:18:38 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id z12-20020ac8454c000000b00304ee715045sm2969857qtn.15.2022.06.07.04.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 04:18:37 -0700 (PDT)
Message-ID: <52e02030f7b2c0052472f127dae91fb9f5312b85.camel@redhat.com>
Subject: Re: [PATCH 2/3] net: xfrm: unexport __init-annotated
 xfrm4_protocol_init()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Ahern <dsahern@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-kernel@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Date:   Tue, 07 Jun 2022 13:18:32 +0200
In-Reply-To: <20220606045355.4160711-3-masahiroy@kernel.org>
References: <20220606045355.4160711-1-masahiroy@kernel.org>
         <20220606045355.4160711-3-masahiroy@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-06-06 at 13:53 +0900, Masahiro Yamada wrote:
> EXPORT_SYMBOL and __init is a bad combination because the .init.text
> section is freed up after the initialization. Hence, modules cannot
> use symbols annotated __init. The access to a freed symbol may end up
> with kernel panic.
> 
> modpost used to detect it, but it has been broken for a decade.
> 
> Recently, I fixed modpost so it started to warn it again, then this
> showed up in linux-next builds.
> 
> There are two ways to fix it:
> 
>   - Remove __init
>   - Remove EXPORT_SYMBOL
> 
> I chose the latter for this case because the only in-tree call-site,
> net/ipv4/xfrm4_policy.c is never compiled as modular.
> (CONFIG_XFRM is boolean)
> 
> Fixes: 2f32b51b609f ("xfrm: Introduce xfrm_input_afinfo to access the the callbacks properly")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>

@Steffen: are you ok if we take this one in the -net tree directly?
Otherwise a repost would probably be the better option, with this patch
stand-alone targeting the ipsec tree and the other 2 targeting -net.

Thanks!

Paolo

