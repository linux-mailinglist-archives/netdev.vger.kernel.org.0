Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECF4359C99
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 13:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233799AbhDILFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 07:05:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49125 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233564AbhDILFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 07:05:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617966292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=cQ5YCLMA9Sp8TLm77Zn6ayHZDzA5IAQduvlhAiz00f4=;
        b=EByO9Q70k4pTQFd6n1C7w1cEiZWnlaT8afCHiEvRKKqYKFjGR9TjM/kgeYYX0/H/U4Dt94
        3XmfCmfQv/E4CnmCiDqhx4XAGGIKWQbWTA9qBCGG5Ry70K6s/XWWSENWDePRXogT+l/7x+
        AwN60c2Xvsj10mzM+MFYPH0wLdNkeS0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-525-kDr1D6e_NvWF-TcAwFQ_aQ-1; Fri, 09 Apr 2021 07:04:51 -0400
X-MC-Unique: kDr1D6e_NvWF-TcAwFQ_aQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B18510054F6;
        Fri,  9 Apr 2021 11:04:49 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-50.ams2.redhat.com [10.36.115.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0100010023BE;
        Fri,  9 Apr 2021 11:04:47 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCH net-next 0/4] veth: allow GRO even without XDP
Date:   Fri,  9 Apr 2021 13:04:36 +0200
Message-Id: <cover.1617965243.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series allows the user-space to enable GRO/NAPI on a veth
device even without attaching an XDP program.

It does not change the default veth behavior (no NAPI, no GRO),
except that the GRO feature bit on top of this series will be
effectively off by default on veth devices. Note that currently
the GRO bit is on by default, but GRO never takes place in
absence of XDP.

On top of this series, setting the GRO feature bit enables NAPI
and allows the GRO to take place. The TSO features on the peer
device are preserved.

The main goal is improving UDP forwarding performances for
containers in a typical virtual network setup:

(container) veth -> veth peer -> bridge/ovs -> vxlan -> NIC

Enabling the NAPI threaded mode, GRO the NETIF_F_GRO_UDP_FWD
feature on the veth peer improves the UDP stream performance
with not void netfilter configuration by 2x factor with no
measurable overhead for TCP traffic: some heuristic ensures
that TCP will not go through the additional NAPI/GRO layer.

Some self-tests are added to check the expected behavior in
the default configuration, with XDP and with plain GRO enabled.

Paolo Abeni (4):
  veth: use skb_orphan_partial instead of skb_orphan
  veth: allow enabling NAPI even without XDP
  veth: refine napi usage
  self-tests: add veth tests

 drivers/net/veth.c                   | 152 ++++++++++++++++++++---
 tools/testing/selftests/net/Makefile |   1 +
 tools/testing/selftests/net/veth.sh  | 177 +++++++++++++++++++++++++++
 3 files changed, 316 insertions(+), 14 deletions(-)
 create mode 100755 tools/testing/selftests/net/veth.sh

-- 
2.26.2

