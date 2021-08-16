Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 196813ED5F4
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 15:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239144AbhHPNQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 09:16:03 -0400
Received: from spam.zju.edu.cn ([61.164.42.155]:27544 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240099AbhHPNOz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 09:14:55 -0400
Received: from localhost.localdomain (unknown [10.214.16.253])
        by mail-app3 (Coremail) with SMTP id cC_KCgDnmDydZBphqP8vAw--.34297S4;
        Mon, 16 Aug 2021 21:14:09 +0800 (CST)
From:   Dinghao Liu <dinghao.liu@zju.edu.cn>
To:     dinghao.liu@zju.edu.cn, kjlu@umn.edu
Cc:     Shahed Shaikh <shshaikh@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sony Chacko <sony.chacko@qlogic.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: qlcnic: add missed unlock in qlcnic_83xx_flash_read32
Date:   Mon, 16 Aug 2021 21:14:04 +0800
Message-Id: <20210816131405.24024-1-dinghao.liu@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cC_KCgDnmDydZBphqP8vAw--.34297S4
X-Coremail-Antispam: 1UD129KBjvdXoWrKFyfKF1DCFy7WryxJFWkJFb_yoWkZwb_KF
        48Zw18Xwn8GrZFgw43Kr43Jr129a98ZF1fAw1Sgay3A34DJFWrWFyvqFyrArW7W34j9ryD
        G3WxA3y3Aw1IkjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbskFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AK
        wVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20x
        vE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4UJVW0owA2z4x0Y4vEx4A2
        jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52
        x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWU
        GwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI4
        8JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2xKxwCF04k20xvY
        0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26r4fKr1UJr1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr
        1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE
        14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7
        IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E
        87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73Uj
        IFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAggOBlZdtVU9CwASsN
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qlcnic_83xx_unlock_flash() is called on all paths after we call
qlcnic_83xx_lock_flash(), except for one error path on failure
of QLCRD32(), which may cause a deadlock. This bug is suggested
by a static analysis tool, please advise.

Fixes: 81d0aeb0a4fff ("qlcnic: flash template based firmware reset recovery")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
index d8882d0b6b49..d51bac7ba5af 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
@@ -3156,8 +3156,10 @@ int qlcnic_83xx_flash_read32(struct qlcnic_adapter *adapter, u32 flash_addr,
 
 		indirect_addr = QLC_83XX_FLASH_DIRECT_DATA(addr);
 		ret = QLCRD32(adapter, indirect_addr, &err);
-		if (err == -EIO)
+		if (err == -EIO) {
+			qlcnic_83xx_unlock_flash(adapter);
 			return err;
+		}
 
 		word = ret;
 		*(u32 *)p_data  = word;
-- 
2.17.1

