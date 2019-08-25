Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FED39C5A6
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 20:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbfHYSwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 14:52:36 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36636 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728739AbfHYSwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 14:52:36 -0400
Received: by mail-ed1-f67.google.com with SMTP id p28so23193151edi.3
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 11:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AQ8zhHQ8iLtZ+WqAIO7wVIcd/Lm8xNBsx99wFU6viEA=;
        b=WxrNvmFwXCjGehpL+ezF7+nI/8crd3IVWn6WdaM3Q49stKagmEhtVHc9m9mkx3N0II
         KYAg2xXnxFES6Dkl5aZV5hSpFzLtzk+RqDL7oQxrQUpOV0+CJEGBpPtHXHDI9I10twMD
         kTgjp/fnt9yVu79Q1UaYmlAfmXMpHdiY0Odw6XUacy7vG4a7yAS9At7kzgLdSTpOYUBS
         HZke//FKnA1nNuWji8ykDbSufxg/o4JR8+QyvkngHNyNUpXk52olYgRBlvBNy3uC6bS+
         aceod5xLyVDrviUwH+kddgCzNtGOf3+uH7IUDSGjm7g6Cmj/rfyokAU4IqF/IR8xUBsS
         PVSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AQ8zhHQ8iLtZ+WqAIO7wVIcd/Lm8xNBsx99wFU6viEA=;
        b=nMCxxjSa/7u7h0Wx2UyNBbmY+MGG/Xm0E04l2I6tIRuyDHzAklec/VdTQpMiD7vsh+
         w5rGVPAEFvd/qMNOw/sG5G8FUmWMrrV7fUvmmOdUiShEGdrzLx/QbecMRJBb64YB0V+D
         uKuSQXxp4TYtNPjz09d5PhlzyHm5E/8luqIrdMMOJCm3MU8issJEU9a1izAyBfiuGEOC
         7JFxs9whfj5WP4s3/tbwu0O06rlAlfc1QU8GF6Vczf8YRuUjStDfcM2Ym5wysb8HG2tR
         UW2gIhtMuc9qagB5S4NF9rS8FwTaprlkXhK5al0kISvPdpGOYoMloZcisa9uAwuG0s+f
         37OA==
X-Gm-Message-State: APjAAAVScjrC0cS4CVaEAe3fjXTypB0oX1uuMJcPjXRUbIOMEH21M2vw
        66085QsaRbOKx1CB4G5wb6ePnNW3pFlVqI6e16R9gA==
X-Google-Smtp-Source: APXvYqyuyMOsCRtyAt4IKC7ZdNDuSHD9WxJqhWvT5wDhYU7hchZtOPa6vf0nVc6f6H4f4X3lDBsNnAI2v6Bw5natdUw=
X-Received: by 2002:a05:6402:124f:: with SMTP id l15mr14960185edw.140.1566759153382;
 Sun, 25 Aug 2019 11:52:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190825184454.14678-1-olteanv@gmail.com> <20190825184454.14678-3-olteanv@gmail.com>
In-Reply-To: <20190825184454.14678-3-olteanv@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 25 Aug 2019 21:52:22 +0300
Message-ID: <CA+h21hoQR-4itfZsD50jVWt0Gd88YRzjdUcmr4SRR21W96++zA@mail.gmail.com>
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

I now realize that I shouldn't error out here, since it is not an
error to not have a pvid on the port. Will make this change in v3,
along with the other change requests that will arise upon review.

> +       }
> +
> +       err = br_vlan_get_info(slave, pvid, &vinfo);
> +       if (err < 0) {
> +               dev_err(ds->dev, "Couldn't determine PVID attributes\n");
> +               return err;
> +       }
> +
> +       return dsa_port_vid_add(&ds->ports[port], pvid, vinfo.flags);
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

Thanks!
-Vladimir
