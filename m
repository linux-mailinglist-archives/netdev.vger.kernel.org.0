Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237E22B55E0
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 01:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730260AbgKQAy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 19:54:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:53568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726321AbgKQAy4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 19:54:56 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FD682467B;
        Tue, 17 Nov 2020 00:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605574495;
        bh=hLfTkfBEj9aBJibsqGAwR3SngfgwIHGSRn9tMbLwc4w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eF8kdeDxuG0e56alc+W87sp8QVH3nsC521ey+GUgYMYa+RVQytM3xH77D6Jug5Gnf
         OtEnQUY4a8re4jAYF5EEDVRkooDTsHYRL0MXR2MyvXwFqBVafJEUjf3R+FtGLMQ8b0
         ryrUJqyIwtO3pk+rwRm40uEz0QOvYYDROsrGE4Y0=
Date:   Mon, 16 Nov 2020 16:54:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>, netdev@vger.kernel.org
Subject: Re: [net v2] net/tls: fix corrupted data in recvmsg
Message-ID: <20201116165454.5b5dd864@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cd2f4bfe-8fff-ddab-d271-08f0917a5b48@novek.ru>
References: <1605413760-21153-1-git-send-email-vfedorenko@novek.ru>
        <20201116162608.2c54953e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <cd2f4bfe-8fff-ddab-d271-08f0917a5b48@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 00:45:11 +0000 Vadim Fedorenko wrote:
> On 17.11.2020 00:26, Jakub Kicinski wrote:
> > On Sun, 15 Nov 2020 07:16:00 +0300 Vadim Fedorenko wrote:  
> >> If tcp socket has more data than Encrypted Handshake Message then
> >> tls_sw_recvmsg will try to decrypt next record instead of returning
> >> full control message to userspace as mentioned in comment. The next
> >> message - usually Application Data - gets corrupted because it uses
> >> zero copy for decryption that's why the data is not stored in skb
> >> for next iteration. Revert check to not decrypt next record if
> >> current is not Application Data.
> >>
> >> Fixes: 692d7b5d1f91 ("tls: Fix recvmsg() to be able to peek across multiple records")
> >> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
> >> ---
> >>   net/tls/tls_sw.c | 2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> >> index 95ab5545..2fe9e2c 100644
> >> --- a/net/tls/tls_sw.c
> >> +++ b/net/tls/tls_sw.c
> >> @@ -1913,7 +1913,7 @@ int tls_sw_recvmsg(struct sock *sk,
> >>   			 * another message type
> >>   			 */
> >>   			msg->msg_flags |= MSG_EOR;
> >> -			if (ctx->control != TLS_RECORD_TYPE_DATA)
> >> +			if (control != TLS_RECORD_TYPE_DATA)  
> > Sorry I wasn't clear enough, should this be:
> >
> > 	if (ctx->control != control)
> >
> > ? Otherwise if we get a control record first and then data record
> > the code will collapse them, which isn't correct, right?
> >  
> >>   				goto recv_end;
> >>   		} else {
> >>   			break;
> I think you mean when ctx->control is control record and control is
> data record. 

Yup.

> In this case control message will be decrypted without
> zero copy and will be stored in skb for the next recvmsg, but will
> not be returned together with data message.

Could you point me to a line which breaks the loop in that case?

> This behavior is the same
> as for TLSv1.3 when record type is known only after decrypting.
> But if we want completely different flow for TLSv1.2 and TLSv1.3
> then changing to check difference in message types makes sense.

