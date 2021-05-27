Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C639E392BE0
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 12:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236153AbhE0KfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 06:35:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59139 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235950AbhE0KfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 06:35:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622111622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SDoGZMQzAHCTC4pI9JF5T7YrJh9V7Kj1qQ5Ga0e57lU=;
        b=iFfs3mG73ahUcAV/ntBXWlyBJtN5l+CdamvRVDtWHfdbxjx8b9duwNyMxSsYPXVUntQwMQ
        m0ynbFW9eSQGbA/KXK6a0mwrGLqvb5p+01InTW6o52NIfHNzwMADBgJ53P7QA0k1Px7U5g
        i30YNrqQXId7q3Uo64qAjY1s0n6rAxM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-OgNpm8vFNASmKlJezlHsFg-1; Thu, 27 May 2021 06:33:41 -0400
X-MC-Unique: OgNpm8vFNASmKlJezlHsFg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73EAE801B12;
        Thu, 27 May 2021 10:33:39 +0000 (UTC)
Received: from kks2.redhat.com (ovpn-116-123.sin2.redhat.com [10.67.116.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EDF645D9C6;
        Thu, 27 May 2021 10:33:36 +0000 (UTC)
From:   Karthik S <ksundara@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        karthik.sundaravel@gmail.com,
        Christophe Fontaine <cfontain@redhat.com>,
        Veda Barrenkala <vbarrenk@redhat.com>,
        Vijay Chundury <vchundur@redhat.com>
Cc:     Karthik S <ksundara@redhat.com>
Subject: [PATCH 0/1] net-next: Port Mirroring support for SR-IOV
Date:   Thu, 27 May 2021 16:03:17 +0530
Message-Id: <20210527103318.801175-1-ksundara@redhat.com>
In-Reply-To: <ksundara@redhat.com>
References: <ksundara@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of this message is to gather feedback from the Netdev community on the addition of SRIOV port mirroring to the iproute2 ip CLI. iproute2 was chosen as the desired interface because there is already extensive support for SRIOV configuration built in and many Linux users are familiar with it for configuring Network functionality in the driver thus port mirroring naturally fits into this schema.

Port mirroring involves sending a copy of packets entering and/or leaving one port to another port which is usually different from the original destination of the packets being mirrored.Hardware Port Mirroring can provide the following benefits for users:
1) Live debugging of network issues without bringing any interface or connection down
2) No latency addition when port mirroring tap is introduced
3) No extra CPU resources are required to perform this function

The prospective implementation would provide three modes of packet mirroring (For Egress or Ingress):
1) PF to VF
2) VF to VF
3) VLAN to VF

The suggested iproute2 ip link interface for setting up Port Mirroring is as follows:

$ip link set dev <pf> vf <dest_vfid> mirror
      [ add [ vf src_vfids  [ dir { in | out | all } ] ] |
            [ pf  [ dir { in | out | all } ] ] |
            [ vlan vlan_ids ]
      [ del [ vf src_vfids  [ dir { in | out | all } ] ] |
            [ pf  [ dir { in | out | all } ] ] |
            [ vlan vlan_ids ]
      [ set [ vf src_vfids  [ dir { in | out | all } ] ] |
            [ pf  [ dir { in | out | all } ] ] |
            [ vlan vlan_ids ]
      [ clear ]
$ip link show <pf>

Whilst significant resources have already gone into an internal PoC for this feature, this request for feedback is being done to make sure this solution is acceptable to the Netdev community before further resources are committed for an eventual RFC Patch.

Kernel Changes: https://github.com/karthiksundaravel/linux
Example driver: https://github.com/karthiksundaravel/i40e-2.12.6
Iproute changes: https://github.com/veda10/iproute2

Karthik S (1):
  rtnetlink: Port mirroring support for SR-IOV

 include/linux/netdevice.h    |   4 ++
 include/uapi/linux/if_link.h |  46 +++++++++++++
 net/core/rtnetlink.c         | 123 ++++++++++++++++++++++++++++++++++-
 3 files changed, 172 insertions(+), 1 deletion(-)

-- 
2.31.1

