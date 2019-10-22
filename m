Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0297EE0737
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 17:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731729AbfJVPXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 11:23:03 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:60632 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731521AbfJVPXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 11:23:03 -0400
Received: from [167.98.27.226] (helo=[10.35.5.173])
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1iMvzx-0006GC-BV; Tue, 22 Oct 2019 16:23:01 +0100
Subject: Re: [PATCH] net: hwbm: if CONFIG_NET_HWBM unset, make stub functions
 static
To:     linux-kernel@lists.codethink.co.uk
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191022151818.21383-1-ben.dooks@codethink.co.uk>
From:   Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
Message-ID: <c2ba06f1-fabd-1edb-b75f-8f6e2c23c0ce@codethink.co.uk>
Date:   Tue, 22 Oct 2019 16:23:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191022151818.21383-1-ben.dooks@codethink.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/10/2019 16:18, Ben Dooks (Codethink) wrote:
> If CONFIG_NET_HWBM is not set, then these stub functions in
> <net/hwbm.h> should be declared static to avoid trying to
> export them from any driver that includes this.
> 
> Note, add __maybe_unused as the marvell mvneta.c driver will
> otherwise cause gcc warnings from these.

urgh, static inline was what I was actually searching for here.

> Fixes the following sparse warnings:
> 
> ./include/net/hwbm.h:24:6: warning: symbol 'hwbm_buf_free' was not declared. Should it be static?
> ./include/net/hwbm.h:25:5: warning: symbol 'hwbm_pool_refill' was not declared. Should it be static?
> ./include/net/hwbm.h:26:5: warning: symbol 'hwbm_pool_add' was not declared. Should it be static?
> 
> Signed-off-by: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>
> ---
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>   include/net/hwbm.h | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/hwbm.h b/include/net/hwbm.h
> index 81643cf8a1c4..cb5e6de8b7cd 100644
> --- a/include/net/hwbm.h
> +++ b/include/net/hwbm.h
> @@ -21,9 +21,9 @@ void hwbm_buf_free(struct hwbm_pool *bm_pool, void *buf);
>   int hwbm_pool_refill(struct hwbm_pool *bm_pool, gfp_t gfp);
>   int hwbm_pool_add(struct hwbm_pool *bm_pool, unsigned int buf_num);
>   #else
> -void hwbm_buf_free(struct hwbm_pool *bm_pool, void *buf) {}
> -int hwbm_pool_refill(struct hwbm_pool *bm_pool, gfp_t gfp) { return 0; }
> -int hwbm_pool_add(struct hwbm_pool *bm_pool, unsigned int buf_num)
> +static void __maybe_unused hwbm_buf_free(struct hwbm_pool *bm_pool, void *buf) {}
> +static int __maybe_unused hwbm_pool_refill(struct hwbm_pool *bm_pool, gfp_t gfp) { return 0; }
> +static int __maybe_unused hwbm_pool_add(struct hwbm_pool *bm_pool, unsigned int buf_num)
>   { return 0; }
>   #endif /* CONFIG_HWBM */
>   #endif /* _HWBM_H */
> 


-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius

https://www.codethink.co.uk/privacy.html
