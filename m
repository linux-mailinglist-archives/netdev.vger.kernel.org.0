Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77BC04B4BB
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 11:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731334AbfFSJNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 05:13:53 -0400
Received: from mail-lj1-f177.google.com ([209.85.208.177]:41780 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731164AbfFSJNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 05:13:53 -0400
Received: by mail-lj1-f177.google.com with SMTP id s21so2486549lji.8
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 02:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=vh1CRzmTP1CzAi7wNtIPxyruWC6hMcZTxd2c7I3bv0Y=;
        b=PINqg8ALuTpuoTGM2paZEkIslf6rrAdsEnOHxpSECdAFmTeVDD2VFdQmckmZkKRUiJ
         SsuwrICm01m/Lq85or9oiUntxBa+CiWSYAUwWsbAlUTvVZoaCMkQc7VD5fDQNq9xaCOr
         0UnAn4G6c+IFAp1AFaJ8LYzaRB1GVgZaAqSD8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=vh1CRzmTP1CzAi7wNtIPxyruWC6hMcZTxd2c7I3bv0Y=;
        b=EikBtO2qdBlNTV0a/utJ+etdtiNrtia3LatU1S4G54SKvt3d7xo4jwgaWz/jrvPMkl
         mGwPiflqyaxcwOa2p3AnOZ2HiLptFrphgNfusZPGS2WiqwCwGNZurGm9mRIuY3BHNjDS
         80f/RybCdxvpHwgIy3d5TOlvZYjH18PZ4lOOO78vkFeUeURz9VTSdvrG5l2YdJ+OLfPb
         VdzMT/6a6UU5+MHD3+0qOO7lmjPlT1XwUYQXTL4NlhiRi9tyoeFq+w3qZ+gUe3XVtWKU
         8bX42guoHelIfkjN8D5lDz+p9iOW56E9vcPCx7ieKsxAu+Y6ZbYquIhCwttaYY8aFQWd
         JwQQ==
X-Gm-Message-State: APjAAAWUS8ls5uZotPZIUkXTyK6sk7Jz3y53iAf5UC340WEz4PzRur4d
        4wcvRCmHABZaXB6EG5ba4zJJPw==
X-Google-Smtp-Source: APXvYqyfNJqikoGU2Lrlrfb3DPRmxv8jD2BJFI5mkBAr2elcdHBQyHwLqpWpJ4TlwgGWIBE8iHjiFQ==
X-Received: by 2002:a2e:7315:: with SMTP id o21mr5780021ljc.3.1560935630168;
        Wed, 19 Jun 2019 02:13:50 -0700 (PDT)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id z26sm3000354ljz.64.2019.06.19.02.13.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 19 Jun 2019 02:13:49 -0700 (PDT)
References: <20190618130050.8344-1-jakub@cloudflare.com> <20190618135258.spo6c457h6dfknt2@breakpoint.cc>
User-agent: mu4e 1.1.0; emacs 26.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@cloudflare.com
Subject: Re: [RFC bpf-next 0/7] Programming socket lookup with BPF
In-reply-to: <20190618135258.spo6c457h6dfknt2@breakpoint.cc>
Date:   Wed, 19 Jun 2019 11:13:48 +0200
Message-ID: <87sgs6ey43.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Florian,

Thanks for taking a look at it.

On Tue, Jun 18, 2019 at 03:52 PM CEST, Florian Westphal wrote:
> Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>  - XDP programs using bpf_sk_lookup helpers, like load balancers, can't
>>    find the listening socket to check for SYN cookies with TPROXY redirect.
>
> Sorry for the question, but where is the problem?
> (i.e., is it with TPROXY or bpf side)?

The way I see it is that the problem is that we have mappings for
steering traffic into sockets split between two places: (1) the socket
lookup tables, and (2) the TPROXY rules.

BPF programs that need to check if there is a socket the packet is
destined for have access to the socket lookup tables, via the mentioned
bpf_sk_lookup helper, but are unaware of TPROXY redirects.

For TCP we're able to look up from BPF if there are any established,
request, and "normal" listening sockets. The listening sockets that
receive connections via TPROXY are invisible to BPF progs.

Why are we interested in finding all listening sockets? To check if any
of them had SYN queue overflow recently and if we should honor SYN
cookies.

>>  - TPROXY takes a reference to the listening socket on dispatch, which
>>    raises lock contention concerns.
>
> FWIW this could be avoided in similar way as to how we handle noref dsts.
>
> The only reason we need to take the reference at the moment is because
> once skb leaves the TPROXY target hook, the skb could leave rcu
> protection as well at some point (nfqueue for example).
>
> Maybe its even enough to move reference taking to nfqueue and add
> 'noref' destructor, that would allow skb_steal_sock to propagate
> refcounted value in __inet_lookup_skb.
>
> So, at least for this part I don't see a technical reason why this
> has to grab a reference for listener socket.

That's helpful, thanks! We rely on TPROXY, so I would like to help with
that. Let me see if I can get time to work on it.

>
>>  - Traffic steering configuration is split over several iptables rules, at
>>    least one per service, which makes configuration changes error prone.
>
> Could you perhaps sketch an example ruleset (doesn't have to be complete
> nor parse-able by itpables-restore), I would just like to understand if
> there is any room for improvement on netfilter/iptables/nft side.

Happy to. Scenarios that are of interest to us:

1) Port sharing, while accepting on a set of subnets
   (same are the demo BPF prog from cover letter)

  ip route add local 192.0.2.0/24 dev lo
  ip route add local 198.51.100.0/24 dev lo
  ip route add local 203.0.113.0/24 dev lo

  ipset create net1 hash:net
  ipset create net2 hash:net
  ipset create net3 hash:net

  ipset add net1 192.0.2.0/24
  ipset add net2 198.51.100.0/24
  ipset add net3 203.0.113.0/24

  iptables -t mangle -A PREROUTING -p tcp --dport 80 \
           -m set --match-set net1 dst \
           -j TPROXY --on-ip=127.0.0.1 --on-port=81

  iptables -t mangle -A PREROUTING -p tcp --dport 80 \
           -m set --match-set net2 dst \
           -j TPROXY --on-ip=127.0.0.1 --on-port=82

2) Receving on all ports, except some

  iptables -t mangle -A PREROUTING -p tcp --dport 80 \
           -m set --match-set net3 dst \
           -j TPROXY --on-ip=127.0.0.1 --on-port=81

  iptables -t mangle -A PREROUTING -p tcp \
           -m set --match-set net3 dst \
           -j TPROXY --on-ip=127.0.0.1 --on-port=1

3) Steering part of the traffic to a different socket (A/B testing)

  iptables -t mangle -A PREROUTING -p tcp \
           -m set --match-set net3 dst \
           -m statistic --mode random --probability 0.01 \
           -j TPROXY --on-ip=127.0.0.1 --on-port=2

  iptables -t mangle -A PREROUTING -p tcp \
           -m set --match-set net3 dst \
           -j TPROXY --on-ip=127.0.0.1 --on-port=1

One thing I haven't touched on in the cover letter is that to use TPROXY
you need to set IP_TRANSPARENT on the listening socket. This requires
that your process runs with CAP_NET_RAW or CAP_NET_ADMIN, or that you
get the socket from systemd.

I haven't been able to explain why the process needs to be privileged to
receive traffic steered with TPROXY, but it turns out to be a pain point
too. We end up having to lock down the service to ensure it doesn't use
the elevated privileges for anything else than setting IP_TRANSPARENT.

Thanks,
Jakub
