Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6DF366B1D
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 14:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239891AbhDUMsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 08:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235231AbhDUMsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 08:48:40 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB16FC06138B
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 05:48:07 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id r1so1080101uat.4
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 05:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dm0VCnlctogH7NOXWwxOQ2XUcL7nBdd4RWT0rpQEyQI=;
        b=YI2Q1E+CS8kAaAkcnffqc+qE9TexY8iEgOXv2ZsWTPykZBkZed4F0O5qgAbdCpBwB1
         aN4x1nzAqF76aeUo6CeXHs2QOsxXCHxZQSlJl6wMURxpWw5rXCkmFn9A2q182P6CTbBx
         DUfhXIK+EMg88MG0T28BgaqmNt+Zkc9muh+vihGr+UfwK5BeM0RtuWhQSK9MH2GhD/ix
         8dR5D42ck0lOY1rkn4XBhMpU+APlwCnhP9TZxduoukqejsv4Dzw2WDqI+NxtgbAzm5ma
         aCQyDL8qVxYEfmqtZ/oUOesfMTpOrtTA7xzFIiSrKi+MZMSDCYsAcCYczVSbO7Q04rW9
         cHDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dm0VCnlctogH7NOXWwxOQ2XUcL7nBdd4RWT0rpQEyQI=;
        b=TarHxqRVkBfQb4uqBF6TcYFy/GGTUNraXxZnkdAKSqlPX9kZKv8pF5dgIkxwxI93ce
         tqFXnAsuDGi90YHwE1iTAUY7D4caQ0goyRKiZlgBVDM6BDqZ0l0JYnJ/tGk2LKDTJjw/
         ahVwZ1NgOsMStB2HJ0IlpNGWJuWRW0j8sQ4EfAJhGpOuB9SNYUwT8gsrdoMa4wyxi707
         1VjJnrrgg4UqodzVVKbhvzLfaxGOhOLuniexgceUfm0otRYh21x+5gO6gEyMtw0hvO2o
         F81ooHvs92ULz1+1Iq1IC0uEffk13YaB++WHcyGQ5dOsvhVj/xA0oElpqqrKEDCYr/iX
         O5jg==
X-Gm-Message-State: AOAM533Z8ItEw5QYMAszTBBPtDA7J16BbOZ5Bmg1+F5+SWjXWPDTL69l
        PkN9nfNlGdkPDv/eqk9AiaoNsqgY68VwPsRPTf174Q==
X-Google-Smtp-Source: ABdhPJylNukcekPvf42D1Q55VlcIB9+JcyiIKTYsmg8UWehYrxAN6wib4b4Lt+57AUUM3T1zlYLmaSo1ji3mYR8og80=
X-Received: by 2002:ab0:20d0:: with SMTP id z16mr16998068ual.33.1619009286572;
 Wed, 21 Apr 2021 05:48:06 -0700 (PDT)
MIME-Version: 1.0
References: <d7fbf3d3a2490d0a9e99945593ada243da58e0f8.1619000255.git.cdleonard@gmail.com>
In-Reply-To: <d7fbf3d3a2490d0a9e99945593ada243da58e0f8.1619000255.git.cdleonard@gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Wed, 21 Apr 2021 08:47:50 -0400
Message-ID: <CADVnQynLSDQHxgMN6=mU2m58t_JKUyugmw0j6g1UDG+jLxTfAw@mail.gmail.com>
Subject: Re: [RFC] tcp: Delay sending non-probes for RFC4821 mtu probing
To:     Leonard Crestez <cdleonard@gmail.com>
Cc:     Willem de Bruijn <willemb@google.com>,
        Ilya Lesokhin <ilyal@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Wei Wang <weiwan@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Mathis <mattmathis@google.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 6:21 AM Leonard Crestez <cdleonard@gmail.com> wrote:
>
> According to RFC4821 Section 7.4 "Protocols MAY delay sending non-probes
> in order to accumulate enough data" but linux almost never does that.
>
> Linux waits for probe_size + (1 + retries) * mss_cache to be available
> in the send buffer and if that condition is not met it will send anyway
> using the current MSS. The feature can be made to work by sending very
> large chunks of data from userspace (for example 128k) but for small writes
> on fast links probes almost never happen.
>
> This patch tries to implement the "MAY" by adding an extra flag
> "wait_data" to icsk_mtup which is set to 1 if a probe is possible but
> insufficient data is available. Then data is held back in
> tcp_write_xmit until a probe is sent, probing conditions are no longer
> met, or 500ms pass.
>
> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
>
> ---
>  Documentation/networking/ip-sysctl.rst |  4 ++
>  include/net/inet_connection_sock.h     |  7 +++-
>  include/net/netns/ipv4.h               |  1 +
>  include/net/tcp.h                      |  2 +
>  net/ipv4/sysctl_net_ipv4.c             |  7 ++++
>  net/ipv4/tcp_ipv4.c                    |  1 +
>  net/ipv4/tcp_output.c                  | 54 ++++++++++++++++++++++++--
>  7 files changed, 71 insertions(+), 5 deletions(-)
>
> My tests are here: https://github.com/cdleonard/test-tcp-mtu-probing
>
> This patch makes the test pass quite reliably with
> ICMP_BLACKHOLE=1 TCP_MTU_PROBING=1 IPERF_WINDOW=256k IPERF_LEN=8k while
> before it only worked with much higher IPERF_LEN=256k
>
> In my loopback tests I also observed another issue when tcp_retries
> increases because of SACKReorder. This makes the original problem worse
> (since the retries amount factors in buffer requirement) and seems to be
> unrelated issue. Maybe when loss happens due to MTU shrinkage the sender
> sack logic is confused somehow?
>
> I know it's towards the end of the cycle but this is mostly just intended for
> discussion.

Thanks for raising the question of how to trigger PMTU probes more often!

AFAICT this approach would cause unacceptable performance impacts by
often injecting unnecessary 500ms delays when there is no need to do
so.

If the goal is to increase the frequency of PMTU probes, which seems
like a valid goal, I would suggest that we rethink the Linux heuristic
for triggering PMTU probes in the light of the fact that the loss
detection mechanism is now RACK-TLP, which provides quick recovery in
a much wider variety of scenarios.

After all, https://tools.ietf.org/html/rfc4821#section-7.4 says:

   In addition, the timely loss detection algorithms in most protocols
   have pre-conditions that SHOULD be satisfied before sending a probe.

And we know that the "timely loss detection algorithms" have advanced
since this RFC was written in 2007.

You mention:
> Linux waits for probe_size + (1 + retries) * mss_cache to be available

The code in question seems to be:

  size_needed = probe_size + (tp->reordering + 1) * tp->mss_cache;

How about just changing this to:

  size_needed = probe_size + tp->mss_cache;

The rationale would be that if that amount of data is available, then
the sender can send one probe and one following current-mss-size
packet. If the path MTU has not increased to allow the probe of size
probe_size to pass through the network, then the following
current-mss-size packet will likely pass through the network, generate
a SACK, and trigger a RACK fast recovery 1/4*min_rtt later, when the
RACK reorder timer fires.

A secondary rationale for this heuristic would be: if the flow never
accumulates roughly two packets worth of data, then does the flow
really need a bigger packet size?

IMHO, just reducing the size_needed seems far preferable to needlessly
injecting 500ms delays.

best,
neal
