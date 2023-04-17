Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5716E50F5
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 21:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbjDQTao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 15:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbjDQTaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 15:30:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B242F65B9
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 12:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681759746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XPsjU+T4QardE/RwlsdSiXNlNwbaRp/4GQ/VtlbYyZw=;
        b=UGgQdukUEAEDLYK/eunQv3qPW1wCYSNgvDcU5K5hMzX10SjsIJkzHc+36w/whrAM2qQJUN
        GdyibA/MWBtxrCKhX2JN+it4f8qkoRaUZF6GSeZl00eHHvr0vltWwe0BzS1+1VvoTgA0eq
        w21cI8hn9jciT8PwcUJuGRYi1ATAPfU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-349-wd8iwKFhN16P7JjHhrijdQ-1; Mon, 17 Apr 2023 15:29:05 -0400
X-MC-Unique: wd8iwKFhN16P7JjHhrijdQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B73F53815F07;
        Mon, 17 Apr 2023 19:29:04 +0000 (UTC)
Received: from calimero.vinschen.de (unknown [10.39.195.69])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 953F9C16028;
        Mon, 17 Apr 2023 19:29:04 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id 92C76A808C0; Mon, 17 Apr 2023 21:29:03 +0200 (CEST)
From:   Corinna Vinschen <vinschen@redhat.com>
To:     netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        alexandre.torgue@foss.st.com, Jose Abreu <joabreu@synopsys.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] stmmac: fix changing mac address
Date:   Mon, 17 Apr 2023 21:29:03 +0200
Message-Id: <20230417192903.590077-1-vinschen@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Without the IFF_LIVE_ADDR_CHANGE flag being set, the network code
disallows changing the mac address while the interface is UP.

Consequences are, for instance, that the interface can't be used
in a failover bond.

Add the missing flag to net_device priv_flags.

Tested on Intel Elkhart Lake with default settings, as well as with
failover and alb mode bonds.

Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 8ab67c020a08..02d0bf70c528 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7279,6 +7279,8 @@ int stmmac_dvr_probe(struct device *device,
 	if (flow_ctrl)
 		priv->flow_ctrl = FLOW_AUTO;	/* RX/TX pause on */
 
+	ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
+
 	/* Setup channels NAPI */
 	stmmac_napi_add(ndev);
 
-- 
2.31.1

