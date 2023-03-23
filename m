Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3D36C71CD
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 21:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbjCWUrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 16:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbjCWUq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 16:46:58 -0400
Received: from out-35.mta0.migadu.com (out-35.mta0.migadu.com [IPv6:2001:41d0:1004:224b::23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14DF19C6B
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 13:46:54 -0700 (PDT)
Message-ID: <366b9486-9a00-6add-d54b-5c3f4d35afe9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679604412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6+GSINJMGgmTxXNiTw2ylsqugVHlWlCO9tBE/Mc8vbA=;
        b=ini74+NpbGOtOqFBntZhuoiX0dFpv4Z89uAEvQtk6WH0aGrgfrX695wAumDN6qKza8Hs16
        7FzRFk8+knRwzixoC1qZAbZDU3aHc9vndZjRJ08hcjbvhfMF5qKx5rjETnW7VXBDE71SDa
        Lm7mNNQyFO+hyEewOCT3HakjkV3pvyU=
Date:   Thu, 23 Mar 2023 13:46:40 -0700
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v2 1/2] net/smc: Introduce BPF injection
 capability for SMC
Content-Language: en-US
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org, kgraul@linux.ibm.com, wenjia@linux.ibm.com,
        jaka@linux.ibm.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
References: <1676981919-64884-1-git-send-email-alibuda@linux.alibaba.com>
 <1676981919-64884-2-git-send-email-alibuda@linux.alibaba.com>
 <76e226e6-f3bf-f740-c86c-6ee214aff07d@linux.dev>
 <72030784-451a-2042-cbb7-98e1f9a544d5@linux.alibaba.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <72030784-451a-2042-cbb7-98e1f9a544d5@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/23 3:49 AM, D. Wythe wrote:
>>> --- /dev/null
>>> +++ b/net/smc/bpf_smc_struct_ops.c
>>> @@ -0,0 +1,146 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +
>>> +#include <linux/kernel.h>
>>> +#include <linux/bpf_verifier.h>
>>> +#include <linux/btf_ids.h>
>>> +#include <linux/bpf.h>
>>> +#include <linux/btf.h>
>>> +#include <net/sock.h>
>>> +#include <net/smc.h>
>>> +
>>> +extern struct bpf_struct_ops smc_sock_negotiator_ops;
>>> +
>>> +DEFINE_RWLOCK(smc_sock_negotiator_ops_rwlock);
>>> +struct smc_sock_negotiator_ops *negotiator;
>>
>> Is it sure one global negotiator (policy) will work for all smc_sock? or each 
>> sk should have its own negotiator and the negotiator is selected by setsockopt.
>>
> This is really a good question,  we can really consider adding an independent 
> negotiator for each sock.
> 
> But just like the TCP congestion control , the global negotiator can be used for 
> sock without
> 
> special requirements.

It is different from TCP congestion control (CC). TCP CC has a global default 
but each sk can select what tcp-cc to use and there can be multiple tcp-cc 
registered under different names.

It sounds like smc using tcp_sock should be able to have different negotiator 
also (eg. based on dst IP or some other tcp connection characteristic). The 
tcp-cc registration, per-sock selection and the rcu_read_lock+refcnt are well 
understood and there are other bpf infrastructure to support the per sock tcp-cc 
selection (like bpf_setsockopt).

For the network stack, there is little reason other af_* should not follow at 
the beginning considering the infrastructure has already been built. The one 
single global negotiator and reader/writer lock in this patch reads like an 
effort wanted to give it a try and see if it will be useful before implementing 
the whole thing. It is better to keep it off the tree for now until it is more 
ready.
