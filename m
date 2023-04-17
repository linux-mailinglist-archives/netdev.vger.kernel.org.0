Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 602D86E472B
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbjDQMKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbjDQMKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:10:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855FB269E
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 05:09:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47FCC61CAC
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 12:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473DCC433D2;
        Mon, 17 Apr 2023 12:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681733380;
        bh=hKYkSpvhATstDaFtEHuCRj8Qj7ipW25dMadGs/JlFgE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kLwOJM82xZajMYhCEkoP1f85BSzadUN/2728UXME5sR9+cCwbg8o11KCPCTQ9Q1eD
         H/n4tcBSJIW9H+oyVAUTD4cuRrPBx3K4J3C3RVU0doi3g8AF910mpmUTKLYonLPOYT
         QviqaQzVDRGkXUrAfGzLqhM7bOyRwbbCHy+l8Vqcf1xbUEL0q/HjPrkDzn5SVkQKn9
         m+LLjbTCduMq43Jf/KnV8zE9s7CMOtWIWVW5SOhgFuAMmD+6TYBNtd3pokZZp5fExx
         tRl4+v/FVQjNtkD+27K7kivDja7zC64rLpEXI6Qn0wOhSAKdFQ66v/YEpMd2d6Ns/n
         JOj+vPt59IIIg==
Date:   Mon, 17 Apr 2023 14:09:36 +0200
From:   Simon Horman <horms@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, pablo@netfilter.org, fw@strlen.de
Subject: Re: [PATCH net-next 5/5] net: skbuff: hide nf_trace and ipvs_property
Message-ID: <ZD03APYJqdhflYNJ@kernel.org>
References: <20230414160105.172125-1-kuba@kernel.org>
 <20230414160105.172125-6-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414160105.172125-6-kuba@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 14, 2023 at 09:01:05AM -0700, Jakub Kicinski wrote:
> Accesses to nf_trace and ipvs_property are already wrapped
> by ifdefs where necessary. Don't allocate the bits for those
> fields at all if possible.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

FWIIW, I'm fine with this, modulo the module handling
discussed elsewhere in this thread.

Acked-by: Simon Horman <horms@kernel.org>

> ---
> CC: pablo@netfilter.org
> CC: fw@strlen.de
> ---
>  include/linux/skbuff.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 543f7ae9f09f..7b43d5a03613 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -966,8 +966,12 @@ struct sk_buff {
>  	__u8			ndisc_nodetype:2;
>  #endif
>  
> +#if IS_ENABLED(CONFIG_IP_VS)
>  	__u8			ipvs_property:1;
> +#endif
> +#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || defined(CONFIG_NF_TABLES)
>  	__u8			nf_trace:1;
> +#endif
>  #ifdef CONFIG_NET_SWITCHDEV
>  	__u8			offload_fwd_mark:1;
>  	__u8			offload_l3_fwd_mark:1;
> -- 
> 2.39.2
> 
