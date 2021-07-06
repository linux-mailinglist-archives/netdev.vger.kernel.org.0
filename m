Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A806B3BD149
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235865AbhGFLi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:38:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236950AbhGFLfs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBBFA61C47;
        Tue,  6 Jul 2021 11:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570690;
        bh=j7iSZBJwnTLRtWg2AvHVb299IpnfQTPkBQMjzpSfV5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=supC/HVUAQ4pdpzVnr7s6tc2jbpuuJISALAJk0npnBnXIXajBiCYKrAQY1BsOWr5v
         X7nZv2qKCT+EAX/a1YAAQrN7KVTrtRX1PoxpZWmJTVcaEi8Sw/q7wqW1HQwtjmiuyU
         lVTics+Z8rOukFuvNulsry3kMpdnsDJ4ZI4QonEiCTw3TvUPV38kZpUw1ZVuHQmMm+
         tZpg37QU8GOJgvGuLUIAjNAMzcYsq5xas7IDIRvFK3EMeNeFArn0oL0aqOsNCRVgVE
         h930310bIctDocZ3xfxk/NW4d8bqpXMzGZij7yPYYd3NUX6jwZm1H0npzhG5qbvDwN
         wTQ03iqfdt0Jg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tedd Ho-Jeong An <tedd.an@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 129/137] Bluetooth: mgmt: Fix the command returns garbage parameter value
Date:   Tue,  6 Jul 2021 07:21:55 -0400
Message-Id: <20210706112203.2062605-129-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tedd Ho-Jeong An <tedd.an@intel.com>

[ Upstream commit 02ce2c2c24024aade65a8d91d6a596651eaf2d0a ]

When the Get Device Flags command fails, it returns the error status
with the parameters filled with the garbage values. Although the
parameters are not used, it is better to fill with zero than the random
values.

Signed-off-by: Tedd Ho-Jeong An <tedd.an@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index b20944e6d274..8c55254558b8 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4038,6 +4038,8 @@ static int get_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 
 	hci_dev_lock(hdev);
 
+	memset(&rp, 0, sizeof(rp));
+
 	if (cp->addr.type == BDADDR_BREDR) {
 		br_params = hci_bdaddr_list_lookup_with_flags(&hdev->whitelist,
 							      &cp->addr.bdaddr,
-- 
2.30.2

