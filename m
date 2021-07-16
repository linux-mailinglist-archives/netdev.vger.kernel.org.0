Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B32B3CB9EC
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 17:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240993AbhGPPhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 11:37:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42638 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240551AbhGPPhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 11:37:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626449683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NT0N4NS6nWZiPdwFZ3UGFeunemiYesVFaQZ2vu93N6U=;
        b=hLaUdQliHL3Mf2nm6TpoESH9EQJGD/k2+CHA5ZE7UWHfdxaxpi3KmagB6u0K5uOANO0tBN
        6MUW7LMyfiRW2t0ik42D/1IgvFaxt1YoQBTj2ZR5OFnDpDCMYqcqarMx//i7adKz/11wH5
        khRQDuXmePcmbB9uzDXuNbbzdo+daF0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-fBCF4dc_MWihhJZWr-V7gA-1; Fri, 16 Jul 2021 11:34:41 -0400
X-MC-Unique: fBCF4dc_MWihhJZWr-V7gA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B7A5A91272;
        Fri, 16 Jul 2021 15:34:40 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-207.ams2.redhat.com [10.36.113.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ACF055C1A3;
        Fri, 16 Jul 2021 15:34:33 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, toke@redhat.com
Subject: [PATCH RFC v2 0/5] veth: more flexible channels number configuration
Date:   Fri, 16 Jul 2021 17:34:18 +0200
Message-Id: <cover.1626449533.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

This iteration covers the feedback provided by Toke and Jakub.

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

