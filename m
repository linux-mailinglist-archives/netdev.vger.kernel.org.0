Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE8F493C42
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 15:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355308AbiASOxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 09:53:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49149 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355296AbiASOxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 09:53:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642603987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=QnoVnkWNJcRI9CxJFxEhranlUVrSFdV8X6+O7Egmt5A=;
        b=Z2X8tpvHikZO+PksoCsBymSp27fsimIMuLq9xrBBnK12txQcG7pRhadAQgnyCerwN1IPZf
        r96egfMZK2mvYkpWo7wAvinfu4poFVEMscfGO9Q7fcNd+l1mSX6PTcGWGkKhvDcQAwecFx
        gNNX+vfNfW1qKnrmzNABVlRgLOqC0JQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-104-Oo5RWqqoOv2QT3ytND8nEA-1; Wed, 19 Jan 2022 09:53:02 -0500
X-MC-Unique: Oo5RWqqoOv2QT3ytND8nEA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D017343CA;
        Wed, 19 Jan 2022 14:53:01 +0000 (UTC)
Received: from calimero.vinschen.de (ovpn-112-9.ams2.redhat.com [10.36.112.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CC2242AA81;
        Wed, 19 Jan 2022 14:53:00 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id 5BDB9A80D67; Wed, 19 Jan 2022 15:52:59 +0100 (CET)
From:   Corinna Vinschen <vinschen@redhat.com>
To:     intel-wired-lan@osuosl.org, netdev@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Lennert Buytenhek <buytenh@wantstofly.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: [PATCH 0/2 net-next v6] igb/igc: fix XDP registration
Date:   Wed, 19 Jan 2022 15:52:57 +0100
Message-Id: <20220119145259.1790015-1-vinschen@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the kernel warning "Missing unregister, handled but fix driver"
when running, e.g.,

  $ ethtool -G eth0 rx 1024

on igc.  Remove memset hack from igb and align igb code to igc. 

v3: use dev_err rather than netdev_err, just as in error case.
v4: fix a return copy/pasted from original igc code into the correct
    `goto err', improve commit message.
v5: add missing dma_free_coherent calls in error case.
v6: refactor code to register with XDP first, as in igc originally.

Corinna Vinschen (2):
  igc: avoid kernel warning when changing RX ring parameters
  igb: refactor XDP registration

 drivers/net/ethernet/intel/igb/igb_ethtool.c |  4 ----
 drivers/net/ethernet/intel/igb/igb_main.c    | 19 +++++++++++++------
 drivers/net/ethernet/intel/igc/igc_main.c    |  3 +++
 3 files changed, 16 insertions(+), 10 deletions(-)

-- 
2.27.0

