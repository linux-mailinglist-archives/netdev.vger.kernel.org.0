Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D70D13AA5B
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 14:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbgANNKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 08:10:50 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59905 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725904AbgANNKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 08:10:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579007449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=QYRkIRZn0ZoxpR/xXmi8xhkYGv+QH1Q2b0cVKYeNAcg=;
        b=IFOhR3Fq/DWXRczT2kKbMinWAkaaQpbQuNo6ogLBRaXHAlUUDJgxyyCyhXRZizZSNJGoAS
        FjLzlU+0rQQ6whWnrc3NWg851KQZqozg15UPwF4tF03STanvz+xSvFRZ4R+W2+4RVJSffQ
        UmgXzdiZXv4oHFkrOVgMnaqHprWhYHY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-131-X3bcbHaVMQW5sU9Eh-hs5A-1; Tue, 14 Jan 2020 08:10:45 -0500
X-MC-Unique: X3bcbHaVMQW5sU9Eh-hs5A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6BFB51902EC2;
        Tue, 14 Jan 2020 13:10:44 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-200-45.brq.redhat.com [10.40.200.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9DEC25E240;
        Tue, 14 Jan 2020 13:10:24 +0000 (UTC)
From:   Mohammed Gamal <mgamal@redhat.com>
To:     linux-hyperv@vger.kernel.org, sthemmin@microsoft.com,
        haiyangz@microsoft.com, netdev@vger.kernel.org
Cc:     kys@microsoft.com, sashal@kernel.org, vkuznets@redhat.com,
        cavery@redhat.com, linux-kernel@vger.kernel.org,
        Mohammed Gamal <mgamal@redhat.com>
Subject: [PATCH v2] hv_netvsc: Fix memory leak when removing rndis device
Date:   Tue, 14 Jan 2020 15:09:50 +0200
Message-Id: <20200114130950.6962-1-mgamal@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kmemleak detects the following memory leak when hot removing
a network device:

unreferenced object 0xffff888083f63600 (size 256):
  comm "kworker/0:1", pid 12, jiffies 4294831717 (age 1113.676s)
  hex dump (first 32 bytes):
    00 40 c7 33 80 88 ff ff 00 00 00 00 10 00 00 00  .@.3............
    00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
  backtrace:
    [<00000000d4a8f5be>] rndis_filter_device_add+0x117/0x11c0 [hv_netvsc]
    [<000000009c02d75b>] netvsc_probe+0x5e7/0xbf0 [hv_netvsc]
    [<00000000ddafce23>] vmbus_probe+0x74/0x170 [hv_vmbus]
    [<00000000046e64f1>] really_probe+0x22f/0xb50
    [<000000005cc35eb7>] driver_probe_device+0x25e/0x370
    [<0000000043c642b2>] bus_for_each_drv+0x11f/0x1b0
    [<000000005e3d09f0>] __device_attach+0x1c6/0x2f0
    [<00000000a72c362f>] bus_probe_device+0x1a6/0x260
    [<0000000008478399>] device_add+0x10a3/0x18e0
    [<00000000cf07b48c>] vmbus_device_register+0xe7/0x1e0 [hv_vmbus]
    [<00000000d46cf032>] vmbus_add_channel_work+0x8ab/0x1770 [hv_vmbus]
    [<000000002c94bb64>] process_one_work+0x919/0x17d0
    [<0000000096de6781>] worker_thread+0x87/0xb40
    [<00000000fbe7397e>] kthread+0x333/0x3f0
    [<000000004f844269>] ret_from_fork+0x3a/0x50

rndis_filter_device_add() allocates an instance of struct rndis_device
which never gets deallocated as rndis_filter_device_remove() sets
net_device->extension which points to the rndis_device struct to NULL,
leaving the rndis_device dangling.

Since net_device->extension is eventually freed in free_netvsc_device(),
we refrain from setting it to NULL inside rndis_filter_device_remove()

Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
---
 drivers/net/hyperv/rndis_filter.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis=
_filter.c
index 857c4bea451c..e66d77dc28c8 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1443,8 +1443,6 @@ void rndis_filter_device_remove(struct hv_device *d=
ev,
 	/* Halt and release the rndis device */
 	rndis_filter_halt_device(net_dev, rndis_dev);
=20
-	net_dev->extension =3D NULL;
-
 	netvsc_device_remove(dev);
 }
=20
--=20
2.21.0

