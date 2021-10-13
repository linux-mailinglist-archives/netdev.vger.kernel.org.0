Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7EE42CF19
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 01:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbhJMXVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 19:21:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229668AbhJMXVO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 19:21:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69E00610CE;
        Wed, 13 Oct 2021 23:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634167150;
        bh=F+xXTdkGjVBQAYl+E0eHKPgE0qeOzSiW/wLeDW3an/E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dkdwuCo63Ap1nR+z3yLaIyti+CfwosJkCneSsUM6HKeMp0hNIzD936NCmoffM99nn
         WL7KLQtXostk777By44UtQ3X6ZKPjtn7vzJc+4yxEinGx6ZZdjo3ctuxfVXZSqhy/i
         Zt+Uwk2pIKinCkgf2os/SBidgEju77w3A0fkQ8aeALORdE0YQQ7gfJfZFsrKUt2t3I
         U2bgw8uVbgcgYuelSfxR23gqGYb9naw2acfaffUcpzLOXObB3g6/7MUAB1VEp8UoCK
         Ebibi/qLuo/kyX1QkbZ1W16eqS13UQoOjZZWNWY+5vrUlm6S12dh8dTpXlWypmqIFj
         ZkPjUQqrlAK8Q==
Date:   Wed, 13 Oct 2021 16:19:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net,
        Maciej Machnikowski <maciej.machnikowski@intel.com>,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        Sunitha Mekala <sunithax.d.mekala@intel.com>
Subject: Re: [PATCH net-next 3/4] ice: Add support for SMA control
 multiplexer
Message-ID: <20211013161909.735f2f17@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211012163153.2104212-4-anthony.l.nguyen@intel.com>
References: <20211012163153.2104212-1-anthony.l.nguyen@intel.com>
        <20211012163153.2104212-4-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Oct 2021 09:31:52 -0700 Tony Nguyen wrote:
> From: Maciej Machnikowski <maciej.machnikowski@intel.com>
> 
> E810-T adapters have two external bidirectional SMA connectors and two
> internal unidirectional U.FL connectors. Multiplexing between U.FL and
> SMA and SMA direction is controlled using the PCA9575 expander.
> 
> Add support for the PCA9575 detection and control of the respective pins
> of the SMA/U.FL multiplexer using the GPIO AQ API.

> +static int
> +ice_get_pca9575_handle(struct ice_hw *hw, u16 *pca9575_handle)
> +{
> +	struct ice_aqc_get_link_topo *cmd;
> +	struct ice_aq_desc desc;
> +	int status;
> +	u8 idx;
> +
> +	if (!hw || !pca9575_handle)
> +		return -EINVAL;

Looks like purest form of defensive programming, please drop this.

> +bool ice_is_pca9575_present(struct ice_hw *hw)
> +{
> +	u16 handle = 0;
> +	int status;
> +
> +	if (!ice_is_e810t(hw))
> +		return false;
> +
> +	status = ice_get_pca9575_handle(hw, &handle);
> +	if (!status && handle)
> +		return true;
> +
> +	return false;
> +}

	return !status && handle;
