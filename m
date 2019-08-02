Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93ADD7EE3C
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 10:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403767AbfHBICH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 04:02:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45366 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728268AbfHBICH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Aug 2019 04:02:07 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 43EAF308A9E2;
        Fri,  2 Aug 2019 08:02:06 +0000 (UTC)
Received: from carbon (ovpn-200-29.brq.redhat.com [10.40.200.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 309CD5D9D3;
        Fri,  2 Aug 2019 08:01:59 +0000 (UTC)
Date:   Fri, 2 Aug 2019 09:53:54 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        xdp-newbies@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        brandon.cazander@multapplied.net,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        brouer@redhat.com
Subject: Re: [net v1 PATCH 4/4] net: fix bpf_xdp_adjust_head regression for
 generic-XDP
Message-ID: <20190802095350.7242399b@carbon>
In-Reply-To: <20190801174406.0b554bb9@cakuba.netronome.com>
References: <156468229108.27559.2443904494495785131.stgit@firesoul>
        <156468243184.27559.7002090473019021952.stgit@firesoul>
        <20190801174406.0b554bb9@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Fri, 02 Aug 2019 08:02:06 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 1 Aug 2019 17:44:06 -0700
Jakub Kicinski <jakub.kicinski@netronome.com> wrote:

> On Thu, 01 Aug 2019 20:00:31 +0200, Jesper Dangaard Brouer wrote:
> > When generic-XDP was moved to a later processing step by commit
> > 458bf2f224f0 ("net: core: support XDP generic on stacked devices.")
> > a regression was introduced when using bpf_xdp_adjust_head.
> > 
> > The issue is that after this commit the skb->network_header is now
> > changed prior to calling generic XDP and not after. Thus, if the header
> > is changed by XDP (via bpf_xdp_adjust_head), then skb->network_header
> > also need to be updated again.  Fix by calling skb_reset_network_header().
> > 
> > Fixes: 458bf2f224f0 ("net: core: support XDP generic on stacked devices.")
> > Reported-by: Brandon Cazander <brandon.cazander@multapplied.net>
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>  
> 
> Out of curiosity what was your conclusion regarding resetting the
> transport header as well?

Well, I don't know... I need some review, from e.g. Stephen that
changed this... I've added code snippets below signature to helper
reviewers (also helps understand below paragraph).

I think, we perhaps should call skb_reset_transport_header(), as we
change skb->data (via either __skb_pull() or __skb_push()), *BUT* I'm
not sure it is needed/required, as someone/something afterwards still
need to call skb_set_transport_header(), which also calls
skb_reset_transport_header() anyway.

I also want to ask reviewers, if we should move the call to
skb_reset_mac_len() (which Stephen added) in __netif_receive_skb_core()
into netif_receive_generic_xdp() (after the call to
skb_reset_network_header()), (it would be more natural to keep them
together)?

- - 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

Code snippet
	/* check if bpf_xdp_adjust_head was used */
	off = xdp->data - orig_data;
	if (off) {
		if (off > 0)
			__skb_pull(skb, off);
		else if (off < 0)
			__skb_push(skb, -off);

		skb->mac_header += off;
		skb_reset_network_header(skb);
	}


static inline bool skb_transport_header_was_set(const struct sk_buff *skb)
{
	return skb->transport_header != (typeof(skb->transport_header))~0U;
}

static inline unsigned char *skb_transport_header(const struct sk_buff *skb)
{
	return skb->head + skb->transport_header;
}

static inline void skb_reset_transport_header(struct sk_buff *skb)
{
	skb->transport_header = skb->data - skb->head;
}

static inline void skb_set_transport_header(struct sk_buff *skb,
					    const int offset)
{
	skb_reset_transport_header(skb);
	skb->transport_header += offset;
}

