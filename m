Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF2FD33D2D
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 04:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfFDCdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 22:33:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52854 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726076AbfFDCdE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 22:33:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fie5ERCs911I94NFylM12bqG6AyLU002nW6NZ0D4OsM=; b=WF9NgS5UKt1n4f+4aNQE5UkZfQ
        vUf2cciiO9D0VBekBSNacYIjozWRPs3thEidJ7wxf4dUCs5vBbd3iKB5xyYXx8mYQulfmaRZoQ4Nj
        DYLzz1OHEuHUOv9hvGlvlf1l/3VZz0vT0Ow/gFmdyS1AnR15lXuA9pbUEzZ3irmPzZ7E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hXzG1-0001Yo-SI; Tue, 04 Jun 2019 04:33:01 +0200
Date:   Tue, 4 Jun 2019 04:33:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org, anirudh@xilinx.com, John.Linn@xilinx.com
Subject: Re: [PATCH net-next 05/18] net: axienet: Allow explicitly setting
 MDIO clock divisor
Message-ID: <20190604023301.GK17267@lunn.ch>
References: <1559599037-8514-1-git-send-email-hancock@sedsystems.ca>
 <1559599037-8514-6-git-send-email-hancock@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559599037-8514-6-git-send-email-hancock@sedsystems.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 03:57:04PM -0600, Robert Hancock wrote:
> This driver was previously always calculating the MDIO clock divisor
> (from AXI bus clock to MDIO bus clock) based on the CPU clock frequency,
> but that simplistic method only works on the MicroBlaze platform. This
> really has to be a platform configuration setting as there is no way the
> kernel can know the clock speed of the AXI bus in the general case.
> 
> Add an optional xlnx,mdio-clock-divisor device tree property that can be
> used to explicitly set the MDIO bus divisor. This must be set based on the
> AXI bus clock rate being used in the FPGA logic so that the resulting
> MDIO clock rate is no greater than 2.5 MHz.

Rather than the clock divisor, the binding should reference the clock,
using the standard DT clock properties. You can then
clk_prepare_enable() the clock to ensure nobody turns it off. You can
get its rate in order to calculate the divisor. And it lays the
foundation for power saving in that you can turn the clock off between
MDIO transactions, using the runtime PM APIS.

     Andrew
