Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47F7A575AA4
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 06:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiGOEvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 00:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiGOEvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 00:51:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F003CBEB;
        Thu, 14 Jul 2022 21:51:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E26A3CE2CEE;
        Fri, 15 Jul 2022 04:51:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9391BC34115;
        Fri, 15 Jul 2022 04:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657860694;
        bh=Af9C0NL6TD+xXm9orAnkB77YsWKypBG3sK4vEoC9kW0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZdztIuUrlbvC0dOuF5rDL57Qn8mNsgzdPbhAKyhTcRdATe1MiX+yEynS/cO0T/wce
         DTJbK8ZexL9CzoYJvziQe5R43+qyYLGTyYuNRIfBHBskAIHOoL9vKTJT15H1pBZLsY
         QKBEUVoeuUDpKPe0sU14jPDvEGcNm6taCocjOMbXFUmQLl7kL9G0dNLEKsHqwcYMpZ
         vaM977uU2BI+96CVr6Ty6ZbmEtUmLJBoCBPr7xCfLQn5ElYA2Ew2qG6J6qaL80gtYL
         CgPdl/CTqvgfqWcaneI3/LsdaPbf9cgGIuafowIyIK06FgvsVyVQTPAfmrun0EluHc
         S8bHU39Yr7hyg==
Date:   Thu, 14 Jul 2022 21:51:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mathias Lark <mathiaslark@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        pabeni@redhat.com, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH net-next] improve handling of ICMP_EXT_ECHO icmp type
Message-ID: <20220714215132.058a1d4e@kernel.org>
In-Reply-To: <20220714151358.GA16615@debian>
References: <20220714151358.GA16615@debian>
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

On Thu, 14 Jul 2022 17:13:58 +0200 Mathias Lark wrote:
> Introduce a helper for icmp type checking - icmp_is_valid_type.
> 
> There is a number of code paths handling ICMP packets. To check
> icmp type validity, some of those code paths perform the check
> `type <= NR_ICMP_TYPES`. Since the introduction of ICMP_EXT_ECHO
> and ICMP_EXT_ECHOREPLY (RFC 8335), this check is no longer correct.
> 
> To fix this inconsistency and avoid further problems with future
> ICMP types, the patch inserts the icmp_is_valid_type helper
> wherever it is required.

Would be good to note in the commit message why we can't bump
NR_ICMP_TYPES to include all the types. What are the types between 
18 and 42?

> diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
> index 163c0998aec9..ad736a24f0c8 100644
> --- a/include/uapi/linux/icmp.h
> +++ b/include/uapi/linux/icmp.h
> @@ -159,4 +159,9 @@ struct icmp_ext_echo_iio {
>  		} addr;
>  	} ident;
>  };
> +
> +static inline bool icmp_is_valid_type(__u8 type)
> +{
> +	return type <= NR_ICMP_TYPES || type == ICMP_EXT_ECHO || type == ICMP_EXT_ECHOREPLY;
> +}

This doesn't look related to uAPI, include/linux/icmp.h or
include/net/icmp.h seems like a better place for it.
