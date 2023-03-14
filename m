Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 549E56BA35A
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 00:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbjCNXI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 19:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjCNXI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 19:08:26 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871C543470;
        Tue, 14 Mar 2023 16:08:25 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id y4so39127706edo.2;
        Tue, 14 Mar 2023 16:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678835304;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jvmGVDEzmPPLoccnkwji0Qxa4oXf8h5vE1XEFGmmxW8=;
        b=eOyXOmUee5BwB4IC5sCf/yCpGXIsEQpsHqEBW3Iuuy5MR9XP5GxEFLBBqFqstbsR1l
         bVLDr2ewlYn2ZyJgNxo39hVl86mlG0vgh759IHBUWoOKmbedirnQCbn/pEFd4ZpP/WHm
         wdJZhMoPuJcBVl4uyPPYccAYwBS5i1LokMEr/vnaqTR/ZSRbyPaR/4M0r/9sgSwxQEoI
         vmLyI2j6n6+01gHYpm8ip8JxuWoflV736hSif9flwO7+oujpQdxVB7WNBYjvvmzk9AwG
         sYuh6c8dLQdO6LPLIKtuybfFpHUiJaxrT56yz8BoVhktw2h4JExtgutIpYFWYpmjZqni
         3nTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678835304;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jvmGVDEzmPPLoccnkwji0Qxa4oXf8h5vE1XEFGmmxW8=;
        b=1obbz2+Y2qbet+48RrJ/Qk0SyhlkOGfuotVYjrwliq/WYDzRpfG/P8jYMCDBttSWmV
         LRXI114Zkf/qAGT8R69v91gyZB/zSR6iXS/Tadp2LtSGiDqw8whA0Qh77atj0wfLYgRy
         SND0LrtZteljjYX7S+omR+DJtfD4FeFlCHEOU5yRVpqCoNPk+P7b1Q6FldNrwh+NjeGW
         hRfe5Hje56BaWNuBW6tV72+Wi8xetgbbW8ZlAHomWbcEIacBNHmhjybao0K4O+vBRClm
         mJNWkxAjes5oe3G1PyTKkFJQBH5F9Oqe94ZQyNIc+FFV1s49Otbg+W5SXgbUGzwZOZEP
         nHXw==
X-Gm-Message-State: AO0yUKV8HCasJHPWxxFvvnwVQUMdk7pzZVyCDC9n+aIzRQZ/NBc83rlD
        sYZk/9vjk+7Cu7zfeRclq2o=
X-Google-Smtp-Source: AK7set/FsMo7uOhPHCx5ABveI2O+e/19Ed5TYsOXR6c6PUejTDR+mNnBORM1NYe7W3EhArW9+yBF2A==
X-Received: by 2002:a17:906:8393:b0:8ae:f73e:233f with SMTP id p19-20020a170906839300b008aef73e233fmr5098936ejx.32.1678835303807;
        Tue, 14 Mar 2023 16:08:23 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id qt22-20020a170906ecf600b009240a577b38sm1729931ejb.14.2023.03.14.16.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 16:08:23 -0700 (PDT)
Date:   Wed, 15 Mar 2023 01:08:21 +0200
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
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND net-next v4 2/3] net: dsa: rzn1-a5psw: add support
 for .port_bridge_flags
Message-ID: <20230314230821.kjiyseiqhat4apqb@skbuf>
References: <20230314163651.242259-1-clement.leger@bootlin.com>
 <20230314163651.242259-3-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230314163651.242259-3-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 05:36:50PM +0100, Clément Léger wrote:
> +static int a5psw_port_pre_bridge_flags(struct dsa_switch *ds, int port,
> +				       struct switchdev_brport_flags flags,
> +				       struct netlink_ext_ack *extack)
> +{
> +	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
> +			   BR_BCAST_FLOOD))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int
> +a5psw_port_bridge_flags(struct dsa_switch *ds, int port,
> +			struct switchdev_brport_flags flags,
> +			struct netlink_ext_ack *extack)
> +{
> +	struct a5psw *a5psw = ds->priv;
> +	u32 val;
> +
> +	if (flags.mask & BR_LEARNING) {
> +		val = flags.val & BR_LEARNING ? 0 : A5PSW_INPUT_LEARN_DIS(port);
> +		a5psw_reg_rmw(a5psw, A5PSW_INPUT_LEARN,
> +			      A5PSW_INPUT_LEARN_DIS(port), val);
> +	}

2 issues.

1: does this not get overwritten by a5psw_port_stp_state_set()?
2: What is the hardware default value for A5PSW_INPUT_LEARN? Please make
   sure that standalone ports have learning disabled by default, when
   the driver probes.

> +
> +	if (flags.mask & BR_FLOOD) {
> +		val = flags.val & BR_FLOOD ? BIT(port) : 0;
> +		a5psw_reg_rmw(a5psw, A5PSW_UCAST_DEF_MASK, BIT(port), val);
> +	}
> +
> +	if (flags.mask & BR_MCAST_FLOOD) {
> +		val = flags.val & BR_MCAST_FLOOD ? BIT(port) : 0;
> +		a5psw_reg_rmw(a5psw, A5PSW_MCAST_DEF_MASK, BIT(port), val);
> +	}
> +
> +	if (flags.mask & BR_BCAST_FLOOD) {
> +		val = flags.val & BR_BCAST_FLOOD ? BIT(port) : 0;
> +		a5psw_reg_rmw(a5psw, A5PSW_BCAST_DEF_MASK, BIT(port), val);
> +	}

Humm, there's a (huge) problem with this flooding mask.

a5psw_flooding_set_resolution() - called from a5psw_port_bridge_join()
and a5psw_port_bridge_leave() - touches the same registers as
a5psw_port_bridge_flags(). Which means that your bridge forwarding
domain controls are the same as your flooding controls.

Which is bad news, because
dsa_port_bridge_leave()
-> dsa_port_switchdev_unsync_attrs()
   -> dsa_port_clear_brport_flags()
      -> dsa_port_bridge_flags()
         -> a5psw_port_bridge_flags()

enables flooding on the port after calling a5psw_port_bridge_leave().
So the port which has left a bridge is standalone, but it still forwards
packets to the other bridged ports!

You should be able to see that this is the case, if you put the ports
under a dummy bridge, then run tools/testing/selftests/drivers/net/dsa/no_forwarding.sh.
