Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA7060E16C
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbiJZNEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbiJZNEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:04:08 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F286EDFC18;
        Wed, 26 Oct 2022 06:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GBv38T/45dq6lsnEAE8G98FaLrnfJC5ijsIiQgoBaQU=; b=L5Yt+yt9qTCZqqB9uJ3MTXCrRR
        qEYaixmbEN7ZcwS64Qgm25fQcgwyGQE5Fgpm+opCGaxnzcPeAV5QqG7WSN06Nacy+3WIr4m57l03L
        99mSqOwWIhRRC9JPYaxVnfHnWlNCuCx44KFnTEg2J2FibzWStdyChvjfFildsx1Km3k0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1onfNE-000cZn-Vt; Wed, 26 Oct 2022 14:19:08 +0200
Date:   Wed, 26 Oct 2022 14:19:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, saeedm@nvidia.com, corbet@lwn.net,
        michael.chan@broadcom.com, huangguangbin2@huawei.com,
        chenhao288@hisilicon.com, moshet@nvidia.com,
        linux@rempel-privat.de, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] ethtool: linkstate: add a statistic for PHY
 down events
Message-ID: <Y1klvBsXfEXd4y8M@lunn.ch>
References: <20221026020948.1913777-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026020948.1913777-1-kuba@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 25, 2022 at 07:09:48PM -0700, Jakub Kicinski wrote:
> The previous attempt to augment carrier_down (see Link)
> was not met with much enthusiasm so let's do the simple
> thing of exposing what some devices already maintain.
> Add a common ethtool statistic for link going down.
> Currently users have to maintain per-driver mapping
> to extract the right stat from the vendor-specific ethtool -S
> stats. carrier_down does not fit the bill because it counts
> a lot of software related false positives.
> 
> Add the statistic to the extended link state API to steer
> vendors towards implementing all of it.
> 
> Implement for bnxt. mlx5 and (possibly) enic also have
> a counter for this but I leave the implementation to their
> maintainers.

> +struct ethtool_link_ext_stats {
> +	/* Custom Linux statistic for PHY level link down events.
> +	 * In a simpler world it should be equal to netdev->carrier_down_count
> +	 * unfortunately netdev also counts local reconfigurations which don't
> +	 * actually take the physical link down, not to mention NC-SI which,
> +	 * if present, keeps the link up regardless of host state.
> +	 * This statistic counts when PHY _actually_ went down, or lost link.
> +	 */
> +	u64 LinkDownEvents;
> +};

You might want to consider a generic implementation in phylib. You
should then have over 60 drivers implementing this, enough momentum it
might actually get used.

      Andrew
