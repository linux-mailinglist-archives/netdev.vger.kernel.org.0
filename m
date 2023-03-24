Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 601FB6C893B
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 00:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbjCXX2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 19:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbjCXX2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 19:28:05 -0400
Received: from out-24.mta0.migadu.com (out-24.mta0.migadu.com [91.218.175.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C76D1705
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 16:28:03 -0700 (PDT)
Message-ID: <fe3db636-2f89-3175-a605-2124b43ae4fa@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679700481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=znY78L98weuBiMgEonJQOPxggC8U4iELkUSqycl27gU=;
        b=VryzPjcKbZ2RosICjRNFYfs1mlJfvbCTcNbx5vDMSyHDIJDr+ksGwR1gd4N+wmsCo+Hshp
        aPfkCsYxzIIUcTfezg61qVf6AYVyKGvoo1V1YKQFPDXaWkDriTpzPq7GDO/sBEaomOckTk
        enbmAKhyDlSYgIbCvFOnPrN1ZHiTb6Y=
Date:   Fri, 24 Mar 2023 16:27:51 -0700
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
 <366b9486-9a00-6add-d54b-5c3f4d35afe9@linux.dev>
 <6b4728e0-dfb7-ec7b-630f-87ee42233fe8@linux.alibaba.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <6b4728e0-dfb7-ec7b-630f-87ee42233fe8@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/23/23 9:08 PM, D. Wythe wrote:
> 
> The latest design is that users can register a negotiator implementation indexed 
> by name, smc_sock can use bpf_setsockopt to specify
> whether a specific negotiation implementation is required via name. If there are 
> no settings, there will be no negotiators.
> 
> What do you think?

tbh, bpf_setsockopt is many steps away. It needs to begin with a syscall 
setsockopt first. There is little reason it can only be done with a bpf prog. 
and how does the user know which negotiator a smc sock is using? Currently, ss 
can learn the tcp-cc of a sk.

~~~~~~~~

If this effort is serious, the code quality has to be much improved. The obvious 
bug and unused variables make this set at most a RFC.

 From the bpf perspective, it is ok-ish to start with a global negotiator first 
and skip the setsockopt details for now. However, it needs to be have a name. 
The new link_update 
(https://lore.kernel.org/bpf/20230323032405.3735486-1-kuifeng@meta.com/) has to 
work also. The struct_ops is rcu reader safe, so leverage it whenever it can 
instead of the read/write lock. It is how struct_ops work for tcp, so try to 
stay consistent as much as possible in the networking stack.

> 
> In addition, I am very sorry that I have not issued my implementation for such a 
> long time, and I have encountered some problems with the implementation because
> the SMC needs to be built as kernel module, I have struggled with the 
> bpf_setsockopt implementation, and there are some new self-testes that need to 
> be written.
> 

Regarding compiling as module,

+ifneq ($(CONFIG_SMC),)
+ifeq ($(CONFIG_BPF_SYSCALL),y)
+obj-y				+= smc/bpf_smc_struct_ops.o
+endif

struct_ops does not support module now. It is on the todo list. The 
bpf_smc_struct_ops.o above can only be used when CONFIG_SMC=y. Otherwise, the 
bpf_smc_struct_ops is always built in while most users will never load the smc 
module.
