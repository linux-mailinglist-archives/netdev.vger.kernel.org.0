Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2532140ED
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 23:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgGCVfo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 3 Jul 2020 17:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbgGCVfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 17:35:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF1DC061794;
        Fri,  3 Jul 2020 14:35:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0F60F155CAC70;
        Fri,  3 Jul 2020 14:35:41 -0700 (PDT)
Date:   Fri, 03 Jul 2020 14:35:38 -0700 (PDT)
Message-Id: <20200703.143538.815540028775269364.davem@davemloft.net>
To:     toke@redhat.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        cake@lists.bufferbloat.net, dcaratti@redhat.com, jiri@resnulli.us,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, mrv@mojatatu.com,
        brakmo@fb.com, i.ponetaev@ndmsystems.com
Subject: Re: [PATCH net v3] sched: consistently handle layer3 header
 accesses in the presence of VLANs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200703202643.12919-1-toke@redhat.com>
References: <20200703202643.12919-1-toke@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 Jul 2020 14:35:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>
Date: Fri,  3 Jul 2020 22:26:43 +0200

> There are a couple of places in net/sched/ that check skb->protocol and act
> on the value there. However, in the presence of VLAN tags, the value stored
> in skb->protocol can be inconsistent based on whether VLAN acceleration is
> enabled. The commit quoted in the Fixes tag below fixed the users of
> skb->protocol to use a helper that will always see the VLAN ethertype.
> 
> However, most of the callers don't actually handle the VLAN ethertype, but
> expect to find the IP header type in the protocol field. This means that
> things like changing the ECN field, or parsing diffserv values, stops
> working if there's a VLAN tag, or if there are multiple nested VLAN
> tags (QinQ).
> 
> To fix this, change the helper to take an argument that indicates whether
> the caller wants to skip the VLAN tags or not. When skipping VLAN tags, we
> make sure to skip all of them, so behaviour is consistent even in QinQ
> mode.
> 
> To make the helper usable from the ECN code, move it to if_vlan.h instead
> of pkt_sched.h.
> 
> v3:
> - Remove empty lines
> - Move vlan variable definitions inside loop in skb_protocol()
> - Also use skb_protocol() helper in IP{,6}_ECN_decapsulate() and
>   bpf_skb_ecn_set_ce()
> 
> v2:
> - Use eth_type_vlan() helper in skb_protocol()
> - Also fix code that reads skb->protocol directly
> - Change a couple of 'if/else if' statements to switch constructs to avoid
>   calling the helper twice
> 
> Reported-by: Ilya Ponetayev <i.ponetaev@ndmsystems.com>
> Fixes: d8b9605d2697 ("net: sched: fix skb->protocol use in case of accelerated vlan path")
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>

Looks good, applied and queued up for -stable.

Thanks!
