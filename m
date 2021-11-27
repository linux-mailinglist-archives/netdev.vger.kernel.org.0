Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E3645F774
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 01:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbhK0Aby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 19:31:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbhK0A3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 19:29:54 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C277BC061574
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 16:26:40 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id i5so21962508wrb.2
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 16:26:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+LWvFxtzxoxxMjbpu5V2PVsWQkhi5eDTXoiyRpRzLKc=;
        b=L6O92GEYhAiOh+JWcIOPG7KjrCwVdnIl4tr18T4ThrbkDsmXeWaJlHp/FWDYOPJuQG
         B4N39Ox8oamvjbkpcfyHUSrzBltEXGOPx+8aGc4x6luJ1sgU3fuirjuLHrKWCRgtw5nR
         DUaCTmq8KPJI9MHUwEhfBAjueuXqApYjdVsLsiDtNf9+KR1U5TUbo1sje+aWv7yZdxHv
         Y/LPAQKwLtCcCxVWNZHnHfszZCgdsS7BihbCr/7dZeOmyz5K+rbONzviPqbOUgugfmU+
         /Bd+C+ySTTMvqeSmgKQyzAgiZQRaEfyiWtLwmC9V47mhFY+VFlARBt87ospiYvAZQJtI
         QvMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+LWvFxtzxoxxMjbpu5V2PVsWQkhi5eDTXoiyRpRzLKc=;
        b=w9DlDfPzCGZxD1UIZGB8ayCvnFKweBh8Rsb77IrsN1ShARnGleaUCeli7cmyFLN2rT
         Tv1Pjoa/vOBdt0IUUunGkUq9HvBEZYOg+2+M8bgThHd/DGmkVFerRFmwrVFaHi7HdPD6
         Nd2C/I8QenW5IR4I9Kz0lh2qUaBJasHIpb0aUmIvXGbsoFSpbhVxlHEFJH8OW2BVhHpQ
         TbVnRmIcMtAGFTwtyDu+K3OMDuHdppwcwvZz5Zl6LMQw0xYuP+AlTQWqJCDKr7atgmjP
         YooWkzZdoe6X/zwxiVAykdzU6PsH20CqsS9fSgaOQda2bvsu2Uy4X3/Zv+/OX7DU5XB5
         SvSg==
X-Gm-Message-State: AOAM530mpuzActrAKRmR4LpBZHSmGyNP8CYNfzuib9pH3YFKXcyzt2d1
        IXhTdCHE0s6xhJQiWYKMyMAzvx11nERqCxTtQRwyn9NHrZI=
X-Google-Smtp-Source: ABdhPJxYkqYn+/iQZp4fWBj0QAEEvw9/MwA5lVuIRMg2EEzXkJJ3O/Fs/gBW/1wesAfX8qvPUWle5AtZ+7zjNPNnM10=
X-Received: by 2002:adf:9b95:: with SMTP id d21mr17568619wrc.527.1637972798939;
 Fri, 26 Nov 2021 16:26:38 -0800 (PST)
MIME-Version: 1.0
References: <0fa74bfdfee95d6bba9fa49a5437f63c014f29ce.1637951641.git.pabeni@redhat.com>
In-Reply-To: <0fa74bfdfee95d6bba9fa49a5437f63c014f29ce.1637951641.git.pabeni@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 26 Nov 2021 16:26:27 -0800
Message-ID: <CANn89iJNu8ckhycBAmthpHTapNU+76RSCGvMAHMg7moi5Ku4MQ@mail.gmail.com>
Subject: Re: [PATCH net v2] tcp: fix page frag corruption on page fault
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Steffen Froemer <sfroemer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 10:35 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Steffen reported a TCP stream corruption for HTTP requests
> served by the apache web-server using a cifs mount-point
> and memory mapping the relevant file.
>
> The root cause is quite similar to the one addressed by
> commit 20eb4f29b602 ("net: fix sk_page_frag() recursion from
> memory reclaim"). Here the nested access to the task page frag
> is caused by a page fault on the (mmapped) user-space memory
> buffer coming from the cifs file.
>
> The page fault handler performs an smb transaction on a different
> socket, inside the same process context. Since sk->sk_allaction
> for such socket does not prevent the usage for the task_frag,
> the nested allocation modify "under the hood" the page frag
> in use by the outer sendmsg call, corrupting the stream.
>

> v1 -> v2:
>  - use a stricted sk_page_frag() check instead of reordering the
>    code (Eric)
>
> Reported-by: Steffen Froemer <sfroemer@redhat.com>
> Fixes: 5640f7685831 ("net: use a per task frag allocator")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---

SGTM, thanks !

Reviewed-by: Eric Dumazet <edumazet@google.com>
