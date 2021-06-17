Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7643AB03C
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 11:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhFQJwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 05:52:53 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:37636 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbhFQJwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 05:52:53 -0400
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id C354C806B6;
        Thu, 17 Jun 2021 21:50:42 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1623923442;
        bh=lUijizVvwPMyg0GLVZGO6475vdE8DJ9xnnDL2U44Ryk=;
        h=From:To:Cc:Subject:Date;
        b=TOSN03l+1Z8hEi+RoLB7FZ5u7/PqGuuQJrGAYZk+jQAYZqiTnHm+glJiV+L+W626k
         kTX6IaiIINLfGmUpGjSREJH3l3qGQRGxz/BwGiSAI7rw1a5NdmTChEsmtHrpAB/APT
         MdH9502e+7QtLTFm5ct+WWAYNawZ2O1bSjjTnh0YJ0E+GwYE1UJRBrsXjl/RTfZx2S
         L08CM8YiwruVdF0fSeRntM93Z2ae7mbpauJp1Je/aTar1/6DcDN2XyJerNaGzuyUU6
         z7EqUj9hHr6PuS7zFvEYhK4GHurXJbt0MmmMRwlQ5/5n8wKZ1yeaaNoFyGRlf7yu76
         3xOc/mDbl3yEg==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B60cb1af20000>; Thu, 17 Jun 2021 21:50:42 +1200
Received: from callums-dl.ws.atlnz.lc (callums-dl.ws.atlnz.lc [10.33.22.16])
        by pat.atlnz.lc (Postfix) with ESMTP id 9A35813EE13;
        Thu, 17 Jun 2021 21:50:42 +1200 (NZST)
Received: by callums-dl.ws.atlnz.lc (Postfix, from userid 1764)
        id 9141FA028D; Thu, 17 Jun 2021 21:50:42 +1200 (NZST)
From:   Callum Sinclair <callum.sinclair@alliedtelesis.co.nz>
To:     dsahern@kernel.org, nikolay@nvidia.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linus.luessing@c0d3.blue,
        Callum Sinclair <callum.sinclair@alliedtelesis.co.nz>
Subject: [PATCH 0/1] Create multicast snooping sysctl option
Date:   Thu, 17 Jun 2021 21:50:19 +1200
Message-Id: <20210617095020.28628-1-callum.sinclair@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=IOh89TnG c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=r6YtysWOX24A:10 a=i2UjaB_res8Kl4noDCIA:9
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IGMP and MLD packets can be received on IP sockets but only if the
group has been explicitly joined. This makes snooping all multicast
packets in the ranges 224.0.0.0/8 and FF00::/8 difficult as each
group in these ranges would have to be added via socketopt calls
individually.

It is possible to get all IGMP and MLD packets by creating a packet
socket and using a BPF to grab only IGMP and MLD packets but this
removes some of the other useful options IP sockets have.

Define a new sysctl to allow one or more interfaces to be defined
as a IGMP and/or MLD Snooping device. This means all multicast
packets will be received on a socket bound to the interface without
being explicitly asked for.

Callum Sinclair (1):
  net: Allow all multicast packets to be received on a interface.

 Documentation/networking/ip-sysctl.rst |  8 ++++++++
 include/linux/inetdevice.h             |  1 +
 include/linux/ipv6.h                   |  1 +
 include/uapi/linux/ip.h                |  1 +
 include/uapi/linux/ipv6.h              |  1 +
 include/uapi/linux/netconf.h           |  1 +
 include/uapi/linux/sysctl.h            |  1 +
 net/ipv4/devinet.c                     |  7 +++++++
 net/ipv4/igmp.c                        |  5 +++++
 net/ipv6/addrconf.c                    | 14 ++++++++++++++
 net/ipv6/mcast.c                       |  5 +++++
 11 files changed, 45 insertions(+)

--=20
2.32.0

