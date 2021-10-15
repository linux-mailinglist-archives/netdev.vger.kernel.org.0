Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F9342F49F
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 16:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240211AbhJOOCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 10:02:38 -0400
Received: from mslow1.mail.gandi.net ([217.70.178.240]:35095 "EHLO
        mslow1.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239577AbhJOOCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 10:02:37 -0400
Received: from relay6-d.mail.gandi.net (unknown [217.70.183.198])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id A905CC2B9A;
        Fri, 15 Oct 2021 13:57:00 +0000 (UTC)
Received: (Authenticated sender: i.maximets@ovn.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 57A8AC0007;
        Fri, 15 Oct 2021 13:56:37 +0000 (UTC)
Message-ID: <1d0a5e90-b878-61a1-99af-35702b72f2d9@ovn.org>
Date:   Fri, 15 Oct 2021 15:56:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Cc:     i.maximets@ovn.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [ovs-dev] [PATCH net-next v7] net: openvswitch: IPv6: Add IPv6
 extension header support
Content-Language: en-US
To:     Toms Atteka <cpp.code.lv@gmail.com>, netdev@vger.kernel.org,
        pshelar@ovn.org, davem@davemloft.net, kuba@kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
References: <20211014211828.291213-1-cpp.code.lv@gmail.com>
From:   Ilya Maximets <i.maximets@ovn.org>
In-Reply-To: <20211014211828.291213-1-cpp.code.lv@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/14/21 23:18, Toms Atteka wrote:
> This change adds a new OpenFlow field OFPXMT_OFB_IPV6_EXTHDR and
> packets can be filtered using ipv6_ext flag.
> 
> Signed-off-by: Toms Atteka <cpp.code.lv@gmail.com>
> ---
>  include/uapi/linux/openvswitch.h |  16 +++-
>  net/openvswitch/flow.c           | 140 +++++++++++++++++++++++++++++++
>  net/openvswitch/flow.h           |  14 ++++
>  net/openvswitch/flow_netlink.c   |  24 +++++-
>  4 files changed, 192 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> index a87b44cd5590..763adf3dce23 100644
> --- a/include/uapi/linux/openvswitch.h
> +++ b/include/uapi/linux/openvswitch.h
> @@ -344,8 +344,17 @@ enum ovs_key_attr {
>  	OVS_KEY_ATTR_NSH,       /* Nested set of ovs_nsh_key_* */
>  
>  #ifdef __KERNEL__
> -	OVS_KEY_ATTR_TUNNEL_INFO,  /* struct ip_tunnel_info */
> +	OVS_KEY_ATTR_TUNNEL_INFO,/* struct ip_tunnel_info */
> +	__OVS_KEY_ATTR_PADDING_1,/* Padding to match field count with ovs */
>  #endif
> +
> +#ifndef __KERNEL__
> +	__OVS_KEY_ATTR_PADDING_2,/* Padding to match field count with ovs */
> +	__OVS_KEY_ATTR_PADDING_3,/* Padding to match field count with ovs */
> +#endif
> +
> +	OVS_KEY_ATTR_IPV6_EXTHDRS,  /* struct ovs_key_ipv6_exthdr */
> +
>  	__OVS_KEY_ATTR_MAX
>  };

Not a full review, but, I think, that we should not add paddings, and
define OVS_KEY_ATTR_IPV6_EXTHDRS before the OVS_KEY_ATTR_TUNNEL_INFO
instead.  See my comments for v6:
  https://lore.kernel.org/netdev/8c4ee3e8-0400-ee6e-b12c-327806f26dae@ovn.org/T/#u

Best regards, Ilya Maximets.
