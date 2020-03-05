Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1857817A097
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 08:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgCEHjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 02:39:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:32887 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbgCEHjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 02:39:18 -0500
Received: from mail-wr1-f69.google.com ([209.85.221.69])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <andrea.righi@canonical.com>)
        id 1j9l3w-0004nm-0e
        for netdev@vger.kernel.org; Thu, 05 Mar 2020 07:36:56 +0000
Received: by mail-wr1-f69.google.com with SMTP id z16so1947148wrm.15
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 23:36:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9CtJGdUYHnqq8YEJwS2KCkXmlOvHXAh2xw0RAmgI+qI=;
        b=jW1wtZYjRW25MJ4j7w4OV9Qix+gEKFke6cmdkvmsyhDQuz7rrFrY3ywKf0xdhnUqu6
         zaXnXFA76aurkD5VcivB8mz2n/3nRk/Z5/7l7EnpJLuWYxjsH6VYVxDjP0DCSQtWq9XI
         4bHu3f12WDjtJDMbU/Pb1+/epcL6ElMpfXvWnbkLavzmsk/nckLjI6kEU4p1PXSnrrtj
         T8rERglUU/HjHDU9+6QXB6TdfAx9+gqD5uckVV/HZtqbGgKtYEAKXlW2VyYMaURIvcaG
         2l0foD9C0xZ+yB3Y2RgbwRYD9p3KStwPBQjvqqD/4vljhIPMU+q+EMTOD+UcDDOpZoV5
         BtMw==
X-Gm-Message-State: ANhLgQ072NMSynJT/XlJURFOotC2hrDX6OAY0nr/YxKLOZdNhBE4X6Nz
        TkxL2s0Yq2T+8NRQiyEYQcmTyaO4m1DAgXD7L/l77l8plHIU0pUrDElo8snE+/RhgnS3oQg/9Fk
        ASITrbMAb21eGUvQ+3Uolcvq5gi6/qVxG7Q==
X-Received: by 2002:adf:f7c1:: with SMTP id a1mr8559538wrq.299.1583393815467;
        Wed, 04 Mar 2020 23:36:55 -0800 (PST)
X-Google-Smtp-Source: ADFU+vs+cCHLCvfbTBArpsEG//QQD/rfqrcaua3+QIrsXxad2+Z6Ca4YiR4vehAh1+uayLJcx2rLBg==
X-Received: by 2002:adf:f7c1:: with SMTP id a1mr8559502wrq.299.1583393815072;
        Wed, 04 Mar 2020 23:36:55 -0800 (PST)
Received: from localhost (host96-127-dynamic.32-79-r.retail.telecomitalia.it. [79.32.127.96])
        by smtp.gmail.com with ESMTPSA id q12sm45991919wrg.71.2020.03.04.23.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 23:36:54 -0800 (PST)
Date:   Thu, 5 Mar 2020 08:36:53 +0100
From:   Andrea Righi <andrea.righi@canonical.com>
To:     Vladis Dronov <vdronov@redhat.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptp: free ptp clock properly
Message-ID: <20200305073653.GC267906@xps-13>
References: <20200304175350.GB267906@xps-13>
 <1830360600.13123996.1583352704368.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1830360600.13123996.1583352704368.JavaMail.zimbra@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 03:11:44PM -0500, Vladis Dronov wrote:
> Hello, Andrea, all,
> 
> ----- Original Message -----
> > From: "Andrea Righi" <andrea.righi@canonical.com>
> > Subject: [PATCH] ptp: free ptp clock properly
> > 
> > There is a bug in ptp_clock_unregister() where ptp_clock_release() can
> > free up resources needed by posix_clock_unregister() to properly destroy
> > a related sysfs device.
> > 
> > Fix this by calling posix_clock_unregister() in ptp_clock_release().
> 
> Honestly, this does not seem right. The calls at PTP clock release are:
> 
> ptp_clock_unregister() -> posix_clock_unregister() -> cdev_device_del() ->
> -> ... bla ... -> ptp_clock_release()
> 
> So, it looks like with this patch both posix_clock_unregister() and
> ptp_clock_release() are not called at all. And it looks like the "fix" is
> not removing PTP clock's cdev, i.e. leaking it and related sysfs resources.

That's absolutely right, thanks for the clarification!

With my "fix" we don't see the the kernel oops anymore, but we're
leaking resources, so definitely not a valid fix.

> 
> I would guess that a kernel in question (5.3.0-40-generic) has the commit
> a33121e5487b but does not have the commit 75718584cb3c, which should be
> exactly fixing a docking station disconnect crash. Could you please,
> check this?

Unfortunately the kernel in question already has 75718584cb3c:
https://git.launchpad.net/~ubuntu-kernel/ubuntu/+source/linux/+git/bionic/commit/?h=hwe&id=c71b774732f997ef38ed7bd62e73891a01f2bbfe

It looks like there's something else that can free up too early the
resources required by posix_clock_unregister() to destroy the related
sysfs files.

Maybe what we really need to call from ptp_clock_release() is
pps_unregister_source()? Something like this:

From: Andrea Righi <andrea.righi@canonical.com>
Subject: [PATCH] ptp: free ptp clock properly

There is a bug in ptp_clock_unregister() where ptp_clock_release() can
free up resources needed by posix_clock_unregister() to properly destroy
a related sysfs device.

Fix this by calling pps_unregister_source() in ptp_clock_release().

See also:
commit 75718584cb3c ("ptp: free ptp device pin descriptors properly").

BugLink: https://bugs.launchpad.net/bugs/1864754
Fixes: a33121e5487b ("ptp: fix the race between the release of ptp_clock and cdev")
Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
---
 drivers/ptp/ptp_clock.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index ac1f2bf9e888..468286ef61ad 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -170,6 +170,9 @@ static void ptp_clock_release(struct device *dev)
 {
 	struct ptp_clock *ptp = container_of(dev, struct ptp_clock, dev);
 
+	/* Release the clock's resources. */
+	if (ptp->pps_source)
+		pps_unregister_source(ptp->pps_source);
 	ptp_cleanup_pin_groups(ptp);
 	mutex_destroy(&ptp->tsevq_mux);
 	mutex_destroy(&ptp->pincfg_mux);
@@ -298,11 +301,6 @@ int ptp_clock_unregister(struct ptp_clock *ptp)
 		kthread_cancel_delayed_work_sync(&ptp->aux_work);
 		kthread_destroy_worker(ptp->kworker);
 	}
-
-	/* Release the clock's resources. */
-	if (ptp->pps_source)
-		pps_unregister_source(ptp->pps_source);
-
 	posix_clock_unregister(&ptp->clock);
 
 	return 0;
-- 
2.25.0
