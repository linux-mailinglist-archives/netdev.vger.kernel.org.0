Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 270F99AB2F
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 11:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbfHWJMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 05:12:39 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:51688 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726980AbfHWJMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 05:12:39 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i15cb-0001k7-BL; Fri, 23 Aug 2019 11:12:37 +0200
Date:   Fri, 23 Aug 2019 11:12:37 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Dan Siemon <dan@coverfire.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: Bridge zeros out skb->cb in 5.2 (not in 5.1)
Message-ID: <20190823091237.GK20113@breakpoint.cc>
References: <CAB2AaTmtwpHKvuOi6a-54SW1JXUxt1N03Lb=GXMVv_-y+zYyEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB2AaTmtwpHKvuOi6a-54SW1JXUxt1N03Lb=GXMVv_-y+zYyEA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dan Siemon <dan@coverfire.com> wrote:

[ CCing bpf maling list ]

> Commit f12064d1b402c60c5db9c4b63d5ed6d7facb33f6 zeros out skb->cb in
> br_input.c:
> 
> memset(skb->cb, 0, sizeof(struct br_input_skb_cb));
> 
> https://github.com/torvalds/linux/commit/f12064d1b402c60c5db9c4b63d5ed6d7facb33f6
> 
> Prior to 5.2, it was possible to store information in skb->cb and have it
> pass through the bridge to the output link.

I did not know this was even possible.

Any owner of the skb (bridge, ip stack, etc.) use skb->cb[] as they see fit.

> We leveraged this to have a BPF
> prog that runs on ingress and does custom packet parsing and stores the
> output qdisc:class in skb->cb. This enabled the egress BPF filter to be
> super simple and avoid having to parse the entire packet again.
> 
> Note I haven't built with this patch removed so it's possible this isn't
> the problem but the memset is unconditional...

You're not exactly saying what the problem is, so I have no idea.

> Is this a regression? Is it expected that the bridge would wipe this field
> when just passing frames?

Even if you remove the memset, that commit br_input_skb_cb
has existed, and is used.  Fields were just cleared on-demand rather
than unconditionally at the start.

I think the latter is better practice and also what other owners do.
So please explain what exactly the problem is and/or check that the
cb clearing "is the problem".

If it is, I have no idea how to fix it.
