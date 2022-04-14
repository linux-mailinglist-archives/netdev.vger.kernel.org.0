Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68689500484
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 05:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236004AbiDNDHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 23:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiDNDHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 23:07:48 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D457F3135E
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 20:05:23 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=gjfang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VA0c0F1_1649905519;
Received: from 30.18.72.19(mailfrom:gjfang@linux.alibaba.com fp:SMTPD_---0VA0c0F1_1649905519)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 14 Apr 2022 11:05:20 +0800
Message-ID: <2b827f3b-a9db-e1a7-0dc9-65446e07bc63@linux.alibaba.com>
Date:   Thu, 14 Apr 2022 11:05:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
To:     vray@kalrayinc.com
Cc:     davem@davemloft.net, guoju.fgj@alibaba-inc.com, kuba@kernel.org,
        linyunsheng@huawei.com, netdev@vger.kernel.org,
        sjones@kalrayinc.com, vladimir.oltean@nxp.com
References: <1359936158.10849094.1649854873275.JavaMail.zimbra@kalray.eu>
Subject: Re: packet stuck in qdisc
Content-Language: en-US
From:   Guoju Fang <gjfang@linux.alibaba.com>
In-Reply-To: <1359936158.10849094.1649854873275.JavaMail.zimbra@kalray.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-11.2 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vincent,

I use the following bpftrace code to print those skb that exceed a 
latency (10ms). Plese see if it can help you.


#!/usr/bin/bpftrace

tracepoint:net:net_dev_queue
{
	@start[args->skbaddr] = nsecs;
	@core[args->skbaddr] = cpu;
}

tracepoint:net:net_dev_start_xmit
{
	$lat = (nsecs - @start[args->skbaddr]) / 1000;
	if ($lat > 10000) {
		time("%H:%M:%S  ");
		printf("queue core %d, xmit core %d, len %d, lat %d us\n",
			@core[args->skbaddr], cpu, args->len, $lat);
	}
	delete(@start[args->skbaddr]);
	delete(@core[args->skbaddr]);
}


Best Regards,
Guoju.
