Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F6E23EF30
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 16:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgHGOrN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 7 Aug 2020 10:47:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36657 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726030AbgHGOrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 10:47:13 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-_3QQI3cPNiyruTVfP-P_4g-1; Fri, 07 Aug 2020 10:47:06 -0400
X-MC-Unique: _3QQI3cPNiyruTVfP-P_4g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F27079ECA;
        Fri,  7 Aug 2020 14:47:05 +0000 (UTC)
Received: from bistromath.localdomain (ovpn-112-107.ams2.redhat.com [10.36.112.107])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F14A9610F3;
        Fri,  7 Aug 2020 14:47:03 +0000 (UTC)
Date:   Fri, 7 Aug 2020 16:47:01 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Bram Yvakh <bram-yvahk@mail.wizbit.be>
Cc:     netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>, xmu@redhat.com
Subject: Re: [PATCH ipsec] xfrmi: drop ignore_df check before updating pmtu
Message-ID: <20200807144701.GC906370@bistromath.localdomain>
References: <70e7c2a65afed5de117dbc16082def459bd39d93.1596531053.git.sd@queasysnail.net>
 <5F295578.4040004@mail.wizbit.be>
MIME-Version: 1.0
In-Reply-To: <5F295578.4040004@mail.wizbit.be>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sd@queasysnail.net
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-08-04, 14:32:56 +0200, Bram Yvakh wrote:
> On 4/08/2020 11:37, Sabrina Dubroca wrote:
> > xfrm interfaces currently test for !skb->ignore_df when deciding
> > whether to update the pmtu on the skb's dst. Because of this, no pmtu
> > exception is created when we do something like:
> >
> >     ping -s 1438 <dest>
> >
> > By dropping this check, the pmtu exception will be created and the
> > next ping attempt will work.
> >
> >
> > Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
> > Reported-by: Xiumei Mu <xmu@redhat.com>
> > Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> > ---
> >  net/xfrm/xfrm_interface.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
> > index b615729812e5..ade2eba863b3 100644
> > --- a/net/xfrm/xfrm_interface.c
> > +++ b/net/xfrm/xfrm_interface.c
> > @@ -292,7 +292,7 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
> >  	}
> >  
> >  	mtu = dst_mtu(dst);
> > -	if (!skb->ignore_df && skb->len > mtu) {
> > +	if (skb->len > mtu) {
> >   
> 
> To me dropping the 'ignore_df' check looks incorrect;
> When I submitted patches last year for VTI which related to
> ptmu/df-bit[1]  I did some testing and also some comparison (also with GRE)
> (I also briefly tested with xfrmi but given that the VTI patches were
> mostly ignored I did not pursue that further[2])
> 
> The conclusion for my testing with GRE: (only the last item is relevant
> but rest included for context)
> * with 'pmtudisc' set for the GRE device: outgoing GRE packet has the
> DF-bit set (this did suffer from some issues when the
> to-be-forwarded-packet did not have the DF bit set)
> * with 'nopmtudisc' set for the GRE device: outgoing GRE packet copies
> DF-bit from the to-be-forwarded packet (this did suffer from some issues
> when client did set DF bit..)
> * with 'nopmtudisc' and 'ignore-df' bit set: outgoing GRE packet never
> has the DF bit set: packet can be fragmented at will

I'd like to focus on xfrmi for now. If there's a bug in VTI, or in
GRE, we can also fix that. But right now, we have a very simple case
that doesn't work with xfrmi.

> I'm also not sure what the exact case is/was that lead to this patch;
> can you shed some light on it?

Yeah, it's the most simple xfrmi setup possible (directly connected by
a veth), and just run ping on it. ping sets DF, we want an exception
to be created, but this test prevents it.
The packet ends up being dropped in xfrm_output_one because of the mtu
check in xfrm4_tunnel_check_size.

-------- 8< --------

KEY_aead=0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f

ip netns add ha
ip netns add hb

ip link add veth0 netns ha type veth peer name veth0 netns hb
ip -net ha link set veth0 up
ip -net hb link set veth0 up
ip -net ha addr add 192.168.1.1/24 dev veth0
ip -net hb addr add 192.168.1.2/24 dev veth0

ip -net ha xfrm state add src 192.168.1.1 dst 192.168.1.2 spi 0x1000 proto esp aead 'rfc4106(gcm(aes))' $KEY_aead 128 mode tunnel sel src 192.168.2.1 dst 192.168.2.2  if_id 123
ip -net ha xfrm state add src 192.168.1.2 dst 192.168.1.1 spi 0x1001 proto esp aead 'rfc4106(gcm(aes))' $KEY_aead 128 mode tunnel sel src 192.168.2.2 dst 192.168.2.1  if_id 123
ip -net ha xfrm policy add dir out src 192.168.2.1 dst 192.168.2.2  tmpl src 192.168.1.1 dst 192.168.1.2 proto esp mode tunnel if_id 123
ip -net ha xfrm policy add dir in  src 192.168.2.2 dst 192.168.2.1  tmpl src 192.168.1.2 dst 192.168.1.1 proto esp mode tunnel if_id 123
ip -net hb xfrm state add src 192.168.1.2 dst 192.168.1.1 spi 0x1001 proto esp aead 'rfc4106(gcm(aes))' $KEY_aead 128 mode tunnel sel src 192.168.2.2 dst 192.168.2.1  if_id 123
ip -net hb xfrm state add src 192.168.1.1 dst 192.168.1.2 spi 0x1000 proto esp aead 'rfc4106(gcm(aes))' $KEY_aead 128 mode tunnel sel src 192.168.2.1 dst 192.168.2.2  if_id 123
ip -net hb xfrm policy add dir out src 192.168.2.2 dst 192.168.2.1  tmpl src 192.168.1.2 dst 192.168.1.1 proto esp mode tunnel if_id 123
ip -net hb xfrm policy add dir in  src 192.168.2.1 dst 192.168.2.2  tmpl src 192.168.1.1 dst 192.168.1.2 proto esp mode tunnel if_id 123

sleep 1
ip netns exec ha ping -c 3 192.168.1.2

ip -net ha link add xfrm0 type xfrm dev veth0 if_id 123
ip -net ha link set xfrm0 up
ip -net hb link add xfrm0 type xfrm dev veth0 if_id 123
ip -net hb link set xfrm0 up
ip -net ha addr add 192.168.2.1/24 dev xfrm0
ip -net hb addr add 192.168.2.2/24 dev xfrm0

ip netns exec ha ping -s 1438 192.168.2.2

-- 
Sabrina

