Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30B304FF7B8
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 15:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235730AbiDMNi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 09:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233567AbiDMNi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 09:38:56 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C20FD5D5F1
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 06:36:34 -0700 (PDT)
Date:   Wed, 13 Apr 2022 15:36:32 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "roid@nvidia.com" <roid@nvidia.com>,
        "vladbu@nvidia.com" <vladbu@nvidia.com>,
        Eli Cohen <elic@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [RFC net-next] net: tc: flow indirect framework issue
Message-ID: <YlbR4Cgzd/ulpT25@salvia>
References: <20220413055248.1959073-1-mattias.forsblad@gmail.com>
 <DM5PR1301MB2172F573F9314D43F79D8F26E7EC9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <20220413090705.zkfrp2fjhejqdj6a@skbuf>
 <2a82cf39-48b9-2c6c-f662-c1d1bce391ba@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2a82cf39-48b9-2c6c-f662-c1d1bce391ba@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 13, 2022 at 02:24:38PM +0200, Mattias Forsblad wrote:
> On 2022-04-13 11:07, Vladimir Oltean wrote:
> > Hi Baowen,
> > 
> > On Wed, Apr 13, 2022 at 07:05:39AM +0000, Baowen Zheng wrote:
[...]
> > Mattias' question comes from the fact that there is already some logic
> > in flow_indr_dev_register() to replay missed flow block binding events,
> > added by Eli Cohen in commit 74fc4f828769 ("net: Fix offloading indirect
> > devices dependency on qdisc order creation"). That logic works, but it
> > replays only the binding, not the actual filters, which again, would be
> > necessary.

A bit of a long email...

This commit 74fc4f828769 handles this scenario:

1) eth0 is gone (module removal)
2) vxlan0 device is still in place, tc ingress also contains rules for
   vxlan0.
3) eth0 is reloaded.

A bit of background: tc ingress removes rules for eth0 if eth0 is
gone (I am refering to software rules, in general). In this model, the
tc ingress rules are attached to the device, and if the device eth0 is
gone, those rules are also gone and, then, once this device eth0 comes
back, the user has to the tc ingress rules software for eth0 again.
There is no replay mechanism for tc ingress rules in this case.

IIRC, Eli's patch re-adds the flow block for vxlan0 because he got a
bug report that says that after reloading the driver module and eth0
comes back, rules for tc vxlan0 were not hardware offloaded.

The indirect flow block infrastructure is tracking devices such as
vxlan0 that the given driver *might* be able to hardware offload.
But from the control plane (user) perspective, this detail is hidden.
To me, the problem is that there is no way from the control plane to
relate vxlan0 with the real device that performs the hardware offload.
There is also no flag for the user to request "please hardware offload
vxlan0 tc ingress rules". Instead, the flow indirect block
infrastructure performs the hardware offload "transparently" to the user.

I think some people believe doing things fully transparent is good, at
the cost of adding more kernel complexity and hiding details that are
relevant to the user (such as if hardware offload is enabled for
vxlan0 and what is the real device that is actually being used for the
vxlan0 to be offloaded).

So, there are no flags when setting up the vxlan0 device for the user
to say: "I would like to hardware offload vxlan0", and going slightly
further there is not "please attach this vxlan0 device to eth0 for
hardware offload". Any real device could be potentially used to
offload vxlan0, the user does not know which one is actually used.

Exposing this information is a bit more work on top of the user, but:

1) it will be transparent: the control plane shows that the vxlan0 is
   hardware offloaded. Then if eth0 is gone, vxlan0 tc ingress can be
   removed too, because it depends on eth0.

2) The control plane validates if hardware offload for vxlan0. If this
   is not possible, display an error to the user: "sorry, I cannot
   offload vxlan0 on eth0 for reason X".

Since this is not exposed to the control plane, the existing
infrastructure follows a snooping scheme, but tracking devices that
might be able to hardware offload.

There is no obvious way to relate vxlan0 with the real device
(eth0) that is actually performing the hardware offloading.

Does replay make sense for vxlan0 when the user has to manually
reload rules for eth0? So why vxlan0 rules need to be transparently
replayed but eth0 rules need to be manually reloaded in tc ingress?

> >> Maybe you can try to regist your callback in your module load stage I
> >> think your callback will be triggered, or change the command order as: 
> >> tc qdisc add dev br0 clsact
> >> ip link set dev swp0 master br0
> >> tc filter add dev br0 ingress pref 1 proto all matchall action drop
> >> I am not sure whether it will take effect.
> > 
> > I think the idea is to make the given command order work, not to change it.
> 
> Re-ordering the tc commands doesn't solve the issue when all ports leave the
> bridge, which will lead to flow_indr_dev_unregister() and later re-joins
> the bridge (flow_indr_dev_register()). We'll need filter replay for this.

Existing drivers call flow_indr_dev_register() from module init, so
they start tracking any device that might be offloaded since the
beginning, see below.

Mattias Forsblad said:
>tc qdisc add dev br0 clsact
>tc filter add dev br0 ingress pref 1 proto all matchall action drop
>
>And then adds a port to that bridge
>ip link set dev swp0 master br0   <---- flow_indr_dev_register() bc this

Regarding your issue: Why does it call flow_indr_dev_register() here?
Most drivers call flow_indr_dev_register() much earlier, when swp0
becomes available.  Then, tc qdisc add dev br0 clsact will trigger the
indirect flow block path to reach your driver.
