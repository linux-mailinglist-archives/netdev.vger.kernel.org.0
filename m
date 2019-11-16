Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73A8FFF38A
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbfKPQ0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:26:20 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:34446 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728181AbfKPQ0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 11:26:19 -0500
Received: by mail-ed1-f65.google.com with SMTP id b72so10002076edf.1
        for <netdev@vger.kernel.org>; Sat, 16 Nov 2019 08:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EkE9lD9d5wUh4kVaonzPLXUhfJe2wUvnmLITV+APzNk=;
        b=UGE1yJIISHVIGGrxG4QykFWWHRRnVU5Jo9M/hHRdF6CEODbpx25jXYksrdl8VDAAPs
         uYEqTq33BRBNk3yYzQptbsp227hIlgSSN7D7z8w62lZuomjSL2ZWB2jhK8Dhw6PQqkhQ
         7uasc6cu9+Pfjn9oi5YCW+KRhpsL/IKVkoGBXWQmarzvhe4MNvFIKBhKkHYE5lyc5jY7
         cGqj/qxo0pr0yJ18mGkR18pXMDK7W+sthToIHFP8WShpfD0zApFBwODX6Q++QCPTWa9j
         884bBsQEnZmEZbuaxKtN8lPbDldnb0kq/w1YZ70mklfeSvhbUtYPL4gTYvMI6fNw1oK4
         5iKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EkE9lD9d5wUh4kVaonzPLXUhfJe2wUvnmLITV+APzNk=;
        b=LZr0zWzKr5+3+6U+H+sLdRBbYeF07bNHKBi4tTuqxQbKQObu5k0DOaej0MuSUM3D0R
         WATWbXgrKd0vZyVF84XDDYBMIt6BTVgSwtlFsW7/kPpXhBLAPfovYsllYLC2BmxN8NQi
         OAjbqRhIckKuxzIggif7FMkz2GhipNf9vyAzw1ea5RhwygC+4PjT+c03JoKoQR2aTWRY
         mCHPuYyylY5pnVzwANfxsZeuEGavp3ufjFazTCsBi7Tk48aiiOa9JF+QNyVk0pdXKwXB
         /nw3OSZ8DkxNQTofGKiFHdRbI0InLoRPu1lX+9AgzoiZRjuxTzGelpP2IQJjpfsFIVNY
         ta+A==
X-Gm-Message-State: APjAAAUC04zRdzrWp+vk9saxFoRUNkmCoB46H9v0UyZWbwIb23YBNpVS
        vwYci9xP85iSNe9L6Kd+ASaaibalmu8Rqto+HVg=
X-Google-Smtp-Source: APXvYqxahVLTg5ncbUb1viYzaYX2hEjfu8IrlORTJ8OMGIF0g0eSHZs9LyvYwA+dBGEnhowwLGPvZ23EGkVVTOfMwOw=
X-Received: by 2002:a17:906:1d19:: with SMTP id n25mr10633213ejh.151.1573921577518;
 Sat, 16 Nov 2019 08:26:17 -0800 (PST)
MIME-Version: 1.0
References: <20191116160842.29511-1-olteanv@gmail.com> <20191116162424.GG5653@lunn.ch>
In-Reply-To: <20191116162424.GG5653@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 16 Nov 2019 18:26:06 +0200
Message-ID: <CA+h21hraJBaizE1VDaH+sKRe-M-RQUsKU5rJh=UJ9WANCbFwcg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: tag_8021q: Fix dsa_8021q_restore_pvid
 for an absent pvid
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

On Sat, 16 Nov 2019 at 18:24, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sat, Nov 16, 2019 at 06:08:42PM +0200, Vladimir Oltean wrote:
> > This sequence of operations:
> > ip link set dev br0 type bridge vlan_filtering 1
> > bridge vlan del dev swp2 vid 1
> > ip link set dev br0 type bridge vlan_filtering 1
> > ip link set dev br0 type bridge vlan_filtering 0
>
> > --- a/net/dsa/tag_8021q.c
> > +++ b/net/dsa/tag_8021q.c
> > @@ -105,7 +105,7 @@ static int dsa_8021q_restore_pvid(struct dsa_switch *ds, int port)
> >       slave = dsa_to_port(ds, port)->slave;
> >
> >       err = br_vlan_get_pvid(slave, &pvid);
> > -     if (err < 0)
> > +     if (!pvid || err < 0)
> >               /* There is no pvid on the bridge for this port, which is
> >                * perfectly valid. Nothing to restore, bye-bye!
> >                */
>
> This looks very similar to the previous patch. Some explanation would
> be good. Did you send it for the wrong tree? Or are there really
> different fixes for different trees?
>
> Thanks
>         Andrew

Hi Andrew,

The context is different:
dsa_to_port(ds, port)
vs
ds->ports[port]

This is due to Vivien's recent rework in DSA's port list vs port array.

Regards,
-Vladimir
