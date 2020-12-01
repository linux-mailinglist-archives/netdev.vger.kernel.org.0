Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51AE52CA6FB
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 16:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391839AbgLAP0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 10:26:07 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:26300 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391831AbgLAP0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 10:26:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1606836366; x=1638372366;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sW2dIf+kChckESO1JXmWeXnHuxhK74xvLF+hUWco2Fk=;
  b=nfqGJko4ONtClUq0/bWS/Qp85Ytn42gmvwHNa7QW4MPwxkoRnmI5oKVC
   1NKdgKGlaOVqrCRqV+jqTTfWQDDgm9bPVDuQKCcgjMqMC1MH6oH2IFgMX
   ti3MwZNnCzB7Zn/ER0wWDCZn+gfq8Yo9jFlL6FRlSydbbNBjZCgVrj6J9
   I=;
X-IronPort-AV: E=Sophos;i="5.78,384,1599523200"; 
   d="scan'208";a="69767497"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 01 Dec 2020 15:25:19 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS id 95ABEA202B;
        Tue,  1 Dec 2020 15:25:16 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com.com (10.43.162.176) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 1 Dec 2020 15:25:10 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     netdev <netdev@vger.kernel.org>
CC:     linux-kernel <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        David Duncan <davdunc@amazon.com>,
        Dexuan Cui <decui@microsoft.com>,
        Alexander Graf <graf@amazon.de>,
        Jorgen Hansen <jhansen@vmware.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH net-next v1 0/3] vsock: Add flag field in the vsock address 
Date:   Tue, 1 Dec 2020 17:25:02 +0200
Message-ID: <20201201152505.19445-1-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
X-Originating-IP: [10.43.162.176]
X-ClientProxiedBy: EX13D13UWA003.ant.amazon.com (10.43.160.181) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vsock enables communication between virtual machines and the host they are
running on. Nested VMs can be setup to use vsock channels, as the multi
transport support has been available in the mainline since the v5.5 Linux kernel
has been released.

Implicitly, if no host->guest vsock transport is loaded, all the vsock packets
are forwarded to the host. This behavior can be used to setup communication
channels between sibling VMs that are running on the same host. One example can
be the vsock channels that can be established within AWS Nitro Enclaves
(see Documentation/virt/ne_overview.rst).

To be able to explicitly mark a connection as being used for a certain use case,
add a flag field in the vsock address data structure. The "svm_reserved1" field
has been repurposed to be the flag field. The value of the flag will then be
taken into consideration when the vsock transport is assigned.

This way can distinguish between nested VMs / local communication and sibling
VMs use cases. And can also setup one or more types of communication at the same
time.

Thank you.

Andra

---

Patch Series Changelog

The patch series is built on top of v5.10-rc6.

GitHub repo branch for the latest version of the patch series:

* https://github.com/andraprs/linux/tree/vsock-flag-sibling-comm-v1

---

Andra Paraschiv (3):
  vm_sockets: Include flag field in the vsock address data structure
  virtio_transport_common: Set sibling VMs flag on the receive path
  af_vsock: Assign the vsock transport considering the vsock address
    flag

 include/uapi/linux/vm_sockets.h         | 18 +++++++++++++++++-
 net/vmw_vsock/af_vsock.c                | 15 +++++++++++----
 net/vmw_vsock/virtio_transport_common.c |  8 ++++++++
 3 files changed, 36 insertions(+), 5 deletions(-)

-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

