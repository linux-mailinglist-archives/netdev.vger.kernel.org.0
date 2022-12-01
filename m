Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55D3163F86F
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 20:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiLATjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 14:39:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiLATjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 14:39:02 -0500
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0294A1C16
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 11:38:57 -0800 (PST)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-3876f88d320so27830527b3.6
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 11:38:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XakWQVkH9474LVaYgKMwnUxbaUgmjE7EAkkJC1goNog=;
        b=UERxYLpkqS4k9Ed3FNI5otOShDe6R6jHfsar2pSBef2+3coMLDt76z8xyuB/svcfFF
         JgSxng+DsuC9wJjOFGDmKF6f2sVqnKOXmNLncYtqdarC/IH2s3sSEIL0EguWBpqhM8zY
         P6Nw9Xc2qa59th4XoEkRXSnz0sEhr3O9Ov88gvtQI+IOAHf6va7AlrGitjuZvZ9p/mMT
         EVG5rvWPn6doD/js9rzu/S8zKesqrl5+FCWuzR/OJ9wss0KvH6k4opLWsqmuCQ7wilSb
         7gHy80g3oQ2H7Y9WUf/AGoSa9GxXsS6+4cEDfop6WwwL746GkrKBMv7U7B0I7hZDZ+sl
         Pw4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XakWQVkH9474LVaYgKMwnUxbaUgmjE7EAkkJC1goNog=;
        b=Udfib2yuXhM2RUl30bwW2bNjs9gogANmIs/vZFso9tjEbkuz1J287l/GjR8x7n6lHK
         Ly0cZCVHP4KwtB5Z6FpsfsTv0hPsM2PZU2qdzN3FMv6gFTXEZC3Y1qMYy/5WWtgdBfMm
         bsbzQOScHczxsh/VCgJc20aOAtbYJYmLXC6WaCREhn9C1k4SyUdi0l+aBfj6X4bTXUjF
         K81Vo1MRapfCvqowXvabrT9fiWFzh7nrSUusOfXH1S+v6aJec/boI7tLQIZAorJf7Uf2
         W2TMHawjBYjJCsZrs13opJXB6USOUoS5pGiNwLNcyWAZPB3XZYJM7MIDPDEUFAT+IFV6
         85nA==
X-Gm-Message-State: ANoB5pl7qhG3winJqm1LrVLENVi7jk+5haJdNLCTmgqQ8zMXm17KN6Tm
        SKIlQFkawGMV4q3jfDTRguT1R8UBTo6HkLn5UF4ZSQ==
X-Google-Smtp-Source: AA0mqf5LC7B68PWoPdHAFSDkF20bzVM7g8/jxSQTlKTzogTHfSlp2hWKWtORAdycDukryw61GvdshCMwNi89TPkgG8I=
X-Received: by 2002:a05:690c:a92:b0:36c:aaa6:e571 with SMTP id
 ci18-20020a05690c0a9200b0036caaa6e571mr63338613ywb.467.1669923536844; Thu, 01
 Dec 2022 11:38:56 -0800 (PST)
MIME-Version: 1.0
References: <20221123173859.473629-1-dima@arista.com> <20221123173859.473629-4-dima@arista.com>
In-Reply-To: <20221123173859.473629-4-dima@arista.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 1 Dec 2022 20:38:44 +0100
Message-ID: <CANn89iJEYhTFsF8vqe6enE7d107HfXZvgxN=iLGQj21sx9gwcQ@mail.gmail.com>
Subject: Re: [PATCH v6 3/5] net/tcp: Disable TCP-MD5 static key on
 tcp_md5sig_info destruction
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Baron <jbaron@akamai.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 6:39 PM Dmitry Safonov <dima@arista.com> wrote:
>
> To do that, separate two scenarios:
> - where it's the first MD5 key on the system, which means that enabling
>   of the static key may need to sleep;
> - copying of an existing key from a listening socket to the request
>   socket upon receiving a signed TCP segment, where static key was
>   already enabled (when the key was added to the listening socket).
>
> Now the life-time of the static branch for TCP-MD5 is until:
> - last tcp_md5sig_info is destroyed
> - last socket in time-wait state with MD5 key is closed.
>
> Which means that after all sockets with TCP-MD5 keys are gone, the
> system gets back the performance of disabled md5-key static branch.
>
> While at here, provide static_key_fast_inc() helper that does ref
> counter increment in atomic fashion (without grabbing cpus_read_lock()
> on CONFIG_JUMP_LABEL=y). This is needed to add a new user for
> a static_key when the caller controls the lifetime of another user.
>
> Signed-off-by: Dmitry Safonov <dima@arista.com>
> Acked-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Eric Dumazet <edumazet@google.com>
