Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFE9C3C95
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732890AbfJAQnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:43:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732863AbfJAQni (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 12:43:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD5E021855;
        Tue,  1 Oct 2019 16:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948217;
        bh=kikUCnJut+ZJ+Fh3iu2tozOkTyYfBY24xOIf7MXwbj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k85kCA4rK+yPMPP+Vw20ALA3mNV1+0rx6x05DBnKFsGMEJldG/Rk5kOhsmjA+6uJ3
         1PLdSi0ecPaNoXDMl3gzidaRyn55fUnsVwpPA3QT9b0dQia9MD45lPHe0KBwtBA/jm
         3W/p+QxokqB09vUEoX98sSESRrEpQkCNZMJ72sLE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 19/43] usbnet: ignore endpoints with invalid wMaxPacketSize
Date:   Tue,  1 Oct 2019 12:42:47 -0400
Message-Id: <20191001164311.15993-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001164311.15993-1-sashal@kernel.org>
References: <20191001164311.15993-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>

[ Upstream commit 8d3d7c2029c1b360f1a6b0a2fca470b57eb575c0 ]

Endpoints with zero wMaxPacketSize are not usable for transferring
data. Ignore such endpoints when looking for valid in, out and
status pipes, to make the drivers more robust against invalid and
meaningless descriptors.

The wMaxPacketSize of these endpoints are used for memory allocations
and as divisors in many usbnet minidrivers. Avoiding zero is therefore
critical.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/usbnet.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 10854977c55f1..52ffb2360cc90 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -112,6 +112,11 @@ int usbnet_get_endpoints(struct usbnet *dev, struct usb_interface *intf)
 			int				intr = 0;
 
 			e = alt->endpoint + ep;
+
+			/* ignore endpoints which cannot transfer data */
+			if (!usb_endpoint_maxp(&e->desc))
+				continue;
+
 			switch (e->desc.bmAttributes) {
 			case USB_ENDPOINT_XFER_INT:
 				if (!usb_endpoint_dir_in(&e->desc))
-- 
2.20.1

