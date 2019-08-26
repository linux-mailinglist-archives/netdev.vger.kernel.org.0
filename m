Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F73C9D5FC
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 20:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387396AbfHZSr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 14:47:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60506 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732007AbfHZSr2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 14:47:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3SctyFfS3yLn1lHEdyI1Kmom1XhY5J/W6bf5Yp9jBk8=; b=NxdnwwNC6gy91psyhP3LpADnOt
        KowX/CZGwKAahaI/D87i4FITICTVSiOGY4G928NklYtshAJ0hNMa5egvajC4/p6J7LWzi2Z6SyXZt
        +m8PtTOvJ4r580w9m3M4V38H8PCmaYRpXfY3kWQ6W2RJ+oWiEmFjnkT7nuA/IVpq+2fs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i2K1P-00067N-EL; Mon, 26 Aug 2019 20:47:19 +0200
Date:   Mon, 26 Aug 2019 20:47:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Voon Weifeng <weifeng.voon@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: Re: [PATCH v1 net-next] net: stmmac: Add support for MDIO interrupts
Message-ID: <20190826184719.GF2168@lunn.ch>
References: <1566870320-9825-1-git-send-email-weifeng.voon@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566870320-9825-1-git-send-email-weifeng.voon@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 09:45:20AM +0800, Voon Weifeng wrote:
> From: "Chuah, Kim Tatt" <kim.tatt.chuah@intel.com>
> 
> DW EQoS v5.xx controllers added capability for interrupt generation
> when MDIO interface is done (GMII Busy bit is cleared).
> This patch adds support for this interrupt on supported HW to avoid
> polling on GMII Busy bit.
> 
> stmmac_mdio_read() & stmmac_mdio_write() will sleep until wake_up() is
> called by the interrupt handler.

Hi Voon

I _think_ there are some order of operation issues here. The mdiobus
is registered in the probe function. As soon as of_mdiobus_register()
is called, the MDIO bus must work. At that point MDIO read/writes can
start to happen.

As far as i can see, the interrupt handler is only requested in
stmmac_open(). So it seems like any MDIO operations after probe, but
before open are going to fail?

Thanks
       Andrew
