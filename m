Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1692136C1FE
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 11:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235049AbhD0JpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 05:45:03 -0400
Received: from void.so ([95.85.17.176]:23633 "EHLO void.so"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231148AbhD0JpC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 05:45:02 -0400
Received: from void.so (localhost [127.0.0.1])
        by void.so (Postfix) with ESMTP id 09D262B2FBA;
        Tue, 27 Apr 2021 12:44:16 +0300 (MSK)
Received: from void.so ([127.0.0.1])
        by void.so (void.so [127.0.0.1]) (amavisd-new, port 10024) with LMTP
        id Oi39z_JHYqM4; Tue, 27 Apr 2021 12:44:11 +0300 (MSK)
Received: from rnd (unknown [91.244.183.205])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by void.so (Postfix) with ESMTPSA id 1F42D2B2FB9;
        Tue, 27 Apr 2021 12:44:10 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=void.so; s=mail;
        t=1619516651; bh=udsMXhoCPIqP09TaGi8Jjej4w+1ijnRhTTeyhYR6ZMc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=VYt/9ZQIhAJBl2nAa1cgTOHPDqShBi5Ei+cvze9QbyTQiJKhr0ByCRKo2sytBdrZr
         SHrcV5aGliuiLisT9gMLxqXOjvSOhRdftMyNahoCo+8A1fVkPqF/Bcw9ITPq8yT11e
         Qq0hWeYR3q0b+PseMIWH8ixQKdvyFcZRQDT77A0A=
Date:   Tue, 27 Apr 2021 12:42:20 +0300
From:   Pavel Balaev <mail@void.so>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH v4 net-next] net: multipath routing: configurable seed
Message-ID: <YIfcfEiym5PKAe0w@rnd>
References: <YILPPCyMjlnhPmEN@rnd>
 <93ca6644-fc5a-0977-db7d-16779ebd320c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <93ca6644-fc5a-0977-db7d-16779ebd320c@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 09:21:53PM -0600, David Ahern wrote:
> On 4/23/21 6:44 AM, Balaev Pavel wrote:
> > Ability for a user to assign seed value to multipath route hashes.
> > Now kernel uses random seed value to prevent hash-flooding DoS attacks;
> > however, it disables some use cases, f.e:
> > 
> > +-------+        +------+        +--------+
> > |       |-eth0---| FW0  |---eth0-|        |
> > |       |        +------+        |        |
> > |  GW0  |ECMP                ECMP|  GW1   |
> > |       |        +------+        |        |
> > |       |-eth1---| FW1  |---eth1-|        |
> > +-------+        +------+        +--------+
> > 
> > In this use case, two ECMP routers balance traffic between two firewalls.
> > If some flow transmits a response over a different channel than request,
> > such flow will be dropped, because keep-state rules are created on
> > the other firewall.
> > 
> > This patch adds sysctl variable: net.ipv4|ipv6.fib_multipath_hash_seed.
> > User can set the same seed value on GW0 and GW1 for traffic to be
> > mirror-balanced. By default, random value is used.
> > 
> > Signed-off-by: Balaev Pavel <balaevpa@infotecs.ru>
> > ---
> >  Documentation/networking/ip-sysctl.rst        |  14 +
> >  include/net/flow_dissector.h                  |   4 +
> >  include/net/netns/ipv4.h                      |   2 +
> >  include/net/netns/ipv6.h                      |   3 +
> >  net/core/flow_dissector.c                     |   9 +
> >  net/ipv4/route.c                              |  10 +-
> >  net/ipv4/sysctl_net_ipv4.c                    |  97 +++++
> >  net/ipv6/route.c                              |  10 +-
> >  net/ipv6/sysctl_net_ipv6.c                    |  96 +++++
> >  .../testing/selftests/net/forwarding/Makefile |   1 +
> >  tools/testing/selftests/net/forwarding/lib.sh |  41 +++
> >  .../net/forwarding/router_mpath_seed.sh       | 347 ++++++++++++++++++
> >  12 files changed, 632 insertions(+), 2 deletions(-)
> >  create mode 100755 tools/testing/selftests/net/forwarding/router_mpath_seed.sh
> 
> this really needs to be multiple patches. At a minimum 1 for ipv4, 1 for
> ipv6 and 1 for the test script (thank you for adding that).
> 
> [ cc'ed Ido since most of the tests under
> tools/testing/selftests/net/forwarding come from him and team ]

OK, I will create 3 patches. Thanks for the advice.

> > 
> > diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> > index 9701906f6..d1a67e6fe 100644
> > --- a/Documentation/networking/ip-sysctl.rst
> > +++ b/Documentation/networking/ip-sysctl.rst
> > @@ -100,6 +100,20 @@ fib_multipath_hash_policy - INTEGER
> >  	- 1 - Layer 4
> >  	- 2 - Layer 3 or inner Layer 3 if present
> >  
> > +fib_multipath_hash_seed - STRING
> > +	Controls seed value for multipath route hashes. By default
> > +	random value is used. Only valid for kernels built with
> > +	CONFIG_IP_ROUTE_MULTIPATH enabled.
> > +
> > +	Valid format: two hex values set off with comma or "random"
> > +	keyword.
> > +
> > +	Example to generate the seed value::
> > +
> > +		RAND=$(openssl rand -hex 16) && echo "${RAND:0:16},${RAND:16:16}"
> > +
> > +	Default: "random"
> > +
> >  fib_sync_mem - UNSIGNED INTEGER
> >  	Amount of dirty memory from fib entries that can be backlogged before
> >  	synchronize_rcu is forced.
> > diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
> > index ffd386ea0..2bd4e28de 100644
> > --- a/include/net/flow_dissector.h
> > +++ b/include/net/flow_dissector.h
> > @@ -348,6 +348,10 @@ static inline bool flow_keys_have_l4(const struct flow_keys *keys)
> >  }
> >  
> >  u32 flow_hash_from_keys(struct flow_keys *keys);
> > +#ifdef CONFIG_IP_ROUTE_MULTIPATH
> > +u32 flow_multipath_hash_from_keys(struct flow_keys *keys,
> > +			   const siphash_key_t *seed);
> 
> column alignment looks off here ^^^^ and a few other places; please
> correct in the next version.
> 
After running "scripts/checkpatch.pl" I got warnings about alignment.
So I run checkpatch.pl --fix and fixed alignment as a script did.
So warnings goes away. I don't get the rules of alignment, can you 
tell me the right way?
