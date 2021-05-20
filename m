Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53BC38B87E
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 22:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239114AbhETUhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 16:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235604AbhETUhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 16:37:10 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A16CC061574;
        Thu, 20 May 2021 13:35:47 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id g7so8728466edm.4;
        Thu, 20 May 2021 13:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k4dWzPCm+6PalKzKaJkaDTaqXlLXGoocl6zkm7MxKPY=;
        b=jdYh/NaeE1Lx/4jLjQo72pIdXimncSDx9yyXfO6Fi/fGqtIypr0Z43GOfT1b+2Qi3I
         Y/LJm2tqernQMYxOkcEoStOfyodB72RjE7gG01ESSNsHDAG8wPknoelzcRut8lnBl6wC
         cT+BKqfkOhaEnrEmBv3yl1sPmE4rWwQKRvcpTXxbmabJy30fpb3+Rwpki4U/2lN4qxyR
         xiwcOYg3RGfOMKKEPLjncHQN6SVJsKK4vKBax0vBr8lPtUQFp8jK7xaVVmdA3HELNfcz
         xyq1Uy9VfY3j7fbrwSgDswKRs9AxLDE5cXtrhGty+w2RjFor8Sz28Q6ticfVW62Loi1F
         Nusw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k4dWzPCm+6PalKzKaJkaDTaqXlLXGoocl6zkm7MxKPY=;
        b=F4Huw53zZtHWGR+OaDxfkYuR8e2PnXcMp0K6IHIizjs621pYw1Rq6Z0E5iNYSXRUh4
         aPb3Fqa523QtMagQ5XtHqiEz8c5pwEhFex+bSTlZqlXjelbAW0Z+BcjxHYFf57kVK+Bi
         zgns5Hx7w5nP+koXbxSNqay93jbT9MfFSxJhby/3i1kQpszaqOVwmtCIz/yAub/qoqq3
         Z4Qp1nBqBTnvdlgWP+k7YT9zDpY7JoGh9/g9O0K0YbDkUlV3LXJ1Bm3laiI64rNTrkbf
         15lqz6XMhaeCVqpE2FT+ZZ4y7ttAStrDwR6Lfc8PhpzJ7Tdw9NYB3EerxMg624ANPd9o
         D9Wg==
X-Gm-Message-State: AOAM533wplqAmREx8TfBk9fCavF0xBCtnR5UOmpVyzwxqF4MtegyVRFQ
        0Q6QakypqH1m4GNRpDhYibY=
X-Google-Smtp-Source: ABdhPJxuZb6ujIsVIgKdvhhak1lO7W0A5PmYN9MJzoB9e3xs9xR030tiohqz3aT7U0VpLvxPwMgRSw==
X-Received: by 2002:a05:6402:1c97:: with SMTP id cy23mr6947927edb.213.1621542945590;
        Thu, 20 May 2021 13:35:45 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id l28sm2257691edc.29.2021.05.20.13.35.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 13:35:45 -0700 (PDT)
Date:   Thu, 20 May 2021 23:35:43 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net-next 2/2] net: dsa: sja1105: adapt to a SPI
 controller with a limited max transfer size
Message-ID: <20210520203543.kysqamwxy2b6i4gi@skbuf>
References: <20210520200223.3375421-1-olteanv@gmail.com>
 <20210520200223.3375421-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520200223.3375421-3-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 11:02:23PM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The static config of the sja1105 switch is a long stream of bytes which
> is programmed to the hardware in chunks (portions with the chip select
> continuously asserted) of max 256 bytes each.
> 
> Only that certain SPI controllers, such as the spi-sc18is602 I2C-to-SPI
> bridge, cannot keep the chip select asserted for that long.
> The spi_max_transfer_size() and spi_max_message_size() functions are how
> the controller can impose its hardware limitations upon the SPI
> peripheral driver.
> 
> The sja1105 sends its static config to the SPI master in chunks, and
> each chunk is a spi_message composed of 2 spi_transfers: the buffer with
> the data and a preceding buffer with the SPI access header. Both buffers
> must be smaller than the transfer limit, and their sum must be smaller
> than the message limit.
> 
> Regression-tested on a switch connected to a controller with no
> limitations (spi-fsl-dspi) as well as with one with caps for both
> max_transfer_size and max_message_size (spi-sc18is602).
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/dsa/sja1105/sja1105_spi.c | 30 ++++++++++++++++++++-------
>  1 file changed, 23 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
> index 8746e3f158a0..7bcf2e419037 100644
> --- a/drivers/net/dsa/sja1105/sja1105_spi.c
> +++ b/drivers/net/dsa/sja1105/sja1105_spi.c
> @@ -40,19 +40,35 @@ static int sja1105_xfer(const struct sja1105_private *priv,
>  			size_t len, struct ptp_system_timestamp *ptp_sts)
>  {
>  	u8 hdr_buf[SJA1105_SIZE_SPI_MSG_HEADER] = {0};
> -	struct sja1105_chunk chunk = {
> -		.len = min_t(size_t, len, SJA1105_SIZE_SPI_MSG_MAXLEN),
> -		.reg_addr = reg_addr,
> -		.buf = buf,
> -	};
>  	struct spi_device *spi = priv->spidev;
>  	struct spi_transfer xfers[2] = {0};
>  	struct spi_transfer *chunk_xfer;
>  	struct spi_transfer *hdr_xfer;
> +	struct sja1105_chunk chunk;
> +	ssize_t xfer_len;
>  	int num_chunks;
>  	int rc, i = 0;
>  
> -	num_chunks = DIV_ROUND_UP(len, SJA1105_SIZE_SPI_MSG_MAXLEN);
> +	/* One spi_message is composed of two spi_transfers: a small one for
> +	 * the message header and another one for the current chunk of the
> +	 * packed buffer.
> +	 * Check that the restrictions imposed by the SPI controller are
> +	 * respected: the chunk buffer is smaller than the max transfer size,
> +	 * and the total length of the chunk plus its message header is smaller
> +	 * than the max message size.
> +	 */
> +	xfer_len = min_t(ssize_t, SJA1105_SIZE_SPI_MSG_MAXLEN,
> +			 spi_max_transfer_size(spi));
> +	xfer_len = min_t(ssize_t, SJA1105_SIZE_SPI_MSG_MAXLEN,
> +			 spi_max_message_size(spi) - SJA1105_SIZE_SPI_MSG_HEADER);
> +	if (xfer_len < 0)
> +		return -ERANGE;

I've introduced a bug here when spi_max_message_size returns SIZE_MAX
which is of the unsigned size_t type. Converted to ssize_t it's negative,
so it triggers the negative check...

Please wait until I send a v3 with this fixed. Thanks.

> +
> +	num_chunks = DIV_ROUND_UP(len, xfer_len);
> +
> +	chunk.reg_addr = reg_addr;
> +	chunk.buf = buf;
> +	chunk.len = min_t(size_t, len, xfer_len);
>  
>  	hdr_xfer = &xfers[0];
>  	chunk_xfer = &xfers[1];
> @@ -104,7 +120,7 @@ static int sja1105_xfer(const struct sja1105_private *priv,
>  		chunk.buf += chunk.len;
>  		chunk.reg_addr += chunk.len / 4;
>  		chunk.len = min_t(size_t, (ptrdiff_t)(buf + len - chunk.buf),
> -				  SJA1105_SIZE_SPI_MSG_MAXLEN);
> +				  xfer_len);
>  
>  		rc = spi_sync_transfer(spi, xfers, 2);
>  		if (rc < 0) {
> -- 
> 2.25.1
> 
