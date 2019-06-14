Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1641646150
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 16:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbfFNOpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 10:45:31 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:34600 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728323AbfFNOpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 10:45:31 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hbnSK-0006hy-Jw; Fri, 14 Jun 2019 16:45:28 +0200
Date:   Fri, 14 Jun 2019 16:45:28 +0200
From:   Florian Westphal <fw@strlen.de>
To:     John Hurley <john.hurley@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, fw@strlen.de,
        jhs@mojatatu.com, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com
Subject: Re: [RFC net-next 2/2] net: sched: protect against stack overflow in
 TC act_mirred
Message-ID: <20190614144528.fmmjqdguqlnonpyt@breakpoint.cc>
References: <1560522831-23952-1-git-send-email-john.hurley@netronome.com>
 <1560522831-23952-3-git-send-email-john.hurley@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560522831-23952-3-git-send-email-john.hurley@netronome.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Hurley <john.hurley@netronome.com> wrote:
> TC hooks allow the application of filters and actions to packets at both
> ingress and egress of the network stack. It is possible, with poor
> configuration, that this can produce loops whereby an ingress hook calls
> a mirred egress action that has an egress hook that redirects back to
> the first ingress etc. The TC core classifier protects against loops when
> doing reclassifies but there is no protection against a packet looping
> between multiple hooks and recursively calling act_mirred. This can lead
> to stack overflow panics.
> 
> Add a per CPU counter to act_mirred that is incremented for each recursive
> call of the action function when processing a packet. If a limit is passed
> then the packet is dropped and CPU counter reset.
> 
> Note that this patch does not protect against loops in TC datapaths. Its
> aim is to prevent stack overflow kernel panics that can be a consequence
> of such loops.

LGTM, thanks.
