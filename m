Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A17BA6603DA
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 17:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234237AbjAFQDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 11:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbjAFQD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 11:03:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C663687A9;
        Fri,  6 Jan 2023 08:03:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4930DB81CDC;
        Fri,  6 Jan 2023 16:03:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E2CC433D2;
        Fri,  6 Jan 2023 16:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673021002;
        bh=4SszgloLESJ9Z/oK4FE1YKuoW/GK96FBWkUuAnmvgLQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qzWxQcfJNUp5m9I7Ji/7kTT8W6fKWhXGKUoxWK2wy7GU1g7bi/gFJJMviU/QzPDTx
         FHzRvCmfh/QDbeWwGE497oDvmMs7WR47xTiCmWF7w5Z6LnMrkqASEusXKG2/JThbng
         y9uU3c6NtrBBRoZ3zwkS5bOqGGhyx+F27pdgIgoemW9s14k4b5ryw48DOW067uvnbZ
         oYkNDV9E5X2qq/Uv/Ozgsl6SW8vwNN8/hfyQBHiMb1TRXGsj9wt8r9sKUSWlLhRQI0
         Uy78KccldBm4xAjotlaJmicEVJWu9kh2tFlUYYeJcac3ErnoPoIX4pVuk9p+A5nHdA
         2EGzqKnchCxTA==
Date:   Fri, 6 Jan 2023 10:03:27 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Justin Iurman <justin.iurman@uliege.be>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] ipv6: ioam: Replace 0-length array with flexible array
Message-ID: <Y7hGT/KFR7aPHvxs@work>
References: <20230105222115.never.661-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105222115.never.661-kees@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 02:21:16PM -0800, Kees Cook wrote:
> Zero-length arrays are deprecated[1]. Replace struct ioam6_trace_hdr's
> "data" 0-length array with a flexible array. Detected with GCC 13,
> using -fstrict-flex-arrays=3:
> 
> net/ipv6/ioam6_iptunnel.c: In function 'ioam6_build_state':
> net/ipv6/ioam6_iptunnel.c:194:37: warning: array subscript <unknown> is outside array bounds of '__u8[0]' {aka 'unsigned char[]'} [-Warray-bounds=]
>   194 |                 tuninfo->traceh.data[trace->remlen * 4] = IPV6_TLV_PADN;
>       |                 ~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~
> In file included from include/linux/ioam6.h:11,
>                  from net/ipv6/ioam6_iptunnel.c:13:
> include/uapi/linux/ioam6.h:130:17: note: while referencing 'data'
>   130 |         __u8    data[0];
>       |                 ^~~~
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Justin Iurman <justin.iurman@uliege.be>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks!
--
Gustavo

> ---
>  include/uapi/linux/ioam6.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/ioam6.h b/include/uapi/linux/ioam6.h
> index ac4de376f0ce..8f72b24fefb3 100644
> --- a/include/uapi/linux/ioam6.h
> +++ b/include/uapi/linux/ioam6.h
> @@ -127,7 +127,7 @@ struct ioam6_trace_hdr {
>  #endif
>  
>  #define IOAM6_TRACE_DATA_SIZE_MAX 244
> -	__u8	data[0];
> +	__u8	data[];
>  } __attribute__((packed));
>  
>  #endif /* _UAPI_LINUX_IOAM6_H */
> -- 
> 2.34.1
> 
