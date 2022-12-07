Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB2346452AA
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 04:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiLGDuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 22:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiLGDuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 22:50:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A06355A8C;
        Tue,  6 Dec 2022 19:50:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77DC06199C;
        Wed,  7 Dec 2022 03:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803ADC433C1;
        Wed,  7 Dec 2022 03:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670385015;
        bh=VNB11BwOk5m3P305D+e2l+GvV7EtvexFh0qA0NVTAbk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aAceGPXD33079mGi4Epdm15XAY+N9eeg7KBm6wMMylR8uIB9QE3lpSJjDohyDOUpF
         g+C/k2vyDyGUxO6Ry12mdqUFAJthEC9ThVT4NmeR0ojKLZx9CWWsh5iXeHOwL6jvDJ
         xfT2B43844fgwHwkN6hiRAnfES3PQz/QZrtgN9xK4s7yjUcBk/SRuXhIWmdH7lyh29
         jJ5PnbO1yEnjamZUtvfh6xjrQoRVQIvRxsSI+xDWRAGhytsi1p7fsD056Whk6lMiOR
         vGhD3/xXBpnSn6bItFVLl3pgRWc4FPfHPVYQYibEv0x9ney3g92a/G/gi9qKLE7aVO
         VkFSgZ0rolneQ==
Date:   Tue, 6 Dec 2022 19:50:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v5 net-next 1/5] net/ethtool: add netlink interface for
 the PLCA RS
Message-ID: <20221206195014.10d7ec82@kernel.org>
In-Reply-To: <350e640b5c3c7b9c25f6fd749dc0237e79e1c573.1670371013.git.piergiorgio.beruto@gmail.com>
References: <cover.1670371013.git.piergiorgio.beruto@gmail.com>
        <350e640b5c3c7b9c25f6fd749dc0237e79e1c573.1670371013.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Dec 2022 01:01:23 +0100 Piergiorgio Beruto wrote:
> Add support for configuring the PLCA Reconciliation Sublayer on
> multi-drop PHYs that support IEEE802.3cg-2019 Clause 148 (e.g.,
> 10BASE-T1S). This patch adds the appropriate netlink interface
> to ethtool.

Please LMK if I'm contradicting prior reviewers, I've scanned=20
the previous versions but may have missed stuff.

> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation=
/networking/ethtool-netlink.rst
> index f10f8eb44255..fe4847611299 100644
> --- a/Documentation/networking/ethtool-netlink.rst
> +++ b/Documentation/networking/ethtool-netlink.rst
> @@ -1716,6 +1716,136 @@ being used. Current supported options are toeplit=
z, xor or crc32.
>  ETHTOOL_A_RSS_INDIR attribute returns RSS indrection table where each by=
te
>  indicates queue number.
> =20
> +PLCA_GET_CFG
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Gets PLCA RS attributes.

Let's spell out PLCA RS, this is the first use of the term in the doc.

> +Request contents:
> +
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +  ``ETHTOOL_A_PLCA_HEADER``              nested  request header
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Kernel response contents:
> +
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> +  ``ETHTOOL_A_PLCA_HEADER``               nested  reply header
> +  ``ETHTOOL_A_PLCA_VERSION``              u16     Supported PLCA managem=
ent
> +                                                  interface standard/ver=
sion
> +  ``ETHTOOL_A_PLCA_ENABLED``              u8      PLCA Admin State
> +  ``ETHTOOL_A_PLCA_NODE_ID``              u8      PLCA unique local node=
 ID
> +  ``ETHTOOL_A_PLCA_NODE_CNT``             u8      Number of PLCA nodes o=
n the
> +                                                  netkork, including the

netkork -> network

> +                                                  coordinator

