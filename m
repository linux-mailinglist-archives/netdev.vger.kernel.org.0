Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCAD413C05
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 23:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235254AbhIUVKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 17:10:31 -0400
Received: from mail-oi1-f171.google.com ([209.85.167.171]:36368 "EHLO
        mail-oi1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235238AbhIUVK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 17:10:28 -0400
Received: by mail-oi1-f171.google.com with SMTP id y201so1178268oie.3;
        Tue, 21 Sep 2021 14:08:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PB7mw84oWqMcTM8L33Z/mqiJNX2vqTIfyYp6vIibYpQ=;
        b=pv5Uonr5OTyBh2ro0cq896BUghHzrOeg109cypv38nh8xdUBuw4Y0NoHhcRtiLl1vK
         zNvH3PewPp4yi6HiBxCz/f23AmBem56k8Pk5VPL5l71i46mwsjyBqnR81tCN/QfJAB6a
         oTjk8p50KXDU+3uMxyf1Et+dqgMrLto4p0MqAfxB5MTDC69d2GCWPmf9T2Rom1q/DO6h
         1ptxleM93rPezIV3mTJvoo/Fu+VGRp91u+V06+bwLs1W81SmBBNC9apKnYkuQ0yUZ0MT
         XnNok0JrEGqUFOie8TEILIo7C6FihuheQSurqO8cFoIttJAMUHBk01qbd7/dY7D97H3g
         h3Hg==
X-Gm-Message-State: AOAM533Nb227Kh6CMEuN2NHBjCPmFTllXooOA4YUQSHLqtnTYrPMnnBr
        otcHH6a8Mta/Z/xYU+EvXrhx952gqQ==
X-Google-Smtp-Source: ABdhPJxByD/gT2HO03lqHDDuqXU2J4bZP7al9mfky5LLkibhzk5AFWSWOQomZ1O5Dw3nMMFhFgp1aA==
X-Received: by 2002:a54:4e1d:: with SMTP id a29mr5287079oiy.7.1632258539121;
        Tue, 21 Sep 2021 14:08:59 -0700 (PDT)
Received: from robh.at.kernel.org (rrcs-192-154-179-36.sw.biz.rr.com. [192.154.179.36])
        by smtp.gmail.com with ESMTPSA id g23sm33684otl.23.2021.09.21.14.07.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 14:08:58 -0700 (PDT)
Received: (nullmailer pid 3326678 invoked by uid 1000);
        Tue, 21 Sep 2021 21:07:39 -0000
Date:   Tue, 21 Sep 2021 16:07:39 -0500
From:   Rob Herring <robh@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Stefan Wahren <stefan.wahren@i2se.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Heimpold <michael.heimpold@in-tech.com>,
        jimmy.shen@vertexcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH RFC 3/3] net: vertexcom: Add MSE102x SPI support
Message-ID: <YUpJm0G7X7DB3oKD@robh.at.kernel.org>
References: <20210914151717.12232-1-stefan.wahren@i2se.com>
 <20210914151717.12232-4-stefan.wahren@i2se.com>
 <YUJi0cVawjyiteEx@lunn.ch>
 <bfbbf816-f467-7e2e-12ca-fb2172ce93f9@i2se.com>
 <YUM6HfDYX0Twe67+@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUM6HfDYX0Twe67+@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 16, 2021 at 02:35:41PM +0200, Andrew Lunn wrote:
> > >> +	netif_carrier_off(mse->ndev);
> > >> +	ndev->if_port = IF_PORT_10BASET;
> > > That is not correct. Maybe you should add a IF_PORT_HOMEPLUG ?
> 
> 
> > There is already a driver (qca_spi, qcauart) for a similiar Homeplug
> > device (QCA7000), which also uses IF_PORT_10BASET. Should i change this
> > too or leave it because of resulting changes to userspace?
> 
> Technically, it would be an ABI change. But ifmap seems pretty loosely
> defined. See man 7 netdevice:
> 
>        SIOCGIFMAP, SIOCSIFMAP
>               Get or set the interface's hardware parameters using ifr_map.
> 	      Setting the parameters is a privileged operation.
> 
>                   struct ifmap {
>                       unsigned long   mem_start;
>                       unsigned long   mem_end;
>                       unsigned short  base_addr;
>                       unsigned char   irq;
>                       unsigned char   dma;
>                       unsigned char   port;
>                   };
> 
>               The interpretation of the ifmap structure depends on the device driver
> 	      and the architecture.
> 
> The if_port value ends up in port. And i've no idea where it is
> actually available in user space. iproute2 does not use it, nor
> ethtool. So, i would say, submit a separate patch for the other
> drivers, and we will see if anybody notices.
> 
> > >> +static const struct of_device_id mse102x_match_table[] = {
> > >> +	{ .compatible = "vertexcom,mse1021" },
> > >> +	{ .compatible = "vertexcom,mse1022" },
> > > Is there an ID register you can read to determine what device you
> > > actually have? If so, i suggest you verify the correct compatible is
> > > used.
> > 
> > AFAIK the device doesn't have any kind of ID register.
> 
> Then i would suggest changing the compatible to "vertexcom,mse102x".

Don't use wildcards in compatible strings.

> 
> If you cannot verify it, and it makes no actual difference, then 50%
> of the boards will use the wrong one. Which means you can then later
> not actually make use of it to enable features specific to a
> compatible string.

A wildcard doesn't help with this. If some boards are wrong, not any way 
we can fix that short of a DT update. If you can update the DT, then you 
can correct the string then.

Rob
