Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2DE949BC80
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 20:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbiAYTv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 14:51:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbiAYTvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 14:51:55 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E2BAC06173B
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 11:51:54 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id x7so58799354lfu.8
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 11:51:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VBbPm13s6wEPsIOn2ZRkMSoeMmWCgQIojvbG+4GjWDQ=;
        b=Z6uZ57KhTOb09VZMts+DwHK53KaGEf4jA/Enzg7yLpZTOzNr4kbQl7EEdNs1eyFa/y
         9K8uzjVcdK687yRhq4YqEbV7CWStyXgx+pao28Ctdz7RkwNaq9zMmHIJnuzs7pzByAol
         dzPxjahkltv3jURrjsjNd8NpZQ9y94mBrY620=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VBbPm13s6wEPsIOn2ZRkMSoeMmWCgQIojvbG+4GjWDQ=;
        b=nKAzN8Acybm04iNokZb3i5F6HqC4icnlZc51hFtJFebHymq15KtSFpVNUu08/4KCyO
         7QvKu3nt+fVMzOpAFpwQlgqH5cvymgiuii6/+0j6kLOUtTWcSSAspJ8VTMmnWXdeOt+T
         XDXpJ+8Dc2phkiFrhNn9O/1IwIC4K1P1yMXsNBD+cn0q74KbjH2HBuPPc3mfxWbx2W47
         P6Fl+vf/1KhHXIpfjfocOkit7wCtzeqD8/Xn0YNkOk2ImFthESjiilV8q5+PCkrDgjxY
         YwHmYCwJCx6dU+8hWXOq3uoaA4a2dlAigks9bZllrAmEhnetrn3MNJ66jFisqyscVk6c
         Ei5w==
X-Gm-Message-State: AOAM533Wj9vvfpYlEGbzCe3rh6+PxbiTwqq699IcDr4Z8FzoMC2ufl98
        5MzZ31UV3+YtGOFETTLUxMK8lKsRtUh4grrcS7qwaQ==
X-Google-Smtp-Source: ABdhPJx3fLcy3gU/50YmqHRSCRlkLYDoGFFfFFPL3ROGihqT/sQpHZ47J8Vf/jAXu9q5WixPnt5W8Uf+oM31Ae0RRSU=
X-Received: by 2002:a05:6512:22d1:: with SMTP id g17mr18330760lfu.154.1643140312724;
 Tue, 25 Jan 2022 11:51:52 -0800 (PST)
MIME-Version: 1.0
References: <1642716150-100589-1-git-send-email-jdamato@fastly.com> <Ye234Pb0f1SusMbA@pop-os.localdomain>
In-Reply-To: <Ye234Pb0f1SusMbA@pop-os.localdomain>
From:   Joe Damato <jdamato@fastly.com>
Date:   Tue, 25 Jan 2022 11:51:41 -0800
Message-ID: <CALALjgzLSmv4yiSuiF0DLU717peuhV3B1UAZ3uc9XStny4LR9w@mail.gmail.com>
Subject: Re: [PATCH net-next] sock: add sndbuff full perf trace event
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 On Sun, Jan 23, 2022 at 12:17 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Thu, Jan 20, 2022 at 02:02:30PM -0800, Joe Damato wrote:
> > Calls to sock_alloc_send_pskb can fail or trigger a wait if there is no
> > sndbuf space available.
> >
> > Add a perf trace event to help users monitor when and how this occurs so
> > appropriate application level changes can be made, if necessary.
> >
> > Signed-off-by: Joe Damato <jdamato@fastly.com>
> > ---
> >  include/trace/events/sock.h | 21 +++++++++++++++++++++
> >  net/core/sock.c             |  1 +
> >  2 files changed, 22 insertions(+)
>
> There are more places where we set the SOCKWQ_ASYNC_NOSPACE bit, so
> it looks like your patch is incomplete.

Thanks for taking a look.

I had originally taken your comment to suggest that the generic stream
code should trigger the same tracepoint; I agree and am happy to
generate a v2 with that case covered.

Are you suggesting that all places where SOCKWQ_ASYNC_NOSPACE is set
(e.g. the poll functions for various protocols) should trigger this
tracepoint, as well? Some of these may not have a user configurable
sndbuf, but I suppose knowing that this event is happening could be
helpful.

Thanks.
