Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E995F6D32D0
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 19:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjDAR2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 13:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjDAR2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 13:28:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E825EC75
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 10:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680370033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=65Iz+2whr6rjm3xLsaaHebB1Q53TG1JVRojv1Hn702I=;
        b=em3pIZDoJVXhoJrOsk07ECQ+Wutgukg2PxhyyCYu85uf7wcPePu9uH7rBezQEESOnOOZqq
        CvCEP9SmVlj/nDi2l2Y1AAMVAVjv/N7VGhJohFsapAI49ZOor2MYMRfnMpmnCphMnx8hNi
        L6xb5IrJKXw08WHG+ihQ16RsgN2FA7c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-110--4-w7UPHPEeTqBrChxPxQw-1; Sat, 01 Apr 2023 13:27:09 -0400
X-MC-Unique: -4-w7UPHPEeTqBrChxPxQw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83CF1811E7C;
        Sat,  1 Apr 2023 17:27:08 +0000 (UTC)
Received: from toolbox.redhat.com (ovpn-192-6.brq.redhat.com [10.40.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9B73340C20FA;
        Sat,  1 Apr 2023 17:27:06 +0000 (UTC)
From:   Michal Schmidt <mschmidt@redhat.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Michal Michalik <michal.michalik@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Karol Kolacinski <karol.kolacinski@intel.com>,
        Petr Oros <poros@redhat.com>
Subject: [PATCH net-next 0/4] ice: lower CPU usage with GNSS
Date:   Sat,  1 Apr 2023 19:26:55 +0200
Message-Id: <20230401172659.38508-1-mschmidt@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series lowers the CPU usage of the ice driver when using its
provided /dev/gnss*.

Intel engineers, in addition to reviewing the patches for correctness,
please also consider my doubts expressed in the descriptions of patches
1 and 2. There may be better solutions possible.

Michal Schmidt (4):
  ice: lower CPU usage of the GNSS read thread
  ice: sleep, don't busy-wait, for sq_cmd_timeout
  ice: remove unused buffer copy code in ice_sq_send_cmd_retry()
  ice: sleep, don't busy-wait, in the SQ send retry loop

 drivers/net/ethernet/intel/ice/ice_common.c   | 29 +++++--------
 drivers/net/ethernet/intel/ice/ice_controlq.c |  8 ++--
 drivers/net/ethernet/intel/ice/ice_controlq.h |  2 +-
 drivers/net/ethernet/intel/ice/ice_gnss.c     | 42 +++++++++----------
 drivers/net/ethernet/intel/ice/ice_gnss.h     |  3 +-
 5 files changed, 35 insertions(+), 49 deletions(-)

-- 
2.39.2

