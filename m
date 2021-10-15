Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D38042EE3A
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 11:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234814AbhJOJ71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 05:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233716AbhJOJ7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 05:59:25 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720AAC061570;
        Fri, 15 Oct 2021 02:57:19 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mbJxk-0008PF-Ra; Fri, 15 Oct 2021 11:57:16 +0200
Date:   Fri, 15 Oct 2021 11:57:16 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH netfilter] netfilter: conntrack: udp: generate event on
 switch to stream timeout
Message-ID: <20211015095716.GH2942@breakpoint.cc>
References: <20211015090934.2870662-1-zenczykowski@gmail.com>
 <YWlKGFpHa5o5jFgJ@salvia>
 <CANP3RGdCBzjWuK8FfHOOKcFAbd_Zru=DkOBBpD3d_PYDR91P5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANP3RGdCBzjWuK8FfHOOKcFAbd_Zru=DkOBBpD3d_PYDR91P5g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Żenczykowski <zenczykowski@gmail.com> wrote:
> > Hm, I still don't understand why do you need this extra 3rd
> > update/assured event event. Could you explain your usecase?
> 
> Currently we populate a flow offload array on the assured event, and
> thus the flow in both directions starts bypassing the kernel.
> Hence conntrack timeout is no longer automatically refreshed - and
> there is no opportunity for the timeout to get bumped to the stream
> timeout of 120s - it stays at 30s.
> We periodically (every just over 60-ish seconds) check whether packets
> on a flow have been offloaded, and if so refresh the conntrack
> timeout.  This isn't cheap and we don't want to do it even more often.
> However this 60s cycle > 30s non-stream udp timeout, so the kernel
> conntrack entry expires (and we must thus clear out the flow from the
> offload).  This results in a broken udp stream - but only on newer
> kernels.  Older kernels don't have this '2s' wait feature (which makes
> a lot of sense btw.) but as a result of this the conntrack assured
> event happens at the right time - when the timeout hits 120s (or 180s
> on even older kernels).
> 
> By generating another assured event when the udp stream is 'confirmed'
> and the timeout is boosted from 30s to 120s we have an opportunity to
> ignore the first one (with timeout 30) and only populate the offload
> on the second one (with timeout 120).
> 
> I'm not sure if I'm doing a good job of describing this.  Ask again if
> it's not clear and I'll try again.

Thanks for explaining, no objections to this from my side.

Do you think it makes sense to just delay setting the ASSURED bit
until after the 2s period?
