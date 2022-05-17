Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADFFD5296B0
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 03:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236069AbiEQB00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 21:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbiEQBZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 21:25:54 -0400
Received: from azure-sdnproxy-2.icoremail.net (azure-sdnproxy.icoremail.net [52.175.55.52])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id A843664DE;
        Mon, 16 May 2022 18:25:49 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [124.236.130.193])
        by mail-app3 (Coremail) with SMTP id cC_KCgB37k2L+YJikKJdAA--.2429S2;
        Tue, 17 May 2022 09:25:40 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-kernel@vger.kernel.org, kuba@kernel.org
Cc:     krzysztof.kozlowski@linaro.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, gregkh@linuxfoundation.org,
        alexander.deucher@amd.com, broonie@kernel.org,
        netdev@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH net v2] NFC: nci: fix sleep in atomic context bugs caused by nci_skb_alloc
Date:   Tue, 17 May 2022 09:25:30 +0800
Message-Id: <20220517012530.75714-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cC_KCgB37k2L+YJikKJdAA--.2429S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tr1xWrW5XF1xKr45tw1UZFb_yoW8try7pF
        WSgFyDZF48Jr1UXFWvvw4ktw4YywnYg34qka9ruw4rJ3sYqrn5tw40yFyYvFWfZrZ7JF42
        qF4Ykr129FnrJ3JanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4U
        JVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
        n2kIc2xKxwCY02Avz4vE14v_KwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJV
        W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
        1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6x
        IIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvE
        x4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvj
        DU0xZFpf9x0JUHpB-UUUUU=
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAg0NAVZdtZtoKQAAsn
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
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

Fixes: ed06aeefdac3 ("nfc: st-nci: Rename st21nfcb to st-nci")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
Changes in v2:
  - Change the Fixes tag to commit st_nci_se_wt_timeout was added.

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

