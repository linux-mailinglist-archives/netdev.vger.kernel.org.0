Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DADA51D4FB
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 11:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390710AbiEFJvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 05:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242864AbiEFJvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 05:51:16 -0400
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E46B465D13;
        Fri,  6 May 2022 02:47:32 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VCRUb.r_1651830449;
Received: from 30.225.28.185(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VCRUb.r_1651830449)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 06 May 2022 17:47:30 +0800
Message-ID: <90cf2e6b-e409-7f52-bde3-ebb93994b931@linux.alibaba.com>
Date:   Fri, 6 May 2022 17:47:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH net-next] net/smc: Fix smc-r link reference count
To:     Wen Gu <guwen@linux.alibaba.com>, kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1651814548-83231-1-git-send-email-alibuda@linux.alibaba.com>
 <e3dbf77b-777a-8b6b-3c52-d1bb3f385c26@linux.alibaba.com>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <e3dbf77b-777a-8b6b-3c52-d1bb3f385c26@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.0 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/5/6 下午3:58, Wen Gu 写道:

> Thanks for your analysis.
> 
> 1) Is the patch more appropriate to 'net' ?

That's my mistake.

> 2) The refcnt of smc link will be
> 
>     - initilized to 1 in smcr_link_init();
> 
>     - increased when connections assigned to the link;
>       eg. smc_conn_create() or smc_switch_link_and_count();
> 
>     - decreased when connections removed from the link or link is cleared,
>       eg. smc_conn_free(), smc_switch_link_and_count(), smcr_link_clear().
> 
>     I see the theoretical race between smcr_link_hold() and 
> smcr_link_put(). Have you encountered this
>     issue in actual test, such as triggering WARN of refcount_inc()? 
> Because IMHO the race window is small
>     (link state will turned to SMC_LNK_UNUSED after smcr_link_put() and 
> connections will not be assigned to it).
> 
> 

Got your point, this race may happened with our another radical change. 
At present, this patch may not be needed.


Thanks.
D. Wythe
