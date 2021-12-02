Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24B3A46643B
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 14:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346740AbhLBNIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 08:08:17 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35678 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241818AbhLBNIP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 08:08:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=BVqw7MpQPVSfrDQsvcV3mEpYc9ny+418FpeFJbGTXoI=; b=Nqc00gKYLPUaP9IJ6SxkNolL0B
        C5yF+x7K+TfcW8sSmNtmJsnM2HBv/20tPDxVEbWz+A7MDHU95gJ7qGEmiHbXFHCdN/zT8qV6vhqIN
        lPYXoKBYpO/DQTCheykANxaISAZNdILEvEh+bmb8lK8g+I1FB/vxfd61p1HOjkg4OKpA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1msllV-00FKI4-Fu; Thu, 02 Dec 2021 14:04:45 +0100
Date:   Thu, 2 Dec 2021 14:04:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wells Lu =?utf-8?B?5ZGC6Iqz6aiw?= <wells.lu@sunplus.com>
Cc:     Wells Lu <wellslutw@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        Vincent Shih =?utf-8?B?5pa96YyV6bS7?= 
        <vincent.shih@sunplus.com>
Subject: Re: [PATCH net-next v3 2/2] net: ethernet: Add driver for Sunplus
 SP7021
Message-ID: <YajEbXtBwlDL4gOL@lunn.ch>
References: <1638266572-5831-1-git-send-email-wellslutw@gmail.com>
 <1638266572-5831-3-git-send-email-wellslutw@gmail.com>
 <YabsT0/dASvYUH2p@lunn.ch>
 <cf60c230950747ec918acfc6dda595d6@sphcmbx02.sunplus.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf60c230950747ec918acfc6dda595d6@sphcmbx02.sunplus.com.tw>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I printed out the value of 'supported' and 'advertising'.
> 'supported' shows PHY device supports Pause and AsymPause (0x62cf).
> But 'advertising' shows PHY device does not support Pause or AsymPause (0x02cf).
> Is this correct?
> 
> How to let link partner know local node supports 
> Pause & AsymPause (flow control)?
>

'supported' indicates that the PHY can do. It has the ability to
advertise pause. But we don't automatically copy those bits into
'advertising' because we don't know if the MAC actually supports
pause/asym pause.

The MAC driver needs to call phy_support_sym_pause() or
phy_support_asym_pause() to let phylib know what it can do. phylib
will then add the appropriate bits to 'advertising'.

> Will mii_read() and mii_write() be called in interrupt context?

No. Only thread context, because it uses a mutex to prevent multiple
accesses at the same time.

	 Andrew
