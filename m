Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A158597365
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 17:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239509AbiHQPzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 11:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234850AbiHQPzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 11:55:01 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBED9AFF1
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 08:55:00 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id s9so13959124ljs.6
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 08:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=ozn+S1pTAHnt4MIbe0EOjsoOdiS7sDbU2zMN4FKTa90=;
        b=UWt/yJz/MYKNe5t7CV8M2TbodbwAY3LVJCR1FDZulb4GlH9kltdhlRv21r/gNeqMTm
         uLlAij2opRCx5vA86ZGHOvtwovTW+DhPjHUIkdcvLH9ByT+Z6paRRFEQuJlDLOsTQDgN
         HaMTRsLZGJZI/SQI26cJi6a2T5E2UKhoNgChQbmx7dZLf3SFS8C5o3LXVLgNuFY8rNEq
         JEWo0S777lIANC1QVb7UMfa0edCSc6Vt3GXEdLCxYADzJiidXynnrWFCgGsj9wGKTdzg
         VxC/NzHM+o+ZFcII/pOS6nnNZB95T54Kt+TH8kAewYo1+YSYgOx5+vxpHWB1Z2WqLMWH
         ZiNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=ozn+S1pTAHnt4MIbe0EOjsoOdiS7sDbU2zMN4FKTa90=;
        b=Zr+IWrxisizE0qa10ISbuG+J7/7WXaee8tsICOYeBrjsvCy39fvG7nAuOd3/ked6vU
         sWY9k8CsvR+mrg5okXusF9slBHMvk6fnBw9ninCb4yM5ssuQbXCWgYowVQ06ulF2REbz
         q/EgOzNL56gyBn0xrJdhx+NDyhye+n8YQPL1xMwgBnawZXFMO6Ik5gSchzF/HXB50g41
         i0sHYy5RuZkUtUSjhc9QX77Zko9xZ0hwd8bIpGiqOp01zMJ03rGsY6rTN2s0HU7u3vlg
         Vfr3MTl2uhOYTW8xPbL6uqZ0W7UolemYxl2VxFcNUjEIJvwLvc5ylFm5Cyx+1816xctf
         ZsYQ==
X-Gm-Message-State: ACgBeo3T07Yvt1xjr5bp3EmMTuLdKL6Qi7HlnFIBsWiq/zOhKU2Ek7ZF
        WDCCtge1/XMeElmwHkF09/xnxGizbRJrKAnf9eNy3Q==
X-Google-Smtp-Source: AA6agR6czP9tLGH15CFY/TCd1TyBpWJmTBTsNb0gf9dSIXnUALf2qPw43A1a2ax4OFjF9mt5QFwvjMGzFHnxAuYXvFk=
X-Received: by 2002:a2e:9dc5:0:b0:25e:6fa0:1243 with SMTP id
 x5-20020a2e9dc5000000b0025e6fa01243mr8638554ljj.513.1660751698380; Wed, 17
 Aug 2022 08:54:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220816032846.2579217-1-imagedong@tencent.com>
In-Reply-To: <20220816032846.2579217-1-imagedong@tencent.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 17 Aug 2022 08:54:44 -0700
Message-ID: <CAKwvOd=accNK7t_SOmybo3e4UcBKoZ6TBPjCHT3eSSpSUouzEA@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net: skb: prevent the split of
 kfree_skb_reason() by gcc
To:     menglong8.dong@gmail.com
Cc:     kuba@kernel.org, miguel.ojeda.sandonis@gmail.com, ojeda@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        asml.silence@gmail.com, imagedong@tencent.com,
        luiz.von.dentz@intel.com, vasily.averin@linux.dev,
        jk@codeconstruct.com.au, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel test robot <lkp@intel.com>,
        linux-toolchains <linux-toolchains@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 8:29 PM <menglong8.dong@gmail.com> wrote:
>
> From: Menglong Dong <imagedong@tencent.com>
>
> Sometimes, gcc will optimize the function by spliting it to two or
> more functions. In this case, kfree_skb_reason() is splited to
> kfree_skb_reason and kfree_skb_reason.part.0. However, the
> function/tracepoint trace_kfree_skb() in it needs the return address
> of kfree_skb_reason().

Does the existing __noclone function attribute help at all here?

If not, surely there's an attribute that's more precise than "disable
most optimization outright."

https://unix.stackexchange.com/questions/223013/function-symbol-gets-part-suffix-after-compilation
https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-noclone-function-attribute

Perhaps noipa might also work here?

>
> This split makes the call chains becomes:
>   kfree_skb_reason() -> kfree_skb_reason.part.0 -> trace_kfree_skb()
>
> which makes the return address that passed to trace_kfree_skb() be
> kfree_skb().
>
> Therefore, prevent this kind of optimization to kfree_skb_reason() by
> making the optimize level to "O1". I think these should be better
> method instead of this "O1", but I can't figure it out......
>
> This optimization CAN happen, which depend on the behavior of gcc.
> I'm not able to reproduce it in the latest kernel code, but it happens
> in my kernel of version 5.4.119. Maybe the latest code already do someting
> that prevent this happen?
>
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
> ---
> v4:
> - move the definition of __nofnsplit to compiler_attributes.h
>
> v3:
> - define __nofnsplit only for GCC
> - add some document
>
> v2:
> - replace 'optimize' with '__optimize__' in __nofnsplit, as Miguel Ojeda
>   advised.
> ---
>  include/linux/compiler_attributes.h | 19 +++++++++++++++++++
>  net/core/skbuff.c                   |  3 ++-
>  2 files changed, 21 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
> index 445e80517cab..968cbafa2421 100644
> --- a/include/linux/compiler_attributes.h
> +++ b/include/linux/compiler_attributes.h
> @@ -270,6 +270,25 @@
>   */
>  #define __noreturn                      __attribute__((__noreturn__))
>
> +/*
> + * Optional: not supported by clang.
> + * Optional: not supported by icc.
> + *
> + * Prevent function from being splited to multiple part. As what the
> + * document says in gcc/ipa-split.cc, single function will be splited
> + * when necessary:
> + *
> + *   https://github.com/gcc-mirror/gcc/blob/master/gcc/ipa-split.cc
> + *
> + * This optimization seems only take effect on O2 and O3 optimize level.
> + * Therefore, make the optimize level to O1 to prevent this optimization.
> + */
> +#if __has_attribute(__optimize__)
> +# define __nofnsplit                   __attribute__((__optimize__("O1")))
> +#else
> +# define __nofnsplit
> +#endif
> +
>  /*
>   * Optional: not supported by gcc.
>   * Optional: not supported by icc.
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 974bbbbe7138..ff9ccbc032b9 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -777,7 +777,8 @@ EXPORT_SYMBOL(__kfree_skb);
>   *     hit zero. Meanwhile, pass the drop reason to 'kfree_skb'
>   *     tracepoint.
>   */
> -void kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
> +void __nofnsplit
> +kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
>  {
>         if (!skb_unref(skb))
>                 return;
> --
> 2.36.1
>


-- 
Thanks,
~Nick Desaulniers
