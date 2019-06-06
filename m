Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C54837DA4
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 21:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727676AbfFFTw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 15:52:59 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:53140 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727047AbfFFTw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 15:52:59 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hYyRT-0003ZA-8b; Thu, 06 Jun 2019 21:52:55 +0200
Date:   Thu, 6 Jun 2019 21:52:55 +0200
From:   Florian Westphal <fw@strlen.de>
To:     David Miller <davem@davemloft.net>
Cc:     fw@strlen.de, john.hurley@netronome.com, netdev@vger.kernel.org,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        jhs@mojatatu.com, oss-drivers@netronome.com
Subject: Re: [RFC net-next v2 1/1] net: sched: protect against loops in TC
 filter hooks
Message-ID: <20190606195255.4uelltuxptwobhiv@breakpoint.cc>
References: <1559825374-32117-1-git-send-email-john.hurley@netronome.com>
 <20190606125818.bvo5im2wqj365tai@breakpoint.cc>
 <20190606.111954.2036000288766363267.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606.111954.2036000288766363267.davem@davemloft.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller <davem@davemloft.net> wrote:
> From: Florian Westphal <fw@strlen.de>
> Date: Thu, 6 Jun 2019 14:58:18 +0200
> 
> >> @@ -827,6 +828,7 @@ struct sk_buff {
> >>  	__u8			tc_at_ingress:1;
> >>  	__u8			tc_redirected:1;
> >>  	__u8			tc_from_ingress:1;
> >> +	__u8			tc_hop_count:2;
> > 
> > I dislike this, why can't we just use a pcpu counter?
> 
> I understand that it's because the only precise context is per-SKB not
> per-cpu doing packet processing.  This has been discussed before.

I don't think its worth it, and it won't work with physical-world
loops (e.g. a bridge setup with no spanning tree and a closed loop).

Also I fear that if we start to do this for tc, we will also have to
followup later with more l2 hopcounts for other users, e.g. veth,
bridge, ovs, and so on.
