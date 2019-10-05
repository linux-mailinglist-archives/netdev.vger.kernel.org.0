Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAECCC70F
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 02:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbfJEAwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 20:52:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33634 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbfJEAwi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 20:52:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5fkSqmsW15V+2JrsYC417O/Y+F5sBbsk+f7FjHM0tcY=; b=wAiPmHzn4JL+lm58UGz+QeBqP9
        j5QSq8PkttMoGcBxlPsvFUlRmrWIsdc5LsMMRhJ5VEs67JbNyo48wzt8XUKUiIf+U2Lz7YQjos8s1
        Ahin1/k783OpDtW7TzFqa10fQ54EuPMOBdq8zXmSJHE3miuKVj0lVyCJBtcnFcx4uDmY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iGYJH-00043I-4J; Sat, 05 Oct 2019 02:52:35 +0200
Date:   Sat, 5 Oct 2019 02:52:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 net-next 1/2] net: dsa: Add support for devlink device
 parameters
Message-ID: <20191005005235.GG3817@lunn.ch>
References: <20191004210934.12813-1-andrew@lunn.ch>
 <20191004210934.12813-2-andrew@lunn.ch>
 <20191004202122.GD32368@t480s.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191004202122.GD32368@t480s.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 04, 2019 at 08:21:22PM -0400, Vivien Didelot wrote:
> On Fri,  4 Oct 2019 23:09:33 +0200, Andrew Lunn <andrew@lunn.ch> wrote:
> > Add plumbing to allow DSA drivers to register parameters with devlink.
> > 
> > To keep with the abstraction, the DSA drivers pass the ds structure to
> > these helpers, and the DSA core then translates that to the devlink
> > structure associated to the device.
> > 
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > ---
> >  include/net/dsa.h | 23 +++++++++++++++++++++++
> >  net/dsa/dsa.c     | 48 +++++++++++++++++++++++++++++++++++++++++++++++
> >  net/dsa/dsa2.c    |  7 ++++++-
> >  3 files changed, 77 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/net/dsa.h b/include/net/dsa.h
> > index 8c3ea0530f65..6623f4428930 100644
> > --- a/include/net/dsa.h
> > +++ b/include/net/dsa.h
> > @@ -541,6 +541,29 @@ struct dsa_switch_ops {
> >  	 */
> >  	netdev_tx_t (*port_deferred_xmit)(struct dsa_switch *ds, int port,
> >  					  struct sk_buff *skb);
> > +	/* Devlink parameters */
> > +	int	(*devlink_param_get)(struct dsa_switch *ds, u32 id,
> > +				     struct devlink_param_gset_ctx *ctx);
> > +	int	(*devlink_param_set)(struct dsa_switch *ds, u32 id,
> > +				     struct devlink_param_gset_ctx *ctx);
> 
> Unless that is how devlink is designed, shouldn't ctx be const on _set?

It is the way devlink is designed. The devlink structure is

truct devlink_param {
        u32 id;
        const char *name;
        bool generic;
        enum devlink_param_type type;
        unsigned long supported_cmodes;
        int (*get)(struct devlink *devlink, u32 id,
                   struct devlink_param_gset_ctx *ctx);
        int (*set)(struct devlink *devlink, u32 id,
                   struct devlink_param_gset_ctx *ctx);
        int (*validate)(struct devlink *devlink, u32 id,
                        union devlink_param_value val,
                        struct netlink_ext_ack *extack);
};

No const on set.

   Andrew
