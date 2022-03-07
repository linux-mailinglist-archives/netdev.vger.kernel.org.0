Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A44754D0AC6
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 23:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343673AbiCGWPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 17:15:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343713AbiCGWPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 17:15:15 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D9E58E50;
        Mon,  7 Mar 2022 14:14:19 -0800 (PST)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id BB716100005;
        Mon,  7 Mar 2022 22:14:13 +0000 (UTC)
Message-ID: <3a96b606-c3aa-c39b-645e-a3af0c82e44b@ovn.org>
Date:   Mon, 7 Mar 2022 23:14:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Cc:     dev@openvswitch.org, Toms Atteka <cpp.code.lv@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, i.maximets@ovn.org
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Roi Dayan <roid@nvidia.com>
References: <20220224005409.411626-1-cpp.code.lv@gmail.com>
 <164578561098.13834.14017896440355101001.git-patchwork-notify@kernel.org>
 <3adf00c7-fe65-3ef4-b6d7-6d8a0cad8a5f@nvidia.com>
 <50d6ce3d-14bb-205e-55da-5828b10224e8@nvidia.com>
 <57996C97-5845-425B-9B13-7F33EE05D704@redhat.com>
 <26b924fb-ed26-bb3f-8c6b-48edac825f73@nvidia.com>
 <20220307122638.215427b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [ovs-dev] [PATCH net-next v8] net: openvswitch: IPv6: Add IPv6
 extension header support
In-Reply-To: <20220307122638.215427b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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

On 3/7/22 21:26, Jakub Kicinski wrote:
> On Mon, 7 Mar 2022 10:49:31 +0200 Roi Dayan wrote:
>>>> I think there is a missing userspace fix. didnt verify yet.
>>>> but in ovs userspace odp-netlink.h created from datapath/linux/compat/include/linux/openvswitch.h
>>>> and that file is not synced the change here.
>>>> So the new enum OVS_KEY_ATTR_IPV6_EXTHDRS is missing and also struct
>>>> ovs_key_ipv6_exthdrs which is needed in lib/udp-util.c
>>>> in struct ovs_flow_key_attr_lens to add expected len for
>>>> OVS_KEY_ATTR_IPV6_EXTHDR.  
>>>
>>> I guess if this is creating backward compatibility issues, this
>>> patch should be reverted/fixed. As a kmod upgrade should not break
>>> existing deployments. 
>>
>> it looks like it does. we can't work with ovs without reverting this.
>> can we continue with reverting this commit please?
> 
> Sure, can someone ELI5 what the problem is?
> 
> What's "kmod upgrade" in this context a kernel upgrade or loading 
> a newer module in older kernel? 
> 
> How can adding a new nl attr break user space? Does the user space
> actually care about the OVS_KEY_ATTR_TUNNEL_INFO wart?

Hi, Jakub.

The main problem is that userspace uses the modified copy of the uapi header
which looks like this:
  https://github.com/openvswitch/ovs/blob/f77dbc1eb2da2523625cd36922c6fccfcb3f3eb7/datapath/linux/compat/include/linux/openvswitch.h#L357

In short, the userspace view:

  enum ovs_key_attr {
      <common attrs>

  #ifdef __KERNEL__
      /* Only used within kernel data path. */
  #endif

  #ifndef __KERNEL__
      /* Only used within userspace data path. */
  #endif
      __OVS_KEY_ATTR_MAX
};

And the kernel view:

  enum ovs_key_attr {
      <common attrs>

  #ifdef __KERNEL__
      /* Only used within kernel data path. */
  #endif

      __OVS_KEY_ATTR_MAX
  };

This happened before my time, but the commit where userspace made a wrong
turn appears to be this one:
  https://github.com/openvswitch/ovs/commit/beb75a40fdc295bfd6521b0068b4cd12f6de507c
The attribute for userspace only was added to the common enum after the
OVS_KEY_ATTR_TUNNEL_INFO.   I'm not sure how things didn't fall apart when
OVS_KEY_ATTR_NSH was added later (no-one cared that NSH doesn't work, because
OVS didn't support it yet?).

In general, any addition of a new attribute into that enumeration leads to
inevitable clash between userpsace-only attributes and new kernel attributes.

After the kernel update, kernel provides new attributes to the userspace and
userspace tries to parse them as one of the userspace-only attributes and
fails.   In our current case userspace is trying to parse OVS_KEY_ATTR_IPV6_EXTHDR
as userspace-only OVS_KEY_ATTR_PACKET_TYPE, because they have the same value in the
enum, fails and discards the netlink message as malformed.  So, IPv6 is fully
broken, because OVS_KEY_ATTR_IPV6_EXTHDR is supplied now with every IPv6 packet
that goes to userspace.

We need to unify the view of 'enum ovs_key_attr' between userspace and kernel
before we can add any new values to it.

One way to do that should be addition of both userspace-only attributes to the
kernel header (and maybe exposing OVS_KEY_ATTR_TUNNEL_INFO too, just to keep
it flat and avoid any possible problems in the future).  Any other suggestions
are welcome.  But in any case this will require careful testing with existing
OVS userspace to avoid any unexpected issues.

Moving forward, I think, userspace OVS should find a way to not have userpsace-only
attributes, or have them as a separate enumeration.  But I'm not sure how to do
that right now.  Or we'll have to add userspace-only attributes to the kernel
uapi before using them.

Sorry for the mess.

Best regards, Ilya Maximets.
