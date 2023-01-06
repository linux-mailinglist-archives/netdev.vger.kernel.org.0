Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB09566085E
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 21:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbjAFUi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 15:38:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjAFUiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 15:38:55 -0500
X-Greylist: delayed 600 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 06 Jan 2023 12:38:51 PST
Received: from serv108.segi.ulg.ac.be (serv108.segi.ulg.ac.be [139.165.32.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BEA2251;
        Fri,  6 Jan 2023 12:38:51 -0800 (PST)
Received: from [192.168.1.62] (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 1FCC4200BE50;
        Fri,  6 Jan 2023 21:22:33 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 1FCC4200BE50
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1673036553;
        bh=DzZXaI2F3PxJ1yWmLU6YlUJRSqMBGp/rQrznnrUv5ko=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Ue2GLTWCQtr/2NKwd/fZ7CR5+QCW4RWwt1azUgVAMcIbd5PuBCKbxTSpx6HF3i1Oi
         ZHgjyWiZDfOW6l980Yv2hEOCctKaSxK/y4nMPxHTludZ1Qa6ElLaCom3TQ5rqLFup2
         zq57Qk4COiTRiiZtPiBU9xg8SpVOcpLuwBpac5NoMh732R79w3e0pLR/vwjAZYWh5S
         9KS7W4XMueEfWNeHqSSVPj/VxWr5feTZcuI5tq1nUEwdh9vJEOab7Jss+WhmbCOtwt
         sby1xUjxBYCiXUgmKfFTstZ6viGN/brqRl1rkTwWt3wqJ59SjP9qiR7idDTMa/LaIU
         BWflpoHSBn+Lw==
Message-ID: <dcaeadb0-f08b-56e3-e8ae-f86bda7570a6@uliege.be>
Date:   Fri, 6 Jan 2023 21:22:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] ipv6: ioam: Replace 0-length array with flexible array
Content-Language: en-US
To:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20230105222115.never.661-kees@kernel.org>
From:   Justin Iurman <justin.iurman@uliege.be>
In-Reply-To: <20230105222115.never.661-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/23 23:21, Kees Cook wrote:
> Zero-length arrays are deprecated[1]. Replace struct ioam6_trace_hdr's
> "data" 0-length array with a flexible array. Detected with GCC 13,
> using -fstrict-flex-arrays=3:
> 
> net/ipv6/ioam6_iptunnel.c: In function 'ioam6_build_state':
> net/ipv6/ioam6_iptunnel.c:194:37: warning: array subscript <unknown> is outside array bounds of '__u8[0]' {aka 'unsigned char[]'} [-Warray-bounds=]
>    194 |                 tuninfo->traceh.data[trace->remlen * 4] = IPV6_TLV_PADN;
>        |                 ~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~
> In file included from include/linux/ioam6.h:11,
>                   from net/ipv6/ioam6_iptunnel.c:13:
> include/uapi/linux/ioam6.h:130:17: note: while referencing 'data'
>    130 |         __u8    data[0];
>        |                 ^~~~
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

Reviewed-by: Justin Iurman <justin.iurman@uliege.be>
Tested-by: Justin Iurman <justin.iurman@uliege.be>

LGTM, thanks.

> ---
>   include/uapi/linux/ioam6.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/ioam6.h b/include/uapi/linux/ioam6.h
> index ac4de376f0ce..8f72b24fefb3 100644
> --- a/include/uapi/linux/ioam6.h
> +++ b/include/uapi/linux/ioam6.h
> @@ -127,7 +127,7 @@ struct ioam6_trace_hdr {
>   #endif
>   
>   #define IOAM6_TRACE_DATA_SIZE_MAX 244
> -	__u8	data[0];
> +	__u8	data[];
>   } __attribute__((packed));
>   
>   #endif /* _UAPI_LINUX_IOAM6_H */
