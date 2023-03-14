Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5153A6B9422
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 13:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbjCNMls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 08:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbjCNMlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 08:41:36 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ACD199251;
        Tue, 14 Mar 2023 05:41:09 -0700 (PDT)
Received: from maxwell.localdomain ([109.43.51.107]) by
 mrelayeu.kundenserver.de (mreue109 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1Mwfj2-1qRHkW3Auw-00y8gt; Tue, 14 Mar 2023 13:39:39 +0100
From:   Jochen Henneberg <jh@henneberg-systemdesign.com>
To:     netdev@vger.kernel.org
Cc:     Jochen Henneberg <jh@henneberg-systemdesign.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 0/2] net: stmmac: Premature loop termination check was ignored
Date:   Tue, 14 Mar 2023 13:37:57 +0100
Message-Id: <20230314123759.132521-1-jh@henneberg-systemdesign.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:nirRWSK/2cPq72undNtjfDp90mDVAAXSn8jLqo9gwzdQIrM76dA
 IVIXDerUHw9J/dLbyoAkjYTSwMFHCQwtMtbJvbi3tGCofoPSvM2MbeYnwS9ZnmamQ3WGZIE
 Wa6FEvvhVLvzFqNljBX94bIN+zxPaBwckA5zP/HH3U/k9NjQyXHWbLuatE5vsWZW04cnnkv
 GyMU5qadNKpk6kXiFGC0w==
UI-OutboundReport: notjunk:1;M01:P0:sUckAPOkw98=;PDZ0zTqeiARJq7sB6acZmZhoo/H
 xYgY5WFfkAgHVZ1PS/rc7PFXdecHiQ5dx6wVy8s3znWf3nym7UX4aXYTmmqXWL50jX15/0iw0
 GLNN0x1QvsBYvdmHKXmpkD9MINLH71Jfiio1CmQaC5Ds2+3LOgf4aM2o/DA7uus/iSkSKvN6R
 Gn6KWfv1rABLi62nKT/XZ31E5gD2Byob6gNXWuNbGCZcOjW3GST9KeCPzV1cmTeXaPlWX2MsJ
 JSvI3wt4BihBv5EqNGLbbJIgI0RbIgdlDuOqzjqBbSmzdF3Y6xkIEc52Uxlf8nIBSBQaYzbl2
 RW+0/AQQVzAi9ebph9gAORyTMG4DZOabkPDByAjepDFgiu9TKT+LVG27TNiOUgPMcXUAmRviy
 pr74TdoWnZKj3YPvGRV7gLDHotkP96/mnBgAfUsiznatYXGP6oLSTBhS/JNeL6Fzi9j6mvIjD
 /Ygg90IE3GVDsgFLfTciR+2a58JXHIdkehMFfBE4UW8j41csl/ImcMfhw0EaUXJhrhdzg5yDj
 tmTe4vNf2/VRwFE8qi6z3s+2owRTWYzke2O2/2iZE8pBtFTv4kgGRlamczsplEiBUgExAqEt/
 ivprnKNjtNhtgy2WVdvNZ6vKXb5khLMO/VD9pg641Qppcopiyv97tsLkVB/S/pKQ8naRkHOVa
 pvgZ5QWCgZ59CA0IMkwv9oI8QNlkIikiw2Lsutb2nA==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As proposed in [1] here is are the fixes as a patch series that do the
premature end-of-loop check within the goto loop.

Jochen Henneberg (2):
  net: stmmac: Premature loop termination check was ignored
  net: stmmac: Premature loop termination check was ignored

 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

[1] https://lore.kernel.org/all/Y%2FdiTAg2iUopr%2FOy@corigine.com/
-- 
2.39.2

