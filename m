Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA701790C5
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 14:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729348AbgCDNC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 08:02:58 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:31489 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729267AbgCDNC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 08:02:58 -0500
X-Greylist: delayed 504 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Mar 2020 08:02:54 EST
Received: from [192.168.1.6] (unknown [101.86.128.44])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 1912040F71;
        Wed,  4 Mar 2020 20:54:26 +0800 (CST)
Subject: Re: [PATCH nf-next v5 0/4] netfilter: flowtable: add indr-block
 offload
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
References: <1582521775-25176-1-git-send-email-wenxu@ucloud.cn>
 <20200303215300.qzo4ankxq5ktaba4@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <83bfbc34-6a3e-1f31-4546-1511c5dcddf5@ucloud.cn>
Date:   Wed, 4 Mar 2020 20:54:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200303215300.qzo4ankxq5ktaba4@salvia>
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSEhJS0tLSkhNSExOT0hZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MQg6SQw*GDg3QyE2I005PioK
        IRkwCh1VSlVKTkNISElNT01NSU1MVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLSlVD
        TVVKSUNVT09ZV1kIAVlBSE5ISTcG
X-HM-Tid: 0a70a59c90942086kuqy1912040f71
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2020/3/4 5:53, Pablo Neira Ayuso Ð´µÀ:
> Hi,
>
> On Mon, Feb 24, 2020 at 01:22:51PM +0800, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> This patch provide tunnel offload based on route lwtunnel. 
>> The first two patches support indr callback setup
>> Then add tunnel match and action offload.
>>
>> This version modify the second patch: make the dev can bind with different 
>> flowtable and check the NF_FLOWTABLE_HW_OFFLOAD flags in 
>> nf_flow_table_indr_block_cb_cmd. 
> I found some time to look at this indirect block infrastructure that
> you have added to net/core/flow_offload.c
>
> This is _complex_ code, I don't understand why it is so complex.
> Frontend calls walks into the driver through callback, then, it gets
> back to the front-end code again through another callback to come
> back... this is hard to follow.
>
> Then, we still have problem with the existing approach that you
> propose, since there is 1:N mapping between the indirect block and the
> net_device.

The indirect block infrastructure is designed by the driver guys. The callbacks

is used for building and finishing relationship between the tunnel device and

the hardware devices. Such as the tunnel device come in and go away and the hardware

device come in and go away. The relationship between the tunnel device and the

hardware devices is so subtle.

> Probably not a requirement in your case, but the same net_device might
> be used in several flowtables. Your patch is flawed there and I don't
> see an easy way to fix this.

The same tunnel device can only be added to one offloaded flowtables. The tunnel device

can build the relationship with the hardware devices one time in the dirver. This is protected

by flow_block_cb_is_busy and xxx_indr_block_cb_priv in driver.


>
> I know there is no way to use ->ndo_setup_tc for tunnel devices, but
> you could have just make it work making it look consistent to the
> ->ndo_setup_tc logic.

I think the difficulty is how to find the hardware device for tunnel device to set the rule

to the hardware.

>
> I'm inclined to apply this patch though, in the hope that this all can
> be revisited later to get it in line with the ->ndo_setup_tc approach.
> However, probably I'm hoping for too much.
>
> Thank you.
>
