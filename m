Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D7B2DEC1D
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 00:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgLRXuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 18:50:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35781 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725858AbgLRXuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 18:50:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608335325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+ltfjKp0a0CZjK5VqWOENgE7djMo2w8zSxVmcmLegAo=;
        b=cCI35rG0EgMsIpBcQyllz8zUMtI09O8trpCaun2Fh6dkKNuRjd6hS0Kg4qLAO2g28ITRkM
        B2xIG1AR9Ce7yotaUG0VMXpXPT0nG18geAfSXlIswyPhOgUPMqYsrR0ktFQb7+D9IzzBHp
        ibgAzh57Nw5MJ1q+d1TL5CnWQWj04iA=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-G3QGR46YNviPexUXrefJjA-1; Fri, 18 Dec 2020 18:48:43 -0500
X-MC-Unique: G3QGR46YNviPexUXrefJjA-1
Received: by mail-oo1-f70.google.com with SMTP id x191so1879465ooa.1
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 15:48:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+ltfjKp0a0CZjK5VqWOENgE7djMo2w8zSxVmcmLegAo=;
        b=n8l61Mjcmvfc5zY5OeVhX75vvrrbPsNneGNC4KRG/tNSG10+HTqNEx24BM/bsWV/HX
         QtSyMZsTJ2afjcoIs+IWrveuMpF+IdjVdOd6M6+xzpnjXAjJwks7cnY5r9FxbDgC83RW
         NrJg5W1cYUYwcOtB+qhYK289T6bKCtdldaE1PCn428ei5z6WpuS+6LeEwWh7QdWhQz7O
         fptpDd2Ex+ivQwTPCsdVZZTad3Yu7UHHlRuu3JpcV+bsqEkGH4tCkzeP5PWXNW8p1YW6
         FrZ4H4Fz5y4K66zs3A3Je1cfUeKesiyXYGPs+QWI+WZcstSXPc1Q26P8/KmPaYViAfCT
         +Mvg==
X-Gm-Message-State: AOAM530IEEcswc0h+9cMFdboI7oQUsMUbGCFms6P6kKT617BwMg8ByVt
        3U9goDBbBOAwlzLVvbSs7jAt8VDsGkJypnf82871pA6pUFq08wZwFiH/hGzaeYlYiYnmFhcSRmU
        QzEHeT4YDVlCG5+GkhWzdvZ/YojBOZ8fa
X-Received: by 2002:a9d:749a:: with SMTP id t26mr4581973otk.277.1608335323018;
        Fri, 18 Dec 2020 15:48:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyJ2nN1vXngcVUoOEAG74s5U3e8lcwmpg38reul9rkZLcrTb66nfk4bZlJ62m+lBkyygSFDFV1MAs6YD3J999k=
X-Received: by 2002:a9d:749a:: with SMTP id t26mr4581966otk.277.1608335322797;
 Fri, 18 Dec 2020 15:48:42 -0800 (PST)
MIME-Version: 1.0
References: <20201205234354.1710-1-jarod@redhat.com> <11900.1607459690@famine>
In-Reply-To: <11900.1607459690@famine>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Fri, 18 Dec 2020 18:48:32 -0500
Message-ID: <CAKfmpSfnD6-7UmaMCN10xvhZq1cbqosRQd9S6H_xjT=Oqi41JA@mail.gmail.com>
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
...
> >The addition of a case BOND_LINK_BACK in bond_miimon_commit() is somewhat
> >separate from the fix for the actual hang, but it eliminates a constant
> >"invalid new link 3 on slave" message seen related to this issue, and it's
> >not actually an invalid state here, so we shouldn't be reporting it as an
> >error.
...
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

For reference, with 5.10.1 and this script:

#!/bin/sh

slave1=ens4f0
slave2=ens4f1

modprobe -rv bonding
modprobe -v bonding mode=2 miimon=100 updelay=200
ip link set bond0 up
ifenslave bond0 $slave1 $slave2
sleep 5

while :
do
        ip link set $slave1 down
        sleep 1
        ip link set $slave1 up
        sleep 1
done

I get this repeating log output:

[ 9488.262291] sfc 0000:05:00.0 ens4f0: link up at 10000Mbps
full-duplex (MTU 1500)
[ 9488.339508] bond0: (slave ens4f0): link status up, enabling it in 200 ms
[ 9488.339511] bond0: (slave ens4f0): invalid new link 3 on slave
[ 9488.547643] bond0: (slave ens4f0): link status definitely up, 10000
Mbps full duplex
[ 9489.276614] bond0: (slave ens4f0): link status definitely down,
disabling slave
[ 9490.273830] sfc 0000:05:00.0 ens4f0: link up at 10000Mbps
full-duplex (MTU 1500)
[ 9490.315540] bond0: (slave ens4f0): link status up, enabling it in 200 ms
[ 9490.315543] bond0: (slave ens4f0): invalid new link 3 on slave
[ 9490.523641] bond0: (slave ens4f0): link status definitely up, 10000
Mbps full duplex
[ 9491.356526] bond0: (slave ens4f0): link status definitely down,
disabling slave
[ 9492.285249] sfc 0000:05:00.0 ens4f0: link up at 10000Mbps
full-duplex (MTU 1500)
[ 9492.291522] bond0: (slave ens4f0): link status up, enabling it in 200 ms
[ 9492.291523] bond0: (slave ens4f0): invalid new link 3 on slave
[ 9492.499604] bond0: (slave ens4f0): link status definitely up, 10000
Mbps full duplex
[ 9493.331594] bond0: (slave ens4f0): link status definitely down,
disabling slave

"invalid new link 3 on slave" is there every single time.

Side note: I'm not actually able to reproduce the repeating "link
status up, enabling it in 200 ms" and never recovering from a downed
link on this host, no clue why it's so reproducible w/another system.

-- 
Jarod Wilson
jarod@redhat.com

