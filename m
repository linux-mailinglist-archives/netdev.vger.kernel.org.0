Return-Path: <netdev+bounces-5920-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B2FCF713570
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 17:20:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 17CEB1C20A05
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 15:20:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 500A0134B3;
	Sat, 27 May 2023 15:20:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F643FEF
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 15:20:44 +0000 (UTC)
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE42D8;
	Sat, 27 May 2023 08:20:40 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R821e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0Vja8aMX_1685200823;
Received: from 30.13.48.72(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0Vja8aMX_1685200823)
          by smtp.aliyun-inc.com;
          Sat, 27 May 2023 23:20:36 +0800
Message-ID: <34e6b564-a658-4461-ebec-f53dd80a9125@linux.alibaba.com>
Date: Sat, 27 May 2023 23:20:22 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCH net 2/2] net/smc: Don't use RMBs not mapped to new link in
 SMCRv2 ADD LINK
To: Wenjia Zhang <wenjia@linux.ibm.com>, kgraul@linux.ibm.com,
 jaka@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com
Cc: linux-s390@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <1685101741-74826-1-git-send-email-guwen@linux.alibaba.com>
 <1685101741-74826-3-git-send-email-guwen@linux.alibaba.com>
 <f134294c-2919-6069-d362-87a84c846690@linux.ibm.com>
From: Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <f134294c-2919-6069-d362-87a84c846690@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.0 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 2023/5/27 18:22, Wenjia Zhang wrote:
> 
> I'm wondering if this crash is introduced by the first fix patch you wrote.
> 
> Thanks,
> Wenjia

Hi Wenjia,

No, the crash can be reproduced without my two patches by the following steps:

1. Each side activates only one RNIC firstly and set the default sndbuf/RMB sizes to more
    than 16KB, such as 64KB, through sysctl net.smc.{wmem | rmem}.
    (The reason why initial sndbufs/RMBs size needs to be larger than 16KB will be explained later)

2. Use SMCRv2 in any test, just to create a link group that has some alloced RMBs.

    Example of step #1 #2:

    [server]
    smcr ueid add 1234
    sysctl net.smc.rmem=65536
    sysctl net.smc.wmem=65536
    smc_run sockperf sr --tcp

    [client]
    smcr ueid add 1234
    sysctl net.smc.rmem=65536
    sysctl net.smc.wmem=65536
    smc_run sockperf pp --tcp -i <server ip> -t <time>


3. Change the default sndbuf/RMB sizes, make sure they are larger than initial size above,
    such as 256KB.

4. Then rerun the test, and there will be some bigger RMBs alloced. And when the test is
    running, activate the second alternate RNIC of each side. It will trigger to add a new
    link and do what I described in the second patch's commit log, that only map the in-use
    256KB RMBs to new link but try to access the unused 64KB RMBs' invalid mr[new_link->lnk_idx].

    Example of step #3 #4:

    [server]
    sysctl net.smc.rmem=262144
    sysctl net.smc.wmem=262144
    smc_run sockperf sr --tcp

    [client]
    sysctl net.smc.rmem=262144
    sysctl net.smc.wmem=262144
    smc_run sockperf pp --tcp -i <server ip> -t <time>

    When the sockperf is running:

    [server/client]
    ip link set dev <2nd RNIC> up	# activate the second alternate RNIC, then crash occurs.


At the beginning, I only found the crash in the second patch. But when I try to fix it,
I found the issue descibed in the first patch.

In first patch, if I understand correctly, smc_llc_get_first_rmb() is aimed to get the first
RMB in lgr->rmb[*]. If so, It should start from lgr->rmbs[0] instead of lgr->rmbs[1], right?

Then back to the reason needs to be explained in step #1. Because of the issue mentioned
above in smc_llc_get_first_rmb(), if we set the initial sndbuf/RMB sizes to 16KB, these 16KB
RMBs (in lgr->rmbs[0]) alloced in step #2 will happen not to be accessed in step #4, so the
potential crash is hided.

So, the crash is not introduced by the first fix. Instead, it is the first issue that may hide
the second issue(crash) in special cases.

I am a little curious why you think the first fix patch caused the second crash? Is
something wrong in the first fix patch?

Thanks for your review!

Regards,
Wen Gu

