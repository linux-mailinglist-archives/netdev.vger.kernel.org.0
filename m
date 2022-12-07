Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A64E4645C01
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 15:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbiLGOGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 09:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiLGOGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 09:06:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463C715A3C
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 06:05:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D503C617A9
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 14:05:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C46C433D6;
        Wed,  7 Dec 2022 14:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670421930;
        bh=tk8utmezOtdizzCIxzZGRejLD+Uzjwoe5RBptBuevsw=;
        h=From:To:Cc:Subject:Date:From;
        b=bUkQeV27Si8FU4OixZdGd1V+seLWc8uDGu/wajrQRYEC94sP3+xvc8Tcw4kbnsN7S
         PKDSp4uq+G/Cd1LbDkj/RdvXsOXAy7Ub/nHtrCZUFZj1ZW9sEwoMLF/p3jwdQzYjZU
         CSibi3L4PQ3LbFtUjhi1aG7qZlp6NTjKEeNTfcBt2lisI9IEdrw8Ec8mtRbUNzBwz6
         ezeRuekg7SUgcFpPFf9trpYY6rBJg+Z7h6aQ8V6bf71JmSn+mSQg8GbDiiwNd7mKlD
         mO24NNFQAb7WLhgVLQ81kMD9zIhRPGFpCjG1eISb7gnq6GD5rCPtJ+0hAsHlyIjZhf
         merBWXBRlbWvQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        leon@kernel.org, sujuan.chen@mediatek.com
Subject: [PATCH v3 net-next 0/2] fix possible deadlock during WED attach
Date:   Wed,  7 Dec 2022 15:04:53 +0100
Message-Id: <cover.1670421354.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a possible deadlock in mtk_wed_attach if mtk_wed_wo_init routine fails.
Check wo pointer is properly allocated before running mtk_wed_wo_reset() and
mtk_wed_wo_deinit().

Changes sice v2:
- add WARN_ON in mtk_wed_mcu_msg_update()
- split in two patches
Changes since v1:
- move wo pointer checks in __mtk_wed_detach()

Lorenzo Bianconi (2):
  net: ethernet: mtk_wed: fix some possible NULL pointer dereferences
  net: ethernet: mtk_wed: fix possible deadlock if mtk_wed_wo_init fails

 drivers/net/ethernet/mediatek/mtk_wed.c     | 30 ++++++++++++++-------
 drivers/net/ethernet/mediatek/mtk_wed_mcu.c |  3 +++
 2 files changed, 23 insertions(+), 10 deletions(-)

-- 
2.38.1

