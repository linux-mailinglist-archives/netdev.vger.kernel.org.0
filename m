Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8FE2D536C
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 06:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732803AbgLJFlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 00:41:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:60936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730584AbgLJFlE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 00:41:04 -0500
Message-ID: <5057047d659b337317d1ee8355a2659c78d3315f.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607578823;
        bh=Q5F4J5wppiN0Rkj8e1cHlqpk4IOx2IP2r3JY2um8XKc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kQRAG7iDJtJv7KFLKySWen9sLBE13I21hWcc3LeLakxgmpUzbZsDKD8MWla0waigz
         JVm1Q5tup6bzX2xw+eYsGGv2qJalgAo1bYv38mc3klodRaU7+Z8ZdzrjGCpcgQH99+
         x7JqZZVRIrb8LDTfsGg5OTHpIjnlzorlz4kVV6mVKx0DnsY9Wh8/zUxQlytk1y1psW
         l2tWkVEWitNhZt6RkQu8E9XVuXhthfqquJUFlr/LrZsci3b1hREYYmoXoVbQK7veN3
         p/5Z9bZjtmcw77U6I5mGzi4Ti1DCjAmKI84NjKwc4FNVNdA8KaUlcOqNJ+joXhHSPG
         wW2ytPWj07eAQ==
Subject: Re: [PATCH net-next 3/7] net: hns3: add support for forwarding
 packet to queues of specified TC when flow director rule hit
From:   Saeed Mahameed <saeed@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, huangdaode@huawei.com,
        Jian Shen <shenjian15@huawei.com>
Date:   Wed, 09 Dec 2020 21:40:22 -0800
In-Reply-To: <1607571732-24219-4-git-send-email-tanhuazhong@huawei.com>
References: <1607571732-24219-1-git-send-email-tanhuazhong@huawei.com>
         <1607571732-24219-4-git-send-email-tanhuazhong@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-12-10 at 11:42 +0800, Huazhong Tan wrote:
> From: Jian Shen <shenjian15@huawei.com>
> 
> For some new device, it supports forwarding packet to queues
> of specified TC when flow director rule hit. So extend the
> command handle to support it.
> 

...

>  static int hclge_config_action(struct hclge_dev *hdev, u8 stage,
>  			       struct hclge_fd_rule *rule)
>  {
> +	struct hclge_vport *vport = hdev->vport;
> +	struct hnae3_knic_private_info *kinfo = &vport->nic.kinfo;
>  	struct hclge_fd_ad_data ad_data;
>  
> +	memset(&ad_data, 0, sizeof(struct hclge_fd_ad_data));
>  	ad_data.ad_id = rule->location;
>  
>  	if (rule->action == HCLGE_FD_ACTION_DROP_PACKET) {
>  		ad_data.drop_packet = true;
> -		ad_data.forward_to_direct_queue = false;
> -		ad_data.queue_id = 0;
> +	} else if (rule->action == HCLGE_FD_ACTION_SELECT_TC) {
> +		ad_data.override_tc = true;
> +		ad_data.queue_id =
> +			kinfo->tc_info.tqp_offset[rule->tc];
> +		ad_data.tc_size =
> +			ilog2(kinfo->tc_info.tqp_count[rule->tc]);

In the previous patch you copied this info from mqprio, which is an
egress qdisc feature, this patch is clearly about rx flow director, I
think the patch is missing some context otherwise it doesn't make any
sense.

>  	} else {
> -		ad_data.drop_packet = false;
>  		ad_data.forward_to_direct_queue = true;
>  		ad_data.queue_id = rule->queue_id;
>  	}
> @@ -5937,7 +5950,7 @@ static int hclge_add_fd_entry(struct
> hnae3_handle *handle,
>  			return -EINVAL;
>  		}
>  
> -		action = HCLGE_FD_ACTION_ACCEPT_PACKET;
> +		action = HCLGE_FD_ACTION_SELECT_QUEUE;
>  		q_index = ring;
>  	}
>  
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
> b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
> index b3c1301..a481064 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
> @@ -572,8 +572,9 @@ enum HCLGE_FD_PACKET_TYPE {
>  };
>  
>  enum HCLGE_FD_ACTION {
> -	HCLGE_FD_ACTION_ACCEPT_PACKET,
> +	HCLGE_FD_ACTION_SELECT_QUEUE,
>  	HCLGE_FD_ACTION_DROP_PACKET,
> +	HCLGE_FD_ACTION_SELECT_TC,

what is SELECT_TC ? you never actually write this value anywhere  in
this patch.


