Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B8E38E70A
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 15:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbhEXNDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 09:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232774AbhEXNDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 09:03:44 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD27C061574;
        Mon, 24 May 2021 06:02:15 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id n2so41655254ejy.7;
        Mon, 24 May 2021 06:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Yd1/iaKW3TN8qN9woa7p+We2hx8jMCCw0wQ0PVgabEA=;
        b=QsKx+4RnhOtJgBLITpPnwMKHq/nSRUFL9KWZsxfWBPpMO1hsQQLqXLCwXcZJd2DGzE
         hnP6YuydqTueDISxoA0/HnwxRaXe907UsjX/NGcku3BBkYCwapxua8cgvujaXaUbbF5v
         SIo0T1g5IpAuoDwFIFMYGPXucAuvo6azaXP3peGPBJ1lCCVQwqmm3ZsAlbsGy7epmfG2
         vxoeZINle7nE2fb6ki52SYG47ofwnKPj2dh5KUgQsUoewccR3gVqfzGK9QNtGuGetwrp
         CET8+jxBS2TPrh2n3CVt99I15BIdZPZzmIXG5YdSCxPnonFNnpTbf+S1NLOXeoEfvMxe
         H29g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Yd1/iaKW3TN8qN9woa7p+We2hx8jMCCw0wQ0PVgabEA=;
        b=KJ6Sf9R1XO08zi9Znj5KCjYm+5IRm0MudvC6GTOi24RK0NmzWniLPcQh6v24Jia31x
         /dtgUDitm/YXydZakDh94+JwM6H/NB4sFSJU/ivrxsQCjIqk+PnClmCG1p1VLDpOkBi3
         IkpopgJW6tEYOcO4TqChd7mwgwo+3LxCWgpX2CIxotUb9cOkUKlvUd0YhY+GgOHCKRiv
         nuxdvjIcW7qXaDTCZajbTcppSKK6M2ISe+2njfNPTFFlw/3Vf5GN95vgMkEvx7ZEvZJ0
         /M7qLise+ufpjOP4beHbH4QV2RJvgKbnPN7qYWiCOItTfQp6jQxdY7RymZIofWYquQa4
         TPkg==
X-Gm-Message-State: AOAM532K/loAOv8mD8YZylrv/FQP6Hwd6lm4DqqtyP4xYmD5M27Q7Isv
        uemHa63QQpNVypY3qZil5J4=
X-Google-Smtp-Source: ABdhPJxLUJ0GYLsqlZz5cZDdqiER7V9uPQqvmYJz0SB8Dr+ueI8v3MEWwS3QDMesQodJiBVvZZi/tQ==
X-Received: by 2002:a17:906:ae10:: with SMTP id le16mr23039652ejb.296.1621861333704;
        Mon, 24 May 2021 06:02:13 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id gw6sm7493819ejb.86.2021.05.24.06.02.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 06:02:13 -0700 (PDT)
Date:   Mon, 24 May 2021 16:02:12 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-spi@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v3 net-next 1/2] net: dsa: sja1105: send multiple
 spi_messages instead of using cs_change
Message-ID: <20210524130212.g6jcf7y4grc64mki@skbuf>
References: <20210520211657.3451036-1-olteanv@gmail.com>
 <20210520211657.3451036-2-olteanv@gmail.com>
 <20210524083529.GA4318@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210524083529.GA4318@sirena.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 24, 2021 at 09:35:29AM +0100, Mark Brown wrote:
> On Fri, May 21, 2021 at 12:16:56AM +0300, Vladimir Oltean wrote:
> 
> > The fact of the matter is that spi_max_message_size() has an ambiguous
> > meaning if any non-final transfer has cs_change = true.
> 
> This is not the case, spi_message_max_size() is a limit on the size of a
> spi_message.

That is true, although it doesn't mean much, since in the presence of
cs_change, a spi_message has no correspondent in the physical world
(i.e. you can't look at a logic analyzer dump and say "this spi_message
was from this to this point"), and that is the problem really.
Describing the controller's inability to send more than N SPI words with
continuous chip select using spi_message_max_size() is what seems flawed
to me, but it's what we have, and what I've adapted to.
