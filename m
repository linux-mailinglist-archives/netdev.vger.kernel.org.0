Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C1B222C65
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 21:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729554AbgGPT4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 15:56:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728907AbgGPT4T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 15:56:19 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3025F206F4;
        Thu, 16 Jul 2020 19:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594929378;
        bh=JjBPhIoa79Zma+LzMThTiFC14BwMYtBkouPOhNxhtDs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KBQ7ebVI5k5PqRkMBZ8oqhwqIDoLjLNOEjIGv/NdlIO/DRkwJpvWPrMui5ttCKmB9
         mN1r5WM/e6QJrT0mu++THqa9bXsgBtb1bTPcvRbJoe76bOx8TuR5LnuthcR5AZ+FV5
         VwgwJg57XyRURGq9cpkaq3iCwepHQbPIEN6/BaWQ=
Date:   Thu, 16 Jul 2020 12:56:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Richard Sailer <richard_siegfried@systemli.org>
Cc:     gerrit@erg.abdn.ac.uk, davem@davemloft.net, dccp@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4] net: dccp: Add SIOCOUTQ IOCTL support (send
 buffer fill)
Message-ID: <20200716125608.33a0589b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200712225520.269542-1-richard_siegfried@systemli.org>
References: <20200712225520.269542-1-richard_siegfried@systemli.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jul 2020 00:55:20 +0200 Richard Sailer wrote:
> This adds support for the SIOCOUTQ IOCTL to get the send buffer fill
> of a DCCP socket, like UDP and TCP sockets already have.
> 
> Regarding the used data field: DCCP uses per packet sequence numbers,
> not per byte, so sequence numbers can't be used like in TCP. sk_wmem_queued
> is not used by DCCP and always 0, even in test on highly congested paths.
> Therefore this uses sk_wmem_alloc like in UDP.
> 
> Signed-off-by: Richard Sailer <richard_siegfried@systemli.org>

Sorry for the late review

> diff --git a/Documentation/networking/dccp.rst b/Documentation/networking/dccp.rst
> index dde16be044562..74659da107f6b 100644
> --- a/Documentation/networking/dccp.rst
> +++ b/Documentation/networking/dccp.rst
> @@ -192,6 +192,8 @@ FIONREAD
>  	Works as in udp(7): returns in the ``int`` argument pointer the size of
>  	the next pending datagram in bytes, or 0 when no datagram is pending.
>  
> +SIOCOUTQ
> +  Returns the number of data bytes in the local send queue.

FIONREAD uses tabs for indentation, it seems like a good idea to
document the size of the argument (i.e. "returns in the ``int`` ...").

>  Other tunables
>  ==============
> diff --git a/net/dccp/proto.c b/net/dccp/proto.c
> index c13b6609474b6..dab74e8a8a69b 100644
> --- a/net/dccp/proto.c
> +++ b/net/dccp/proto.c
> @@ -375,6 +375,14 @@ int dccp_ioctl(struct sock *sk, int cmd, unsigned long arg)
>  		goto out;
>  
>  	switch (cmd) {
> +	case SIOCOUTQ: {
> +		/* Using sk_wmem_alloc here because sk_wmem_queued is not used by DCCP and
> +		 * always 0, comparably to UDP.
> +		 */
> +		int amount = sk_wmem_alloc_get(sk);
> +		rc = put_user(amount, (int __user *)arg);

checkpatch warns:

WARNING: Missing a blank line after declarations
#48: FILE: net/dccp/proto.c:383:
+		int amount = sk_wmem_alloc_get(sk);
+		rc = put_user(amount, (int __user *)arg);

Could you please address that, and better still move the declaration of
"int amount" up to the function level and avoid the funky bracket around
the case statement altogether?

> +	}
> +		break;
>  	case SIOCINQ: {
>  		struct sk_buff *skb;
>  		unsigned long amount = 0;

