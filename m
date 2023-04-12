Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD5F6DED73
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 10:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjDLIUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 04:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjDLIUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 04:20:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C445B6A41
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 01:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681287591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=oJ0AvAxU8YiIt1rkYJGTfQA8ueLL73KkTt4yrMJFcSA=;
        b=K+9K1oHwqndA+DxrTi5ChcP1i2xbCJRgsoQLToMwnT10pbNgu3AWr5VRewZrabFV1xUBje
        x7KgUwY5+MdJ+CI+i5jN2qgiDSz5amP4/JbOc3b++m+G4RzKht7qcaIIu8AwWckpFbdxrY
        YDWqnJNIpKrVo3MKodqELZ2Bx2DW5oo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-vikeAygTOGiBbHvyVpg8RA-1; Wed, 12 Apr 2023 04:19:48 -0400
X-MC-Unique: vikeAygTOGiBbHvyVpg8RA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE6843C0F187;
        Wed, 12 Apr 2023 08:19:47 +0000 (UTC)
Received: from toolbox.infra.bos2.lab (ovpn-192-9.brq.redhat.com [10.40.192.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F2C441415117;
        Wed, 12 Apr 2023 08:19:45 +0000 (UTC)
From:   Michal Schmidt <mschmidt@redhat.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Karol Kolacinski <karol.kolacinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Simon Horman <simon.horman@corigine.com>,
        Michal Michalik <michal.michalik@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Petr Oros <poros@redhat.com>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 0/6] ice: lower CPU usage with GNSS
Date:   Wed, 12 Apr 2023 10:19:23 +0200
Message-Id: <20230412081929.173220-1-mschmidt@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series lowers the CPU usage of the ice driver when using its
provided /dev/gnss*.

v2:
 - Changed subject of patch 1. Requested by Andrew Lunn.
 - Added patch 2 to change the polling interval as recommended by Intel.
 - Added patch 3 to remove sq_cmd_timeout as suggested by Simon Horman.

Michal Schmidt (6):
  ice: do not busy-wait to read GNSS data
  ice: increase the GNSS data polling interval to 20 ms
  ice: remove ice_ctl_q_info::sq_cmd_timeout
  ice: sleep, don't busy-wait, for ICE_CTL_Q_SQ_CMD_TIMEOUT
  ice: remove unused buffer copy code in ice_sq_send_cmd_retry()
  ice: sleep, don't busy-wait, in the SQ send retry loop

 drivers/net/ethernet/intel/ice/ice_common.c   | 29 +++++--------
 drivers/net/ethernet/intel/ice/ice_controlq.c | 12 +++---
 drivers/net/ethernet/intel/ice/ice_controlq.h |  3 +-
 drivers/net/ethernet/intel/ice/ice_gnss.c     | 42 +++++++++----------
 drivers/net/ethernet/intel/ice/ice_gnss.h     |  3 +-
 5 files changed, 36 insertions(+), 53 deletions(-)

-- 
2.39.2

