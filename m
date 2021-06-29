Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5723B6BA8
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 02:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbhF2AXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 20:23:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232018AbhF2AXg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 20:23:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC3A961CED;
        Tue, 29 Jun 2021 00:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624926070;
        bh=1QPO1mcA+UJxp/Jc2BIHhK7gJ8qRdu2eQv8OZVQo7MY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kEgyuIMLG2eEYbt0wQ8cAf0KWqD+1v7jD6BIpqNSo+u5ewoUwlbfmeD0tfV0+vVEu
         XFWS/EgdseN22ACVyUIyJrAU0EdpQE/IbrxGPZNP+ZkhKESdFY9MdKY9f75R0ap7Bt
         S27fyKgda3ybt6j6TA5vHuKy0uCkgbCX58v9RD1HyAqVxyHkF3ZC8LGlD3Mq8SpnN/
         beTdTjM7f7EUHA36XYS3lOcojOnIRRkaKTRdpWEmYlnHaDYLsyCp8NRT7qk9fWqZSC
         yLrAsY2JayBQnHiQQlcbUPDGJ2WQ2TAQ7XsP0DAFXFoCOxuNEyyGYJJSS2cHnSbeWY
         7iglQo8faBZOQ==
Date:   Tue, 29 Jun 2021 02:21:06 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Kurt Cancemi <kurt@x64architecture.com>
Cc:     Marcin Wojtas <mw@semihalf.com>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/1] net: phy: marvell: Fixed handing of delays with
 plain RGMII interface
Message-ID: <20210629022106.58925d5f@thinkpad>
In-Reply-To: <CADujJWW=QbsRcrvF+7UxWZssMJ0iK1+xq+mfCTAVb7SkKKXcaA@mail.gmail.com>
References: <20210628192826.1855132-1-kurt@x64architecture.com>
        <20210628192826.1855132-2-kurt@x64architecture.com>
        <20210629004958.40f3b98c@thinkpad>
        <CAPv3WKfcHZ642S1SczFNMruq64H9E6x0KD5+bYWHcs3uu058cQ@mail.gmail.com>
        <CADujJWW=QbsRcrvF+7UxWZssMJ0iK1+xq+mfCTAVb7SkKKXcaA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Jun 2021 20:05:19 -0400
Kurt Cancemi <kurt@x64architecture.com> wrote:

> Well I'm sorry for the noise I was running into a lot of other DPAA
> ethernet related issues and overlooked adding phy-mode = "rgmii-id";
> that fixed the issue. I knew my patch was not correct (as I explained
> in the cover email) but I was not sure why it was necessary but now I
> see it was not necessary I just had "phy-connection-mode" instead of
> "phy-mode".
> 
> May I ask what is the purpose of phy-connection-mode? And why did the

phy-connection-type, not mode

> DPAA driver recognize the PHY interface mode as RGMII ID but the
> Marvell PHY driver didn't?

phy-mode and phy-connection-type are synonyms. phy-mode takes
precedence. Look at drivers/of/of_net.c function of_get_phy_mode().

If your device tree declares both, it can lead to confusion. For
example if dtsi file says
  phy-mode = "rgmii";
and you include this dtsi file but than you say
  phy-connection-type = "rgmii-id";
the kernel code will use rgmii, not rgmii-id, because phy-mode takes
precedence over phy-connection-type.

Marek
