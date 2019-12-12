Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17DF411D586
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 19:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730357AbfLLS3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 13:29:14 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:42374 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730017AbfLLS3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 13:29:13 -0500
Received: by mail-yb1-f196.google.com with SMTP id p137so829599ybg.9
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 10:29:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=exBs6cbYBhiaiO85VuX1I/b0vyw8Vg3ZJUVGTes5fL4=;
        b=IV0M6yXBR/LWP427wPO0bQQoZ0TEv4OV1+JAaeAoeGL/I3oPnwnvWynLO82VHop2dB
         Fw1YqLVJF5/AZ2FLL8BsFzp1dmrxwGPOmCOYPKfWxmJpa4xPmHhgG5W+95FLM3b4edTE
         hYQfUDutLAxuSIISmcwCHaAp9bw5xd0Vx9HpjXhEM/GCeY48HmAUUkjaw+8GIdHevGIy
         qTyHZ6pAhDt1XEGpUOGOaF3ZxJPvPZ+Up6iIK9HKECtQkNyXe/NcTiGVWSX4D83m8UrA
         XafsCXPRN3tlTE96nkZLm17p/4gaLsjhBPibkw+IizeTSzhD+g1n6kE258Mo3x3C1obw
         10uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=exBs6cbYBhiaiO85VuX1I/b0vyw8Vg3ZJUVGTes5fL4=;
        b=mPBXLwdKiCu3sTd9dE3grWymdmZE2tVfadenZJ07imICc8ZXd3Nv09CLN1cGnn0OyA
         zHTA71lP6y3x4r6J57ZNtW04tf+t25W93PgQ4kJrnpDxyisD0lTEbqk96bKyz9qTaXHT
         RN519JFJjM4vRoylsRU4MTRlFnzjQQe5sDcu2Wscwgkau2og9KP4IKf83sF7y+0t/MHW
         SyHZL8MXepowmPjiu0z/1PgN8oyScy/Z3wIYyOz+//miljE0Jo1G7ldxKmsnw1YkP4LD
         f6lWECL4XEOeUoXJSv7lJVYjEW52YIlN4JjfrOtnyj8jrDS9UXPc2kE/OxPlHr1F0OZ0
         33mg==
X-Gm-Message-State: APjAAAXUmfDwTPknkHaBhTnEk1ujXUdbVL1wPVMfjEmLkEy6naQ4vxL1
        J6r5Bdb1WMhU+FYn+sYxwtchftLHuw3IaggUtNhmj6TP++o=
X-Google-Smtp-Source: APXvYqznO9y2VeSUIdrxIZXFU7Gwp9xcAtTaYEU56OgaWmbq4eOLu9EjV/rh57frBSO390VzFzGDMc1hX//VLi1khwU=
X-Received: by 2002:a25:6c86:: with SMTP id h128mr5556181ybc.305.1576175351865;
 Thu, 12 Dec 2019 10:29:11 -0800 (PST)
MIME-Version: 1.0
References: <20191206234455.213159-1-maheshb@google.com> <10902.1575756592@famine>
 <CAF2d9jgjeky0eMgwFZKHO_RLTBNstH1gCq4hn1FfO=TtrMP1ow@mail.gmail.com> <26918.1576132686@famine>
In-Reply-To: <26918.1576132686@famine>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Thu, 12 Dec 2019 10:28:55 -0800
Message-ID: <CAF2d9jh7WAydcm79VYZLb=A=fXo7B7RDiMquZRJdP2fnwnLabg@mail.gmail.com>
Subject: Re: [PATCH net] bonding: fix active-backup transition after link failure
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Andy Gospodarek <andy@greyhouse.net>,
        Veaceslav Falico <vfalico@gmail.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Mahesh Bandewar <mahesh@bandewar.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 10:39 PM Jay Vosburgh
<jay.vosburgh@canonical.com> wrote:
>
> Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=A5=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=
=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=B0) wrote:
>
> >On Sat, Dec 7, 2019 at 2:09 PM Jay Vosburgh <jay.vosburgh@canonical.com>=
 wrote:
