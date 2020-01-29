Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC9A614CDEB
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 17:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgA2QDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 11:03:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:33560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726564AbgA2QDN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jan 2020 11:03:13 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D83820716;
        Wed, 29 Jan 2020 16:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580313792;
        bh=1Vu2LfUy97wPgVFYJeDseCwF+09EEXsO8l/KfLq84Ms=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JANwGAa+ecBjxxqlp1htq1PDdbVOyaD8JpyFdsQSgd9lnGxXj8XnBpnzvkLQlKl+8
         2GFAtDsdJ0TjXV7yOcvMFSqfqIAfF8y3ttxocU3FGwxz0aqSygx7C3USTxWR4PN6h9
         NFCtuqvb8x+LXq1LgdH8OzEjLZ8rthJ5jW7sfhns=
Date:   Wed, 29 Jan 2020 08:03:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sameeh Jubran <sameehj@amazon.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>
Subject: Re: [PATCH V1 net 04/11] net: ena: fix incorrect default RSS key
Message-ID: <20200129080311.0bc5af60@cakuba>
In-Reply-To: <20200129140422.20166-5-sameehj@amazon.com>
References: <20200129140422.20166-1-sameehj@amazon.com>
        <20200129140422.20166-5-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jan 2020 14:04:15 +0000, Sameeh Jubran wrote:
> From: Arthur Kiyanovski <akiyano@amazon.com>
> 
> Bug description:
> When running "ethtool -x <if_name>" the key shows up as all zeros.
> 
> When we use "ethtool -X <if_name> hfunc toeplitz hkey <some:random:key>" to
> set the key and then try to retrieve it using "ethtool -x <if_name>" then
> we return the correct key because we return the one we saved.
> 
> Bug cause:
> We don't fetch the key from the device but instead return the key
> that we have saved internally which is by default set to zero upon
> allocation.
> 
> Fix:
> This commit fixes the issue by initializing the key to the default key that
> is used by the device.
> 
> Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
> Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
> Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>

So is the device actually using that key by default?

Hard coding a default RSS key makes it trivial for DDoS attackers 
to target specific queues, doesn't it?

Please follow the best practice of initializing your key with
netdev_rss_key_fill() and configuring the device with it at startup.

> diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
> index e54c44fdc..769339043 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_com.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_com.c
> @@ -64,6 +64,15 @@
>  
>  #define ENA_POLL_MS	5
>  
> +/* Default Microsoft RSS key, used for HRSS. */
> +static const u8 rss_hash_key[ENA_HASH_KEY_SIZE] = {
> +		0x6d, 0x5a, 0x56, 0xda, 0x25, 0x5b, 0x0e, 0xc2,
> +		0x41, 0x67, 0x25, 0x3d, 0x43, 0xa3, 0x8f, 0xb0,
> +		0xd0, 0xca, 0x2b, 0xcb, 0xae, 0x7b, 0x30, 0xb4,
> +		0x77, 0xcb, 0x2d, 0xa3, 0x80, 0x30, 0xf2, 0x0c,
> +		0x6a, 0x42, 0xb7, 0x3b, 0xbe, 0xac, 0x01, 0xfa

You also have an extra tab here for no reason.

> +};
> +
>  /*****************************************************************************/
>  /*****************************************************************************/
>  /*****************************************************************************/
