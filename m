Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5A52D0F7
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 23:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727934AbfE1VZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 17:25:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54294 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726824AbfE1VZ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 17:25:56 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2072A307C940;
        Tue, 28 May 2019 21:25:56 +0000 (UTC)
Received: from ovpn-116-124.ams2.redhat.com (ovpn-116-124.ams2.redhat.com [10.36.116.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B61C2611B7;
        Tue, 28 May 2019 21:25:53 +0000 (UTC)
Message-ID: <f921c3efbc3f0266e49a840962816a52e5bcfaf2.camel@redhat.com>
Subject: Re: [PATCH net] net/sched: act_pedit: fix 'ex munge' on network
 header in case of QinQ packet
From:   Davide Caratti <dcaratti@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     shuali@redhat.com, Eli Britstein <elibr@mellanox.com>
In-Reply-To: <290a8e03-1d24-a84f-751c-6fc27f04bba0@gmail.com>
References: <753b96cc340e4fbae6640da070aac09d7220efe2.1559075758.git.dcaratti@redhat.com>
         <290a8e03-1d24-a84f-751c-6fc27f04bba0@gmail.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Tue, 28 May 2019 23:25:52 +0200
Mime-Version: 1.0
User-Agent: Evolution 3.30.3 (3.30.3-1.fc29) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 28 May 2019 21:25:56 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi Eric, thanks for looking at this!

On Tue, 2019-05-28 at 14:02 -0700, Eric Dumazet wrote:
> 
> On 5/28/19 1:50 PM, Davide Caratti wrote:
> > +				vlan = (struct vlan_hdr *)skb->data;
> > +				protocol = vlan->h_vlan_encapsulated_proto;
> > +				skb_pull(skb, VLAN_HLEN);
> > +				skb_reset_network_header(skb);
> > +				(*vlan_hdr_count)++;
> > +			}
> > +			goto again;
> 
> What prevents this loop to access data not yet in skb->head ?

just luck.

'pedit' does skb_header_pointer() later on, when it writes in the packet.
But indeed, there is no guarantee that all the nested vlan headers are in
the linear area of the packet. 

Looking at 2ecba2d1e45b and current act_csum.c, probably also tcf_csum_act()
needs the same check: I will try a patch for that tomorrow.

> skb_header_pointer() (or pskb_may_pull()) seems needed.

pskb_may_pull(), with proper error handling, seems better to me. 
regards,
-- 
davide


