Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13FAA25EF45
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 19:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgIFRNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 13:13:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbgIFRNh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 13:13:37 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43A6F20709;
        Sun,  6 Sep 2020 17:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599412417;
        bh=G5dl8Ov6nsLIXrSjUsnfZTrl6XpPGIow5alsRi6MqUE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZufotFHZfCgh79d1HjT7VMbUjHr/Dx+5Erz5KdNbbbYT/C4oMfr1jcROS53xM9Dg5
         mDhS2esqFQJuI6UB8Bk2UN9Y8gv7AmGq2EMIZzwzDY1Ti4SOVG5TTfcfWXzQus/Gdy
         sl4e+Jbv66cvNuafv4f9+L3UBeQFjxok+twX42T8=
Date:   Sun, 6 Sep 2020 10:13:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>, jtoppins@redhat.com,
        Netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: Failing to attach bond(created with two interfaces from
 different NICs) to a bridge
Message-ID: <20200906101335.47b2b60b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200906111249.GA2419244@shredder.lan>
References: <CAACQVJo_n+PsHd2wBVrAAQZm9On89TcEQ5TAn7ZpZ1SNWU0exg@mail.gmail.com>
        <20200903121428.4f86ef1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200906111249.GA2419244@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 6 Sep 2020 14:12:49 +0300 Ido Schimmel wrote:
> On Thu, Sep 03, 2020 at 12:14:28PM -0700, Jakub Kicinski wrote:
> > On Thu, 3 Sep 2020 12:52:25 +0530 Vasundhara Volam wrote:  
> > > Hello Jiri,
> > > 
> > > After the following set of upstream commits, the user fails to attach
> > > a bond to the bridge, if the user creates the bond with two interfaces
> > > from different bnxt_en NICs. Previously bnxt_en driver does not
> > > advertise the switch_id for legacy mode as part of
> > > ndo_get_port_parent_id cb but with the following patches, switch_id is
> > > returned even in legacy mode which is causing the failure.
> > > 
> > > ---------------
> > > 7e1146e8c10c00f859843817da8ecc5d902ea409 net: devlink: introduce
> > > devlink_compat_switch_id_get() helper
> > > 6605a226781eb1224c2dcf974a39eea11862b864 bnxt: pass switch ID through
> > > devlink_port_attrs_set()
> > > 56d9f4e8f70e6f47ad4da7640753cf95ae51a356 bnxt: remove
> > > ndo_get_port_parent_id implementation for physical ports
> > > ----------------
> > > 
> > > As there is a plan to get rid of ndo_get_port_parent_id in future, I
> > > think there is a need to fix devlink_compat_switch_id_get() to return
> > > the switch_id only when device is in SWITCHDEV mode and this effects
> > > all the NICs.
> > > 
> > > Please let me know your thoughts. Thank you.  
> > 
> > I'm not Jiri, but I'd think that hiding switch_id from devices should
> > not be the solution here. Especially that no NICs offload bridging
> > today. 
> > 
> > Could you describe the team/bridge failure in detail, I'm not that
> > familiar with this code.  
> 
> Maybe:
> 
> br_add_slave()
> 	br_add_if()
> 		nbp_switchdev_mark_set()
> 			dev_get_port_parent_id()
> 
> I believe the last call will return '-ENODATA' because the two bnxt
> netdevs member in the bond have different switch IDs. Perhaps the 
> function can be changed to return '-EOPNOTSUPP' when it's called for an
> upper device that have multiple parent IDs beneath it:
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index d42c9ea0c3c0..7932594ca437 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -8646,7 +8646,7 @@ int dev_get_port_parent_id(struct net_device *dev,
>                 if (!first.id_len)
>                         first = *ppid;
>                 else if (memcmp(&first, ppid, sizeof(*ppid)))
> -                       return -ENODATA;
> +                       return -EOPNOTSUPP;
>         }
>  
>         return err;

LGTM, or we could make bridge ignore ENODATA (in case the distinctions
is useful?)

I was searching for the early versions of Florian's patch set but
I can't find it :( Florian, do you remember if there was a reason to
fail bridge in this case?
