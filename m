Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04068486168
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 09:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236309AbiAFIZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 03:25:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236583AbiAFIZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 03:25:27 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA2BC061201
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 00:25:27 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id d201so5284544ybc.7
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 00:25:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CVfZvVXQxByQSLbmPIaWDydWXmtBJuvjNsIi28C4K4Y=;
        b=rB4DZRKRTdC4hDg682cFL8qOGPL0OIpqVIyibmQKdJUxbHnvR3A0pwYNydWI6t9L2P
         om05ORGVCXNTEiXRFV3Wk4wQGOpn04OTfbprbaH93zBM1o4ign28+X/y/RSuVHuHqcqi
         Idzeq6r6qgBJnsDF5ipKRjHDD7mk3sK+jELb6PO5j6F8YZibRaT3wSOyxagEkOjvhDW8
         EvQFd7YfW94iOIN6D48JkmgviFcQLHZyV2mh2ShMi5WPVzuQEjSwHDJDbXiOr/43LsjK
         7X7y8nmB38xvrNqg+M0LQS2lY21qNvKjmP/KiW7bTd5GjbMgPawpcryFY6TOKbsOvWlM
         mglw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CVfZvVXQxByQSLbmPIaWDydWXmtBJuvjNsIi28C4K4Y=;
        b=oeAsiYbRFNbMrx70Rm5twNSDQljWvWXiBjsdPAn4YvzTlVliMaVUERRGiwwJVNF/5Q
         tCSJfiYmtg03yIkqaucAp647mDYXw+fvJkcInXUL4SHZRdjNQk2PPOJJpdPR8mB8uxlI
         bBAV8mkb2+F1SSWGL9N1ppGIaYY6Wz7HHG1b8F3EHYbb+yHmzooT41qJO1qKO69XrU1+
         5SJQEAAHMzFUnauSrh+RyaTU+nTpV1SMYC0K0jMj5wFkWfQTw9BJLGbIcynRi4vp+Um5
         ipBV0gLFn/MaZDdzCo20M1QMlGf+ZM0ZlMyFHSnlowlh3CETbypcR1fPw69x5WcKf7md
         C39w==
X-Gm-Message-State: AOAM532FOIWSCioY0xckwsKvS3ubI12EIUNzBQVmf4Xc+8cW+zCoSMhW
        42RmfOTJL/G21DHeIDNSJwBCwBF81kWDrMF2eyxIUg==
X-Google-Smtp-Source: ABdhPJzwFpp3lIYB6mI2+0ckTXC3zK8hj0VfIUOZdI1x7S1ukZvIOyFNl34N1s5SlZY3PmdKEksH2X0qwQwPPVGszxI=
X-Received: by 2002:a25:2342:: with SMTP id j63mr55904255ybj.293.1641457526399;
 Thu, 06 Jan 2022 00:25:26 -0800 (PST)
MIME-Version: 1.0
References: <20220104003722.73982-1-ivan@cloudflare.com> <20220103164443.53b7b8d5@hermes.local>
 <CANn89i+bLN4=mHxQoWg88_MTaFRkn9FAeCy9dn3b9W+x=jowRQ@mail.gmail.com> <CABWYdi2oapjDMSJb+8T7BXMM6h+ftCQCSpPPePXaS3MyS4hD+w@mail.gmail.com>
In-Reply-To: <CABWYdi2oapjDMSJb+8T7BXMM6h+ftCQCSpPPePXaS3MyS4hD+w@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 6 Jan 2022 00:25:15 -0800
Message-ID: <CANn89i+9cOC4Ftnh2q7SZ+iP7-qe2jkFW3NtvFGzXLxoGUOsiA@mail.gmail.com>
Subject: Re: [PATCH net] tcp: note that tcp_rmem[1] has a limited range
To:     Ivan Babrou <ivan@cloudflare.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 5, 2022 at 8:20 PM Ivan Babrou <ivan@cloudflare.com> wrote:
>
> On Tue, Jan 4, 2022 at 12:33 AM Eric Dumazet <edumazet@google.com> wrote:
> > I guess you have to define what is the initial window.
>
> What I mean here is the first window after scaling is allowed, so the
> one that appears in the first non-SYN ACK.
>
> > There seems to be a confusion between rcv_ssthresh and sk_rcvbuf
> >
> > If you want to document what is rcv_ssthresh and how it relates to sk_rcvbuf,
> > you probably need more than few lines in Documentation/networking/ip-sysctl.rst
>
> I can't say I fully understand how buffer sizes grow and how
> rcv_ssthresh and sk_rcvbuf interact to document this properly.
>
> All I want is to document the fact that no matter what you punch into
> sysctls, you'll end up with an initial scaled window (defined above)
> that's no higher than 64k. Let me know if this is incorrect and if
> there's a way we can put this into words without going into too much
> detail.

Just to clarify, normal TCP 3WHS has a final ACK packet, where window
scaling is enabled.

You describe a possible issue of passive connections.
Most of the time, servers want some kind of control before allowing a
remote peer to send MB of payload in the first round trip.

However, a typical connection starts with IW10 (rfc 6928), and
standard TCP congestion
control would implement Slow Start, doubling the payload at every round trip,
so this is not an issue.

If you want to enable bigger than 65535 RWIN for passive connections,
this would violate standards and should be discussed first at IETF.

If you want to enable bigger than 65535 RWIN for passive connections
in a controlled environment, I suggest using an eBPF program to do so.


>
> > Please do not. We set this sysctl to 0.5 MB
> > DRS is known to have quantization artifacts.
>
> Where can I read more about the quantization artifacts you mentioned?

DRS is implemented in tcp_rcv_space_adjust()/tcp_rcv_rtt_update(),
you can look at git history to get plenty of details.

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=c3916ad9320eed8eacd7c0b2cf7f881efceda892
