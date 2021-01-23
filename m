Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF8730179C
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 19:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbhAWS0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 13:26:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbhAWS0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 13:26:21 -0500
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23BF9C0613D6
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 10:25:41 -0800 (PST)
Received: by mail-vk1-xa34.google.com with SMTP id d6so2160193vkb.13
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 10:25:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dEIgIP0bJkP6fY5AKAeiVRZud0dfhw1FU39czLcz5rs=;
        b=U1LilYzRZByE8KX/zMAyCtriKdcVcFf40xI7WYThSwKAJMQgNz4YQb7lfhXoqpT/Mw
         XURZC9OCjV3w1N0Hxi9eZkBbtfeKph2Kj6HT5SZw4EsLvepRlDmsEI0eig5lmAtOHThp
         tVKVUDLhPNbI5JTUEmWcQ4yOAGUa9jhhtcrS1OqZrEzaZk78m7+D9n4xviMxdpLsSXcI
         iPbEKKcZtmHB4qdKaSq8K6xEwtJ9IZxfKxKVQfyuNowxq/5e5PoOLH4PyxOkUXnbQo2X
         v/p1vRNJV4kSon4efh2Hup1yJ2QpERWB0U+iL88jvHOzlhxKRcnc4OAp8RyL6MeWgD/q
         rYtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dEIgIP0bJkP6fY5AKAeiVRZud0dfhw1FU39czLcz5rs=;
        b=HIP858UQC0AMhV8hBCVriRUxLT4YKx1HPuLZgnP8D74m9LcyJJRgzK24XRs59ptU6q
         6q3s3EUX/IO9p4OPUlbNiNyjLjGmFVbKAnU81IU/Azr6/IXlV+3L8PDSQby8Ot4hDUk8
         8lKkHU0EUurkiQSBYAEQQTP4o5w1NEdkPnglJqhcDYHqnUuGx9MLDnoNvWzKy7VAYMAS
         qrYXmgzaeJpoMZjTRpS4GAZo3R6VnW2FMauW+DBYHs+DSNbLxzAe0hc3h4D2m7zdoBpp
         v7FCgD8kd/62UnkOZzvY7beGLcGUbQcdKVVfCXHsOfnd6OEvLeXafd6ok7Dr6veavv+8
         6tnA==
X-Gm-Message-State: AOAM533qOshCp0vN8UT3OoCfW5b3fCofmwi4CnanPiLsRil4I6sGAYBa
        5hpuEsrs05ct/VIunRqssF0mXv55PsRTeGb7WJaiXQ==
X-Google-Smtp-Source: ABdhPJwlPKrQFOfe0AEI4YrO+rKWB3RqTBR3wk8EeZQ4zZNaM0BBCSynLnsQ2Nq5yzK1C05tO4VklcN/R9RIzvgLTtA=
X-Received: by 2002:a1f:3d95:: with SMTP id k143mr72345vka.11.1611426340035;
 Sat, 23 Jan 2021 10:25:40 -0800 (PST)
MIME-Version: 1.0
References: <20210122172703.39cfff6c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <1611413231-13731-1-git-send-email-yangpc@wangsu.com>
In-Reply-To: <1611413231-13731-1-git-send-email-yangpc@wangsu.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Sat, 23 Jan 2021 13:25:23 -0500
Message-ID: <CADVnQy=Htibc9H2bDy8T47F76kEmtWn-ZwJNtQXr2RaR0X6_dw@mail.gmail.com>
Subject: Re: [PATCH net] tcp: fix TLP timer not set when CA_STATE changes from
 DISORDER to OPEN
To:     Pengcheng Yang <yangpc@wangsu.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 23, 2021 at 9:15 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
>
> On Sat, Jan 23, 2021 at 9:27 AM "Jakub Kicinski" <kuba@kernel.org> wrote:
> >
> > On Fri, 22 Jan 2021 11:53:46 +0100 Eric Dumazet wrote:
> > > On Fri, Jan 22, 2021 at 11:28 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
> > > >
> > > > When CA_STATE is in DISORDER, the TLP timer is not set when receiving
> > > > an ACK (a cumulative ACK covered out-of-order data) causes CA_STATE to
> > > > change from DISORDER to OPEN. If the sender is app-limited, it can only
> > > > wait for the RTO timer to expire and retransmit.
> > > >
> > > > The reason for this is that the TLP timer is set before CA_STATE changes
> > > > in tcp_ack(), so we delay the time point of calling tcp_set_xmit_timer()
> > > > until after tcp_fastretrans_alert() returns and remove the
> > > > FLAG_SET_XMIT_TIMER from ack_flag when the RACK reorder timer is set.
> > > >
> > > > This commit has two additional benefits:
> > > > 1) Make sure to reset RTO according to RFC6298 when receiving ACK, to
> > > > avoid spurious RTO caused by RTO timer early expires.
> > > > 2) Reduce the xmit timer reschedule once per ACK when the RACK reorder
> > > > timer is set.
> > > >
> > > > Link: https://lore.kernel.org/netdev/1611139794-11254-1-git-send-email-yangpc@wangsu.com
> > > > Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> > > > Cc: Neal Cardwell <ncardwell@google.com>
> > >
> > > This looks like a very nice patch, let me run packetdrill tests on it.
> > >
> > > By any chance, have you cooked a packetdrill test showing the issue
> > > (failing on unpatched kernel) ?
> >
> > Any guidance on backporting / fixes tag? (once the packetdrill
> > questions are satisfied)
>
> By reading the commits, we can add:
> Fixes: df92c8394e6e ("tcp: fix xmit timer to only be reset if data ACKed/SACKed")

Thanks for the fix and the packetdrill test!

Eric ran our internal packetdrill test suite and all the changes in
behavior with your patch all look like fixes to me.

Acked-by: Neal Cardwell <ncardwell@google.com>

The Fixes: tag you suggest also looks good to me. (It seems like
patchwork did not pick it up from your email and add it to the commit
message automatically, BTW?)

neal
