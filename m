Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52772C1683
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 21:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729470AbgKWUZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 15:25:43 -0500
Received: from smtprelay0097.hostedemail.com ([216.40.44.97]:34720 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728869AbgKWUZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 15:25:43 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 10236100E7B46;
        Mon, 23 Nov 2020 20:25:42 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:2892:2894:2902:3138:3139:3140:3141:3142:3352:3622:3865:3867:3870:3871:3872:4321:5007:9010:10004:10400:10848:11026:11232:11658:11914:12296:12297:12438:12740:12895:13069:13142:13149:13230:13311:13357:13439:13894:14659:14721:14777:21080:21433:21627:21939:30054:30075:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: cook74_371674827368
X-Filterd-Recvd-Size: 2017
Received: from XPS-9350.home (unknown [47.151.128.180])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Mon, 23 Nov 2020 20:25:40 +0000 (UTC)
Message-ID: <d0d1edf746b8f50ca8897478a5e76a006e5d36ed.camel@perches.com>
Subject: Re: [PATCH net-next 15/17] rxrpc: Organise connection security to
 use a union
From:   Joe Perches <joe@perches.com>
To:     David Howells <dhowells@redhat.com>, netdev@vger.kernel.org
Cc:     linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Mon, 23 Nov 2020 12:25:39 -0800
In-Reply-To: <160616230898.830164.7298470680786861832.stgit@warthog.procyon.org.uk>
References: <160616220405.830164.2239716599743995145.stgit@warthog.procyon.org.uk>
         <160616230898.830164.7298470680786861832.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-11-23 at 20:11 +0000, David Howells wrote:
> Organise the security information in the rxrpc_connection struct to use a
> union to allow for different data for different security classes.

Is there a known future purpose to this?

> diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h

> @@ -448,9 +448,15 @@ struct rxrpc_connection {
>  	struct list_head	proc_link;	/* link in procfs list */
>  	struct list_head	link;		/* link in master connection list */
>  	struct sk_buff_head	rx_queue;	/* received conn-level packets */
> +
>  	const struct rxrpc_security *security;	/* applied security module */
> -	struct crypto_sync_skcipher *cipher;	/* encryption handle */
> -	struct rxrpc_crypt	csum_iv;	/* packet checksum base */
> +	union {
> +		struct {
> +			struct crypto_sync_skcipher *cipher;	/* encryption handle */
> +			struct rxrpc_crypt csum_iv;	/* packet checksum base */
> +			u32	nonce;		/* response re-use preventer */
> +		} rxkad;
> +	};

It seems no other follow-on patch in the series uses this nameless union.

