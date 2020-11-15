Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F942B31F5
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 03:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgKOCMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 21:12:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:51926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgKOCMu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 21:12:50 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6682E24137;
        Sun, 15 Nov 2020 02:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605406370;
        bh=o5ngBiHSCcL5D0IjIRLA3P9XVTnZOeTMfBnit/jDwtI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VFaKglcAj9SHYOM54ZVSRFVUv95FL70/uA23C90lqjo0IsbgtzTWLVCebjao3FMAP
         8iPS33dYzOA3S+4d0djw2kPekPPe59e8gkqOeZl3x8vjT3qeobSw7iJfj42es1vfzn
         GtpTD/zgnjAewGE2xFvEPQ21gbk8S9hpoGihd9bc=
Date:   Sat, 14 Nov 2020 18:12:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>, netdev@vger.kernel.org
Subject: Re: [net] net/tls: fix corrupted data in recvmsg
Message-ID: <20201114181249.4fab54d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1605326982-2487-1-git-send-email-vfedorenko@novek.ru>
References: <1605326982-2487-1-git-send-email-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 Nov 2020 07:09:42 +0300 Vadim Fedorenko wrote:
> If tcp socket has more data than Encrypted Handshake Message then
> tls_sw_recvmsg will try to decrypt next record instead of returning
> full control message to userspace as mentioned in comment. The next
> message - usually Application Data - gets corrupted because it uses
> zero copy for decryption that's why the data is not stored in skb
> for next iteration. Disable zero copy for this case.
> 
> Fixes: 692d7b5d1f91 ("tls: Fix recvmsg() to be able to peek across multiple records")
> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>

Do you have some BPF in the mix?

I don't see how we would try to go past a non-data record otherwise, 
since the loop ends like this:

		if (tls_sw_advance_skb(sk, skb, chunk)) {
			/* Return full control message to
			 * userspace before trying to parse
			 * another message type
			 */
			msg->msg_flags |= MSG_EOR;
			if (ctx->control != TLS_RECORD_TYPE_DATA)
				goto recv_end;
		} else {
			break;
		}
