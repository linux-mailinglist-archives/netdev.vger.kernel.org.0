Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950331C11B5
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 13:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728642AbgEAL4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 07:56:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42142 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728570AbgEAL4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 07:56:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588334175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=80rfEzLgNgzLSm4P8ePsBC7Rh1UCZZCx9F6alt2/1l4=;
        b=WpEPLx+eD1JQkeCH6QeTOUgqlZVTalbH5EtXP/KfwfLPN+MqEPGz9uy3IF+ODuEfVMU30W
        PGEsPziDTqmg1LMqeeQojxW1uqRd7la8Mw3W8m5budtfI8cCFlVaRTlsrLry5LKEh3jNkB
        SRqzgUYMNaCGeFPHtlxLcIAPP2T6ub8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-AMBL9R_kOre8Jv8g2UTgoQ-1; Fri, 01 May 2020 07:56:09 -0400
X-MC-Unique: AMBL9R_kOre8Jv8g2UTgoQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C707D8014C1;
        Fri,  1 May 2020 11:56:08 +0000 (UTC)
Received: from carbon (unknown [10.40.208.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 946EF5D9CA;
        Fri,  1 May 2020 11:56:04 +0000 (UTC)
Date:   Fri, 1 May 2020 13:56:02 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>, brouer@redhat.com
Subject: Re: [PATCH net-next V2] net: sched: fallback to qdisc noqueue if
 default qdisc setup fail
Message-ID: <20200501135602.0671c73d@carbon>
In-Reply-To: <20200430124549.3272afb1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <158824694174.2180470.8094886910962590764.stgit@firesoul>
        <20200430124549.3272afb1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Apr 2020 12:45:49 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Thu, 30 Apr 2020 13:42:22 +0200 Jesper Dangaard Brouer wrote:
> > Currently if the default qdisc setup/init fails, the device ends up with
> > qdisc "noop", which causes all TX packets to get dropped.
> > 
> > With the introduction of sysctl net/core/default_qdisc it is possible
> > to change the default qdisc to be more advanced, which opens for the
> > possibility that Qdisc_ops->init() can fail.
> > 
> > This patch detect these kind of failures, and choose to fallback to
> > qdisc "noqueue", which is so simple that its init call will not fail.
> > This allows the interface to continue functioning.
> > 
> > V2:
> > As this also captures memory failures, which are transient, the
> > device is not kept in IFF_NO_QUEUE state.  This allows the net_device
> > to retry to default qdisc assignment.
> > 
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>  
> 
> I have mixed feelings about this one, I wonder if I'm the only one.
> Seems like failure to allocate the default qdisc is pretty critical,
> the log message may be missed, especially in the boot time noise.
> 
> I think a WARN_ON() is in order here, I'd personally just replace the
> netdev_info with a WARN_ON, without the fallback.

It is good that we agree that failure to default qdisc is pretty
critical.  I guess we disagree on whether (1) we keep network
functioning in a degraded state, (2) drop all packets on net_device
such that people notice.

This change propose (1) keeping the box functioning.  For me it was a
pretty bad experience, that when I pushed a new kernel over the network
to my embedded box, then I lost all network connectivity.  I
fortunately had serial console access (as this was not an OpenWRT box
but a full devel board) so I could debug, but I could no-longer upgrade
the kernel.  I clearly noticed, as the box was not operational, but I
guess most people would just give up at this point. (Imagine a small
OpenWRT box config setting default_qdisc to fq_codel, which brick the
box as it cannot allocate memory).

I hope that people will notice this degrade state, when they start to
transfer data to the device.  Because running 'noqueue' on a physical
device will result in net_crit_ratelimited() messages below:

 [86971.609318] Virtual device eth0 asks to queue packet!
 [86971.622183] Virtual device eth0 asks to queue packet!
 [86971.627510] Virtual device eth0 asks to queue packet!

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

