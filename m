Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 109756B7F21
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 18:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjCMRQd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 13 Mar 2023 13:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231521AbjCMRQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 13:16:21 -0400
Received: from ocelot.miegl.cz (ocelot.miegl.cz [IPv6:2a01:4f8:1c1c:20fe::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116DA80916;
        Mon, 13 Mar 2023 10:15:45 -0700 (PDT)
MIME-Version: 1.0
Date:   Mon, 13 Mar 2023 17:14:58 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: RainLoop/1.16.0
From:   "Josef Miegl" <josef@miegl.cz>
Message-ID: <57238dfc519a27b1b8d604879caa7b1b@miegl.cz>
Subject: Re: [PATCH net-next] net: geneve: accept every ethertype
To:     "Simon Horman" <simon.horman@corigine.com>
Cc:     "Eyal Birger" <eyal.birger@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Pravin B Shelar" <pshelar@ovn.org>
In-Reply-To: <ZA9T14Ks66HOlwH+@corigine.com>
References: <ZA9T14Ks66HOlwH+@corigine.com>
 <20230312163726.55257-1-josef@miegl.cz>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

March 13, 2023 5:48 PM, "Simon Horman" <simon.horman@corigine.com> wrote:

> +Pravin
> 
> On Sun, Mar 12, 2023 at 05:37:26PM +0100, Josef Miegl wrote:
> 
>> The Geneve encapsulation, as defined in RFC 8926, has a Protocol Type
>> field, which states the Ethertype of the payload appearing after the
>> Geneve header.
>> 
>> Commit 435fe1c0c1f7 ("net: geneve: support IPv4/IPv6 as inner protocol")
>> introduced a new IFLA_GENEVE_INNER_PROTO_INHERIT flag that allowed the
>> use of other Ethertypes than Ethernet. However, it imposed a restriction
>> that prohibits receiving payloads other than IPv4, IPv6 and Ethernet.
>> 
>> This patch removes this restriction, making it possible to receive any
>> Ethertype as a payload, if the IFLA_GENEVE_INNER_PROTO_INHERIT flag is
>> set.
>> 
>> This is especially useful if one wants to encapsulate MPLS, because with
>> this patch the control-plane traffic (IP, IS-IS) and the data-plane
>> traffic (MPLS) can be encapsulated without an Ethernet frame, making
>> lightweight overlay networks a possibility.
> 
> Hi Josef,
> 
> I could be mistaken. But I believe that the thinking at the time,
> was based on the idea that it was better to only allow protocols that
> were known to work. And allow more as time goes on.

Thanks for the reply Simon!

What does "known to work" mean? Protocols that the net stack handles will
work, protocols that Linux doesn't handle will not.

> Perhaps we have moved away from that thinking (I have no strong feeling
> either way). Or perhaps this is safe because of some other guard. But if
> not perhaps it is better to add the MPLS ethertype(s) to the if clause
> rather than remove it.

The thing is it is not just adding one ethertype. For my own use-case,
I would need to whitelist MPLS UC and 0x00fe for IS-IS. But I am sure
other people will want to use GENEVE` for xx other protocols.

The protocol handling seems to work, what I am not sure about is if
allowing all Ethertypes has any security implications. However, if these
implications exist, safeguarding should be done somewhere down the stock.

> This would be after any patches that enhance the
> stack to actually support this (I'm thinking of [1], though I haven't
> looked at it closely).
> 
> [1] [PATCH net-next] net: geneve: set IFF_POINTOPOINT with IFLA_GENEVE_INNER_PROTO_INHERIT
> Link: https://lore.kernel.org/netdev/20230312164557.55354-1-josef@miegl.cz

This patch just adds IFF_POINTOPOINT to a GENEVE device, it is unrelated.

>> Signed-off-by: Josef Miegl <josef@miegl.cz>
>> ---
>> drivers/net/geneve.c | 9 ++-------
>> 1 file changed, 2 insertions(+), 7 deletions(-)
>> 
>> diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
>> index 89ff7f8e8c7e..32684e94eb4f 100644
>> --- a/drivers/net/geneve.c
>> +++ b/drivers/net/geneve.c
>> @@ -365,13 +365,6 @@ static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
>> if (unlikely(geneveh->ver != GENEVE_VER))
>> goto drop;
>> 
>> - inner_proto = geneveh->proto_type;
>> -
>> - if (unlikely((inner_proto != htons(ETH_P_TEB) &&
>> - inner_proto != htons(ETH_P_IP) &&
>> - inner_proto != htons(ETH_P_IPV6))))
>> - goto drop;
>> -
>> gs = rcu_dereference_sk_user_data(sk);
>> if (!gs)
>> goto drop;
>> @@ -380,6 +373,8 @@ static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
>> if (!geneve)
>> goto drop;
>> 
>> + inner_proto = geneveh->proto_type;
>> +
>> if (unlikely((!geneve->cfg.inner_proto_inherit &&
>> inner_proto != htons(ETH_P_TEB)))) {
>> geneve->dev->stats.rx_dropped++;
>> --
>> 2.37.1
