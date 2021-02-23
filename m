Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB05322B9C
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 14:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbhBWNnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 08:43:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33191 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232752AbhBWNnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 08:43:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614087733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4pyj+MDg3D0lSmS/jJmU1uY6ZedP+DGHmYasaylhky0=;
        b=WxBw+iTYhdAWVvrUvwBH17o77P+CdypuIQ29kpM1OX/Ny3PwHb0iGAUXXVHldSJjZS0h2O
        86MDajpa8BYK23wKpyrtZ4UIr2jtMvVG/AapWDD7lvsAU7QT6DwDI7pmHkX5svxqE6Mvqn
        6nYpDtvbAM1cteuwmwjif/08K/ECMl0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-eJeQ-4O9PPCl3IEHZSfWKw-1; Tue, 23 Feb 2021 08:42:11 -0500
X-MC-Unique: eJeQ-4O9PPCl3IEHZSfWKw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 02C8680403A;
        Tue, 23 Feb 2021 13:42:10 +0000 (UTC)
Received: from bnemeth.users.ipa.redhat.com (ovpn-112-72.ams2.redhat.com [10.36.112.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A65319C46;
        Tue, 23 Feb 2021 13:42:05 +0000 (UTC)
Message-ID: <1bcc8d88b4cb7ad5610a045fc013127d3055b0d8.camel@redhat.com>
Subject: Re: [PATCH] net: check if protocol extracted by
 virtio_net_hdr_set_proto is correct
From:   Balazs Nemeth <bnemeth@redhat.com>
To:     Jason Wang <jasowang@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Miller <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org
Date:   Tue, 23 Feb 2021 14:42:04 +0100
In-Reply-To: <8168e98e-d608-750a-9b49-b1e60a23714c@redhat.com>
References: <5e910d11a14da17c41317417fc41d3a9d472c6e7.1613659844.git.bnemeth@redhat.com>
         <CA+FuTSe7srSBnAmFNFBFkDrLmPL5XtxhbXEs1mBytUBuuym2fg@mail.gmail.com>
         <2cc06597-8005-7be8-4094-b20f525afde8@redhat.com>
         <CA+FuTSf2GCi+RzpkFeBgtSOyhjsBFfApjekzupHLfyeYDn-JYQ@mail.gmail.com>
         <8168e98e-d608-750a-9b49-b1e60a23714c@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-02-22 at 11:39 +0800, Jason Wang wrote:
> 
> On 2021/2/19 10:55 下午, Willem de Bruijn wrote:
> > On Fri, Feb 19, 2021 at 3:53 AM Jason Wang <jasowang@redhat.com>
> > wrote:
> > > 
> > > On 2021/2/18 11:50 下午, Willem de Bruijn wrote:
> > > > On Thu, Feb 18, 2021 at 10:01 AM Balazs Nemeth <
> > > > bnemeth@redhat.com> wrote:
> > > > > For gso packets, virtio_net_hdr_set_proto sets the protocol
> > > > > (if it isn't
> > > > > set) based on the type in the virtio net hdr, but the skb
> > > > > could contain
> > > > > anything since it could come from packet_snd through a raw
> > > > > socket. If
> > > > > there is a mismatch between what virtio_net_hdr_set_proto
> > > > > sets and
> > > > > the actual protocol, then the skb could be handled
> > > > > incorrectly later
> > > > > on by gso.
> > > > > 
> > > > > The network header of gso packets starts at 14 bytes, but a
> > > > > specially
> > > > > crafted packet could fool the call to
> > > > > skb_flow_dissect_flow_keys_basic
> > > > > as the network header offset in the skb could be incorrect.
> > > > > Consequently, EINVAL is not returned.
> > > > > 
> > > > > There are even packets that can cause an infinite loop. For
> > > > > example, a
> > > > > packet with ethernet type ETH_P_MPLS_UC (which is unnoticed
> > > > > by
> > > > > virtio_net_hdr_to_skb) that is sent to a geneve interface
> > > > > will be
> > > > > handled by geneve_build_skb. In turn, it calls
> > > > > udp_tunnel_handle_offloads which then calls
> > > > > skb_reset_inner_headers.
> > > > > After that, the packet gets passed to mpls_gso_segment. That
> > > > > function
> > > > > calculates the mpls header length by taking the difference
> > > > > between
> > > > > network_header and inner_network_header. Since the two are
> > > > > equal
> > > > > (due to the earlier call to skb_reset_inner_headers), it will
> > > > > calculate
> > > > > a header of length 0, and it will not pull any headers. Then,
> > > > > it will
> > > > > call skb_mac_gso_segment which will again call
> > > > > mpls_gso_segment, etc...
> > > > > This leads to the infinite loop.
> > > 
> > > I remember kernel will validate dodgy gso packets in gso ops. I
> > > wonder
> > > why not do the check there? The reason is that virtio/TUN is not
> > > the
> > > only source for those packets.
> > It is? All other GSO packets are generated by the stack itself,
> > either
> > locally or through GRO.
> 
> 
> Something like what has been done in tcp_tso_segment()?
> 
>      if (skb_gso_ok(skb, features | NETIF_F_GSO_ROBUST)) {
>                  /* Packet is from an untrusted source, reset
> gso_segs. */
> 
>          skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(skb->len, mss);
> 
>          segs = NULL;
>                  goto out;
>          }
> 
> My understanding of the header check logic is that it tries to dealy
> the 
> check as much as possible, so for device that has GRO_ROBUST, there's
> even no need to do that.
> 
> 
> > 
> > But indeed some checks are better performed in the GSO layer. Such
> > as
> > likely the 0-byte mpls header length.
> > 
> > If we cannot trust virtio_net_hdr.gso_type passed from userspace,
> > then
> > we can also not trust the eth.h_proto coming from the same source.
> 
> 
> I agree.
> 
I'll add a check in the GSO layer as well. 
> 
> > But
> > it makes sense to require them to be consistent. There is a
> > dev_parse_header_protocol that may return the link layer type in a
> > more generic fashion than casting to skb_eth_hdr.
> > 
> > Question remains what to do for the link layer types that do not
> > implement
> > header_ops->parse_protocol, and so we cannot validate the packet's
> > network protocol. Drop will cause false positives, accepts will
> > leave a
> > potential path, just closes it for Ethernet.
> > 
> > This might call for multiple fixes, both on first ingest and inside
> > the stack?
> 
Given that this is related to dodgy packets and that we can't trust
eth.h_proto, wouldn't it make sense to always drop packets (with
potential false positives), erring on the side of caution, if
header_ops->parse_protocol isn't implemented for the dev in question?
> 
> It's a balance between performance and security. Ideally, it looks to
> me 
> the GSO codes should not assume the header of dodgy packet is correct
> which means it must validate them before using them. I'm not sure if
> it 
> needs a lot of changes or not.
> 
> For security reason, it's better to do a strict check during first 
> ingest. But it bascially suppress the meaning of NETIF_F_GSO_ROBUST 
> somehow. And it needs some benchmark to see if it can cause obvious 
> performance regression.
> 
> Thanks
> 
> 
> > 
> 


