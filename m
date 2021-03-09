Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E33C332419
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 12:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbhCILcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 06:32:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29509 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230122AbhCILcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 06:32:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615289521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=9Hd9dlI2mhGfzWKWP5M+r5dSFrh0DXyROodADpdYywg=;
        b=bpPc4izYB1jwVpeS07xAYnVuPzcYAgYGlfiHijfN6EouCL1IBHwwV8mm1ilvKkXt6zgBFP
        Q+eJqkrQh1W0p9oj7KB3/Y4d3snKQkh60SMCiAD2/N+AvYdms5yXJrHEnE63U6Re3y7Su7
        0i4R3pUS9GBG8wlftuUpWGRyPV1GUg4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-gRUK1z1cPquk_dsKlOilhw-1; Tue, 09 Mar 2021 06:31:59 -0500
X-MC-Unique: gRUK1z1cPquk_dsKlOilhw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F3DB801503;
        Tue,  9 Mar 2021 11:31:58 +0000 (UTC)
Received: from bnemeth.users.ipa.redhat.com (ovpn-115-104.ams2.redhat.com [10.36.115.104])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B4E7059451;
        Tue,  9 Mar 2021 11:31:52 +0000 (UTC)
From:   Balazs Nemeth <bnemeth@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        dsahern@gmail.com, davem@davemloft.net, willemb@google.com,
        virtualization@lists.linux-foundation.org, bnemeth@redhat.com
Subject: [PATCH net v3 0/2] net: prevent infinite loop caused by incorrect proto from virtio_net_hdr_set_proto
Date:   Tue,  9 Mar 2021 12:30:59 +0100
Message-Id: <cover.1615288658.git.bnemeth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches prevent an infinite loop for gso packets with a protocol
from virtio net hdr that doesn't match the protocol in the packet.
Note that packets coming from a device without
header_ops->parse_protocol being implemented will not be caught by
the check in virtio_net_hdr_to_skb, but the infinite loop will still
be prevented by the check in the gso layer.

Changes from v2 to v3:
  - Remove unused *eth.
  - Use MPLS_HLEN to also check if the MPLS header length is a multiple
    of four.

Balazs Nemeth (2):
  net: check if protocol extracted by virtio_net_hdr_set_proto is
    correct
  net: avoid infinite loop in mpls_gso_segment when mpls_hlen == 0

 include/linux/virtio_net.h | 7 ++++++-
 net/mpls/mpls_gso.c        | 3 +++
 2 files changed, 9 insertions(+), 1 deletion(-)

--
2.29.2

