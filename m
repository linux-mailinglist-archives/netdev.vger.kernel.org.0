Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8380BFC3DD
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 11:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfKNKTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 05:19:04 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:42996 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726869AbfKNKTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 05:19:03 -0500
Received: by mail-ed1-f65.google.com with SMTP id m13so4511881edv.9
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 02:19:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1EOL1+4SdPB8XyWEX5CLM5t0DHszcdq3iUcMtTL1IZI=;
        b=GkNfOXciOPR481POzoIGHN/rshoaTnk/OC97xNOJV1pbL7TwQPla5pz/Cpo80XhKzW
         rYp88xRLY7HpmjT9ev35o4IX70+0u0IVHhd6pho2eBzy+ZCdjRCLraCHYbkY2Wk7lSvR
         yOXlEXtH0hGBAOvgSojunGumY5m+m/EUnurg6P0QoSK58pUO8P9M7XbK8IZ+GktIdYwa
         qHtmaV1WvWS17Jr4nzguB8vBnqtbgi9iObJ/ua8VC/CSIvK5ccs7G84dddeGTFYYO3o/
         r1w9AJHmqOrAtwiS+8HckMmybYrBKnZo+h42vo0wTeZsLOyRaQGGj1W8p09VSf6UCLzw
         ijSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1EOL1+4SdPB8XyWEX5CLM5t0DHszcdq3iUcMtTL1IZI=;
        b=m+VciRYMH34AbhCjnaOLxc+LiTN0rC308sTrxpTVd1+0JP0HSvB2Usl90V6dhuqZvF
         +8o2FQyIhocI4Q8FYVB3BbsJ1weayLqm+oSn0sYm6Nxr4g2gQUzk/mI8rSrPqoBMDBxg
         /gIipXQBVf4axWy7VRdvc1LpHUtK0g6tHQOWn9tiPXFJqbzjqpwT3SwIqff2dGqFEXYO
         Wg4jStn/OLmqaFIOSZgzSH5Sxq8/p81s+NBc/8KTAqoPDWh66j7R0T/S2nA3q45WBOqr
         M5NjYNPrL7qU2vVlRx7ha6BQw/MQC3tZOAEJcbHzGRsZ1+XYKXIBT60bR7vSOokzF9Ox
         lyyA==
X-Gm-Message-State: APjAAAUPV6M4l9jpWjpwAgAZ3X+Z7uLlnXML/uLeYJ27xz1ZE7lCcveh
        ehktHMte2/GDXTzkfCenWtX/6V4vWx85i9v1JTQpmw==
X-Google-Smtp-Source: APXvYqxiFENfxgrWJujBhNVLISbxRs3YX2WSN4WD5BarebVszSpvLip95hM3AGNXqb44Z9dnEx1VKheA0r1t9EUER30=
X-Received: by 2002:a17:906:1d19:: with SMTP id n25mr7389912ejh.151.1573726741478;
 Thu, 14 Nov 2019 02:19:01 -0800 (PST)
MIME-Version: 1.0
References: <20191112212515.6663-1-olteanv@gmail.com>
In-Reply-To: <20191112212515.6663-1-olteanv@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 14 Nov 2019 12:18:50 +0200
Message-ID: <CA+h21hqpO91_LduJhhW7c1fr_0JJg54m8ovu5An-Ly+bzVtQ6g@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: sja1105: Make HOSTPRIO a kernel config
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Nov 2019 at 23:25, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Unfortunately with this hardware, there is no way to transmit in-band
> QoS hints with management frames (i.e. VLAN PCP is ignored). The traffic
> class for these is fixed in the static config (which in turn requires a
> reset to change).
>
> With the new ability to add time gates for individual traffic classes,
> there is a real danger that the user might unknowingly turn off the
> traffic class for PTP, BPDUs, LLDP etc.
>
> So we need to manage this situation the best we can. There isn't any
> knob in Linux for this, and changing it at runtime probably isn't worth
> it either. So just make the setting loud enough by promoting it to a
> Kconfig, which the user can customize to their particular setup.
>
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>  Documentation/networking/dsa/sja1105.rst |  4 ++--
>  drivers/net/dsa/sja1105/Kconfig          | 11 +++++++++++
>  drivers/net/dsa/sja1105/sja1105_main.c   |  2 +-
>  3 files changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/networking/dsa/sja1105.rst b/Documentation/networking/dsa/sja1105.rst
> index eef20d0bcf7c..2eaa6edf9c5b 100644
> --- a/Documentation/networking/dsa/sja1105.rst
> +++ b/Documentation/networking/dsa/sja1105.rst
> @@ -181,8 +181,8 @@ towards the switch, with the VLAN PCP bits set appropriately.
>  Management traffic (having DMAC 01-80-C2-xx-xx-xx or 01-19-1B-xx-xx-xx) is the
>  notable exception: the switch always treats it with a fixed priority and
>  disregards any VLAN PCP bits even if present. The traffic class for management
> -traffic has a value of 7 (highest priority) at the moment, which is not
> -configurable in the driver.
> +traffic is configurable through ``CONFIG_NET_DSA_SJA1105_HOSTPRIO``, which by
> +default has a value of 7 (highest priority).
>
>  Below is an example of configuring a 500 us cyclic schedule on egress port
>  ``swp5``. The traffic class gate for management traffic (7) is open for 100 us,
> diff --git a/drivers/net/dsa/sja1105/Kconfig b/drivers/net/dsa/sja1105/Kconfig
> index 0fe1ae173aa1..ac63054f578e 100644
> --- a/drivers/net/dsa/sja1105/Kconfig
> +++ b/drivers/net/dsa/sja1105/Kconfig
> @@ -17,6 +17,17 @@ tristate "NXP SJA1105 Ethernet switch family support"
>             - SJA1105R (Gen. 2, SGMII, No TT-Ethernet)
>             - SJA1105S (Gen. 2, SGMII, TT-Ethernet)
>
> +config NET_DSA_SJA1105_HOSTPRIO
> +       int "Traffic class for management traffic"
> +       range 0 7
> +       default 7
> +       depends on NET_DSA_SJA1105
> +       help
> +         Configure the traffic class which will be used for management
> +         (link-local) traffic injected and trapped to/from the CPU.
> +
> +         Higher is better as long as you care about your PTP frames.
> +
>  config NET_DSA_SJA1105_PTP
>         bool "Support for the PTP clock on the NXP SJA1105 Ethernet switch"
>         depends on NET_DSA_SJA1105
> diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
> index b60224c55244..907babeb8c8a 100644
> --- a/drivers/net/dsa/sja1105/sja1105_main.c
> +++ b/drivers/net/dsa/sja1105/sja1105_main.c
> @@ -388,7 +388,7 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
>                 /* Priority queue for link-local management frames
>                  * (both ingress to and egress from CPU - PTP, STP etc)
>                  */
> -               .hostprio = 7,
> +               .hostprio = CONFIG_NET_DSA_SJA1105_HOSTPRIO,
>                 .mac_fltres1 = SJA1105_LINKLOCAL_FILTER_A,
>                 .mac_flt1    = SJA1105_LINKLOCAL_FILTER_A_MASK,
>                 .incl_srcpt1 = false,
> --
> 2.17.1
>

Would a devlink property be better for this?

Thanks,
-Vladimir
