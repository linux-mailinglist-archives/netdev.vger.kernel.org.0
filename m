Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 978C46DEDE4
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 10:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbjDLIgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 04:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjDLIgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 04:36:21 -0400
Received: from out199-3.us.a.mail.aliyun.com (out199-3.us.a.mail.aliyun.com [47.90.199.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E696EAF;
        Wed, 12 Apr 2023 01:34:47 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R661e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VfvlHTJ_1681288402;
Received: from 30.221.150.135(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VfvlHTJ_1681288402)
          by smtp.aliyun-inc.com;
          Wed, 12 Apr 2023 16:33:23 +0800
Message-ID: <acb77026-c8eb-39e8-b3a8-23c348cbd60c@linux.alibaba.com>
Date:   Wed, 12 Apr 2023 16:33:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [RFC PATCH bpf-next 0/5] net/smc: Introduce BPF injection
 capability
Content-Language: en-US
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org
References: <1680795034-86384-1-git-send-email-alibuda@linux.alibaba.com>
In-Reply-To: <1680795034-86384-1-git-send-email-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-11.0 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi everyone,

It's seems the RFC patch been hanging for some time.  I would like to 
politely inquire if there are any suggestions or criticisms.
Compared to previous patches, this patch has several main features:

1. Allow registration of multiple negotiators, each SMC negotiator has a 
name and can be indexed that name
2. no read/write lock anymore
3. support bpf update

If you have any suggestions or criticisms, please let me know.

Thanks
D. Wythe

On 4/6/23 11:30 PM, D. Wythe wrote:
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
> D. Wythe (5):
>    net/smc: move smc_sock related structure definition
>    net/smc: net/smc: allow smc to negotiate protocols on policies
>    net/smc: allow set or get smc negotiator by sockopt
>    bpf: add smc negotiator support in BPF struct_ops
>    bpf/selftests: add selftest for SMC bpf capability
>
>   include/net/smc.h                                | 268 +++++++++++++++++
>   include/uapi/linux/smc.h                         |   1 +
>   kernel/bpf/bpf_struct_ops_types.h                |   4 +
>   net/Makefile                                     |   1 +
>   net/smc/Kconfig                                  |  13 +
>   net/smc/af_smc.c                                 | 203 ++++++++++---
>   net/smc/bpf_smc.c                                | 359 +++++++++++++++++++++++
>   net/smc/smc.h                                    | 224 --------------
>   tools/testing/selftests/bpf/prog_tests/bpf_smc.c | 107 +++++++
>   tools/testing/selftests/bpf/progs/bpf_smc.c      | 265 +++++++++++++++++
>   10 files changed, 1186 insertions(+), 259 deletions(-)
>   create mode 100644 net/smc/bpf_smc.c
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_smc.c
>   create mode 100644 tools/testing/selftests/bpf/progs/bpf_smc.c
>

