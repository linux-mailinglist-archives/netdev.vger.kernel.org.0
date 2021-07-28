Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481B03D8705
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 07:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbhG1FGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 01:06:06 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:47698
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229714AbhG1FGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 01:06:05 -0400
Received: from famine.localdomain (1.general.jvosburgh.us.vpn [10.172.68.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id D85DB3F23F;
        Wed, 28 Jul 2021 05:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627448763;
        bh=ywpuTyMAe+q9pQuzppxk7eduIPrzgF4xA3rY+4E3WZc=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=fsXbSq9TP8/IAdQGhbplmZq1xKo49WUIJYL/XiXYMP0gyzPV8l5Sc0KRYABoXFSx0
         lsd2XfEZ7C6eT1wht2tl/4hsT0pUnfUDJqluMnKTfRnpJc9YQkGogNLuzr2KatgTPB
         YT5AYbNmlCdFqQNthF9IMiOslOZuE5oLuvMjY7R3ERA6rVEWXDXLEr5mDg7t0E7HnL
         K4HdClLFOrleY4bOsE3+Xg8t01JcMnU6WxoRvgX8P9OuKEiyjlxdc3anfLN/7+A4WX
         PqKYeCFeKzsmse4FknWqb2xpZcFVsOUrw4Tfyt57HleXO4ax9mpLy300S0f4njuIlZ
         l7Xl6jcpUE77w==
Received: by famine.localdomain (Postfix, from userid 1000)
        id 194D85FBC4; Tue, 27 Jul 2021 22:06:01 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 11E2BA040B;
        Tue, 27 Jul 2021 22:06:01 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     zhudi <zhudi21@huawei.com>
cc:     vfalico@gmail.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, rose.chen@huawei.com
Subject: Re: [PATCH] bonding: Avoid adding slave devices to inactive bonding
In-reply-to: <20210728033505.1627-1-zhudi21@huawei.com>
References: <20210728033505.1627-1-zhudi21@huawei.com>
Comments: In-reply-to zhudi <zhudi21@huawei.com>
   message dated "Wed, 28 Jul 2021 11:35:05 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <10155.1627448761.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 27 Jul 2021 22:06:01 -0700
Message-ID: <10156.1627448761@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zhudi <zhudi21@huawei.com> wrote:

>We need to refuse to add slave devices to the bonding which does
>not set IFF_UP flag, otherwise some problems will be caused(such as
>bond_set_carrier() will not sync carrier state to upper net device).
>The ifenslave command can prevent such use case, but through the sysfs
>interface, slave devices can still be added regardless of whether
>the bonding is set with IFF_UP flag or not.

	What specifically happens in the carrier state issue you
mention?  Are there other specific issues?

	As far as I can recall, adding interfaces to the bond while the
bond is down has worked for a very long time, so I'm concerned that
disabling that functionality will have impact on existing
configurations.

	Also, to the best of my knowledge, the currently packaged
ifenslave programs are scripts that utilize the sysfs interface.  I'm
unaware of current usage of the old C ifenslave program (removed from
the kernel source in 2013), although the kernel code should still
support it.

	-J

>So we introduce a new BOND_OPTFLAG_IFUP flag to avoid adding slave
>devices to inactive bonding.
>
>Signed-off-by: zhudi <zhudi21@huawei.com>
>---
> drivers/net/bonding/bond_options.c | 4 +++-
> include/net/bond_options.h         | 4 +++-
> 2 files changed, 6 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bon=
d_options.c
>index 0cf25de6f46d..6d2f44b3528d 100644
>--- a/drivers/net/bonding/bond_options.c
>+++ b/drivers/net/bonding/bond_options.c
>@@ -387,7 +387,7 @@ static const struct bond_option bond_opts[BOND_OPT_LA=
ST] =3D {
> 		.id =3D BOND_OPT_SLAVES,
> 		.name =3D "slaves",
> 		.desc =3D "Slave membership management",
>-		.flags =3D BOND_OPTFLAG_RAWVAL,
>+		.flags =3D BOND_OPTFLAG_RAWVAL | BOND_OPTFLAG_IFUP,
> 		.set =3D bond_option_slaves_set
> 	},
> 	[BOND_OPT_TLB_DYNAMIC_LB] =3D {
>@@ -583,6 +583,8 @@ static int bond_opt_check_deps(struct bonding *bond,
> 		return -ENOTEMPTY;
> 	if ((opt->flags & BOND_OPTFLAG_IFDOWN) && (bond->dev->flags & IFF_UP))
> 		return -EBUSY;
>+	if ((opt->flags & BOND_OPTFLAG_IFUP) && !(bond->dev->flags & IFF_UP))
>+		return -EPERM;
> =

> 	return 0;
> }
>diff --git a/include/net/bond_options.h b/include/net/bond_options.h
>index 9d382f2f0bc5..742f5cc81adf 100644
>--- a/include/net/bond_options.h
>+++ b/include/net/bond_options.h
>@@ -15,11 +15,13 @@
>  * BOND_OPTFLAG_NOSLAVES - check if the bond device is empty before sett=
ing
>  * BOND_OPTFLAG_IFDOWN - check if the bond device is down before setting
>  * BOND_OPTFLAG_RAWVAL - the option parses the value itself
>+ * BOND_OPTFLAG_IFUP - check if the bond device is up before setting
>  */
> enum {
> 	BOND_OPTFLAG_NOSLAVES	=3D BIT(0),
> 	BOND_OPTFLAG_IFDOWN	=3D BIT(1),
>-	BOND_OPTFLAG_RAWVAL	=3D BIT(2)
>+	BOND_OPTFLAG_RAWVAL	=3D BIT(2),
>+	BOND_OPTFLAG_IFUP	=3D BIT(3)
> };
> =

> /* Value type flags:
>-- =

>2.27.0
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
