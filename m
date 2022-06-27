Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C2555E12C
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236186AbiF0RWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 13:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234714AbiF0RWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 13:22:09 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 907CBE083;
        Mon, 27 Jun 2022 10:22:08 -0700 (PDT)
Date:   Mon, 27 Jun 2022 19:22:05 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Wei Han <lailitty@foxmail.com>
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: xt_esp: add support for ESP match in NAT
 Traversal
Message-ID: <YrnnPV8rPz+s845b@salvia>
References: <tencent_DDE91CB7412D427A442DB4362364DC04F20A@qq.com>
 <YrTAyW0phD0OiYN/@salvia>
 <tencent_2B372B7CD9C70750319022510DAD3C081108@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <tencent_2B372B7CD9C70750319022510DAD3C081108@qq.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 24, 2022 at 08:05:30PM +0800, Wei Han wrote:
> On Thu, Jun 23, 2022 at 09:36:41PM +0200, Pablo Neira Ayuso wrote:
[...]
> > > +		} else {
> > > +			return false;
> > > +		}
> > > +	} else if (proto == IPPROTO_ESP) {
> > > +		//not NAT-T
> > > +		eh = skb_header_pointer(skb, par->thoff, sizeof(_esp), &_esp);
> > > +		if (!eh) {
> > > +			/* We've been asked to examine this packet, and we
> > > +			 * can't.  Hence, no choice but to drop.
> > > +			 */
> > > +			pr_debug("Dropping evil ESP tinygram.\n");
> > > +			par->hotdrop = true;
> > > +			return false;
> > > +		}
> > 
> > This is loose, the user does not have a way to restrict to either
> > ESP over UDP or native ESP. I don't think this is going to look nice
> > from iptables syntax perspective to restrict either one or another
> > mode.
> >
>   This match original purpose is check the ESP packet's SPI value, so I
>   think the user maybe not need to pay attention that the packet is 
>   ESP over UDP or native ESP just get SPI and check it, this patch is 
>   only want to add support for get SPI in ESP over UDP.And the iptables rules like:
>   "iptables -A INPUT -m esp --espspi 0x12345678 -j ACCEPT"

This rule would be now allowing UDP traffic to go through, even if the
user does not need it. An explicit policy entry to allow NAT-T would
be preferred.

There is another issue, although I suppose there is a standard UDP
port for this, user might decide to select a different one, in that
case, this would break. And I don't see an easy way to allow user to
select the UDP port in the iptables case.
