Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9BE19B67C
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 21:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732720AbgDATl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 15:41:26 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:26140 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732560AbgDATl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 15:41:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1585770082;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=A0+JzdAiPU3XNZx6W/Snqv56H9zh2dsABEt6Hx1ngMI=;
        b=i6kZyLrJBAUC8gMM7PqUCM5OEj8XYA8zfa8z8zxJBBnjoDOJ3Eg/694nVj8Xtz/OoQ
        3zmHhxMHCGXRIotF3xMB8X2T/ImTLhxk4bNhJkMHKC7vKOcGO4vWgh55ji1Q7b2uMb65
        n87+767woKAVr3cvOEEg9QfWA6bSJxKoqFY3u3x3I63UmEu5ub38k6v9BOjB45xbcIGz
        vARRHNza75SI+7uCp28oN/kUUzMKOwmBJPK+NWEanbOTmvfJ4PfKFElXK7L68ZUvVnUu
        4TcsQAbhZyCLs/MinT4Pdo1XZfw+GnfbRigFsLi5mqHbvlhNXVyAs/3DUF7S4H5ZOwXI
        zkRg==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMGX8h5lU+m"
X-RZG-CLASS-ID: mo00
Received: from [192.168.50.177]
        by smtp.strato.de (RZmta 46.2.1 DYNA|AUTH)
        with ESMTPSA id D07898w31JfEI2y
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 1 Apr 2020 21:41:14 +0200 (CEST)
Subject: Re: [PATCH v2] slcan: Don't transmit uninitialized stack data in
 padding
To:     Richard Palethorpe <rpalethorpe@suse.com>,
        linux-can@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>, netdev@vger.kernel.org,
        security@kernel.org, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net
References: <20200401100639.20199-1-rpalethorpe@suse.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <4ec16ff5-7126-ffa2-491f-520606a038a9@hartkopp.net>
Date:   Wed, 1 Apr 2020 21:41:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200401100639.20199-1-rpalethorpe@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 01/04/2020 12.06, Richard Palethorpe wrote:
> struct can_frame contains some padding which is not explicitly zeroed in
> slc_bump. This uninitialized data will then be transmitted if the stack
> initialization hardening feature is not enabled (CONFIG_INIT_STACK_ALL).
> 
> This commit just zeroes the whole struct including the padding.
> 
> Signed-off-by: Richard Palethorpe <rpalethorpe@suse.com>
> Fixes: a1044e36e457 ("can: add slcan driver for serial/USB-serial CAN adapters")
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Cc: linux-can@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: security@kernel.org
> Cc: wg@grandegger.com
> Cc: mkl@pengutronix.de
> Cc: davem@davemloft.net

Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>


> ---
> 
> V2: Reviewed by Kees and Fixes tag added.
> 
> As mentioned in V1; The following unfinished test can reproduce the bug:
> https://github.com/richiejp/ltp/blob/pty-slcan/testcases/kernel/pty/pty04.c
> 
> 
>   drivers/net/can/slcan.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
> index a3664281a33f..4dfa459ef5c7 100644
> --- a/drivers/net/can/slcan.c
> +++ b/drivers/net/can/slcan.c
> @@ -148,7 +148,7 @@ static void slc_bump(struct slcan *sl)
>   	u32 tmpid;
>   	char *cmd = sl->rbuff;
>   
> -	cf.can_id = 0;
> +	memset(&cf, 0, sizeof(cf));
>   
>   	switch (*cmd) {
>   	case 'r':
> @@ -187,8 +187,6 @@ static void slc_bump(struct slcan *sl)
>   	else
>   		return;
>   
> -	*(u64 *) (&cf.data) = 0; /* clear payload */
> -
>   	/* RTR frames may have a dlc > 0 but they never have any data bytes */
>   	if (!(cf.can_id & CAN_RTR_FLAG)) {
>   		for (i = 0; i < cf.can_dlc; i++) {
> 
