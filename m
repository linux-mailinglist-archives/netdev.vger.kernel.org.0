Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0C438B11E
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 16:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243653AbhETOKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 10:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243715AbhETOJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 10:09:20 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462ACC061343;
        Thu, 20 May 2021 07:06:12 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id b17so19584880ede.0;
        Thu, 20 May 2021 07:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AUtwY0YyV6MUpEXrEq/QLtlnGkpYP87nXhFzm7PSbOY=;
        b=sB3GH0+8UVYRvkWj+hs7tYKLFwFeSjDm+ybheKMP3/xw87zBACyNRO3CDLTKtwL5tw
         puGeGutssWvX/oOqB1DfLFTJF8WkcnIspvPxypQKK+PeBo76gRj9tghuDYYArNTBVDdW
         ngPXDGKc/oIKX9nTdognD48pcx+apvzQNOq7Ly/Ypzc2QKURJuPqkqbFJt67ghkN1Npm
         IHGU/dq7KvELGV/wwvgqVaAqv3i8Zr8U5KkI7Ou5BcEVfT1ttHRyelKaI/2hT6l/u+gN
         JDF9h21WaESAb4dIaBD776ZTDSLk2IUfS0AfwMFSr5vhlQ9ZVHkNF9I46XqtbFqvTvjP
         Ut0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AUtwY0YyV6MUpEXrEq/QLtlnGkpYP87nXhFzm7PSbOY=;
        b=afmBqBj7c2IUHBW1Qh1IFaDvllFZdnjjnhUDaY2U5fcWBCCa9XRT7Re1prMyTPhT1r
         EpQd6+lmE3YCmDkrJ9QOmc09QWSg9GF1xZ1KCIqzezCeLRixiPyKnFsGszEvbb3+uDJO
         RqwE2yhFpoymunoOV7NEhaGRKFWUisRkWON9vZszI5mQROxIzsmeuOP8LqnTnTCOMMSS
         aa+ujhvVjigw2PsiePzY175o7dmCJxaoMemRcI2scRqr38XwONK96IQpOTML/sHi/j5g
         a6ZgCRbrB/rVx9+J7LBOuzq6FbOwoIKzO1zPC4Y4svtQHLDbtlwWywKM5agiDbjyFEoy
         yhcQ==
X-Gm-Message-State: AOAM531gSDlTjQ/rOvz89rDXUbtgbrEnsrA4PCkCon2/GRErskGGkTl2
        Ikx7J9pIhtumL0P24UDgAC8=
X-Google-Smtp-Source: ABdhPJx9tjC/dZh9vEtgaImWmzZRsBwM7FPJ2SOBTbxNbPwTnxGFc3+94X4Q5mIbtjJ4PGmjrbWPmQ==
X-Received: by 2002:a05:6402:1d39:: with SMTP id dh25mr5193121edb.113.1621519570933;
        Thu, 20 May 2021 07:06:10 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id p5sm1449101ejm.115.2021.05.20.07.06.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 07:06:10 -0700 (PDT)
Date:   Thu, 20 May 2021 17:06:09 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-spi@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next] net: dsa: sja1105: adapt to a SPI controller
 with a limited max transfer size
Message-ID: <20210520140609.mriocqfabkcflsls@skbuf>
References: <20210520135031.2969183-1-olteanv@gmail.com>
 <20210520135615.GB3962@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520135615.GB3962@sirena.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mark,

On Thu, May 20, 2021 at 02:56:15PM +0100, Mark Brown wrote:
> On Thu, May 20, 2021 at 04:50:31PM +0300, Vladimir Oltean wrote:
> 
> > Only that certain SPI controllers, such as the spi-sc18is602 I2C-to-SPI
> > bridge, cannot keep the chip select asserted for that long.
> > The spi_max_transfer_size() and spi_max_message_size() functions are how
> > the controller can impose its hardware limitations upon the SPI
> > peripheral driver.
> 
> You should respect both, frankly I don't see any advantage to using
> cs_change for something like this - just do a bunch of async SPI
> transfers and you'll get the same effect in terms of being able to keep
> the queue for the controller primed with more robust support since it's
> not stressing edge cases.  cs_change is more for doing things that are
> just very non-standard.

Sorry, I don't really understand your comment: in which way would it be
more robust for my use case to use spi_async()?

The cs_change logic was already there prior to this patch, I am just
reiterating how it works. Given the way in which it works (which I think
is correct), the most natural way to limit the buffer length is to look
for the max transfer len.
