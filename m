Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADE26A6F01
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 16:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbjCAPIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 10:08:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjCAPID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 10:08:03 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4AAFBB9A;
        Wed,  1 Mar 2023 07:08:01 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pXO3X-0002iJ-QW; Wed, 01 Mar 2023 16:07:47 +0100
Date:   Wed, 1 Mar 2023 16:07:47 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Madhu Koriginja <madhu.koriginja@nxp.com>
Cc:     gerrit@erg.abdn.ac.uk, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, edumazet@google.com, dccp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vani.namala@nxp.com
Subject: Re: [PATCH] [NETFILTER]: Keep conntrack reference until IPsecv6
 policy checks are done
Message-ID: <20230301150747.GB4691@breakpoint.cc>
References: <20230301145534.421569-1-madhu.koriginja@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301145534.421569-1-madhu.koriginja@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Madhu Koriginja <madhu.koriginja@nxp.com> wrote:
> Keep the conntrack reference until policy checks have been performed for
> IPsec V6 NAT support. The reference needs to be dropped before a packet is
> queued to avoid having the conntrack module unloadable.

In the old days there was no ipv6 nat so its not surpising
that ipv6 discards the conntrack entry earlier than ipv4.

> -		if (!(ipprot->flags & INET6_PROTO_NOPOLICY) &&
> -		    !xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb))
> -			goto discard;
> +
> +		if (!ipprot->flags & INET6_PROTO_NOPOLICY) {

This looks wrong, why did you drop the () ?

if (!(ipprot->flags & INET6_PROTO_NOPOLICY)) { ...

rest LGTM.
