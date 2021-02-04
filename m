Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D373B30F924
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 18:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238185AbhBDRHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 12:07:54 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48488 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238298AbhBDRBR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 12:01:17 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l7hzW-004Dmc-Mr; Thu, 04 Feb 2021 18:00:26 +0100
Date:   Thu, 4 Feb 2021 18:00:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net] net: dsa: call teardown method on probe failure
Message-ID: <YBwoKiRlOmi3my5G@lunn.ch>
References: <20210204163351.2929670-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210204163351.2929670-1-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 04, 2021 at 06:33:51PM +0200, Vladimir Oltean wrote:
> Since teardown is supposed to undo the effects of the setup method, it
> should be called in the error path for dsa_switch_setup, not just in
> dsa_switch_teardown.

I disagree with this. If setup failed, it should of cleaned itself up.
That is the generally accepted way of doing things. If a function is
going to exit with an error, it should first undo whatever it did
before exiting.

You are adding extra semantics to the teardown op. It can no longer
assume setup was successful. So it needs to be very careful about what
it tears down, it cannot assume everything has been setup. I doubt the
existing implementations actually do that.

   Andrew
