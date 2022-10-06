Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC70B5F6EAD
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 22:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbiJFUKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 16:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiJFUKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 16:10:40 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9AEC5113;
        Thu,  6 Oct 2022 13:10:38 -0700 (PDT)
Message-ID: <46cabc2c-fc7f-5699-dfcb-b8be686ed200@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1665087036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g6gk48mvXQ95YsrgOtXV0sHQYUk+lFg3Q3bAUyptH3k=;
        b=QI1d/g0UQuayPTlJUmSkjYO8EsCTVHkGFvotUUC68p8MfhRr5iAKDEnFSnf4HWDvEQqCXA
        rojVNkFU1yfdxHS8Msx0dYMy7Enn0sepCPmK1k/9IhxCOeUMHs5ag003cqpQgh7We4aVBh
        qlSiGWi+1QSzXcqzJQVHS3mDKa9k7p4=
Date:   Thu, 6 Oct 2022 13:10:32 -0700
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next 02/10] bpf: Implement BPF link handling for tc
 BPF programs
Content-Language: en-US
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     razor@blackwall.org, ast@kernel.org, andrii@kernel.org,
        john.fastabend@gmail.com, joannelkoong@gmail.com, memxor@gmail.com,
        toke@redhat.com, joe@cilium.io, netdev@vger.kernel.org,
        bpf <bpf@vger.kernel.org>
References: <20221004231143.19190-1-daniel@iogearbox.net>
 <20221004231143.19190-3-daniel@iogearbox.net>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20221004231143.19190-3-daniel@iogearbox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/4/22 4:11 PM, Daniel Borkmann wrote:
>   static int __xtc_prog_detach(struct net_device *dev, bool ingress, u32 limit,
> -			     u32 prio)
> +			     u32 id, u32 prio)
>   {
>   	struct bpf_prog_array_item *item, *tmp;
>   	struct bpf_prog *oprog, *fprog = NULL;
> @@ -126,8 +133,11 @@ static int __xtc_prog_detach(struct net_device *dev, bool ingress, u32 limit,
>   		if (item->bpf_priority != prio) {
>   			tmp->prog = oprog;
>   			tmp->bpf_priority = item->bpf_priority;
> +			tmp->bpf_id = item->bpf_id;
>   			j++;
>   		} else {
> +			if (item->bpf_id != id)
> +				return -EBUSY;

A nit.  Should this be -ENOENT?  I think the cgroup detach is also returning 
-ENOENT for the not found case.

btw, this case should only happen from the BPF_PROG_DETACH but not the 
BPF_LINK_DETACH?


