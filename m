Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85FC9222CA7
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 22:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgGPUWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 16:22:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725844AbgGPUWD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 16:22:03 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88247207E8;
        Thu, 16 Jul 2020 20:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594930923;
        bh=lQnOz2T3QCHaK6UF7S1d7Qs0hGwqgBqz68lRqr564Q0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KLQQplKfA+NxUh+JpUeyJiJAnN52TP3b4UWJGR5wAgqeK58SdOgIK3lPFET+4pS0c
         ZkpllacXbfFMcTVMsGo1YejtdZEKpY/i+1zBDJfBSpldarLXselgIwp8T3mTkWIkij
         vJGykErjJBUv1/s4xfKaq6zWabUTAhvNle2M8UnU=
Date:   Thu, 16 Jul 2020 13:22:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal =?UTF-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>
Cc:     Thomas Falcon <tlfalcon@linux.ibm.com>,
        David Miller <davem@davemloft.net>, drt@linux.ibm.com,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH net-next] ibmvnic: Increase driver logging
Message-ID: <20200716132200.37934905@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200716160736.GI32107@kitsune.suse.cz>
References: <1594857115-22380-1-git-send-email-tlfalcon@linux.ibm.com>
        <20200715170632.11f0bf19@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200715.182956.490791427431304861.davem@davemloft.net>
        <9c9d6e46-240b-8513-08e4-e1c7556cb3c8@linux.ibm.com>
        <20200716160736.GI32107@kitsune.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jul 2020 18:07:37 +0200 Michal Such=C3=A1nek wrote:
> On Thu, Jul 16, 2020 at 10:59:58AM -0500, Thomas Falcon wrote:
> > On 7/15/20 8:29 PM, David Miller wrote: =20
> > > From: Jakub Kicinski <kuba@kernel.org>
> > > Date: Wed, 15 Jul 2020 17:06:32 -0700
> > >  =20
> > > > On Wed, 15 Jul 2020 18:51:55 -0500 Thomas Falcon wrote: =20
> > > > >   	free_netdev(netdev);
> > > > >   	dev_set_drvdata(&dev->dev, NULL);
> > > > > +	netdev_info(netdev, "VNIC client device has been successfully r=
emoved.\n"); =20
> > > > A step too far, perhaps.
> > > >=20
> > > > In general this patch looks a little questionable IMHO, this amount=
 of
> > > > logging output is not commonly seen in drivers. All the the info
> > > > messages are just static text, not even carrying any extra informat=
ion.
> > > > In an era of ftrace, and bpftrace, do we really need this? =20
> > > Agreed, this is too much.  This is debugging, and thus suitable for t=
racing
> > > facilities, at best. =20
> >=20
> > Thanks for your feedback. I see now that I was overly aggressive with t=
his
> > patch to be sure, but it would help with narrowing down problems at a f=
irst
> > glance, should they arise. The driver in its current state logs very li=
ttle
> > of what is it doing without the use of additional debugging or tracing
> > facilities. Would it be worth it to pursue a less aggressive version or
> > would that be dead on arrival? What are acceptable driver operations to=
 log
> > at this level? =20

Sadly it's much more of an art than hard science. Most networking
drivers will print identifying information when they probe the device
and then only about major config changes or when link comes up or goes
down. And obviously when anything unexpected, like an error happens,
that's key.

You seem to be adding start / end information for each driver init /
deinit stage. I'd say try to focus on the actual errors you're trying
to catch.

> Also would it be advisable to add the messages as pr_dbg to be enabled on=
 demand?

I personally have had a pretty poor experience with pr_debug() because
CONFIG_DYNAMIC_DEBUG is not always enabled. Since you're just printing
static text there shouldn't be much difference between pr_debug and
ftrace and/or bpftrace, honestly.

Again, slightly hard to advise not knowing what you're trying to catch.
