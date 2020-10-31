Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5CC2A12BA
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 02:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbgJaBlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 21:41:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgJaBlF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 21:41:05 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0500208B6;
        Sat, 31 Oct 2020 01:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604108465;
        bh=uW6NN4rmbksa+jXNvkaJXhdL3ezxmCF1MSWTTFq0JB0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jOLpJNVRCFvF3XBOHVDkHhvPbkTlAIr4vPjljpFsEOVaSvoK5xIJSpl2MYrtjlNl2
         vaP3gMtJmSLIWrAexJ5vBgUT3BRQTQcxlO/4yVNQpBqpi9qC7pAnACZDjMSoXRH8Mn
         6CzCFIn/brKhaOZaJZr/WS+CZYEo+hZK7qjcPQgs=
Date:   Fri, 30 Oct 2020 18:41:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Camelia Groza <camelia.groza@nxp.com>
Cc:     willemdebruijn.kernel@gmail.com, madalin.bucur@oss.nxp.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net v2 1/2] dpaa_eth: update the buffer layout for
 non-A050385 erratum scenarios
Message-ID: <20201030184103.59b09d16@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <505ebfdd659456e04eba067839eccf14e485005d.1603899392.git.camelia.groza@nxp.com>
References: <cover.1603899392.git.camelia.groza@nxp.com>
        <505ebfdd659456e04eba067839eccf14e485005d.1603899392.git.camelia.groza@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Oct 2020 18:40:59 +0200 Camelia Groza wrote:
> Impose a large RX private data area only when the A050385 erratum is
> present on the hardware. A smaller buffer size is sufficient in all
> other scenarios. This enables a wider range of linear frame sizes
> in non-erratum scenarios

Any word on user impact? Measurable memory waste?

> Fixes: 3c68b8fffb48 ("dpaa_eth: FMan erratum A050385 workaround")
> Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
> ---
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> index 06cc863..1aac0b6 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -175,8 +175,10 @@
>  #define DPAA_TIME_STAMP_SIZE 8
>  #define DPAA_HASH_RESULTS_SIZE 8
>  #ifdef CONFIG_DPAA_ERRATUM_A050385
> -#define DPAA_RX_PRIV_DATA_SIZE (DPAA_A050385_ALIGN - (DPAA_PARSE_RESULTS_SIZE\
> -	 + DPAA_TIME_STAMP_SIZE + DPAA_HASH_RESULTS_SIZE))
> +#define DPAA_RX_PRIV_DATA_SIZE (fman_has_errata_a050385() ? \
> +			(DPAA_A050385_ALIGN - (DPAA_PARSE_RESULTS_SIZE\
> +			 + DPAA_TIME_STAMP_SIZE + DPAA_HASH_RESULTS_SIZE)) : \
> +			(DPAA_TX_PRIV_DATA_SIZE + dpaa_rx_extra_headroom))

This expressions is highly unreadable, please refactor. Maybe separate
defines for errata and non-errata, and one for the ternary operator?

>  #else
>  #define DPAA_RX_PRIV_DATA_SIZE	(u16)(DPAA_TX_PRIV_DATA_SIZE + \
>  					dpaa_rx_extra_headroom)

