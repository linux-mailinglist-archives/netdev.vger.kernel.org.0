Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C488348FF
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 15:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbfFDNhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 09:37:24 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:43234 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727229AbfFDNhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 09:37:23 -0400
Received: by mail-yw1-f66.google.com with SMTP id t2so997474ywe.10
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 06:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HNGY3CirY9d4XVxddZISq7diL84bQqCS2j5n24KF518=;
        b=vksfPhzlBy/pcdTsdPg+i9EHiyPT0vJp2NsnP4VVTyRtjJa81U4tsnJkuIKW4as6MG
         n8SNsW0BK47FDdyInTtKTt0Wcis1uG1Uxir1wOSkPZGf4JDAoXgLqoOxVA+X5lB7lMF/
         aBCoTa4r9djHw9i290Nqx7bqd/1mdM/fpzoGj2ekrzK2zAroafolZ8kJHNn9zvSIxONZ
         Edbdgf0+xBGfrivRSS65UJivkKEPmn33w4bXXQvU+UH/QZU0vd8JhhkZZR2jj2gmzY1C
         WQhryyDrCPQ7SxyftMF+VTwTSsjg+AU3jaawyW+y5Zg6JO1cp1h6z4ZzGEhikoRl+ckY
         IBlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HNGY3CirY9d4XVxddZISq7diL84bQqCS2j5n24KF518=;
        b=V+nuXjJtUwqYua9sJoTkl7FNmae1J4EuuhqimIqeTEioN7V3zKR2Nbu2KxLXK5ttez
         JHLKJrebdsLqDiodLJyGf4LRn+OMWkgeBcUnvFJMQ6JVX+F5Mx6lprPiEfENfwknhZzA
         DF5W+GEKCatFdkB7/yuJZzeGuqPuA/CzJ7BZOkxkFRNRx4iBGq59XYUdQQ/idzI5CWLp
         8fFBoPh9Hgh1EVgex/wAQKQhguwkBf0tLCVpN6M0NgHugwVWQ/bXqy1X+p+HtK57qdoQ
         hykEeUtQqMC8JuhVujxwrSPMIgMt9pE0RseXS4OQXS1tVHfj06xlyfxsxpWNCAiOSSop
         xqNw==
X-Gm-Message-State: APjAAAU1eqiOxWWooZ80oK7DRV1592ntCUELO67xQUH7/SzuSFUA1Ai0
        Sh7yhKK5vRuIaQs4O1UKEccrzjJPkUrPEShaNlIybA==
X-Google-Smtp-Source: APXvYqzmsLGzjQyRypfo9ULkwDKvbrTsUvThQYBn1wUfmZQHffsKDBcd28qdrZnTQ3h6AirRlYHcvVxp7Gh8fJG3haU=
X-Received: by 2002:a81:7893:: with SMTP id t141mr6589487ywc.424.1559655442101;
 Tue, 04 Jun 2019 06:37:22 -0700 (PDT)
MIME-Version: 1.0
References: <678856f4fc73bbcd0de07a97c9d59996b6b8b585.1559641396.git.pabeni@redhat.com>
In-Reply-To: <678856f4fc73bbcd0de07a97c9d59996b6b8b585.1559641396.git.pabeni@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 4 Jun 2019 06:37:10 -0700
Message-ID: <CANn89iLTB=N663kU8p+98hVHYvU3osb-iQ473SdFW9ZTXdsvng@mail.gmail.com>
Subject: Re: [PATCH net v2] net: fix indirect calls helpers for ptype list hooks.
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 4, 2019 at 2:45 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> As Eric noted, the current wrapper for ptype func hook inside
> __netif_receive_skb_list_ptype() has no chance of avoiding the indirect
> call: we enter such code path only for protocols other than ipv4 and
> ipv6.
>
> Instead we can wrap the list_func invocation.
>
> v1 -> v2:
>  - use the correct fix tag
>
> Fixes: f5737cbadb7d ("net: use indirect calls helpers for ptype hook")
> Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Acked-by: Edward Cree <ecree@solarflare.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>
