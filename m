Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0261F180AFC
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 22:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbgCJV6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 17:58:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47510 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727311AbgCJV6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 17:58:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583877483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rFoH7Ve/QOaTfyLMyBzdHWsF+mknAGjgw0uOM54z3Ts=;
        b=ZFpwpoyc83jUAMXj+2GM69O7bvy9P/tZSCYFEeQzwmW5CO5eSK3rvVEWHbuI54RjgA8jLp
        DNtM5MVcEuIgx4OY+q3a13NCQtlkVuKe/w4rLruCZSULTZmkjg8m4AO/o1QSwFwFYXvtev
        jixdYq6relAsJgVq0jcRYTZcvHY3zqc=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-IYSdyxyEM3Cd7Zez8UFL9Q-1; Tue, 10 Mar 2020 17:58:01 -0400
X-MC-Unique: IYSdyxyEM3Cd7Zez8UFL9Q-1
Received: by mail-qk1-f198.google.com with SMTP id 22so108871qkc.7
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 14:58:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rFoH7Ve/QOaTfyLMyBzdHWsF+mknAGjgw0uOM54z3Ts=;
        b=rAzhm66wqFDbghZx2yDFdVrquTEzrVCzqMGH7gGISAxXHcVclfpHEA8dXtiPh8enhO
         QATRqzqZIBYTAOH2IWyyIb5/y58ylrke6ILxHv90UxmAJPKFPvUExQYjnppbv8yvO7y/
         lucHYh69EKdiKvFfc9XwlyCuoDVvJy/p05cZqSxOtcGDMClXTXDWqxTMn/rr/Qwcd22E
         WW0ppW21S3b5QP10tW6DPlp9yQT5+1CeSMRESP9wAdNy3PHqILRAy67jR/1CugUJWEpa
         AH2AQhf6WHge6VGXnE6shmNp2Ink4mrb78GQPMCDnm/joJn7+oEqmGiI/QoIaCiFBh8u
         afDQ==
X-Gm-Message-State: ANhLgQ0vsTUH6bEbo1+7eMor6mReEBRR59IPA6D6mH46exGzU/mPIjGj
        ClxLJbL/fx1kg3N/JEC5T3RuCwYOuoL/mbbAJa8QsaHq1ZFbG4/yfQTDh+yJazSJrmDifSAF7bn
        685R1nxfPny+c9QjZ
X-Received: by 2002:ac8:366d:: with SMTP id n42mr77895qtb.180.1583877480967;
        Tue, 10 Mar 2020 14:58:00 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsDBRq6UMElOACGpfbm+5PX3Fxg2rRfH89/pZvbT5wKDzqiq8TmlkpMtJKKgkT7YapygMqtFw==
X-Received: by 2002:ac8:366d:: with SMTP id n42mr77881qtb.180.1583877480642;
        Tue, 10 Mar 2020 14:58:00 -0700 (PDT)
Received: from redhat.com (bzq-79-178-2-19.red.bezeqint.net. [79.178.2.19])
        by smtp.gmail.com with ESMTPSA id v126sm7543776qkb.107.2020.03.10.14.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 14:57:59 -0700 (PDT)
Date:   Tue, 10 Mar 2020 17:57:55 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH net] net/packet: tpacket_rcv: do not increment ring index
 on drop
Message-ID: <20200310175627-mutt-send-email-mst@kernel.org>
References: <20200309153435.32109-1-willemdebruijn.kernel@gmail.com>
 <20200310023528-mutt-send-email-mst@kernel.org>
 <CA+FuTSd=oLQhtKet-n5r++3HHmHR+5rMkDqSMyjArOBfF4vsKw@mail.gmail.com>
 <20200310085437-mutt-send-email-mst@kernel.org>
 <CA+FuTSe+mxUwHMTccO7QO+GVi1TUgxbwZoAktGTD+15yMZf5Vw@mail.gmail.com>
 <20200310104024-mutt-send-email-mst@kernel.org>
 <CA+FuTSeZFTUShADA0STcHjSt88JsSGWQ0nnc5Sr-oQAvRH+-3A@mail.gmail.com>
 <20200310172833-mutt-send-email-mst@kernel.org>
 <CA+FuTSfrjThis9UchhiKE2ibMKVgCvfTdbeB0Q33XiTDLBEX8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSfrjThis9UchhiKE2ibMKVgCvfTdbeB0Q33XiTDLBEX8w@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 05:35:55PM -0400, Willem de Bruijn wrote:
