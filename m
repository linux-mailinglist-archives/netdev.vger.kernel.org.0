Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0961645CA27
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 17:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349046AbhKXQhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 11:37:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349029AbhKXQhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 11:37:31 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86CDFC061748
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 08:34:21 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id t26so8724852lfk.9
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 08:34:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zPOV/LNYwYTsmB7mQfhpRU+MWIN56vkkbdkQqLN+cvk=;
        b=bJ63a2e3Wy0M/xAdLhyaS4w9SbJ0nm2ErOeirbaa8ttvAjUGrt3n+uoQrwtA8+hWfd
         ssH9Z9lR1kI0OAKzPImESpcPZ8IZcoCaIkI8XQf5BKZmLZ7exvaa2/Mz/BeEQRf6oo0i
         HmYXatM1v2rz+lybQ4T/PYzN4LzvdDECznQdU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zPOV/LNYwYTsmB7mQfhpRU+MWIN56vkkbdkQqLN+cvk=;
        b=O75KuKU0TAvM7kOCpDc/tRE0bOSSSwM7DF33vOwfBnJPDapBGy25OuUAX8cntMcTmQ
         BaIuPbs4X/q2D8xsIoNkn5hrT8Q/iKC4pqFWHBsKREyVeOo5ZulimFi3ciaiDXmYHslq
         1ozWkny9lcSMt7BQJDPn6HixPfYDVhYlI7DQkNN0rJ86Yx+PyV0U3eNg8tgA17ozGMUY
         GFWQwcPes8dWNAa8lE8j4c5KnC9bomOWNlZZnzUCTdKoa8vg5p0ad6wGEwalT7QmOOQi
         kCFECtTly/DswCX67IvsHMI52Z9bLkLkQwm2pnL/Z5laC28Z5AXoeUeTqMw2zEhEZoj1
         QotQ==
X-Gm-Message-State: AOAM532DoAc9H/Sum0mw99Myhvg8MpZ/iNlLoZGWPntegaoKMw8zo4kD
        jejCaTNVAn/LPlaT++pUPKcfI1DP9+pBpZg6HOUljg==
X-Google-Smtp-Source: ABdhPJxll5plpSGM9GkzJLSlx7bxnJPHlV7QraqV5JuIj+jX+jjAxnkuvJ3L3Cz96Fx4R8waIVALa7LdANrfPhP7N5g=
X-Received: by 2002:a19:6b08:: with SMTP id d8mr16476607lfa.39.1637771659326;
 Wed, 24 Nov 2021 08:34:19 -0800 (PST)
MIME-Version: 1.0
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
 <20211123163955.154512-22-alexandr.lobakin@intel.com> <77407c26-4e32-232c-58e0-2d601d781f84@iogearbox.net>
In-Reply-To: <77407c26-4e32-232c-58e0-2d601d781f84@iogearbox.net>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Wed, 24 Nov 2021 16:34:08 +0000
Message-ID: <CACAyw9998vkRPX3vZxf8cC6ivVfTFDJPY11Cz08ZUSTLf_s7=A@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 21/26] ice: add XDP and XSK generic
 per-channel statistics
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Networking <netdev@vger.kernel.org>, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org,
        bpf <bpf@vger.kernel.org>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel asked me to share my opinion, as Cloudflare has an XDP load
balancer as well.

On Wed, 24 Nov 2021 at 00:53, Daniel Borkmann <daniel@iogearbox.net> wrote:

> I'm just taking our XDP L4LB in Cilium as an example: there we already count errors and
> export them via per-cpu map that eventually lead to XDP_DROP cases including the /reason/
> which caused the XDP_DROP (e.g. Prometheus can then scrape these insights from all the
> nodes in the cluster). Given the different action codes are very often application specific,
> there's not much debugging that you can do when /only/ looking at `ip link xdpstats` to
> gather insight on *why* some of these actions were triggered (e.g. fib lookup failure, etc).

Agreed. For our purpose we often want to know whether a specific
program has been invoked. Per-channel or per device stats don't help
us much since we have a chain of programs (not using libxdp though).
My colleague Arthur has written xdpcap [1], which gives per-action,
per-program counters. This way we can correlate an action with a
packet and a program.

> If really of interest, then maybe libxdp could have such per-action counters as opt-in in
> its call chain..

We could also make it part of BPF_ENABLE_STATS, it's kind of coarse
grained though.

> In the case of ice_run_xdp() today, we already bump total_rx_bytes/total_rx_pkts under
> XDP and update ice_update_rx_ring_stats(). I do see the case for XDP_TX and XDP_REDIRECT
> where we run into driver-specific errors that are /outside of the reach/ of the BPF prog.
> For example, we've been running into errors from XDP_TX in ice_xmit_xdp_ring() in the
> past during testing, and were able to pinpoint the location as xdp_ring->tx_stats.tx_busy
> was increasing. These things are useful and would make sense to standardize for XDP context.

I'd like to see more tracepoints like trace_xdp_exception, personally.
We can use things like bpftrace for exploration and ebpf_exporter [2]
to generate alerts much more easily than something wired into
iproute2.

Best
Lorenz

1: https://github.com/cloudflare/xdpcap
2: https://github.com/cloudflare/ebpf_exporter

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
