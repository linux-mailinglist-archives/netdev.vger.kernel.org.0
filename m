Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D209D447D52
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 11:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237630AbhKHKN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 05:13:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235425AbhKHKN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 05:13:27 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6157DC061714
        for <netdev@vger.kernel.org>; Mon,  8 Nov 2021 02:10:42 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id j10so9398017lfu.4
        for <netdev@vger.kernel.org>; Mon, 08 Nov 2021 02:10:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=oqR92U7kLA3UxeOztQYj8+Q9vHwXz7gRmE4C5RHEVkw=;
        b=mxSPnmWnhIzVbpu4Ft0gau7C8lo7e14gLbZZjlTI30TkmBjsi138XoHG0tC02+eLdO
         WUha1StV1CRlp0dZRtATZueP2VOZSEjuDi5DZq5lY3qoFoYFstKY09IANCwitnxnBD6k
         tTdGS5n70gKOPnuDOS4Ji0cHKO6j8sAd7o6Ro=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=oqR92U7kLA3UxeOztQYj8+Q9vHwXz7gRmE4C5RHEVkw=;
        b=Ixzt/v56Gx11v6r/SCEWF46oR8nOmAdz+eJLeGjy085PzxCGj7glxE+2tzEmJAlD+o
         +Az4uXPYVBe8vSuf3hUbpO6BgtGXr3jiFANctnm9+g6hNVauDrGfetD2lC2r+6LpuaAf
         1MJ34a8c9wOg7Izq2VK2me40GneYfPiE8hdf77oL1XTkbJizC6+U6julTs6XBHxTgsti
         5zOlDp6SNM6U2ZjGHpHjY400TZ7S/nfo3XOmbUB0Tp5qAYvnOwdJtV6yW0JimskOVtiJ
         X+4bDOdRiKkWHW35pKBkXC5MvuvErG/I28HpIEH/b/Lrysx1g5ZswobnRGcPmIBwU3MN
         CKgw==
X-Gm-Message-State: AOAM531OflfrIgwvrXjgQ0/rO/8qYmuleoaWSFwA7RsTcktueDZ4WlBb
        d0+uC9NCcU7AXXBveKFxd8Hpzw==
X-Google-Smtp-Source: ABdhPJzsWSqsMKJQeuYHlBx6wPXCvhdJqXjKVtUJFoIyDwCH1f283lPLx5HQfQsGooUBetltFdVo9A==
X-Received: by 2002:a05:6512:3c93:: with SMTP id h19mr70746417lfv.411.1636366240713;
        Mon, 08 Nov 2021 02:10:40 -0800 (PST)
Received: from cloudflare.com ([2a01:110f:480d:6f00:ff34:bf12:ef2:5071])
        by smtp.gmail.com with ESMTPSA id m15sm483600lfp.9.2021.11.08.02.10.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 02:10:40 -0800 (PST)
References: <20211103204736.248403-1-john.fastabend@gmail.com>
 <20211103204736.248403-2-john.fastabend@gmail.com>
User-agent: mu4e 1.1.0; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        joamaki@gmail.com, xiyou.wangcong@gmail.com
Subject: Re: [PATCH bpf v2 1/5] bpf, sockmap: Use stricter sk state checks
 in sk_lookup_assign
In-reply-to: <20211103204736.248403-2-john.fastabend@gmail.com>
Date:   Mon, 08 Nov 2021 11:10:39 +0100
Message-ID: <87wnljgdpc.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 03, 2021 at 09:47 PM CET, John Fastabend wrote:
> In order to fix an issue with sockets in TCP sockmap redirect cases
> we plan to allow CLOSE state sockets to exist in the sockmap. However,
> the check in bpf_sk_lookup_assign currently only invalidates sockets
> in the TCP_ESTABLISHED case relying on the checks on sockmap insert
> to ensure we never SOCK_CLOSE state sockets in the map.
>
> To prepare for this change we flip the logic in bpf_sk_lookup_assign()
> to explicitly test for the accepted cases. Namely, a tcp socket in
> TCP_LISTEN or a udp socket in TCP_CLOSE state. This also makes the
> code more resilent to future changes.
>
> Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---

Thanks, John, for patching up the helper.

I will follow up with a test to cover unbound sockets.

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
