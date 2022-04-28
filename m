Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57C9D513469
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 15:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346754AbiD1NIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 09:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345704AbiD1NIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 09:08:11 -0400
Received: from smtpproxy21.qq.com (smtpbg701.qq.com [203.205.195.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C1584ED1
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 06:04:52 -0700 (PDT)
X-QQ-mid: bizesmtp67t1651151084t0ubflmf
Received: from localhost.localdomain ( [58.240.82.166])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 28 Apr 2022 21:04:38 +0800 (CST)
X-QQ-SSF: 01400000002000E0M000000A0000000
X-QQ-FEAT: ZHWZeLXy+8e6BJiTYangnhOr5IcHo9PDpnvWd/LzUXHVBYP5Ns70+NJtTUtxx
        L01MpdLZwTtCieUxlV8UIGqzjZfGRszS7pO8xh6GIBpyVBzL7HR/q1gSfEyLMHiTUWPYb6e
        LzytBKJhBvGYQDlAvnb1PJcM5l9U8f7C0jrWpYitUp8ANcew4BSSrFywwKiT8/7SKMXi1aM
        NvRixxfd88NJhhjN7sGdtrFCaq0BBxCC0b2dfsA71mGdGzxE3SGnt77lmuNQNcengdztGt8
        pl0GwkrVhYcJv2ejnebUG5rudHVO0oD6yKydmspMLdzTUNVpJDPPuL71y0ye/og60cAbfKf
        RFIcLQgPtwtvRxgh9eAC9xLtEg8iLQE6STJYzpRxlRiyRIs8+0=
X-QQ-GoodBg: 1
From:   Meng Tang <tangmeng@uniontech.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Meng Tang <tangmeng@uniontech.com>
Subject: [PATCH] Bluetooth: Add bluetooth error information for error codes
Date:   Thu, 28 Apr 2022 21:04:35 +0800
Message-Id: <20220428130435.896-1-tangmeng@uniontech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybgforeign:qybgforeign10
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bluetooth error codes to Unix errno mapping is not completed. For
example, the following Bluetooth error codes are directly classified
as ENOSYS.

  /* Possible error codes */
  #define HCI_SCO_INTERVAL_REJECTED     0x1C
  #define HCI_SCO_AIR_MODE_REJECTED     0x1D
  #define HCI_UNSPECIFIED_ERROR         0x1F
  #define HCI_ROLE_CHANGE_NOT_ALLOWED   0x21
  #define HCI_LMP_RESPONSE_TIMEOUT      0x22
  #define HCI_UNIT_KEY_USED             0x26
  #define HCI_INSTANT_PASSED            0x28

As a result, when these error codes occur in Bluetooth, ENOSYS is
always returned, and users cannot know the specific error codes of
Bluetooth, thus affecting the positioning of Bluetooth problems.

This will make it difficult to locate and analyze Bluetooth issues.
Therefore, I added information for bluetooth error codes that are
not currently mapped to help users get bluetooth error codes.

Signed-off-by: Meng Tang <tangmeng@uniontech.com>
---
 net/bluetooth/lib.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/net/bluetooth/lib.c b/net/bluetooth/lib.c
index 5326f41a58b7..eaf952de0ef9 100644
--- a/net/bluetooth/lib.c
+++ b/net/bluetooth/lib.c
@@ -122,6 +122,14 @@ int bt_to_errno(__u16 code)
 	case 0x1b:
 		return ECONNREFUSED;
 
+	case 0x1c:
+		printk(KERN_ERR "Bluetooth: errno(0x%02x), SCO Interval Rejected", code);
+		return ENOSYS;
+
+	case 0x1d:
+		printk(KERN_ERR "Bluetooth: errno(0x%02x), SCO Air Mode Rejected", code);
+		return ENOSYS;
+
 	case 0x19:
 	case 0x1e:
 	case 0x23:
@@ -129,7 +137,28 @@ int bt_to_errno(__u16 code)
 	case 0x25:
 		return EPROTO;
 
+	case 0x1f:
+		printk(KERN_ERR "Bluetooth: errno(0x%02x), Unspecified Error", code);
+		return ENOSYS;
+
+	case 0x21:
+		printk(KERN_ERR "Bluetooth: errno(0x%02x), Role Change Not Allowed", code);
+		return ENOSYS;
+
+	case 0x22:
+		printk(KERN_ERR "Bluetooth: errno(0x%02x), LMP Response Timeout", code);
+		return ENOSYS;
+
+	case 0x26:
+		printk(KERN_ERR "Bluetooth: errno(0x%02x), Unit Key Used", code);
+		return ENOSYS;
+
+	case 0x28:
+		printk(KERN_ERR "Bluetooth: errno(0x%02x), Instant Passed", code);
+		return ENOSYS;
+
 	default:
+		printk(KERN_ERR "Bluetooth: errno(0x%02x), Error code unknown", code);
 		return ENOSYS;
 	}
 }
-- 
2.20.1



