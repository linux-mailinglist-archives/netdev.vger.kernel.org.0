Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFB5F39FF7D
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 20:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234614AbhFHSdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 14:33:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:57560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234124AbhFHSce (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 14:32:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D70DC613CD;
        Tue,  8 Jun 2021 18:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177025;
        bh=jl8Z6ZgrA67B1nrcFs3fiCeBUftXiBdarqG5ygOvl9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pI/22bxZRt7qPlSGGd3+J+ZP0NDcqMYF7cx3B+0VLCqEvuNhSWkzY9LJBH43MmMwf
         Ydr5Rt2Fg0aLOfKqblgMektOf3KynEv8j7my2dCN1KLo70xWVTZBnCBNBitQ73RLQB
         T1p3GLb9GYca3pNF3dudTxtoBZMwfJ7HnhBVRD9Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        Lin Ma <linma@zju.edu.cn>, Hao Xiong <mart1n@zju.edu.cn>
Subject: [PATCH 4.9 13/29] Bluetooth: fix the erroneous flush_work() order
Date:   Tue,  8 Jun 2021 20:27:07 +0200
Message-Id: <20210608175928.248830114@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175927.821075974@linuxfoundation.org>
References: <20210608175927.821075974@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lin Ma <linma@zju.edu.cn>

commit 6a137caec23aeb9e036cdfd8a46dd8a366460e5d upstream.

In the cleanup routine for failed initialization of HCI device,
the flush_work(&hdev->rx_work) need to be finished before the
flush_work(&hdev->cmd_work). Otherwise, the hci_rx_work() can
possibly invoke new cmd_work and cause a bug, like double free,
in late processings.

This was assigned CVE-2021-3564.

This patch reorder the flush_work() to fix this bug.

Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-bluetooth@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Signed-off-by: Hao Xiong <mart1n@zju.edu.cn>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1422,8 +1422,13 @@ static int hci_dev_do_open(struct hci_de
 	} else {
 		/* Init failed, cleanup */
 		flush_work(&hdev->tx_work);
-		flush_work(&hdev->cmd_work);
+
+		/* Since hci_rx_work() is possible to awake new cmd_work
+		 * it should be flushed first to avoid unexpected call of
+		 * hci_cmd_work()
+		 */
 		flush_work(&hdev->rx_work);
+		flush_work(&hdev->cmd_work);
 
 		skb_queue_purge(&hdev->cmd_q);
 		skb_queue_purge(&hdev->rx_q);


