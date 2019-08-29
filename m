Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3422CA195D
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 13:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfH2Lu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 07:50:29 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:33857 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbfH2Lu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 07:50:29 -0400
Received: by mail-ed1-f66.google.com with SMTP id s49so3778842edb.1
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 04:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NIBZFTASbWij8fDrpn+uvXXeZQO1/Q8U2w2qwOs71UE=;
        b=b82+Rf4JwpB3pqspzfDmXe+Wyv0mjVgUmcqyDcP8xnHG/lQe1WqLBaE4lu2ffJjl4R
         GlOzU6oZbBvfoVQB+X1+pCulzLMmIKCcBKqWOi3q7Sxo/1KnFFO3FTmXF1TGElZxuH+0
         i6wlleIRdm6RThmmMsaiLBbbF8jaqxZGgXsqiJQwTF5TMeOP372YfxmGJyuF1flArazK
         VMIea3YpbKSs9DEyg5TqZu7Nwtc0s7LqS+cLB3txI1Wj8OVBg+WkqaWp4mmaS8QjgZYs
         LzslQ0ntnyomg88OxSL+vK5A79CxNhX5s4qKYZzc9oth2bEaA9+MrDGqlWwEwOirDGi4
         9R9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NIBZFTASbWij8fDrpn+uvXXeZQO1/Q8U2w2qwOs71UE=;
        b=f5UU8dgrdWpKCk+Zwss8ljZYNMx3Msm+cTcv79zrzg4gbJJNxI2n+k2AC71WMCZZ4g
         vRVDWkYsdiAZwGRkV6CocOur7Q3c/MPjW+PTFcDNB3lazlLl1DabkK1axZg45kEflqxx
         sHpQJLXO9hu/T158pcpfEqpIJXVMz6PAaWz2Hk7/OhuT8rrq0g333sNW4eetfiJTCLCK
         GnLsAxqG7UrOZfZ/wFh4hSyLauBjRdrEj6SzKf8ceqJGF18Sj1dlXsVI82kOMUIRIp0d
         3NZe6spbuKZj/9TiPSBwUYFyc6v4fmQ4BUhZ2g1H/WASb9LyaT3FnRwZONMJmLjykzVE
         r29g==
X-Gm-Message-State: APjAAAVy1MD3MVem/C5ihMnYH+h/Ufo894+VSC2SezLphCxLu/l+ram9
        8fei+GCb1PDYa6z8JOKQSyE+/QUegnHfeFtqHZQ=
X-Google-Smtp-Source: APXvYqyeegyvJG7sAUNKxB3chkvLU+fS1PuobG+cLoHWdxDTV0KIRAw7LS6XFcEVYo0lcq+gmqFBk5MIxEdBVBptzws=
X-Received: by 2002:a50:9dc8:: with SMTP id l8mr9380077edk.108.1567079426691;
 Thu, 29 Aug 2019 04:50:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190825184454.14678-1-olteanv@gmail.com> <20190825184454.14678-3-olteanv@gmail.com>
In-Reply-To: <20190825184454.14678-3-olteanv@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 29 Aug 2019 14:50:14 +0300
Message-ID: <CA+h21hq=VVw0p0OjGaPx2-c4FE1ge-STRVHYZ6P62c-+_xW0nw@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 2/2] net: dsa: tag_8021q: Restore bridge VLANs
 when enabling vlan_filtering
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        nikolay@cumulusnetworks.com,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vivien,

