Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 798725F2E7E
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 11:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbiJCJuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 05:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbiJCJt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 05:49:28 -0400
X-Greylist: delayed 1330 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 03 Oct 2022 02:49:22 PDT
Received: from forward102j.mail.yandex.net (forward102j.mail.yandex.net [5.45.198.243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D8425F7;
        Mon,  3 Oct 2022 02:49:21 -0700 (PDT)
Received: from myt6-efff10c3476a.qloud-c.yandex.net (myt6-efff10c3476a.qloud-c.yandex.net [IPv6:2a02:6b8:c12:13a3:0:640:efff:10c3])
        by forward102j.mail.yandex.net (Yandex) with ESMTP id 3FA244BE8DF0;
        Mon,  3 Oct 2022 12:12:23 +0300 (MSK)
Received: by myt6-efff10c3476a.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id 0vVcFmtQu1-CLhOiAOp;
        Mon, 03 Oct 2022 12:12:22 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1664788342;
        bh=SNMppGXILPRmAUGOgbtHH6mka3pq7302+CIsjfv+mvU=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=j/8XpG/vRJ95g7cR8cjmCTuWByl5baHB+IvPMFdyNoGKi0RQvsKRyuux/SOyt4x32
         4n6/2gVSNBb0fGNHqwidEv54SW8fN6kWRfbEC4tn4qEN34jMYZM7tmpz9gdjFzhOro
         2uSlZnyJIgRf3TyFmSr0KQ1wFgYXQBYZ1vujIEWc=
Authentication-Results: myt6-efff10c3476a.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
From:   Peter Kosyh <pkosyh@yandex.ru>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Peter Kosyh <pkosyh@yandex.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ath10k: Check return value of ath10k_get_arvif in ath10k_wmi_event_tdls_peer
Date:   Mon,  3 Oct 2022 12:12:17 +0300
Message-Id: <20221003091217.322598-1-pkosyh@yandex.ru>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return value of a function 'ath10k_get_arvif' is dereferenced without
checking for null in ath10k_wmi_event_tdls_peer, but it is usually checked
for this function.

Make ath10k_wmi_event_tdls_peer do check retval of ath10k_get_arvif.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Peter Kosyh <pkosyh@yandex.ru>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 876410a47d1d..1f2c37c642ff 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -585,6 +585,11 @@ static void ath10k_wmi_event_tdls_peer(struct ath10k *ar, struct sk_buff *skb)
 			goto exit;
 		}
 		arvif = ath10k_get_arvif(ar, __le32_to_cpu(ev->vdev_id));
+		if (!arvif) {
+			ath10k_warn(ar, "no vif for vdev_id %d found\n",
+				__le32_to_cpu(ev->vdev_id));
+			goto exit;
+		}
 		ieee80211_tdls_oper_request(
 					arvif->vif, station->addr,
 					NL80211_TDLS_TEARDOWN,
-- 
2.37.0

