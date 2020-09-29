Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04B9327D3AA
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 18:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729528AbgI2Qad convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 29 Sep 2020 12:30:33 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:29180 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728126AbgI2Qac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 12:30:32 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-Zle2tyG7M42IAyhjs9qLRQ-1; Tue, 29 Sep 2020 12:30:27 -0400
X-MC-Unique: Zle2tyG7M42IAyhjs9qLRQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33FBC8015C5;
        Tue, 29 Sep 2020 16:30:26 +0000 (UTC)
Received: from bahia.lan (ovpn-113-41.ams2.redhat.com [10.36.113.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EAF9E1972A;
        Tue, 29 Sep 2020 16:30:20 +0000 (UTC)
Subject: [PATCH v2 0/2] vhost: Skip access checks on GIOVAs
From:   Greg Kurz <groug@kaod.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, qemu-devel@nongnu.org,
        Laurent Vivier <laurent@vivier.eu>,
        David Gibson <david@gibson.dropbear.id.au>
Date:   Tue, 29 Sep 2020 18:30:20 +0200
Message-ID: <160139701999.162128.2399875915342200263.stgit@bahia.lan>
User-Agent: StGit/0.21
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

While digging some more I realized that log_access_ok() can also be 
passed a GIOVA (vq->log_addr) even though log_used() will never log
anything at that address. I could observe addresses beyond the end
of the log bitmap being passed to access_ok(), but it didn't have any
impact because the addresses were still acceptable from an access_ok()
standpoint. Adding a second patch to fix that anyway.

Note that I've also posted a patch for QEMU so that it skips the used
structure GIOVA when allocating the log bitmap. Otherwise QEMU fails to
allocate it because POWER puts GIOVAs very high in the address space (ie.
over 0x800000000000000ULL).

https://patchwork.ozlabs.org/project/qemu-devel/patch/160105498386.68108.2145229309875282336.stgit@bahia.lan/

v2:
 - patch 1: move the (vq->ioltb) check from vhost_vq_access_ok() to
            vq_access_ok() as suggested by MST
 - patch 2: new patch

---

Greg Kurz (2):
      vhost: Don't call access_ok() when using IOTLB
      vhost: Don't call log_access_ok() when using IOTLB


 drivers/vhost/vhost.c |   32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

--
Greg

