Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D22440F75A
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 14:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243276AbhIQMWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 08:22:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46180 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232880AbhIQMWo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 08:22:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ZXk8POf9xloOumdtczqRSIGFEQphjzL3fTseGtszg3c=; b=tn8wu8TF/6fHkkMlO9UfLt98I1
        ykQb3JCO5/bJv13MkXsZ954VX5FF8Ca2XtYcjNlpX3WZRkX/2Lu2fwWN7puXg79TruzwSOVLDvcxR
        3NoTxCtTH3mGerKSMS3j/eZkoyOTkV5H1TeqFo1HD7cDZejBxH5t1LmgfR64UXacrlkA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mRCrk-0074AE-ES; Fri, 17 Sep 2021 14:21:16 +0200
Date:   Fri, 17 Sep 2021 14:21:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH net-next 0/4] net: dsa: b53: Clean up CPU/IMP ports
Message-ID: <YUSIPMBSAT93oZKo@lunn.ch>
References: <20210916120354.20338-1-zajec5@gmail.com>
 <7c5e1cf8-2d98-91df-fc6b-f9edfa0f23c9@gmail.com>
 <a8a684ce-bede-b1f1-1f7a-31e71dca3fd3@gmail.com>
 <1568bbc3-1652-7d01-2fc7-cb4189c71ad2@gmail.com>
 <20210917100051.254mzlfxwvaromcn@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210917100051.254mzlfxwvaromcn@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > That DSA_PORT_TYPE_UNUSED would probably require investigating DSA & b53
> > behaviour *and* discussing it with DSA maintainer to make sure we don't
> > abuse that.
> 
> How absent are these ports in hardware? For DSA_PORT_TYPE_UNUSED we do
> register a devlink port, but if those ports are really not present in
> hardware, I'm thinking maybe the easiest way would be to supply a
> ds->disabled_port_mask before dsa_register_switch(), and DSA will simply
> skip those ports when allocating the dp, the devlink_port etc. So you
> will literally have nothing for them.

The basic idea seems O.K, we just need to be careful.

We have code like:

static inline bool dsa_is_dsa_port(struct dsa_switch *ds, int p)
{
	return dsa_to_port(ds, p)->type == DSA_PORT_TYPE_DSA;
}

static inline bool dsa_is_user_port(struct dsa_switch *ds, int p)
{
	return dsa_to_port(ds, p)->type == DSA_PORT_TYPE_USER;
}

dsa_to_port(ds, p) will return NULL, and then bad things will happen.

Maybe it would be safer to add DSA_PORT_TYPE_PHANTOM and do allocate
the dp?

    Andrew
