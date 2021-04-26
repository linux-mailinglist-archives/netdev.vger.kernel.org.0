Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66E3B36AB0B
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 05:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbhDZDVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 23:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231679AbhDZDVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 23:21:07 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9DEC061574
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 20:20:24 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id n2so1024667wrm.0
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 20:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A+O9XxSyRAxC04s135zV0ImqDIzVrFlS/3PdrRouQHM=;
        b=tz057H0ZyVDZA4cz2Ph0/d0cDQLB20ImUcGHhlecr3NTGfQE0EVtrrle92XvODW3CP
         SQ8sE1EdnY5psqwpYIIPbQ+4hjw5CArt0nfU8maG1GwJkA4Cl4cLSGP/FS4R/qCYbfLV
         Xk5S8OEfeQd4xms8ondf7Bx8E+jsbTOPzyQtC8+7AyvxvgSSQ/aS3iqp0qgrflXyNI0f
         /ILMdVMa41rChzyMEMaM/nUvemuLZg5PyL5pytZb2M6zuqEVBR+rA79auA2U1klA/9nM
         huPH8+uou1uRkF44Na0JYeRJ/HXj3p+XrEsMQPqRjNX1y0s8ZGsIwmOnIzljpL0USf0g
         XhIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A+O9XxSyRAxC04s135zV0ImqDIzVrFlS/3PdrRouQHM=;
        b=nsb8TW/BQg9d1ncWI3a5ApIVx3U5Qkoy0HYCxDzScJl7wpOGpFW9bMuuak0bZ3THx7
         i/lQsBJjN1IA8agwNr2xdNXo+VkA0c5ruvKgzeUIWYleU2x/T7M2M8dfMVUExpwj7hmV
         PBAwS6ugi6YJyn6lM2Rk/3ivr9V9fAY6W/q1pSPmbTdmTr4WiRsIgelS2Lj6BrONW8sm
         goT+AR062Oyn9gttxWYihgiF8pkTa5j34fKApoC2quqnjS97/JdXJLdaEFBDACo9nIUR
         ZCAMpoEJ2ODmgYGp49Vl0Gio5aA13J7IEg3QFwlD123A8vAuqeFeDrfiZIpyRYmk7Q76
         7crQ==
X-Gm-Message-State: AOAM531mDcUC8QVZ8omBKzpXVbrJexioe4HkizlxAlOrRbhR9HelwpNG
        qh3XS0/YC9xtp1LNq7xc4pYA3j8xijCo6ox0N/0wWQ==
X-Google-Smtp-Source: ABdhPJwei9VUtsJLBZyc0PgKIEMreSZc6VoK8XBJH+rMhh/h403LwXwyRD34IF06reumKVvxPXGYSIv/3Akqw7iHNRE=
X-Received: by 2002:a5d:5903:: with SMTP id v3mr4103013wrd.405.1619407223551;
 Sun, 25 Apr 2021 20:20:23 -0700 (PDT)
MIME-Version: 1.0
References: <d7fbf3d3a2490d0a9e99945593ada243da58e0f8.1619000255.git.cdleonard@gmail.com>
 <CADVnQynLSDQHxgMN6=mU2m58t_JKUyugmw0j6g1UDG+jLxTfAw@mail.gmail.com> <50de1e9f-eed7-f827-77ea-708f4621e3d4@drivenets.com>
In-Reply-To: <50de1e9f-eed7-f827-77ea-708f4621e3d4@drivenets.com>
From:   Matt Mathis <mattmathis@google.com>
Date:   Sun, 25 Apr 2021 20:20:11 -0700
Message-ID: <CAH56bmA7bRwd5DVVA++jxZqoG2GVLSMb+g1iyN8zHgFFeP-BVQ@mail.gmail.com>
Subject: Re: [RFC] tcp: Delay sending non-probes for RFC4821 mtu probing
To:     Leonard Crestez <lcrestez@drivenets.com>
Cc:     Neal Cardwell <ncardwell@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Yuchung Cheng <ycheng@google.com>,
        John Heffner <johnwheffner@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First RFC 4821 was finished in 2007, but most of the work was done
several years earlier.   In the intervening years just about
everything else in TCP has been overhauled.   The 11 packets was
probably reasonable for Reno with early retransmit and non adaptive
reordering.   These are archaic algorithms by today's standards.

You have two problems that you need to address:
1) like TSO you need to hold back transmits that are otherwise
eligible to be sent, such that you have enough data in the backlog to
send a probe or TSO.
2) you need to make sure that TCP recovers promptly when a probe is
lost (which is the most common case).  This is not so hard on a well
behaved network, but is likely to make your head hurt in the presence
of reordering (e,g, ECMP w/o flow pinning).  RACK helps, I'm sure.

Thanks,
--MM--
The best way to predict the future is to create it.  - Alan Kay

We must not tolerate intolerance;
       however our response must be carefully measured:
            too strong would be hypocritical and risks spiraling out of control;
            too weak risks being mistaken for tacit approval.

On Sun, Apr 25, 2021 at 7:34 PM Leonard Crestez <lcrestez@drivenets.com> wrote:
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
> probe success or failure is can determine within roughly 1*rtt. RACK
> marks segments as lost based on echoed timestamps so it doesn't need
> multiple segments. The minimum time interval is only a little higher
> (5/4 rtt). Is this correct?
>
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
>
> > A secondary rationale for this heuristic would be: if the flow never
> > accumulates roughly two packets worth of data, then does the flow
> > really need a bigger packet size?
>
> The problem is that "accumulating sufficient data" is an extremely fuzzy
> concept. In particular it seems that at the same traffic level
> performing shorter writes from userspace (2kb instead of 64k) can
> prevent mtu probing entirely and this is unreasonable.
>
> --
> Regards,
> Leonard
