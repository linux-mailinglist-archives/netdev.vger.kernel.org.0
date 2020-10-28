Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1047829DBB4
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390740AbgJ2ANE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:13:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50720 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390157AbgJ2ANE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 20:13:04 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXZlq-003u4H-RF; Wed, 28 Oct 2020 01:56:58 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next] net: nfc: Fix kerneldoc warnings
Date:   Wed, 28 Oct 2020 01:56:53 +0100
Message-Id: <20201028005653.930467-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net//nfc/core.c:1046: warning: Function parameter or member 'tx_headroom' not described in 'nfc_allocate_device'
net//nfc/core.c:1046: warning: Function parameter or member 'tx_tailroom' not described in 'nfc_allocate_device'
net//nfc/core.c:198: warning: Excess function parameter 'protocols' description in 'nfc_start_poll'
net//nfc/core.c:198: warning: Function parameter or member 'im_protocols' not described in 'nfc_start_poll'
net//nfc/core.c:198: warning: Function parameter or member 'tm_protocols' not described in 'nfc_start_poll'
net//nfc/core.c:441: warning: Function parameter or member 'mode' not described in 'nfc_deactivate_target'
net//nfc/core.c:711: warning: Function parameter or member 'dev' not described in 'nfc_alloc_send_skb'
net//nfc/core.c:711: warning: Function parameter or member 'err' not described in 'nfc_alloc_send_skb'
net//nfc/core.c:711: warning: Function parameter or member 'flags' not described in 'nfc_alloc_send_skb'
net//nfc/core.c:711: warning: Function parameter or member 'sk' not described in 'nfc_alloc_send_skb'
net//nfc/digital_core.c:470: warning: Function parameter or member 'im_protocols' not described in 'digital_start_poll'
net//nfc/digital_core.c:470: warning: Function parameter or member 'nfc_dev' not described in 'digital_start_poll'
net//nfc/digital_core.c:470: warning: Function parameter or member 'tm_protocols' not described in 'digital_start_poll'
net//nfc/nci/core.c:1119: warning: Function parameter or member 'tx_headroom' not described in 'nci_allocate_device'
net//nfc/nci/core.c:1119: warning: Function parameter or member 'tx_tailroom' not described in 'nci_allocate_device'

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/nfc/core.c         | 10 +++++++++-
 net/nfc/digital_core.c |  3 +++
 net/nfc/nci/core.c     |  2 ++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/nfc/core.c b/net/nfc/core.c
index eb377f87bcae..ffbd5850c5b0 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -189,7 +189,8 @@ static const struct rfkill_ops nfc_rfkill_ops = {
  * nfc_start_poll - start polling for nfc targets
  *
  * @dev: The nfc device that must start polling
- * @protocols: bitset of nfc protocols that must be used for polling
+ * @im_protocols: bitset of nfc initiator protocols to be used for polling
+ * @tm_protocols: bitset of nfc transport protocols to be used for polling
  *
  * The device remains polling for targets until a target is found or
  * the nfc_stop_poll function is called.
@@ -436,6 +437,7 @@ int nfc_activate_target(struct nfc_dev *dev, u32 target_idx, u32 protocol)
  *
  * @dev: The nfc device that found the target
  * @target_idx: index of the target that must be deactivated
+ * @mode: Idle or sleep?
  */
 int nfc_deactivate_target(struct nfc_dev *dev, u32 target_idx, u8 mode)
 {
@@ -703,7 +705,11 @@ EXPORT_SYMBOL(nfc_tm_deactivated);
 /**
  * nfc_alloc_send_skb - allocate a skb for data exchange responses
  *
+ * @dev: device sending the response
+ * @sk: socket sending the response
+ * @flags: MSG_DONTWIAT flag
  * @size: size to allocate
+ * @err: pointer to memory to store the error code
  */
 struct sk_buff *nfc_alloc_send_skb(struct nfc_dev *dev, struct sock *sk,
 				   unsigned int flags, unsigned int size,
@@ -1039,6 +1045,8 @@ struct nfc_dev *nfc_get_device(unsigned int idx)
  *
  * @ops: device operations
  * @supported_protocols: NFC protocols supported by the device
+ * @tx_headroom: Reserved space at beginning of skb
+ * @tx_tailroom: Reserved space at end of skb
  */
 struct nfc_dev *nfc_allocate_device(struct nfc_ops *ops,
 				    u32 supported_protocols,
diff --git a/net/nfc/digital_core.c b/net/nfc/digital_core.c
index e3599ed4a7a8..da7e2112771f 100644
--- a/net/nfc/digital_core.c
+++ b/net/nfc/digital_core.c
@@ -458,6 +458,9 @@ static void digital_add_poll_tech(struct nfc_digital_dev *ddev, u8 rf_tech,
 
 /**
  * start_poll operation
+ * @nfc_dev: device to be polled
+ * @im_protocols: bitset of nfc initiator protocols to be used for polling
+ * @tm_protocols: bitset of nfc transport protocols to be used for polling
  *
  * For every supported protocol, the corresponding polling function is added
  * to the table of polling technologies (ddev->poll_techs[]) using
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 741da8f81c2b..4953ee5146e1 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -1112,6 +1112,8 @@ static struct nfc_ops nci_nfc_ops = {
  *
  * @ops: device operations
  * @supported_protocols: NFC protocols supported by the device
+ * @tx_headroom: Reserved space at beginning of skb
+ * @tx_tailroom: Reserved space at end of skb
  */
 struct nci_dev *nci_allocate_device(struct nci_ops *ops,
 				    __u32 supported_protocols,
-- 
2.28.0

