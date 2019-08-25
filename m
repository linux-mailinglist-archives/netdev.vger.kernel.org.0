Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3D289C655
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 23:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729114AbfHYVwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 17:52:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56458 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727321AbfHYVwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 17:52:47 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0DEA314EB38B7;
        Sun, 25 Aug 2019 14:52:47 -0700 (PDT)
Date:   Sun, 25 Aug 2019 14:52:46 -0700 (PDT)
Message-Id: <20190825.145246.711177960271090404.davem@davemloft.net>
To:     pshelar@ovn.org
Cc:     jpettit@ovn.org, netdev@vger.kernel.org, joe@wand.net.nz
Subject: Re: [PATCH net 1/2] openvswitch: Properly set L4 keys on "later"
 IP fragments.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAOrHB_BKd=QKR_ScO+r7qAyZaniEbFur+iup1iXbtiycaFawjw@mail.gmail.com>
References: <20190824165846.79627-1-jpettit@ovn.org>
        <CAOrHB_AU1gQ74L5WawyA4THhh=MG8YZhcvkkxnKgRG+5m-436g@mail.gmail.com>
        <CAOrHB_BKd=QKR_ScO+r7qAyZaniEbFur+iup1iXbtiycaFawjw@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 25 Aug 2019 14:52:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pravin Shelar <pshelar@ovn.org>
Date: Sun, 25 Aug 2019 13:40:58 -0700

> On Sun, Aug 25, 2019 at 9:54 AM Pravin Shelar <pshelar@ovn.org> wrote:
>>
>> On Sat, Aug 24, 2019 at 9:58 AM Justin Pettit <jpettit@ovn.org> wrote:
>> >
>> > When IP fragments are reassembled before being sent to conntrack, the
>> > key from the last fragment is used.  Unless there are reordering
>> > issues, the last fragment received will not contain the L4 ports, so the
>> > key for the reassembled datagram won't contain them.  This patch updates
>> > the key once we have a reassembled datagram.
>> >
>> > Signed-off-by: Justin Pettit <jpettit@ovn.org>
>> > ---
>> >  net/openvswitch/conntrack.c | 4 ++++
>> >  1 file changed, 4 insertions(+)
>> >
>> > diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
>> > index 848c6eb55064..f40ad2a42086 100644
>> > --- a/net/openvswitch/conntrack.c
>> > +++ b/net/openvswitch/conntrack.c
>> > @@ -524,6 +524,10 @@ static int handle_fragments(struct net *net, struct sw_flow_key *key,
>> >                 return -EPFNOSUPPORT;
>> >         }
>> >
>> > +       /* The key extracted from the fragment that completed this datagram
>> > +        * likely didn't have an L4 header, so regenerate it. */
>> > +       ovs_flow_key_update(skb, key);
>> > +
>> >         key->ip.frag = OVS_FRAG_TYPE_NONE;
>> >         skb_clear_hash(skb);
>> >         skb->ignore_df = 1;
>> > --
>>
>> Looks good to me.
>>
>> Acked-by: Pravin B Shelar <pshelar@ovn.org>
>>
> Actually I am not sure about this change. caller of this function
> (ovs_ct_execute()) does skb-pull and push of L2 header, calling
> ovs_flow_key_update() is not safe here, it expect skb data to point to
> L2 header.

Agreed, also the comment needs to be formatted properly ala:

	/* blah
	 * blah
	 */

instead of:

	/* blah
	 * blah */
