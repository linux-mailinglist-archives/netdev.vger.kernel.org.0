Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D96224D3A9A
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 20:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236185AbiCITuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 14:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234660AbiCITuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 14:50:21 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4139E266D;
        Wed,  9 Mar 2022 11:49:20 -0800 (PST)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id DF720C0005;
        Wed,  9 Mar 2022 19:49:16 +0000 (UTC)
Message-ID: <01c03553-a5de-b040-6296-29282d2f95e9@ovn.org>
Date:   Wed, 9 Mar 2022 20:49:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Cc:     i.maximets@ovn.org, "David S. Miller" <davem@davemloft.net>,
        Pravin B Shelar <pshelar@ovn.org>,
        Toms Atteka <cpp.code.lv@gmail.com>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        Aaron Conole <aconole@redhat.com>
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Roi Dayan <roid@nvidia.com>
References: <20220309155623.2996968-1-i.maximets@ovn.org>
 <5d89f306-d3fa-3e96-c4f3-587c9e3c605b@ovn.org>
From:   Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [PATCH net-next] net: openvswitch: fix uAPI incompatibility with
 existing user space
In-Reply-To: <5d89f306-d3fa-3e96-c4f3-587c9e3c605b@ovn.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/22 18:22, Ilya Maximets wrote:
> On 3/9/22 16:56, Ilya Maximets wrote:
>> Few years ago OVS user space made a strange choice in the commit [1]
>> to define types only valid for the user space inside the copy of a
>> kernel uAPI header.  '#ifndef __KERNEL__' and another attribute was
>> added later.
>>
>> This leads to the inevitable clash between user space and kernel types
>> when the kernel uAPI is extended.  The issue was unveiled with the
>> addition of a new type for IPv6 extension header in kernel uAPI.
>>
>> When kernel provides the OVS_KEY_ATTR_IPV6_EXTHDRS attribute to the
>> older user space application, application tries to parse it as
>> OVS_KEY_ATTR_PACKET_TYPE and discards the whole netlink message as
>> malformed.  Since OVS_KEY_ATTR_IPV6_EXTHDRS is supplied along with
>> every IPv6 packet that goes to the user space, IPv6 support is fully
>> broken.
>>
>> Fixing that by bringing these user space attributes to the kernel
>> uAPI to avoid the clash.  Strictly speaking this is not the problem
>> of the kernel uAPI, but changing it is the only way to avoid breakage
>> of the older user space applications at this point.
>>
>> These 2 types are explicitly rejected now since they should not be
>> passed to the kernel.  Additionally, OVS_KEY_ATTR_TUNNEL_INFO moved
>> out from the '#ifdef __KERNEL__' as there is no good reason to hide
>> it from the userspace.  And it's also explicitly rejected now, because
>> it's for in-kernel use only.
>>
>> Comments with warnings were added to avoid the problem coming back.
>>
>>  [1] beb75a40fdc2 ("userspace: Switching of L3 packets in L2 pipeline")
>>
>> Fixes: 28a3f0601727 ("net: openvswitch: IPv6: Add IPv6 extension header support")
>> Link: https://lore.kernel.org/netdev/3adf00c7-fe65-3ef4-b6d7-6d8a0cad8a5f@nvidia.com
>> Link: https://github.com/openvswitch/ovs/commit/beb75a40fdc295bfd6521b0068b4cd12f6de507c
>> Reported-by: Roi Dayan <roid@nvidia.com>
>> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
>> ---
>>
>> Roi, could you please test this change on your setup?
>>
>> I didn't run system tests myself yet, setting up environment at the moment.
> 
> OK.  I set up my own environment and the patch doesn't seem to work.
> Investigating.

I figured that out.  The problem is that OVS_KEY_ATTR_IPV6_EXTHDRS == 32.
That causes (1 << type) to overflow during the parsing and enable incorrect
bit in the mask of seen attributes.  The following additional change fixes
the problem:

diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index c9c49e5cd67f..5176f6ccac8e 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -489,7 +489,7 @@ static int __parse_flow_nlattrs(const struct nlattr *attr,
                        return -EINVAL;
                }
 
-               if (attrs & (1 << type)) {
+               if (attrs & (1ULL << type)) {
                        OVS_NLERR(log, "Duplicate key (type %d).", type);
                        return -EINVAL;
                }
@@ -502,7 +502,7 @@ static int __parse_flow_nlattrs(const struct nlattr *attr,
                }
 
                if (!nz || !is_all_zero(nla_data(nla), nla_len(nla))) {
-                       attrs |= 1 << type;
+                       attrs |= 1ULL << type;
                        a[type] = nla;
                }
        }
---

I'll run few more checks to be sure and send v2 with above change applied.

We may also want to have a cosmetic change that converts all (1 << OVS_*)
to (1ULL << OVS_*) even for attributes < 32 as a follow up.  Current code
looks a bit inconsistent.

Best regards, Ilya Maximets.
