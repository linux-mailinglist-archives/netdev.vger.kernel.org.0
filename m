Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D473B107A
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 01:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhFVXWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 19:22:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229704AbhFVXWH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 19:22:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B3A8600EF;
        Tue, 22 Jun 2021 23:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624403990;
        bh=3eBGjsipU4p5Rfq2y0i9xFf2Mk3jC+8e4Dwa+KFevBw=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=AFyvU966LIFTw+5rX/Rw4tQFBkeM327rh74IZ5Ox01r+9iIsM5jPg+6YQn6J3WMFC
         1Eow6O5IaFx9E6g1cI/3RBzXRU+bwu8ur6dDRF86xwQDbwHs/XdonHTfnAIlZlTjOb
         IOCjkEIp3GZ9F6mOwCiYYRpHPgAsmcABehZynhrHHXAXxAG95anP8143Oom7/xRTan
         E5YNm9nF7RLbnZ8b+dq6oeTVaEmNpgKMlvXVcLnpsJBq+Iw74Vk57fWAA7WiKwqrjz
         cO5bZCUfGtUesfRvExIAb7EQ1x0cPfFhBdGcUDWYfz5hbGa2FmWG+iIHm4z86DUFmQ
         nlsS61SHwBOVg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 5842B5C08B8; Tue, 22 Jun 2021 16:19:50 -0700 (PDT)
Date:   Tue, 22 Jun 2021 16:19:50 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 03/16] xdp: add proper __rcu annotations to
 redirect map entries
Message-ID: <20210622231950.GK4397@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20210617212748.32456-1-toke@redhat.com>
 <20210617212748.32456-4-toke@redhat.com>
 <1881ecbe-06ec-6b0a-836c-033c31fabef4@iogearbox.net>
 <87zgvirj6g.fsf@toke.dk>
 <87r1guovg2.fsf@toke.dk>
 <20210622202604.GH4397@paulmck-ThinkPad-P17-Gen-1>
 <874kdppo45.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <874kdppo45.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 11:48:26PM +0200, Toke Høiland-Jørgensen wrote:
> "Paul E. McKenney" <paulmck@kernel.org> writes:
> 
> > On Tue, Jun 22, 2021 at 03:55:25PM +0200, Toke Høiland-Jørgensen wrote:
> >> Toke Høiland-Jørgensen <toke@redhat.com> writes:
> >> 
> >> >> It would also be great if this scenario in general could be placed
> >> >> under the Documentation/RCU/whatisRCU.rst as an example, so we could
> >> >> refer to the official doc on this, too, if Paul is good with this.
> >> >
> >> > I'll take a look and see if I can find a way to fit it in there...
> >> 
> >> OK, I poked around in Documentation/RCU and decided that the most
> >> natural place to put this was in checklist.rst which already talks about
> >> local_bh_disable(), but a bit differently. Fixing that up to correspond
> >> to what we've been discussing in this thread, and adding a mention of
> >> XDP as a usage example, results in the patch below.
> >> 
> >> Paul, WDYT?
> >
> > I think that my original paragraph needed to have been updated back
> > when v4.20 came out.  And again when RCU Tasks Trace came out.  ;-)
> >
> > So I did that updating, then approximated your patch on top of it,
> > as shown below.  Does this work for you?
> 
> Yup, LGTM, thanks! Shall I just fold that version into the next version
> of my series, or do you want to take it through your tree (I suppose
> it's independent of the rest, so either way is fine by me)?

I currently have the two here in -rcu, most likely for v5.15 (as in
the merge window after the upcoming one):

2b7cb9d95ba4 ("doc: Clarify and expand RCU updaters and corresponding readers")
c6ef58907d22 ("doc: Give XDP as example of non-obvious RCU reader/updater pairing")

I am happy taking it, but if you really would like to add it to your
series, please do take both.  ;-)

							Thanx, Paul
