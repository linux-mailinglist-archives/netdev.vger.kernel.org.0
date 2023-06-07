Return-Path: <netdev+bounces-8664-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A87D7251D2
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 03:55:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6487D1C20B3A
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 01:54:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E2FD641;
	Wed,  7 Jun 2023 01:54:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF707C
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 01:54:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B06EC433EF;
	Wed,  7 Jun 2023 01:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686102895;
	bh=L5++KAY1MZjlyXEgE62/aSSXjGPmyMxfne3vd2s3Qh0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mCWRdAv9G9mqhBqQL78XetAXwO85iy64XPDCYeMLzla2fz2hjB5WC6W++watZjd0s
	 oaLdHFMuRkCtMN8Kuhq8OwNylmDR1p439v2jHKPaCmwerg/RNg/h8GmPHlonUjSRE9
	 sgAfLkEhP/2C5uFWAg0e1Kfd+sihCI6EXlz8mp2x9xvkFRcIccQXLQYybbo+wuLxcs
	 XHkx7gPJn+QqcQMpgdLj9yYAODmRwZknUfyZCN6DdQRAtgUWY4mUmX+jbi/1F9fS6O
	 IdrfgStPm1AbFEOvapklC8HpviuJTVRt9pHfufo6OxwEEKqklpPuLBpKQpCTEKaW6m
	 McbRq3mezKn1g==
Date: Tue, 6 Jun 2023 18:54:53 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Justin Chen <justin.chen@broadcom.com>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 bcm-kernel-feedback-list@broadcom.com, florian.fainelli@broadcom.com,
 davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
 opendmb@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
 linux@armlinux.org.uk, richardcochran@gmail.com, sumit.semwal@linaro.org,
 christian.koenig@amd.com, simon.horman@corigine.com
Subject: Re: [PATCH net-next v6 3/6] net: bcmasp: Add support for ASP2.0
 Ethernet controller
Message-ID: <20230606185453.582d3831@kernel.org>
In-Reply-To: <8601be87-4bcb-8e6b-5124-1c63150c7c40@broadcom.com>
References: <1685657551-38291-1-git-send-email-justin.chen@broadcom.com>
	<1685657551-38291-4-git-send-email-justin.chen@broadcom.com>
	<20230602235859.79042ff0@kernel.org>
	<956dc20f-386c-f4fe-b827-1a749ee8af02@broadcom.com>
	<20230606171605.3c20ae79@kernel.org>
	<8601be87-4bcb-8e6b-5124-1c63150c7c40@broadcom.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 6 Jun 2023 18:35:51 -0700 Justin Chen wrote:
> > Also - can you describe how you can have multiple netdevs for
> > the same MAC?  
> 
> Not netdevs per se, but packets can be redirected to an offload 
> co-processor.

How is the redirecting configured?

Could you split this patch into basic netdev datapath,
and then as separate patches support for ethtool configuration features,
each with its own patch? This will make it easier for area experts to
review.

The base patch can probably include these:

+	.get_drvinfo		= bcmasp_get_drvinfo,
+	.get_link		= ethtool_op_get_link,
+	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
+	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
+	.get_msglevel		= bcmasp_get_msglevel,
+	.set_msglevel		= bcmasp_set_msglevel,

WoL can be a separate patch:

+	.get_wol		= bcmasp_get_wol,
+	.set_wol		= bcmasp_set_wol,

Stats a separate patch:

+	.get_strings		= bcmasp_get_strings,
+	.get_ethtool_stats	= bcmasp_get_ethtool_stats,
+	.get_sset_count		= bcmasp_get_sset_count,
+	.nway_reset		= phy_ethtool_nway_reset,

Flow steering separate:

+	.get_rxnfc		= bcmasp_get_rxnfc,
+	.set_rxnfc		= bcmasp_set_rxnfc,

EEE separate:

+	.set_eee		= bcmasp_set_eee,
+	.get_eee		= bcmasp_get_eee,

