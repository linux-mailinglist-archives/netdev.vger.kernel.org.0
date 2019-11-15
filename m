Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A190CFE56D
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 20:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfKOTJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 14:09:25 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:29948 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbfKOTJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 14:09:24 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xAFJ99oU024225;
        Fri, 15 Nov 2019 11:09:10 -0800
Date:   Sat, 16 Nov 2019 00:30:57 +0530
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH net-next v3 1/2] cxgb4: add TC-MATCHALL classifier egress
 offload
Message-ID: <20191115190056.GA14695@chelsio.com>
References: <cover.1573818408.git.rahul.lakkireddy@chelsio.com>
 <5b5af4a7ec3a6c9bc878046f4670a2838bbbe718.1573818408.git.rahul.lakkireddy@chelsio.com>
 <20191115135845.GC2158@nanopsycho>
 <20191115150824.GA14296@chelsio.com>
 <20191115153247.GD2158@nanopsycho>
 <20191115105112.17c14b2b@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115105112.17c14b2b@cakuba.netronome.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday, November 11/15/19, 2019 at 10:51:12 -0800, Jakub Kicinski wrote:
> On Fri, 15 Nov 2019 16:32:47 +0100, Jiri Pirko wrote:
> > Fri, Nov 15, 2019 at 04:08:30PM CET, rahul.lakkireddy@chelsio.com wrote:
> > >On Friday, November 11/15/19, 2019 at 14:58:45 +0100, Jiri Pirko wrote:  
> > >> Fri, Nov 15, 2019 at 01:14:20PM CET, rahul.lakkireddy@chelsio.com wrote:
> > >> >+static int cxgb4_matchall_egress_validate(struct net_device *dev,
> > >> >+					  struct tc_cls_matchall_offload *cls)
> > >> >+{
> > >> >+	struct netlink_ext_ack *extack = cls->common.extack;
> > >> >+	struct flow_action *actions = &cls->rule->action;
> > >> >+	struct port_info *pi = netdev2pinfo(dev);
> > >> >+	struct flow_action_entry *entry;
> > >> >+	u64 max_link_rate;
> > >> >+	u32 i, speed;
> > >> >+	int ret;
> > >> >+
> > >> >+	if (cls->common.prio != 1) {
> > >> >+		NL_SET_ERR_MSG_MOD(extack,
> > >> >+				   "Egress MATCHALL offload must have prio 1");  
> > >> 
> > >> I don't understand why you need it to be prio 1.  
> > >
> > >This is to maintain rule ordering with the kernel. Jakub has suggested
> > >this in my earlier series [1][2]. I see similar checks in various
> > >drivers (mlx5 and nfp), while offloading matchall with policer.  
> > 
> > I don't think that is correct. If matchall is the only filter there, it
> > does not matter which prio is it. It matters only in case there are
> > other filters.
> 
> Yup, the ingress side is the one that matters.
> 
> > The code should just check for other filters and forbid to insert the
> > rule if other filters have higher prio (lower number).
> 
> Ack as well, that'd work even better. 
> 
> I've capitulated to the prio == 1 condition as "good enough" when
> netronome was adding the policer offload for OvS.

I see. I thought there was some sort of mutual agreement, that to
offload police, then prio must be 1, when I saw several drivers do
it. I don't have a police offload on ingress side yet. So, I'm
guessing this check for prio is not needed at all for my series?
Please confirm again so that I'm on the same page. :)

Thanks,
Rahul
