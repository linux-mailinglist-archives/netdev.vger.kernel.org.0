Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB8D2D689F
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 21:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391312AbgLJUZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 15:25:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:43062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390070AbgLJUZ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 15:25:29 -0500
Message-ID: <d2c14bd14daabcd7f589e17b14b2ffeebc0d8a15.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607631888;
        bh=qTQp+kYtNGLesjGoQz58y9Jan53hivDYnrWOoOb9muM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kwk5MaCxi6jLgesKpFojsjEkZUOT+X/IwKNiWoSLMS1e7e0GhLQjaWr7m/IeaLg6O
         j0MU0v6PfQWAFlygU1TlNV3uaP5sfnqPnKDjVfJTqVaIfjtql/zzlbHRvJcGu93eeN
         rpyU7yEUnRuGyKq+A07XzS/vA7ZIYAf9YaoLiuBohtkLBHwEUaAi8Iv82uQfjcHUjH
         2VvdNR9uKTacWhtEDgUcXwm02iaf6OVglhL4O9RFtlAqs0Ky4FqaTxB4vEvwQlKSZJ
         HJSGeryrvbVgeL3z1YNbZBzNTdYQTaV008kGWv8wKOS77/WUZRtvFt703MmveWOgUj
         ezjLG7IxKVwog==
Subject: Re: [PATCH net-next 2/7] net: hns3: add support for tc mqprio
 offload
From:   Saeed Mahameed <saeed@kernel.org>
To:     tanhuazhong <tanhuazhong@huawei.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, huangdaode@huawei.com,
        Jian Shen <shenjian15@huawei.com>
Date:   Thu, 10 Dec 2020 12:24:46 -0800
In-Reply-To: <42c9fd63-3e51-543e-bbbd-01e7face7c9c@huawei.com>
References: <1607571732-24219-1-git-send-email-tanhuazhong@huawei.com>
         <1607571732-24219-3-git-send-email-tanhuazhong@huawei.com>
         <80b7502b700df43df7f66fa79fb9893399d0abd1.camel@kernel.org>
         <42c9fd63-3e51-543e-bbbd-01e7face7c9c@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-12-10 at 20:27 +0800, tanhuazhong wrote:
> 
> On 2020/12/10 12:50, Saeed Mahameed wrote:
> > On Thu, 2020-12-10 at 11:42 +0800, Huazhong Tan wrote:
> > > From: Jian Shen <shenjian15@huawei.com>
> > > 
> > > Currently, the HNS3 driver only supports offload for tc number
> > > and prio_tc. This patch adds support for other qopts, including
> > > queues count and offset for each tc.
> > > 
> > > When enable tc mqprio offload, it's not allowed to change
> > > queue numbers by ethtool. For hardware limitation, the queue
> > > number of each tc should be power of 2.
> > > 
> > > For the queues is not assigned to each tc by average, so it's
> > > should return vport->alloc_tqps for hclge_get_max_channels().
> > > 
> > 
> > The commit message needs some improvements, it is not really clear
> > what
> > the last two sentences are about.
> > 
> 
> The hclge_get_max_channels() returns the max queue number of each TC
> for
> user can set by command ethool -L. In previous implement, the queues
> are
> assigned to each TC by average, so we return it by vport-:
> alloc_tqps / num_tc. And now we can assign differrent queue number
> for
> each TC, so it shouldn't be divided by num_tc.

What do you mean by "queues assigned to each tc by average" ?

[...]

>   
> > > +	}
> > > +	if (hdev->vport[0].alloc_tqps < queue_sum) {
> > 
> > can't you just allocate new tqps according to the new mqprio input
> > like
> > other drivers do ? how the user allocates those tqps ?
> > 
> 
> maybe the name of 'alloc_tqps' is a little bit misleading, the
> meaning
> of this field is the total number of the available tqps in this
> vport.
> 

from your driver code it seems alloc_tqps is number of rings allocated
via ethool -L.

My point is, it seems like in this patch you demand for the queues to
be preallocated, but what other drivers do on setup tc, they just
duplicate what ever number of queues was configured prior to setup tc,
num_tc times.

> > > +		dev_err(&hdev->pdev->dev,
> > > +			"qopt queue count sum should be less than
> > > %u\n",
> > > +			hdev->vport[0].alloc_tqps);
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static void hclge_sync_mqprio_qopt(struct hnae3_tc_info
> > > *tc_info,
> > > +				   struct tc_mqprio_qopt_offload
> > > *mqprio_qopt)
> > > +{
> > > +	int i;
> > > +
> > > +	memset(tc_info, 0, sizeof(*tc_info));
> > > +	tc_info->num_tc = mqprio_qopt->qopt.num_tc;
> > > +	memcpy(tc_info->prio_tc, mqprio_qopt->qopt.prio_tc_map,
> > > +	       sizeof_field(struct hnae3_tc_info, prio_tc));
> > > +	memcpy(tc_info->tqp_count, mqprio_qopt->qopt.count,
> > > +	       sizeof_field(struct hnae3_tc_info, tqp_count));
> > > +	memcpy(tc_info->tqp_offset, mqprio_qopt->qopt.offset,
> > > +	       sizeof_field(struct hnae3_tc_info, tqp_offset));
> > > +
> > 
> > isn't it much easier to just store a copy of tc_mqprio_qopt in you
> > tc_info and then just:
> > tc_info->qopt = mqprio->qopt;
> > 
> > [...]
> 
> The tc_mqprio_qopt_offload still contains a lot of opt hns3 driver
> does
> not use yet, even if the hns3 use all the opt, I still think it is
> better to create our own struct, if struct tc_mqprio_qopt_offload
> changes in the future, we can limit the change to the
> tc_mqprio_qopt_offload convertion.
> 

ok.


