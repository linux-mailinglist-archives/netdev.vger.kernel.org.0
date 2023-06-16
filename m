Return-Path: <netdev+bounces-11621-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 08190733B45
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 23:00:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E2561C20AD9
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 21:00:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2418D6AB4;
	Fri, 16 Jun 2023 21:00:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15388ECB
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 21:00:32 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5E530F1;
	Fri, 16 Jun 2023 14:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=/0KYNG1uu6OLOczaiMiZPIPx6IT+zlOzx5X/EdsZ93Y=; b=koc+oIVJT0JjkvRjMmML9CaNhS
	yx7gLISInirxmjUOfey7U7uxJuvGY1KMVKq7fLgiTreGudJ6HCgOpsSod7zcUeZXqKw++4Oo5C2PI
	RcO5Fusttvj/6HURCtLlf35Ah1d6rc8HXqS43P0wKtJRdo+rqp3E8BJq5pifQX58SdyA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1qAGYT-00Gl8R-J8; Fri, 16 Jun 2023 23:00:25 +0200
Date: Fri, 16 Jun 2023 23:00:25 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc: hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	richardcochran@gmail.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, sebastian.tobuschat@nxp.com
Subject: Re: [PATCH net-next v1 13/14] net: phy: nxp-c45-tja11xx: reset PCS
 if the link goes down
Message-ID: <d483be85-2d63-4b37-9cc3-f8924c53bd08@lunn.ch>
References: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
 <20230616135323.98215-14-radu-nicolae.pirea@oss.nxp.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616135323.98215-14-radu-nicolae.pirea@oss.nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 04:53:22PM +0300, Radu Pirea (NXP OSS) wrote:
> During PTP testing on early TJA1120 engineering samples I observed that
> if the link is lost and recovered, the tx timestamps will be randomly
> lost. To avoid this HW issue, the PCS should be reseted.
> 
> Resetting the PCS will break the link and we should reset the PCS on
> LINK UP -> LINK DOWN transition, otherwise we will trigger and infinite
> loop of LINK UP -> LINK DOWN events.

> +static int tja1120_read_status(struct phy_device *phydev)
> +{
> +	unsigned int link = phydev->link;
> +	int ret;

Maybe consider using link_change_notify:

        /**
         * @link_change_notify: Called to inform a PHY device driver
         * when the core is about to change the link state. This
         * callback is supposed to be used as fixup hook for drivers
         * that need to take action when the link state
         * changes. Drivers are by no means allowed to mess with the
         * PHY device structure in their implementations.
         */
        void (*link_change_notify)(struct phy_device *dev);

Seems like a fixup to me.

      Andrew

