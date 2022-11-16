Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 723BE62BED0
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 14:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbiKPNBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 08:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiKPNB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 08:01:29 -0500
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7EA7995A6;
        Wed, 16 Nov 2022 05:01:25 -0800 (PST)
Received: from zju.edu.cn (unknown [10.12.77.33])
        by mail-app2 (Coremail) with SMTP id by_KCgC3v_cW33RjmJ22Bw--.48243S4;
        Wed, 16 Nov 2022 21:01:10 +0800 (CST)
From:   Lin Ma <linma@zju.edu.cn>
To:     krzk@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mudongliangabcd@gmail.com
Cc:     Lin Ma <linma@zju.edu.cn>,
        syzbot+43475bf3cfbd6e41f5b7@syzkaller.appspotmail.com
Subject: [PATCH v1] nfc/nci: fix race with opening and closing
Date:   Wed, 16 Nov 2022 21:01:06 +0800
Message-Id: <20221116130106.10202-1-linma@zju.edu.cn>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: by_KCgC3v_cW33RjmJ22Bw--.48243S4
X-Coremail-Antispam: 1UD129KBjvdXoWrKF4DZw45XrWDCFykGF4fGrg_yoWDWFcE93
        97AF4DXws3Aw1xGwsxJF4qyryayayIgayIvryrWF4qv345Zr15JFZ7WrnxJr43ua43uFyD
        XFn2qF48C345GjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb2xFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AK
        wVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20x
        vE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E
        87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
        8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
        Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
        xGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxF
        aVAv8VW8uw4UJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr
        4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxG
        rwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8Jw
        CI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2
        z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously we leverage NCI_UNREG and the lock inside nci_close_device to
prevent the race condition between opening a device and closing a
device. However, it still has problem because a failed opening command
will erase the NCI_UNREG flag and allow another opening command to
bypass the status checking.

This fix corrects that by making sure the NCI_UNREG is held.

Reported-by: syzbot+43475bf3cfbd6e41f5b7@syzkaller.appspotmail.com
Fixes: 48b71a9e66c2 ("NFC: add NCI_UNREG flag to eliminate the race")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
---
 net/nfc/nci/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 6a193cce2a75..76ade5d4f55a 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -542,7 +542,7 @@ static int nci_open_device(struct nci_dev *ndev)
 		skb_queue_purge(&ndev->tx_q);
 
 		ndev->ops->close(ndev);
-		ndev->flags = 0;
+		ndev->flags = BIT(NCI_UNREG);
 	}
 
 done:
-- 
2.38.1

