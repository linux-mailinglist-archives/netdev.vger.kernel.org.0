Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD4E2D6915
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 21:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404668AbgLJUrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 15:47:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:51786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404641AbgLJUqv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 15:46:51 -0500
Message-ID: <16de519d16ea1925e892f396378b79a98b2aa43e.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607633170;
        bh=kStGZNnkONSQR3fWTTqsmgVODC0s9NrlElzH7Q2xP/g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GvWrWnpeoc7/RwE3S3pMBQhLvJQ9csGb0zTkqOCzyZVpkJwM19QO3uDynQkz3VZY5
         INH11BtfS/LDN0zqaiBTsJsRM0oHXuNrcnMaThk4wL7uMlny/sOFG5FPhG/6OGbax4
         826enM1ZGzuYaPvwD7IAUbII9pM76VwuLI5s6frC5tVIk5818Ib9VjafYXyYkMKp9R
         uJAoMJKkmto5gkQu8mxUK55KmvORkFQje9inOYtqbEA7rP9TTC/vnAQzHbDiLWuPRB
         Ngk2olGzT/LKsEtjdo6bp884d0viSUkkDOekm4RDRU2fqjB9/P1virI8zJaYWdUjYP
         HWFtRNhtj8JmA==
Subject: Re: [PATCH net-next 3/7] net: hns3: add support for forwarding
 packet to queues of specified TC when flow director rule hit
From:   Saeed Mahameed <saeed@kernel.org>
To:     tanhuazhong <tanhuazhong@huawei.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, huangdaode@huawei.com,
        Jian Shen <shenjian15@huawei.com>
Date:   Thu, 10 Dec 2020 12:46:09 -0800
In-Reply-To: <dc805355-9cb8-87f1-dc4b-f9cfed2a5764@huawei.com>
References: <1607571732-24219-1-git-send-email-tanhuazhong@huawei.com>
         <1607571732-24219-4-git-send-email-tanhuazhong@huawei.com>
         <5057047d659b337317d1ee8355a2659c78d3315f.camel@kernel.org>
         <dc805355-9cb8-87f1-dc4b-f9cfed2a5764@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-12-10 at 20:24 +0800, tanhuazhong wrote:
> 
> On 2020/12/10 13:40, Saeed Mahameed wrote:
> > On Thu, 2020-12-10 at 11:42 +0800, Huazhong Tan wrote:
> > > From: Jian Shen <shenjian15@huawei.com>
> > > 
> > > For some new device, it supports forwarding packet to queues
> > > of specified TC when flow director rule hit. So extend the
> > > command handle to support it.
> > > 
> > 
> > ...
> > 
> > >   static int hclge_config_action(struct hclge_dev *hdev, u8
> > > stage,
> > >   			       struct hclge_fd_rule *rule)
> > >   {
> > > +	struct hclge_vport *vport = hdev->vport;
> > > +	struct hnae3_knic_private_info *kinfo = &vport->nic.kinfo;
> > >   	struct hclge_fd_ad_data ad_data;
> > >   
> > > +	memset(&ad_data, 0, sizeof(struct hclge_fd_ad_data));
> > >   	ad_data.ad_id = rule->location;
> > >   
> > >   	if (rule->action == HCLGE_FD_ACTION_DROP_PACKET) {
> > >   		ad_data.drop_packet = true;
> > > -		ad_data.forward_to_direct_queue = false;
> > > -		ad_data.queue_id = 0;
> > > +	} else if (rule->action == HCLGE_FD_ACTION_SELECT_TC) {
> > > +		ad_data.override_tc = true;
> > > +		ad_data.queue_id =
> > > +			kinfo->tc_info.tqp_offset[rule->tc];
> > > +		ad_data.tc_size =
> > > +			ilog2(kinfo->tc_info.tqp_count[rule->tc]);
> > 
> > In the previous patch you copied this info from mqprio, which is an
> > egress qdisc feature, this patch is clearly about rx flow director,
> > I
> > think the patch is missing some context otherwise it doesn't make
> > any
> > sense.
> > 
> 
> Since tx and rx are in the same tqp, what we do here is to make tx
> and 
> rx in the same tc when rule is hit.
> 

this needs more clarification, even if tx and rx are the same hw
object, AFAIK there is not correlation between mqprio and tc rx
classifiers. 

> > >   	} else {
> > > -		ad_data.drop_packet = false;
> > >   		ad_data.forward_to_direct_queue = true;
> > >   		ad_data.queue_id = rule->queue_id;
> > >   	}
> > > @@ -5937,7 +5950,7 @@ static int hclge_add_fd_entry(struct
> > > hnae3_handle *handle,
> > >   			return -EINVAL;
> > >   		}
> > >   
> > > -		action = HCLGE_FD_ACTION_ACCEPT_PACKET;
> > > +		action = HCLGE_FD_ACTION_SELECT_QUEUE;
> > >   		q_index = ring;
> > >   	}
> > >   
> > > diff --git
> > > a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
> > > b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
> > > index b3c1301..a481064 100644
> > > --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
> > > +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
> > > @@ -572,8 +572,9 @@ enum HCLGE_FD_PACKET_TYPE {
> > >   };
> > >   
> > >   enum HCLGE_FD_ACTION {
> > > -	HCLGE_FD_ACTION_ACCEPT_PACKET,
> > > +	HCLGE_FD_ACTION_SELECT_QUEUE,
> > >   	HCLGE_FD_ACTION_DROP_PACKET,
> > > +	HCLGE_FD_ACTION_SELECT_TC,
> > 
> > what is SELECT_TC ? you never actually write this value
> > anywhere  in
> > this patch.
> > 
> 
> HCLGE_FD_ACTION_SELECT_TC means that the packet will be forwarded
> into 
> the queue of specified TC when rule is hit.
> 
what is "specified TC" in this context ?

Are we talking about ethtool nfc steering here ? because clearly this
was the purpose of HCLGE_FD_ACTION_ACCEPT_PACKET before it got removed.


> the assignment is in the next patch, maybe these two patch should be 
> merged for making it more readable.
> 
> 
> Thanks.
> Huazhong.
> 
> > 
> > .
> > 

