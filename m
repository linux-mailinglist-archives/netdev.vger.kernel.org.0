Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85E8F37F9C5
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 16:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234566AbhEMOhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 10:37:21 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:55027 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234544AbhEMOhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 10:37:03 -0400
Received: from [192.168.1.23] (ip-78-45-89-65.net.upcbroadband.cz [78.45.89.65])
        (Authenticated sender: i.maximets@ovn.org)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 0B755100002;
        Thu, 13 May 2021 14:35:48 +0000 (UTC)
Subject: Re: [ovs-dev] [PATCH net v2] openvswitch: meter: fix race when
 getting now_ms.
To:     Tao Liu <thomas.liu@ucloud.cn>, pshelar@ovn.org
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, i.maximets@ovn.org,
        jean.tourrilhes@hpe.com, kuba@kernel.org, davem@davemloft.net,
        wenxu@ucloud.cn
References: <20210513130800.31913-1-thomas.liu@ucloud.cn>
From:   Ilya Maximets <i.maximets@ovn.org>
Message-ID: <f26c37b5-487c-0399-e65b-e0a9d2259c03@ovn.org>
Date:   Thu, 13 May 2021 16:35:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210513130800.31913-1-thomas.liu@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/13/21 3:08 PM, Tao Liu wrote:
> We have observed meters working unexpected if traffic is 3+Gbit/s
> with multiple connections.
> 
> now_ms is not pretected by meter->lock, we may get a negative
> long_delta_ms when another cpu updated meter->used, then:
>     delta_ms = (u32)long_delta_ms;
> which will be a large value.
> 
>     band->bucket += delta_ms * band->rate;
> then we get a wrong band->bucket.
> 
> OpenVswitch userspace datapath has fixed the same issue[1] some
> time ago, and we port the implementation to kernel datapath.
> 
> [1] https://patchwork.ozlabs.org/project/openvswitch/patch/20191025114436.9746-1-i.maximets@ovn.org/
> 
> Fixes: 96fbc13d7e77 ("openvswitch: Add meter infrastructure")
> Signed-off-by: Tao Liu <thomas.liu@ucloud.cn>
> Suggested-by: Ilya Maximets <i.maximets@ovn.org>
> ---
> Changelog:
> v2: just set negative long_delta_ms to zero in case of race for meter lock.
> v1: make now_ms protected by meter lock.
> ---

Thanks!
I didn't test it, but the change looks good to me.

Reviewed-by: Ilya Maximets <i.maximets@ovn.org>

>  net/openvswitch/meter.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
> index 96b524c..896b8f5 100644
> --- a/net/openvswitch/meter.c
> +++ b/net/openvswitch/meter.c
> @@ -611,6 +611,14 @@ bool ovs_meter_execute(struct datapath *dp, struct sk_buff *skb,
>  	spin_lock(&meter->lock);
>  
>  	long_delta_ms = (now_ms - meter->used); /* ms */
> +	if (long_delta_ms < 0) {
> +		/* This condition means that we have several threads fighting
> +		 * for a meter lock, and the one who received the packets a
> +		 * bit later wins. Assuming that all racing threads received
> +		 * packets at the same time to avoid overflow.
> +		 */
> +		long_delta_ms = 0;
> +	}
>  
>  	/* Make sure delta_ms will not be too large, so that bucket will not
>  	 * wrap around below.
> 

