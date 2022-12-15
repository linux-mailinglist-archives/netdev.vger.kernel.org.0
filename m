Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4508B64E402
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 23:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiLOWvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 17:51:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiLOWvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 17:51:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19AB43D93D
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 14:51:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671144666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=YjHSeOcAQkQ7ENMLsxcSRW3ncebyKJH9WpbmehEsMYs=;
        b=WIXwjF/qXS01ljQ5gOP3f1Bb2AqkfC28LkdVRLhhLKoPl2EWXnp1TrhwkTSjwvR4BwljdI
        ibZcV1LGSHx7vECc897wPDqDHyHFzICY0l16FbNmuzbaUl76JuszezDMo85zwxQYU1ehCQ
        0WoxjzGJqgmDkcZ6surNWvk5yUvQqVA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-166-2LGHJ-BePpmIO208BiOIyA-1; Thu, 15 Dec 2022 17:51:05 -0500
X-MC-Unique: 2LGHJ-BePpmIO208BiOIyA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DFB593C0F696;
        Thu, 15 Dec 2022 22:51:04 +0000 (UTC)
Received: from toolbox.redhat.com (ovpn-192-38.brq.redhat.com [10.40.192.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A47652166B26;
        Thu, 15 Dec 2022 22:51:03 +0000 (UTC)
From:   Michal Schmidt <mschmidt@redhat.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Patryk Piotrowski <patryk.piotrowski@intel.com>
Subject: [PATCH net v2 0/2] iavf: fix temporary deadlock and failure to set MAC address
Date:   Thu, 15 Dec 2022 23:50:47 +0100
Message-Id: <20221215225049.508812-1-mschmidt@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes an issue where setting the MAC address on iavf runs into a
timeout and fails with EAGAIN.

Changes in v2:
 - Removed unused 'ret' variable in patch 1.
 - Added patch 2 to fix another cause of the same timeout.

Michal Schmidt (2):
  iavf: fix temporary deadlock and failure to set MAC address
  iavf: avoid taking rtnl_lock in adminq_task

 drivers/net/ethernet/intel/iavf/iavf.h        |   4 +-
 .../net/ethernet/intel/iavf/iavf_ethtool.c    |  10 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 135 ++++++++++--------
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |   8 +-
 4 files changed, 86 insertions(+), 71 deletions(-)

-- 
2.37.2

