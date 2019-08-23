Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9891E9B3C5
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 17:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436519AbfHWPpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 11:45:06 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:34883 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387803AbfHWPpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 11:45:05 -0400
Received: by mail-ed1-f67.google.com with SMTP id t50so14143771edd.2
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 08:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vIGb3R+jfWL3N0X5Qw5qtMDpcswbDHoG5Ll+OaD90Og=;
        b=ojoIS9q0Bj1F0xdbrkX5P+4NtvH1/4d/kItTaIm/00BzNSy9NW0BHBlCJFX7O+UUIr
         0CxIxHk+zCxNA/jln7ut1dQn/Meo4SwNdTtT/cWg7RYWq1dsek0JpqsrI4rRWAb+Wcb+
         +EAMJyTtGPxUFL20J1xnYCexIVNkI0dGKZzi4uUuEJYyp/f8q3g5EVULOwFL5o8+fVG/
         T6ATceafipj1BlSfxqsgpDvan0NCJOxOqfJhg9r/oOC7OSC1kh8KtY11hW2QR9N0wwx0
         nhiQXxGT0k/6nhwXQA5pepGavcF9NIaerQIqnFxnhmJvUw7OMcb5BJGWLl+Crrt2pUHZ
         jUwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vIGb3R+jfWL3N0X5Qw5qtMDpcswbDHoG5Ll+OaD90Og=;
        b=Lq/u6oeFZS5IwDIvyUQ4yKo3MTjkVTVQv6+IPmfeHjvKicDEYBQDiHT7fGHm9k77gT
         LVImezZSkop6F28p8tp7V5/hNL3toJyPdH2brbzpQAuIdmX45FJzXKueua4kPtdX7pFg
         s6mGj8Pwd2hN8RcvlAiAtPh0fDdfFz4eaPG29oJ36eMAAzff6oAGZAQ0aYKnQjwtom+Y
         OaJvsd92gYec2tMghq+nyNNcTbyyUPiNEphwScXZj3znChWHh0RoE9LUJW9MMPH+SXOn
         Z2Rh4BS3PtrdKDOE8sfibDQwcsTC6u5eXHXZWflZwvfTFl0aolUqToUlb2jXQ9qJhynW
         tO7w==
X-Gm-Message-State: APjAAAURRxgkwjaMQ61wcQ1Vk3SJzhYdG5edcBMdjYEuAdw9u/ysVw4U
        G88UElzRSdwLRCEor5J95P1NdclQksnnT8teqfg=
X-Google-Smtp-Source: APXvYqzTtjOy2qbqb73sZFsV0zwPevIXzix5PPWa0XdrCTDctV6nUZ3zK7kt9C2DzLTTT/dlvC4t5y6a6wJTfWZrDKc=
X-Received: by 2002:a50:9dc8:: with SMTP id l8mr5261163edk.108.1566575104065;
 Fri, 23 Aug 2019 08:45:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190822201323.1292-1-vivien.didelot@gmail.com> <20190822201323.1292-6-vivien.didelot@gmail.com>
In-Reply-To: <20190822201323.1292-6-vivien.didelot@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 23 Aug 2019 18:44:52 +0300
Message-ID: <CA+h21hofEiB+rypFKrt0Dy3OfUvk5n6s=sTmb9r83yBzVVA7ZQ@mail.gmail.com>
Subject: Re: [PATCH net-next 5/6] net: dsa: program VLAN on CPU port from slave
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Aug 2019 at 23:13, Vivien Didelot <vivien.didelot@gmail.com> wrote:
>
> DSA currently programs a VLAN on the CPU port implicitly after the
> related notifier is received by a switch.
>
> While we still need to do this transparent programmation of the DSA
> links in the fabric, programming the CPU port this way may cause
> problems in some corners such as the tag_8021q driver.
>
> Because the dedicated CPU port is specific to a slave, make their
> programmation explicit a few layers up, in the slave code.
>
> Note that technically, DSA links have a dedicated CPU port as well,
> but since they are only used as conduit between interconnected switches
> of a fabric, programming them transparently this way is fine.
>
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
> ---
>  net/dsa/slave.c  | 14 ++++++++++++++
>  net/dsa/switch.c |  5 ++++-
>  2 files changed, 18 insertions(+), 1 deletion(-)
>
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 82e48d247b81..8267c156a51a 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -332,6 +332,10 @@ static int dsa_slave_vlan_add(struct net_device *dev,
>         if (err)
>                 return err;
>
> +       err = dsa_port_vlan_add(dp->cpu_dp, &vlan, trans);
> +       if (err)
> +               return err;
> +
>         return 0;
>  }
>
> @@ -383,6 +387,9 @@ static int dsa_slave_vlan_del(struct net_device *dev,
>         if (dp->bridge_dev && !br_vlan_enabled(dp->bridge_dev))
>                 return 0;
>
> +       /* Do not deprogram the CPU port as it may be shared with other user
> +        * ports which can be members of this VLAN as well.
> +        */

+1 for the comments, the deletion of dp->cpu_dp is less likely to get
patched into the code in the future now.

>         return dsa_port_vlan_del(dp, SWITCHDEV_OBJ_PORT_VLAN(obj));
>  }
>
> @@ -1121,6 +1128,10 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
>         if (ret && ret != -EOPNOTSUPP)
>                 return ret;
>
> +       ret = dsa_port_vid_add(dp->cpu_dp, vid, 0);
> +       if (ret && ret != -EOPNOTSUPP)
> +               return ret;
> +

I think it's worth understanding what the EOPNOTSUPP -> 0 is avoiding.

>         return 0;
>  }
>
> @@ -1151,6 +1162,9 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
>         if (ret == -EOPNOTSUPP)
>                 ret = 0;
>
> +       /* Do not deprogram the CPU port as it may be shared with other user
> +        * ports which can be members of this VLAN as well.
> +        */
>         return ret;
>  }
>
> diff --git a/net/dsa/switch.c b/net/dsa/switch.c
> index 489eb7b430a4..6a9607518823 100644
> --- a/net/dsa/switch.c
> +++ b/net/dsa/switch.c
> @@ -232,7 +232,7 @@ static bool dsa_switch_vlan_match(struct dsa_switch *ds, int port,
>         if (ds->index == info->sw_index && port == info->port)
>                 return true;
>
> -       if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
> +       if (dsa_is_dsa_port(ds, port))

Much better, thank you.



>                 return true;
>
>         return false;
> @@ -288,6 +288,9 @@ static int dsa_switch_vlan_del(struct dsa_switch *ds,
>         if (ds->index == info->sw_index)
>                 return ds->ops->port_vlan_del(ds, info->port, info->vlan);
>
> +       /* Do not deprogram the DSA links as they may be used as conduit
> +        * for other VLAN members in the fabric.
> +        */
>         return 0;
>  }
>
> --
> 2.23.0
>
