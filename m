Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE5FA3E13FB
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 13:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241059AbhHELhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 07:37:16 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:53891 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240857AbhHELhO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 07:37:14 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GgRQx6y6Wz9sRR;
        Thu,  5 Aug 2021 21:36:57 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1628163418;
        bh=LUuDWZ6QjdYX5SUcL0rg4SU99LJt8O7kFIHfniH4Wkg=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=SF7x/1BvF/du6tR1e3AqhoEFXeAMJ23q3ppFOuDYEK6+ht3SZq2BGm0VpBTQhnKiX
         c69CtfwbXEyopOpWkMlhoaZaNy7MBcjvFgi441GQPs8JoNSbaypcrSiMU40xfYUL8t
         f9mZrC/0/S9Sd0Sks9Q6ztffcNH3z15sejK3Mrq6GIC9o5cgKjNUdNCU7s+JyZXP+k
         m7V2vyizjbFsWr3PDpb/VJj0/lHDkB5dWIo6L1vPnRk6HtSQ+cZceBM9r0fWUQuSIl
         t/rcwuCY/XD4brZ4tPPAIPKwBGgNhCg1BsOkubGmrACsiPv8a+bTpGKspwCElp7iAD
         /yfmCkkp5M+aw==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Kees Cook <keescook@chromium.org>, linux-hardening@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH 58/64] powerpc: Split memset() to avoid multi-field
 overflow
In-Reply-To: <20210727205855.411487-59-keescook@chromium.org>
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-59-keescook@chromium.org>
Date:   Thu, 05 Aug 2021 21:36:54 +1000
Message-ID: <87czqsnmw9.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memset(), avoid intentionally writing across
> neighboring fields.
>
> Instead of writing across a field boundary with memset(), move the call
> to just the array, and an explicit zeroing of the prior field.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/macintosh/smu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/macintosh/smu.c b/drivers/macintosh/smu.c
> index 94fb63a7b357..59ce431da7ef 100644
> --- a/drivers/macintosh/smu.c
> +++ b/drivers/macintosh/smu.c
> @@ -848,7 +848,8 @@ int smu_queue_i2c(struct smu_i2c_cmd *cmd)
>  	cmd->read = cmd->info.devaddr & 0x01;
>  	switch(cmd->info.type) {
>  	case SMU_I2C_TRANSFER_SIMPLE:
> -		memset(&cmd->info.sublen, 0, 4);
> +		cmd->info.sublen = 0;
> +		memset(&cmd->info.subaddr, 0, 3);
>  		break;
>  	case SMU_I2C_TRANSFER_COMBINED:
>  		cmd->info.devaddr &= 0xfe;
> -- 
> 2.30.2

Reviewed-by: Michael Ellerman <mpe@ellerman.id.au>

cheers
