Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 963A964E882
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 10:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbiLPJNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 04:13:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiLPJNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 04:13:40 -0500
Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4422B3D3BE;
        Fri, 16 Dec 2022 01:13:37 -0800 (PST)
Received: from myt5-8800bd68420f.qloud-c.yandex.net (myt5-8800bd68420f.qloud-c.yandex.net [IPv6:2a02:6b8:c12:4615:0:640:8800:bd68])
        by forwardcorp1b.mail.yandex.net (Yandex) with ESMTP id 18FE0601F0;
        Fri, 16 Dec 2022 12:13:35 +0300 (MSK)
Received: from d-tatianin-nix.yandex-team.ru (unknown [2a02:6b8:b081:20::1:18])
        by myt5-8800bd68420f.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id RDdkrU0Q6Ko1-Iah20vAt;
        Fri, 16 Dec 2022 12:13:34 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1671182014; bh=DpGcPD4QYNFodyzBuUrzHjZYe9mlGwIx7WnbID1FEt0=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=MtdZfUs9f4EjEINccyLb/HKZmCrkn2/crpmmmC+V3erQTQDPl85m0hEs1kUQc1/Bj
         hYgbEkGMSjp9ReoPK/+AGzqrS5Ghx6KEGd6OsQMC9ijew/Zt2qM/kquQ6uKXFVjehU
         letaB9xrxR/Cny8RFPmkOOQPMZ+8/02EhZIcQO/I=
Authentication-Results: myt5-8800bd68420f.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From:   Daniil Tatianin <d-tatianin@yandex-team.ru>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     Daniil Tatianin <d-tatianin@yandex-team.ru>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Harshitha Ramamurthy <harshitha.ramamurthy@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1] iavfs/iavf_main: actually log ->src mask when talking about it
Date:   Fri, 16 Dec 2022 12:13:26 +0300
Message-Id: <20221216091326.1457454-1-d-tatianin@yandex-team.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes a copy-paste issue where dev_err would log the dst mask even
though it is clearly talking about src.

Found by Linux Verification Center (linuxtesting.org) with the SVACE
static analysis tool.

Fixes: 0075fa0fadd0a ("i40evf: Add support to apply cloud filters")
Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index c4e451ef7942..adc02adef83a 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3850,7 +3850,7 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 				field_flags |= IAVF_CLOUD_FIELD_IIP;
 			} else {
 				dev_err(&adapter->pdev->dev, "Bad ip src mask 0x%08x\n",
-					be32_to_cpu(match.mask->dst));
+					be32_to_cpu(match.mask->src));
 				return -EINVAL;
 			}
 		}
-- 
2.25.1

