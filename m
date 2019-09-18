Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A94F3B6639
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 16:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730787AbfIROgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 10:36:22 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:45356 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbfIROgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 10:36:21 -0400
Received: by mail-ed1-f65.google.com with SMTP id h33so160764edh.12
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 07:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tg+zBVdGCNQ1jVIHOEFvQ0Gy20wX0cZPJGaO0LaU7Ng=;
        b=hB6RCbcrLJ7laIiBQ/6wKMCCUinhqOG99EbNN93e6VP9eAF7jpQILyn6N49yjk6ACR
         A/s9SFF2D27xtzFrxwoLnUGt0qhmmQBFYt3jWJ0smTeaIc2DK3aVBHW3fZ21OorhB24Y
         2otezmq+wcBzJLdrgqXVFKl/4ncyvOAGnI3sgiaRA/2u6TPWkx6Qf1Wst/KX5fnGWCNv
         zkqAaCsUDAN2vNVRoznjyl8J9ISX0KuuUKVQGA/Z3co+0DpTaOwXUv7D7t/0Qb7R798J
         tVyZkxPImSOd1a1qxztp4YviHPcCzbEw0HDsR7HFacRqG0R4TocPVyv+DnZiPYwTcy4R
         wxsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tg+zBVdGCNQ1jVIHOEFvQ0Gy20wX0cZPJGaO0LaU7Ng=;
        b=WC/l3o6c0e8dOxJqMlLiZfDy60euVyoQ11fWF/L4EtVryeRzO4CtTmXOpYbj0pZIiP
         OYQy7dECsMYNpKHqXUjA3Z+M7ddwTfVgphthnvhP6k6kRzT3jT9wqKO+3i8k2PZI/eN7
         eM6wTbqApQfXEHTtSQFDaL2aDm4xnxlBQAS/Rs0B1usi14M1YNKPxroXnMJbGTbsvh3q
         pn3ITsns9m03OcybUd51UB40HfVLjUcSt/ZmARromDf13NJ8uE2u2PGwt4XLh5Fzdx5Q
         4iNH614D/xJeAFXzYDvrhxTtxy3EltpV42o9pzXYiJmBTUloN5n2ypBeFVqEfdE7rRk5
         gGjA==
X-Gm-Message-State: APjAAAU7pFty2+ri2FGdgWxT5u95AwgUreOKqfUnOLGAdoLOXOZDknCr
        uQqd7A+yYCBjZp1MiTheY2Tcme4B9B1rgBXHEyU=
X-Google-Smtp-Source: APXvYqz37K6NjSAnVl6vgDaZ81ocfmlySkZfY/6o9wnZj4vhDdBlhx2rCq4OUKI+f96+zVzonsAZnG6Zb1q+9sNEmLY=
X-Received: by 2002:a05:6402:35b:: with SMTP id r27mr9502868edw.140.1568817379701;
 Wed, 18 Sep 2019 07:36:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190918140225.imqchybuf3cnknob@pengutronix.de>
In-Reply-To: <20190918140225.imqchybuf3cnknob@pengutronix.de>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 18 Sep 2019 17:36:08 +0300
Message-ID: <CA+h21hpG52R6ScGpGX86Q7MuRHCgGNY-TxzaQGu2wZR8EtPtbA@mail.gmail.com>
Subject: Re: dsa traffic priorization
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Florian Fainelli <f.fainelli@gmail.com>, kernel@pengutronix.de
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sascha,

On Wed, 18 Sep 2019 at 17:03, Sascha Hauer <s.hauer@pengutronix.de> wrote:
>
> Hi All,
>
> We have a customer using a Marvell 88e6240 switch with Ethercat on one port and
> regular network traffic on another port. The customer wants to configure two things
> on the switch: First Ethercat traffic shall be priorized over other network traffic
> (effectively prioritizing traffic based on port). Second the ethernet controller
> in the CPU is not able to handle full bandwidth traffic, so the traffic to the CPU
> port shall be rate limited.
>

You probably already know this, but egress shaping will not drop
frames, just let them accumulate in the egress queue until something
else happens (e.g. queue occupancy threshold triggers pause frames, or
tail dropping is enabled, etc). Is this what you want? It sounds a bit
strange to me to configure egress shaping on the CPU port of a DSA
switch. That literally means you are buffering frames inside the
system. What about ingress policing?

> For reference the patch below configures the switch to their needs. Now the question
> is how this can be implemented in a way suitable for mainline. It looks like the per
> port priority mapping for VLAN tagged packets could be done via ip link add link ...
> ingress-qos-map QOS-MAP. How the default priority would be set is unclear to me.
>

Technically, configuring a match-all rxnfc rule with ethtool would
count as 'default priority' - I have proposed that before. Now I'm not
entirely sure how intuitive it is, but I'm also interested in being
able to configure this.

