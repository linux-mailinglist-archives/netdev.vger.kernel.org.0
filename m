Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5227242E4C
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 19:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgHLRwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 13:52:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbgHLRwW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Aug 2020 13:52:22 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58FD92078B;
        Wed, 12 Aug 2020 17:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597254742;
        bh=GU5wKUe7LsBFQ/MQDdWeINUdgK8/h6OmoCIEuIFpT10=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OaqUxrae3seo/A3yLHJeaNz46VM9rpt+EnRibARsHxrlURZF9LpC0l/TboIYFM10U
         oMAvcTnwR9oxxgWo2Wpy9z5f48BeT1ll+BO0Kck0hNYKS9VgRXHR7xAM65Ebzz9sZU
         ha3CS00G8vt+RviH7i5DmNr2lC1Dp6JR1xw8nfvw=
Date:   Wed, 12 Aug 2020 10:52:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <sameehj@amazon.com>,
        <ndagan@amazon.com>
Subject: Re: [PATCH V1 net 1/3] net: ena: Prevent reset after device
 destruction
Message-ID: <20200812105219.4c4e3e3b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200812101059.5501-2-shayagr@amazon.com>
References: <20200812101059.5501-1-shayagr@amazon.com>
        <20200812101059.5501-2-shayagr@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Aug 2020 13:10:57 +0300 Shay Agroskin wrote:
> This patch also removes the destruction of the timer and reset services
> from ena_remove() since the timer is destroyed by the destruction
> routine and the reset work is handled by this patch.

You'd still have a use after free if the work runs after the device is
removed. I think cancel_work_sync() gotta stay.
