Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBFAE3CF65C
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 10:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235087AbhGTIMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 04:12:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26509 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233414AbhGTIFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 04:05:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626770703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=bUp4vxsQgTQRrk0Qssrw44tpCd0hG0HCzOI7bhOnxOE=;
        b=GJtiLuPNnMx7CjWGZsbCUQOUg1DD3EpQjiE2PT315Tr+0Rkl8RhpV9foEhfn8JbrAjAW6d
        GXtQCNoBKECLH3VmCR/dtgquPYOrZAGt4FfLscLzCPQjvHptX63osLr431tbDmotSy0Cfl
        FkU5P+CRavEX6W/ACPVsIU4+BcLFJjE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-vNVxE0KnMXip13QFYdS7Dw-1; Tue, 20 Jul 2021 04:44:59 -0400
X-MC-Unique: vNVxE0KnMXip13QFYdS7Dw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF49C1019982;
        Tue, 20 Jul 2021 08:44:58 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-114-77.ams2.redhat.com [10.36.114.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 726D760BD8;
        Tue, 20 Jul 2021 08:44:57 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, toke@redhat.com
Subject: [PATCH net-next 0/5] veth: more flexible channels number configuration
Date:   Tue, 20 Jul 2021 10:41:47 +0200
Message-Id: <cover.1626768072.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XDP setups can benefit from multiple veth RX/TX queues. Currently
veth allow setting such number only at creation time via the 
'numrxqueues' and 'numtxqueues' parameters.

This series introduces support for the ethtool set_channel operation
and allows configuring the queue number via a new module parameter.

The veth default configuration is not changed.

Finally self-tests are updated to check the new features, with both
valid and invalid arguments.

This iteration is a rebase of the most recent RFC, it does not provide
a module parameter to configure the default number of queues, but I
think could be worthy

RFC v1 -> RFC v2:
 - report more consistent 'combined' count
 - make set_channel as resilient as possible to errors
 - drop module parameter - but I would still consider it.
 - more self-tests

Paolo Abeni (5):
  veth: always report zero combined channels
  veth: factor out initialization helper
  veth: implement support for set_channel ethtool op
  veth: create by default nr_possible_cpus queues
  selftests: net: veth: add tests for set_channel

 drivers/net/veth.c                  | 305 +++++++++++++++++++++++-----
 tools/testing/selftests/net/veth.sh | 183 ++++++++++++++++-
 2 files changed, 434 insertions(+), 54 deletions(-)

-- 
2.26.3

