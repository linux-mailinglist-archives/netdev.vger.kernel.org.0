Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08923555253
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 19:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237692AbiFVRZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 13:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359517AbiFVRZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 13:25:38 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6CA275F5
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 10:25:37 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id ay16so16368259ejb.6
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 10:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version;
        bh=NfLxHjkFejgN3aBvC6gvaCqk/o4hrmVWcIBXv3qiGjo=;
        b=GU2pKalKAZZVYbZ3ZrhCS8BYSgUFS9Sh6BpDfCmkNhtMAtj1+6nCfCP1G2+SMHg67z
         EQRjWISgrbA5E7kjAxs9U4nRah6z00TL318txcB9WAClW1GSKBG9yJXY9pIwBft5PVqz
         rN9vBbFKG7tqug0i8NZ1/yM8trYSL5uj1aHvA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version;
        bh=NfLxHjkFejgN3aBvC6gvaCqk/o4hrmVWcIBXv3qiGjo=;
        b=pjXKJDbqBtjet42vdV4fZg3Qe433Pa5bdf/Qna0SI232sOBEvEUt7k1UGDPvahsYsU
         tAgGgEINMUxXiQkyJjS6mNH3zlZR+ZqtQpU8TxdsrYfyQrGX9Pp389WGgsHJcHZWbK7/
         IYOgblA6scQiQZrs8V8ZUikrW/G9VGLvjMS/HnPOrFx6Y+SRMGfzSX5KP3bp/7WKEBUD
         ctruSrWYn0R0W9cK1dpJrJkjNNMVBhBFKJdkOzQg7iyf7FcHbOBGc0/2N5wX9Jk8Z57G
         F579ThhR3bbND/L4iwbUEJz60fX4rAAu04KBrXIYI8GAHt3Lf9F2Pr3fuk8BCqs/Zc8x
         UR3g==
X-Gm-Message-State: AJIora9bPgw7yhp8/U7R0b/BeW9GS6slQ+2UvLUi5nIU2Q9JaluVt3b+
        FTv4sB63RqBZ44heYfFxHaWo9g==
X-Google-Smtp-Source: AGRyM1vry+93pLne/ov9KvcKadetbVmUjCmjtvOvfat88mn8Q0+LxJczNPUIS5dI274B1Lo4vKZKhQ==
X-Received: by 2002:a17:907:962a:b0:711:d519:5ae3 with SMTP id gb42-20020a170907962a00b00711d5195ae3mr4336558ejc.711.1655918736164;
        Wed, 22 Jun 2022 10:25:36 -0700 (PDT)
Received: from cloudflare.com (79.184.138.130.ipv4.supernova.orange.pl. [79.184.138.130])
        by smtp.gmail.com with ESMTPSA id w8-20020a170906384800b00722fadc4279sm718243ejc.124.2022.06.22.10.25.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 10:25:35 -0700 (PDT)
References: <20220620191353.1184629-1-kuba@kernel.org>
 <20220620191353.1184629-2-kuba@kernel.org>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, john.fastabend@gmail.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        borisp@nvidia.com, cong.wang@bytedance.com, bpf@vger.kernel.org
Subject: Re: [PATCH net 2/2] sock: redo the psock vs ULP protection check
Date:   Wed, 22 Jun 2022 19:24:16 +0200
In-reply-to: <20220620191353.1184629-2-kuba@kernel.org>
Message-ID: <87fsjw4nlc.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 20, 2022 at 12:13 PM -07, Jakub Kicinski wrote:
> Commit 8a59f9d1e3d4 ("sock: Introduce sk->sk_prot->psock_update_sk_prot()")
> has moved the inet_csk_has_ulp(sk) check from sk_psock_init() to
> the new tcp_bpf_update_proto() function. I'm guessing that this
> was done to allow creating psocks for non-inet sockets.
>
> Unfortunately the destruction path for psock includes the ULP
> unwind, so we need to fail the sk_psock_init() itself.
> Otherwise if ULP is already present we'll notice that later,
> and call tcp_update_ulp() with the sk_proto of the ULP
> itself, which will most likely result in the ULP looping
> its callbacks.
>
> Fixes: 8a59f9d1e3d4 ("sock: Introduce sk->sk_prot->psock_update_sk_prot()")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---

I followed up with a regression test, if you would like to pick it up
through net tree.

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Tested-by: Jakub Sitnicki <jakub@cloudflare.com>
