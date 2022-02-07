Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 510BB4AB5D1
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 08:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233660AbiBGHXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 02:23:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238266AbiBGHN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 02:13:28 -0500
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0665C043181;
        Sun,  6 Feb 2022 23:13:26 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V3nwNrk_1644218002;
Received: from 30.225.28.47(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V3nwNrk_1644218002)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 07 Feb 2022 15:13:23 +0800
Message-ID: <0c4902f4-e744-fe95-1a05-51ae936c4516@linux.alibaba.com>
Date:   Mon, 7 Feb 2022 15:13:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH v2 net-next 3/3] net/smc: Fallback when handshake
 workqueue congested
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, matthieu.baerts@tessares.net
References: <cover.1643380219.git.alibuda@linux.alibaba.com>
 <2d3f81193fc7a245c50b30329d0e84ae98427a33.1643380219.git.alibuda@linux.alibaba.com>
 <YfTDjXh8zP3WBAtg@TonyMac-Alibaba>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <YfTDjXh8zP3WBAtg@TonyMac-Alibaba>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


After some trial and thought, I found that the scope of netlink control 
is too large, we should limit the scope to socket. Adding a socket 
option may be a better choice, what do you think?


在 2022/1/29 下午12:33, Tony Lu 写道:
> On Fri, Jan 28, 2022 at 10:44:38PM +0800, D. Wythe wrote:
>> From: "D. Wythe" <alibuda@linux.alibaba.com>
>> @@ -19,3 +19,15 @@ config SMC_DIAG
> 
> ...
> 
>> +if SMC
>> +
>> +config SMC_AUTO_FALLBACK
>> +	bool "SMC: automatic fallback to TCP"
>> +	default y
>> +	help
>> +	  Allow automatic fallback to TCP accroding to the pressure of SMC-R
>> +	  handshake process.
>> +
>> +	  If that's not what you except or unsure, say N.
>> +endif
> 
> Using a netlink knob to control behavior with static key should be more
> flexible. As I appended in the previous version of this patch.
> 
> Thank you,
> Tony Lu
