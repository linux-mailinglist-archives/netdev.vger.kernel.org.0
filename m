Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1064A6EA2D1
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 06:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbjDUEb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 00:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjDUEbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 00:31:25 -0400
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629DD525C;
        Thu, 20 Apr 2023 21:31:22 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VgbJzgk_1682051473;
Received: from 30.221.149.253(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VgbJzgk_1682051473)
          by smtp.aliyun-inc.com;
          Fri, 21 Apr 2023 12:31:19 +0800
Message-ID: <3990a85c-c8d9-d20d-0c6d-f111ed872b7a@linux.alibaba.com>
Date:   Fri, 21 Apr 2023 12:31:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [RFC PATCH bpf-next v3 0/5] net/smc: Introduce BPF injection
 capability
Content-Language: en-US
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org
References: <1682051033-66125-1-git-send-email-alibuda@linux.alibaba.com>
In-Reply-To: <1682051033-66125-1-git-send-email-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-11.6 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Martin,

At now, most of the issues you mentioned have been resolved, mainly 
including

1. Use RCU instead of read write lock
2. Support for update
3. Negotiator requires a name
4. Added a KConfig with a default value of N to avoid affecting users 
who do not require SMC.
5. Revised some issues with test cases.

Do you have any other suggestions? If any, please let me know. Thank a 
lot! 😁
If there are no other opinions, I plan to convert the RFC into a formal 
PATCH.
What do you think?

Best wishes
D. Wythe


On 4/21/23 12:23 PM, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
>
> This patches attempt to introduce BPF injection capability for SMC,
> and add selftest to ensure code stability.
>
> As we all know that the SMC protocol is not suitable for all scenarios,
> especially for short-lived. However, for most applications, they cannot
> guarantee that there are no such scenarios at all. Therefore, apps
> may need some specific strategies to decide shall we need to use SMC
> or not, for example, apps can limit the scope of the SMC to a specific
> IP address or port.
>
> Based on the consideration of transparent replacement, we hope that apps
> can remain transparent even if they need to formulate some specific
> strategies for SMC using. That is, do not need to recompile their code.
>
> On the other hand, we need to ensure the scalability of strategies
> implementation. Although it is simple to use socket options or sysctl,
> it will bring more complexity to subsequent expansion.
>
> Fortunately, BPF can solve these concerns very well, users can write
> thire own strategies in eBPF to choose whether to use SMC or not.
> And it's quite easy for them to modify their strategies in the future.
>
> This patches implement injection capability for SMC via struct_ops.
> In that way, we can add new injection scenarios in the future.
>
> v3 -> v2:
>
> 1. Fix format errors in subject.
> 2. Remove unnecessary conditions in Kconfig.
>
> v2 -> v1:
>
> 1. Fix complie error if CONFIG_BPF_SYSCALL set while CONFIG_SMC_BPF not.
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/oe-kbuild-all/202304070326.mYVdiX9k-lkp@intel.com/
>
> 2. Fix potential reference leaks, smc_destruct may be prematurely retired
> due to pre conditions.
>
> D. Wythe (5):
>    net/smc: move smc_sock related structure definition
>    net/smc: allow smc to negotiate protocols on policies
>    net/smc: allow set or get smc negotiator by sockopt
>    bpf: add smc negotiator support in BPF struct_ops
>    bpf/selftests: add selftest for SMC bpf capability
>
>   include/net/smc.h                                | 268 +++++++++++++++++
>   include/uapi/linux/smc.h                         |   1 +
>   kernel/bpf/bpf_struct_ops_types.h                |   4 +
>   net/Makefile                                     |   1 +
>   net/smc/Kconfig                                  |  11 +
>   net/smc/af_smc.c                                 | 203 ++++++++++---
>   net/smc/bpf_smc.c                                | 360 +++++++++++++++++++++++
>   net/smc/smc.h                                    | 224 --------------
>   tools/testing/selftests/bpf/prog_tests/bpf_smc.c | 107 +++++++
>   tools/testing/selftests/bpf/progs/bpf_smc.c      | 265 +++++++++++++++++
>   10 files changed, 1185 insertions(+), 259 deletions(-)
>   create mode 100644 net/smc/bpf_smc.c
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_smc.c
>   create mode 100644 tools/testing/selftests/bpf/progs/bpf_smc.c
>

