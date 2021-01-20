Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7BDC2FD317
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 15:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390796AbhATOn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 09:43:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26891 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390730AbhATOlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 09:41:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611153573;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=jcmi7IRbKfPU7zhZ58GxMqDWQcVd4fEg3bQrTXHSVhY=;
        b=bdbcDr+jTsY2jy5kyQU5/ZwZ5ABAcm92A9A7Yz34eBWEPhPteBzw5r+WX1VPewxgEXw7JQ
        vhZYmNhqMQWwAW0wKNsF7oJ1i/BlBVHor9GgEKPYJeacNwjRI3vQ7CHA488H2Mk+ixbT9O
        uwHqpcluzCNSPwjNx5G6q8gF3U0AgNM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-71A20GnJMri4-GCvHDI3AQ-1; Wed, 20 Jan 2021 09:39:31 -0500
X-MC-Unique: 71A20GnJMri4-GCvHDI3AQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6511192D78F;
        Wed, 20 Jan 2021 14:39:29 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-164.ams2.redhat.com [10.36.115.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 82F745D9C2;
        Wed, 20 Jan 2021 14:39:28 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH v2 net-next 0/5] mptcp: re-enable sndbuf autotune
Date:   Wed, 20 Jan 2021 15:39:09 +0100
Message-Id: <cover.1611153172.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sendbuffer autotuning was unintentionally disabled as a
side effect of the recent workqueue removal refactor. These
patches re-enable id, with some extra care: with autotuning
enable/large send buffer we need a more accurate packet
scheduler to be able to use efficiently the available
subflow bandwidth, especially when the subflows have
different capacities.

The first patch cleans-up subflow socket handling, making
the actual re-enable (patch 2) simpler.

Patches 3 and 4 improve the packet scheduler, to better cope
with non trivial scenarios and large send buffer. 

Finally patch 5 adds and uses some infrastructure to avoid
the workqueue usage for the packet scheduler operations introduced
by the previous patches.

v1 -> v2:
 - fix a UaF in patch 5, see patch changelog for the details 

Paolo Abeni (5):
  mptcp: always graft subflow socket to parent
  mptcp: re-enable sndbuf autotune
  mptcp: do not queue excessive data on subflows
  mptcp: schedule work for better snd subflow selection
  mptcp: implement delegated actions

 net/mptcp/protocol.c | 179 ++++++++++++++++++++++++++++---------------
 net/mptcp/protocol.h |  87 +++++++++++++++++++++
 net/mptcp/subflow.c  |  55 ++++++++++++-
 3 files changed, 258 insertions(+), 63 deletions(-)

-- 
2.26.2

