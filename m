Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA0F2D9C45
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 17:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730037AbgLNQMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 11:12:39 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:48392 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729598AbgLNQMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 11:12:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607962344; x=1639498344;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vwyhK+XBrxa7GJXnWqxrpzNFzOKUuPo8CcCM/5vRbQI=;
  b=HvEyCeDhp+Ck5OiEACYsH+V3+HuzV+2MLVRowPWBt1USdSeRcjiKu2+/
   HTbw+7mGrhxJAkyA4mg6e0ILI6ERRc+TGK6jqHYk3GKTCBusoshqs3LSz
   tiAX7CrDypnYyAqXkgqmfzZGuLu01/InnrYJLFe470UCigTTIDDkN+rbB
   Y=;
X-IronPort-AV: E=Sophos;i="5.78,420,1599523200"; 
   d="scan'208";a="71057542"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 14 Dec 2020 16:11:36 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id 5E70FA1EBB;
        Mon, 14 Dec 2020 16:11:34 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com.com (10.43.160.21) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 14 Dec 2020 16:11:28 +0000
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
Subject: [PATCH net-next v4 0/5] vsock: Add flags field in the vsock address
Date:   Mon, 14 Dec 2020 18:11:17 +0200
Message-ID: <20201214161122.37717-1-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
X-Originating-IP: [10.43.160.21]
X-ClientProxiedBy: EX13D14UWC001.ant.amazon.com (10.43.162.5) To
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
add a flags field in the vsock address data structure. The value of the flags
field is taken into consideration when the vsock transport is assigned. This way
can distinguish between different use cases, such as nested VMs / local
communication and sibling VMs.

The flags field can be set in the user space application connect logic. On the
listen path, the field can be set in the kernel space logic.

Thank you.

Andra

---

Patch Series Changelog

The patch series is built on top of v5.10.

GitHub repo branch for the latest version of the patch series:

* https://github.com/andraprs/linux/tree/vsock-flag-sibling-comm-v4

v3 -> v4

* Rebase on top of v5.10.
* Add check for supported flag values. 
* Update the "svm_flags" field to be 1 byte instead of 2 bytes.
* v3: https://lore.kernel.org/lkml/20201211103241.17751-1-andraprs@amazon.com/

v2 -> v3

* Rebase on top of v5.10-rc7.
* Add "svm_flags" as a new field, not reusing "svm_reserved1".
* Update comments to mention when the "VMADDR_FLAG_TO_HOST" flag is set in the
  connect and listen paths.
* Update bitwise check logic to not compare result to the flag value.
* v2: https://lore.kernel.org/lkml/20201204170235.84387-1-andraprs@amazon.com/

v1 -> v2

* Update the vsock flag naming to "VMADDR_FLAG_TO_HOST".
* Use bitwise operators to setup and check the vsock flag.
* Set the vsock flag on the receive path in the vsock transport assignment
  logic.
* Merge the checks for the g2h transport assignment in one "if" block.
* v1: https://lore.kernel.org/lkml/20201201152505.19445-1-andraprs@amazon.com/

---

Andra Paraschiv (5):
  vm_sockets: Add flags field in the vsock address data structure
  vm_sockets: Add VMADDR_FLAG_TO_HOST vsock flag
  vsock_addr: Check for supported flag values
  af_vsock: Set VMADDR_FLAG_TO_HOST flag on the receive path
  af_vsock: Assign the vsock transport considering the vsock address
    flags

 include/uapi/linux/vm_sockets.h | 26 +++++++++++++++++++++++++-
 net/vmw_vsock/af_vsock.c        | 21 +++++++++++++++++++--
 net/vmw_vsock/vsock_addr.c      |  4 +++-
 3 files changed, 47 insertions(+), 4 deletions(-)

-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

