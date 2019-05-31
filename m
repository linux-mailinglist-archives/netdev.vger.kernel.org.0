Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C12D30AF4
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 11:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfEaJCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 05:02:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35988 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726275AbfEaJCY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 05:02:24 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7539C308FC23;
        Fri, 31 May 2019 09:02:19 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.32.181.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 838F5174A7;
        Fri, 31 May 2019 09:02:14 +0000 (UTC)
Message-ID: <5370208b08c9e25c05b6a7cc0e8dfae79721da4d.camel@redhat.com>
Subject: Re: [PATCH net v2 1/3] net/sched: act_csum: pull all VLAN headers
 before checksumming
From:   Davide Caratti <dcaratti@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        shuali@redhat.com, Eli Britstein <elibr@mellanox.com>
In-Reply-To: <20190530110840.794ba98b@hermes.lan>
References: <cover.1559237173.git.dcaratti@redhat.com>
         <655b6508443c52f04be2b2fe9a6a7f2470b47ad1.1559237173.git.dcaratti@redhat.com>
         <20190530110840.794ba98b@hermes.lan>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Fri, 31 May 2019 11:02:13 +0200
Mime-Version: 1.0
User-Agent: Evolution 3.30.3 (3.30.3-1.fc29) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Fri, 31 May 2019 09:02:24 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-05-30 at 11:08 -0700, Stephen Hemminger wrote:
> On Thu, 30 May 2019 20:03:41 +0200
> Davide Caratti <dcaratti@redhat.com> wrote:
> 
> >  
> > +static inline int tc_skb_pull_vlans(struct sk_buff *skb,
> > +				    unsigned int *hdr_count,
> > +				    __be16 *proto)
> > +{
> > +	if (skb_vlan_tag_present(skb))
> > +		*proto = skb->protocol;
> > +
> > +	while (eth_type_vlan(*proto)) {
> > +		struct vlan_hdr *vlan;
> > +
> > +		if (unlikely(!pskb_may_pull(skb, VLAN_HLEN)))
> > +			return -ENOMEM;
> > +
> > +		vlan = (struct vlan_hdr *)skb->data;
> > +		*proto = vlan->h_vlan_encapsulated_proto;
> > +		skb_pull(skb, VLAN_HLEN);
> > +		skb_reset_network_header(skb);
> > +		(*hdr_count)++;
> > +	}
> > +	return 0;
> > +}
> 
> Does this really need to be an inline, or could it just be
> part of the sched_api?

yes, you are right: I will send a v3.

thanks,
-- 
davide


