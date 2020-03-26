Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20D2319483F
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 21:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbgCZUFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 16:05:38 -0400
Received: from smtprelay0172.hostedemail.com ([216.40.44.172]:37626 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727851AbgCZUFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 16:05:38 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 22899182CF244;
        Thu, 26 Mar 2020 20:05:37 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3868:3871:4321:5007:6742:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12048:12296:12297:12438:12740:12760:12895:13161:13229:13439:14659:14721:21080:21627:21990:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:24,LUA_SUMMARY:none
X-HE-Tag: ink47_137fca8f2a32c
X-Filterd-Recvd-Size: 3482
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf17.hostedemail.com (Postfix) with ESMTPA;
        Thu, 26 Mar 2020 20:05:33 +0000 (UTC)
Message-ID: <ba3b1a69496eb08cb071dace96fd385ff8f838e7.camel@perches.com>
Subject: Re: [PATCH net-next 7/9] net: phy: enable qoriq backplane support
From:   Joe Perches <joe@perches.com>
To:     florinel.iordache@nxp.com, davem@davemloft.net,
        netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org
Date:   Thu, 26 Mar 2020 13:03:42 -0700
In-Reply-To: <1585230682-24417-8-git-send-email-florinel.iordache@nxp.com>
References: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
         <1585230682-24417-8-git-send-email-florinel.iordache@nxp.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-03-26 at 15:51 +0200, Florinel Iordache wrote:
> Enable backplane support for qoriq family of devices

trivial notes:

> diff --git a/drivers/net/phy/backplane/qoriq_backplane.c b/drivers/net/phy/backplane/qoriq_backplane.c
[]
> +static int qoriq_backplane_probe(struct phy_device *bpphy)
> +{
> +	static bool one_time_action = true;
> +
> +	if (one_time_action) {
> +		one_time_action = false;
> +		pr_info("%s: QorIQ Backplane driver version %s\n",
> +			QORIQ_BACKPLANE_DRIVER_NAME,
> +			QORIQ_BACKPLANE_DRIVER_VERSION);
> +	}

There is an existing mechanism for this:

	pr_info_once("%s: ... %s\n", etc...);

[]

> +static int qoriq_backplane_config_init(struct phy_device *bpphy)
> +{
[]
> +	for (i = 0; i < bp_phy->num_lanes; i++) {
[]
> +		ret = of_address_to_resource(lane_node, 0, &res);
> +		if (ret) {
> +			bpdev_err(bpphy,
> +				  "could not obtain lane memory map for index=%d, ret = %d\n",
> +				  i, ret);
> +			return ret;

This could use the new vsprintf %pe extension:

			bpdev_err(bpphy,
				  "could not obtain lane memory map for index=%d, %pe\n",
				  i, ERR_PTR(ret));

> +	ret = of_address_to_resource(serdes_node, 0, &res);
> +	if (ret) {
> +		bpdev_err(bpphy,
> +			  "could not obtain serdes memory map, ret = %d\n",
> +			  ret);
> +		return ret;

%pe etc.

[]

> +	for (i = 0; i < comp_no; i++) {
> +		ret = of_property_read_string_index(serdes_node, "compatible",
> +						    i, &serdes_comp);
> +		if (ret == 0) {
> +			if (!strcasecmp(serdes_comp, "serdes-10g")) {
> +				serdes_type = SERDES_10G;
> +				break;
> +			} else if (!strcasecmp(serdes_comp, "serdes-28g")) {
> +				serdes_type = SERDES_28G;
> +				break;
> +			}
> +		}
> +	}
[]
> +static int qoriq_backplane_match_phy_device(struct phy_device *bpphy)
> +{
[]
> +	for (i = 0; i < comp_no; i++) {
> +		ret = of_property_read_string_index(serdes_node, "compatible",
> +						    i, &serdes_comp);
> +		if (ret == 0) {
> +			if (!strcasecmp(serdes_comp, "serdes-10g")) {
> +				serdes_type = SERDES_10G;
> +				break;
> +			} else if (!strcasecmp(serdes_comp, "serdes-28g")) {
> +				serdes_type = SERDES_28G;
> +				break;
> +			}
> +		}
> +	}
[]

Maybe add and use a helper function?


