Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E942624384
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 14:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbiKJNrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 08:47:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiKJNrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 08:47:25 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB3761745;
        Thu, 10 Nov 2022 05:47:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=cBJxJE+HDCTGVW4nP1oD4Tm/AJ6zzyKfXe5KSUdkRHU=; b=b3JHN2a1QQU75g16Z74Sp/M/Yz
        UuqDodapwtpdTRz7TJnM3ZhX7omPmz5CDRs7zDKOPSoTIEzflGhG2RJpVCVGHQifiFhdogAJXY0nK
        j0IaCVtH8oqF8QIamwNYj/VtX8n9d+VacFYpzfao0O1A94ege3Vc/GShplMtBKes4KMo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ot7tf-0022JC-2O; Thu, 10 Nov 2022 14:47:11 +0100
Date:   Thu, 10 Nov 2022 14:47:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] rxrpc: Fix missing IPV6 #ifdef
Message-ID: <Y20A33ya17l/MqxU@lunn.ch>
References: <166807341463.2904467.10141806642379634063.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166807341463.2904467.10141806642379634063.stgit@warthog.procyon.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 09:43:34AM +0000, David Howells wrote:
> Fix rxrpc_encap_err_rcv() to make the call to ipv6_icmp_error conditional
> on IPV6 support being enabled.
> 
> Fixes: b6c66c4324e7 ("rxrpc: Use the core ICMP/ICMP6 parsers")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Marc Dionne <marc.dionne@auristor.com>
> cc: linux-afs@lists.infradead.org
> cc: netdev@vger.kernel.org
> ---
> 
>  net/rxrpc/local_object.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
> index a178f71e5082..25cdfcf7b415 100644
> --- a/net/rxrpc/local_object.c
> +++ b/net/rxrpc/local_object.c
> @@ -33,7 +33,9 @@ static void rxrpc_encap_err_rcv(struct sock *sk, struct sk_buff *skb, int err,
>  {
>  	if (ip_hdr(skb)->version == IPVERSION)
>  		return ip_icmp_error(sk, skb, err, port, info, payload);
> +#ifdef CONFIG_AF_RXRPC_IPV6
>  	return ipv6_icmp_error(sk, skb, err, port, info, payload);
> +#endif

Can this be if (IS_ENABLED(CONFIG_AF_RXRPC_IPV6) {} rather than
#ifdef? It gives better build testing.

	Andrew
