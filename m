Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 635144572D0
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 17:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233355AbhKSQ1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 11:27:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbhKSQ1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 11:27:24 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574C7C061574
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 08:24:22 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso9242980pjb.2
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 08:24:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qui87OY5Jed4+H9Eeo8B5vVSCb7VatAB11Im4YTYJRU=;
        b=llELplFVoWfVosynWC9z829rWucL2lgjibfYGe7Wjc/w2c39KJ8ALIgzVb0vwI6zZs
         klS0Tvi8i7jIVaOU/DYlIxm4ulh1KGfEbnWjdpRELoTVhMAe8ybvt8t8GoASncsmKlw0
         Z/HweGsovgW4dQ/GBFXje/nE/Uos0iqCW7s3g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qui87OY5Jed4+H9Eeo8B5vVSCb7VatAB11Im4YTYJRU=;
        b=3sAQrwv411qCFN05WR5SXTx5lf14zzdbJYZ5HNnzQAFUYtWESyliDEV/FXps43vCw6
         phbR4qgBcml1g7ipkxwHnLiYIEq4kFDugB5z+4+uHUL63iEDT+MIdZ292SDMo/hzf9Z4
         I1Hn5F8vPOInyLktfwX2DmFSf920RsKEXnSh/H0vz6fmjFGF1WZiuq3aOB5fI1yEM8w5
         Mg99vfNyw5ljlnuPqxs9zNuMuF7iBsL3eBUMMY+12312tM/8H7WM47Vnq0HM9MQ9YVL1
         REvd6ED4mNMMMCUTIzQGP3Hy3iGCofKdZZWkpH2VHBLGuy4l3AXHjbLmyE3lnIdDg0Xb
         Nrew==
X-Gm-Message-State: AOAM533755fCTcyTpfpK8wyWTmdaZM0e1w8V0lKcNdbx6+7aSry18loO
        uZMlZ1beowdahPUaFRR5JTHlzg==
X-Google-Smtp-Source: ABdhPJzOSTnQ3rV6Qyg1u/LKfX0KBy8F72q5HyeDuG/FkYat7OxNw9TLTL+XNHEUVXP48WDRb6uSuQ==
X-Received: by 2002:a17:90b:1c02:: with SMTP id oc2mr990156pjb.65.1637339061491;
        Fri, 19 Nov 2021 08:24:21 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id u22sm144313pfi.187.2021.11.19.08.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 08:24:21 -0800 (PST)
Date:   Fri, 19 Nov 2021 08:24:20 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        linux-kernel@vger.kernel.org, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] skbuff: Switch structure bounds to struct_group()
Message-ID: <202111190821.8147EF796B@keescook>
References: <20211118183615.1281978-1-keescook@chromium.org>
 <20211118231355.7a39d22f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211118231355.7a39d22f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 11:13:55PM -0800, Jakub Kicinski wrote:
> On Thu, 18 Nov 2021 10:36:15 -0800 Kees Cook wrote:
> > In preparation for FORTIFY_SOURCE performing compile-time and run-time
> > field bounds checking for memcpy(), memmove(), and memset(), avoid
> > intentionally writing across neighboring fields.
> > 
> > Replace the existing empty member position markers "headers_start" and
> > "headers_end" with a struct_group(). This will allow memcpy() and sizeof()
> > to more easily reason about sizes, and improve readability.
> > 
> > "pahole" shows no size nor member offset changes to struct sk_buff.
> > "objdump -d" shows no object code changes (outside of WARNs affected by
> > source line number changes).
> 
> This adds ~27k of these warnings to W=1 gcc builds:
> 
> include/linux/skbuff.h:851:1: warning: directive in macro's argument list

Oh my, I see it[1]. I will get that fixed. This smells like a missing
header or something weird. I have a dim memory of fixing this warning
long ago when evolving this series.

Thanks!

-Kees

[1] https://patchwork.kernel.org/project/netdevbpf/patch/20211118183615.1281978-1-keescook@chromium.org/

-- 
Kees Cook
