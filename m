Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4974436B656
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 18:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234555AbhDZQAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 12:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234507AbhDZQAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 12:00:41 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C662FC061756
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 08:59:57 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id w24so4553095vsq.5
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 08:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/etdMnMfQf8Lq4o4ojGxs2fwM1Ap/wcUvIhOPXMbqeo=;
        b=FF+A/gQ7lJT/4qME+i4BCaa1DeVO4KQI+woQPX3C2/zE318F2F3SFHsdNxu3L+aOcH
         mZ6XajqDNv/iesNAyscATuxJqKuzm1Qfd58Omm+dqXsAykfimoLZdCu+17MGh02nLynT
         64Gh57Pv7zZKwNi5NA3j9yWSBceYBxSv67Z4PHgh8QxyWNkYBX5dhZBeESdhucaRcjVm
         epVNAjOTygai2T0Fj4ziAd+xAqzPmMzETxngrmVgUCwuL+O7PYWfDW57B6ZvmRopmHEq
         EpiKOo1sLgNWOdzT5qefKRVDTZtT4UeqCsUOxWSg9xY9yRxsdFtY/yAYbEGskxQ9wczf
         6zkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/etdMnMfQf8Lq4o4ojGxs2fwM1Ap/wcUvIhOPXMbqeo=;
        b=c0dypPYxMxvqdBaPelLaVi2VU6SsHFf15ZO+jbzLHCPebpB+qdNeFFHhmOP1P4hQC/
         DjEqpjrK9DWi9cV8fkqVDAjrL7tEqa9krAtkFNXEiCUhIdk/B/UENMHo3OS48b1wBkDV
         hLtDifwjs6hU2YEH4R+XFxJYQpjBF4uORj5USt9RpOKfN777GWtgYZ07II6kdyei71I8
         ec411TcwN813AFwQJDehzHkHFTo3fZ8pgj4s5E67ke8VhDiK0VQJnng35IZMmUOEpYVA
         qVHiV3JCEy9vwW3RgApHpdfRbo/DNk7R+UzN2kF2CoPYu+rGrrYrDiUXg5uRz4UojOyg
         s7hQ==
X-Gm-Message-State: AOAM533EqLxEgfKqsEBwAh6ACZ/oc7DUHDGuox3mxVSGKAr7GPg94cMN
        PomMjQz9RYt9y27w+F41GukmtNEBFt5Wkq7VPIObxw==
X-Google-Smtp-Source: ABdhPJys7ly5DxO20QI1dp5v/ulYMs3nUsBFrEaA4f9psG5gXcierkZqnbALcZm8WBJXBFnKYz1qmn/fo4PB7EdnWn4=
X-Received: by 2002:a67:ee88:: with SMTP id n8mr13471336vsp.52.1619452796573;
 Mon, 26 Apr 2021 08:59:56 -0700 (PDT)
MIME-Version: 1.0
References: <d7fbf3d3a2490d0a9e99945593ada243da58e0f8.1619000255.git.cdleonard@gmail.com>
 <CADVnQynLSDQHxgMN6=mU2m58t_JKUyugmw0j6g1UDG+jLxTfAw@mail.gmail.com> <50de1e9f-eed7-f827-77ea-708f4621e3d4@drivenets.com>
