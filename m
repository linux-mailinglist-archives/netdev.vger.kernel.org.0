Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8185B46C7AF
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 23:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbhLGWu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 17:50:27 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44020 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242250AbhLGWu0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 17:50:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=lHPnHA1nU3LhV/++RjTXfkaI1ue59guv+6zmLEaU6I4=; b=MkIxEUwL55Vv/nig/31ZujtMJN
        ElwqwHiGg6pDJ/26rcisPncK434MXpcfHbPxPmnSqZKfngmz8NsDGNc+F006ImvekFK3eTrkliJ+h
        v3dz+vHtzX+Cqfal3o0TWiv4rLAeYHeGslqgmSD0AEiNi2DEzRppuFpjCksI6T9FkMu8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mujEa-00FouQ-JF; Tue, 07 Dec 2021 23:46:52 +0100
Date:   Tue, 7 Dec 2021 23:46:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 0/6] Add support for qca8k mdio rw in
 Ethernet packet
Message-ID: <Ya/kXHBuWiKLLqGQ@lunn.ch>
References: <20211207145942.7444-1-ansuelsmth@gmail.com>
 <Ya+q02HlWsHMYyAe@lunn.ch>
 <61afadb9.1c69fb81.7dfad.19b1@mx.google.com>
 <Ya+yzNDMorw4X9CT@lunn.ch>
 <61afb452.1c69fb81.18c6f.242e@mx.google.com>
 <20211207205219.4eoygea6gey4iurp@skbuf>
 <61afd6a1.1c69fb81.3281e.5fff@mx.google.com>
 <Ya/esX+GTet9PM+D@lunn.ch>
 <61afe087.1c69fb81.45db8.5d80@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61afe087.1c69fb81.45db8.5d80@mx.google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > 1) The tagger needs somewhere to store its own private data.
> > 2) The tagger needs to share state with the switch driver.
> > 
> > We can probably have the DSA core provide 1). Add the size to
> > dsa_device_ops structure, and provide helpers to go from either a
> > master or a slave netdev to the private data.
> 
> I'm just implementing this. It doesn't look that hard.
> 
> > 
> > 2) is harder. But as far as i know, we have an 1:N setup.  One switch
> > driver can use N tag drivers. So we need the switch driver to be sure
> > the tag driver is what it expects. We keep the shared state in the tag
> > driver, so it always has valid data, but when the switch driver wants
> > to get a pointer to it, it needs to pass a enum dsa_tag_protocol and
> > if it does not match, the core should return -EINVAL or similar.
> > 
> 
> Mhh this looks a bit complex. I'm probably missing something but why the
> tagger needs to share a state? To check if it does support some feature?
> If it's ready to be used for mdio Ethernet? Or just to be future-proof?

This is the general problem we have, and it might not be relevant for
this specific problem of MDIO over Ethernet.

tag_sja1105 wants access to a queue of frames and a work queue shared
with switch driver.

tag_ocelot_8021q has something similar to tag_sja1105.

tag_lan9303 wants to know if its two ports are in the same bridge.

	Andrew
