Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEAF12EF4BD
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 16:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727713AbhAHPWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 10:22:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57193 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726977AbhAHPWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 10:22:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610119285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/aeFvJpJFMTwfZ7/vJ01xGc8codi2ZIp83v/Ajx1hj0=;
        b=au08Q3Ly5Vvps2VYQ51jWSLjoNN3ZZJvz/jrg/7Xog9A4l0TyxcmrSCY/PamKlB4vHnOob
        bqWcUVgSxbhmKPdJPjjYvT2dHB2YlBn8EVj7ai/e16Q8bBjv/0LdwdCtHcuKtRCNUeywko
        fl7vZji9/8LYgfDf+xg7NyFe3mCdzSA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116-4dDv4JWPP7aKlhsYflMGiA-1; Fri, 08 Jan 2021 10:21:23 -0500
X-MC-Unique: 4dDv4JWPP7aKlhsYflMGiA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9252C803621;
        Fri,  8 Jan 2021 15:21:21 +0000 (UTC)
Received: from redhat.com (dhcp-17-185.bos.redhat.com [10.18.17.185])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A1205D9C0;
        Fri,  8 Jan 2021 15:21:19 +0000 (UTC)
Date:   Fri, 8 Jan 2021 10:21:17 -0500
From:   Jarod Wilson <jarod@redhat.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     linux-kernel@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next] bonding: add a vlan+srcmac tx hashing option
Message-ID: <20210108152117.GC63172@redhat.com>
References: <20201218193033.6138-1-jarod@redhat.com>
 <20201228101145.GC3565223@nanopsycho.orion>
 <20210107235813.GB29828@redhat.com>
 <20210108131256.GG3565223@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210108131256.GG3565223@nanopsycho.orion>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 08, 2021 at 02:12:56PM +0100, Jiri Pirko wrote:
> Fri, Jan 08, 2021 at 12:58:13AM CET, jarod@redhat.com wrote:
> >On Mon, Dec 28, 2020 at 11:11:45AM +0100, Jiri Pirko wrote:
> >> Fri, Dec 18, 2020 at 08:30:33PM CET, jarod@redhat.com wrote:
> >> >This comes from an end-user request, where they're running multiple VMs on
> >> >hosts with bonded interfaces connected to some interest switch topologies,
> >> >where 802.3ad isn't an option. They're currently running a proprietary
> >> >solution that effectively achieves load-balancing of VMs and bandwidth
> >> >utilization improvements with a similar form of transmission algorithm.
> >> >
> >> >Basically, each VM has it's own vlan, so it always sends its traffic out
> >> >the same interface, unless that interface fails. Traffic gets split
> >> >between the interfaces, maintaining a consistent path, with failover still
> >> >available if an interface goes down.
> >> >
> >> >This has been rudimetarily tested to provide similar results, suitable for
> >> >them to use to move off their current proprietary solution.
> >> >
> >> >Still on the TODO list, if these even looks sane to begin with, is
> >> >fleshing out Documentation/networking/bonding.rst.
> >> 
> >> Jarod, did you consider using team driver instead ? :)
> >
> >That's actually one of the things that was suggested, since team I believe
> >already has support for this, but the user really wants to use bonding.
> >We're finding that a lot of users really still prefer bonding over team.
> 
> Do you know the reason, other than "nostalgia"?

I've heard a few different reasons that come to mind:

1) nostalgia is definitely one -- "we know bonding here"
2) support -- "the things I'm running say I need bonding to properly
support failover in their environment". How accurate this is, I don't
actually know.
3) monitoring -- "my monitoring solution knows about bonding, but not
about team". This is probably easily fixed, but may or may not be in the
user's direct control.
4) footprint -- "bonding does the job w/o team's userspace footprint".
I think this one is kind of hard for team to do anything about, bonding
really does have a smaller userspace footprint, which is a plus for
embedded type applications and high-security environments looking to keep
things as minimal as possible.

I think I've heard a few "we tried team years ago and it didn't work" as
well, which of course is ridiculous as a reason not to try something again,
since a lot can change in a few years in this world.

-- 
Jarod Wilson
jarod@redhat.com

