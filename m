Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 675FC5BDFEF
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 10:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiITIZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 04:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231372AbiITIYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 04:24:41 -0400
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A8CE6AA27;
        Tue, 20 Sep 2022 01:22:15 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R911e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VQIU5xu_1663662113;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0VQIU5xu_1663662113)
          by smtp.aliyun-inc.com;
          Tue, 20 Sep 2022 16:21:54 +0800
Date:   Tue, 20 Sep 2022 16:21:53 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Wen Gu <guwen@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net/smc: Introduce a specific sysctl for
 TEST_LINK time
Message-ID: <20220920082153.GD108825@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <1663641907-15852-1-git-send-email-guwen@linux.alibaba.com>
 <1663642434-30035-1-git-send-email-guwen@linux.alibaba.com>
 <20220920045520.GC108825@linux.alibaba.com>
 <1ad45b33-d88a-54b7-fbfa-831f58fca9d2@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ad45b33-d88a-54b7-fbfa-831f58fca9d2@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 20, 2022 at 02:23:09PM +0800, Wen Gu wrote:
>
>
>On 2022/9/20 12:55, dust.li wrote:
>
>> On Tue, Sep 20, 2022 at 10:53:54AM +0800, Wen Gu wrote:
>> > SMC-R tests the viability of link by sending out TEST_LINK LLC
>> > messages over RoCE fabric when connections on link have been
>> > idle for a time longer than keepalive interval (testlink time).
>> > 
>> > But using tcp_keepalive_time as testlink time maybe not quite
>> > suitable because it is default no less than two hours[1], which
>> > is too long for single link to find peer dead. The active host
>> > will still use peer-dead link (QP) sending messages, and can't
>> > find out until get IB_WC_RETRY_EXC_ERR error CQEs, which takes
>> > more time than TEST_LINK timeout (SMC_LLC_WAIT_TIME) normally.
>> > 
>> > So this patch introduces a independent sysctl for SMC-R to set
>> > link keepalive time, in order to detect link down in time. The
>> > default value is 30 seconds.
>> > 
>> > [1] https://www.rfc-editor.org/rfc/rfc1122#page-101
>> > 
>> > Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
>> > ---
>
>> > /* called after lgr was removed from lgr_list */
>> > diff --git a/net/smc/smc_llc.h b/net/smc/smc_llc.h
>> > index 4404e52..1de9a29 100644
>> > --- a/net/smc/smc_llc.h
>> > +++ b/net/smc/smc_llc.h
>> > @@ -19,6 +19,7 @@
>> > 
>> > #define SMC_LLC_WAIT_FIRST_TIME		(5 * HZ)
>> > #define SMC_LLC_WAIT_TIME		(2 * HZ)
>> > +#define SMC_LLC_TESTLINK_DEFAULT_TIME	30
>> 
>> I'm wondering why we don't follow the upper to macros using (30 * HZ) ?
>> 
>Thanks for the reivew.
>
>Because the value of sysctl_smcr_testlink_time is in seconds, and the value
>of llc_testlink_time is jiffies.
>
>I have thought about
>1) using proc_dointvec_jiffies as sysctl's proc_handler just like TCP does.
>   But proc_dointvec_jiffies has no minimum limit, value 0 makes no sense for SMC testlink.

Maybe 0 means disable the LLC TEST LINK ?


>2) using proc_dointvec_ms_jiffies_minmax as proc_handler. But millisecond interval
>   seems expensive for SMC test link.
>
>So, I choose to use proc_dointvec_minmax, make sysctl_smcr_testlink_time in
>seconds, and convert to jiffies when assigning to llc_testlink_time.

If proc_dointvec_jiffies_minmax is really the problem, maybe you can
write your own proc handler.


Thanks
