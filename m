Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D88A46C2F8F
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 11:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbjCUKwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 06:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbjCUKwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 06:52:13 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A8EF765
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 03:52:10 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 185EA20533;
        Tue, 21 Mar 2023 11:52:09 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id QUEiFSs2uLce; Tue, 21 Mar 2023 11:52:08 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8FC4C2052E;
        Tue, 21 Mar 2023 11:52:08 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 7F8F380004A;
        Tue, 21 Mar 2023 11:52:08 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Tue, 21 Mar 2023 11:52:03 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Tue, 21 Mar
 2023 11:52:03 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id B2C693181AD7; Tue, 21 Mar 2023 11:52:02 +0100 (CET)
Date:   Tue, 21 Mar 2023 11:52:02 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Hyunwoo Kim <v4bel@theori.io>
CC:     Eric Dumazet <edumazet@google.com>,
        Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Dmitry Kozlov <xeb@mail.ru>,
        David Ahern <dsahern@kernel.org>, <tudordana@google.com>,
        <netdev@vger.kernel.org>, <imv4bel@gmail.com>
Subject: Re: [PATCH] net: Fix invalid ip_route_output_ports() call
Message-ID: <ZBmMUjSXPzFBWeTv@gauss3.secunet.de>
References: <20230321024946.GA21870@ubuntu>
 <CANn89i+=-BTZyhg9f=Vyz0rws1Z-1O-F5TkESBjkZnKmHeKz1g@mail.gmail.com>
 <20230321050803.GA22060@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230321050803.GA22060@ubuntu>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 10:08:03PM -0700, Hyunwoo Kim wrote:
> On Mon, Mar 20, 2023 at 08:17:15PM -0700, Eric Dumazet wrote:
> > On Mon, Mar 20, 2023 at 7:49 PM Hyunwoo Kim <v4bel@theori.io> wrote:
> 
> struct rtable *ip_route_output_flow(struct net *net, struct flowi4 *flp4,
> 				    const struct sock *sk)
> {
> 	struct rtable *rt = __ip_route_output_key(net, flp4);
> 
> 	if (IS_ERR(rt))
> 		return rt;
> 
> 	if (flp4->flowi4_proto) {
> 		flp4->flowi4_oif = rt->dst.dev->ifindex;
> 		rt = (struct rtable *)xfrm_lookup_route(net, &rt->dst,
> 							flowi4_to_flowi(flp4),  // <===[4]
> 							sk, 0);
> 	}
> 
> 	return rt;
> }
> EXPORT_SYMBOL_GPL(ip_route_output_flow);
> ```
> This is the cause of the stack OOB. Because we calculated the struct flowi pointer address based on struct flowi4 declared as a stack variable, 
> if we accessed a member of flowi that exceeds the size of flowi4, we would get an OOB.
> 
> 
> Finally, xfrm_state_find()[5] uses daddr, which is a pointer to `&fl->u.ip4.saddr`.
> Here, the encap_family variable can be entered by the user using the netlink socket. 
> If the user chose AF_INET6 instead of AF_INET, the xfrm_dst_hash() function would be called on an AF_INET6 basis[6], 
> which could cause an OOB in the `struct flowi4 fl4` variable of igmpv3_newpack()[2].

Thanks for the great analysis!

Looks like a missing sanity check when the policy gets inserted.
Can you send the output of 'ip x p' for that policy?
