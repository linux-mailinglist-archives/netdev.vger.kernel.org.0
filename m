Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9188F6D885
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 03:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbfGSBoT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Jul 2019 21:44:19 -0400
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:15176 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbfGSBoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 21:44:18 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.1]) by rmmx-syy-dmz-app11-12011 (RichMail) with SMTP id 2eeb5d312054c02-a8005; Fri, 19 Jul 2019 09:43:49 +0800 (CST)
X-RM-TRANSID: 2eeb5d312054c02-a8005
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from [172.20.21.101] (unknown[112.25.154.148])
        by rmsmtp-syy-appsvr01-12001 (RichMail) with SMTP id 2ee15d31205337a-2e74a;
        Fri, 19 Jul 2019 09:43:48 +0800 (CST)
X-RM-TRANSID: 2ee15d31205337a-2e74a
Content-Type: text/plain; charset=gb2312
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] openvswitch: Fix a possible memory leak on dst_cache
From:   Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
In-Reply-To: <9b231232-dd6e-5733-2af9-e2fb3d6ae0a4@gmail.com>
Date:   Fri, 19 Jul 2019 09:43:47 +0800
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <F832C073-F038-40ED-B739-40799F3B859C@cmss.chinamobile.com>
References: <1563466028-2531-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
 <9b231232-dd6e-5733-2af9-e2fb3d6ae0a4@gmail.com>
To:     Gregory Rose <gvrose8192@gmail.com>
X-Mailer: Apple Mail (2.3273)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On 2019年7月19日, at 上午6:12, Gregory Rose <gvrose8192@gmail.com> wrote:
> 
> On 7/18/2019 9:07 AM, Haishuang Yan wrote:
>> dst_cache should be destroyed when fail to add flow actions.
>> 
>> Fixes: d71785ffc7e7 ("net: add dst_cache to ovs vxlan lwtunnel")
>> Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
>> ---
>>  net/openvswitch/flow_netlink.c | 1 +
>>  1 file changed, 1 insertion(+)
>> 
>> diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
>> index d7559c6..1fd1cdd 100644
>> --- a/net/openvswitch/flow_netlink.c
>> +++ b/net/openvswitch/flow_netlink.c
>> @@ -2608,6 +2608,7 @@ static int validate_and_copy_set_tun(const struct nlattr *attr,
>>  			 sizeof(*ovs_tun), log);
>>  	if (IS_ERR(a)) {
>>  		dst_release((struct dst_entry *)tun_dst);
>> +		dst_cache_destroy(&tun_dst->u.tun_info.dst_cache);
>>  		return PTR_ERR(a);
>>  	}
>>  
> 
> Nack.
> 
> dst_release will decrement the ref count and will call_rcu(&dst->rcu_head, dst_destroy_rcu) if the ref count is zero.  No other net drivers call dst_destroy SFAICT.
> 
> Haishuang,
> 
> are you trying to fix some specific problem here?
> 
> Thanks,
> 
> - Greg
> 
> 

Greg,

You’re right, dst_cache would be freed in metadata_dst_free:

  125
  126         if (dst->flags & DST_METADATA)
  127                 metadata_dst_free((struct metadata_dst *)dst);
  128         else
  129                 kmem_cache_free(dst->ops->kmem_cachep, dst);
  130

I thought I encountered a memory leak, but it seems not an issue, thanks for you explanation.

