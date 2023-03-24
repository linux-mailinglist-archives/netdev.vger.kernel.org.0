Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59B326C8823
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 23:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbjCXWLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 18:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbjCXWLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 18:11:06 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1202A2007B;
        Fri, 24 Mar 2023 15:10:36 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id er18so2028056edb.9;
        Fri, 24 Mar 2023 15:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679695833;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fxVZl65ppaYPFIKyRPyYl3dX0Inh16J0pYuSo0cJb7E=;
        b=UyazcQbd8gG65l601C3UsTA6yL+rW6fegRVIGG4AR5MPSmoOclYwoBIaUEfB5tP+Uq
         rCu2JU7emy41Ux5nokIxhqKI5J1MGBgzKiq59ICmxWzijxH6n7rvHon8VrCs2qGXCicn
         JeqQiuK3D9ZuZyfpl0GBuy/yq8CU89U5ELCSuZQs+aw/Ps4IOV2HwBPdyT6LPbiS1pn7
         3PubVrbdoPmEfaR6Ovkt1oQOvtuaDtYIZ6GjzPP+7eVM4U//NyJIpaKNfvQO6zzPjx1d
         HVVZ+l+j6rzCGOd9/ldOqhUDCiLkGPFnn4LRKAeKEvd0MU/t9Ta22+paV1ILG80q1y0M
         L/XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679695833;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fxVZl65ppaYPFIKyRPyYl3dX0Inh16J0pYuSo0cJb7E=;
        b=MiriGYTqrJSiZTSxpujIf4M/UrpYl89PUsiyCVqcXKxkrpWf5oJ4VlKqpVk6X9/fS7
         2j/zxJULp265tn9S1tmHSgxakiLSuXSSzhBO3S5KW03GMpkmNGR3cz4i9FjAbYhlzpgM
         il0b/MEWdF1zX4OvbiKGnQLQmjsb92cRcdLQiIjeRm8br3KP/N4dyGA2Xlhb8QtD/vMJ
         0qnBbcp5aoCDiIU4sZ+CnGlUDIoUDXWcNZc2kaPCV/FuD6AeugoSI/Dfcv0Ze5BLr9+o
         m/WS8aa21VUBFMqAIz63Jt13sEXXYYgWYpmg099Q4pfHf9DZiM8WNi7w1Lmjq8uymhcw
         DJQA==
X-Gm-Message-State: AAQBX9eNsOlb0+bBaqateqb3ZsqoKhloXFpLwzbtG76UiYr0h/gsQ96e
        oK56XVskW+ZpOp6hZXALwqE=
X-Google-Smtp-Source: AKy350bbbGxK21mLlRapiV4hrzxYhWbys8g59LNpWrccXWhmcAIuU/uIm4ympucH+j396toCfj8JlA==
X-Received: by 2002:a17:907:d09:b0:930:e634:3d52 with SMTP id gn9-20020a1709070d0900b00930e6343d52mr5565312ejc.24.1679695833228;
        Fri, 24 Mar 2023 15:10:33 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id zc14-20020a170906988e00b00927f6c799e6sm10931958ejb.132.2023.03.24.15.10.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 15:10:32 -0700 (PDT)
Date:   Sat, 25 Mar 2023 00:10:30 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Arun Ramadoss <Arun.Ramadoss@microchip.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexis =?utf-8?Q?Lothor=C3=A9?= <alexis.lothore@bootlin.com>
Subject: Re: [PATCH RESEND net-next v4 2/3] net: dsa: rzn1-a5psw: add support
 for .port_bridge_flags
Message-ID: <20230324221030.eps7xsbapwfzjxez@skbuf>
References: <20230314163651.242259-1-clement.leger@bootlin.com>
 <20230314163651.242259-3-clement.leger@bootlin.com>
 <20230314230821.kjiyseiqhat4apqb@skbuf>
 <20230316125329.75b290d4@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230316125329.75b290d4@fixe.home>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 12:53:29PM +0100, Clément Léger wrote:
> Le Wed, 15 Mar 2023 01:08:21 +0200,
> Vladimir Oltean <olteanv@gmail.com> a écrit :
> 
> > On Tue, Mar 14, 2023 at 05:36:50PM +0100, Clément Léger wrote:
> > > +static int a5psw_port_pre_bridge_flags(struct dsa_switch *ds, int port,
> > > +				       struct switchdev_brport_flags flags,
> > > +				       struct netlink_ext_ack *extack)
> > > +{
> > > +	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
> > > +			   BR_BCAST_FLOOD))
> > > +		return -EINVAL;
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int
> > > +a5psw_port_bridge_flags(struct dsa_switch *ds, int port,
> > > +			struct switchdev_brport_flags flags,
> > > +			struct netlink_ext_ack *extack)
> > > +{
> > > +	struct a5psw *a5psw = ds->priv;
> > > +	u32 val;
> > > +
> > > +	if (flags.mask & BR_LEARNING) {
> > > +		val = flags.val & BR_LEARNING ? 0 : A5PSW_INPUT_LEARN_DIS(port);
> > > +		a5psw_reg_rmw(a5psw, A5PSW_INPUT_LEARN,
> > > +			      A5PSW_INPUT_LEARN_DIS(port), val);
> > > +	}  
> > 
> > 2 issues.
> > 
> > 1: does this not get overwritten by a5psw_port_stp_state_set()?
> 
> Hum indeed. How is this kind of thing supposed to be handled ? Should I
> remove the handling of BR_LEARNING to forbid modifying it ? Ot should I
> allow it only if STP isn't enabled (which I'm not sure how to do it) ?

It's handled correctly by only enabling learning in port_stp_state_set()
if dp->learning allows it. See sja1105_bridge_stp_state_set():

	case BR_STATE_LEARNING:
		mac[port].dyn_learn = dp->learning;
		break;
	case BR_STATE_FORWARDING:
		mac[port].dyn_learn = dp->learning;

ocelot_bridge_stp_state_set():

	if ((state == BR_STATE_LEARNING || state == BR_STATE_FORWARDING) &&
	    ocelot_port->learn_ena)
		learn_ena = ANA_PORT_PORT_CFG_LEARN_ENA;

ksz_port_stp_state_set():

	case BR_STATE_LEARNING:
		if (!p->learning)
			data |= PORT_LEARN_DISABLE;
		break;
	case BR_STATE_FORWARDING:
		if (!p->learning)
			data |= PORT_LEARN_DISABLE;

> > enables flooding on the port after calling a5psw_port_bridge_leave().
> > So the port which has left a bridge is standalone, but it still forwards
> > packets to the other bridged ports!
> 
> Actually not this way because the port is configured in a specific mode
> which only forward packet to the CPU ports. Indeed, we set a specific
> rule using the PATTERN_CTRL register with the MGMTFWD bit set:
> When set, the frame is forwarded to the management port only
> (suppressing destination address lookup).

Ah, cool, this answers one of my issues in the other thread.

> However, the port will received packets *from* the other ports (which is
> wrong... I can handle that by not setting the flooding attributes if
> the port is not in bridge. Doing so would definitely fix the various
> problems that could happen.

hmm.. I guess that could work?
