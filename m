Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D16A86603D4
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 17:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233983AbjAFQAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 11:00:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233358AbjAFQA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 11:00:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A564643E7C;
        Fri,  6 Jan 2023 08:00:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5ABF6B81DC4;
        Fri,  6 Jan 2023 16:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB5FC433EF;
        Fri,  6 Jan 2023 16:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673020822;
        bh=RQ9/DSHPqkUIWMwP6Ei9ZryCNoPhLA/Cjadj71jF/k0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AEtuigL93tsRhNpPKEMAWpFvGs1H9i/eb5or5fD2Wb0CHaP0anA8STL5JRxGbmuj9
         Jzx3z9IO7dNd+9Q6FCtdj3Z0NDzN8/h1VFNtEPUalRkC18V7Utv0GDO48Jgcr29r4l
         m5WOMs14rOnacYnipLSFWB7mYJy/XKQB7mdJTs8Wnk2Oo9Xj2+JWCLaj5rOZfsvtzP
         0iRTLYsSwK9O6tA7OMtGHVfQsXnqDcpI7fIMuo/mCg0Cgo3IOins5kfpu7NIvnJ6Hi
         7OsQ2TXltMca10qMcyZQMhJFx+Bb+XrNFHZOggM3fAncgCfpRCY/mMj3A3j+ljIEpJ
         sAXii3Wf/edcg==
Date:   Fri, 6 Jan 2023 10:00:26 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] net: ipv6: rpl_iptunnel: Replace 0-length arrays with
 flexible arrays
Message-ID: <Y7hFmjlUoyFOv6gB@work>
References: <20230105221533.never.711-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105221533.never.711-kees@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 02:15:37PM -0800, Kees Cook wrote:
> Zero-length arrays are deprecated[1]. Replace struct ipv6_rpl_sr_hdr's
> "segments" union of 0-length arrays with flexible arrays. Detected with
> GCC 13, using -fstrict-flex-arrays=3:
> 
> In function 'rpl_validate_srh',
>     inlined from 'rpl_build_state' at ../net/ipv6/rpl_iptunnel.c:96:7:
> ../net/ipv6/rpl_iptunnel.c:60:28: warning: array subscript <unknown> is outside array bounds of 'struct in6_addr[0]' [-Warray-bounds=]
>    60 |         if (ipv6_addr_type(&srh->rpl_segaddr[srh->segments_left - 1]) &
>       |                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from ../include/net/rpl.h:12,
>                  from ../net/ipv6/rpl_iptunnel.c:13:
> ../include/uapi/linux/rpl.h: In function 'rpl_build_state':
> ../include/uapi/linux/rpl.h:40:33: note: while referencing 'addr'
>    40 |                 struct in6_addr addr[0];
>       |                                 ^~~~
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks!
--
Gustavo

> ---
>  include/uapi/linux/rpl.h | 4 ++--
>  net/ipv6/rpl_iptunnel.c  | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/uapi/linux/rpl.h b/include/uapi/linux/rpl.h
> index 708adddf9f13..7c8970e5b84b 100644
> --- a/include/uapi/linux/rpl.h
> +++ b/include/uapi/linux/rpl.h
> @@ -37,8 +37,8 @@ struct ipv6_rpl_sr_hdr {
>  #endif
>  
>  	union {
> -		struct in6_addr addr[0];
> -		__u8 data[0];
> +		__DECLARE_FLEX_ARRAY(struct in6_addr, addr);
> +		__DECLARE_FLEX_ARRAY(__u8, data);
>  	} segments;
>  } __attribute__((packed));
>  
> diff --git a/net/ipv6/rpl_iptunnel.c b/net/ipv6/rpl_iptunnel.c
> index ff691d9f4a04..b1c028df686e 100644
> --- a/net/ipv6/rpl_iptunnel.c
> +++ b/net/ipv6/rpl_iptunnel.c
> @@ -13,7 +13,7 @@
>  #include <net/rpl.h>
>  
>  struct rpl_iptunnel_encap {
> -	struct ipv6_rpl_sr_hdr srh[0];
> +	DECLARE_FLEX_ARRAY(struct ipv6_rpl_sr_hdr, srh);
>  };
>  
>  struct rpl_lwt {
> -- 
> 2.34.1
> 
