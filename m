Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B61F6605A5D
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 10:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiJTI7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 04:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiJTI7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 04:59:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A1B194225
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 01:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666256338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z4JdVTNocmv+5C7FFGGGdfOf1ttmjLbFkFJntY9Bfk4=;
        b=Zax5i9ayjz8anF3R1dvhueLGwcykDdKonXoTXAxpPEO6EpDS1Ei5MdnH1O3YyH0eOysSok
        21CWRRwb6H9R5GrEBh/DVRMwOkBn0rVJPWZS0KYrBt19q2Ta9dkeSSD3usuVX3XgQEtdAX
        cm6d674C8dAKQGeCTepqF6EzDIJhEqI=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-379-hqBvP5AkNIGfiQyY-IoGIA-1; Thu, 20 Oct 2022 04:58:56 -0400
X-MC-Unique: hqBvP5AkNIGfiQyY-IoGIA-1
Received: by mail-qt1-f200.google.com with SMTP id bz12-20020a05622a1e8c00b0039ae6e887ffso14401899qtb.8
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 01:58:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z4JdVTNocmv+5C7FFGGGdfOf1ttmjLbFkFJntY9Bfk4=;
        b=SqctnDVpxYAXGKbPpiiJTATwJTfBYk0dexllvRXlIP7CdwBYZpRGmHEh87ry2jVXmY
         oS9O+a6h9tjH8N5oPWXlcF/isaxUaKMnKbJegAKNlFVlNWb1u6MJCwqkoXiQQroZbohN
         UeeLhu8CCA0tyNEAiDg23FuIi1CdvLrFYbNCdtmrYtS4yOE9CNzhXdUViu7SEqB2WWdf
         pUVMfqEgVJmPp/WaU4prIXYGgJ0xW1zJnenuB3uVgWPqzjTH29fCj0ZwRzlSMNv4Z8Ws
         o1p8+yrWKbPRxZvOmYLNsFo+lUHbA6UcuzYra0RS1N2TNtkSukOcEObHjwamsfFAjSFC
         e0NQ==
X-Gm-Message-State: ACrzQf2uqhx0yZLQtw5DoAFVtluLCJ09SpLrqXtn/JrmBsfjAq0PvJmZ
        hMcAR1X9iv7zgphtD5h5ytSuIlx9RVsZaeKx/u5q9Pfx0LGf76I3+EO3CP7yODTG7nYOox+wuDO
        FkH5pzrfZrFonEUOa
X-Received: by 2002:a0c:cb88:0:b0:4b8:d79e:b2c1 with SMTP id p8-20020a0ccb88000000b004b8d79eb2c1mr694658qvk.85.1666256336287;
        Thu, 20 Oct 2022 01:58:56 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4bXCasRwb46Qr+S4wxdTnTzsOhS4+ji7UC6MR7ZQFF8dYmBWGwTTEIKInkUbNKjOcrOIHvKQ==
X-Received: by 2002:a0c:cb88:0:b0:4b8:d79e:b2c1 with SMTP id p8-20020a0ccb88000000b004b8d79eb2c1mr694632qvk.85.1666256336012;
        Thu, 20 Oct 2022 01:58:56 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-103-235.dyn.eolo.it. [146.241.103.235])
        by smtp.gmail.com with ESMTPSA id z15-20020a05622a124f00b0039a08c0a594sm5671319qtx.82.2022.10.20.01.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 01:58:55 -0700 (PDT)
Message-ID: <bd11473cd4e2a92c4ce2a32d370800522862ad4b.camel@redhat.com>
Subject: Re: [PATCH][next] net: dev: Convert sa_data to flexible array in
 struct sockaddr
From:   Paolo Abeni <pabeni@redhat.com>
To:     Kees Cook <keescook@chromium.org>, Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Dylan Yudaken <dylany@fb.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Petr Machata <petrm@nvidia.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        Willem de Bruijn <willemb@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        "D. Wythe" <alibuda@linux.alibaba.com>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Congyu Liu <liu3101@purdue.edu>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
Date:   Thu, 20 Oct 2022 10:58:50 +0200
In-Reply-To: <20221018095503.never.671-kees@kernel.org>
References: <20221018095503.never.671-kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, 2022-10-18 at 02:56 -0700, Kees Cook wrote:
> One of the worst offenders of "fake flexible arrays" is struct sockaddr,
> as it is the classic example of why GCC and Clang have been traditionally
> forced to treat all trailing arrays as fake flexible arrays: in the
> distant misty past, sa_data became too small, and code started just
> treating it as a flexible array, even though it was fixed-size. The
> special case by the compiler is specifically that sizeof(sa->sa_data)
> and FORTIFY_SOURCE (which uses __builtin_object_size(sa->sa_data, 1))
> do not agree (14 and -1 respectively), which makes FORTIFY_SOURCE treat
> it as a flexible array.
> 
> However, the coming -fstrict-flex-arrays compiler flag will remove
> these special cases so that FORTIFY_SOURCE can gain coverage over all
> the trailing arrays in the kernel that are _not_ supposed to be treated
> as a flexible array. To deal with this change, convert sa_data to a true
> flexible array. To keep the structure size the same, move sa_data into
> a union with a newly introduced sa_data_min with the original size. The
> result is that FORTIFY_SOURCE can continue to have no idea how large
> sa_data may actually be, but anything using sizeof(sa->sa_data) must
> switch to sizeof(sa->sa_data_min).
> 
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Pavel Begunkov <asml.silence@gmail.com>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Dylan Yudaken <dylany@fb.com>
> Cc: Yajun Deng <yajun.deng@linux.dev>
> Cc: Petr Machata <petrm@nvidia.com>
> Cc: Hangbin Liu <liuhangbin@gmail.com>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: syzbot <syzkaller@googlegroups.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  include/linux/socket.h |  5 ++++-
>  net/core/dev.c         |  2 +-
>  net/core/dev_ioctl.c   |  2 +-
>  net/packet/af_packet.c | 10 +++++-----
>  4 files changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/socket.h b/include/linux/socket.h
> index de3701a2a212..13c3a237b9c9 100644
> --- a/include/linux/socket.h
> +++ b/include/linux/socket.h
> @@ -33,7 +33,10 @@ typedef __kernel_sa_family_t	sa_family_t;
>  
>  struct sockaddr {
>  	sa_family_t	sa_family;	/* address family, AF_xxx	*/
> -	char		sa_data[14];	/* 14 bytes of protocol address	*/
> +	union {
> +		char sa_data_min[14];		/* Minimum 14 bytes of protocol address	*/
> +		DECLARE_FLEX_ARRAY(char, sa_data);

Any special reason to avoid preserving the old name for the array and
e.g. using sa_data_flex for the new field, so we don't have to touch
the sockaddr users?

Thanks!

Paolo

