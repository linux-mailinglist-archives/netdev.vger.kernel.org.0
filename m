Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3A3409874
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 18:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345644AbhIMQMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 12:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235710AbhIMQMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 12:12:17 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E042C061574
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 09:11:01 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id k5-20020a05600c1c8500b002f76c42214bso7409248wms.3
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 09:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QpE1S2p3t02G6MfbKQlni0N9WQGdDSWS7h5ldQ8+QG8=;
        b=aorTiGztIAsEiaYjo1Ct9tkbfStLX7gagE5pvzTgJo0MIfO+NOx1nczBkMK0ym71qp
         re6gAJ+YIKFc3hWGPL2xg7uqZFpup7g19f72l44ZqF97oqZatLiYGpnd7b5Y3/vveGPs
         vC3tpAtAw9RFyvlFTQgyI4XVkXXapqWhb3HuqfCyIYzNGcFOjFe6cYpCCoBKMyG374Ce
         9RhjYztOzY54hlLEFvoKDyCUTpVvuYK6gS+eHIZ3hr90oa3cxtE0TJiF/Wy9mHtAmxGa
         inPsjVy+Q1AWhfHrYQXRMl0HXSflSUSPF8rBmciaeetZZayUTc3fTtwXrMOJrO8l6fEF
         3yKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QpE1S2p3t02G6MfbKQlni0N9WQGdDSWS7h5ldQ8+QG8=;
        b=rMsZIRzfe139NAn8VnmP1QrEgkDtFis3QFdCw53ECilljQe/a37XkaKxGlcTAsrvoW
         8HI8DBJ6IVeSMBuEvP9jkKZ0xRQ1rPGIoMlLymOfY2qmxjC5yu8A7YLUNf4X1gyxs9fc
         l0rvRTD4Dmjg9WEcE9pCPJtHnfsImpzDDb7RM6UmP5QJTVlQV9/F5y2igVR88wcMg8uA
         LPemycy4zE7vNgbV7OlXvfYTlYenC7fAXEq7yLAXBX/lMDmOWfRTb23UJVPW+ex12p9B
         j2SgAuUmZ/tXj48SaLn+E1rFes9uWixgCRZBkMrBTwuUSr39hNFFp35h1qnFIKuw2+uf
         z2ag==
X-Gm-Message-State: AOAM5310NwH8vuvK6gvagJADfaT4aAylB4KQhwc/0OQodGL2J1uPnnf4
        yESEU64HEz1EjhuPJO1FyQG3Ga2whgHmMbOwNu3vr8JCz9P0xA==
X-Google-Smtp-Source: ABdhPJwbJNBrHbg7IdepKRAjHziPCE1ShL+aCE1fgBMveaaJP02e3rh7svgANPlEyjj51uGuHrGk71kI19dOSM/GKUc=
X-Received: by 2002:a05:600c:22da:: with SMTP id 26mr12043203wmg.100.1631549459688;
 Mon, 13 Sep 2021 09:10:59 -0700 (PDT)
MIME-Version: 1.0
References: <1630314010-15792-1-git-send-email-zhenggy@chinatelecom.cn> <CANn89iLMDQqVmhq38OhD3X1D93qzAye0AsQpZYdCi=fsLEuNsg@mail.gmail.com>
In-Reply-To: <CANn89iLMDQqVmhq38OhD3X1D93qzAye0AsQpZYdCi=fsLEuNsg@mail.gmail.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Mon, 13 Sep 2021 09:10:22 -0700
Message-ID: <CAK6E8=fDRvd_qezt+Nxiru+aYH=aLFhSuYFQsZMHmzsKS2WWZg@mail.gmail.com>
Subject: Re: [PATCH v3] tcp: fix tp->undo_retrans accounting in tcp_sacktag_one()
To:     Eric Dumazet <edumazet@google.com>
Cc:     zhenggy <zhenggy@chinatelecom.cn>,
        Neal Cardwell <ncardwell@google.com>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, qitiepeng@chinatelecom.cn,
        wujianguo@chinatelecom.cn, liyonglong@chinatelecom.cn
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 8:49 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Mon, Sep 13, 2021 at 3:51 AM zhenggy <zhenggy@chinatelecom.cn> wrote:
> >
> > Commit 10d3be569243 ("tcp-tso: do not split TSO packets at retransmit
> > time") may directly retrans a multiple segments TSO/GSO packet without
> > split, Since this commit, we can no longer assume that a retransmitted
> > packet is a single segment.
> >
> > This patch fixes the tp->undo_retrans accounting in tcp_sacktag_one()
> > that use the actual segments(pcount) of the retransmitted packet.
> >
> > Before that commit (10d3be569243), the assumption underlying the
> > tp->undo_retrans-- seems correct.
> >
> > Fixes: 10d3be569243 ("tcp-tso: do not split TSO packets at retransmit time")
> >
>
> nit: We normally do not add an empty line between Fixes: tag and others.
>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>

This is a nice fix that would increase the effectiveness of TCP undo
in high-speed networks.

>
> > Signed-off-by: zhenggy <zhenggy@chinatelecom.cn>
> > ---
> >  net/ipv4/tcp_input.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > index 3f7bd7a..141e85e 100644
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -1346,7 +1346,7 @@ static u8 tcp_sacktag_one(struct sock *sk,
> >         if (dup_sack && (sacked & TCPCB_RETRANS)) {
> >                 if (tp->undo_marker && tp->undo_retrans > 0 &&
> >                     after(end_seq, tp->undo_marker))
> > -                       tp->undo_retrans--;
> > +                       tp->undo_retrans = max_t(int, 0, tp->undo_retrans - pcount);
> >                 if ((sacked & TCPCB_SACKED_ACKED) &&
> >                     before(start_seq, state->reord))
> >                                 state->reord = start_seq;
> > --
> > 1.8.3.1
> >
