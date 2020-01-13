Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBB513918E
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 14:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728778AbgAMNA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 08:00:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57786 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727494AbgAMNA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 08:00:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578920455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ev18epwrOyGsovY9mZaXn1IwdIuRdMV0wrxhb9Bjf6Q=;
        b=CiW/poOcvoqjH1a31R6IZtQebmETpP8nV3P8aVzJv3OcPkuVYJw2qXRDDn6w5WHSRpsVkV
        7+AM06HYluAhnEITo2OmFYMMZ0GTLAFpYImx4/19JAUtbAdKJrfFFDN7WxHEQ9UbAFMgeZ
        uImuYPShS3eecEOPus644jPL41EWhB0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-plZront1Oxu0z16vwwqTZw-1; Mon, 13 Jan 2020 08:00:52 -0500
X-MC-Unique: plZront1Oxu0z16vwwqTZw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D573485EE6D;
        Mon, 13 Jan 2020 13:00:50 +0000 (UTC)
Received: from rules.brq.redhat.com (unknown [10.43.2.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E9A095DA70;
        Mon, 13 Jan 2020 13:00:12 +0000 (UTC)
From:   Vladis Dronov <vdronov@redhat.com>
To:     Antti Laakso <antti.laakso@intel.com>, netdev@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>, vdronov@redhat.com,
        sjohnsto@redhat.com, vlovejoy@redhat.com,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        artem.bityutskiy@intel.com
Subject: [PATCH] ptp: free ptp device pin descriptors properly
Date:   Mon, 13 Jan 2020 14:00:09 +0100
Message-Id: <20200113130009.2938-1-vdronov@redhat.com>
In-Reply-To: <3d2bd09735dbdaf003585ca376b7c1e5b69a19bd.camel@intel.com>
References: <3d2bd09735dbdaf003585ca376b7c1e5b69a19bd.camel@intel.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a bug in ptp_clock_unregister(), where ptp_cleanup_pin_groups()
first frees ptp->pin_{,dev_}attr, but then posix_clock_unregister() needs
them to destroy a related sysfs device.

These functions can not be just swapped, as posix_clock_unregister() free=
s
ptp which is needed in the ptp_cleanup_pin_groups(). Fix this by calling
ptp_cleanup_pin_groups() in ptp_clock_release(), right before ptp is free=
d.

This makes this patch fix an UAF bug in a patch which fixes an UAF bug.

Reported-by: Antti Laakso <antti.laakso@intel.com>
Fixes: a33121e5487b ("ptp: fix the race between the release of ptp_clock =
and cdev")
Link: https://lore.kernel.org/netdev/3d2bd09735dbdaf003585ca376b7c1e5b69a=
19bd.camel@intel.com/
Signed-off-by: Vladis Dronov <vdronov@redhat.com>
---
 drivers/ptp/ptp_clock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index 61fafe0374ce..b84f16bbd6f2 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -170,6 +170,7 @@ static void ptp_clock_release(struct device *dev)
 {
 	struct ptp_clock *ptp =3D container_of(dev, struct ptp_clock, dev);
=20
+	ptp_cleanup_pin_groups(ptp);
 	mutex_destroy(&ptp->tsevq_mux);
 	mutex_destroy(&ptp->pincfg_mux);
 	ida_simple_remove(&ptp_clocks_map, ptp->index);
@@ -302,9 +303,8 @@ int ptp_clock_unregister(struct ptp_clock *ptp)
 	if (ptp->pps_source)
 		pps_unregister_source(ptp->pps_source);
=20
-	ptp_cleanup_pin_groups(ptp);
-
 	posix_clock_unregister(&ptp->clock);
+
 	return 0;
 }
 EXPORT_SYMBOL(ptp_clock_unregister);
--=20
2.20.1

