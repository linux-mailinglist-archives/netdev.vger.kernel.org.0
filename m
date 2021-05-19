Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C1D388B32
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 11:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347402AbhESJy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 05:54:57 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:33835 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347460AbhESJyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 05:54:18 -0400
Received: (Authenticated sender: i.maximets@ovn.org)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 0F8BB20010;
        Wed, 19 May 2021 09:52:50 +0000 (UTC)
Subject: Re: [PATCH net-next v2] net: openvswitch: IPv6: Add IPv6 extension
 header support
To:     Toms Atteka <cpp.code.lv@gmail.com>, netdev@vger.kernel.org
References: <20210517152051.35233-1-cpp.code.lv@gmail.com>
Cc:     i.maximets@ovn.org, "pshelar@ovn.org" <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        ovs dev <dev@openvswitch.org>,
        Jakub Kicinski <kuba@kernel.org>, Ben Pfaff <blp@ovn.org>
From:   Ilya Maximets <i.maximets@ovn.org>
Message-ID: <614d9840-cd9d-d8b1-0d88-ce07e409068d@ovn.org>
Date:   Wed, 19 May 2021 11:52:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210517152051.35233-1-cpp.code.lv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/17/21 5:20 PM, Toms Atteka wrote:
> IPv6 extension headers carry optional internet layer information
> and are placed between the fixed header and the upper-layer
> protocol header.
> 
> This change adds a new OpenFlow field OFPXMT_OFB_IPV6_EXTHDR and
> packets can be filtered using ipv6_ext flag.
> 
> Tested-at: https://github.com/TomCodeLV/ovs/actions/runs/504185214
> Signed-off-by: Toms Atteka <cpp.code.lv@gmail.com>
> ---
>  include/uapi/linux/openvswitch.h |   1 +
>  net/openvswitch/flow.c           | 141 +++++++++++++++++++++++++++++++
>  net/openvswitch/flow.h           |  14 +++
>  net/openvswitch/flow_netlink.c   |   5 +-
>  4 files changed, 160 insertions(+), 1 deletion(-)
> 
> 
> base-commit: 5d869070569a23aa909c6e7e9d010fc438a492ef
> 
> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> index 8d16744edc31..a19812b6631a 100644
> --- a/include/uapi/linux/openvswitch.h
> +++ b/include/uapi/linux/openvswitch.h
> @@ -420,6 +420,7 @@ struct ovs_key_ipv6 {
>  	__u8   ipv6_tclass;
>  	__u8   ipv6_hlimit;
>  	__u8   ipv6_frag;	/* One of OVS_FRAG_TYPE_*. */
> +	__u16  ipv6_exthdr;
>  };

Wouldn't this break existing userspace?  Curent OVS expects netlink
message with attribute size equal to the old version of 'struct ovs_key_ipv6'
and it will discard OVS_KEY_ATTR_IPV6 as malformed.

This should likely be a completely new structure and a completely new
OVS_KEY_ATTR.

Best regards, Ilya Maximets.
