Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F62A2B55B0
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 01:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731033AbgKQA0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 19:26:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:46064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728553AbgKQA0J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 19:26:09 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7071F24677;
        Tue, 17 Nov 2020 00:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605572769;
        bh=0LbkxFyBPJHMV8Xp70IDICjD16ULCVGfNe3VmL1GW1I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kiWrXsMxu5s48zWgygx+Y0BQwtXeKPqNiKdLoktJ19a2h9g4xt32CsQXx95P/5Fg3
         2qlgezFylHIgBbYgShkdkJbPOrOL+gUupqwFgT5e0lNk2V3kCQgs6Z2B54KEDfViin
         uq5buTaYatYgNCec2ghNXP6IZwPl7bTZKptWhZKY=
Date:   Mon, 16 Nov 2020 16:26:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>, netdev@vger.kernel.org
Subject: Re: [net v2] net/tls: fix corrupted data in recvmsg
Message-ID: <20201116162608.2c54953e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1605413760-21153-1-git-send-email-vfedorenko@novek.ru>
References: <1605413760-21153-1-git-send-email-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 15 Nov 2020 07:16:00 +0300 Vadim Fedorenko wrote:
> If tcp socket has more data than Encrypted Handshake Message then
> tls_sw_recvmsg will try to decrypt next record instead of returning
> full control message to userspace as mentioned in comment. The next
> message - usually Application Data - gets corrupted because it uses
> zero copy for decryption that's why the data is not stored in skb
> for next iteration. Revert check to not decrypt next record if
> current is not Application Data.
> 
> Fixes: 692d7b5d1f91 ("tls: Fix recvmsg() to be able to peek across multiple records")
> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
> ---
>  net/tls/tls_sw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index 95ab5545..2fe9e2c 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -1913,7 +1913,7 @@ int tls_sw_recvmsg(struct sock *sk,
>  			 * another message type
>  			 */
>  			msg->msg_flags |= MSG_EOR;
> -			if (ctx->control != TLS_RECORD_TYPE_DATA)
> +			if (control != TLS_RECORD_TYPE_DATA)

Sorry I wasn't clear enough, should this be:

	if (ctx->control != control)

? Otherwise if we get a control record first and then data record
the code will collapse them, which isn't correct, right?

>  				goto recv_end;
>  		} else {
>  			break;