This is 30.16.1.1.3 aPLCANodeCount ? The phrasing of the help is quite
different than the standard. Pure count should be max node + 1 (IOW max
of 256, which won't fit into u8, hence the question)
Or is node 255 reserved?

> +  ``ETHTOOL_A_PLCA_TO_TMR``               u8      Transmit Opportunity T=
imer
> +                                                  value in bit-times (BT)
> +  ``ETHTOOL_A_PLCA_BURST_CNT``            u8      Number of additional p=
ackets
> +                                                  the node is allowed to=
 send
> +                                                  within a single TO
> +  ``ETHTOOL_A_PLCA_BURST_TMR``            u8      Time to wait for the M=
AC to
> +                                                  transmit a new frame b=
efore
> +                                                  terminating the burst

Please consider making the fields u16 or u32. Netlink pads all
attributes to 4B, and once we decide the size in the user API
we can never change it. So even if the standard says max is 255
if some vendor somewhere may decide to allow a bigger range we
may be better off using a u32 type and limiting the accepted
range in the netlink policy (grep for NLA_POLICY_MAX())

> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> +
> +When set, the optional ``ETHTOOL_A_PLCA_VERSION`` attribute indicates wh=
ich
> +standard and version the PLCA management interface complies to. When not=
 set,
> +the interface is vendor-specific and (possibly) supplied by the driver.
> +The OPEN Alliance SIG specifies a standard register map for 10BASE-T1S P=
HYs
> +embedding the PLCA Reconcialiation Sublayer. See "10BASE-T1S PLCA Manage=
ment
> +Registers" at https://www.opensig.org/about/specifications/. When this s=
tandard
> +is supported, ETHTOOL_A_PLCA_VERSION is reported as 0Axx where 'xx' deno=
tes the

you put backticks around other attr names but not here

TBH I can't parse the "ETHTOOL_A_PLCA_VERSION is reported as 0Axx
where.." sentence. Specifically I'm confused about what the 0A is.

> +map version (see Table A.1.0 =E2=80=94 IDVER bits assignment).

> +When set, the optional ``ETHTOOL_A_PLCA_ENABLED`` attribute indicates the
> +administrative state of the PLCA RS. When not set, the node operates in =
"plain"
> +CSMA/CD mode. This option is corresponding to ``IEEE 802.3cg-2019`` 30.1=
6.1.1.1
> +aPLCAAdminState / 30.16.1.2.1 acPLCAAdminControl.
> +
> +When set, the optional ``ETHTOOL_A_PLCA_NODE_ID`` attribute indicates the
> +configured local node ID of the PHY. This ID determines which transmit
> +opportunity (TO) is reserved for the node to transmit into. This option =
is
> +corresponding to ``IEEE 802.3cg-2019`` 30.16.1.1.4 aPLCALocalNodeID.
> +
> +When set, the optional ``ETHTOOL_A_PLCA_NODE_CNT`` attribute indicates t=
he
> +configured maximum number of PLCA nodes on the mixing-segment. This numb=
er
> +determines the total number of transmit opportunities generated during a
> +PLCA cycle. This attribute is relevant only for the PLCA coordinator, wh=
ich is
> +the node with aPLCALocalNodeID set to 0. Follower nodes ignore this sett=
ing.
> +This option is corresponding to ``IEEE 802.3cg-2019`` 30.16.1.1.3
> +aPLCANodeCount.
> +
> +When set, the optional ``ETHTOOL_A_PLCA_TO_TMR`` attribute indicates the
> +configured value of the transmit opportunity timer in bit-times. This va=
lue
> +must be set equal across all nodes sharing the medium for PLCA to work
> +correctly. This option is corresponding to ``IEEE 802.3cg-2019`` 30.16.1=
.1.5
> +aPLCATransmitOpportunityTimer.
> +
> +When set, the optional ``ETHTOOL_A_PLCA_BURST_CNT`` attribute indicates =
the
> +configured number of extra packets that the node is allowed to send duri=
ng a
> +single transmit opportunity. By default, this attribute is 0, meaning th=
at
> +the node can only send a sigle frame per TO. When greater than 0, the PL=
CA RS
> +keeps the TO after any transmission, waiting for the MAC to send a new f=
rame
> +for up to aPLCABurstTimer BTs. This can only happen a number of times pe=
r PLCA
> +cycle up to the value of this parameter. After that, the burst is over a=
nd the
> +normal counting of TOs resumes. This option is corresponding to
> +``IEEE 802.3cg-2019`` 30.16.1.1.6 aPLCAMaxBurstCount.
> +
> +When set, the optional ``ETHTOOL_A_PLCA_BURST_TMR`` attribute indicates =
how
> +many bit-times the PLCA RS waits for the MAC to initiate a new transmiss=
ion
> +when aPLCAMaxBurstCount is greater than 0. If the MAC fails to send a new
> +frame within this time, the burst ends and the counting of TOs resumes.
> +Otherwise, the new frame is sent as part of the current burst. This opti=
on
> +is corresponding to ``IEEE 802.3cg-2019`` 30.16.1.1.7 aPLCABurstTimer.
> +
> +PLCA_SET_CFG
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Sets PLCA RS parameters.
> +
> +Request contents:
> +
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> +  ``ETHTOOL_A_PLCA_HEADER``               nested  request header
> +  ``ETHTOOL_A_PLCA_ENABLED``              u8      PLCA Admin State
> +  ``ETHTOOL_A_PLCA_NODE_ID``              u8      PLCA unique local node=
 ID
> +  ``ETHTOOL_A_PLCA_NODE_CNT``             u8      Number of PLCA nodes o=
n the
> +                                                  netkork, including the
> +                                                  coordinator
> +  ``ETHTOOL_A_PLCA_TO_TMR``               u8      Transmit Opportunity T=
imer
> +                                                  value in bit-times (BT)
> +  ``ETHTOOL_A_PLCA_BURST_CNT``            u8      Number of additional p=
ackets
> +                                                  the node is allowed to=
 send
> +                                                  within a single TO
> +  ``ETHTOOL_A_PLCA_BURST_TMR``            u8      Time to wait for the M=
AC to
> +                                                  transmit a new frame b=
efore
> +                                                  terminating the burst
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> +
> +For a description of each attribute, see ``PLCA_GET_CFG``.
> +
> +PLCA_GET_STATUS
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Gets PLCA RS status information.
> +
> +Request contents:
> +
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +  ``ETHTOOL_A_PLCA_HEADER``              nested  request header
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Kernel response contents:
> +
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> +  ``ETHTOOL_A_PLCA_HEADER``               nested  reply header
> +  ``ETHTOOL_A_PLCA_STATUS``               u8      PLCA RS operational st=
atus
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> +
> +When set, the ``ETHTOOL_A_PLCA_STATUS`` attribute indicates whether the =
node is
> +detecting the presence of the BEACON on the network. This flag is
> +corresponding to ``IEEE 802.3cg-2019`` 30.16.1.1.2 aPLCAStatus.

I noticed some count attributes in the spec, are these statistics?
Do any of your devices support them? It'd be good to add support in
a fixed format via net/ethtool/stats.c from the start, so that people
don't start inventing their own ways of reporting them.

(feel free to ask for more guidance, the stats support is a bit spread
out throughout the code)

>   * struct ethtool_phy_ops - Optional PHY device options
>   * @get_sset_count: Get number of strings that @get_strings will write.
>   * @get_strings: Return a set of strings that describe the requested obj=
ects
>   * @get_stats: Return extended statistics about the PHY device.
> + * @get_plca_cfg: Return PLCA configuration.
> + * @set_plca_cfg: Set PLCA configuration.

missing get status in kdoc

>   * @start_cable_test: Start a cable test
>   * @start_cable_test_tdr: Start a Time Domain Reflectometry cable test
>   *
> @@ -819,6 +823,13 @@ struct ethtool_phy_ops {
>  	int (*get_strings)(struct phy_device *dev, u8 *data);
>  	int (*get_stats)(struct phy_device *dev,
>  			 struct ethtool_stats *stats, u64 *data);
> +	int (*get_plca_cfg)(struct phy_device *dev,
> +			    struct phy_plca_cfg *plca_cfg);
> +	int (*set_plca_cfg)(struct phy_device *dev,
> +			    struct netlink_ext_ack *extack,
> +			    const struct phy_plca_cfg *plca_cfg);

extack is usually the last argument

> +	int (*get_plca_status)(struct phy_device *dev,
> +			       struct phy_plca_status *plca_st);

get status doesn't need exact? I guess..

>  	int (*start_cable_test)(struct phy_device *phydev,
>  				struct netlink_ext_ack *extack);
>  	int (*start_cable_test_tdr)(struct phy_device *phydev,
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 71eeb4e3b1fd..f3ecc9a86e67 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -765,6 +765,63 @@ struct phy_tdr_config {
>  };
>  #define PHY_PAIR_ALL -1
> =20
> +/**
> + * struct phy_plca_cfg - Configuration of the PLCA (Physical Layer Colli=
sion
> + * Avoidance) Reconciliation Sublayer.
> + *
> + * @version: read-only PLCA register map version. 0 =3D not available. I=
gnored

                                                     ^^^^^^^^^^^^^^^^^^

> + *   when setting the configuration. Format is the same as reported by t=
he PLCA
> + *   IDVER register (31.CA00). -1 =3D not available.

                                  ^^^^^^^^^^^^^^^^^^^

So is it 0 or -1 that's N/A for this field? :)

> + * @enabled: PLCA configured mode (enabled/disabled). -1 =3D not availab=
le / don't
> + *   set. 0 =3D disabled, anything else =3D enabled.
> + * @node_id: the PLCA local node identifier. -1 =3D not available / don'=
t set.
> + *   Allowed values [0 .. 254]. 255 =3D node disabled.
> + * @node_cnt: the PLCA node count (maximum number of nodes having a TO).=
 Only
> + *   meaningful for the coordinator (node_id =3D 0). -1 =3D not availabl=
e / don't
> + *   set. Allowed values [0 .. 255].
> + * @to_tmr: The value of the PLCA to_timer in bit-times, which determine=
s the
> + *   PLCA transmit opportunity window opening. See IEEE802.3 Clause 148 =
for
> + *   more details. The to_timer shall be set equal over all nodes.
> + *   -1 =3D not available / don't set. Allowed values [0 .. 255].
> + * @burst_cnt: controls how many additional frames a node is allowed to =
send in
> + *   single transmit opportunity (TO). The default value of 0 means that=
 the
> + *   node is allowed exactly one frame per TO. A value of 1 allows two f=
rames
> + *   per TO, and so on. -1 =3D not available / don't set.
> + *   Allowed values [0 .. 255].
> + * @burst_tmr: controls how many bit times to wait for the MAC to send a=
 new
> + *   frame before interrupting the burst. This value should be set to a =
value
> + *   greater than the MAC inter-packet gap (which is typically 96 bits).
> + *   -1 =3D not available / don't set. Allowed values [0 .. 255].

> +struct phy_plca_cfg {
> +	s32 version;
> +	s16 enabled;
> +	s16 node_id;
> +	s16 node_cnt;
> +	s16 to_tmr;
> +	s16 burst_cnt;
> +	s16 burst_tmr;

make them all int, oddly sized integers are only a source of trouble

> +};
> +
> +/**
> + * struct phy_plca_status - Status of the PLCA (Physical Layer Collision
> + * Avoidance) Reconciliation Sublayer.
> + *
> + * @pst: The PLCA status as reported by the PST bit in the PLCA STATUS
> + *	register(31.CA03), indicating BEACON activity.
> + *
> + * A structure containing status information of the PLCA RS configuratio=
n.
> + * The driver does not need to implement all the parameters, but should =
report
> + * what is actually used.
> + */
> +struct phy_plca_status {
> +	bool pst;
> +};

> +#include <linux/phy.h>
> +#include <linux/ethtool_netlink.h>
> +
> +#include "netlink.h"
> +#include "common.h"
> +
> +struct plca_req_info {
> +	struct ethnl_req_info		base;
> +};
> +
> +struct plca_reply_data {
> +	struct ethnl_reply_data		base;
> +	struct phy_plca_cfg		plca_cfg;
> +	struct phy_plca_status		plca_st;
> +};
> +
> +#define PLCA_REPDATA(__reply_base) \
> +	container_of(__reply_base, struct plca_reply_data, base)
> +
> +// PLCA get configuration message --------------------------------------=
----- //
> +
> +const struct nla_policy ethnl_plca_get_cfg_policy[] =3D {
> +	[ETHTOOL_A_PLCA_HEADER]		=3D
> +		NLA_POLICY_NESTED(ethnl_header_policy),
> +};
> +
> +static int plca_get_cfg_prepare_data(const struct ethnl_req_info *req_ba=
se,
> +				     struct ethnl_reply_data *reply_base,
> +				     struct genl_info *info)
> +{
> +	struct plca_reply_data *data =3D PLCA_REPDATA(reply_base);
> +	struct net_device *dev =3D reply_base->dev;
> +	const struct ethtool_phy_ops *ops;
> +	int ret;
> +
> +	// check that the PHY device is available and connected
> +	if (!dev->phydev) {
> +		ret =3D -EOPNOTSUPP;
> +		goto out;
> +	}
> +
> +	// note: rtnl_lock is held already by ethnl_default_doit
> +	ops =3D ethtool_phy_ops;
> +	if (!ops || !ops->get_plca_cfg) {
> +		ret =3D -EOPNOTSUPP;
> +		goto out;
> +	}
> +
> +	ret =3D ethnl_ops_begin(dev);
> +	if (ret < 0)
> +		goto out;
> +
> +	ret =3D ops->get_plca_cfg(dev->phydev, &data->plca_cfg);
> +	if (ret < 0)
> +		goto out;

You still need to complete the op, no? Don't jump over that..

> +	ethnl_ops_complete(dev);
> +
> +out:
> +	return ret;
> +}

> +	if ((plca->version >=3D 0 &&
> +	     nla_put_u16(skb, ETHTOOL_A_PLCA_VERSION, (u16)plca->version)) ||
> +	    (plca->enabled >=3D 0 &&
> +	     nla_put_u8(skb, ETHTOOL_A_PLCA_ENABLED, !!plca->enabled)) ||
> +	    (plca->node_id >=3D 0 &&
> +	     nla_put_u8(skb, ETHTOOL_A_PLCA_NODE_ID, (u8)plca->node_id)) ||
> +	    (plca->node_cnt >=3D 0 &&
> +	     nla_put_u8(skb, ETHTOOL_A_PLCA_NODE_CNT, (u8)plca->node_cnt)) ||
> +	    (plca->to_tmr >=3D 0 &&
> +	     nla_put_u8(skb, ETHTOOL_A_PLCA_TO_TMR, (u8)plca->to_tmr)) ||
> +	    (plca->burst_cnt >=3D 0 &&
> +	     nla_put_u8(skb, ETHTOOL_A_PLCA_BURST_CNT, (u8)plca->burst_cnt)) ||
> +	    (plca->burst_tmr >=3D 0 &&
> +	     nla_put_u8(skb, ETHTOOL_A_PLCA_BURST_TMR, (u8)plca->burst_tmr)))

The casts are unnecessary, but if you really really want them they=20
can stay..

> +		return -EMSGSIZE;
> +
> +	return 0;
> +};

> +const struct nla_policy ethnl_plca_set_cfg_policy[] =3D {
> +	[ETHTOOL_A_PLCA_HEADER]		=3D
> +		NLA_POLICY_NESTED(ethnl_header_policy),
> +	[ETHTOOL_A_PLCA_ENABLED]	=3D { .type =3D NLA_U8 },

NLA_POLICY_MAX(NLA_U8, 1)

> +	[ETHTOOL_A_PLCA_NODE_ID]	=3D { .type =3D NLA_U8 },

Does this one also need check against 255 or is 255 allowed?

> +	[ETHTOOL_A_PLCA_NODE_CNT]	=3D { .type =3D NLA_U8 },
> +	[ETHTOOL_A_PLCA_TO_TMR]		=3D { .type =3D NLA_U8 },
> +	[ETHTOOL_A_PLCA_BURST_CNT]	=3D { .type =3D NLA_U8 },
> +	[ETHTOOL_A_PLCA_BURST_TMR]	=3D { .type =3D NLA_U8 },


> +int ethnl_set_plca_cfg(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct ethnl_req_info req_info =3D {};
> +	struct nlattr **tb =3D info->attrs;
> +	const struct ethtool_phy_ops *ops;
> +	struct phy_plca_cfg plca_cfg;
> +	struct net_device *dev;
> +

spurious new line

> +	bool mod =3D false;
> +	int ret;
> +
> +	ret =3D ethnl_parse_header_dev_get(&req_info,
> +					 tb[ETHTOOL_A_PLCA_HEADER],
> +					 genl_info_net(info), info->extack,
> +					 true);
> +	if (ret < 0)
> +		return ret;
> +
> +	dev =3D req_info.dev;
> +
> +	// check that the PHY device is available and connected

Comment slightly misplaced now?

> +	rtnl_lock();
> +
> +	if (!dev->phydev) {
> +		ret =3D -EOPNOTSUPP;
> +		goto out_rtnl;
> +	}
> +
> +	ops =3D ethtool_phy_ops;
> +	if (!ops || !ops->set_plca_cfg) {
> +		ret =3D -EOPNOTSUPP;
> +		goto out_rtnl;
> +	}
> +
> +	ret =3D ethnl_ops_begin(dev);
> +	if (ret < 0)
> +		goto out_rtnl;
> +
> +	memset(&plca_cfg, 0xFF, sizeof(plca_cfg));
> +
> +	if (tb[ETHTOOL_A_PLCA_ENABLED]) {
> +		plca_cfg.enabled =3D !!nla_get_u8(tb[ETHTOOL_A_PLCA_ENABLED]);
> +		mod =3D true;
> +	}
> +
> +	if (tb[ETHTOOL_A_PLCA_NODE_ID]) {
> +		plca_cfg.node_id =3D nla_get_u8(tb[ETHTOOL_A_PLCA_NODE_ID]);
> +		mod =3D true;
> +	}
> +
> +	if (tb[ETHTOOL_A_PLCA_NODE_CNT]) {
> +		plca_cfg.node_cnt =3D nla_get_u8(tb[ETHTOOL_A_PLCA_NODE_CNT]);
> +		mod =3D true;
> +	}
> +
> +	if (tb[ETHTOOL_A_PLCA_TO_TMR]) {
> +		plca_cfg.to_tmr =3D nla_get_u8(tb[ETHTOOL_A_PLCA_TO_TMR]);
> +		mod =3D true;
> +	}
> +
> +	if (tb[ETHTOOL_A_PLCA_BURST_CNT]) {
> +		plca_cfg.burst_cnt =3D nla_get_u8(tb[ETHTOOL_A_PLCA_BURST_CNT]);
> +		mod =3D true;
> +	}
> +
> +	if (tb[ETHTOOL_A_PLCA_BURST_TMR]) {
> +		plca_cfg.burst_tmr =3D nla_get_u8(tb[ETHTOOL_A_PLCA_BURST_TMR]);
> +		mod =3D true;
> +	}

Could you add a helper for the modifications? A'la ethnl_update_u8, but
accounting for the oddness in types (ergo probably locally in this file
rather that in the global scope)?

> +	ret =3D 0;
> +	if (!mod)
> +		goto out_ops;
> +
> +	ret =3D ops->set_plca_cfg(dev->phydev, info->extack, &plca_cfg);
> +

spurious new line

> +	if (ret < 0)
> +		goto out_ops;
> +
> +	ethtool_notify(dev, ETHTOOL_MSG_PLCA_NTF, NULL);
> +
> +out_ops:
> +	ethnl_ops_complete(dev);
> +out_rtnl:
> +	rtnl_unlock();
> +	ethnl_parse_header_dev_put(&req_info);
> +
> +	return ret;
> +}
> +
> +// PLCA get status message ---------------------------------------------=
----- //
> +
> +const struct nla_policy ethnl_plca_get_status_policy[] =3D {
> +	[ETHTOOL_A_PLCA_HEADER]		=3D
> +		NLA_POLICY_NESTED(ethnl_header_policy),
> +};
> +
> +static int plca_get_status_prepare_data(const struct ethnl_req_info *req=
_base,
> +					struct ethnl_reply_data *reply_base,
> +					struct genl_info *info)
> +{
> +	struct plca_reply_data *data =3D PLCA_REPDATA(reply_base);
> +	struct net_device *dev =3D reply_base->dev;
> +	const struct ethtool_phy_ops *ops;
> +	int ret;
> +
> +	// check that the PHY device is available and connected
> +	if (!dev->phydev) {
> +		ret =3D -EOPNOTSUPP;
> +		goto out;
> +	}
> +
> +	// note: rtnl_lock is held already by ethnl_default_doit
> +	ops =3D ethtool_phy_ops;
> +	if (!ops || !ops->get_plca_status) {
> +		ret =3D -EOPNOTSUPP;
> +		goto out;
> +	}
> +
> +	ret =3D ethnl_ops_begin(dev);
> +	if (ret < 0)
> +		goto out;
> +
> +	ret =3D ops->get_plca_status(dev->phydev, &data->plca_st);
> +	if (ret < 0)
> +		goto out;

don't skip complete

> +	ethnl_ops_complete(dev);
> +out:
> +	return ret;
> +}

