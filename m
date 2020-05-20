Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3BA1DBDAF
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 21:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgETTMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 15:12:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726548AbgETTMy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 15:12:54 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D263E206B6;
        Wed, 20 May 2020 19:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590001974;
        bh=RkadoWIBanOCKs885+ED7RmQ3OubhGzfviJ/NcHqSpQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rw5tsy8H36Pu1JKsNiiFQqBkB5Pi/LVWydxf1b3yMRdALCSv6dIW3zZDKsU2GkOZl
         YKnl/9CvPINgEOxX+KrsSaiqjsC7kjKV8/n8PtTdjnOT3/oZZAZlVCT//TSiq1+U9O
         ZgWXAwhzaW+rd1AaRHqY43xqOwKyoclx6KuzrZUA=
Date:   Wed, 20 May 2020 12:12:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffic
 classes
Message-ID: <20200520121252.6cee8674@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <VI1PR0402MB3871686102702FC257853855E0B60@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200515184753.15080-1-ioana.ciornei@nxp.com>
        <VI1PR0402MB387165B351F0DF0FA1E78BF4E0BD0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200515124059.33c43d03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB3871F0358FE1369A2F00621DE0BD0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200515152500.158ca070@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB38719FE975320D9E0E47A6F9E0BA0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200518123540.3245b949@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB387101A0B3D3382B08DBE07CE0B90@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200519114342.331ff0f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB387192A5F1A47C6779D0958DE0B90@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200519143525.136d3c3c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB3871686102702FC257853855E0B60@VI1PR0402MB3871.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 May 2020 15:10:42 +0000 Ioana Ciornei wrote:
> DPAA2 has frame queues per each Rx traffic class and the decision from which queue
> to pull frames from is made by the HW based on the queue priority within a channel
> (there is one channel per each CPU).

IOW you're reading the descriptor for the device memory/iomem address
and the HW will return the next descriptor based on configured priority?
Presumably strict priority?

> If this should be modeled in software, then I assume there should be a NAPI instance
> for each traffic class and the stack should know in which order to call the poll()
> callbacks so that the priority is respected.

Right, something like that. But IMHO not needed if HW can serve the
right descriptor upon poll.
