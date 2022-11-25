Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9364638CBD
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 15:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiKYOw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 09:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiKYOw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 09:52:56 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B6A275CB
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 06:52:54 -0800 (PST)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 29002C000E;
        Fri, 25 Nov 2022 14:52:51 +0000 (UTC)
Message-ID: <3a98720b-4eb0-595f-81ad-f90460963c62@ovn.org>
Date:   Fri, 25 Nov 2022 15:53:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Cc:     i.maximets@ovn.org, Aaron Conole <aconole@redhat.com>,
        dev@openvswitch.org
Content-Language: en-US
To:     Eelco Chaudron <echaudro@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>, netdev@vger.kernel.org
References: <9FD6F4CD-4F41-4350-B217-4EFE40E347E2@redhat.com>
From:   Ilya Maximets <i.maximets@ovn.org>
Subject: Re: Patch "openvswitch: Fix Frame-size larger than 1024 bytes
 warning" not correct.
In-Reply-To: <9FD6F4CD-4F41-4350-B217-4EFE40E347E2@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NEUTRAL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/15/22 17:16, Eelco Chaudron wrote:
> Hi Pravin,
> 
> It looks like a previous fix you made, 190aa3e77880 ("openvswitch: Fix Frame-size larger than 1024 bytes warning."), is breaking stuff. With this change, the actual flow lookup, ovs_flow_tbl_lookup(), is done using a masked key, where it should be an unmasked key. This is maybe more clear if you take a look at the diff for the ufid addition, 74ed7ab9264c ("openvswitch: Add support for unique flow IDs.").
> 
> Just reverting the change gets rid of the problem, but it will re-introduce the larger stack size. It looks like we either have it on the stack or dynamically allocate it each time. Let me know if you have any other clever fix ;)

I'd say that dynamic allocation should be fine.
We do alloc other things in the same function, and
I don't immediately see another simple way to fix
the problem without heavily re-working the logic.

My 2c.
Best regards, Ilya Maximets.

> 
> We found this after debugging some customer-specific issue. More details are in the following OVS patch, https://patchwork.ozlabs.org/project/openvswitch/list/?series=328315
> 
> Cheers,
> 
> Eelco
> 
> 
> FYI the working revers:
> 
> 
>    Revert "openvswitch: Fix Frame-size larger than 1024 bytes warning."
> 
>     This reverts commit 190aa3e77880a05332ea1ccb382a51285d57adb5.
> 
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index 861dfb8daf4a..660d5fdd9b28 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -948,6 +948,7 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
>         struct sw_flow_mask mask;
>         struct sk_buff *reply;
>         struct datapath *dp;
> +       struct sw_flow_key key;
>         struct sw_flow_actions *acts;
>         struct sw_flow_match match;
>         u32 ufid_flags = ovs_nla_get_ufid_flags(a[OVS_FLOW_ATTR_UFID_FLAGS]);
> @@ -975,24 +976,20 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
>         }
> 
>         /* Extract key. */
> -       ovs_match_init(&match, &new_flow->key, false, &mask);
> +       ovs_match_init(&match, &key, true, &mask);
>         error = ovs_nla_get_match(net, &match, a[OVS_FLOW_ATTR_KEY],
>                                   a[OVS_FLOW_ATTR_MASK], log);
>         if (error)
>                 goto err_kfree_flow;
> 
> +       ovs_flow_mask_key(&new_flow->key, &key, true, &mask);
> +
>         /* Extract flow identifier. */
>         error = ovs_nla_get_identifier(&new_flow->id, a[OVS_FLOW_ATTR_UFID],
> -                                      &new_flow->key, log);
> +                                      &key, log);
>         if (error)
>                 goto err_kfree_flow;
> 
> -       /* unmasked key is needed to match when ufid is not used. */
> -       if (ovs_identifier_is_key(&new_flow->id))
> -               match.key = new_flow->id.unmasked_key;
> -
> -       ovs_flow_mask_key(&new_flow->key, &new_flow->key, true, &mask);
> -
>         /* Validate actions. */
>         error = ovs_nla_copy_actions(net, a[OVS_FLOW_ATTR_ACTIONS],
>                                      &new_flow->key, &acts, log);
> @@ -1019,7 +1016,7 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
>         if (ovs_identifier_is_ufid(&new_flow->id))
>                 flow = ovs_flow_tbl_lookup_ufid(&dp->table, &new_flow->id);
>         if (!flow)
> -               flow = ovs_flow_tbl_lookup(&dp->table, &new_flow->key);
> +               flow = ovs_flow_tbl_lookup(&dp->table, &key);
>         if (likely(!flow)) {
>                 rcu_assign_pointer(new_flow->sf_acts, acts);
> 

