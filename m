Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477463AB60A
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 16:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbhFQOhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 10:37:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42856 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232816AbhFQOhp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 10:37:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Lv7YF61cRg5b+c6h339gNfE39+KuqQcnJ+b/h7HNkMs=; b=QUfvcRzR4oJjA4WPHLIaSqaKAk
        NYz7dnytOzzG4oSiSmqxRHWmpYnbhfClg78+4VOjhM+LtXPV66UqQbj/jwfN6S+z8hBmqpLTYiXX3
        3VL9VoFd0eG8AvLXtXdTZ97gf0YK0iVDeyIsrQP2f01nXPWpRpNF6kJzsu7JJR7wGFe8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ltt75-009vTA-Id; Thu, 17 Jun 2021 16:35:23 +0200
Date:   Thu, 17 Jun 2021 16:35:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Gatis Peisenieks <gatis@mikrotik.com>
Cc:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        hkallweit1@gmail.com, jesse.brandeburg@intel.com,
        dchickles@marvell.com, tully@mikrotik.com, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] atl1c: improve reliability of mdio ops on Mikrotik
 10/25G NIC
Message-ID: <YMtdq1SbLqM65vBq@lunn.ch>
References: <20210617122553.2970190-1-gatis@mikrotik.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617122553.2970190-1-gatis@mikrotik.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 17, 2021 at 03:25:53PM +0300, Gatis Peisenieks wrote:
> MDIO ops on Mikrotik 10/25G NIC can occasionally take longer
> to complete. This increases the timeout from 1.2 to 12ms.

That seems a very long time. A C22 transaction is 64 bits, and it is
clocked out at 2.5MHz. So it should take (1/2.5*1000*1000)*64 =
0.0000256s, i.e. 0.0256ms. 1.2ms is already 50 times longer than
needed, and now you are suggesting to make it 500 times longer than
needed?

Are you sure there is not something else going on here?  I notice
atl1c_stop_phy_polling() does not check the return from
atl1c_wait_mdio_idle(). Maybe this is your problem, you are not
waiting long enough for the MAC to stop directly accessing the PHY?

	Andrew
