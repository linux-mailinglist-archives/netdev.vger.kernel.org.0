Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34F0C538813
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 22:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241012AbiE3UNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 16:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235259AbiE3UNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 16:13:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3006CE25;
        Mon, 30 May 2022 13:13:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE38AB80ED2;
        Mon, 30 May 2022 20:13:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC01C385B8;
        Mon, 30 May 2022 20:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653941593;
        bh=IyPskumtuU2sLSwhSBmkDFek1VnDLMcF+obJ0NF+o/U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=D2Tz2KPPrsUmuqH5STuOqut8buTDr6ggZPNJ1cIfSfdoTeSLizUOgTtEYrNO/Has0
         AACyHIYhh02gas1nLyAiF6Zl8JswNzGvjO4o1xNGmC7u4jVHxAj6byUnNhmlX5pheE
         l13c9t+OFMZ9w2F4+zGO5aHbKli2cwl4qnW5Kts3Hm7dL4yI6pBqCUerBkOhNklxBB
         84qBsAH4XkZQmrUIsluCDOIPc2d0K2ZTcsW7CuvkbW0zsuq2IBm3VNU0dsaWYXsUfO
         8WsVuQrfq406hbfK8SCDp2uf8c8rww2uVrFfCMDPajPcdr7SLsmRM1zNFfNYUW7yj4
         zn73vYpJoSx3w==
Date:   Mon, 30 May 2022 13:13:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, nhorman@tuxdriver.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        imagedong@tencent.com, dsahern@kernel.org, talalahmad@google.com,
        keescook@chromium.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/3] net: skb: use auto-generation to
 convert skb drop reason to string
Message-ID: <20220530131311.40914ab7@kernel.org>
In-Reply-To: <20220530081201.10151-3-imagedong@tencent.com>
References: <20220530081201.10151-1-imagedong@tencent.com>
        <20220530081201.10151-3-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 May 2022 16:12:00 +0800 menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> It is annoying to add new skb drop reasons to 'enum skb_drop_reason'
> and TRACE_SKB_DROP_REASON in trace/event/skb.h, and it's easy to forget
> to add the new reasons we added to TRACE_SKB_DROP_REASON.
> 
> TRACE_SKB_DROP_REASON is used to convert drop reason of type number
> to string. For now, the string we passed to user space is exactly the
> same as the name in 'enum skb_drop_reason' with a 'SKB_DROP_REASON_'
> prefix. Therefore, we can use 'auto-generation' to generate these
> drop reasons to string at build time.
> 
> The new header 'dropreason_str.h'

Not any more.

> will be generated, and the
> __DEFINE_SKB_DROP_REASON() in it can do the converting job. Meanwhile,
> we use a global array to store these string, which can be used both
> in drop_monitor and 'kfree_skb' tracepoint.

> diff --git a/include/net/dropreason.h b/include/net/dropreason.h
> index ecd18b7b1364..460de425297c 100644
> --- a/include/net/dropreason.h
> +++ b/include/net/dropreason.h
> @@ -3,6 +3,8 @@
>  #ifndef _LINUX_DROPREASON_H
>  #define _LINUX_DROPREASON_H
>  
> +#include <linux/kernel.h>

Why?

> +dropreason_str.c
> \ No newline at end of file

Heed the warning.

> diff --git a/net/core/Makefile b/net/core/Makefile
> index a8e4f737692b..3c7f99ff6d89 100644
> --- a/net/core/Makefile
> +++ b/net/core/Makefile
> @@ -4,7 +4,8 @@
>  #
>  
>  obj-y := sock.o request_sock.o skbuff.o datagram.o stream.o scm.o \
> -	 gen_stats.o gen_estimator.o net_namespace.o secure_seq.o flow_dissector.o
> +	 gen_stats.o gen_estimator.o net_namespace.o secure_seq.o \
> +	 flow_dissector.o dropreason_str.o
>  
>  obj-$(CONFIG_SYSCTL) += sysctl_net_core.o
>  
> @@ -39,3 +40,23 @@ obj-$(CONFIG_NET_SOCK_MSG) += skmsg.o
>  obj-$(CONFIG_BPF_SYSCALL) += sock_map.o
>  obj-$(CONFIG_BPF_SYSCALL) += bpf_sk_storage.o
>  obj-$(CONFIG_OF)	+= of_net.o
> +
> +clean-files := dropreason_str.c
> +
> +quiet_cmd_dropreason_str = GEN     $@
> +cmd_dropreason_str = awk -F ',' 'BEGIN{ print "\#include <net/dropreason.h>\n"; \
> +	print "const char * const drop_reasons[] = {" }\
> +	/^enum skb_drop/ { dr=1; }\
> +	/\}\;/ { dr=0; }\
> +	/^\tSKB_DROP_REASON_/ {\
> +		if (dr) {\
> +			sub(/\tSKB_DROP_REASON_/, "", $$1);\
> +			printf "\t[SKB_DROP_REASON_%s] = \"%s\",\n", $$1, $$1;\
> +		}\
> +	} \
> +	END{ print "};\nEXPORT_SYMBOL(drop_reasons);" }' $< > $@
> +
> +$(obj)/dropreason_str.c: $(srctree)/include/net/dropreason.h
> +	$(call cmd,dropreason_str)

I'm getting this:

  awk: cmd. line:1: warning: regexp escape sequence `\;' is not a known regexp operator