> On Tue, Mar 10, 2020 at 5:30 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Tue, Mar 10, 2020 at 11:38:16AM -0400, Willem de Bruijn wrote:
> > > On Tue, Mar 10, 2020 at 10:44 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Tue, Mar 10, 2020 at 10:16:56AM -0400, Willem de Bruijn wrote:
> > > > > On Tue, Mar 10, 2020 at 8:59 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > >
> > > > > > On Tue, Mar 10, 2020 at 08:49:23AM -0400, Willem de Bruijn wrote:
> > > > > > > On Tue, Mar 10, 2020 at 2:43 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > >
> > > > > > > > On Mon, Mar 09, 2020 at 11:34:35AM -0400, Willem de Bruijn wrote:
> > > > > > > > > From: Willem de Bruijn <willemb@google.com>
> > > > > > > > >
> > > > > > > > > In one error case, tpacket_rcv drops packets after incrementing the
> > > > > > > > > ring producer index.
> > > > > > > > >
> > > > > > > > > If this happens, it does not update tp_status to TP_STATUS_USER and
> > > > > > > > > thus the reader is stalled for an iteration of the ring, causing out
> > > > > > > > > of order arrival.
> > > > > > > > >
> > > > > > > > > The only such error path is when virtio_net_hdr_from_skb fails due
> > > > > > > > > to encountering an unknown GSO type.
> > > > > > > > >
> > > > > > > > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > > > > > > > >
> > > > > > > > > ---
> > > > > > > > >
> > > > > > > > > I wonder whether it should drop packets with unknown GSO types at all.
> > > > > > > > > This consistently blinds the reader to certain packets, including
> > > > > > > > > recent UDP and SCTP GSO types.
> > > > > > > >
> > > > > > > > Ugh it looks like you have found a bug.  Consider a legacy userspace -
> > > > > > > > it was actually broken by adding USD and SCTP GSO.  I suspect the right
> > > > > > > > thing to do here is actually to split these packets up, not drop them.
> > > > > > >
> > > > > > > In the main virtio users, virtio_net/tun/tap, the packets will always
> > > > > > > arrive segmented, due to these devices not advertising hardware
> > > > > > > segmentation for these protocols.
> > > > > >
> > > > > > Oh right. That's good then, sorry about the noise.
> > > > >
> > > > > Not at all. Thanks for taking a look!
> > > > >
> > > > > > > So the issue is limited to users of tpacket_rcv, which is relatively
> > > > > > > new. There too it is limited on egress to devices that do advertise
> > > > > > > h/w offload. And on r/x to GRO.
> > > > > > >
> > > > > > > The UDP GSO issue precedes the fraglist GRO patch, by the way, and
> > > > > > > goes back to my (argh!) introduction of the feature on the egress
> > > > > > > path.
> > > > > > >
> > > > > > > >
> > > > > > > > > The peer function virtio_net_hdr_to_skb already drops any packets with
> > > > > > > > > unknown types, so it should be fine to add an SKB_GSO_UNKNOWN type and
> > > > > > > > > let the peer at least be aware of failure.
> > > > > > > > >
> > > > > > > > > And possibly add SKB_GSO_UDP_L4 and SKB_GSO_SCTP types to virtio too.
> > > > > > > >
> > > > > > > > This last one is possible for sure, but for virtio_net_hdr_from_skb
> > > > > > > > we'll need more flags to know whether it's safe to pass
> > > > > > > > these types to userspace.
> > > > > > >
> > > > > > > Can you elaborate? Since virtio_net_hdr_to_skb users already returns
> > > > > > > -EINVAL on unknown GSO types and its callers just drop these packets,
> > > > > > > it looks to me that the infra is future proof wrt adding new GSO
> > > > > > > types.
> > > > > >
> > > > > > Oh I mean if we do want to add new types and want to pass them to
> > > > > > users, then virtio_net_hdr_from_skb will need to flag so it
> > > > > > knows whether that will or won't confuse userspace.
> > > > >
> > > > > I'm not sure how that would work. Ignoring other tun/tap/virtio for
> > > > > now, just looking at tpacket, a new variant of socket option for
> > > > > PACKET_VNET_HDR, for every new GSO type?
> > > >
> > > > Maybe a single one with a bitmap of legal types?
> > > >
> > > > > In practice the userspace I'm aware of, and any sane implementation,
> > > > > will be future proof to drop and account packets whose type it cannot
> > > > > process. So I think we can just add new types.
> > > >
> > > > Well if packets are just dropped then userspace breaks right?
> > >
> > > It is an improvement over the current silent discard in the kernel.
> > >
> > > If it can count these packets, userspace becomes notified that it
> > > should perhaps upgrade or use ethtool to stop the kernel from
> > > generating certain packets.
> > >
> > > Specifically for packet sockets, it wants to receive packets as they
> > > appear "on the wire". It does not have to drop these today even, but
> > > can easily parse the headers.
> > >
> > > For packet sockets at least, I don't think that we want transparent
> > > segmentation.
> >
> > Well it's GSO is in the way then it's no longer "on the wire", right?
> > Whether we split these back to individual skbs or we don't
> > it's individual packets that are on the wire. GSO just allows
> > passing them to the application in a more efficient way.
> 
> Not entirely. With TSO enabled, packet sockets will show the TCP TSO
> packets, not the individual segment on the wire.

But nothing breaks if it shows a segment on the wire while linux
processes packets in batches, right? It's just some extra info that
an app can't handle, so we hide it from the app...

-- 
MST

