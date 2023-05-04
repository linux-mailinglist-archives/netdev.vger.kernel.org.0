Return-Path: <netdev+bounces-238-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A6486F631E
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 05:05:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 47C741C21079
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 03:05:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C96B8EBC;
	Thu,  4 May 2023 03:05:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2207C
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 03:05:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F69C4339B;
	Thu,  4 May 2023 03:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683169547;
	bh=nbR6RG+gUNBf0VDqoWhC4g62ObIlSlFeVW5NhH2u/Do=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OosPuxYtctHk+Duhe4/rt6Cx82SytoOrCs5J1ZlLXjr3Q/vq5RKCIXOWHjp5HIns+
	 m4Cqwm4CZj8+skvAWChEKsOfRUaO1nNFKup8cOkSCKZmGxqHEbislTR6gLJdCGkbky
	 BivIFaVoOYSBYrz709jqEXGw9qRRoGDP+jeqTEdI7eEJSRaBjE5/F44Nd8PIXaXUPC
	 afH9ZX9RYnxjsLShJP9c8zyZrZ9UYHBBMkO5hSvA9cSo1DoJSISs7Oxj8/qkVQ8j3Z
	 uIORoS5V1Adj2lqyyymlnHLqyMEo9OxgjmER6DRCGEetAWVFemA6Es+XzaAE1DskK8
	 60PgoGWxxb6GQ==
Date: Wed, 3 May 2023 20:05:45 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Maxim Georgiev <glipus@gmail.com>
Cc: kory.maincent@bootlin.com, netdev@vger.kernel.org,
 maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
 vadim.fedorenko@linux.dev, richardcochran@gmail.com,
 gerhard@engleder-embedded.com, liuhangbin@gmail.com
Subject: Re: [RFC PATCH net-next v6 2/5] net: Add ifreq pointer field to
 kernel_hwtstamp_config structure
Message-ID: <20230503200545.2ff5d9d2@kernel.org>
In-Reply-To: <20230502043150.17097-3-glipus@gmail.com>
References: <20230502043150.17097-1-glipus@gmail.com>
	<20230502043150.17097-3-glipus@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon,  1 May 2023 22:31:47 -0600 Maxim Georgiev wrote:
> +	err = dev_eth_ioctl(dev, &ifrr, SIOCSHWTSTAMP);
> +	if (!err) {
> +		kernel_cfg->ifr->ifr_ifru = ifrr.ifr_ifru;
> +		kernel_cfg->kernel_flags |= KERNEL_HWTSTAMP_FLAG_IFR_RESULT;
> +	}
> +	return err;

nit: I think we should stick to the normal flow even if it costs 
a few extra lines:

	err = dev_eth_ioctl(..
	if (err)
		return err;

	kernel_cfg->ifr->ifr_ifru = ifrr.ifr_ifru;
	kernel_cfg->kernel_flags |= KERNEL_HWTSTAMP_FLAG_IFR_RESULT;

	return 0;


Other than that patches LGTM :)

