Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCB8F63479
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 12:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfGIKmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 06:42:11 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:45510 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725947AbfGIKmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 06:42:11 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hknZW-0008Hh-H4; Tue, 09 Jul 2019 12:42:06 +0200
Date:   Tue, 9 Jul 2019 12:42:06 +0200
From:   Florian Westphal <fw@strlen.de>
To:     wenxu <wenxu@ucloud.cn>
Cc:     Florian Westphal <fw@strlen.de>, pablo@netfilter.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next 1/3] netfilter: nf_nat_proto: add
 nf_nat_bridge_ops support
Message-ID: <20190709104206.gy6l52rx2dat3743@breakpoint.cc>
References: <1562574567-8293-1-git-send-email-wenxu@ucloud.cn>
 <20190708141730.ozycgmtrub7ok2qs@breakpoint.cc>
 <0a4cf910-6c87-34b6-3018-3e25f6fecdce@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0a4cf910-6c87-34b6-3018-3e25f6fecdce@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wenxu <wenxu@ucloud.cn> wrote:
> > For NAT on bridge, it should be possible already to push such packets
> > up the stack by
> >
> > bridge input meta iif eth0 ip saddr 192.168.0.0/16 \
> >        meta pkttype set unicast ether daddr set 00:11:22:33:44:55
> 
> yes, packet can be push up to IP stack to handle the nat through bridge device. 
> 
> In my case dnat 2.2.1.7 to 10.0.0.7, It assume the mac address of the two address
> is the same known by outer.

I think that in general they will have different MAC addresses, so plain
replacement of ip addresses won't work.

> But in This case modify the packet dmac to bridge device, the packet push up through bridge device
> Then do nat and route send back to bridge device.

Are you saying that you can use the send-to-ip-layer approach?

We might need/want a more convenient way to do this.
There are two ways that I can see:

1. a redirect support for nftables bridge family.
   The redirect expression would be same as "ether daddr set
   <bridge_mac>", but there is no need to know the bridge mac address.

2. Support ebtables -t broute in nftables.
   The route rework for ebtables has been completed already, so
   this needs a new expression.  Packet that is brouted behaves
   as if the bridge port was not part of the bridge.
