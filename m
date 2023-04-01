Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0BC36D32D3
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 19:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjDAR2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 13:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjDAR2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 13:28:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F55A1BF5D
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 10:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680370055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SNKv27E0TSrQzuBdoriRm3TI5q4rweM0mIElGLkLGAQ=;
        b=dUZqDysz+Ysg7PECphbbbGYWYwALZFvCl1AnadV8b2XJaGIw2R8oLByzJUB6Fr7fqX5z9+
        wCmdW7Zw/N+Qz3QYJfofwVmwbjARKjIL/VvcTEleoUENEA5R+RxWyVRi09N7warUg7L8YE
        JlzchrwWqVLWxcIlJjWLvFDvtro7Ay4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-475-CYuGsK1dOFOTVqNxOGJJoQ-1; Sat, 01 Apr 2023 13:27:32 -0400
X-MC-Unique: CYuGsK1dOFOTVqNxOGJJoQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AEC94101A531;
        Sat,  1 Apr 2023 17:27:31 +0000 (UTC)
Received: from toolbox.redhat.com (ovpn-192-6.brq.redhat.com [10.40.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA53F40C20FA;
        Sat,  1 Apr 2023 17:27:29 +0000 (UTC)
From:   Michal Schmidt <mschmidt@redhat.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Michal Michalik <michal.michalik@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Karol Kolacinski <karol.kolacinski@intel.com>,
        Petr Oros <poros@redhat.com>
Subject: [PATCH net-next 4/4] ice: sleep, don't busy-wait, in the SQ send retry loop
Date:   Sat,  1 Apr 2023 19:26:59 +0200
Message-Id: <20230401172659.38508-5-mschmidt@redhat.com>
In-Reply-To: <20230401172659.38508-1-mschmidt@redhat.com>
References: <20230401172659.38508-1-mschmidt@redhat.com>
MIME-Version: 1.0
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

10 ms is a lot of time to spend busy-waiting. Sleeping is clearly
allowed here, because we have just returned from ice_sq_send_cmd(),
which takes a mutex.

On kernels with HZ=100, this msleep may be twice as long, but I don't
think it matters.
I did not actually observe any retries happening here.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 539b756f227c..438367322bcd 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1643,7 +1643,7 @@ ice_sq_send_cmd_retry(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 
 		memcpy(desc, &desc_cpy, sizeof(desc_cpy));
 
-		mdelay(ICE_SQ_SEND_DELAY_TIME_MS);
+		msleep(ICE_SQ_SEND_DELAY_TIME_MS);
 
 	} while (++idx < ICE_SQ_SEND_MAX_EXECUTE);
 
-- 
2.39.2

