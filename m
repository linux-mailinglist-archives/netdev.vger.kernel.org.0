Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB61447979B
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 00:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbhLQXnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 18:43:51 -0500
Received: from us-smtp-delivery-160.mimecast.com ([170.10.133.160]:21190 "EHLO
        us-smtp-delivery-160.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229488AbhLQXnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 18:43:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qsc.com; s=mimecast20190503;
        t=1639784630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=iE/sszsA1GaPTlHkvwyykJkzKVhcJNxgo40yRqjlyHc=;
        b=HvIKsK3K1jIR73XOWypdtcAbVBi6yemNCbqtoDAGXuykdNwDYLRG4QraODzXvsF5Q6eBc0
        4pE0Uk+ny8P7ZETP/Pa5M4Gb1228WyRBNgPTVlQ64yEFjeAoTiexLsaJoEitGv/jSWxbKr
        PfDi8N+oEeAZr+I7+QSrtCrs+MVbuBc=
Received: from 1uslvexch01.qscaudio.com (209.170.222.241 [209.170.222.241])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 us-mta-216-qjM709rHO_KxS77SCeQ6Yw-1; Fri, 17 Dec 2021 18:43:49 -0500
X-MC-Unique: qjM709rHO_KxS77SCeQ6Yw-1
Received: from 1uslvexch01.qscaudio.com (10.105.30.125) by
 1uslvexch01.qscaudio.com (10.105.30.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 17 Dec 2021 15:43:47 -0800
Received: from james-3700x.qscaudio.com (10.104.74.41) by smtp-relay.qsc.com
 (10.105.30.125) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Fri, 17 Dec 2021 15:43:46 -0800
From:   James McLaughlin <james.mclaughlin@qsc.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <vinicius.gomes@intel.com>,
        James McLaughlin <james.mclaughlin@qsc.com>
Subject: [PATCH v2] igc: Fix TX timestamp support for non-MSI-X platforms
Date:   Fri, 17 Dec 2021 16:43:10 -0700
Message-ID: <20211217234310.740255-1-james.mclaughlin@qsc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA60A255 smtp.mailfrom=james.mclaughlin@qsc.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: qsc.com
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Time synchronization was not properly enabled on non-MSI-X platforms.

Fixes: 2c344ae24501 ("igc: Add support for TX timestamping")

Signed-off-by: James McLaughlin <james.mclaughlin@qsc.com>
Reviewed-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---

Having trouble with work email client, understand and agree with comments f=
rom Vinicius.
v1->v2 updated commit message, email subject, and reference original commit=
 this is fixing.

 drivers/net/ethernet/intel/igc/igc_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethern=
et/intel/igc/igc_main.c
index 8e448288ee26..d28a80a00953 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5467,6 +5467,9 @@ static irqreturn_t igc_intr_msi(int irq, void *data)
 =09=09=09mod_timer(&adapter->watchdog_timer, jiffies + 1);
 =09}
=20
+=09if (icr & IGC_ICR_TS)
+=09=09igc_tsync_interrupt(adapter);
+
 =09napi_schedule(&q_vector->napi);
=20
 =09return IRQ_HANDLED;
@@ -5510,6 +5513,9 @@ static irqreturn_t igc_intr(int irq, void *data)
 =09=09=09mod_timer(&adapter->watchdog_timer, jiffies + 1);
 =09}
=20
+=09if (icr & IGC_ICR_TS)
+=09=09igc_tsync_interrupt(adapter);
+
 =09napi_schedule(&q_vector->napi);
=20
 =09return IRQ_HANDLED;
--=20
2.25.1

