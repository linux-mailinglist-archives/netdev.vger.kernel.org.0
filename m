Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2005986F
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 12:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfF1KcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 06:32:22 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:57693 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbfF1KcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 06:32:21 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1M6ltQ-1he45c1Zlu-008HB7; Fri, 28 Jun 2019 12:32:02 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Aviad Krawczyk <aviad.krawczyk@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Xue Chaojing <xuechaojing@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Zhao Chen <zhaochen6@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        dann frazier <dann.frazier@canonical.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] hinic: reduce rss_init stack usage
Date:   Fri, 28 Jun 2019 12:31:44 +0200
Message-Id: <20190628103158.2446356-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:QYqTtvUivST2IBpYNwbYUeyahFSQ0lBwtIbf+kVFvKJocTNobD3
 6oZnmk2BXjTOixp0JMhOYp5ecOqypzq2WAcggP2YyxYJ4gHZ+MT4EQM1++vHGj2/KQ5+oyn
 SI7TwHlzuPyA2DXGEAhyFDj3op66U9AI3PoPKSpxIZQNa5G7pmFPfX/AqplBNEs+94s6dVQ
 5ZrbusWR4PJB7Msx7reMQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:vAu+k/1Jipc=:/rgUdU+92MUy0Czi/8OOPu
 jzWuggmU0hfDPFjrql2B5uc4F+INBBT8E2TRB1fksflWdlRQyJRl6sitiElZmKCpViSAOXcX3
 URC7WkRgP2PvaN7etopF27r35pyIXb1OVP9AdyrXMHvJRe6OT7dWN1TE5scXiEmWaQNhjEhSz
 awEHcf+UIaeyw9MOz5oC0PGlIXuvO5F3EPj40CNT1A4PdHjx+d20z2JeXSu6r7nSorWpJTtbR
 xqo6h5tiuVeaXX+H99SOgn8UaPfjh4W7QUVY3AbWl/1JhBHA9IqYuMxbUyF/hBPs0WQgR2Yse
 qmQsa/f97SamCv0kQd+bezG/OmavEadLt1Q21hOf52Y+RESnK89MC3pghP7eon+iT4vMnI1c/
 u9tP7chOcrOTG2D0zdMJydgHgoVVDyucPaNu0GmHl0fVQ88HR8K3CpQBAWejAgzyZI/eOAWaZ
 9DkIBf6akZ8m5fzT7Z4WSYqUdA+wWS0gX71P6RQEiz+vgb5CzEmm7LKlBsENWUAEHVAIaU4no
 6pIA6NQ3EYT9t77av15TU/ZjiavLwoVDQXPXsP7aIZo4XHR+LYLZ1VvTzKLUt+BlV6j2+OW3u
 PXJ8zfCb09ALH1hQDj2k39PcEKDKaj6EHEMVwrnNHuzmqsI2OfIpIQCRb6ggoIPIf45dEYENj
 IdmytUJN8Du2MtJu9wLjrKsNlzA9+uC1hCRrKuG1jQxGLOK1DhKhKWDWjOEMFW4wluoBCG3zi
 DeEjPwBPphsOLL/EUMMa83I1jO4S4J5JGUI2CA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 32-bit architectures, putting an array of 256 u32 values on the
stack uses more space than the warning limit:

drivers/net/ethernet/huawei/hinic/hinic_main.c: In function 'hinic_rss_init':
drivers/net/ethernet/huawei/hinic/hinic_main.c:286:1: error: the frame size of 1068 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]

I considered changing the code to use u8 values here, since that's
all the hardware supports, but dynamically allocating the array is
a more isolated fix here.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 .../net/ethernet/huawei/hinic/hinic_main.c    | 20 ++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 1b917543feac..ceb0e247f52d 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -256,37 +256,43 @@ static int hinic_configure_max_qnum(struct hinic_dev *nic_dev)
 
 static int hinic_rss_init(struct hinic_dev *nic_dev)
 {
-	u32 indir_tbl[HINIC_RSS_INDIR_SIZE] = { 0 };
 	u8 default_rss_key[HINIC_RSS_KEY_SIZE];
 	u8 tmpl_idx = nic_dev->rss_tmpl_idx;
+	u32 *indir_tbl;
 	int err, i;
 
+	indir_tbl = kcalloc(HINIC_RSS_INDIR_SIZE, sizeof(u32), GFP_KERNEL);
+	if (!indir_tbl)
+		return -ENOMEM;
+
 	netdev_rss_key_fill(default_rss_key, sizeof(default_rss_key));
 	for (i = 0; i < HINIC_RSS_INDIR_SIZE; i++)
 		indir_tbl[i] = ethtool_rxfh_indir_default(i, nic_dev->num_rss);
 
 	err = hinic_rss_set_template_tbl(nic_dev, tmpl_idx, default_rss_key);
 	if (err)
-		return err;
+		goto out;
 
 	err = hinic_rss_set_indir_tbl(nic_dev, tmpl_idx, indir_tbl);
 	if (err)
-		return err;
+		goto out;
 
 	err = hinic_set_rss_type(nic_dev, tmpl_idx, nic_dev->rss_type);
 	if (err)
-		return err;
+		goto out;
 
 	err = hinic_rss_set_hash_engine(nic_dev, tmpl_idx,
 					nic_dev->rss_hash_engine);
 	if (err)
-		return err;
+		goto out;
 
 	err = hinic_rss_cfg(nic_dev, 1, tmpl_idx);
 	if (err)
-		return err;
+		goto out;
 
-	return 0;
+out:
+	kfree(indir_tbl);
+	return err;
 }
 
 static void hinic_rss_deinit(struct hinic_dev *nic_dev)
-- 
2.20.0

