Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B662F5769
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbhANB7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 20:59:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:40798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728982AbhANB7A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 20:59:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 255A72343B;
        Thu, 14 Jan 2021 01:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610589499;
        bh=QsmD0Bge8rY2KWlyJvvPy2bG4NjrkNHoKmZWUy8ss98=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YXCALl+P4Z0XSGnzh4uRT1f4bLnwjFdXFDUKE/M+l4MiDTxVYIQx/xDpid3cu+xrJ
         gk7XGCm/Qi3bqPsTXLKaMkEOhndftXzcwEMg1aJGkJYEkXAUEMZge1NU7kpKsHhErI
         KpFJk0oUT2+6h0reQ2d0HZAZ6eboABFjLI6sX5kv/a4kkNzaCrwNL0hpNIYS0788ov
         xxGy++HJVlQ+vxZPzEy66UPv1SDkh6iLOa7L9fOen0ychP0EyfvA/wTJLcKmCYOFN2
         ycXN2Ps5EyfoUDYeEFiz8g6cbR3PKdogcZq3a+IsiVsi6ziXs7vqV6FIWntbN0ki+G
         BjEA0/mbFDypA==
Date:   Wed, 13 Jan 2021 17:58:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jarod Wilson <jarod@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] bonding: add a vlan+mac tx hashing option
Message-ID: <20210113175818.7dce3076@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210113223548.1171655-1-jarod@redhat.com>
References: <20201218193033.6138-1-jarod@redhat.com>
        <20210113223548.1171655-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jan 2021 17:35:48 -0500 Jarod Wilson wrote:
> This comes from an end-user request, where they're running multiple VMs on
> hosts with bonded interfaces connected to some interest switch topologies,
> where 802.3ad isn't an option. They're currently running a proprietary
> solution that effectively achieves load-balancing of VMs and bandwidth
> utilization improvements with a similar form of transmission algorithm.
> 
> Basically, each VM has it's own vlan, so it always sends its traffic out
> the same interface, unless that interface fails. Traffic gets split
> between the interfaces, maintaining a consistent path, with failover still
> available if an interface goes down.
> 
> This has been rudimetarily tested to provide similar results, suitable for
> them to use to move off their current proprietary solution. A patch for
> iproute2 is forthcoming as well, to properly support the new mode there as
> well.

> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> ---
> v2: verified netlink interfaces working, added Documentation, changed
> tx hash mode name to vlan+mac for consistency and clarity.
> 
>  Documentation/networking/bonding.rst | 13 +++++++++++++
>  drivers/net/bonding/bond_main.c      | 27 +++++++++++++++++++++++++--
>  drivers/net/bonding/bond_options.c   |  1 +
>  include/linux/netdevice.h            |  1 +
>  include/uapi/linux/if_bonding.h      |  1 +
>  5 files changed, 41 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
> index adc314639085..c78ceb7630a0 100644
> --- a/Documentation/networking/bonding.rst
> +++ b/Documentation/networking/bonding.rst
> @@ -951,6 +951,19 @@ xmit_hash_policy
>  		packets will be distributed according to the encapsulated
>  		flows.
>  
> +	vlan+mac
> +
> +		This policy uses a very rudimentary vland ID and source mac
> +		ID hash to load-balance traffic per-vlan, with failover
> +		should one leg fail. The intended use case is for a bond
> +		shared by multiple virtual machines, all configured to
> +		use their own vlan, to give lacp-like functionality
> +		without requiring lacp-capable switching hardware.
> +
> +		The formula for the hash is simply
> +
> +		hash = (vlan ID) XOR (source MAC)

But in the code it's only using one byte of the MAC, currently.

I think that's fine for the particular use case but should we call out
explicitly in the commit message why it's considered sufficient?

Someone can change it later, if needed, but best if we spell out the
current motivation.

>  	The default value is layer2.  This option was added in bonding
>  	version 2.6.3.  In earlier versions of bonding, this parameter
>  	does not exist, and the layer2 policy is the only policy.  The

> +static inline u32 bond_vlan_srcmac_hash(struct sk_buff *skb)

Can we drop the inline? It's a static function called once.

> +{
> +	struct ethhdr *mac_hdr = (struct ethhdr *)skb_mac_header(skb);

I don't see anything in the patch making sure the interface actually
has a L2 header. Should we validate somehow the ifc is Ethernet?

> +	u32 srcmac = mac_hdr->h_source[5];
> +	u16 vlan;
> +
> +	if (!skb_vlan_tag_present(skb))
> +		return srcmac;
> +
> +	vlan = skb_vlan_tag_get(skb);
> +
> +	return srcmac ^ vlan;
> +}
