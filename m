Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B04428236F
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 12:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbgJCKBx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 3 Oct 2020 06:01:53 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:60934 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725826AbgJCKBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 06:01:53 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-uNrKKprfMHOGpQcR7fbb3Q-1; Sat, 03 Oct 2020 06:01:48 -0400
X-MC-Unique: uNrKKprfMHOGpQcR7fbb3Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D849B801ADE;
        Sat,  3 Oct 2020 10:01:46 +0000 (UTC)
Received: from bahia.lan (ovpn-112-192.ams2.redhat.com [10.36.112.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C6135D9D3;
        Sat,  3 Oct 2020 10:01:41 +0000 (UTC)
Subject: [PATCH v3 0/3] vhost: Skip access checks on GIOVAs
From:   Greg Kurz <groug@kaod.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        qemu-devel@nongnu.org, Laurent Vivier <laurent@vivier.eu>,
        David Gibson <david@gibson.dropbear.id.au>
Date:   Sat, 03 Oct 2020 12:01:40 +0200
Message-ID: <160171888144.284610.4628526949393013039.stgit@bahia.lan>
User-Agent: StGit/0.21
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=groug@kaod.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kaod.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series addresses some misuse around vring addresses provided by
userspace when using an IOTLB device. The misuse cause failures of
the VHOST_SET_VRING_ADDR ioctl on POWER, which in turn causes QEMU
to crash at migration time.

Jason suggested that we should use vhost_get_used_size() during the
review of v2. Fixed this in a preliminary patch (patch 2) and rebased
the vq_log_used_access_ok() helper on top (patch 3).

Note that I've also posted a patch for QEMU so that it skips the used
structure GIOVA when allocating the log bitmap. Otherwise QEMU fails to
allocate it because POWER puts GIOVAs very high in the address space (ie.
over 0x800000000000000ULL).

https://patchwork.ozlabs.org/project/qemu-devel/patch/160105498386.68108.2145229309875282336.stgit@bahia.lan/

v3:
 - patch 1: added Jason's ack
 - patch 2: new patch to use vhost_get_used_size()
 - patch 3: rebased patch 2 from v2

v2:
 - patch 1: move the (vq->ioltb) check from vhost_vq_access_ok() to
            vq_access_ok() as suggested by MST
 - patch 2: new patch

---

Greg Kurz (3):
      vhost: Don't call access_ok() when using IOTLB
      vhost: Use vhost_get_used_size() in vhost_vring_set_addr()
      vhost: Don't call log_access_ok() when using IOTLB


 drivers/vhost/vhost.c |   33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

--
Greg

