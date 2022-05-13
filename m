Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE3CA526346
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 15:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiEMNt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 09:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381309AbiEMNe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 09:34:58 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net (zg8tmty1ljiyny4xntqumjca.icoremail.net [165.227.154.27])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 0A0DC10F0;
        Fri, 13 May 2022 06:34:54 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [218.12.19.27])
        by mail-app2 (Coremail) with SMTP id by_KCgD3nEFEXn5ixqcfAA--.44066S2;
        Fri, 13 May 2022 21:34:15 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     netdev@vger.kernel.org, krzysztof.kozlowski@linaro.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        gregkh@linuxfoundation.org, alexander.deucher@amd.com,
        broonie@kernel.org, Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH net] NFC: nci: fix sleep in atomic context bugs caused by nci_skb_alloc
Date:   Fri, 13 May 2022 21:33:55 +0800
Message-Id: <20220513133355.113222-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: by_KCgD3nEFEXn5ixqcfAA--.44066S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tr1xWrW5XF1xKr45tw1UZFb_yoW8tr43pF
        WSgFWDZF48Jr1UXFWvvw4vqw4YywnYg3yDKa9ruws5J3sYqrn5ta10yFyYvFZ3ZrWkAF4a
        qr4Y9r17uFnrt3JanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvj14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
        Y2ka0xkIwI1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
        xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
        MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
        0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
        JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUoO
        J5UUUUU
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgkIAVZdtZqDiwAgsO
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,
        RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are sleep in atomic context bugs when the request to secure
element of st-nci is timeout. The root cause is that nci_skb_alloc
with GFP_KERNEL parameter is called in st_nci_se_wt_timeout which is
a timer handler. The call paths that could trigger bugs are shown below:

    (interrupt context 1)
st_nci_se_wt_timeout
  nci_hci_send_event
    nci_hci_send_data
      nci_skb_alloc(..., GFP_KERNEL) //may sleep

   (interrupt context 2)
st_nci_se_wt_timeout
  nci_hci_send_event
    nci_hci_send_data
      nci_send_data
        nci_queue_tx_data_frags
          nci_skb_alloc(..., GFP_KERNEL) //may sleep

This patch changes allocation mode of nci_skb_alloc from GFP_KERNEL to
GFP_ATOMIC in order to prevent atomic context sleeping. The GFP_ATOMIC
flag makes memory allocation operation could be used in atomic context.

Fixes: 6a2968aaf50c ("NFC: basic NCI protocol implementation ")
Fixes: 11f54f228643 ("NFC: nci: Add HCI over NCI protocol support")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
 net/nfc/nci/data.c | 2 +-
 net/nfc/nci/hci.c  | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/nfc/nci/data.c b/net/nfc/nci/data.c
index 6055dc9a82a..aa5e712adf0 100644
--- a/net/nfc/nci/data.c
+++ b/net/nfc/nci/data.c
@@ -118,7 +118,7 @@ static int nci_queue_tx_data_frags(struct nci_dev *ndev,
 
 		skb_frag = nci_skb_alloc(ndev,
 					 (NCI_DATA_HDR_SIZE + frag_len),
-					 GFP_KERNEL);
+					 GFP_ATOMIC);
 		if (skb_frag == NULL) {
 			rc = -ENOMEM;
 			goto free_exit;
diff --git a/net/nfc/nci/hci.c b/net/nfc/nci/hci.c
index 19703a649b5..78c4b6addf1 100644
--- a/net/nfc/nci/hci.c
+++ b/net/nfc/nci/hci.c
@@ -153,7 +153,7 @@ static int nci_hci_send_data(struct nci_dev *ndev, u8 pipe,
 
 	i = 0;
 	skb = nci_skb_alloc(ndev, conn_info->max_pkt_payload_len +
-			    NCI_DATA_HDR_SIZE, GFP_KERNEL);
+			    NCI_DATA_HDR_SIZE, GFP_ATOMIC);
 	if (!skb)
 		return -ENOMEM;
 
@@ -184,7 +184,7 @@ static int nci_hci_send_data(struct nci_dev *ndev, u8 pipe,
 		if (i < data_len) {
 			skb = nci_skb_alloc(ndev,
 					    conn_info->max_pkt_payload_len +
-					    NCI_DATA_HDR_SIZE, GFP_KERNEL);
+					    NCI_DATA_HDR_SIZE, GFP_ATOMIC);
 			if (!skb)
 				return -ENOMEM;
 
-- 
2.17.1

