Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 638E46190C6
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 07:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiKDGPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 02:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiKDGPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 02:15:46 -0400
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D44B127DC6;
        Thu,  3 Nov 2022 23:15:44 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R271e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=chentao.kernel@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VTvV9Ei_1667542539;
Received: from 30.221.117.118(mailfrom:chentao.kernel@linux.alibaba.com fp:SMTPD_---0VTvV9Ei_1667542539)
          by smtp.aliyun-inc.com;
          Fri, 04 Nov 2022 14:15:40 +0800
Message-ID: <a0084580-7956-0825-42de-90c0b220cc21@linux.alibaba.com>
Date:   Fri, 4 Nov 2022 14:15:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.3
Subject: Re: [PATCH net-next] netlink: Fix potential skb memleak in
 netlink_ack
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Petr Machata <petrm@nvidia.com>,
        Kees Cook <keescook@chromium.org>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <7a382b9503d10d235238ca55938bc933d92a1de7.1667389213.git.chentao.kernel@linux.alibaba.com>
 <20221102143953.001f1247@kernel.org>
From:   Tao Chen <chentao.kernel@linux.alibaba.com>
In-Reply-To: <20221102143953.001f1247@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2022/11/3 上午5:39, Jakub Kicinski 写道:
> On Wed,  2 Nov 2022 20:08:20 +0800 Tao Chen wrote:
>> We should clean the skb resource if nlmsg_put/append failed
>> , so fix it.
> 
> The comma should be at the end of the previous line.
> But really the entire ", so fix it." is redundant.
> 
Thank you, i will pay attention next time
>> Fiexs: commit 738136a0e375 ("netlink: split up copies in the
>> ack construction")
> 
> Please look around to see how to correctly format a Fixes tag
> (including not line wrapping it).
> 
> How did you find this bug? An automated tool? Syzbot?
> 
> One more note below on the code itself.
> 
This was found by the coverity tool, i will add it.
>> Signed-off-by: Tao Chen <chentao.kernel@linux.alibaba.com>
>> ---
>>   net/netlink/af_netlink.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
>> index c6b8207e..9d73dae 100644
>> --- a/net/netlink/af_netlink.c
>> +++ b/net/netlink/af_netlink.c
>> @@ -2500,7 +2500,7 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
>>   
>>   	skb = nlmsg_new(payload + tlvlen, GFP_KERNEL);
>>   	if (!skb)
>> -		goto err_bad_put;
>> +		goto err_skb;
>>   
>>   	rep = nlmsg_put(skb, NETLINK_CB(in_skb).portid, nlh->nlmsg_seq,
>>   			NLMSG_ERROR, sizeof(*errmsg), flags);
>> @@ -2528,6 +2528,8 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
>>   	return;
>>   
>>   err_bad_put:
>> +	kfree_skb(skb);
> 
> Please use nlmsg_free() since we allocated with nlmsg_new().
> 
Ok, i will send it in v2.
>> +err_skb:
>>   	NETLINK_CB(in_skb).sk->sk_err = ENOBUFS;
>>   	sk_error_report(NETLINK_CB(in_skb).sk);
>>   }