In-Reply-To: <50de1e9f-eed7-f827-77ea-708f4621e3d4@drivenets.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Mon, 26 Apr 2021 11:59:40 -0400
Message-ID: <CADVnQykBebycW1XcvD=NGan+BrJ3N1m5Q-pWs5vyYNmQQLjrBw@mail.gmail.com>
Subject: Re: [RFC] tcp: Delay sending non-probes for RFC4821 mtu probing
To:     Leonard Crestez <lcrestez@drivenets.com>
Cc:     Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Mathis <mattmathis@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        John Heffner <johnwheffner@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 25, 2021 at 10:34 PM Leonard Crestez <lcrestez@drivenets.com> wrote:
>
> On 4/21/21 3:47 PM, Neal Cardwell wrote:
> > On Wed, Apr 21, 2021 at 6:21 AM Leonard Crestez <cdleonard@gmail.com> wrote:
> >>
> >> According to RFC4821 Section 7.4 "Protocols MAY delay sending non-probes
> >> in order to accumulate enough data" but linux almost never does that.
> >>
> >> Linux waits for probe_size + (1 + retries) * mss_cache to be available
> >> in the send buffer and if that condition is not met it will send anyway
> >> using the current MSS. The feature can be made to work by sending very
> >> large chunks of data from userspace (for example 128k) but for small writes
> >> on fast links probes almost never happen.
> >>
> >> This patch tries to implement the "MAY" by adding an extra flag
> >> "wait_data" to icsk_mtup which is set to 1 if a probe is possible but
> >> insufficient data is available. Then data is held back in
> >> tcp_write_xmit until a probe is sent, probing conditions are no longer
> >> met, or 500ms pass.
> >>
> >> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
> >>
> >> ---
> >>   Documentation/networking/ip-sysctl.rst |  4 ++
> >>   include/net/inet_connection_sock.h     |  7 +++-
> >>   include/net/netns/ipv4.h               |  1 +
> >>   include/net/tcp.h                      |  2 +
> >>   net/ipv4/sysctl_net_ipv4.c             |  7 ++++
> >>   net/ipv4/tcp_ipv4.c                    |  1 +
> >>   net/ipv4/tcp_output.c                  | 54 ++++++++++++++++++++++++--
> >>   7 files changed, 71 insertions(+), 5 deletions(-)
> >>
> >> My tests are here: https://github.com/cdleonard/test-tcp-mtu-probing
> >>
> >> This patch makes the test pass quite reliably with
> >> ICMP_BLACKHOLE=1 TCP_MTU_PROBING=1 IPERF_WINDOW=256k IPERF_LEN=8k while
> >> before it only worked with much higher IPERF_LEN=256k
> >>
> >> In my loopback tests I also observed another issue when tcp_retries
> >> increases because of SACKReorder. This makes the original problem worse
> >> (since the retries amount factors in buffer requirement) and seems to be
> >> unrelated issue. Maybe when loss happens due to MTU shrinkage the sender
> >> sack logic is confused somehow?
> >>
> >> I know it's towards the end of the cycle but this is mostly just intended for
> >> discussion.
> >
> > Thanks for raising the question of how to trigger PMTU probes more often!
> >
> > AFAICT this approach would cause unacceptable performance impacts by
> > often injecting unnecessary 500ms delays when there is no need to do
> > so.
> >
> > If the goal is to increase the frequency of PMTU probes, which seems
> > like a valid goal, I would suggest that we rethink the Linux heuristic
> > for triggering PMTU probes in the light of the fact that the loss
> > detection mechanism is now RACK-TLP, which provides quick recovery in
> > a much wider variety of scenarios.
>
> > After all, https://tools.ietf.org/html/rfc4821#section-7.4 says:
> >
> >     In addition, the timely loss detection algorithms in most protocols
> >     have pre-conditions that SHOULD be satisfied before sending a probe.
> >
> > And we know that the "timely loss detection algorithms" have advanced
> > since this RFC was written in 2007. >
> > You mention:
> >> Linux waits for probe_size + (1 + retries) * mss_cache to be available
> >
> > The code in question seems to be:
> >
> >    size_needed = probe_size + (tp->reordering + 1) * tp->mss_cache;
>
> As far as I understand this is meant to work with classical retransmit:
> if 3 dupacks are received then the first segment is considered lost and
> probe success or failure is can determine within roughly 1*rtt.

Yes, that is my sense as well.

> RACK
> marks segments as lost based on echoed timestamps so it doesn't need
> multiple segments. The minimum time interval is only a little higher
> (5/4 rtt). Is this correct?

That's basically the case, though RACK doesn't even require echoed timestamps.

> > How about just changing this to:
> >
> >    size_needed = probe_size + tp->mss_cache;
> >
> > The rationale would be that if that amount of data is available, then
> > the sender can send one probe and one following current-mss-size
> > packet. If the path MTU has not increased to allow the probe of size
> > probe_size to pass through the network, then the following
> > current-mss-size packet will likely pass through the network, generate
> > a SACK, and trigger a RACK fast recovery 1/4*min_rtt later, when the
> > RACK reorder timer fires.
>
> This appears to almost work except it stalls after a while. I spend some
> time investigating it and it seems that cwnd is shrunk on mss increases
> and does not go back up. This causes probes to be skipped because of a
> "snd_cwnd < 11" condition.
>
> I don't undestand where that magical "11" comes from, could that be
> shrunk. Maybe it's meant to only send probes when the cwnd is above the
> default of 10? Then maybe mtu_probe_success shouldn't shrink mss below
> what is required for an additional probe, or at least round-up.
>
> The shrinkage of cwnd is a problem with this "short probes" approach
> because tcp_is_cwnd_limited returns false because tp->max_packets_out is
> smaller (4). With longer probes tp->max_packets_out is larger (6) so
> tcp_is_cwnd_limited returns true even for a cwnd of 10.
>
> I'm testing using namespace-to-namespace loopback so my delays are close
> to zero. I tried to introduce an artificial delay of 30ms (using tc
> netem) and it works but 20ms does not.

I agree the magic 11 seems outdated and unnecessarily high, given RACK-TLP.

I think it would be fine to change the magic 11 to a magic
(TCP_FASTRETRANS_THRESH+1), aka 3+1=4:

  - tp->snd_cwnd < 11 ||
  + p->snd_cwnd < (TCP_FASTRETRANS_THRESH + 1) ||

As long as the cwnd is >= TCP_FASTRETRANS_THRESH+1 then the sender
should usually be able to send the 1 probe packet and then 3
additional packets beyond the probe, and in the common case (with no
reordering) then with failed probes this should allow the sender to
quickly receive 3 SACKed segments and enter fast recovery quickly.
Even if the sender doesn't have 3 additional packets, or if reordering
has been detected, then RACK-TLP should be able to start recovery
quickly (5/4*RTT if there is at least one SACK, or 2*RTT for a TLP if
there is no SACK).

> > A secondary rationale for this heuristic would be: if the flow never
> > accumulates roughly two packets worth of data, then does the flow
> > really need a bigger packet size?
>
> The problem is that "accumulating sufficient data" is an extremely fuzzy
> concept. In particular it seems that at the same traffic level
> performing shorter writes from userspace (2kb instead of 64k) can
> prevent mtu probing entirely and this is unreasonable.

Something like your autocorking-enhanced-PMTU patch sounds like a
reasonable way to deal with this.

thanks,
neal
