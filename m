Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8861E49104E
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 19:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238291AbiAQS3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 13:29:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:54404 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238275AbiAQS3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 13:29:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642444163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NPndoflHHf996F3//9m2DIDeIMaF7kUsjRmWBf9enqQ=;
        b=PL8WkxPQKBBAvkoV7++bN3GONiZ6SiR48/nV1BsTLT06pqqT+75wcPnO8OkiVBKWYeAOT7
        DlV8kJEP7e57G2R7RM6wv/lQSPYfnf7xCZ9cW0ZsH4eGArvrEZRxyiowKVNcAW4oket2jN
        I58FFLZY/9UqFeb0NZxCdg2tP2WekJ4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-EBfNgvoXNBGNuaDwLRfXfA-1; Mon, 17 Jan 2022 13:29:20 -0500
X-MC-Unique: EBfNgvoXNBGNuaDwLRfXfA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C0A7B1019988;
        Mon, 17 Jan 2022 18:29:18 +0000 (UTC)
Received: from calimero.vinschen.de (ovpn-112-3.rdu2.redhat.com [10.10.112.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0647C7ED8F;
        Mon, 17 Jan 2022 18:29:17 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id 70FA9A807A3; Mon, 17 Jan 2022 19:29:15 +0100 (CET)
From:   Corinna Vinschen <vinschen@redhat.com>
To:     intel-wired-lan@osuosl.org, netdev@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Lennert Buytenhek <buytenh@wantstofly.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: [PATCH 0/3 net-next v5] igb/igc: fix XDP registration
Date:   Mon, 17 Jan 2022 19:29:12 +0100
Message-Id: <20220117182915.1283151-1-vinschen@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

Corinna Vinschen (2):
  igc: avoid kernel warning when changing RX ring parameters
  igb: refactor XDP registration
  igb/igc: RX queues: fix DMA leak in error case

 drivers/net/ethernet/intel/igb/igb_ethtool.c |  4 ----
 drivers/net/ethernet/intel/igb/igb_main.c    | 13 +++++++++---
 drivers/net/ethernet/intel/igc/igc_main.c    | 21 +++++++++++---------
 3 files changed, 22 insertions(+), 16 deletions(-)

-- 
2.27.0

