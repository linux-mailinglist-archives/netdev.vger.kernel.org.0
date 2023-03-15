Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 476106BBD91
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 20:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbjCOTtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 15:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbjCOTtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 15:49:03 -0400
Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26EBB1BAF5;
        Wed, 15 Mar 2023 12:48:32 -0700 (PDT)
Received: from mail-nwsmtp-smtp-corp-main-62.myt.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-62.myt.yp-c.yandex.net [IPv6:2a02:6b8:c12:2619:0:640:e777:0])
        by forwardcorp1b.mail.yandex.net (Yandex) with ESMTP id 81B665FF97;
        Wed, 15 Mar 2023 22:48:26 +0300 (MSK)
Received: from d-tatianin-nix.HomeLAN (unknown [2a02:6b8:b081:b711::1:2a])
        by mail-nwsmtp-smtp-corp-main-62.myt.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id MmpZl50hv8c0-V1mgUtDL;
        Wed, 15 Mar 2023 22:48:25 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1678909705; bh=KYvNM7ml1IcN3ZNSKnTy48XecqCZr9+I5Ds2ibkGhKw=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=pdPX0IVlA1H44yMCMnFcRkg3FaxYcbPuFaqRgjAfRt73SUszrfvCMPm4lo4g6eb4l
         4LfXMTjbGGRXOVcc1bMYt1UHynKY3gxoNqT9j9639XdHgWNjaJLPvBquJZ9lejvkd7
         vHE1af5ZgHomRZ4vIkzNqO9movKtBkT3NSJGhTIs=
Authentication-Results: mail-nwsmtp-smtp-corp-main-62.myt.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From:   Daniil Tatianin <d-tatianin@yandex-team.ru>
To:     Ariel Elior <aelior@marvell.com>
Cc:     Daniil Tatianin <d-tatianin@yandex-team.ru>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yuval Mintz <Yuval.Mintz@qlogic.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] qed/qed_sriov: avoid a possible NULL deref in configure_min_tx_rate
Date:   Wed, 15 Mar 2023 22:48:09 +0300
Message-Id: <20230315194809.579756-1-d-tatianin@yandex-team.ru>
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

We have to make sure that the info returned by qed_iov_get_vf_info is
valid before using it.

Found by Linux Verification Center (linuxtesting.org) with the SVACE
static analysis tool.

Fixes: 733def6a04bf ("qed*: IOV link control")
Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
---
 drivers/net/ethernet/qlogic/qed/qed_sriov.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
index 2bf18748581d..cd43f1b23eb1 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -4404,6 +4404,9 @@ qed_iov_configure_min_tx_rate(struct qed_dev *cdev, int vfid, u32 rate)
 	}
 
 	vf = qed_iov_get_vf_info(QED_LEADING_HWFN(cdev), (u16)vfid, true);
+	if (!vf)
+		return -EINVAL;
+
 	vport_id = vf->vport_id;
 
 	return qed_configure_vport_wfq(cdev, vport_id, rate);
-- 
2.25.1

