Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9F92CF288
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 18:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730958AbgLDRDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 12:03:51 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:25047 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730826AbgLDRDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 12:03:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607101430; x=1638637430;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9ZWPXCNBvGyFhS6+xfCTmX3TbeCP7FxnUU5/8BPnPT0=;
  b=CxG4PMYITfkaMSdC3kNuwb1St5CG/9esDNI2ibr59WktqBG8A6DdNd3/
   JWh9y5mDUuLfEl4sjwQDAGFqMUr/1Fa0o4NhOFSPT+PjAkxZ/gv2m8t9Q
   2lSC07XUo0Ncc3sUHhBpePv1CjFYnMEGhmz9X62ReBec21wFS5DxkGwrt
   E=;
X-IronPort-AV: E=Sophos;i="5.78,393,1599523200"; 
   d="scan'208";a="67658563"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 04 Dec 2020 17:02:51 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id C4BE0A2010;
        Fri,  4 Dec 2020 17:02:46 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.53) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Dec 2020 17:02:40 +0000
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
Subject: [PATCH net-next v2 0/4] vsock: Add flags field in the vsock address
Date:   Fri, 4 Dec 2020 19:02:31 +0200
Message-ID: <20201204170235.84387-1-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
X-Originating-IP: [10.43.162.53]
X-ClientProxiedBy: EX13D23UWC003.ant.amazon.com (10.43.162.81) To
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
add a flags field in the vsock address data structure. The "svm_reserved1" field
has been repurposed to be the flags field. The value of the flags will then be
taken into consideration when the vsock transport is assigned. This way can
distinguish between different use cases, such as nested VMs / local communication
and sibling VMs.

Thank you.

Andra

---

Patch Series Changelog

The patch series is built on top of v5.10-rc6.

GitHub repo branch for the latest version of the patch series:

* https://github.com/andraprs/linux/tree/vsock-flag-sibling-comm-v2

v1 -> v2

* Update the vsock flag naming to "VMADDR_FLAG_TO_HOST".
* Use bitwise operators to setup and check the vsock flag.
* Set the vsock flag on the receive path in the vsock transport assignment
  logic.
* Merge the checks for the g2h transport assignment in one "if" block.
* v1: https://lore.kernel.org/lkml/20201201152505.19445-1-andraprs@amazon.com/

---

Andra Paraschiv (4):
  vm_sockets: Include flags field in the vsock address data structure
  vm_sockets: Add VMADDR_FLAG_TO_HOST vsock flag
  af_vsock: Set VMADDR_FLAG_TO_HOST flag on the receive path
  af_vsock: Assign the vsock transport considering the vsock address
    flags

 include/uapi/linux/vm_sockets.h | 17 ++++++++++++++++-
 net/vmw_vsock/af_vsock.c        | 21 +++++++++++++++++++--
 2 files changed, 35 insertions(+), 3 deletions(-)

-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

