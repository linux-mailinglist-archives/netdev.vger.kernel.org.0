Return-Path: <netdev+bounces-7940-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 971F67222BA
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 11:56:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50B2D281201
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:56:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D9A6156E1;
	Mon,  5 Jun 2023 09:56:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92980156D0
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 09:56:03 +0000 (UTC)
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8339B8
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 02:56:00 -0700 (PDT)
X-QQ-mid: bizesmtp86t1685958952trabyio6
Received: from localhost.localdomain ( [60.177.99.31])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 05 Jun 2023 17:55:51 +0800 (CST)
X-QQ-SSF: 01400000000000N0Z000000A0000000
X-QQ-FEAT: dKvkn8qoLrEQWQdYBXYHpS2gwex9CvNurH0iJ538W4eZNbWBuYTPXENg90Tlr
	HwY/vW07hk5T8cxR65K4RqNAAcXQtjHn58vkb5ndOf0YTkVqVJJ2twEK4ftkRyCg2OrPsdJ
	nI3Ibr9A/dqhfvx2e6P9fuy6HN0gf1czIx7ennuSdiG9bpw9Ph96amwUHbjzDg18b5z4I3W
	/LAHfFj4Y8qle1Z54btwo5NtHOwHmIVsB6Vpl9Mxn9HSQwSpN6tbqJStCJLqoTZY5W5VyX4
	NIgAwJyaIeeLFggd72Pn8ZnZ0EVl0mRKU6/ZRaqTlDUFaVn/BYpbT0wkF7hT2n4Ho+95bFW
	dVv0EGC9sV5Ok+VR7UklWarfcpZDzmd0aESrM02RAbJOBj9ezkp+IYK5k5TToMBrwiUvEej
	isrilAXJBe0=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 2032313646085698842
From: Mengyuan Lou <mengyuanlou@net-swift.com>
To: netdev@vger.kernel.org
Cc: jiawenwu@trustnetic.com,
	Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [RFC,PATCH net-next 3/3] net: ngbe: add support for ncsi nics
Date: Mon,  5 Jun 2023 17:52:52 +0800
Message-ID: <5050D7292AC40763+20230605095527.57898-4-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230605095527.57898-1-mengyuanlou@net-swift.com>
References: <20230605095527.57898-1-mengyuanlou@net-swift.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvrgz:qybglogicsvrgz5a-3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Pass ncsi_enabled through netdev to phy_supsend().
when ncsi_enabled is on, phy should not to supsend.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index 5d013ac3acd1..37d5e1f12d19 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -629,6 +629,7 @@ static int ngbe_probe(struct pci_dev *pdev,
 
 	device_set_wakeup_enable(&pdev->dev, wx->wol);
 	netdev->wol_enabled = wx->wol_enabled;
+	netdev->ncsi_enabled = wx->ncsi_enabled;
 
 	/* Save off EEPROM version number and Option Rom version which
 	 * together make a unique identify for the eeprom
-- 
2.41.0


