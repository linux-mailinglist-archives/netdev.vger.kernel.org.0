Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A224C4BB80
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 16:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbfFSOav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 10:30:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56887 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbfFSOav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 10:30:51 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hdbbp-0005sO-5S; Wed, 19 Jun 2019 14:30:45 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][net-next] iavf: fix dereference of null rx_buffer pointer
Date:   Wed, 19 Jun 2019 15:30:44 +0100
Message-Id: <20190619143044.10259-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

A recent commit efa14c3985828d ("iavf: allow null RX descriptors") added
a null pointer sanity check on rx_buffer, however, rx_buffer is being
dereferenced before that check, which implies a null pointer dereference
bug can potentially occur.  Fix this by only dereferencing rx_buffer
until after the null pointer check.

Addresses-Coverity: ("Dereference before null check")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/intel/iavf/iavf_txrx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
index 1cde1601bc32..0cca1b589b56 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -1296,7 +1296,7 @@ static struct sk_buff *iavf_construct_skb(struct iavf_ring *rx_ring,
 					  struct iavf_rx_buffer *rx_buffer,
 					  unsigned int size)
 {
-	void *va = page_address(rx_buffer->page) + rx_buffer->page_offset;
+	void *va;
 #if (PAGE_SIZE < 8192)
 	unsigned int truesize = iavf_rx_pg_size(rx_ring) / 2;
 #else
@@ -1308,6 +1308,7 @@ static struct sk_buff *iavf_construct_skb(struct iavf_ring *rx_ring,
 	if (!rx_buffer)
 		return NULL;
 	/* prefetch first cache line of first page */
+	va = page_address(rx_buffer->page) + rx_buffer->page_offset;
 	prefetch(va);
 #if L1_CACHE_BYTES < 128
 	prefetch(va + L1_CACHE_BYTES);
@@ -1362,7 +1363,7 @@ static struct sk_buff *iavf_build_skb(struct iavf_ring *rx_ring,
 				      struct iavf_rx_buffer *rx_buffer,
 				      unsigned int size)
 {
-	void *va = page_address(rx_buffer->page) + rx_buffer->page_offset;
+	void *va;
 #if (PAGE_SIZE < 8192)
 	unsigned int truesize = iavf_rx_pg_size(rx_ring) / 2;
 #else
@@ -1374,6 +1375,7 @@ static struct sk_buff *iavf_build_skb(struct iavf_ring *rx_ring,
 	if (!rx_buffer)
 		return NULL;
 	/* prefetch first cache line of first page */
+	va = page_address(rx_buffer->page) + rx_buffer->page_offset;
 	prefetch(va);
 #if L1_CACHE_BYTES < 128
 	prefetch(va + L1_CACHE_BYTES);
-- 
2.20.1

