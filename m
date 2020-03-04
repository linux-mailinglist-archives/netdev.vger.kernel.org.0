Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5075E179999
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 21:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387996AbgCDULv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 15:11:51 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:38495 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728278AbgCDULu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 15:11:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583352709;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JkoOmo/uioqA9PwDxWS+txa/xYjNxgEGpUJZ05OzMY4=;
        b=K6KX5X+vYBhC14BIHKg7DroedXZhCjE7Xb9op0gyy09dwoAuXFhwdAQfHe+FGL9teXAfbt
        4Du5AKf9DBp8IYS4zrvroE/qSM8Y9P/S/BmYzSB1501M5s3j5ma5B+ibrYvAEdlusEV77P
        PaRlpvZ4y8MfiJhaIcOIg2eD4k5rON8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-wmTToPnyO0-fSYKc5-gz2w-1; Wed, 04 Mar 2020 15:11:46 -0500
X-MC-Unique: wmTToPnyO0-fSYKc5-gz2w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EFB2C8017DF;
        Wed,  4 Mar 2020 20:11:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BD00F27061;
        Wed,  4 Mar 2020 20:11:44 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7AA728446C;
        Wed,  4 Mar 2020 20:11:44 +0000 (UTC)
Date:   Wed, 4 Mar 2020 15:11:44 -0500 (EST)
From:   Vladis Dronov <vdronov@redhat.com>
To:     Andrea Righi <andrea.righi@canonical.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <1830360600.13123996.1583352704368.JavaMail.zimbra@redhat.com>
In-Reply-To: <20200304175350.GB267906@xps-13>
References: <20200304175350.GB267906@xps-13>
Subject: Re: [PATCH] ptp: free ptp clock properly
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.40.204.205, 10.4.195.7]
Thread-Topic: free ptp clock properly
Thread-Index: PDXsSbboxZFT/a99TucbY86w37w5+g==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, Andrea, all,

----- Original Message -----
> From: "Andrea Righi" <andrea.righi@canonical.com>
> Subject: [PATCH] ptp: free ptp clock properly
> 
> There is a bug in ptp_clock_unregister() where ptp_clock_release() can
> free up resources needed by posix_clock_unregister() to properly destroy
> a related sysfs device.
> 
> Fix this by calling posix_clock_unregister() in ptp_clock_release().

Honestly, this does not seem right. The calls at PTP clock release are:

ptp_clock_unregister() -> posix_clock_unregister() -> cdev_device_del() ->
-> ... bla ... -> ptp_clock_release()

So, it looks like with this patch both posix_clock_unregister() and
ptp_clock_release() are not called at all. And it looks like the "fix" is
not removing PTP clock's cdev, i.e. leaking it and related sysfs resources.

I would guess that a kernel in question (5.3.0-40-generic) has the commit
a33121e5487b but does not have the commit 75718584cb3c, which should be
exactly fixing a docking station disconnect crash. Could you please,
check this?

Why? We have 2 crash call traces. 1) the launchpad bug 2) the email which
led to the commit 75718584cb3c creation (see Link:).

Aaaaand they are identical starting from device_release_driver_internal()
and almost to the top.

> See also:
> commit 75718584cb3c ("ptp: free ptp device pin descriptors properly").
> 
> BugLink: https://bugs.launchpad.net/bugs/1864754
> Fixes: a33121e5487b ("ptp: fix the race between the release of ptp_clock and
> cdev")
> Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
> ---
>  drivers/ptp/ptp_clock.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
> index ac1f2bf9e888..12951023d0c6 100644
> --- a/drivers/ptp/ptp_clock.c
> +++ b/drivers/ptp/ptp_clock.c
> @@ -171,6 +171,7 @@ static void ptp_clock_release(struct device *dev)
>  	struct ptp_clock *ptp = container_of(dev, struct ptp_clock, dev);
>  
>  	ptp_cleanup_pin_groups(ptp);
> +	posix_clock_unregister(&ptp->clock);
>  	mutex_destroy(&ptp->tsevq_mux);
>  	mutex_destroy(&ptp->pincfg_mux);
>  	ida_simple_remove(&ptp_clocks_map, ptp->index);
> @@ -303,8 +304,6 @@ int ptp_clock_unregister(struct ptp_clock *ptp)
>  	if (ptp->pps_source)
>  		pps_unregister_source(ptp->pps_source);
>  
> -	posix_clock_unregister(&ptp->clock);
> -
>  	return 0;
>  }
>  EXPORT_SYMBOL(ptp_clock_unregister);
> --
> 2.25.0

Best regards,
Vladis Dronov | Red Hat, Inc. | The Core Kernel | Senior Software Engineer

