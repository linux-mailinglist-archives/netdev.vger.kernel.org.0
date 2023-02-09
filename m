Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19A43691229
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 21:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbjBIUii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 15:38:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjBIUih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 15:38:37 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2B063134;
        Thu,  9 Feb 2023 12:38:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xdQMydH9PmcdCXuy6OiSMoO1TmqwS6eZVWQWTkIosYI=; b=Gqzt/zjlsrmtZKF8+l1HnrNRCX
        5vj8VU1Al/YdsebQFPJ6pfMFTkLFZC0rRy/lpn9ZFGlQ0+CgtT+AtkA7gziwVpt1ct/A1IOGZOrHL
        5r3jv/466uXtMS/8vVM8ukIpk/BIqLqkmNb6gIkUxOaW0TdNx4/xWbqLO3rVUv1hfPnk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pQDgX-004XSJ-ND; Thu, 09 Feb 2023 21:38:25 +0100
Date:   Thu, 9 Feb 2023 21:38:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     wei.fang@nxp.com
Cc:     shenwei.wang@nxp.com, xiaoning.wang@nxp.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: fec: add CBS offload support
Message-ID: <Y+VZwaFbLBAj2Ng0@lunn.ch>
References: <20230209092422.1655062-1-wei.fang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209092422.1655062-1-wei.fang@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	/* cbs->idleslope is in kilobits per second. speed is the port rate
> +	 * in megabits per second. So bandwidth ratio bw = (idleslope /
> +	 * (speed * 1000)) * 100, the unit is percentage.
> +	 */
> +	bw = cbs->idleslope / (speed * 10UL);

This appears to be a / 0 when the link is not up yet?  Also, if the
link goes does, fep->speed keeps the old value, so if it comes up
again at a different speed, your calculations are all wrong. So i
think you need fec_enet_adjust_link() involved in this.


> +	/* bw% can not >= 100% */
> +	if (bw >= 100)
> +		return -EINVAL;

Well > 100% could happen when the link goes from 1G to 10Half, or even
100Full. You should probably document the policy of what you do
then. Do you dedicate all the available bandwidth to the high priority
queue, or do you go back to best effort? Is it possible to indicate in
the tc show command that the configuration is no longer possible?

Presumably other drivers have already addressed all these issues, so
you just need to find out what they do.

    Andrew
