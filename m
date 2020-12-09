Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 180112D4562
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 16:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730128AbgLIP2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 10:28:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42666 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729904AbgLIP2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 10:28:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607527609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TwZsNeR+aocPo/aT6u4plPoYBOWpeq4qK4h3Enahzxk=;
        b=NsFG7GUmiCDwYwvqbkF4oonReHajye45BtJtUgYRfJI9SS273e0B60BOn21GCCie6sexOM
        bONK8R3WeuZDF/aQBbmPoGAUxT5SLiALsy0FpATEES+pMuBvE+fv8uKacewuDvuzXa3eG0
        wUjMQIdYeaj0skN4y5Nhh8RaE72K0Uk=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-YG2P8su3OVSSFKM9-Hvd4Q-1; Wed, 09 Dec 2020 10:26:47 -0500
X-MC-Unique: YG2P8su3OVSSFKM9-Hvd4Q-1
Received: by mail-oi1-f199.google.com with SMTP id z63so945140oiz.1
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 07:26:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TwZsNeR+aocPo/aT6u4plPoYBOWpeq4qK4h3Enahzxk=;
        b=XWRbWlNwW52rTgSppjxJSkUIV5VmWSRUBqvPjcIuZ1JV8aAKgWV4H9zQFZRHEgYRwr
         OEUI1Y0b8weve84BcKrJFTx9Ob45afoEo/34NVTGwcrrOuhjgyLh29TwgIqxn8UpY6JI
         ilIbhTXogh96ZD6tIa3LDhA+TzO2XBxHkXby5lQNO9mvRsL23dxhPM7HFwpaWCJhmndZ
         XZdYPx5bVlKBYK2BWYKusvwzMhH8tmZW1M0R4aU79k0vB66fCr+UJJS12RhEz0HgyqL9
         DlA3+2qy1QRE1leP+smqlYDsR1Y5i+oPxa83WGHX+u+rOhzFfYpdj+Qi1PIBKOyJGHdH
         OtYw==
X-Gm-Message-State: AOAM533SJOmL/0Dqoh3d+Dxq6McOhCiSrCqRP2k+qBaJjpPTWpNJiFqW
        EsCrhXqwd1/Cu+KtxnDyT3+OA5c9faPfAS57fc1IfmKwVI121Fiv2MMXaz1r7aqtQd81QWtsWDQ
        v9KIQ9Hm+CDTcD+bnRHw7b61XWEW5fvwo
X-Received: by 2002:a05:6830:1308:: with SMTP id p8mr2146326otq.330.1607527607023;
        Wed, 09 Dec 2020 07:26:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzE3U5baieMoXkcPN/6zBCkZPElzYyaFBYTC67eE2xamfmG1c+GAtCCyYVpdv+F5RvzO3BcSSwNhi+XNCwD6xA=
X-Received: by 2002:a05:6830:1308:: with SMTP id p8mr2146312otq.330.1607527606795;
 Wed, 09 Dec 2020 07:26:46 -0800 (PST)
MIME-Version: 1.0
References: <20201205234354.1710-1-jarod@redhat.com> <11900.1607459690@famine>
In-Reply-To: <11900.1607459690@famine>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Wed, 9 Dec 2020 10:26:38 -0500
Message-ID: <CAKfmpSfbvi4hVCCotFLQB3MzvCx9ZRX7ttVww136pPkm1bN6PQ@mail.gmail.com>
Subject: Re: [PATCH net] bonding: reduce rtnl lock contention in mii monitor thread
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 8, 2020 at 3:35 PM Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
>
> Jarod Wilson <jarod@redhat.com> wrote:
>
> >I'm seeing a system get stuck unable to bring a downed interface back up
> >when it's got an updelay value set, behavior which ceased when logging
> >spew was removed from bond_miimon_inspect(). I'm monitoring logs on this
> >system over another network connection, and it seems that the act of
> >spewing logs at all there increases rtnl lock contention, because
> >instrumented code showed bond_mii_monitor() never able to succeed in it's
> >attempts to call rtnl_trylock() to actually commit link state changes,
> >leaving the downed link stuck in BOND_LINK_DOWN. The system in question
> >appears to be fine with the log spew being moved to
> >bond_commit_link_state(), which is called after the successful
> >rtnl_trylock(). I'm actually wondering if perhaps we ultimately need/want
> >some bond-specific lock here to prevent racing with bond_close() instead
> >of using rtnl, but this shift of the output appears to work. I believe
> >this started happening when de77ecd4ef02 ("bonding: improve link-status
> >update in mii-monitoring") went in, but I'm not 100% on that.
>
>         We use RTNL not to avoid deadlock with bonding itself, but
> because the "commit" side undertakes actions which require RTNL, e.g.,
> various events will eventually call netdev_lower_state_changed.
>
>         However, the RTNL acquisition is a trylock to avoid the deadlock
> with bond_close.  Moving that out of line here (e.g., putting the commit
> into another work queue event or the like) has the same problem, in that
> bond_close needs to wait for all of the work queue events to finish, and
> it holds RTNL.

Ah, okay, it wasn't clear to me that we actually do need RTNL here,
I'd thought it was just for the deadlock avoidance with bond_close,
based on the comments in the source.

>         Also, a dim memory says that the various notification messages
> were mostly placed in the "inspect" phase and not the "commit" phase to
> avoid doing printk-like activities with RTNL held.  As a general
> principle, I don't think we want to add more verbiage under RTNL.

Yeah, that's fair.

> >The addition of a case BOND_LINK_BACK in bond_miimon_inspect() is somewhat
> >separate from the fix for the actual hang, but it eliminates a constant
> >"invalid new link 3 on slave" message seen related to this issue, and it's
> >not actually an invalid state here, so we shouldn't be reporting it as an
> >error.
>
>         Do you mean bond_miimon_commit here and not bond_miimon_inspect
> (which already has a case for BOND_LINK_BACK)?

Whoops, yes.

>         In principle, bond_miimon_commit should not see _BACK or _FAIL
> state as a new link state, because those states should be managed at the
> bond_miimon_inspect level (as they are the result of updelay and
> downdelay).  These states should not be "committed" in the sense of
> causing notifications or doing actions that require RTNL.
>
>         My recollection is that the "invalid new link" messages were the
> result of a bug in de77ecd4ef02, which was fixed in 1899bb325149
> ("bonding: fix state transition issue in link monitoring"), but maybe
> the RTNL problem here induces that in some other fashion.
>
>         Either way, I believe this message is correct as-is.

Hm, okay, definitely seeing this message pop up regularly when a link
recovers, using a fairly simple reproducer:

slave1=p6p1
slave2=p6p2

modprobe -rv bonding
modprobe -v bonding mode=2 miimon=100 updelay=200
ip link set bond0 up
ifenslave bond0 $slave1 $slave2
sleep 10

while :
do
  ip link set $slave1 down
   sleep 1
   ip link set $slave1 up
   sleep 1
done

I wasn't actually seeing the problem until I was running a 'watch -n 1
"dmesg | tail -n 50"' or similar in a remote ssh session on the host.

I should add the caveat that this was also initially seen on an older
kernel, but with a fairly up-to-date bonding driver, which does
include both de77ecd4ef02 and 1899bb325149. I'm going to keep prodding
w/a more recent upstreamier kernel, and see if I can get a better idea
of what's actually going on.

-- 
Jarod Wilson
jarod@redhat.com

