Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C52B1D6485
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 00:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgEPWgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 18:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726290AbgEPWgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 18:36:01 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E334CC05BD09
        for <netdev@vger.kernel.org>; Sat, 16 May 2020 15:35:59 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id e25so5963548ljg.5
        for <netdev@vger.kernel.org>; Sat, 16 May 2020 15:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ojEx/IuaCeSKl9dRzHTqbsmjCdnPX9Gd1n5eUMrsf6M=;
        b=JAjVbcADzxZkX/Q9hYkJyomMRdTOJf00a9W3t+vXoqLmEMBqDEC7mhW36NzNVaCP1b
         fOClknEqOrOMON9fxP6KqFVN6LaC0xmFLhaA/jkcXyZtggHuF3gQDyHCuOzZrkP5OHw/
         Zf07d/YRPfmnlMdTYBcFLj1AreaT2nGSG90e942XyELtlrm57Wy1geeB+JYwT+LSi4AF
         ktCg9U466UEeAGkcu++Yo+YcrlViEBVBRSZkoa4pplU8dag4LG3Br2IeZjDVz7Y/3Pr+
         RauQC0Sq1+9MypuJ0ayG38Gt0/+xjXawcGnpc1PYS2tklbxy1NWEQvCE92pCofiWJDgR
         SF/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ojEx/IuaCeSKl9dRzHTqbsmjCdnPX9Gd1n5eUMrsf6M=;
        b=c4euLikl2ju1gSYzTKfzo5PRKZSTgLhtrmuOuZF/LQcQgwDnjD3YNkHH1YnKcwW6F/
         EvSvT+xv+k4qQfnU9/UoB9PxbR9eT31RP5q9+j2Ot8kd0gSJFnsr7WzW7esw6XbXWYLc
         pgzshgo6wqTxxIavZCqAE2bMZQaSzmfCm24iKLkPmhQwp+o5MK6y4/jN3fhYq+0X6wzW
         djd0D+hrUojm0AzjtRZKUY0US5ekqQbUPwpk19gs5WOHQds8GHKM68o0aGJ2crGbuplX
         kCWjpO6+zPF31iMtseXf9T1jno14Sp/jRD8mKj1P8zJSfVnOMrMc2T6OULn3zFAPu4w8
         KQVg==
X-Gm-Message-State: AOAM5326VIS9kvmVKqDELcdkeTN8aOdbbb90tl72fqWMNA263Cm+qOoX
        6GkOCWaRafGMBL4I8N3io2+F/3/PgsJsPLLARKKEPg==
X-Google-Smtp-Source: ABdhPJyww2Ss10TFjQnw3rjcwTRh+N7rxxkevxyjMZ55BpomUMXpG4iVUjePGN7YpviRN2j8Ji6HIOVBA8z0RrSBLvE=
X-Received: by 2002:a2e:9795:: with SMTP id y21mr6097660lji.115.1589668557959;
 Sat, 16 May 2020 15:35:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200516021736.226222-1-shakeelb@google.com> <20200516.134018.1760282800329273820.davem@davemloft.net>
In-Reply-To: <20200516.134018.1760282800329273820.davem@davemloft.net>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Sat, 16 May 2020 15:35:46 -0700
Message-ID: <CALvZod7euq10j6k9Z_dej4BvGXDjqbND05oM-u6tQrLjosX31A@mail.gmail.com>
Subject: Re: [PATCH] net/packet: simply allocations in alloc_one_pg_vec_page
To:     David Miller <davem@davemloft.net>
Cc:     Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 16, 2020 at 1:40 PM David Miller <davem@davemloft.net> wrote:
>
> From: Shakeel Butt <shakeelb@google.com>
> Date: Fri, 15 May 2020 19:17:36 -0700
>
> > and thus there is no need to have any fallback after vzalloc.
>
> This statement is false.
>
> The virtual mapping allocation or the page table allocations can fail.
>
> A fallback is therefore indeed necessary.

I am assuming that you at least agree that vzalloc should only be
called for non-zero order allocations. So, my argument is if non-zero
order vzalloc has failed (allocations internal to vzalloc, including
virtual mapping allocation and page table allocations, are order 0 and
use GFP_KERNEL i.e. triggering reclaim and oom-killer) then the next
non-zero order page allocation has very low chance of succeeding.
