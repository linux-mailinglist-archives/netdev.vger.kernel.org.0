Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE2E81EDB76
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 04:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgFDC5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 22:57:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgFDC5C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jun 2020 22:57:02 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 675D9206C3;
        Thu,  4 Jun 2020 02:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591239421;
        bh=Tb84IRzoycfngaQnbYDYH0G0XRCPsYUWREAd8iOgSD0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YFxoeIRDS+i8g8WjBt+7V2yi1B/KQYxm0uEb/VWYSGOUgfGTg/xAiXjVZ9N73bxgb
         lv/IAIguzONGYO2UNBe/U2UVJ5e6S8wk7GvIibZ/5Qw1bU/xgUkkDC2JNnapekHBN8
         3HstGoYOqEr2lYsl3Ude4dB4GVR4VkLKFUethINc=
Date:   Wed, 3 Jun 2020 19:56:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next 10/11] net/mlx5e: kTLS, Add kTLS RX resync support
Message-ID: <20200603195659.4d6a1060@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3895f115-6a0b-29ff-83b9-7e099819a570@mellanox.com>
References: <20200529194641.243989-1-saeedm@mellanox.com>
        <20200529194641.243989-11-saeedm@mellanox.com>
        <20200529131631.285351a5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <e0b8a4d9395207d553e46cb28e38f37b8f39b99d.camel@mellanox.com>
        <20200529145043.5d218693@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <27149ee9-0483-ecff-a4ec-477c8c03d4dd@mellanox.com>
        <20200601151206.454168ad@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <4f07f3e0-8179-e70a-71a5-9f0407b709d6@mellanox.com>
        <20200602113148.47c2daea@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <3895f115-6a0b-29ff-83b9-7e099819a570@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Jun 2020 10:02:33 +0300 Tariq Toukan wrote:
> > IIUC the HW asks for a resync at the first record after a specific seq
> > (the record header is in the frame that carried the OOO marking, right?)
> > 
> > Can we make the core understand those semantics and avoid trying to
> > resync at the wrong record?
> 
> HW asks for a resync when it is in tracking mode and identifies the 
> magic, so it calculates the expected seq of next record.
> This seq is not part of the completion (for now, this is a planned 
> enhancement), so the device driver posts a request to the device to get 
> the seq, and then the driver hopefully approve it (by another post to 
> the HW) after comparing it to the stack sw seq.
> 
> As long as the device driver does not know the HW expected seq, it 
> cannot provide a seq to the stack. So force resync is used.

Right, what I was trying to say is that the HW will likely latch on the
first magic in the TCP segment, so maybe the driver and the core can
reasonably expect that. Driver can tell the core to provide first
record after TCP seq_no X. Otherwise if the TCP socket is backed up
driver may get a very old record.

Just clarifying what I was trying to say, not sure how that fits your
device.

> We can think of an optimization here, it is doable.
