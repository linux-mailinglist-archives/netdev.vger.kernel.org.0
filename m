Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 916BC170B50
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 23:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgBZWPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 17:15:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56054 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727715AbgBZWPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 17:15:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582755304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BpZS5KpF2EgyTb06d65Ogcl15EGk9qadh3W5g3HMimw=;
        b=COCz3GIIhK8fGkYIuVhaMhKkZ19Ec0LTBS6pQNVdYQTCclwT/1tliNIpqnlkuvbrFXqHjO
        Wz+yb0UxZ3WSWadSIgnvLYmHaU5and2dw7alVQEbV8bYpDT++6EYsY8CyWwexy78V9tfta
        5t+4rctAvnfEYGkXjQARHoiY4LfGGv0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-_xyZB9j8PcewRMhx476I6Q-1; Wed, 26 Feb 2020 17:15:00 -0500
X-MC-Unique: _xyZB9j8PcewRMhx476I6Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B193E800D5A;
        Wed, 26 Feb 2020 22:14:58 +0000 (UTC)
Received: from ovpn-112-57.rdu2.redhat.com (ovpn-112-57.rdu2.redhat.com [10.10.112.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3727E60BE2;
        Wed, 26 Feb 2020 22:14:56 +0000 (UTC)
Message-ID: <bd04741b8a8f07e1f1b622cf28ac1ed89d964509.camel@redhat.com>
Subject: Re: [RFC] wwan: add a new WWAN subsystem
From:   Dan Williams <dcbw@redhat.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Alex Elder <elder@linaro.org>, m.chetan.kumar@intel.com,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Date:   Wed, 26 Feb 2020 16:15:53 -0600
In-Reply-To: <983917b5637ce1d9948c94f638d857d37a2ab808.camel@sipsolutions.net>
References: <20200225100053.16385-1-johannes@sipsolutions.net>
         <20200225105149.59963c95aa29.Id0e40565452d0d5bb9ce5cc00b8755ec96db8559@changeid>
         <20200225151521.GA7663@lunn.ch>
         <983917b5637ce1d9948c94f638d857d37a2ab808.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-02-25 at 16:39 +0100, Johannes Berg wrote:
> On Tue, 2020-02-25 at 16:15 +0100, Andrew Lunn wrote:
> 
> > Looking at it bottom up, is the WWAN device itself made up of
> > multiple
> > devices? Are the TTYs separate drivers to the packet moving
> > engines?
> 
> Possibly, yes, it depends a bit.
> 
> > They have there own USB end points, and could just be standard CDC
> > ACM?
> 
> Yeah, for a lot of USB devices that's indeed the case.

For exmaple, the most common non-embedded case is USB WWAN cards
(whether sticks or M.2/PCIe minicard):

* one or more "control" ports, either CDC-ACM that speak AT commands or
CDC-WDM that speak QMI, AT, or MBIM. Exposed by drivers like cdc-acm,
cdc-wdm, option, qcserial, qcaux, hso, sierra, etc.

* one or more "data" ports that are exposed by USB network drivers.
Exposed by drivers like cdc-ether, cdc-ncm, qmi-wwan, sierra-net, hso,
etc.

In most cases the data port needs to be configured using specific
commands from the control ports to be useful and pass traffic. They are
logically the same device, but use totally separate kernel drivers and
sometimes buses.

But that's only for USB. Qualcomm embedded stuff will use a different
bus, other devices use PCI, some have both platform serial and USB
connections. But I don't think we need a perfect solution, just
something that handles a bunch of the cases that we can improve over
time.

Dan

> > driver/base/component.c could be useful for bringing together these
> > individual devices to form the whole WWAN device.
> 
> Huh, I was unaware of this, I'll take a look!
> 
> A very brief look suggests that it wants to have a driver for the
> whole
> thing in the end, which isn't really true here, but perhaps we could
> "make one up" and have that implement the userspace API. I need to
> take
> a closer look, thanks for the pointer.
> 
> > Plus you need to avoid confusion by not adding another "component
> > framework" which means something totally different to the existing
> > component framework.
> 
> :)
> 
> johannes
> 

