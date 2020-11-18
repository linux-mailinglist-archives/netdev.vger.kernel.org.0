Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE1462B79E9
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 10:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgKRJDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 04:03:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40011 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725772AbgKRJDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 04:03:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605690212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TX2J0ifsZPmx8I8UtITBRgivjbAtjJZ06Fr9MXuTZbk=;
        b=VMF766E3/BDMp5UZ9PPQLpVPs6j9HWg13UloUBLEz88dON2kHNwYwhG4wPQPURFcAqQ710
        qOYmGQ1jk/fnB2PXQ2plnDYG5OAffZNUh0AEimMqeTQhevyFKUfVQLWY2kKJXfLPTHrYnJ
        3RfHKD5aLXPBlRqYHogNmoNtmATGeRo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-KoGZ1HYYPUONl7j5bTNrJA-1; Wed, 18 Nov 2020 04:03:25 -0500
X-MC-Unique: KoGZ1HYYPUONl7j5bTNrJA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 59A671087D6B;
        Wed, 18 Nov 2020 09:03:24 +0000 (UTC)
Received: from yoda.fritz.box (unknown [10.40.195.78])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B56F5D9CA;
        Wed, 18 Nov 2020 09:03:22 +0000 (UTC)
Date:   Wed, 18 Nov 2020 10:03:20 +0100
From:   Antonio Cardace <acardace@redhat.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v4 5/6] selftests: refactor get_netdev_name
 function
Message-ID: <20201118090320.wdth32bkz3ro6mbc@yoda.fritz.box>
References: <20201117152015.142089-1-acardace@redhat.com>
 <20201117152015.142089-6-acardace@redhat.com>
 <20201117173520.bix4wdfy6u3mapjl@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117173520.bix4wdfy6u3mapjl@lion.mk-sys.cz>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 06:35:20PM +0100, Michal Kubecek wrote:
> On Tue, Nov 17, 2020 at 04:20:14PM +0100, Antonio Cardace wrote:
> > As pointed out by Michal Kubecek, getting the name
> > with the previous approach was racy, it's better
> > and easier to get the name of the device with this
> > patch's approach.
> > 
> > Essentialy the function doesn't need to exist
> > anymore as it's a simple 'ls' command.
> > 
> > Signed-off-by: Antonio Cardace <acardace@redhat.com>
> > ---
> >  .../drivers/net/netdevsim/ethtool-common.sh   | 20 ++-----------------
> >  1 file changed, 2 insertions(+), 18 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/drivers/net/netdevsim/ethtool-common.sh b/tools/testing/selftests/drivers/net/netdevsim/ethtool-common.sh
> > index fa44cf6e732c..3c287ac78117 100644
> > --- a/tools/testing/selftests/drivers/net/netdevsim/ethtool-common.sh
> > +++ b/tools/testing/selftests/drivers/net/netdevsim/ethtool-common.sh
> > @@ -20,23 +20,6 @@ function cleanup {
> > 
> >  trap cleanup EXIT
> > 
> > -function get_netdev_name {
> > -    local -n old=$1
> > -
> > -    new=$(ls /sys/class/net)
> > -
> > -    for netdev in $new; do
> > -	for check in $old; do
> > -            [ $netdev == $check ] && break
> > -	done
> > -
> > -	if [ $netdev != $check ]; then
> > -	    echo $netdev
> > -	    break
> > -	fi
> > -    done
> > -}
> > -
> >  function check {
> >      local code=$1
> >      local str=$2
> > @@ -65,5 +48,6 @@ function make_netdev {
> >      fi
> > 
> >      echo $NSIM_ID > /sys/bus/netdevsim/new_device
> > -    echo `get_netdev_name old_netdevs`
> > +    # get new device name
> > +    echo $(ls /sys/bus/netdevsim/devices/netdevsim${NSIM_ID}/net/)
> 
> Is there a reason for combining command substitution with echo? Couldn't
> we use one of
> 
>   ls /sys/bus/netdevsim/devices/netdevsim${NSIM_ID}/net/
>   echo /sys/bus/netdevsim/devices/netdevsim${NSIM_ID}/net/*
> 
> instead?
> 
> Michal
> 
Ouch, no that's just a mistake. I'll fix it.

Do I have to resend the whole serie as a new version or is there a
quicker way to just resend a single patch?

Thanks,
Antonio

