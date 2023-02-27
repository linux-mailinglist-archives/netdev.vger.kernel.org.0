Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 233726A4A94
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 20:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbjB0TH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 14:07:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbjB0TH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 14:07:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B73618C;
        Mon, 27 Feb 2023 11:07:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCA90B80861;
        Mon, 27 Feb 2023 19:07:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193C2C433EF;
        Mon, 27 Feb 2023 19:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677524871;
        bh=Rb8avXpbAaWH6QXFNSR/fXEJx3QgA5sD+yXWUKWCfCo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pz1C5Cl96zEioaPAbnz7jvz1eHbPVStOvGs3vgjhByQ2azUIdcYUZrFVVXyJ8EZEh
         mUfwYlmqiAT9A4mxFZr6lPNTBa0By2B3NM85vCwLzifIIHp3i1BgB9WzWiBfoz4ZgO
         NteJ4tNqYtp2rkMbGInGWQPZ2Ah4ImpzRLTnzYViVjlhbCcg2CKmGzcm0t/mdVpbbS
         LF+gd14gK9I4hN4FiIhGSD5nuSt2e4dPDWfJz3H80SYam6KCI0p5MkcXpd0Cc7yLfq
         g9Owbog98S/dIt0ZwDgOXPxSzADtZLaqaqjxE5NLanTh6RXa/p2seWCkYDTReNAWmH
         DdOFSq77PifUQ==
Date:   Mon, 27 Feb 2023 11:07:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Florian Westphal <fw@strlen.de>, borisp@nvidia.com,
        john.fastabend@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, davejwatson@fb.com, aviadye@mellanox.com,
        ilyal@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: tls: fix possible race condition between
 do_tls_getsockopt_conf() and do_tls_setsockopt_conf()
Message-ID: <20230227110750.6988fca5@kernel.org>
In-Reply-To: <52faaa10-f3e4-bca9-4bff-6f1ea7d26593@gmail.com>
References: <20230224105811.27467-1-hbh25y@gmail.com>
        <20230224120606.GI26596@breakpoint.cc>
        <20230224105508.4892901f@kernel.org>
        <Y/kck0/+NB+Akpoy@hog>
        <20230224130625.6b5261b4@kernel.org>
        <Y/kwyS2n4uLn8eD0@hog>
        <20230224141740.63d5e503@kernel.org>
        <52faaa10-f3e4-bca9-4bff-6f1ea7d26593@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Feb 2023 11:26:18 +0800 Hangyu Hua wrote:
> In order to reduce ambiguity, I think it may be a good idea only to
> lock do_tls_getsockopt_conf() like we did in do_tls_setsockopt()
> 
> It will look like:
> 
> static int do_tls_getsockopt(struct sock *sk, int optname,
> 			     char __user *optval, int __user *optlen)
> {
> 	int rc = 0;
> 
> 	switch (optname) {
> 	case TLS_TX:
> 	case TLS_RX:
> +		lock_sock(sk);
> 		rc = do_tls_getsockopt_conf(sk, optval, optlen,
> 					    optname == TLS_TX);
> +		release_sock(sk);
> 		break;
> 	case TLS_TX_ZEROCOPY_RO:
> 		rc = do_tls_getsockopt_tx_zc(sk, optval, optlen);
> 		break;
> 	case TLS_RX_EXPECT_NO_PAD:
> 		rc = do_tls_getsockopt_no_pad(sk, optval, optlen);
> 		break;
> 	default:
> 		rc = -ENOPROTOOPT;
> 		break;
> 	}
> 	return rc;
> }
> 
> Of cause, I will clean the lock in do_tls_getsockopt_conf(). What do you
> guys think?

I'd suggest to take the lock around the entire switch statement.
