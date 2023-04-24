Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 885866ECC4F
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 14:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbjDXMuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 08:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbjDXMuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 08:50:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C721749FF;
        Mon, 24 Apr 2023 05:50:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BF5E61557;
        Mon, 24 Apr 2023 12:50:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE56C4339C;
        Mon, 24 Apr 2023 12:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682340602;
        bh=0rJK3cwH3zFbaELWMscdo/xtWlXrXcTBDQUPOZjTeYg=;
        h=From:To:Cc:Subject:Date:From;
        b=VwaRvpwo89ywpoBeHmigT77cjaiQaz879A1GWXTurHnrnMFNh+osJZx8itQC0NDCV
         L6rWHOnmMCdpctxCfJ8TwKdOnjoC+cRQ5jRidq7pvyII5V6kjFLvJLsb/jYsUFsPJA
         9JLLJOPRu1A+uR+Zv6EUCaAkHMfrHOXATaBotY95rRiiYjiRYh8XDtDbLt2ZMnKNU0
         m44zALqL6rfoj2PXLD78I3vOErRNE1cWETirEwovQaUrc2b4oWKzXi6x6UI0x8xrq1
         PvCi1HSd8XLy2sSej/UHqPS5wtRZTm78plkpdoKKHOmXhG2I7gErUuLJMnRF68Lv+2
         B8UHsUexxOoWg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pqve6-0003IV-D8; Mon, 24 Apr 2023 14:50:19 +0200
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH 0/2] Bluetooth: fix debugfs registration
Date:   Mon, 24 Apr 2023 14:48:50 +0200
Message-Id: <20230424124852.12625-1-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The HCI controller debugfs interface is created during setup or when a
controller is configured, but there is nothing preventing a controller
from being configured multiple times (e.g. by setting the device
address), which results in a host of errors in the logs:

	debugfs: File 'features' in directory 'hci0' already present!
	debugfs: File 'manufacturer' in directory 'hci0' already present!
	debugfs: File 'hci_version' in directory 'hci0' already present!
	...
	debugfs: File 'quirk_simultaneous_discovery' in directory 'hci0' already present!

The Qualcomm driver suffers from a related problem for controllers with
non-persistent setup.

Johan


Johan Hovold (2):
  Bluetooth: fix debugfs registration
  Bluetooth: hci_qca: fix debugfs registration

 drivers/bluetooth/hci_qca.c | 6 +++++-
 include/net/bluetooth/hci.h | 1 +
 net/bluetooth/hci_sync.c    | 3 +++
 3 files changed, 9 insertions(+), 1 deletion(-)

-- 
2.39.2

