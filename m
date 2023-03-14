Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE5D96BA394
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 00:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjCNXfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 19:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjCNXe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 19:34:59 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4D0A243;
        Tue, 14 Mar 2023 16:34:58 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id x3so68716204edb.10;
        Tue, 14 Mar 2023 16:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678836897;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=75mkBro0auUkQVDm72OpsQNfSGM7MDaLDHv3dONW9eQ=;
        b=E5nRdro+MEVtesuGijddf2kLm9OlmTwbzNhAclYTIy1qBOo3JMYzAf+r6snKOqGhiH
         YkuEWil77Ne6Gr9qhLTyPI1MAlDk8XdEZaf48LqjNkLMsZ943xqrupOc5VNynI976CQU
         kflRLM8q1NU5igauSzByjAvl7enpA9qOChNavY9dFoPaspmSrNmLGdMcOly19lhF6DdY
         02v7dL1gftDh3EB/382f1bfIm0IuyaUJ8DcOmvQytFleG5KpQJtKL9b729d7TQEHYLAB
         gByj2mFNYZlqnBbWeSJpcHqAQ8A8hVc0gIHiyD4+4op5dXWJTn8q6IpFVu6GS4Ny8Y18
         Hc5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678836897;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=75mkBro0auUkQVDm72OpsQNfSGM7MDaLDHv3dONW9eQ=;
        b=0Hh2Rqq5PgGzSLaluKOLyhTXw74efO/+3RYLpocdmFRkLK4IrwhIKekPxue0hSo8wR
         R9d9wk4jmQDkQVf+SPzZIkCgiGKUr0EIvUjZHNq8cKraWLtA93ArqN4MQLkRq23D8OAJ
         xP7KMldgWJ1s66jb/O7kXUv67gpvW8bQD2BXeGupXZ7IGsYnTbOH50hYAF6QFDpu9FaP
         udYScOfjlvzsqGxoXRaPYwrCuKIP6JYqsw7bv4SPKKCoHkgNNpYkeaM39ovp2EPFCn+E
         9ikHL1Tr71zxOSJWj2nVWbZ6YPAxzfsKnSto8XmTRX7GTeOOkK4XLbAkHOtnCyu/EHsZ
         Oq6A==
X-Gm-Message-State: AO0yUKWdo456Vu+1NStbx7Wc9zlznCyF8AtNdVbH5xS98oZ0R7GHXwUq
        wZAnQQeGmSf+9ZylZ53H7mg=
X-Google-Smtp-Source: AK7set/uUtlk3y77eOFjKc9q33ZV4VPN1ElsNmUVBtjhsc2qJp/W3Ssj9LfkZNVOvXE4oF/4w60VAg==
X-Received: by 2002:a17:906:d92e:b0:8b1:7684:dfb0 with SMTP id rn14-20020a170906d92e00b008b17684dfb0mr4101699ejb.57.1678836896956;
        Tue, 14 Mar 2023 16:34:56 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id qt17-20020a170906ecf100b009236ae669ecsm1716641ejb.191.2023.03.14.16.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 16:34:56 -0700 (PDT)
Date:   Wed, 15 Mar 2023 01:34:54 +0200
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
Subject: Re: [PATCH RESEND net-next v4 3/3] net: dsa: rzn1-a5psw: add vlan
 support
Message-ID: <20230314233454.3zcpzhobif475hl2@skbuf>
References: <20230314163651.242259-1-clement.leger@bootlin.com>
 <20230314163651.242259-1-clement.leger@bootlin.com>
 <20230314163651.242259-4-clement.leger@bootlin.com>
 <20230314163651.242259-4-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230314163651.242259-4-clement.leger@bootlin.com>
 <20230314163651.242259-4-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 05:36:51PM +0100, Clément Léger wrote:
