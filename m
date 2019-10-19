Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05ED8DDB23
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 23:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfJSVTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 17:19:01 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42444 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbfJSVTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 17:19:01 -0400
Received: by mail-qk1-f196.google.com with SMTP id f16so8646567qkl.9;
        Sat, 19 Oct 2019 14:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OInwu2l8kRk36qEJ8aNRyw7RXhD3MTVYTP7FbpPhse4=;
        b=msbumPEGjHgLWB8mpblDcXdfWf4cA3qLnXRTAY43JRS5vNYG8h7q5A3pKbFUke3ri/
         Fucckdkaf3jRiO7eGnRPrD1GB6swjdsp4Hye9h3DzAO3fCmepFHfLfW8EGjPB6gX+Hue
         7HCyFLS0hGxoIwQN5xEsncGcHAzrE+jJ61gxsOWVMOWgOCb2MJmXDwEz3vEKLY1SSYsn
         AGkIIFsY7+f+Hbwu9q8T2erHOrCoLHYFnDDhMqXFdiZOqtf/ahJG2X5PYog5rA1rWa8I
         g35+JsU5gLf1XHgOdevE9eN2FmrX/n9VM2pA3uaMP/w05zZGyuLgTdluJ4/Zo9/ThgvU
         QAEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=OInwu2l8kRk36qEJ8aNRyw7RXhD3MTVYTP7FbpPhse4=;
        b=bhvHIi74q+6YXn/lxws67JhsY+UijtcJF5gU5bByzX8AohWvgbJGHHBp/Yzhp+z9gr
         E0hhizfiS89E5KVrZYfR8mgNGghG2G7g5TANXqUEU9hZjNRx8XclvQvggp6+rtmJUR3E
         hybwG4yyB7bK+CJPTukdks0Yu1a2ZMKiETA7X0iwWayzsD+nRUrQO+0gq7g98lBy1hyK
         Gp/WQKJqgtBaHUaRJnM0JTo48abgG8Vtn1bGzPuipaBC3++5oBxZqwQGDmrIMhhJ74dE
         1ftETL+fSlURs0e8cYqtP++1I7aRtnGo08KiMVPU6TESzcaXRu7DE03Yu1hkIezYnWSc
         aCBA==
X-Gm-Message-State: APjAAAXell/LT8LLjv0Pttytp5olHDkd6tpgmrc/AmoBHkuDdl+3bXz0
        ieGXZxiA6Ble4Zc9eiNoQh8=
X-Google-Smtp-Source: APXvYqw5BihCOMh10bAyfZPbJrYrEXHCPtpu2iGDpXQkxzekBaAZfJHZ4nvYV095qX7yi2bTUXaNtA==
X-Received: by 2002:a05:620a:13c1:: with SMTP id g1mr8673058qkl.369.1571519939913;
        Sat, 19 Oct 2019 14:18:59 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1d0d])
        by smtp.gmail.com with ESMTPSA id h23sm4076165qkk.128.2019.10.19.14.18.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 19 Oct 2019 14:18:59 -0700 (PDT)
Date:   Sat, 19 Oct 2019 14:18:56 -0700
From:   Tejun Heo <tj@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-team@fb.com, linux-kernel@vger.kernel.org,
        Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH] net: fix sk_page_frag() recursion from memory reclaim
Message-ID: <20191019211856.GR18794@devbig004.ftw2.facebook.com>
References: <20191019170141.GQ18794@devbig004.ftw2.facebook.com>
 <dc6ff540-e7fc-695e-ed71-2bc0a92a0a9b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc6ff540-e7fc-695e-ed71-2bc0a92a0a9b@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sat, Oct 19, 2019 at 11:15:28AM -0700, Eric Dumazet wrote:
> It seems compiler generates better code with :
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index ab905c4b1f0efd42ebdcae333b3f0a2c7c1b2248..56de6ac99f0952bd0bc003353c094ce3a5a852f4 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -2238,7 +2238,8 @@ struct sk_buff *sk_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp,
>   */
>  static inline struct page_frag *sk_page_frag(struct sock *sk)
>  {
> -       if (gfpflags_allow_blocking(sk->sk_allocation))
> +       if (likely((sk->sk_allocation & (__GFP_DIRECT_RECLAIM | __GFP_MEMALLOC)) ==
> +                   __GFP_DIRECT_RECLAIM))
>                 return &current->task_frag;
>  
>         return &sk->sk_frag;
> 
> 
> WDYT ?

Whatever works is fine by me.  gfpflags_allow_blocking() is clearer
than testing __GFP_DIRECT_RECLAIM directly tho.  Maybe a better way is
introducing a new gfpflags_ helper?

Thanks.

-- 
tejun
