Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E8D1CCCC5
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 20:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbgEJSAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 14:00:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728123AbgEJSAQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 14:00:16 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A51512082E;
        Sun, 10 May 2020 18:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589133616;
        bh=bm937qa0g14GW3Sr3DXXEaKI+z0a5+7m4i2VZMSO2pM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CSC1cSoDffEnhpzRycizpLTLk4t2ZncLbNRK2mfMpAu9hZEDz2hjWDdAyzoeWB2h0
         aDsJ9J7OZyAygRaN0aVmOuuNzKK+ncpXjMqF4aYw9QEzhkNPhwkP+NAnf2j7bsyrBW
         rLBMWsQQD4y4J8leE3lF2WF4Mx1rmku2bS8jV69E=
Date:   Sun, 10 May 2020 11:00:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>, michael@walle.cc
Subject: Re: [PATCH net-next v3 06/10] net: ethtool: Add infrastructure for
 reporting cable test results
Message-ID: <20200510110013.0ae22016@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200510160758.GN362499@lunn.ch>
References: <20200509162851.362346-1-andrew@lunn.ch>
        <20200509162851.362346-7-andrew@lunn.ch>
        <20200510151226.GI30711@lion.mk-sys.cz>
        <20200510160758.GN362499@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 May 2020 18:07:58 +0200 Andrew Lunn wrote:
> On Sun, May 10, 2020 at 05:12:26PM +0200, Michal Kubecek wrote:
> > On Sat, May 09, 2020 at 06:28:47PM +0200, Andrew Lunn wrote:  
> > > Provide infrastructure for PHY drivers to report the cable test
> > > results.  A netlink skb is associated to the phydev. Helpers will be
> > > added which can add results to this skb. Once the test has finished
> > > the results are sent to user space.
> > > 
> > > When netlink ethtool is not part of the kernel configuration stubs are
> > > provided. It is also impossible to trigger a cable test, so the error
> > > code returned by the alloc function is of no consequence.
> > > 
> > > v2:
> > > Include the status complete in the netlink notification message
> > > 
> > > Signed-off-by: Andrew Lunn <andrew@lunn.ch>  
> > 
> > Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
> > 
> > It seems you applied the changes to ethnl_cable_test_alloc() suggested
> > in v2 review as part of patch 7 rather than here. I don't think it's
> > necessary to fix that unless there is some actual problem that would
> > require a resubmit.  
> 
> Hi Michal
> 
> Yes, squashed it into the wrong patch. But since all it does it change
> one errno for another, it is unlikely to break bisect. As i agree, we
> can live with this.

Sorry Andrew, would you mind doing one more quick spin? :(

Apart from what Michal pointed out there is a new line added after
ETHTOOL_A_TSINFO_MAX in patch 3 and removed in patch 4. 

More importantly we should not use the ENOTSUPP error code, AFAIU it's
for NFS, it's not a standard error code and user space struggles to
translate it with strerror(). Would you mind replacing all ENOTSUPPs
with EOPNOTSUPPs?
