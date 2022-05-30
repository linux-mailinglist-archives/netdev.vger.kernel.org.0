Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8700853743B
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 07:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232523AbiE3FK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 01:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbiE3FK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 01:10:26 -0400
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60B360A8B;
        Sun, 29 May 2022 22:10:23 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VEhVvoG_1653887420;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VEhVvoG_1653887420)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 30 May 2022 13:10:21 +0800
Date:   Mon, 30 May 2022 13:10:19 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     liuyacan@corp.netease.com
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ubraun@linux.ibm.com
Subject: Re: SMC-R problem under multithread
Message-ID: <YpRRuxCs+G6Fp4kT@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20220530031604.144875-1-liuyacan@corp.netease.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220530031604.144875-1-liuyacan@corp.netease.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 30, 2022 at 11:16:04AM +0800, liuyacan@corp.netease.com wrote:
> Hi experts,
> 
>   I recently used memcached to test the performance of SMC-R relative to TCP, but the results 
>   are confusing me. When using multithread on the server side, the performance of SMC-R is not as good as TCP.
>     
>   Specifically, I tested 4 scenarios with server thread: 1\2\4\8. The client uses 8threads fixedly. 
>   
>   server: (smc_run) memcached -t 1 -m 16384 -p [SERVER-PORT] -U 0 -F -c 10240 -o modern
>   client: (smc-run) memtier_benchmark -s [SERVER-IP] -p [SERVER-PORT] -P memcache_text --random-data --data-size=100 --data-size-pattern=S --key-minimum=30 --key-maximum=100  -n 5000000 -t 8
>   
>   The result is as follows:
>   
>   SMC-R:
>   
>   server-thread    ops/sec  client-cpu server-cpu
>       1             242k        220%         97%
>       2             362k        241%        128%
>       4             378k        242%        160%
>       8             395k        242%        210%
>       
>   TCP:
>   server-thread    ops/sec  client-cpu server-cpu
>       1             185k       224%         100%
>       2             435k       479%         200%
>       4             780k       731%         400%
>       8             938k       800%         659%                   
>    
>   It can be seen that as the number of threads increases, the performance increase of SMC-R is much slower than that of TCP.
> 
>   Am I doing something wrong? Or is it only when CPU resources are tight that SMC-R has a significant advantage ?  
>   
>   Any suggestions are welcome.

Hi Yacan,

This result matches some of our scenarios to some extent. Let's talk
about this result first.

Based on your benchmark, the biggest factor affecting performance seems
that the CPU resource is limited. As the number of threads increased,
neither CPU usage nor performance metrics improved, and CPU is limited
to about 200-250%. To make it clear, could you please give out more
metrics about per-CPU (usr / sys / hi / si) and memcached process usage.

Secondly, it seems that there is lots of connections in this test.
If it takes too much time to establish a connection, or the number of
final connections does not reach the specified value, the result will be
greatly affected. Could you please give out more details about the
connections numbers during benchmark?

We have noticed SMC has some limitations in multiple threads and many
connections. This benchmark happens to be basically in line with this
scenario. In general, there are some aspects in brief:
1. control path (connection setup and dismiss) is not as fast as TCP;
2. data path (lock contention, CQ spreading, etc.) needs further improvement;

About CPU limitation, SMC use one CQ and one core to handle data
transmission, which cannot spread workload over multiple cores. There is
is an early temporary solution [1], which also need to improve (new CQ
API, WR refactor). With this early solution, it shows several times the
performance improvement.

About the improvement of connection setup, you can see [2] for more
details, which is still a proposal now, and we are working on it now.
This show considerable performance boost.

[1] https://lore.kernel.org/all/20220126130140.66316-1-tonylu@linux.alibaba.com/
[2] https://lore.kernel.org/all/1653375127-130233-1-git-send-email-alibuda@linux.alibaba.com/

Thanks,
Tony LU
