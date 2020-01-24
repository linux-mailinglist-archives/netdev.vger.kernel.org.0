Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C92E148AA4
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730953AbgAXOwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:52:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:44680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730287AbgAXOwq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 09:52:46 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A720720704;
        Fri, 24 Jan 2020 14:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579877565;
        bh=SWQtWFvP2yM5RTM0cJf3qzdhWsmk+CUpbrJZ2ck+Zxs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OCVmpaFORc4TqvptdkWJvnSmyl70Z5uEf4IYVdy2heKCgllI6QmjqNjE5dPmwoMc5
         alByYmV1Ni3acbhUsPp8oHgHQwlQGcgyxLMskSrIWb1kCQj5giif02TdhILDTAV40O
         JnSNpt0ygT2a7bzyGY/sTqSgY1yvQldsjg1z3OsY=
Date:   Fri, 24 Jan 2020 06:52:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Luigi Rizzo <lrizzo@google.com>, netdev@vger.kernel.org,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, sameehj@amazon.com,
        toke@redhat.com
Subject: Re: [PATCH net-next] v2 net-xdp: netdev attribute to control
 xdpgeneric skb linearization
Message-ID: <20200124065244.4cafef68@cakuba>
In-Reply-To: <3a7e66da-7506-47a0-8733-8d48674176f9@iogearbox.net>
References: <20200123232054.183436-1-lrizzo@google.com>
        <3a7e66da-7506-47a0-8733-8d48674176f9@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Jan 2020 10:55:19 +0100, Daniel Borkmann wrote:
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 4dcc1b390667..13a671e45b61 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -4484,8 +4484,8 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
> >   	 * of XDP_PACKET_HEADROOM bytes. This is the guarantee that also
> >   	 * native XDP provides, thus we need to do it here as well.
> >   	 */
> > -	if (skb_is_nonlinear(skb) ||
> > -	    skb_headroom(skb) < XDP_PACKET_HEADROOM) {
> > +	if (skb->dev->xdp_linearize && (skb_is_nonlinear(skb) ||
> > +	    skb_headroom(skb) < XDP_PACKET_HEADROOM)) {
> >   		int hroom = XDP_PACKET_HEADROOM - skb_headroom(skb);
> >   		int troom = skb->tail + skb->data_len - skb->end;  
> 
> I still think in order for this knob to be generally useful, we would need to
> provide an equivalent of bpf_skb_pull_data() helper, which in generic XDP would then
> pull in more data from non-linear section, and in native XDP would be a "no-op" since
> the frame is already linear. Otherwise, as mentioned in previous thread, users would
> have no chance to examine headers if they are not pre-pulled by the driver.

Which takes us to the point of the ongoing work to allow multi-buffer
frames in native mode. Sorry if this was already mentioned but this
seems like the other side of the same coin, once we have multi-buffer
semantics in native mode we can likely just replicate them for skbs, no?
