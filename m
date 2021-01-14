Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B08B2F6D63
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 22:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbhANVnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 16:43:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41632 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726843AbhANVni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 16:43:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610660532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/s4weO8DV932wCkpW85o9rdOlW+6rj8jC6Sd/cwN2cM=;
        b=FLqFxM13K5NBWsBPs1ysyi6cfgE0ZafHiHSjnnKFwBC06HwC0ywyosxDLA69IB1j/aWqGu
        0zdp/SYkC2dlcW8dFi67kaci9+mOgKIiyMT6b2YQDPskJeAX7vmT5GmEzeNwATRRWXwFEf
        ABbT7lA2bTuKEXaxqlvirfFSEDCbq78=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-Olb3NcnTOYSFGe-feDeo_w-1; Thu, 14 Jan 2021 16:42:08 -0500
X-MC-Unique: Olb3NcnTOYSFGe-feDeo_w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97B15612AB;
        Thu, 14 Jan 2021 21:42:06 +0000 (UTC)
Received: from redhat.com (dhcp-17-185.bos.redhat.com [10.18.17.185])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 639C519C45;
        Thu, 14 Jan 2021 21:42:05 +0000 (UTC)
Date:   Thu, 14 Jan 2021 16:42:03 -0500
From:   Jarod Wilson <jarod@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] bonding: add a vlan+mac tx hashing option
Message-ID: <20210114214203.GI1171031@redhat.com>
References: <20201218193033.6138-1-jarod@redhat.com>
 <20210113223548.1171655-1-jarod@redhat.com>
 <20210113175818.7dce3076@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210114211141.GH1171031@redhat.com>
 <20210114132314.2c484e9f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114132314.2c484e9f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 01:23:14PM -0800, Jakub Kicinski wrote:
> On Thu, 14 Jan 2021 16:11:41 -0500 Jarod Wilson wrote:
> > In truth, this code started out as a copy of bond_eth_hash(), which also
> > only uses the last byte, though of both source and destination macs. In
> > the typical use case for the requesting user, the bond is formed from two
> > onboard NICs, which typically have adjacent mac addresses, i.e.,
> > AA:BB:CC:DD:EE:01 and AA:BB:CC:DD:EE:02, so only the last byte is really
> > relevant to hash differently, but in thinking about it, a replacement NIC
> > because an onboard one died could have the same last byte, and maybe we
> > ought to just go full source mac right off the go here.
> > 
> > Something like this instead maybe:
> > 
> > static u32 bond_vlan_srcmac_hash(struct sk_buff *skb)
> > {
> >         struct ethhdr *mac_hdr = (struct ethhdr *)skb_mac_header(skb);
> >         u32 srcmac = 0;
> >         u16 vlan;
> >         int i;
> > 
> >         for (i = 0; i < ETH_ALEN; i++)
> >                 srcmac = (srcmac << 8) | mac_hdr->h_source[i];
> > 
> >         if (!skb_vlan_tag_present(skb))
> >                 return srcmac;
> > 
> >         vlan = skb_vlan_tag_get(skb);
> > 
> >         return vlan ^ srcmac;
> > }
> > 
> > Then the documentation is spot-on, and we're future-proof, though
> > marginally less performant in calculating the hash, which may have been a
> > consideration when the original function was written, but is probably
> > basically irrelevant w/modern systems...
> 
> No preference, especially if bond_eth_hash() already uses the last byte.
> Just make sure the choice is explained in the commit message.

I've sold myself on using the full MAC, because if there's no vlan tag
present, mac is the only thing used for the hash, increasing the chances
of getting the same hash for two different interfaces, which won't happen
if we've got the full MAC. Of course, I'm not sure why someone would be
using this xmit hash outside of the very particular use-case that includes
VLANs, but people do strange things...

-- 
Jarod Wilson
jarod@redhat.com

