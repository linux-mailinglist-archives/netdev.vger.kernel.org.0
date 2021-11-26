Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C79745F0CA
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 16:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378138AbhKZPi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 10:38:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349459AbhKZPg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 10:36:28 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 450F2C061792
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 07:27:17 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id j3so19459896wrp.1
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 07:27:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SMKU4OYpc9OGVJAM4AKWAvhdyy5YcBbLFAWqkC9Hu4c=;
        b=ZJAKi8hMK7NDi1ibqo+O05fRqeG6sy5nOoDl5PqEEaIQmu5j5la/4+GoEBYIVnfX9R
         690pXR4DrZNKJoR9TcsksaxSLdyjCjrY6DyPi0Jowgi9/TENPi173XvOkJcIDc2CEnCk
         7442U05/AzdJ1sR2wREk7LMyYeS16rlYiCHvSNgIBPid+Hxx83W5Q9q7Oo/ey35Z6rw9
         LOWQQYjeD52iifdPos8owWoqR0+h2EZtxxe01fjG3EnVhv3bAEhkMWRZ7xgZmCpcLitM
         +d7SxsdezaY5wrG1A+y7FVli3OjNSapV7YamFwXy3jyrMTomSft3lqjO2Fja7GsRdHvR
         h4LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SMKU4OYpc9OGVJAM4AKWAvhdyy5YcBbLFAWqkC9Hu4c=;
        b=hc4mMdoO+hRF9F/WFBYmZAHT2DpaqWZ/9qHbFV+lzS2ykssEm+Gu0s34XtvNZLXzzx
         Xy8wRW7kFt5fziD411ebexGQZVOFMVVOHGnSn4KC4li+S3bYH8IQYRTQ/BCMNFXLpS8r
         OIx65lKqsGvop4Vo9idYgdO6KSt5kBdxZTcAJfEdr6UQUp1DdodvJa+lo2ARc8c52eKU
         d+1uG4vwIcOvECBqZU91peh9cJGwSNmNvjyXp9nZdzG32r4lCnaStFKJU2QDZtPJiLg5
         z8kurWdVZEbsiSgkXqRMbGGS418FXMl3mu4tVkjEyKd8Izy2s0NlZN25/HTL3Br9aSul
         CeaA==
X-Gm-Message-State: AOAM531TcshIDTN3Ci1PhCk9jDyf28KDmnxXGvNn3XxwW0d7dYdcJFVT
        DLLyeVW6LZ6ptIQX80bKWWjcfdx4pc//ZvdexnH7Jw==
X-Google-Smtp-Source: ABdhPJy4LKTYSXguwaXF5Oy3KDu/+1ey3ffTYC+MNY0kXNNsJ7L8c/c307eiwGo0ImSrsRsZQbiec8u1XCfWAwAK2CY=
X-Received: by 2002:adf:9b95:: with SMTP id d21mr14641278wrc.527.1637940435417;
 Fri, 26 Nov 2021 07:27:15 -0800 (PST)
MIME-Version: 1.0
References: <d77eb546e29ce24be9ab88c47a66b70c52ce8109.1637923678.git.pabeni@redhat.com>
 <CANn89iJdg0qFvnykrtGx5OrV3zQTEtm2htTOFtaK-nNwNmOmDA@mail.gmail.com> <169f6a93856664dd4001840081c82f792ae1dc99.camel@redhat.com>
In-Reply-To: <169f6a93856664dd4001840081c82f792ae1dc99.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 26 Nov 2021 07:27:03 -0800
Message-ID: <CANn89iJ=BRJheZjb_hMoLbEca1h3p79iKkpgPbF7DTpGcx=46g@mail.gmail.com>
Subject: Re: [PATCH net] tcp: fix page frag corruption on page fault
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Steffen Froemer <sfroemer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 7:05 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Hello,
>
...

> Double checking I understood correctly: the problem is that in case of
> skb_copy_to_page_nocache() error, if the skb is not empty, random data
> will be introduced into the TCP stream, or something else/more? I
> obviously did not see that before the submission, nor tests cached it,
> sorry.

If there is a copy error, the skb is left with an extended fragment
(if a merge happened)
or a new frag, with random data in it, as the copy operation failed.

We are thus going to send garbage on the network on next sendmsg(),
which will append
more stuff in the frag array.

>
> > Please investigate CIFS and gfpflags_normal_context() tandem to fix
> > this issue instead.
>
> Do you mean changing gfpflags_normal_context() definition so that cifs
> allocation are excluded? Something alike the following should do:

We need to find one flag that can ask  gfpflags_normal_context() to
return false for this case.

Or if too difficult, stop only using sk->sk_allocation to decide
between the per-thread frag, or the per socket one.

I presume there are few active CIFS sockets on a host. They should use
a per socket sk_frag.



>
> ---
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index b976c4177299..f9286aeeded5 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -379,8 +379,8 @@ static inline bool gfpflags_allow_blocking(const gfp_t gfp_flags)
>   */
>  static inline bool gfpflags_normal_context(const gfp_t gfp_flags)
>  {
> -       return (gfp_flags & (__GFP_DIRECT_RECLAIM | __GFP_MEMALLOC)) ==
> -               __GFP_DIRECT_RECLAIM;
> +       return (gfp_flags & (__GFP_DIRECT_RECLAIM | __GFP_MEMALLOC | __GFP_FS)) ==
> +               (__GFP_DIRECT_RECLAIM | __GFP_FS);
>  }
> ---
> If so there is a caveat: dlm is currently using
> gfpflags_normal_context() - apparently to check for non blocking
> context. If I'll change gfpflags_normal_context() definition I likely
> will have to replace gfpflags_normal_context() with
> gfpflags_allow_blocking() in dlm.
>
> In that case the relevant patch should touch both the mm and the fs
> subsystem. In that case I guess I should go via the fs tree first and
> the via mm?
>
> Thanks!
>
> Paolo
>
