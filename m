Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF4D6204F
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 16:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730011AbfGHORg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 10:17:36 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:39830 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728596AbfGHORf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 10:17:35 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hkUSQ-0001FR-U2; Mon, 08 Jul 2019 16:17:30 +0200
Date:   Mon, 8 Jul 2019 16:17:30 +0200
From:   Florian Westphal <fw@strlen.de>
To:     wenxu@ucloud.cn
Cc:     pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH nf-next 1/3] netfilter: nf_nat_proto: add
 nf_nat_bridge_ops support
Message-ID: <20190708141730.ozycgmtrub7ok2qs@breakpoint.cc>
References: <1562574567-8293-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562574567-8293-1-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wenxu@ucloud.cn <wenxu@ucloud.cn> wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Add nf_nat_bridge_ops to do nat in the bridge family

Whats the use case for this?

The reason I'm asking is that a bridge doesn't know about IP,
Bridge netfilter (the call-iptables thing) has a lot of glue code
to detect dnat rewrites and updates target mac address, including
support for redirect (suddently packet has to be pushed up the stack)
or changes in the oif to non-bridge ports (it even checks forward sysctl
state ..) and so on.

Thats something that I don't want to support in nftables.

For NAT on bridge, it should be possible already to push such packets
up the stack by

bridge input meta iif eth0 ip saddr 192.168.0.0/16 \
       meta pkttype set unicast ether daddr set 00:11:22:33:44:55

then normal ip processing handles this and nat should "just work".
If above doesn't work for you I'd like to understand why.
