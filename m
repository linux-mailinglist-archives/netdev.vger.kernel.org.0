Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C889624A9F1
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 01:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbgHSX1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 19:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbgHSX1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 19:27:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E880C061757
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 16:27:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 32CAD11DB315F;
        Wed, 19 Aug 2020 16:11:04 -0700 (PDT)
Date:   Wed, 19 Aug 2020 16:27:49 -0700 (PDT)
Message-Id: <20200819.162749.429169729481879920.davem@davemloft.net>
To:     vishal@chelsio.com
Cc:     netdev@vger.kernel.org, rahul.lakkireddy@chelsio.com,
        mkubecek@suse.cz
Subject: Re: [PATCH net-next] ethtool: allow flow-type ether without IP
 protocol field
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200818185503.664-1-vishal@chelsio.com>
References: <20200818185503.664-1-vishal@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Aug 2020 16:11:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vishal Kulkarni <vishal@chelsio.com>
Date: Wed, 19 Aug 2020 00:25:03 +0530

> Set IP protocol mask only when IP protocol field is set.
> This will allow flow-type ether with vlan rule which don't have
> protocol field to apply.
> 
> ethtool -N ens5f4 flow-type ether proto 0x8100 vlan 0x600\
> m 0x1FFF action 3 loc 16
> 
> Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>

Michal, please review.

> ---
>  net/ethtool/ioctl.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> index 441794e0034f..e6f5cf52023c 100644
> --- a/net/ethtool/ioctl.c
> +++ b/net/ethtool/ioctl.c
> @@ -3025,13 +3025,14 @@ ethtool_rx_flow_rule_create(const struct ethtool_rx_flow_spec_input *input)
>  	case TCP_V4_FLOW:
>  	case TCP_V6_FLOW:
>  		match->key.basic.ip_proto = IPPROTO_TCP;
> +		match->mask.basic.ip_proto = 0xff;
>  		break;
>  	case UDP_V4_FLOW:
>  	case UDP_V6_FLOW:
>  		match->key.basic.ip_proto = IPPROTO_UDP;
> +		match->mask.basic.ip_proto = 0xff;
>  		break;
>  	}
> -	match->mask.basic.ip_proto = 0xff;
>  
>  	match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_BASIC);
>  	match->dissector.offset[FLOW_DISSECTOR_KEY_BASIC] =
> -- 
> 2.21.1
> 
