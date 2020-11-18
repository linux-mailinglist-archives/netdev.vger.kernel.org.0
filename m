Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF8742B821D
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 17:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgKRQo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 11:44:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:34374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726092AbgKRQo5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 11:44:57 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DCB2208FE;
        Wed, 18 Nov 2020 16:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605717896;
        bh=y/mCOfrZHfKr2/U1eTKwpvHjjwDOsoXWVEPxClsf2Zg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ryYY1TErpcdbSqw0S7k5Ep88dSPaVVGG+dOMnPPZH22DMkvB+cG3L1HW7uvweS37/
         qZjJL2mpWEZO9DkSWWpwjyTUjKIWlhLMCLdpibEHKC1FQcWVVbb8MeLzWH2dhDadhv
         c6zkqzDHgFWKmnUh7Es+Is0UhXVM+JTT7oK6VsnY=
Date:   Wed, 18 Nov 2020 08:44:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        davem <davem@davemloft.net>, Guillaume Nault <gnault@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>, lorenzo@kernel.org,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH net-next] ip_gre: remove CRC flag from dev features in
 gre_gso_segment
Message-ID: <20201118084455.10f903ec@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CADvbK_eP4ap74vbZ64S8isYr5nz33ZdLB7qsyqd5zqqGV-rvWA@mail.gmail.com>
References: <52ee1b515df977b68497b1b08290d00a22161279.1605518147.git.lucien.xin@gmail.com>
        <20201117162952.29c1a699@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CADvbK_eP4ap74vbZ64S8isYr5nz33ZdLB7qsyqd5zqqGV-rvWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 14:14:49 +0800 Xin Long wrote:
> On Wed, Nov 18, 2020 at 8:29 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Mon, 16 Nov 2020 17:15:47 +0800 Xin Long wrote:  
> > > This patch is to let it always do CRC checksum in sctp_gso_segment()
> > > by removing CRC flag from the dev features in gre_gso_segment() for
> > > SCTP over GRE, just as it does in Commit 527beb8ef9c0 ("udp: support
> > > sctp over udp in skb_udp_tunnel_segment") for SCTP over UDP.
> > >
> > > It could set csum/csum_start in GSO CB properly in sctp_gso_segment()
> > > after that commit, so it would do checksum with gso_make_checksum()
> > > in gre_gso_segment(), and Commit 622e32b7d4a6 ("net: gre: recompute
> > > gre csum for sctp over gre tunnels") can be reverted now.
> > >
> > > Signed-off-by: Xin Long <lucien.xin@gmail.com>  
> >
> > Makes sense, but does GRE tunnels don't always have a csum.  
> Do you mean the GRE csum can be offloaded? If so, it seems for GRE tunnel
> we need the similar one as:
> 
> commit 4bcb877d257c87298aedead1ffeaba0d5df1991d
> Author: Tom Herbert <therbert@google.com>
> Date:   Tue Nov 4 09:06:52 2014 -0800
> 
>     udp: Offload outer UDP tunnel csum if available
> 
> I will confirm and implement it in another patch.
> 
> >
> > Is the current hardware not capable of generating CRC csums over
> > encapsulated patches at all?  
> There is, but very rare. The thing is after doing CRC csum, the outer
> GRE/UDP checksum will have to be recomputed, as it's NOT zero after
> all fields for CRC scum are summed, which is different from the
> common checksum. So if it's a GRE/UDP tunnel, the inner CRC csum
> has to be done there even if the HW supports its offload.

Ack, my point is that for UDP tunnels (at least with IPv4) the UDP
checksum is optional (should be ignored if the header field is 0),
and for GRE checksum is optional and it's presence is indicated by 
a bit in the header IIRC.

So if the HW can compute the CRC csum based on offsets, without parsing
the packet, it should be able to do the CRC on tunneled packets w/o
checksum in the outer header.

IDK how realistic this is, whether it'd work today, and whether we care
about it...
