Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6D0012B61B
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfL0RYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:24:20 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59847 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726379AbfL0RYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 12:24:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577467458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6BagKGK8+pZSqwaMw/HELL5MlEA5rUbPb85VxpNXUsU=;
        b=DcFOCXg7tvjzKXO/4xT6mJhMyKoVI+MphdTK4X0+Ffe7AAJJD44bK8KpByEhJnKzScEJBN
        3f/5S+48ez2V410e1M8RUuwx0EDO0wHT2DzhfnkAv/oExGl4zZiW4Ge5uBFW4XGhCVk6jf
        z+U8CZnKIRNbdMX87vBkA9b3O/lpDWA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-1y8vaMnpOPeT0R7BGJ8Y8A-1; Fri, 27 Dec 2019 12:24:14 -0500
X-MC-Unique: 1y8vaMnpOPeT0R7BGJ8Y8A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81F8A107ACC5;
        Fri, 27 Dec 2019 17:24:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7712360BFB;
        Fri, 27 Dec 2019 17:24:13 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6A6B318089C8;
        Fri, 27 Dec 2019 17:24:13 +0000 (UTC)
Date:   Fri, 27 Dec 2019 12:24:13 -0500 (EST)
From:   Vladis Dronov <vdronov@redhat.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Al Viro <aviro@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <1031316500.2657655.1577467453350.JavaMail.zimbra@redhat.com>
In-Reply-To: <20191227150218.GA1435@localhost>
References: <20191208195340.GX4203@ZenIV.linux.org.uk> <20191227022627.24476-1-vdronov@redhat.com> <20191227150218.GA1435@localhost>
Subject: Re: [PATCH v2] ptp: fix the race between the release of ptp_clock
 and cdev
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [194.228.13.70, 10.4.196.16, 10.5.100.50, 10.4.195.23]
Thread-Topic: fix the race between the release of ptp_clock and cdev
Thread-Index: irWUFwtSG/M8AhEHYaeQCeWyBgqSgA==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, Richard,

Thank you for the review!

> > + * @dev:   Pointer to the initialized device. Caller must provide
> > + *         'release' filed
> 
> field

Indeed. *sigh* Nothing is ideal. Let's hope a maintainer could fix it if
this is approved.

Best regards,
Vladis Dronov | Red Hat, Inc. | The Core Kernel | Senior Software Engineer

----- Original Message -----
> From: "Richard Cochran" <richardcochran@gmail.com>
> To: "Vladis Dronov" <vdronov@redhat.com>
> Cc: linux-fsdevel@vger.kernel.org, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Al Viro" <aviro@redhat.com>,
> netdev@vger.kernel.org, linux-kernel@vger.kernel.org
> Sent: Friday, December 27, 2019 4:02:19 PM
> Subject: Re: [PATCH v2] ptp: fix the race between the release of ptp_clock and cdev
> 
> On Fri, Dec 27, 2019 at 03:26:27AM +0100, Vladis Dronov wrote:
> > Here cdev is embedded in posix_clock which is embedded in ptp_clock.
> > The race happens because ptp_clock's lifetime is controlled by two
> > refcounts: kref and cdev.kobj in posix_clock. This is wrong.
> > 
> > Make ptp_clock's sysfs device a parent of cdev with cdev_device_add()
> > created especially for such cases. This way the parent device with its
> > ptp_clock is not released until all references to the cdev are released.
> > This adds a requirement that an initialized but not exposed struct
> > device should be provided to posix_clock_register() by a caller instead
> > of a simple dev_t.
> > 
> > This approach was adopted from the commit 72139dfa2464 ("watchdog: Fix
> > the race between the release of watchdog_core_data and cdev"). See
> > details of the implementation in the commit 233ed09d7fda ("chardev: add
> > helper function to register char devs with a struct device").
> 
> Thanks for digging into this!
> 
> Acked-by: Richard Cochran <richardcochran@gmail.com>
> 
> >  /**
> >   * posix_clock_register() - register a new clock
> > - * @clk:   Pointer to the clock. Caller must provide 'ops' and 'release'
> > - * @devid: Allocated device id
> > + * @clk:   Pointer to the clock. Caller must provide 'ops' field
> > + * @dev:   Pointer to the initialized device. Caller must provide
> > + *         'release' filed
> 
> field
> 
> Thanks,
> Richard

