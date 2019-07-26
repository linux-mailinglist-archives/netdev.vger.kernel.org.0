Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9C5D76A51
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 15:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbfGZNkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 09:40:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387601AbfGZNku (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 09:40:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84F272238C;
        Fri, 26 Jul 2019 13:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148449;
        bh=YBzj4fQ+SdNXzgQNLcvqMQX9tA99KBH39x2aobuK4sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CNKpWfFkf7hPGHHjhRcwGnAZBlwNxDn30cuN9uj2UMmLtyumAolwN2UrFHkH4iqpn
         9A82c1oQNX3t4e8L0h0xG2ZahB/HUmqkQb58wpUeX3ZhhL1Iv2W3JmBOtObFNzkInJ
         PmO6p9MJuXuenVdBzQ1rW1oRxNMT+l0eBvJ8/wDc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Phong Tran <tranmanphong@gmail.com>,
        syzbot+8750abbc3a46ef47d509@syzkaller.appspotmail.com,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 45/85] ISDN: hfcsusb: checking idx of ep configuration
Date:   Fri, 26 Jul 2019 09:38:55 -0400
Message-Id: <20190726133936.11177-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Phong Tran <tranmanphong@gmail.com>

[ Upstream commit f384e62a82ba5d85408405fdd6aeff89354deaa9 ]

The syzbot test with random endpoint address which made the idx is
overflow in the table of endpoint configuations.

this adds the checking for fixing the error report from
syzbot

KASAN: stack-out-of-bounds Read in hfcsusb_probe [1]
The patch tested by syzbot [2]

Reported-by: syzbot+8750abbc3a46ef47d509@syzkaller.appspotmail.com

[1]:
https://syzkaller.appspot.com/bug?id=30a04378dac680c5d521304a00a86156bb913522
[2]:
https://groups.google.com/d/msg/syzkaller-bugs/_6HBdge8F3E/OJn7wVNpBAAJ

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/hardware/mISDN/hfcsusb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/isdn/hardware/mISDN/hfcsusb.c b/drivers/isdn/hardware/mISDN/hfcsusb.c
index 4c99739b937e..0e224232f746 100644
--- a/drivers/isdn/hardware/mISDN/hfcsusb.c
+++ b/drivers/isdn/hardware/mISDN/hfcsusb.c
@@ -1955,6 +1955,9 @@ hfcsusb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 
 				/* get endpoint base */
 				idx = ((ep_addr & 0x7f) - 1) * 2;
+				if (idx > 15)
+					return -EIO;
+
 				if (ep_addr & 0x80)
 					idx++;
 				attr = ep->desc.bmAttributes;
-- 
2.20.1

