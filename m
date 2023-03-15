Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 320186BBD8B
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 20:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbjCOTrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 15:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbjCOTrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 15:47:39 -0400
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851A87DD0D;
        Wed, 15 Mar 2023 12:47:11 -0700 (PDT)
Received: from mail-nwsmtp-smtp-corp-main-62.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-62.vla.yp-c.yandex.net [IPv6:2a02:6b8:c0d:3786:0:640:7c97:0])
        by forwardcorp1a.mail.yandex.net (Yandex) with ESMTP id 59FC360147;
        Wed, 15 Mar 2023 22:46:25 +0300 (MSK)
Received: from d-tatianin-nix.HomeLAN (unknown [2a02:6b8:b081:b711::1:2a])
        by mail-nwsmtp-smtp-corp-main-62.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id LkptH40h1mI0-oGGbD262;
        Wed, 15 Mar 2023 22:46:24 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1678909584; bh=xepOwA5O8nfRmiuTHAqJf2zN43poau4DsX8xiFS7h9U=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=vze6zgcKbiE9wDQbBbQ6LISTPc47orA4jtUL3xfQGgmZhMklLaj9s+Q5NWFYB+9z+
         ilM+2B+xkVs7D16TqJdiPfee4hDpqn1tmXwmazUxdo260vn7usNEYANTYK6zNpR83c
         HaoOg08wWua/naefgdV1A2MnOTxM6fGddj1yrW+g=
Authentication-Results: mail-nwsmtp-smtp-corp-main-62.vla.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From:   Daniil Tatianin <d-tatianin@yandex-team.ru>
To:     Ariel Elior <aelior@marvell.com>
Cc:     Daniil Tatianin <d-tatianin@yandex-team.ru>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sudarsana Reddy Kalluru <sudarsana.kalluru@cavium.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] qed/qed_mng_tlv: correctly zero out ->min instead of ->hour
Date:   Wed, 15 Mar 2023 22:46:18 +0300
Message-Id: <20230315194618.579286-1-d-tatianin@yandex-team.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes an issue where ->hour would erroneously get zeroed out
instead of ->min because of a bad copy paste.

Found by Linux Verification Center (linuxtesting.org) with the SVACE
static analysis tool.

Fixes: f240b6882211 ("qed: Add support for processing fcoe tlv request.")
Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
---
 drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c b/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c
index 6190adf965bc..f55eed092f25 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c
@@ -422,7 +422,7 @@ qed_mfw_get_tlv_time_value(struct qed_mfw_tlv_time *p_time,
 	if (p_time->hour > 23)
 		p_time->hour = 0;
 	if (p_time->min > 59)
-		p_time->hour = 0;
+		p_time->min = 0;
 	if (p_time->msec > 999)
 		p_time->msec = 0;
 	if (p_time->usec > 999)
-- 
2.25.1

