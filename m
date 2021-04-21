Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950E4366EB6
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 17:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243767AbhDUPGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 11:06:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55999 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243121AbhDUPGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 11:06:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619017530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aCGNfGJna2mi0QGYDDAzVONCyuWVlq5wfDw7UeZBSec=;
        b=VljPbmChXoGbhrJXnXuwGQxgs0PYF/jT8mpEUwIPFjojAD7p3L+CbE5LE529aAWeFXyria
        Qq7CVfF4CimtPBgSbz3FjkmWqxp9ZlABVjp7Nh/Mq1EQtq4adXnMHnulFVJPJxTYREDirg
        /05G2CMiIaSxfKa5F7R4GVz8zEmkWn4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-594-CXV-Ah5hOyqKQ73RuOP38Q-1; Wed, 21 Apr 2021 11:05:23 -0400
X-MC-Unique: CXV-Ah5hOyqKQ73RuOP38Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2E16107AD3E;
        Wed, 21 Apr 2021 15:05:21 +0000 (UTC)
Received: from [10.40.195.0] (unknown [10.40.195.0])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 16BF060C05;
        Wed, 21 Apr 2021 15:05:19 +0000 (UTC)
Message-ID: <36693a9a56f1054f55b42b1a25a4c70d3dbb1728.camel@redhat.com>
Subject: Re: [PATCH net 1/2] openvswitch: fix stack OOB read while
 fragmenting IPv4 packets
From:   Davide Caratti <dcaratti@redhat.com>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
In-Reply-To: <1097839A-30AD-4AE9-859A-4B7C6A3EFA40@redhat.com>
References: <cover.1618844973.git.dcaratti@redhat.com>
         <94839fa9e7995afa6139b4f65c12ac15c1a8dc2f.1618844973.git.dcaratti@redhat.com>
         <1097839A-30AD-4AE9-859A-4B7C6A3EFA40@redhat.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Wed, 21 Apr 2021 17:05:18 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello Eelco, thanks for looking at this!

On Wed, 2021-04-21 at 11:27 +0200, Eelco Chaudron wrote:
> 
> On 19 Apr 2021, at 17:23, Davide Caratti wrote:
> 
> > running openvswitch on kernels built with KASAN, it's possible to see 
> > the
> > following splat while testing fragmentation of IPv4 packets:
> 
> <SNIP>
> 
> > for IPv4 packets, ovs_fragment() uses a temporary struct dst_entry. 
> > Then,
> > in the following call graph:
> > 
> >   ip_do_fragment()
> >     ip_skb_dst_mtu()
> >       ip_dst_mtu_maybe_forward()
> >         ip_mtu_locked()
> > 
> > the pointer to struct dst_entry is used as pointer to struct rtable: 
> > this
> > turns the access to struct members like rt_mtu_locked into an OOB read 
> > in
> > the stack. Fix this changing the temporary variable used for IPv4 
> > packets
> > in ovs_fragment(), similarly to what is done for IPv6 few lines below.
> > 
> > Fixes: d52e5a7e7ca4 ("ipv4: lock mtu in fnhe when received PMTU < 
> > net.ipv4.route.min_pmt")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> 
> The fix looks good to me, however isn’t the real root cause 
> ip_mtu_locked() who casts struct dst_entry to struct rtable (not even 
> using container_of())?

good point, that's my understanding (and the reason for that 'Fixes:'
tag). Probably openvswitch was doing this on purpose, and it was "just
working" until commit d52e5a7e7ca4.

But at the current state, I see much easier to just fix the IPv4 part to
have the same behavior as other "users" of ip_do_fragment(), like it
happens for ovs_fragment() when the packet is IPv6 (or br_netfilter
core, see [1]).

By the way, apparently ip_do_fragment() already assumes that a struct
rtable is available for the skb [2]. So, the fix in ovs_fragment() looks
safer to me. WDYT?

-- 
davide

[1] https://elixir.bootlin.com/linux/v5.12-rc8/source/net/bridge/br_nf_core.c#L72
[2] https://elixir.bootlin.com/linux/v5.12-rc8/source/net/ipv4/ip_output.c#L778



