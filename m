Return-Path: <netdev+bounces-8868-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EB7A8726258
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:08:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A75CA2812EE
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:08:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF04A35B58;
	Wed,  7 Jun 2023 14:07:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53CB370CF
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 14:07:57 +0000 (UTC)
Received: from qs51p00im-qukt01071502.me.com (qs51p00im-qukt01071502.me.com [17.57.155.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E522697
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 07:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pen.gy; s=sig1;
	t=1686146263; bh=pzOiGFlXxe7wjzq9Fg+hUaE4VwJuvopU7xJEFjn/GtE=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=Ess5UdrSTD0MqGSfHurZPTz//Rqt34b2G1OxfCVLZ6IQSlR/f/b61dAuKilsJu9Zg
	 4fqTo8mJZtQPDwDaXMyspBRCDAWBG08P0/TB2aDugahJpWcLhVCt6WzMvGQgQb/9cz
	 SNfEwdpku/4fNbKI4CvozQyvM3x0gArQsV4S6PtiJ0qg6C5i9waqC0knlUqIZPTMhf
	 Oc616rEAj3lmVp0CoaQ0XnNUiPNwUVx/0bKLhmJx6KUTAF6sSDmNitvvXEUCE2lpje
	 8plkSlF0/IyYYW+OF1AzpNUYp1ee8HfP8qT1tZrLhylzohU2j/G/DhHOZu9R9avLFZ
	 iE8Di/KhMlZTA==
Received: from fossa.iopsys.eu (qs51p00im-dlb-asmtp-mailmevip.me.com [17.57.155.28])
	by qs51p00im-qukt01071502.me.com (Postfix) with ESMTPSA id 1526666802E9;
	Wed,  7 Jun 2023 13:57:40 +0000 (UTC)
From: Foster Snowhill <forst@pen.gy>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Georgi Valkov <gvalkov@gmail.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	linux-usb@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH net-next v4 1/4] usbnet: ipheth: fix risk of NULL pointer deallocation
Date: Wed,  7 Jun 2023 15:56:59 +0200
Message-Id: <20230607135702.32679-1-forst@pen.gy>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: FF6KxZYHCoMp_WPLSmy58s38wlihLML9
X-Proofpoint-GUID: FF6KxZYHCoMp_WPLSmy58s38wlihLML9
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.138,18.0.790,17.11.62.513.0000000_definitions?=
 =?UTF-8?Q?=3D2022-01-12=5F02:2020-02-14=5F02,2022-01-12=5F02,2021-12-02?=
 =?UTF-8?Q?=5F01_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 clxscore=1030 suspectscore=0 malwarescore=0 mlxlogscore=350 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2306070117
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Georgi Valkov <gvalkov@gmail.com>

The cleanup precedure in ipheth_probe will attempt to free a
NULL pointer in dev->ctrl_buf if the memory allocation for
this buffer is not successful. While kfree ignores NULL pointers,
and the existing code is safe, it is a better design to rearrange
the goto labels and avoid this.

Signed-off-by: Georgi Valkov <gvalkov@gmail.com>
Signed-off-by: Foster Snowhill <forst@pen.gy>
---
v4:
  No change
v3: https://lore.kernel.org/netdev/20230527130309.34090-1-forst@pen.gy/
  - Reword commit msg to indicate design improvement rather than bugfix
  - Add missing signoff for Foster Snowhill
  No code changes
v2: https://lore.kernel.org/netdev/20230525194255.4516-1-forst@pen.gy/
  - Factor out goto label change from v1 into this separate patch
v1: n/a
  Part of https://lore.kernel.org/netdev/20230516210127.35841-1-forst@pen.gy/
---
 drivers/net/usb/ipheth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index 6a769df0b..8875a3d0e 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -510,8 +510,8 @@ static int ipheth_probe(struct usb_interface *intf,
 	ipheth_free_urbs(dev);
 err_alloc_urbs:
 err_get_macaddr:
-err_alloc_ctrl_buf:
 	kfree(dev->ctrl_buf);
+err_alloc_ctrl_buf:
 err_endpoints:
 	free_netdev(netdev);
 	return retval;
-- 
2.40.1


