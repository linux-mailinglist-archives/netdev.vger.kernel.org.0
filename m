Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D59FE16C6
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 11:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390545AbfJWJ4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 05:56:12 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27145 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390939AbfJWJ4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 05:56:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571824571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=PjIrWxilILjTXJMM4pZ+a2frsZYLFCvzVYmdT4dKHeA=;
        b=b5zDXq8J97LwC5WX8PDjo+cfJdZZOnEezlbTMRhRHpU2HUGLbaQxaw+As7v+urTLtBvPCO
        jM5JM27+/lVGh8aIP74TVhqRuUiISgaAurfsQFsZZn7yRTifKcU5ghkF4R+odbPzYeFbAN
        WSNSePJTMlPVIAqAazHXU5EXB1LqDpc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-AIB5fJO8MnCfZd5pS6ln_A-1; Wed, 23 Oct 2019 05:56:07 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B56EC1800DD0;
        Wed, 23 Oct 2019 09:56:05 +0000 (UTC)
Received: from steredhat.redhat.com (unknown [10.36.118.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1BEEB5C1B2;
        Wed, 23 Oct 2019 09:55:54 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-hyperv@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH net-next 00/14] vsock: add multi-transports support
Date:   Wed, 23 Oct 2019 11:55:40 +0200
Message-Id: <20191023095554.11340-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: AIB5fJO8MnCfZd5pS6ln_A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds the multi-transports support to vsock, following
this proposal: https://www.spinics.net/lists/netdev/msg575792.html

With the multi-transports support, we can use VSOCK with nested VMs
(using also different hypervisors) loading both guest->host and
host->guest transports at the same time.
Before this series, vmci-transport supported this behavior but only
using VMware hypervisor on L0, L1, etc.

RFC: https://patchwork.ozlabs.org/cover/1168442/
RFC -> v1:
- Added R-b/A-b from Dexuan and Stefan
- Fixed comments and typos in several patches (Stefan)
- Patch 7: changed .notify_buffer_size return to void (Stefan)
- Added patch 8 to simplify the API exposed to the transports (Stefan)
- Patch 11:
  + documented VSOCK_TRANSPORT_F_* flags (Stefan)
  + fixed vsock_assign_transport() when the socket is already assigned
  + moved features outside of struct vsock_transport, and used as
    parameter of vsock_core_register() as a preparation of Patch 12
- Removed "vsock: add 'transport_hg' to handle g2h\h2g transports" patch
- Added patch 12 to register vmci_transport only when VMCI guest/host
  are active

The first 9 patches are cleanups and preparations, maybe some of
these can go regardless of this series.

Patch 10 changes the hvs_remote_addr_init(). setting the
VMADDR_CID_HOST as remote CID instead of VMADDR_CID_ANY to make
the choice of transport to be used work properly.

Patch 11 adds multi-transports support.

Patch 12 touch a little bit the vmci_transport and the vmci driver
to register the vmci_transport only when there are active host/guest.

Patch 13 prevents the transport modules unloading while sockets are
assigned to them.

Patch 14 fixes an issue in the bind() logic discoverable only with
the new multi-transport support.

I've tested this series with nested KVM (vsock-transport [L0,L1],
virtio-transport[L1,L2]) and with VMware (L0) + KVM (L1)
(vmci-transport [L0,L1], vhost-transport [L1], virtio-transport[L2]).

Dexuan successfully tested the RFC series on HyperV with a Linux guest.

Stefano Garzarella (14):
  vsock/vmci: remove unused VSOCK_DEFAULT_CONNECT_TIMEOUT
  vsock: remove vm_sockets_get_local_cid()
  vsock: remove include/linux/vm_sockets.h file
  vsock: add 'transport' member in the struct vsock_sock
  vsock/virtio: add transport parameter to the
    virtio_transport_reset_no_sock()
  vsock: add 'struct vsock_sock *' param to vsock_core_get_transport()
  vsock: handle buffer_size sockopts in the core
  vsock: add vsock_create_connected() called by transports
  vsock: move vsock_insert_unbound() in the vsock_create()
  hv_sock: set VMADDR_CID_HOST in the hvs_remote_addr_init()
  vsock: add multi-transports support
  vsock/vmci: register vmci_transport only when VMCI guest/host are
    active
  vsock: prevent transport modules unloading
  vsock: fix bind() behaviour taking care of CID

 drivers/misc/vmw_vmci/vmci_driver.c     |  50 ++++
 drivers/misc/vmw_vmci/vmci_driver.h     |   2 +
 drivers/misc/vmw_vmci/vmci_guest.c      |   2 +
 drivers/misc/vmw_vmci/vmci_host.c       |   7 +
 drivers/vhost/vsock.c                   |  96 +++---
 include/linux/virtio_vsock.h            |  18 +-
 include/linux/vm_sockets.h              |  15 -
 include/linux/vmw_vmci_api.h            |   2 +
 include/net/af_vsock.h                  |  44 +--
 include/net/vsock_addr.h                |   2 +-
 net/vmw_vsock/af_vsock.c                | 376 ++++++++++++++++++------
 net/vmw_vsock/hyperv_transport.c        |  70 ++---
 net/vmw_vsock/virtio_transport.c        | 177 ++++++-----
 net/vmw_vsock/virtio_transport_common.c | 131 +++------
 net/vmw_vsock/vmci_transport.c          | 137 +++------
 net/vmw_vsock/vmci_transport.h          |   3 -
 net/vmw_vsock/vmci_transport_notify.h   |   1 -
 17 files changed, 627 insertions(+), 506 deletions(-)
 delete mode 100644 include/linux/vm_sockets.h

--=20
2.21.0

