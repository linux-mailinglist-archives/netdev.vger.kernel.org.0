Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3429E527BA
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 11:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729925AbfFYJPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 05:15:11 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:59922 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728365AbfFYJPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 05:15:11 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hfhXf-0000Vt-UI; Tue, 25 Jun 2019 11:15:07 +0200
Date:   Tue, 25 Jun 2019 11:15:07 +0200
From:   Florian Westphal <fw@strlen.de>
To:     John Hurley <john.hurley@netronome.com>
Cc:     Eyal Birger <eyal.birger@gmail.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        oss-drivers@netronome.com, shmulik@metanetworks.com
Subject: Re: [PATCH net-next 2/2] net: sched: protect against stack overflow
 in TC act_mirred
Message-ID: <20190625091507.pwtingx6yk4ltmbo@breakpoint.cc>
References: <1561414416-29732-1-git-send-email-john.hurley@netronome.com>
 <1561414416-29732-3-git-send-email-john.hurley@netronome.com>
 <20190625113010.7da5dbcb@jimi>
 <CAK+XE=mOjtp16tdz83RZ-x_jEp3nPRY3smxbG=OfCmGi9_DnXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK+XE=mOjtp16tdz83RZ-x_jEp3nPRY3smxbG=OfCmGi9_DnXg@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Hurley <john.hurley@netronome.com> wrote:
> Hi Eyal,
> The value of 4 is basically a revert to what it was on older kernels
> when TC had a TTL value in the skb:
> https://elixir.bootlin.com/linux/v3.19.8/source/include/uapi/linux/pkt_cls.h#L97

IIRC this TTL value was not used ever.

> I also found with my testing that a value greater than 4 was sailing
> close to the edge.
> With a larger value (on my system anyway), I could still trigger a
> stack overflow here.
> I'm not sure on the history of why a value of 4 was selected here but
> it seems to fall into line with my findings.
> Is there a hard requirement for >4 recursive calls here?

One alternative would be to (instead of dropping the skb), to
decrement the ttl and use netif_rx() instead.
