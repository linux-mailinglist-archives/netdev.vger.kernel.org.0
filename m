Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A40AD69FAB8
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 19:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbjBVSE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 13:04:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbjBVSE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 13:04:27 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E1811EBC;
        Wed, 22 Feb 2023 10:04:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=hlNS2X2Xqf+Z97espqDnwbcl/Ki3E10UhHxUQFY1lCE=; b=AVK8vTj3eQpBWUQ3toTiAMeZNA
        2/+u5ANSCyFS8g9BTtGnw6eZnmOK5EnmIjpyoIlR31NJewT0RHIqK3dKqaEJpWOPyJYdinKFRspp4
        hkgRAyj0a+Xufnl3nR7C0jdTixqQ6kkh4iDYMoJ67VIt8vhYtghSIr93VNaASfUQ8nzo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pUtSw-005iK5-Un; Wed, 22 Feb 2023 19:03:42 +0100
Date:   Wed, 22 Feb 2023 19:03:42 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Henneberg - Systemdesign <lists@henneberg-systemdesign.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net V3] net: stmmac: Premature loop termination check was
 ignored
Message-ID: <Y/ZY/o5HvNCPLfFg@lunn.ch>
References: <87y1oq5es0.fsf@henneberg-systemdesign.com>
 <Y/XbXwKYpy3+pTah@corigine.com>
 <87lekp66ko.fsf@henneberg-systemdesign.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lekp66ko.fsf@henneberg-systemdesign.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 04:49:55PM +0100, Henneberg - Systemdesign wrote:
> 
> Simon Horman <simon.horman@corigine.com> writes:
> 
> > On Wed, Feb 22, 2023 at 08:38:28AM +0100, Jochen Henneberg wrote:
> >> 
> >> The premature loop termination check makes sense only in case of the
> >> jump to read_again where the count may have been updated. But
> >> read_again did not include the check.
> >> 
> >> Fixes: bba2556efad6 ("net: stmmac: Enable RX via AF_XDP zero-copy")
> >
> > This commit was included in v5.13
> >
> >> Fixes: ec222003bd94 ("net: stmmac: Prepare to add Split Header support")
> >
> > While this one was included in v5.4
> >
> > It seems to me that each of the above commits correspond to one
> > of the two hunks below. I don't know if that means this
> > patch should be split in two to assist backporting.
> >
> 
> I was thinking about this already but the change was so trivial that I
> hesitated to split it into two commits. I wanted I will surely change
> this.

The advantage of splitting is that it makes back porting easy. Both
parts are needed for 6.1 and 5.15. 5.10 only needs the fix for
ec222003bd94. It if does not easily apply to 5.10 it could get
dropped. By splitting it, the backporting probably happens fully
automated, no human involved.

	Andrew
