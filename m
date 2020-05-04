Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABAD01C461C
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 20:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgEDSil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 14:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726778AbgEDSij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 14:38:39 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD05C061A0F
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 11:38:38 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id t12so14450683edw.3
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 11:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fTDD2VPZVPs+4wr2Ar3GVpXywKzRxglPHg3Mz+UZktU=;
        b=jrhTAEPakzP2hcNrY9kEF84NCU+7+bdWFKIfvb8wwq1Dr1EO9PYabe0xVAn1k0jQ3Y
         rlwvXpVDmmkEg7eoDlYmyFWRmmJLkQzrb8BGoiO78nsKT9rqrYuKdDET3ahyEehHzIjn
         iof8itiT21KAatOQSRo+gkpLms1GroqwXNVLV7kmjL1hbWbOQzFCmVVizWRNstJKl0xf
         Y15WP4Zx3hQkYFeVDx5m6qqpD9Up8/5mKQJUy6rR43sVLMEciQ+GstPpF3q2K1VrX18b
         Jba58h/fQ26pOW1ojTG39UPVLc3r/T7CfBJFZmIjl/bCsEiKv89X61ThgxW7HztmoAl3
         LD+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fTDD2VPZVPs+4wr2Ar3GVpXywKzRxglPHg3Mz+UZktU=;
        b=a3drvhqL2Xb2ApraEDLbhACadBHOwoa5fkzHyAgz3e+u8Pzn2Y02BKhfAOS2FSK7On
         9fhzKUCBulAgUQs8ncZLn+taUN8ufhYp0Z65pkTtX0yNVAFkpw+UAg1Obpt8AohIU+mP
         GygzMf5Wucr4jombqeEcFlUnTGWG31pYnEyatXRnbpfrhP83OdI1yGXt20Imhzzg1eLI
         Xuga+lGFqSUZf4GjNHfI4rRvCynD8FIH7fV+4GYII7hVFRSV01NE+jQkV6cK7UJqxdZH
         18wu9M5SCP5pKuhsOpmeZ0mwek9c6v32mb2JEmfc9LygNlzjD/eovl/MLOTDPEGBRYLv
         VhnQ==
X-Gm-Message-State: AGi0PuaJWvn9RvpNCYngzNntOYPXIY6ekL99Op7Nxsxg3G5Pk+nLcV1v
        xOh9rzcZSlwAKy7zIG1gTh+pq3MvSgdvmkBmFJE=
X-Google-Smtp-Source: APiQypK/HxbRqVUp08i3uURQaSmdtCFpUKg+UyLkX1W+Kj8qwj4YbZfuJokcokashkw+Jfk/xoihtw8V8Xk+ZAL8rK8=
X-Received: by 2002:a50:8dc2:: with SMTP id s2mr16578866edh.318.1588617517456;
 Mon, 04 May 2020 11:38:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200503211035.19363-1-olteanv@gmail.com> <20200503211035.19363-5-olteanv@gmail.com>
 <20200504141913.GB941102@t480s.localdomain> <20200504142302.GD941102@t480s.localdomain>
In-Reply-To: <20200504142302.GD941102@t480s.localdomain>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 4 May 2020 21:38:26 +0300
Message-ID: <CA+h21howxs23VkvTVk3BiepQz7Z1vXgRiE1w+F1eeHYqYZmLpA@mail.gmail.com>
Subject: Re: [PATCH net-next 4/6] net: dsa: sja1105: support flow-based
 redirection via virtual links
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Po Liu <po.liu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang@nxp.com>,
        Mingkai Hu <mingkai.hu@nxp.com>,
        Christian Herber <christian.herber@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        vlad@buslov.dev, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vivien,

On Mon, 4 May 2020 at 21:23, Vivien Didelot <vivien.didelot@gmail.com> wrote:
>
> On Mon, 4 May 2020 14:19:13 -0400, Vivien Didelot <vivien.didelot@gmail.com> wrote:
> > Hi Vladimir,
> >
> > On Mon,  4 May 2020 00:10:33 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> > > +           case FLOW_ACTION_REDIRECT: {
> > > +                   struct dsa_port *to_dp;
> > > +
> > > +                   if (!dsa_slave_dev_check(act->dev)) {
> > > +                           NL_SET_ERR_MSG_MOD(extack,
> > > +                                              "Destination not a switch port");
> > > +                           return -EOPNOTSUPP;
> > > +                   }
> > > +
> > > +                   to_dp = dsa_slave_to_port(act->dev);
> >
> > Instead of exporting two DSA core internal functions, I would rather expose
> > a new helper for drivers, such as this one:
> >
> >     struct dsa_port *dsa_dev_to_port(struct net_device *dev)
> >     {
> >         if (!dsa_slave_dev_check(dev))
> >             return -EOPNOTSUPP;
>
> Oops, NULL, not an integer error code, but you get the idea of public helpers.
>
> >
> >         return dsa_slave_to_port(dev);
> >     }
> >
> > The naming might not be the best, this helper could even be mirroring-specific,
> > I didn't really check the requirements for this functionality yet.
> >
> >
> > Thank you,
> >
> >       Vivien

How about

int dsa_slave_get_port_index(struct net_device *dev)
{
    if (!dsa_slave_dev_check(dev))
        return -EINVAL;

    return dsa_slave_to_port(dev)->index;
}
EXPORT_SYMBOL_GPL(dsa_slave_get_port_index);

also, where to put it? slave.c I suppose?

Thanks,
-Vladimir
