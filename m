Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4D5D84A5
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 02:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388022AbfJPAFD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 15 Oct 2019 20:05:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42048 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbfJPAFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 20:05:03 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1160311F5F624;
        Tue, 15 Oct 2019 17:05:02 -0700 (PDT)
Date:   Tue, 15 Oct 2019 17:04:59 -0700 (PDT)
Message-Id: <20191015.170459.2090609203514838368.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     scott.branden@broadcom.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, phil@raspberrypi.org,
        jonathan@raspberrypi.org, matthias.bgg@kernel.org,
        linux-rpi-kernel@lists.infradead.org, wahrenst@gmx.net,
        nsaenzjulienne@suse.de, opendmb@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: bcmgenet: Generate a random MAC if
 none is valid
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191015153955.2e602903@cakuba.netronome.com>
References: <20191014212000.27712-1-f.fainelli@gmail.com>
        <dda8587a-0734-d294-5b50-0f5f35c27918@broadcom.com>
        <20191015153955.2e602903@cakuba.netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Oct 2019 17:05:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Tue, 15 Oct 2019 15:39:55 -0700

> On Tue, 15 Oct 2019 15:32:28 -0700, Scott Branden wrote:
>> > @@ -3482,7 +3476,12 @@ static int bcmgenet_probe(struct platform_device *pdev)
>> >   
>> >   	SET_NETDEV_DEV(dev, &pdev->dev);
>> >   	dev_set_drvdata(&pdev->dev, dev);
>> > -	ether_addr_copy(dev->dev_addr, macaddr);
>> > +	if (IS_ERR_OR_NULL(macaddr) || !is_valid_ether_addr(macaddr)) {
>> > +		dev_warn(&pdev->dev, "using random Ethernet MAC\n");  
>> 
>> I would still consider this warrants a dev_err as you should not be 
>> using the device with a random MAC address assigned to it.  But I'll 
>> leave it to the "experts" to decide on the print level here.
> 
> FWIW I'd stick to warn for this message since this is no longer a hard
> failure.

Agreed.