> The other part of the problem seems to be that the CPU port has no network device
> representation in Linux, so there's no interface to configure the egress limits via tc.
> This has been discussed before, but it seems there hasn't been any consensous regarding how
> we want to proceed?
>
> Sascha
>
> -----------------------------8<-----------------------------------
>
>  drivers/net/dsa/mv88e6xxx/chip.c | 54 +++++++++++++++++++-
>  drivers/net/dsa/mv88e6xxx/port.c | 87 ++++++++++++++++++++++++++++++++
>  drivers/net/dsa/mv88e6xxx/port.h | 19 +++++++
>  3 files changed, 159 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index d0a97eb73a37..2a15cf259d04 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -2090,7 +2090,9 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
>  {
>          struct dsa_switch *ds = chip->ds;
>          int err;
> +        u16 addr;
>          u16 reg;
> +        u16 val;
>
>          chip->ports[port].chip = chip;
>          chip->ports[port].port = port;
> @@ -2246,7 +2248,57 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
>          /* Default VLAN ID and priority: don't set a default VLAN
>           * ID, and set the default packet priority to zero.
>           */
> -        return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_DEFAULT_VLAN, 0);
> +        err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_DEFAULT_VLAN, 0);
> +        if (err)
> +                return err;
> +
> +#define SWITCH_CPU_PORT 5
> +#define SWITCH_ETHERCAT_PORT 3
> +
> +        /* set the egress rate */
> +        switch (port) {
> +                case SWITCH_CPU_PORT:
> +                        err = mv88e6xxx_port_set_egress_rate(chip, port,
> +                                        MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_MODE_FRAME, 30000);
> +                        break;
> +                default:
> +                        err = mv88e6xxx_port_set_egress_rate(chip, port,
> +                                        MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_MODE_FRAME, 0);
> +                        break;
> +        }
> +
> +        if (err)
> +                return err;
> +
> +        /* set the output queue usage */
> +        switch (port) {
> +                case SWITCH_CPU_PORT:
> +                        err = mv88e6xxx_port_set_output_queue_schedule(chip, port,
> +                                        MV88E6XXX_PORT_EGRESS_RATE_CTL2_SCHEDULE_Q3_STRICT);
> +                        break;
> +                default:
> +                        err = mv88e6xxx_port_set_output_queue_schedule(chip, port,
> +                                        MV88E6XXX_PORT_EGRESS_RATE_CTL2_SCHEDULE_NONE_STRICT);
> +                        break;
> +        }
> +
> +        if (err)
> +                return err;
> +
> +        /* set the default QPri */
> +        switch (port) {
> +                case SWITCH_ETHERCAT_PORT:
> +                        err = mv88e6xxx_port_set_default_qpri(chip, port, 3);
> +                        break;
> +                default:
> +                        err = mv88e6xxx_port_set_default_qpri(chip, port, 2);
> +                        break;
> +        }
> +
> +        if (err)
> +                return err;
> +
> +        return 0;
>  }
>
>  static int mv88e6xxx_port_enable(struct dsa_switch *ds, int port,
> diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
> index 04309ef0a1cc..e03f24308f15 100644
> --- a/drivers/net/dsa/mv88e6xxx/port.c
> +++ b/drivers/net/dsa/mv88e6xxx/port.c
> @@ -1147,6 +1147,22 @@ int mv88e6165_port_set_jumbo_size(struct mv88e6xxx_chip *chip, int port,
>          return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL2, reg);
>  }
>
> +int mv88e6xxx_port_set_default_qpri(struct mv88e6xxx_chip *chip, int port, int qpri)
> +{
> +        u16 reg;
> +        int err;
> +
> +        err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_CTL2, &reg);
> +        if (err)
> +                return err;
> +
> +        reg &= ~MV88E6XXX_PORT_CTL2_DEF_QPRI_MASK;
> +        reg |= (qpri << 1) & MV88E6XXX_PORT_CTL2_DEF_QPRI_MASK;
> +        reg |= MV88E6XXX_PORT_CTL2_USE_DEF_QPRI;
> +
> +        return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL2, reg);
> +}
> +
>  /* Offset 0x09: Port Rate Control */
>
>  int mv88e6095_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port)
> @@ -1161,6 +1177,77 @@ int mv88e6097_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port)
>                                      0x0001);
>  }
>
> +int mv88e6xxx_port_set_output_queue_schedule(struct mv88e6xxx_chip *chip, int port,
> +                                             u16 schedule)
> +{
> +        u16 reg;
> +        int err;
> +
> +        err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_EGRESS_RATE_CTL2, &reg);
> +        if (err)
> +                return err;
> +
> +        reg &= ~MV88E6XXX_PORT_EGRESS_RATE_CTL2_SCHEDULE_MASK;
> +        reg |= schedule;
> +
> +        return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_EGRESS_RATE_CTL2, reg);
> +}
> +
> +static int _mv88e6xxx_egress_rate_calc_frames(u32 rate, u16 *egress_rate_val)
> +{
> +        const volatile u32 scale_factor = (1000 * 1000 * 1000);
> +        volatile u32 u;
> +
> +        if (rate > 1488000)
> +                return EINVAL;
> +
> +        if (rate < 7600)
> +                return EINVAL;
> +
> +        u = 32 * rate;
> +        u = scale_factor / u; /* scale_factor used to convert 32s into 32ns */
> +
> +        *egress_rate_val = (u16)u;
> +
> +        return 0;
> +}
> +
> +int mv88e6xxx_port_set_egress_rate(struct mv88e6xxx_chip *chip, int port, u16 type,
> +                                   u32 rate)
> +{
> +        u16 reg;
> +        int err;
> +        u16 egress_rate_val;
> +
> +        err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_EGRESS_RATE_CTL2, &reg);
> +        if (err)
> +                return err;
> +
> +        reg &= ~MV88E6XXX_PORT_EGRESS_RATE_CTL2_RATE_MASK;
> +
> +        if (rate) {
> +                reg &= ~MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_MODE_MASK;
> +                reg |= type;
> +
> +                switch (type) {
> +                        case MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_MODE_FRAME:
> +                                err = _mv88e6xxx_egress_rate_calc_frames(rate, &egress_rate_val);
> +                                if (err)
> +                                        return err;
> +                                reg |= egress_rate_val & 0x0FFF;
> +                                break;
> +                        case MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_MODE_L1:
> +                        case MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_MODE_L2:
> +                        case MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_MODE_L3:
> +                                return EINVAL; /* ToDo */
> +                        default:
> +                                return EINVAL;
> +                }
> +        }
> +
> +        return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_EGRESS_RATE_CTL2, reg);
> +}
> +
>  /* Offset 0x0C: Port ATU Control */
>
>  int mv88e6xxx_port_disable_learn_limit(struct mv88e6xxx_chip *chip, int port)
> diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
> index 8d5a6cd6fb19..cdd057c52ab8 100644
> --- a/drivers/net/dsa/mv88e6xxx/port.h
> +++ b/drivers/net/dsa/mv88e6xxx/port.h
> @@ -197,6 +197,8 @@
>  #define MV88E6XXX_PORT_CTL2_DEFAULT_FORWARD                0x0040
>  #define MV88E6XXX_PORT_CTL2_EGRESS_MONITOR                0x0020
>  #define MV88E6XXX_PORT_CTL2_INGRESS_MONITOR                0x0010
> +#define MV88E6XXX_PORT_CTL2_USE_DEF_QPRI        0x0008
> +#define MV88E6XXX_PORT_CTL2_DEF_QPRI_MASK        0x0006
>  #define MV88E6095_PORT_CTL2_CPU_PORT_MASK                0x000f
>
>  /* Offset 0x09: Egress Rate Control */
> @@ -204,6 +206,17 @@
>
>  /* Offset 0x0A: Egress Rate Control 2 */
>  #define MV88E6XXX_PORT_EGRESS_RATE_CTL2                0x0a
> +#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_MODE_MASK 0xC000
> +#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_MODE_FRAME 0x0000
> +#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_MODE_L1 0x4000
> +#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_MODE_L2 0x8000
> +#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_MODE_L3 0xC000
> +#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_SCHEDULE_MASK 0x3000
> +#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_SCHEDULE_NONE_STRICT 0x0000
> +#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_SCHEDULE_Q3_STRICT 0x1000
> +#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_SCHEDULE_Q3_Q2_STRICT 0x2000
> +#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_SCHEDULE_ALL_STRICT 0x3000
> +#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_RATE_MASK 0x0FFF
>
>  /* Offset 0x0B: Port Association Vector */
>  #define MV88E6XXX_PORT_ASSOC_VECTOR                        0x0b
> @@ -326,8 +339,14 @@ int mv88e6xxx_port_set_message_port(struct mv88e6xxx_chip *chip, int port,
>                                      bool message_port);
>  int mv88e6165_port_set_jumbo_size(struct mv88e6xxx_chip *chip, int port,
>                                    size_t size);
> +int mv88e6xxx_port_set_default_qpri(struct mv88e6xxx_chip *chip, int port,
> +                                  int qpri);
>  int mv88e6095_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port);
>  int mv88e6097_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port);
> +int mv88e6xxx_port_set_output_queue_schedule(struct mv88e6xxx_chip *chip, int port,
> +                                  u16 schedule);
> +int mv88e6xxx_port_set_egress_rate(struct mv88e6xxx_chip *chip, int port,
> +                                  u16 type, u32 rate);
>  int mv88e6097_port_pause_limit(struct mv88e6xxx_chip *chip, int port, u8 in,
>                                 u8 out);
>  int mv88e6390_port_pause_limit(struct mv88e6xxx_chip *chip, int port, u8 in,
> --
> 2.23.0
>
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

Regards,
-Vladimir
