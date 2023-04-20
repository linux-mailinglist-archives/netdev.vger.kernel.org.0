Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D07276E8C8E
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 10:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234398AbjDTIUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 04:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233947AbjDTIU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 04:20:29 -0400
Received: from forwardcorp1c.mail.yandex.net (forwardcorp1c.mail.yandex.net [178.154.239.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B791635BB;
        Thu, 20 Apr 2023 01:20:26 -0700 (PDT)
Received: from mail-nwsmtp-smtp-corp-main-26.myt.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-26.myt.yp-c.yandex.net [IPv6:2a02:6b8:c12:3612:0:640:a8a8:0])
        by forwardcorp1c.mail.yandex.net (Yandex) with ESMTP id 3AB675FA6A;
        Thu, 20 Apr 2023 11:20:22 +0300 (MSK)
Received: from d-tatianin-nix.yandex-team.ru (unknown [2a02:6b8:b081:b409::1:14])
        by mail-nwsmtp-smtp-corp-main-26.myt.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id GKZned0OrSw0-ZMtL3jQ8;
        Thu, 20 Apr 2023 11:20:21 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1681978821; bh=9mp+pNldrwYKUsap4NBAwMn7ODY5PLISjDiGq37dX08=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=p+8OjW/Pwu2PIc8vaB50z4dLDff5X4bJ9YWx+S/Hjm711tgn+trXbY+HJlz7JU9Cg
         o8PzFCM3KY5rPAft0+3aELGcw8lmuNvEgDFIixh0+gCVVTIVM0ztQOyiiqq2aI1eLB
         4g0XxHDpCXk2kT/4eAepg1G5ZnrbOJfBK8Fithak=
Authentication-Results: mail-nwsmtp-smtp-corp-main-26.myt.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
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
Subject: [PATCH net] qed/qed_sriov: propagate errors from qed_init_run in enable_vf_access
Date:   Thu, 20 Apr 2023 11:20:16 +0300
Message-Id: <20230420082016.335314-1-d-tatianin@yandex-team.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The return value was silently ignored, and not propagated to the caller.

Found by Linux Verification Center (linuxtesting.org) with the SVACE
static analysis tool.

Fixes: 1408cc1fa48c ("qed: Introduce VFs")
Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
---
I'm not familiar enough with the code to know if there's anything we
have to undo here in case qed_init_run returns an error. Any additional
comments are appreciated.
---
 drivers/net/ethernet/qlogic/qed/qed_sriov.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
index fa167b1aa019..5244d7208eb4 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -814,7 +814,7 @@ static int qed_iov_enable_vf_access(struct qed_hwfn *p_hwfn,
 	SET_FIELD(igu_vf_conf, IGU_VF_CONF_PARENT, p_hwfn->rel_pf_id);
 	STORE_RT_REG(p_hwfn, IGU_REG_VF_CONFIGURATION_RT_OFFSET, igu_vf_conf);
 
-	qed_init_run(p_hwfn, p_ptt, PHASE_VF, vf->abs_vf_id,
+	rc = qed_init_run(p_hwfn, p_ptt, PHASE_VF, vf->abs_vf_id,
 		     p_hwfn->hw_info.hw_mode);
 
 	/* unpretend */
-- 
2.25.1