On Sun, 25 Aug 2019 at 21:46, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> The bridge core assumes that enabling/disabling vlan_filtering will
> translate into the simple toggling of a flag for switchdev drivers.
>
> That is clearly not the case for sja1105, which alters the VLAN table
> and the pvids in order to obtain port separation in standalone mode.
>
> There are 2 parts to the issue.
>
> First, tag_8021q changes the pvid to a unique per-port rx_vid for frame
> identification. But we need to disable tag_8021q when vlan_filtering
> kicks in, and at that point, the VLAN configured as pvid will have to be
> removed from the filtering table of the ports. With an invalid pvid, the
> ports will drop all traffic.  Since the bridge will not call any vlan
> operation through switchdev after enabling vlan_filtering, we need to
> ensure we're in a functional state ourselves. Hence read the pvid that
> the bridge is aware of, and program that into our ports.
>
> Secondly, tag_8021q uses the 1024-3071 range privately in
> vlan_filtering=0 mode. Had the user installed one of these VLANs during
> a previous vlan_filtering=1 session, then upon the next tag_8021q
> cleanup for vlan_filtering to kick in again, VLANs in that range will
> get deleted unconditionally, hence breaking user expectation. So when
> deleting the VLANs, check if the bridge had knowledge about them, and if
> it did, re-apply the settings. Wrap this logic inside a
> dsa_8021q_vid_apply helper function to reduce code duplication.
>
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>  net/dsa/tag_8021q.c | 91 +++++++++++++++++++++++++++++++++++----------
>  1 file changed, 71 insertions(+), 20 deletions(-)
>
> diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
> index 67a1bc635a7b..81f943e365b9 100644
> --- a/net/dsa/tag_8021q.c
> +++ b/net/dsa/tag_8021q.c
> @@ -93,6 +93,68 @@ int dsa_8021q_rx_source_port(u16 vid)
>  }
>  EXPORT_SYMBOL_GPL(dsa_8021q_rx_source_port);
>
> +static int dsa_8021q_restore_pvid(struct dsa_switch *ds, int port)
> +{
> +       struct bridge_vlan_info vinfo;
> +       struct net_device *slave;
> +       u16 pvid;
> +       int err;
> +
> +       if (!dsa_is_user_port(ds, port))
> +               return 0;
> +
> +       slave = ds->ports[port].slave;
> +
> +       err = br_vlan_get_pvid(slave, &pvid);
> +       if (err < 0) {
> +               dev_err(ds->dev, "Couldn't determine bridge PVID\n");
> +               return err;
> +       }
> +
> +       err = br_vlan_get_info(slave, pvid, &vinfo);
> +       if (err < 0) {
> +               dev_err(ds->dev, "Couldn't determine PVID attributes\n");
> +               return err;
> +       }
> +
> +       return dsa_port_vid_add(&ds->ports[port], pvid, vinfo.flags);

If the bridge had installed a dsa_8021q VLAN here, I need to use the
dsa_slave_vid_add logic to restore it. The dsa_8021q flags on the CPU
port are "ingress tagged", but that may not be the case for the bridge
VLAN.
Should I expose dsa_slave_vlan_add in dsa_priv.h, or should I just
open-code another dsa_port_vid_add for dp->cpu_dp, duplicating a bit
of code from dsa_slave_vlan_add?

> +}
> +
> +/* If @enabled is true, installs @vid with @flags into the switch port's HW
> + * filter.
> + * If @enabled is false, deletes @vid (ignores @flags) from the port. Had the
> + * user explicitly configured this @vid through the bridge core, then the @vid
> + * is installed again, but this time with the flags from the bridge layer.
> + */
> +static int dsa_8021q_vid_apply(struct dsa_switch *ds, int port, u16 vid,
> +                              u16 flags, bool enabled)
> +{
> +       struct dsa_port *dp = &ds->ports[port];
> +       struct bridge_vlan_info vinfo;
> +       int err;
> +
> +       if (enabled)
> +               return dsa_port_vid_add(dp, vid, flags);
> +
> +       err = dsa_port_vid_del(dp, vid);
> +       if (err < 0)
> +               return err;
> +
> +       /* Nothing to restore from the bridge for a non-user port */
> +       if (!dsa_is_user_port(ds, port))
> +               return 0;
> +
> +       err = br_vlan_get_info(dp->slave, vid, &vinfo);
> +       /* Couldn't determine bridge attributes for this vid,
> +        * it means the bridge had not configured it.
> +        */
> +       if (err < 0)
> +               return 0;
> +
> +       /* Restore the VID from the bridge */
> +       return dsa_port_vid_add(dp, vid, vinfo.flags);
> +}
> +
>  /* RX VLAN tagging (left) and TX VLAN tagging (right) setup shown for a single
>   * front-panel switch port (here swp0).
>   *
> @@ -148,8 +210,6 @@ EXPORT_SYMBOL_GPL(dsa_8021q_rx_source_port);
>  int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int port, bool enabled)
>  {
>         int upstream = dsa_upstream_port(ds, port);
> -       struct dsa_port *dp = &ds->ports[port];
> -       struct dsa_port *upstream_dp = &ds->ports[upstream];
>         u16 rx_vid = dsa_8021q_rx_vid(ds, port);
>         u16 tx_vid = dsa_8021q_tx_vid(ds, port);
>         int i, err;
> @@ -166,7 +226,6 @@ int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int port, bool enabled)
>          * restrictions, so there are no concerns about leaking traffic.
>          */
>         for (i = 0; i < ds->num_ports; i++) {
> -               struct dsa_port *other_dp = &ds->ports[i];
>                 u16 flags;
>
>                 if (i == upstream)
> @@ -179,10 +238,7 @@ int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int port, bool enabled)
>                         /* The RX VID is a regular VLAN on all others */
>                         flags = BRIDGE_VLAN_INFO_UNTAGGED;
>
> -               if (enabled)
> -                       err = dsa_port_vid_add(other_dp, rx_vid, flags);
> -               else
> -                       err = dsa_port_vid_del(other_dp, rx_vid);
> +               err = dsa_8021q_vid_apply(ds, i, rx_vid, flags, enabled);
>                 if (err) {
>                         dev_err(ds->dev, "Failed to apply RX VID %d to port %d: %d\n",
>                                 rx_vid, port, err);
> @@ -193,10 +249,7 @@ int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int port, bool enabled)
>         /* CPU port needs to see this port's RX VID
>          * as tagged egress.
>          */
> -       if (enabled)
> -               err = dsa_port_vid_add(upstream_dp, rx_vid, 0);
> -       else
> -               err = dsa_port_vid_del(upstream_dp, rx_vid);
> +       err = dsa_8021q_vid_apply(ds, upstream, rx_vid, 0, enabled);
>         if (err) {
>                 dev_err(ds->dev, "Failed to apply RX VID %d to port %d: %d\n",
>                         rx_vid, port, err);
> @@ -204,26 +257,24 @@ int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int port, bool enabled)
>         }
>
>         /* Finally apply the TX VID on this port and on the CPU port */
> -       if (enabled)
> -               err = dsa_port_vid_add(dp, tx_vid, BRIDGE_VLAN_INFO_UNTAGGED);
> -       else
> -               err = dsa_port_vid_del(dp, tx_vid);
> +       err = dsa_8021q_vid_apply(ds, port, tx_vid, BRIDGE_VLAN_INFO_UNTAGGED,
> +                                 enabled);
>         if (err) {
>                 dev_err(ds->dev, "Failed to apply TX VID %d on port %d: %d\n",
>                         tx_vid, port, err);
>                 return err;
>         }
> -       if (enabled)
> -               err = dsa_port_vid_add(upstream_dp, tx_vid, 0);
> -       else
> -               err = dsa_port_vid_del(upstream_dp, tx_vid);
> +       err = dsa_8021q_vid_apply(ds, upstream, tx_vid, 0, enabled);
>         if (err) {
>                 dev_err(ds->dev, "Failed to apply TX VID %d on port %d: %d\n",
>                         tx_vid, upstream, err);
>                 return err;
>         }
>
> -       return 0;
> +       if (!enabled)
> +               err = dsa_8021q_restore_pvid(ds, port);
> +
> +       return err;
>  }
>  EXPORT_SYMBOL_GPL(dsa_port_setup_8021q_tagging);
>
> --
> 2.17.1
>

Thanks,
-Vladimir
