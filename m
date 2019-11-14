Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1ECFC697
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 13:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbfKNMxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 07:53:36 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:40160 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbfKNMxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 07:53:35 -0500
Received: by mail-ed1-f65.google.com with SMTP id p59so4893412edp.7
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 04:53:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qLg2+eH3JUu/yykgEIBs5zYXw+HgK9jKtrrlrB8F9Ac=;
        b=KkyUdx8t/Fvk2P4hriE7gT4fQi2CkQ24pXYI5YapiVpEqQd6axrkmx7Qp/m9mTs4mM
         we2rG1f/GTGmTyWWO06qE2p801v21xhO3wNQpq71CJaK3bQ0onmXbuqSjV2HchkFlwI3
         vt45dKjM5oVBqhdhqIhKliPM5acYOT1wlTLyEuD52yyPgHp+JQ4CWAPUB7o+0q9dQB3S
         cxqJdaI3xmkRV8cQ+YA6vW3sA6eay6vH/2Gxl24YTsl2nGn70owdnUzFUJLy0l/BlBnv
         TKQ2l2JvXlXTghXFiJUnLvBex/jiN+1gd7WrffDbhoALupHe8SKv2n8nP3LDVbTn94JT
         YSww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qLg2+eH3JUu/yykgEIBs5zYXw+HgK9jKtrrlrB8F9Ac=;
        b=er8QFlKl+dhyUromVk2/uqnemZ/bmc8CZ8qx6fkjWo1sfQdpgfG9kziW9N9XVsqPvb
         KYj3wKvMf0nMNNZfn9aIdL5cSZJ3LuN0xiGUtBlEqEtPOCN/Q2mP92OPKfXuxYAsD8Uy
         qSIJH9GPtybhBK6NexRJWDvxGVutelGT5xyjE6DFQlPS0BuLNtRfCsHVkKhd8jia3yda
         F+f6rjwpxMw8lqsKj01bEXDv8lkzhvv+B5LCgjEZ8H/tXKdnFZSZuFPNNM6QB9JYWWjJ
         KlAYjipw+1FVYEGBZgSPLF3p8hW0LximzR+ZwFklQ3qma3fAW0Exb9M90mcvAgCAanCJ
         0zlw==
X-Gm-Message-State: APjAAAVi1Iyz97RMdRNgcOJkkDyHRbParzuuBmaCtF/8L/52Czbtwptk
        Jc6Al2PZZlXBXQGwDmuT0dy4dWSSnodq9Wb87yE=
X-Google-Smtp-Source: APXvYqw04ngNLw0TvuM0E32yRvep9Ed4h56uEbHXG1RdBijCN17u4FCpyHbybqFyTJLSwdBYvTONL4hPNchqqasaCCw=
X-Received: by 2002:a17:906:3450:: with SMTP id d16mr7996004ejb.216.1573736012797;
 Thu, 14 Nov 2019 04:53:32 -0800 (PST)
MIME-Version: 1.0
References: <20191112212200.5572-1-olteanv@gmail.com> <20191113035321.GC16688@lunn.ch>
In-Reply-To: <20191113035321.GC16688@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 14 Nov 2019 14:53:21 +0200
Message-ID: <CA+h21ho84nWHcH0R+3oUBjShW65Ks63q1N+8CeNbDEa8tXkoow@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: sja1105: Print the reset reason
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Wed, 13 Nov 2019 at 05:53, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Tue, Nov 12, 2019 at 11:22:00PM +0200, Vladimir Oltean wrote:
> > Sometimes it can be quite opaque even for me why the driver decided to
> > reset the switch. So instead of adding dump_stack() calls each time for
> > debugging, just add a reset reason to sja1105_static_config_reload
> > calls which gets printed to the console.
>
> > +int sja1105_static_config_reload(struct sja1105_private *priv,
> > +                              enum sja1105_reset_reason reason)
> >  {
> >       struct ptp_system_timestamp ptp_sts_before;
> >       struct ptp_system_timestamp ptp_sts_after;
> > @@ -1405,6 +1413,10 @@ int sja1105_static_config_reload(struct sja1105_private *priv)
> >  out_unlock_ptp:
> >       mutex_unlock(&priv->ptp_data.lock);
> >
> > +     dev_info(priv->ds->dev,
> > +              "Reset switch and programmed static config. Reason: %s\n",
> > +              sja1105_reset_reasons[reason]);
>
> If this is for debugging, maybe dev_dbg() would be better?
>
>    Andrew

This should not be a debugging print, a reset is an important event in
the life of the switch and I would like the user to be aware of it.
When I said "debugging" I meant "figure out the reason why it needed
to reset this time".

Thanks,
-Vladimir
