Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15B431F5267
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 12:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbgFJKfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 06:35:05 -0400
Received: from mail.intenta.de ([178.249.25.132]:28230 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726533AbgFJKfD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jun 2020 06:35:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:CC:To:From:Date; bh=loI4CH3WmfwdXksqDDti2xWPtXtxjCTEcZYNbn2hIuk=;
        b=C/EjmDbDJVP5M4N3qRrUXDBaruaPYNSDgzlt2RvAbBzSnFXg9ZE1HuG55S12G5o1N6vtBDMP5dMN5BmRCtkdgi16nOGyP0IHVPl+CE4Vo6ejxB8JJ1JjuQdpW/9VHHHk3NJwvC8e/zb3nGU0dg8JgxoOkQPfPS+OnSPRpuocGtQSYAHRO4jN0sdSBXJr6xyx20EK4RTTi6oTBZQpX9bRU6yv19damI8P/tOML2MSbjYMA5CWQFoD6cjtdgQJdDR9xAVZo4f/jizQG1fSLdSJqvHboDLrgxqvhaVpntXNe+lbKhQdDwKQufd3EqC5x8laNDOJf8KKhETk7m3DFEGKRQ==;
Date:   Wed, 10 Jun 2020 12:34:50 +0200
From:   Helmut Grohne <helmut.grohne@intenta.de>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: correct use of PHY_INTERFACE_MODE_RGMII{,_TXID,_RXID,_ID}
Message-ID: <20200610103450.GA10547@laureti-dev>
References: <20200610081236.GA31659@laureti-dev>
 <VI1PR0402MB3871F98C656BF1A0A599CA59E0830@VI1PR0402MB3871.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB3871F98C656BF1A0A599CA59E0830@VI1PR0402MB3871.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ICSMA002.intenta.de (10.10.16.48) To ICSMA002.intenta.de
 (10.10.16.48)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ioana,

On Wed, Jun 10, 2020 at 11:10:23AM +0200, Ioana Ciornei wrote:
> > freescale/dpaa2/dpaa2-mac.c is interesting. It checks whether any rgmii mode
> > other than PHY_INTERFACE_MODE_RGMII is used and complains that delays are
> > not supported in that case. The above comment says that the MAC does not
> > support adding delays. It seems that in that case, the only working mode should
> > be PHY_INTERFACE_MODE_RGMII_ID rather than
> > PHY_INTERFACE_MODE_RGMII. Is the code mixed up or my understanding?
> 
> The snippet that you are referring to is copied below for quick reference:
> 
> /* The MAC does not have the capability to add RGMII delays so
>  * error out if the interface mode requests them and there is no PHY
>  * to act upon them
>  */
> if (of_phy_is_fixed_link(dpmac_node) &&
>     (mac->if_mode == PHY_INTERFACE_MODE_RGMII_ID ||
>      mac->if_mode == PHY_INTERFACE_MODE_RGMII_RXID ||
>      mac->if_mode == PHY_INTERFACE_MODE_RGMII_TXID)) {
> 	netdev_err(net_dev, "RGMII delay not supported\n");
> 
> The important part which you seem to be missing is that a functional RGMII link can
> have the delays inserted by the PHY, the MAC or by PCB traces (in this exact order
> of preference). Here we check for any RGMII interface mode that
> requests delays to be added when the interface is in fixed link mode
> (using of_phy_is_fixed_link()), thus there is no PHY to act upon them.
> This restriction, as the comment says, comes from the fact that the MAC
> is not able to add RGMII delays.
> 
> When we are dealing with a fixed link, the only solution for DPAA2 is to use plain
> PHY_INTERFACE_MODE_RGMII and to hope that somebody external to this Linux
> system made sure that the delays have been inserted (be those PCB delays, or
> internal delays added by the link partner).

If I am reading this correctly, you are saying that the DPAA2 driver is
operating as a PHY, not as a MAC here. Is that correct?

This distinction is a bit difficult (in particular for fixed links)
since RGMII is symmetric, but it is important for understanding the
definitions from
Documentation/devicetree/bindings/net/ethernet-controller.yaml:

|       # RX and TX delays are added by the MAC when required
|       - rgmii
| 
|       # RGMII with internal RX and TX delays provided by the PHY,
|       # the MAC should not add the RX or TX delays in this case
|       - rgmii-id
| 
|       # RGMII with internal RX delay provided by the PHY, the MAC
|       # should not add an RX delay in this case
|       - rgmii-rxid
| 
|       # RGMII with internal TX delay provided by the PHY, the MAC
|       # should not add an TX delay in this case
|       - rgmii-txid

These are turned into the matching PHY_INTERFACE_MODE_* by the OF code.

My understanding is that the delays are always described as seen by the
PHY. When it says that an "internal delay" (id) is present, the delay is
internal to the PHY, not the MAC. So unless DPAA2 is operating as a PHY,
it still seems reversed to me.

If we think of DPAA2 as a MAC (which seems more natural to me), it
should only allow rgmii-id, becaue it does not support adding delays
according to the comment.

Helmut
