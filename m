Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4C4635EE91
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 09:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349517AbhDNHlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 03:41:44 -0400
Received: from void.so ([95.85.17.176]:31207 "EHLO void.so"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232504AbhDNHlm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 03:41:42 -0400
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Apr 2021 03:41:42 EDT
Received: from void.so (localhost [127.0.0.1])
        by void.so (Postfix) with ESMTP id 7A6EC1C2AB7;
        Wed, 14 Apr 2021 10:35:26 +0300 (MSK)
Received: from void.so ([127.0.0.1])
        by void.so (void.so [127.0.0.1]) (amavisd-new, port 10024) with LMTP
        id aEbjF7fypsrM; Wed, 14 Apr 2021 10:35:25 +0300 (MSK)
Received: from rnd (unknown [91.244.183.205])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by void.so (Postfix) with ESMTPSA id C85401C2A8F;
        Wed, 14 Apr 2021 10:35:24 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=void.so; s=mail;
        t=1618385725; bh=LsWiFWRn6e3uVdSzey5wxdT3Rfim8kYzeFNX3JB4cvQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=TbGh9J0rcrI9+EWsyc70eAlfCdFLvXwN5kYlj37+tV+uYDFh2GjkkELBnbj5R5saL
         mtvW2dLvWWjdfzmQMAZcdegjZjgwbuCB4kucG6HiICZfknRLmJ+NVodM1+z0KGfzpq
         +bbEDKMe3LjwjtkUMNSrshOxgo9vnIHpRVsukd4E=
Date:   Wed, 14 Apr 2021 10:33:38 +0300
From:   Pavel Balaev <mail@void.so>
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Cc:     christophe.jaillet@wanadoo.fr, davem@davemloft.net,
        kuba@kernel.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org
Subject: Re: [PATCH v3 net-next] net: multipath routing: configurable seed
Message-ID: <YHaa0pRCTKFbEhA2@rnd>
References: <YHWGmPmvpQAT3BcV@rnd>
 <08aba836-162e-b5d3-7a93-0488489be798@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <08aba836-162e-b5d3-7a93-0488489be798@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 08:28:52PM -0700, David Ahern wrote:
> On 4/13/21 4:55 AM, Balaev Pavel wrote:
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
> > In this use case, two ECMP routers balance traffic between
> > two firewalls. If some flow transmits a response over a different channel than request,
> > such flow will be dropped, because keep-state rules are created on
> > the other firewall.
> > 
> > This patch adds sysctl variable: net.ipv4.fib_multipath_hash_seed.
> > User can set the same seed value on GW0 and GW1 for traffic to be
> > mirror-balanced. By default, random value is used.
> > 
> > Signed-off-by: Balaev Pavel <balaevpa@infotecs.ru>
> > ---
> >  Documentation/networking/ip-sysctl.rst |  14 ++++
> >  include/net/flow_dissector.h           |   4 +
> >  include/net/netns/ipv4.h               |  20 +++++
> >  net/core/flow_dissector.c              |   9 +++
> >  net/ipv4/af_inet.c                     |   5 ++
> >  net/ipv4/route.c                       |  10 ++-
> >  net/ipv4/sysctl_net_ipv4.c             | 104 +++++++++++++++++++++++++
> >  7 files changed, 165 insertions(+), 1 deletion(-)
> > 
> 
> This should work the same for IPv6.
I wanted to add IPv6 support after IPv4 will be approved,
anyway no problem, will add IPv6 in next version 
> And please add test cases under tools/testing/selftests/net.
This feature cannot be tested whithin one host instance, becasue the same seed
will be used by default for all netns, so results will be the same
anyway, should I use QEMU for this tests?
 