> >>
> >> Mahesh Bandewar <maheshb@google.com> wrote:
> >>
> >> >After the recent fix 1899bb325149 ("bonding: fix state transition
> >> >issue in link monitoring"), the active-backup mode with miimon
> >> >initially come-up fine but after a link-failure, both members
> >> >transition into backup state.
> >> >
> >> >Following steps to reproduce the scenario (eth1 and eth2 are the
> >> >slaves of the bond):
> >> >
> >> >    ip link set eth1 up
> >> >    ip link set eth2 down
> >> >    sleep 1
> >> >    ip link set eth2 up
> >> >    ip link set eth1 down
> >> >    cat /sys/class/net/eth1/bonding_slave/state
> >> >    cat /sys/class/net/eth2/bonding_slave/state
> >> >
> >> >Fixes: 1899bb325149 ("bonding: fix state transition issue in link mon=
itoring")
> >> >CC: Jay Vosburgh <jay.vosburgh@canonical.com>
> >> >Signed-off-by: Mahesh Bandewar <maheshb@google.com>
> >> >---
> >> > drivers/net/bonding/bond_main.c | 3 ---
> >> > 1 file changed, 3 deletions(-)
> >> >
> >> >diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bo=
nd_main.c
> >> >index fcb7c2f7f001..ad9906c102b4 100644
> >> >--- a/drivers/net/bonding/bond_main.c
> >> >+++ b/drivers/net/bonding/bond_main.c
> >> >@@ -2272,9 +2272,6 @@ static void bond_miimon_commit(struct bonding *=
bond)
> >> >                       } else if (BOND_MODE(bond) !=3D BOND_MODE_ACTI=
VEBACKUP) {
> >> >                               /* make it immediately active */
> >> >                               bond_set_active_slave(slave);
> >> >-                      } else if (slave !=3D primary) {
> >> >-                              /* prevent it from being the active on=
e */
> >> >-                              bond_set_backup_slave(slave);
> >>
> >>         How does this fix things?  Doesn't bond_select_active_slave() =
->
> >> bond_change_active_slave() set the backup flag correctly via a call to
> >> bond_set_slave_active_flags() when it sets a slave to be the active
> >> slave?  If this change resolves the problem, I'm not sure how this eve=
r
> >> worked correctly, even prior to 1899bb325149.
> >>
> >Hi Jay, I used kprobes to figure out the brokenness this patch fixes.
> >Prior to your patch this call would not happen but with the patch,
> >this extra call will put the master into the backup mode erroneously
> >(in fact both members would be in backup state). The mechanics you
> >have mentioned works correctly except that in the prior case, the
> >switch statement was using new_link which was not same as
> >link_new_state. The miimon_inspect will update new_link which is what
> >was used in miimon_commit code. The link_new_state was used only to
> >mitigate the rtnl-lock issue which would update the "link". Hence in
> >the prior code, this path would never get executed.
>
>         I'm looking at the old code (prior to 1899bb325149), and I don't
> see a path to what you're describing for the down to up transition in
> active-backup mode.
>
I was referring to the code where bond_miimon_inspect() switches using
bond->link and bond_miimon_commit() (which happens after inspect)
switches using bond->new_link. inspect doesn't touch new_link unless
delay is set which is a corner case and probably ignore for this
purpose since it's just postponing the behavior.
bond->link_new_state was brought in to mitigate RTNL issue and affects
only bond->link, if it can acquire RTNL. So irrespective of what
bond_miimon_inspect() does for bond->link or bond->link_new_state the
bond->new_link was maintained and then used in the bond_miimon_commit.
Because of this the wrong transition wouldn't happen.

Once the new_link and link_new_state is merged, the state that
bond_miimon_inspect() sets for bond->link_new_state *is* used in
bond_miimon_commit() (which is after the fact) and hence (I believe)
the erroneous transition.

Having said that, the fix that you put in is necessary to close the
window between link_propose() and link_commit() but the side effect of
that was the situation that I explained
above which is what this patch fixes it.

> bond_miimon_inspect enters switch, slave->link =3D=3D BOND_LINK_DOWN.
>
> link_state is nonzero, call bond_propose_link_state(BOND_LINK_BACK),
> which sets slave->link_new_state to _BACK.
>
> Fall through to BOND_LINK_BACK case, set slave->new_link =3D BOND_LINK_UP
>
> bond_mii_monitor then calls bond_commit_link_state, which sets
> slave->link to BOND_LINK_BACK
>
> Enter bond_miimon_commit switch (new_link), which is BOND_LINK_UP
>
> In "case BOND_LINK_UP:" there is no way out of this block, and it should
> proceed to call bond_set_backup_slave for active-backup mode every time.
>
> >The steps to reproduce this issue is straightforward and happens 100%
> >of the time (I used two mlx interfaces but that shouldn't matter).
>
>         Yes, I've been able to reproduce it locally (with igb, FWIW).  I
> think the patch is likely ok, I'm just mystified as to how the backup
> setting could have worked prior to 1899bb325149, so perhaps the Fixes
> tag doesn't go back far enough.
>
Well, I added fixes-tag since the behavior started as soon as the
1899bb325149 was added. I don't see the issue if I revert
1899bb325149.


>         -J
>
> >thanks,
> >--mahesh..
> >>         -J
> >>
> >> >                       }
> >> >
> >> >                       slave_info(bond->dev, slave->dev, "link status=
 definitely up, %u Mbps %s duplex\n",
> >> >--
> >> >2.24.0.393.g34dc348eaf-goog
>
> ---
>         -Jay Vosburgh, jay.vosburgh@canonical.com
