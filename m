Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F363D6B4C94
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 17:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232999AbjCJQRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 11:17:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbjCJQRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 11:17:21 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6445226C27;
        Fri, 10 Mar 2023 08:12:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ENIictmQQrUukowLJhwcEIVurshXzW2oH3AKELncnZg=; b=QvypUm8Dg5JjCs4xIDiXwqCTPh
        0eo9je+L45XcF1Ku4g7S+NGODWtTcMBpbtS9F75EhFN2Nb2/Khhb8Eqr8BUs27ZxLs0PVcqBbJkC/
        cOTvHgbNA0pOnjVfpZ10RozR7kHjHyBY53ovotjHTguKR+HbYrIqFpzRCu6OeVauHL/k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pafLo-006zgP-Gl; Fri, 10 Mar 2023 17:12:12 +0100
Date:   Fri, 10 Mar 2023 17:12:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Lukasz Majewski <lukma@denx.de>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] dsa: marvell: Provide per device information about
 max frame size
Message-ID: <2ed80772-feed-40ac-b0ac-612227558d08@lunn.ch>
References: <20230309125421.3900962-1-lukma@denx.de>
 <20230309125421.3900962-2-lukma@denx.de>
 <20230310120235.2cjxauvqxyei45li@skbuf>
 <20230310141719.7f691b45@wsk>
 <20230310154511.yqf3ykknnwe22b77@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310154511.yqf3ykknnwe22b77@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 05:45:11PM +0200, Vladimir Oltean wrote:
> On Fri, Mar 10, 2023 at 02:17:19PM +0100, Lukasz Majewski wrote:
> > This is the "patch 4" in the comment sent by Russel (to fix stuff which
> > is already broken, but it has been visible after running the validation
> > code):
> > 
> > https://lists.openwall.net/netdev/2023/03/09/233
> 
> Ok, so nope, what I was talking about here (MTU 1492) is *not* what you
> have discussed with Russell in patch 4.
> 
> What I was talking about is this:
> https://patchwork.kernel.org/project/netdevbpf/patch/20230309125421.3900962-2-lukma@denx.de/#25245979
> and Russell now seems to agree with me that it should be addressed
> separately, and prior to the extra development work done here.
> 
> It looks like it will also need a bit of assistance from Andrew to
> untangle whether EDSA_HLEN should be included in the max_mtu calculations
> for some switch families only, rather than for all.

That is hard to say. From other peoples experiments, it seems like
some families don't impose the frame length check on DSA and CPU
ports. Hence they accept frames with DSA or EDSA headers, even if that
puts them over the theoretical port max. Other families do seem to
perform check on DSA and CPU ports. I don't think the datasheets say
anything about this.

The safe thing to do is:

Assume all switches can accept the standard minimum MTU + DSA/EDSA
headers on their CPU ports.

For those switches which accept frames bigger than the standard,
assume the DSA/EDSA header is counted as part of the limit, and so
adjust the calculation.

This might short change a few switches 4/8 bytes, but that is better
than being broken because frames are dropped.

     Andrew
