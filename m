Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958A320440E
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 00:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731275AbgFVWts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 18:49:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:34278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730943AbgFVWtr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 18:49:47 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4719B2073E;
        Mon, 22 Jun 2020 22:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592866187;
        bh=2V6HAjG7opCc+ZDYvmLhiL4vCmwHjAGV4dXL2KgDUgU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pxkH1O/E5nimem1BAuyNZBPi7mq7aD5aqD4q3UynCIiX/IxGBdHGVz0HjWSEK72XO
         kwL+VVhb7zOH+Qj+fSgW/LJWeo7ZWtY/+tClGqJ8CG3lvnnheEOHUHc4vtBikwCwBW
         Oa1T8C9mi3Yc12/7OoPuIjNMjbf7DFepGPEdZl9o=
Date:   Mon, 22 Jun 2020 15:49:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: Re: [PATCH 03/11] net: devres: relax devm_register_netdev()
Message-ID: <20200622154943.02782b5a@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200622100056.10151-4-brgl@bgdev.pl>
References: <20200622100056.10151-1-brgl@bgdev.pl>
        <20200622100056.10151-4-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Jun 2020 12:00:48 +0200 Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> This devres helper registers a release callback that only unregisters
> the net_device. It works perfectly fine with netdev structs that are
> not managed on their own. There's no reason to check this - drop the
> warning.
> 
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

I think the reasoning for this suggestion was to catch possible UAF
errors. The netdev doesn't necessarily has to be from devm_alloc_* 
but it has to be part of devm-ed memory or memory which is freed 
after driver's remove callback.

Are there cases in practice where you've seen the netdev not being
devm allocated?