> Add support for vlan operation (add, del, filtering) on the RZN1
> driver. The a5psw switch supports up to 32 VLAN IDs with filtering,
> tagged/untagged VLANs and PVID for each ports.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
>  drivers/net/dsa/rzn1_a5psw.c | 164 +++++++++++++++++++++++++++++++++++
>  drivers/net/dsa/rzn1_a5psw.h |   8 +-
>  2 files changed, 169 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
> index 5059b2814cdd..a9a42a8bc7e3 100644
> --- a/drivers/net/dsa/rzn1_a5psw.c
> +++ b/drivers/net/dsa/rzn1_a5psw.c
> @@ -583,6 +583,144 @@ static int a5psw_port_fdb_dump(struct dsa_switch *ds, int port,
>  	return ret;
>  }
>  
> +static int a5psw_port_vlan_filtering(struct dsa_switch *ds, int port,
> +				     bool vlan_filtering,
> +				     struct netlink_ext_ack *extack)
> +{
> +	u32 mask = BIT(port + A5PSW_VLAN_VERI_SHIFT) |
> +		   BIT(port + A5PSW_VLAN_DISC_SHIFT);

I'm curious what the A5PSW_VLAN_VERI_SHIFT and A5PSW_VLAN_DISC_SHIFT
bits do. Also curious in general what does this hardware do w.r.t.
VLANs. There would be several things on the checklist:

- can it drop a VLAN which isn't present in the port membership list?
  I guess this is what A5PSW_VLAN_DISC_SHIFT does.

- can it use VLAN information from the packet (with a fallback on the
  port PVID) to determine where to send, and where *not* to send the
  packet? How does this relate to the flooding registers? Is the flood
  mask restricted by the VLAN mask? Is there a default VLAN installed in
  the hardware tables, which is also the PVID of all ports, and all
  ports are members of it? Could you implement standalone/bridged port
  forwarding isolation based on VLANs, rather than the flimsy and most
  likely buggy implementation done based on flooding domains, from this
  patch set?

- is the FDB looked up per {MAC DA, VLAN ID} or just MAC DA? Looking at
  a5psw_port_fdb_add(), there's absolutely no sign of "vid" being used,
  so I guess it's Shared VLAN Learning. In that case, there's absolutely
  no hope to implement ds->fdb_isolation for this hardware. But at the
  *very* least, please disable address learning on standalone ports,
  *and* implement ds->ops->port_fast_age() so that ports quickly forget
  their learned MAC adddresses after leaving a bridge and become
  standalone again.

- if the port PVID is indeed used to filter the flooding mask of
  untagged packets, then I speculate that when A5PSW_VLAN_VERI_SHIFT
  is set, the hardware searches for a VLAN tag in the packet, whereas if
  it's unset, all packets will be forwarded according just to the port
  PVID (A5PSW_SYSTEM_TAGINFO). That would be absolutely magnificent if
  true, but it also means that you need to be *a lot* more careful when
  programming this register. See the "Address databases" section from
  Documentation/networking/dsa/dsa.rst for an explanation of the
  asynchronous nature of .port_vlan_add() relative to .port_vlan_filtering().
  Also see the call paths of sja1105_commit_pvid() and mv88e6xxx_port_commit_pvid()
  for an example of how this should be managed correctly, and how the
  bridge PVID should be committed to hardware only when the port is
  currently VLAN-aware.

> +	u32 val = vlan_filtering ? mask : 0;
> +	struct a5psw *a5psw = ds->priv;
> +
> +	a5psw_reg_rmw(a5psw, A5PSW_VLAN_VERIFY, mask, val);
> +
> +	return 0;
> +}
> +
> +static int a5psw_port_vlan_del(struct dsa_switch *ds, int port,
> +			       const struct switchdev_obj_port_vlan *vlan)
> +{
> +	struct a5psw *a5psw = ds->priv;
> +	u16 vid = vlan->vid;
> +	int vlan_res_id;
> +
> +	dev_dbg(a5psw->dev, "Removing VLAN %d on port %d\n", vid, port);
> +
> +	vlan_res_id = a5psw_find_vlan_entry(a5psw, vid);
> +	if (vlan_res_id < 0)
> +		return -EINVAL;
> +
> +	a5psw_port_vlan_cfg(a5psw, vlan_res_id, port, false);
> +	a5psw_port_vlan_tagged_cfg(a5psw, vlan_res_id, port, false);
> +
> +	/* Disable PVID if the vid is matching the port one */

What does it mean to disable PVID?

> +	if (vid == a5psw_reg_readl(a5psw, A5PSW_SYSTEM_TAGINFO(port)))
> +		a5psw_reg_rmw(a5psw, A5PSW_VLAN_IN_MODE_ENA, BIT(port), 0);
> +
> +	return 0;
> +}
> +
>  static u64 a5psw_read_stat(struct a5psw *a5psw, u32 offset, int port)
>  {
>  	u32 reg_lo, reg_hi;
> @@ -700,6 +838,27 @@ static void a5psw_get_eth_ctrl_stats(struct dsa_switch *ds, int port,
>  	ctrl_stats->MACControlFramesReceived = stat;
>  }
>  
> +static void a5psw_vlan_setup(struct a5psw *a5psw, int port)
> +{
> +	u32 reg;
> +
> +	/* Enable TAG always mode for the port, this is actually controlled
> +	 * by VLAN_IN_MODE_ENA field which will be used for PVID insertion
> +	 */

What does the "tag always" mode do, and what are the alternatives?

> +	reg = A5PSW_VLAN_IN_MODE_TAG_ALWAYS;
> +	reg <<= A5PSW_VLAN_IN_MODE_PORT_SHIFT(port);
> +	a5psw_reg_rmw(a5psw, A5PSW_VLAN_IN_MODE, A5PSW_VLAN_IN_MODE_PORT(port),
> +		      reg);
> +
> +	/* Set transparent mode for output frame manipulation, this will depend
> +	 * on the VLAN_RES configuration mode
> +	 */

What does the "transparent" output mode do, and how does it compare to
the "dis", "strip" and "tag through" alternatives?

> +	reg = A5PSW_VLAN_OUT_MODE_TRANSPARENT;
> +	reg <<= A5PSW_VLAN_OUT_MODE_PORT_SHIFT(port);
> +	a5psw_reg_rmw(a5psw, A5PSW_VLAN_OUT_MODE,
> +		      A5PSW_VLAN_OUT_MODE_PORT(port), reg);
> +}

Sorry for asking all these questions, but VLAN configuration on a switch
such as to bring it in line with the bridge driver expectations is a
rather tricky thing, so I'd like to have as clear of a mental model of
this hardware as possible, if public documentation isn't available.
