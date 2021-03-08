Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF343330B42
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 11:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbhCHKcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 05:32:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57968 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231567AbhCHKcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 05:32:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615199538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=sPmn+3VtIFlvEVuOGLaP5xi0YdL6Nlb6OjKmNe5SwYQ=;
        b=RP6fse8sqo2f86DotzKiHEDFE5fkPYWJuCCQDwq34LyAXsL5p+6kq6jRDKmfEpYjn9pbZI
        1jghODWkq6MaBzz1daZ6XYSnga9Eb+arVb9VsOpEh11R6X8pNuewI9xzznvQMtKmSHBOh8
        2osW3TMohbCkBbwZHqMOh263X9l2iNM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-VEeGFNJyMiOmN3ac4SUGyA-1; Mon, 08 Mar 2021 05:32:17 -0500
X-MC-Unique: VEeGFNJyMiOmN3ac4SUGyA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B6402101962C;
        Mon,  8 Mar 2021 10:32:15 +0000 (UTC)
Received: from bnemeth.users.ipa.redhat.com (ovpn-113-99.ams2.redhat.com [10.36.113.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D83AB18C7A;
        Mon,  8 Mar 2021 10:32:13 +0000 (UTC)
From:   Balazs Nemeth <bnemeth@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        davem@davemloft.net, willemb@google.com,
        virtualization@lists.linux-foundation.org, bnemeth@redhat.com
Subject: [PATCH v2 0/2] net: prevent infinite loop caused by incorrect proto from virtio_net_hdr_set_proto
Date:   Mon,  8 Mar 2021 11:31:24 +0100
Message-Id: <cover.1615199056.git.bnemeth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here is v2 of the patches that prevent an infinite loop for gso packets
with a protocol from virtio net hdr that doesn't match the protocol in
the packet. Note that packets coming from a device without
header_ops->parse_protocol being implemented will not be caught by
the check in virtio_net_hdr_to_skb, but the infinite loop will still
be prevented by the check in the gso layer.

Balazs Nemeth (2):
  net: check if protocol extracted by virtio_net_hdr_set_proto is
    correct
  net: avoid infinite loop in mpls_gso_segment when mpls_hlen == 0

 include/linux/virtio_net.h | 8 +++++++-
 net/mpls/mpls_gso.c        | 2 +-
 2 files changed, 8 insertions(+), 2 deletions(-)

--
2.29.2

