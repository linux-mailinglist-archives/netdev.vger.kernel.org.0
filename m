Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1671584D2
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 22:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbgBJVdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 16:33:04 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:33250 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727056AbgBJVdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 16:33:04 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1j1Gfr-0000Kw-Dt; Mon, 10 Feb 2020 22:32:59 +0100
Date:   Mon, 10 Feb 2020 22:32:59 +0100
From:   Florian Westphal <fw@strlen.de>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2 net 1/5] icmp: introduce helper for NAT'd source
 address in network device context
Message-ID: <20200210213259.GI2991@breakpoint.cc>
References: <20200210141423.173790-1-Jason@zx2c4.com>
 <20200210141423.173790-2-Jason@zx2c4.com>
 <CAHmME9pa+x_i2b1HJi0Y8+bwn3wFBkM5Mm3bpVaH5z=H=2WJPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9pa+x_i2b1HJi0Y8+bwn3wFBkM5Mm3bpVaH5z=H=2WJPw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> On Mon, Feb 10, 2020 at 3:15 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > +               ip_hdr(skb_in)->saddr = ct->tuplehash[0].tuple.src.u3.ip;
> > +       }
> > +       icmp_send(skb_in, type, code, info);
> 
> According to the comments in icmp_send, access to
> ip_hdr(skb_in)->saddr requires first checking for `if
> (skb_network_header(skb_in) < skb_in->head ||
> (skb_network_header(skb_in) + sizeof(struct iphdr)) >
> skb_tail_pointer(skb_in))` first to be safe.

You will probably also need skb_ensure_writable() to handle cloned skbs.

I also suggest to check "ct->status & IPS_NAT_MASK", nat is only done if
those bits are set.
