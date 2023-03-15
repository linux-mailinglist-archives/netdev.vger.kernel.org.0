Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD3CC6BC1B4
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 00:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbjCOXr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 19:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbjCOXr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 19:47:57 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2D621A06
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 16:47:21 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id eg48so905221edb.13
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 16:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1678924039;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jix/jt8/DqGVnmXzbJxKpTagGoN376osQS+d3UviJ2s=;
        b=Qpl9rOW7nQa0Bgarl7S1MT9QLwbQtyDj4G3+9+QgMf65Pdml//zgB/HOIui7FFuhcJ
         TUCE5XhTtSYTfRJnFdoPUpkdeY5Km1KtkrlR9B7oAr5REwKx6lmdp/L0JsrRbUQ5MFe5
         h7kmmIoGsYmbm34jweDbZApnKVaHi1x0QK/Ww=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678924039;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jix/jt8/DqGVnmXzbJxKpTagGoN376osQS+d3UviJ2s=;
        b=tUg3aFwi0M3Sznb4ygnkya6aMyENgGPlIa3ReNzECy5frW5/oxjnwivoEeaNlRixav
         HVnSyqq/FKU7nJMbeH1ZBobd0bRpr7hpuJtCQ7BiwpMl5nFKm8wPl4xPI+tA5CDOGMFy
         qk4NaoxBMGa7U53MWg2gbf7jRarBd9P+xVa/OydPji5GpI7/hFa36w7E2M2GPwMmjmme
         6CBEcPLIFt9yzPpvT+jTAa8EPYI+/pCNM64On2XG5zYwhFyqqTzKahv8NpiTB01pnMt2
         ecOqP18E79U9qbtEmbrmGd3ekdk41UVtQKIxV8U9yI4c3u5c4ajnZ7NdzF8hY9RE66MX
         cgPg==
X-Gm-Message-State: AO0yUKWqZCd35VvYm22JxtQPucn0MSABGTxTWcbu2462O9F2DGOpjwTp
        pOufYdWH5ruZuANLpM1TBQIsapLr6D9r3fpbLdGLCg==
X-Google-Smtp-Source: AK7set+hElLOCxvZES0hWtlE+B4hsUFozlsZlEqPhjr0POVnYLnCK0dTZPfopLvXfEs4jPrJ9am6Zw==
X-Received: by 2002:a17:906:1b09:b0:88e:e498:109b with SMTP id o9-20020a1709061b0900b0088ee498109bmr7887638ejg.5.1678924039161;
        Wed, 15 Mar 2023 16:47:19 -0700 (PDT)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id v10-20020a170906858a00b008d173604d72sm3122102ejx.174.2023.03.15.16.47.18
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 16:47:18 -0700 (PDT)
Received: by mail-ed1-f50.google.com with SMTP id cy23so922247edb.12
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 16:47:18 -0700 (PDT)
X-Received: by 2002:a17:906:1542:b0:8b1:28f6:8ab3 with SMTP id
 c2-20020a170906154200b008b128f68ab3mr4147419ejd.15.1678924037912; Wed, 15 Mar
 2023 16:47:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230315154245.3405750-1-edumazet@google.com> <20230315154245.3405750-2-edumazet@google.com>
 <20230315142841.3a2ac99a@kernel.org> <CANn89iLbOqjWVmgZKdGjbdsHw1EwO9d_w+dgKsyzLoq9pOsurQ@mail.gmail.com>
 <CAHk-=wiPUfe8aji5KojAhDKjWhJJU2F9kfzyL660=jRkY+Uzyg@mail.gmail.com> <CANn89iKA3E0CnXD=3EmP8-Ojav-tYEFeBaBu3B7CgzPaX6EC6A@mail.gmail.com>
In-Reply-To: <CANn89iKA3E0CnXD=3EmP8-Ojav-tYEFeBaBu3B7CgzPaX6EC6A@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 15 Mar 2023 16:47:01 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgQm4CgRJmmRdNjUCsX+F+mKxeUE_Siikuz6q_FbEySxA@mail.gmail.com>
Message-ID: <CAHk-=wgQm4CgRJmmRdNjUCsX+F+mKxeUE_Siikuz6q_FbEySxA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/8] inet: preserve const qualifier in inet_sk()
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 4:37=E2=80=AFPM Eric Dumazet <edumazet@google.com> =
wrote:
>
> Yep. my goal was to have const awareness.
>
> This:
>
> #define inet_sk(ptr) container_of(ptr, struct inet_sock, sk)
>
> does not really cover what I wanted, does it ?

Ugh. You should use "container_of_const()" of course.

I *thought* we already fixed plain "container_of()" to do the right
thing,, and got rid of "container_of_const()", but that was obviously
in my dreams.

           Linus
