Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2243B11BA9F
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 18:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730267AbfLKRtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 12:49:40 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48438 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729524AbfLKRtk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 12:49:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jmd4oZRB2oaaUlAC2mwLSvTh0bdmsKNKQFZo0Gn+F3A=; b=U5DagJe+yC0Wu+COqr/tTppK7P
        CrkQAOxLhjSki0cXrEmtCGaCpMckpmHlJ41DlcFvb3lKOKVcMHrsYkAp0CD8wVstIfHvJxXkc3S2j
        /xu0CX8WHMZ9pOF4VeSWY5Msl9pcQRhc+rmrxOdb6fjelVXtIfzJYMtTone8kqKf2w5M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1if67G-0006MF-6l; Wed, 11 Dec 2019 18:49:38 +0100
Date:   Wed, 11 Dec 2019 18:49:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>, netdev@vger.kernel.org,
        Denis Odintsov <d.odintsov@traviangames.com>,
        Hubert Feurstein <h.feurstein@gmail.com>
Subject: Re: [BUG] mv88e6xxx: tx regression in v5.3
Message-ID: <20191211174938.GB30053@lunn.ch>
References: <87tv67tcom.fsf@tarshish>
 <20191211131111.GK16369@lunn.ch>
 <87fthqu6y6.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fthqu6y6.fsf@tarshish>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Bisect points at 7fb5a711545d ("net: dsa: mv88e6xxx: drop adjust_link to
> enabled phylink"). Reverting this commit on top of v5.3.15 fixes the
> issue (and brings the warning back). As I understand, this basically
> reverts the driver migration to phylink. What might be the issue with
> phylink?

That suggests the MAC is wrongly running at 1G, and the PHY at 100M,
which is why it does not work.

You probably want to add #define DEBUG to the top of phylink.c, and
scatter some debug prints in mv88e6xxx_mac_config(). My guess would
be, either mv88e6xxx_mac_config() is existing before configuring the
MAC, or mv88e6xxx_port_setup_mac() has wrongly decided nothing has
changed and so has not configured the MAC.

	Andrew
