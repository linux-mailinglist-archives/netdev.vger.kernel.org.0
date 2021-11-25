Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58CB045DEC8
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 17:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356426AbhKYQwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 11:52:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41853 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1356564AbhKYQuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 11:50:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637858830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=v8IilDWrUg2aLvaIVHcQBIwCAbGoff91iXtMv+Z8IJE=;
        b=GdjLxwjNAh4vNDzV9D2CwF/RNCbRklpoXp5Zwz7gId/Wcthi9RD8bjjc0d2/kLYxT1ujZa
        HP/xfgF0tPaNDk2+wBG+ptWhv+iy8q9A8kK98GYtAAsmi/utNibntluf/8nQn6mpA18zqi
        2dMc6OhMCpZ8DoC2g+kE97REsL1i5tY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-288-w_O84QwdMKyuEGy9nCXTpA-1; Thu, 25 Nov 2021 11:47:06 -0500
X-MC-Unique: w_O84QwdMKyuEGy9nCXTpA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5830B10B7440;
        Thu, 25 Nov 2021 16:47:05 +0000 (UTC)
Received: from x230 (unknown [10.39.192.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 190945D9CA;
        Thu, 25 Nov 2021 16:46:55 +0000 (UTC)
Date:   Thu, 25 Nov 2021 17:46:31 +0100
From:   Stefan Assmann <sassmann@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        netdev@vger.kernel.org,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: Re: [PATCH net-next 06/12] iavf: Add trace while removing device
Message-ID: <20211125164631.4begykv47j3neej6@x230>
References: <20211124171652.831184-1-anthony.l.nguyen@intel.com>
 <20211124171652.831184-7-anthony.l.nguyen@intel.com>
 <20211124154811.6d9c48cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211125065049.hwubag5eherksrle@x230>
 <20211125071316.69c3319a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211125154349.ozf6jfq5kmzoou4j@x230>
 <20211125075701.7b67ae7f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125075701.7b67ae7f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-11-25 07:57, Jakub Kicinski wrote:
> On Thu, 25 Nov 2021 16:43:49 +0100 Stefan Assmann wrote:
> > On 2021-11-25 07:13, Jakub Kicinski wrote:
> > > On Thu, 25 Nov 2021 07:50:49 +0100 Stefan Assmann wrote:  
> > > > From personal experience I'd say this piece of information has value,
> > > > especially when debugging it can be interesting to know exactly when
> > > > the driver was removed.  
> > > 
> > > But there isn't anything specific to iavf here, right? If it really 
> > > is important then core should be doing the printing for all drivers.
> > > 
> > > Actually, I can't come up with any uses for this print on the spot.
> > > What debugging scenarios do you have in mind?  
> > 
> > There was a lot of trouble with iavf in terms of device reset, device
> > unbinding (DPDK), stress testing of driver load/unload issues. When
> > looking through the crash logs it was not always easy to determine if
> > the driver was still loaded.
> > Especially on problems that weren't easy to reproduce.
> 
> That's a slippery slope, historically we were always pushing for
> avoiding informational prints. Otherwise every driver reconfig would
> result in a line in the logs.
> 
> > So for iavf having that information would have been valuable. Not sure
> > if that justifies a PCI core message or if others might find that too
> > verbose.
> 
> So what you're saying is from your experience iavf is of significantly
> poorer quality than other vendors' drivers?

No, I can't really comment on how iavf compares to other vendor drivers
since I've mostly worked with Intel. There's a lot of async tasks and
communication going on between PF and VF and while that seems great it
has a lot of potential for things to go wrong as well. If you look at
the git history of iavf (previously i40evf) you'll see that the
especially the reset, shutdown, error handling code has seen a lot of
fixes and refactoring. Just recently in net-next
898ef1cb1cb2 iavf: Combine init and watchdog state machines
45eebd62999d iavf: Refactor iavf state machine tracking

Finding and fixing all those corner cases is hard, especially when we
have situation where we rely on firmware to perform a certain task in
defined time.
Example:
In iavf_reset_task() we poll a register for a certain amount of time as
the firmware is supposed to complete the reset in that amount of time.
Now that works well 99,999% of the time but sometime it doesn't so the
driver logs a message and continues operation.
That might work, it might not and things go wrong and we had to figure
out why.
Or some async message came in at a bad time, while the driver was
already being removed, and rescheduled the reset task which of course
caused a crash as the structures were being free'd underneath the reset
task.

So from the perspective of somebody working on the driver I'd like to
see it when the driver gets removed.

  Stefan

