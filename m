Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08CC2AEDDB
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 10:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgKKJd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 04:33:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45834 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726621AbgKKJd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 04:33:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605087235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ry6c6il1QUa78SSYS15ImkmJaL0iw4a/bsKiGOYdFwo=;
        b=W9DONUuSgeR3pwOIV0d7+jbmHUM80yDGS9Khivre9+l/kS8uEZtESlwa7/RnemQtrocNQs
        LFc2hVDZsr5iEyYj4vB2wZEihsy2b3rP+UN6DvS0xTXrdOihIyJ3UQCVUgWpvD4S+Xbi9c
        X/CtJgH6Y2iGWMJItKekaps8niroH6w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-UisX5i0ZOkuuyh0C3VMiUQ-1; Wed, 11 Nov 2020 04:33:51 -0500
X-MC-Unique: UisX5i0ZOkuuyh0C3VMiUQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 20C3E6D253;
        Wed, 11 Nov 2020 09:33:50 +0000 (UTC)
Received: from localhost (holly.tpb.lab.eng.brq.redhat.com [10.43.134.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E4066115F;
        Wed, 11 Nov 2020 09:33:48 +0000 (UTC)
Date:   Wed, 11 Nov 2020 10:33:46 +0100
From:   Miroslav Lichvar <mlichvar@redhat.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, andre.guedes@intel.com,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        bhelgaas@google.com
Subject: Re: [Intel-wired-lan] [PATCH next-queue v2 3/3] igc: Add support for
 PTP getcrosststamp()
Message-ID: <20201111093346.GE1559650@localhost>
References: <20201110061019.519589-1-vinicius.gomes@intel.com>
 <20201110061019.519589-4-vinicius.gomes@intel.com>
 <20201110180719.GA1559650@localhost>
 <871rh19gm8.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871rh19gm8.fsf@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 11:06:07AM -0800, Vinicius Costa Gomes wrote:
> Miroslav Lichvar <mlichvar@redhat.com> writes:
> > I suspect the estimate would be valid only when the NIC is connected
> > directly to the PTM root (PCI root complex). Is it possible to get the
> > timestamps or delay from PTM-capable switches on the path between CPU
> > and NIC? Also, how frequent can be the PTM dialogs? Could they be
> > performed synchronously in the ioctl?
> 
> Reading the PTM specs, it could work over PCIe switches (if they also
> support PTM).

I saw some "implementation specific means" mentioned in the spec, so
I'm not sure what and how exactly it works with the existing CPUs,
NICs and PCIe switches. But even if the reported delay was valid only
for directly connected NICs, I think that could still be useful as
long as the user/application can figure out whether that is the case.

> The NIC I have supports PTM cycles from every ~1ms to ~512ms, and from
> my tests it wants to be kept running "in background" always, i.e. set
> the cycles to run, and only report the data when necessary. Trying to
> only enable the cycles "on demand" was unreliable.

I see. It does makes sense if the clocks need to be are synchronized.
For the case of this ioctl, I think it would be better if it we could
just collect the measurements and leave the clocks free running.

> (so for the _EXTENDED case, I would need to accumulate multiple values
> in the driver, and report them later, a bit annoying, but not
> impossible)

I think you could simply repeat the sample in the output up to the
requested number.

I suspect a bigger issue, for both the PRECISE and EXTENDED variants,
is that it would return old data. I'm not sure if the existing
applications are ready to deal with that. With high clock update
rates, a delay of 50 milliseconds could cause an instability. You can
try phc2sys -R 50 and see if it stays stable.

The minimum 1ms cycle you mentioned would probably work better for the
applications.

-- 
Miroslav Lichvar

