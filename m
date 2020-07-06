Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38BCB215F12
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 20:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729815AbgGFSya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 14:54:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729723AbgGFSy3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 14:54:29 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA52C206B6;
        Mon,  6 Jul 2020 18:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594061669;
        bh=HzID5Om1HnGgvtiQfrJds62KVOO5oQytyNYfEh5EEfM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=egsDbD1Qr1UfPfBNnQQqs3Yh1EU8pbn/cs04DZ0uzS3zCcL71aN43vo9FBLeYERlV
         qxojRT7tstSVqRECmyjKrHWFA0ajjuepp/TtGPt4uQvlQUf/E3aWifyYJCFY4YBixq
         CsrITk5XxKPlpbzs8U6KXzHmzvM0F3qyRdaHcbis=
Date:   Mon, 6 Jul 2020 11:54:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 3/3] net: ethtool: Remove PHYLIB direct
 dependency
Message-ID: <20200706115427.36e4cff2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <262dbde0-2a0e-6820-fd69-157b7f05a8c4@gmail.com>
References: <20200706042758.168819-1-f.fainelli@gmail.com>
        <20200706042758.168819-4-f.fainelli@gmail.com>
        <20200706114000.223e27eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <262dbde0-2a0e-6820-fd69-157b7f05a8c4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Jul 2020 11:45:38 -0700 Florian Fainelli wrote:
> On 7/6/2020 11:40 AM, Jakub Kicinski wrote:
> > On Sun,  5 Jul 2020 21:27:58 -0700 Florian Fainelli wrote:  
> >> +	ops = ethtool_phy_ops;
> >> +	if (!ops || !ops->start_cable_test) {  
> > 
> > nit: don't think member-by-member checking is necessary. We don't
> > expect there to be any alternative versions of the ops, right?  
> 
> There could be, a network device driver not using PHYLIB could register
> its own operations and only implement a subset of these operations.

I'd strongly prefer drivers did not insert themselves into
subsys-to-subsys glue :S

> > We could even risk a direct call:
> > 
> > #if IS_REACHABLE(CONFIG_PHYLIB)
> > static inline int do_x()
> > {
> > 	return __do_x();
> > }
> > #else
> > static inline int do_x()
> > {
> > 	if (!ops)
> > 		return -EOPNOTSUPP;
> > 	return ops->do_x();
> > }
> > #endif
> > 
> > But that's perhaps doing too much...  
> 
> Fine either way with me, let us see what Michal and Andrew think about that.

Ack, let's hear it :)
