Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1C48642194
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 03:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbiLECgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 21:36:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbiLECgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 21:36:08 -0500
Received: from mail.nfschina.com (unknown [124.16.136.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6D48E640C;
        Sun,  4 Dec 2022 18:36:05 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 942291E80D0B;
        Mon,  5 Dec 2022 10:31:51 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8G1ifBev-PxQ; Mon,  5 Dec 2022 10:31:48 +0800 (CST)
Received: from [172.30.38.124] (unknown [180.167.10.98])
        (Authenticated sender: liqiong@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 4DF011E80C97;
        Mon,  5 Dec 2022 10:31:48 +0800 (CST)
Subject: Re: [PATCH] net: sched: fix a error path in fw_change()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yu Zhe <yuzhe@nfschina.com>
References: <20221201151532.25433-1-liqiong@nfschina.com>
 <Y4unik6y8a0MuoFt@pop-os.localdomain>
From:   liqiong <liqiong@nfschina.com>
Message-ID: <6a8a4c34-83bf-9418-987e-56ac4b44ccc6@nfschina.com>
Date:   Mon, 5 Dec 2022 10:36:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <Y4unik6y8a0MuoFt@pop-os.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,MAY_BE_FORGED,
        NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022年12月04日 03:46, Cong Wang 写道:
> On Thu, Dec 01, 2022 at 11:15:32PM +0800, Li Qiong wrote:
>> The 'pfp' pointer could be null if can't find the target filter.
>> Check 'pfp' pointer and fix this error path.
> Did you see any actual kernel crash? And do you have a reproducer too?
> Please include them if you do.
Found this by  'smatch' tool,  I check and find it may be a real problem at the risk
of NULL pointer. Like 'fw_delete()', It checks  'pfp' and 'pfp == f' too.
 



>
>> Signed-off-by: Li Qiong <liqiong@nfschina.com>
>> ---
>>  net/sched/cls_fw.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/net/sched/cls_fw.c b/net/sched/cls_fw.c
>> index a32351da968c..b898e4a81146 100644
>> --- a/net/sched/cls_fw.c
>> +++ b/net/sched/cls_fw.c
>> @@ -289,6 +289,12 @@ static int fw_change(struct net *net, struct sk_buff *in_skb,
>>  			if (pfp == f)
>>  				break;
>>  
>> +		if (!pfp) {
>> +			tcf_exts_destroy(&fnew->exts);
>> +			kfree(fnew);
>> +			return err;
>
> BTW, err is 0 here, you have to set some error here.
You are right,  It should return  '-EINVAL'  -- can't get the target filter.



>
> Thanks.



