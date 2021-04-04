Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEB935394F
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 20:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbhDDSBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 14:01:47 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:54679 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbhDDSBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Apr 2021 14:01:44 -0400
X-Originating-IP: 78.45.89.65
Received: from [192.168.1.23] (ip-78-45-89-65.net.upcbroadband.cz [78.45.89.65])
        (Authenticated sender: i.maximets@ovn.org)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 189EC240003;
        Sun,  4 Apr 2021 18:01:36 +0000 (UTC)
Subject: Re: [PATCH net] openvswitch: fix send of uninitialized stack memory
 in ct limit reply
To:     Ilya Maximets <i.maximets@ovn.org>,
        Pravin B Shelar <pshelar@ovn.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yi-Hung Wei <yihung.wei@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ovs dev <dev@openvswitch.org>
References: <20210404175031.3834734-1-i.maximets@ovn.org>
From:   Ilya Maximets <i.maximets@ovn.org>
Message-ID: <84e7d112-f29f-022a-8863-69f1db157c10@ovn.org>
Date:   Sun, 4 Apr 2021 20:01:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210404175031.3834734-1-i.maximets@ovn.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CC: ovs-dev

On 4/4/21 7:50 PM, Ilya Maximets wrote:
> 'struct ovs_zone_limit' has more members than initialized in
> ovs_ct_limit_get_default_limit().  The rest of the memory is a random
> kernel stack content that ends up being sent to userspace.
> 
> Fix that by using designated initializer that will clear all
> non-specified fields.
> 
> Fixes: 11efd5cb04a1 ("openvswitch: Support conntrack zone limit")
> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
> ---
>  net/openvswitch/conntrack.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
> index c29b0ef1fc27..cadb6a29b285 100644
> --- a/net/openvswitch/conntrack.c
> +++ b/net/openvswitch/conntrack.c
> @@ -2032,10 +2032,10 @@ static int ovs_ct_limit_del_zone_limit(struct nlattr *nla_zone_limit,
>  static int ovs_ct_limit_get_default_limit(struct ovs_ct_limit_info *info,
>  					  struct sk_buff *reply)
>  {
> -	struct ovs_zone_limit zone_limit;
> -
> -	zone_limit.zone_id = OVS_ZONE_LIMIT_DEFAULT_ZONE;
> -	zone_limit.limit = info->default_limit;
> +	struct ovs_zone_limit zone_limit = {
> +		.zone_id = OVS_ZONE_LIMIT_DEFAULT_ZONE,
> +		.limit   = info->default_limit,
> +	};
>  
>  	return nla_put_nohdr(reply, sizeof(zone_limit), &zone_limit);
>  }
> 

