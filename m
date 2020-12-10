Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11CDD2D657F
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 19:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390614AbgLJSuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 13:50:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:60402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390578AbgLJStt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 13:49:49 -0500
Message-ID: <721648a5e14dadc32629291a7d1914dd1044b7d0.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607626148;
        bh=MkM5B3xfKGPd3WvgDd/FJyUo0iJpsgU0H2zBX1X5P6I=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=k+EITTv+grnKUv7nnr0WZHuPHZwQ126ggcczmEJdHIEg6B9KsAdHf9mJufLnWYTGo
         kcqhdlwETAznqvdpYtBa6VX8t6HdSMFBuwP4Jhar0uVjh+FZbyUgq7eHMjfxAKauPK
         CoyoupYzOa/bsIn4I0MBfchpfqvmpEmFcmbcCHL3WgKGH9u5Warf2YXMhK7KxJ7SXn
         l2SA/+ljjVVHtn/G01Uxi2na54m5Tq1SIEWRE/9A8tlUTsAKBC7LdkRBhLW2vCU5Pk
         OfSFMkhkavdaJMKUNJI5Pgr3OEjqH+Rk4EIOwB5ZW3fV6MjOUyinPUdaWkSYzCTU12
         xEUrV/Cc3F42Q==
Subject: Re: [PATCH bpf-next] net: xdp: introduce xdp_init_buff utility
 routine
From:   Saeed Mahameed <saeed@kernel.org>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, brouer@redhat.com,
        alexander.duyck@gmail.com
Date:   Thu, 10 Dec 2020 10:49:05 -0800
In-Reply-To: <20201210175945.GB462213@lore-desk>
References: <e54fb61ff17c21f022392f1bb46ec951c9b909cc.1607615094.git.lorenzo@kernel.org>
         <20201210160507.GC45760@ranger.igk.intel.com>
         <20201210163241.GA462213@lore-desk>
         <20201210165556.GA46492@ranger.igk.intel.com>
         <20201210175945.GB462213@lore-desk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-12-10 at 18:59 +0100, Lorenzo Bianconi wrote:
> On Dec 10, Maciej Fijalkowski wrote:
> > On Thu, Dec 10, 2020 at 05:32:41PM +0100, Lorenzo Bianconi wrote:
> > > > On Thu, Dec 10, 2020 at 04:50:42PM +0100, Lorenzo Bianconi
> > > > wrote:
> > > > > Introduce xdp_init_buff utility routine to initialize
> > > > > xdp_buff data
> > > > > structure. Rely on xdp_init_buff in all XDP capable drivers.
> > > > 
> > > > Hm, Jesper was suggesting two helpers, one that you implemented
> > > > for things
> > > > that are set once per NAPI and the other that is set per each
> > > > buffer.
> > > > 
> > > > Not sure about the naming for a second one - xdp_prepare_buff ?
> > > > xdp_init_buff that you have feels ok.
> > > 
> > > ack, so we can have xdp_init_buff() for initialization done once
> > > per NAPI run and 
> > > xdp_prepare_buff() for per-NAPI iteration initialization, e.g.
> > > 
> > > static inline void
> > > xdp_prepare_buff(struct xdp_buff *xdp, unsigned char *hard_start,
> > > 		 int headroom, int data_len)
> > > {
> > > 	xdp->data_hard_start = hard_start;
> > > 	xdp->data = hard_start + headroom;
> > > 	xdp->data_end = xdp->data + data_len;
> > > 	xdp_set_data_meta_invalid(xdp);
> > > }
> > 
> > I think we should allow for setting the data_meta as well.
> > x64 calling convention states that first four args are placed onto
> > registers, so to keep it fast maybe have a third helper:
> > 
> > static inline void
> > xdp_prepare_buff_meta(struct xdp_buff *xdp, unsigned char
> > *hard_start,
> > 		      int headroom, int data_len)
> > {
> > 	xdp->data_hard_start = hard_start;
> > 	xdp->data = hard_start + headroom;
> > 	xdp->data_end = xdp->data + data_len;
> > 	xdp->data_meta = xdp->data;
> > }
> > 
> > Thoughts?
> 
> ack, I am fine with it. Let's wait for some feedback.
> 
> Do you prefer to have xdp_prepare_buff/xdp_prepare_buff_meta in the
> same series
> of xdp_buff_init() or is it ok to address it in a separate patch?
> 

you only need 2
why do you need xpd_prepare_buff_meta? that's exactly
what xdp_set_data_meta_invalid(xdp) is all about.


