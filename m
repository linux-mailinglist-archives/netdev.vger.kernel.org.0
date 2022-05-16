Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A69B527BC1
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 04:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238861AbiEPCLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 22:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbiEPCLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 22:11:22 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net (zg8tmty1ljiyny4xntqumjca.icoremail.net [165.227.154.27])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id AC66B2019A;
        Sun, 15 May 2022 19:11:19 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [106.117.76.98])
        by mail-app4 (Coremail) with SMTP id cS_KCgB3yOCVsoFi_ldFAA--.5610S2;
        Mon, 16 May 2022 10:10:40 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-kernel@vger.kernel.org, krzysztof.kozlowski@linaro.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, gregkh@linuxfoundation.org,
        alexander.deucher@amd.com, broonie@kernel.org,
        netdev@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH net] NFC: hci: fix sleep in atomic context bugs in nfc_hci_hcp_message_tx
Date:   Mon, 16 May 2022 10:10:28 +0800
Message-Id: <20220516021028.54063-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cS_KCgB3yOCVsoFi_ldFAA--.5610S2
X-Coremail-Antispam: 1UD129KBjvJXoW7uFykCry7Cr15CF1UAr1xuFg_yoW8WryrpF
        Wv9a4UZFWrJry8WFWvkw4Iqw1F93WkGFy7G39ruw4rZ39Iqr1xtFn5Ja4jvFZ5ArZ7Aay2
        vFyjkr17WFy7A37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26rxl
        6s0DM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
        jxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
        1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxa
        n2IY04v7MxkIecxEwVAFwVW8JwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJV
        W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
        1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6x
        IIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvE
        x4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvj
        DU0xZFpf9x0JUCg4hUUUUU=
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgkIAVZdtZqDiwBLsl
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are sleep in atomic context bugs when the request to secure
element of st21nfca is timeout. The root cause is that kzalloc and
alloc_skb with GFP_KERNEL parameter is called in st21nfca_se_wt_timeout
which is a timer handler. The call tree shows the execution paths that
could lead to bugs:

   (Interrupt context)
st21nfca_se_wt_timeout
  nfc_hci_send_event
    nfc_hci_hcp_message_tx
      kzalloc(..., GFP_KERNEL) //may sleep
      alloc_skb(..., GFP_KERNEL) //may sleep

This patch changes allocation mode of kzalloc and alloc_skb from
GFP_KERNEL to GFP_ATOMIC in order to prevent atomic context from
sleeping. The GFP_ATOMIC flag makes memory allocation operation
could be used in atomic context.

Fixes: 8b8d2e08bf0d ("NFC: HCI support")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
 net/nfc/hci/hcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/nfc/hci/hcp.c b/net/nfc/hci/hcp.c
index 05c60988f59..1caf9c2086f 100644
--- a/net/nfc/hci/hcp.c
+++ b/net/nfc/hci/hcp.c
@@ -30,7 +30,7 @@ int nfc_hci_hcp_message_tx(struct nfc_hci_dev *hdev, u8 pipe,
 	int hci_len, err;
 	bool firstfrag = true;
 
-	cmd = kzalloc(sizeof(struct hci_msg), GFP_KERNEL);
+	cmd = kzalloc(sizeof(*cmd), GFP_ATOMIC);
 	if (cmd == NULL)
 		return -ENOMEM;
 
@@ -58,7 +58,7 @@ int nfc_hci_hcp_message_tx(struct nfc_hci_dev *hdev, u8 pipe,
 			  data_link_len + ndev->tx_tailroom;
 		hci_len -= data_link_len;
 
-		skb = alloc_skb(skb_len, GFP_KERNEL);
+		skb = alloc_skb(skb_len, GFP_ATOMIC);
 		if (skb == NULL) {
 			err = -ENOMEM;
 			goto out_skb_err;
-- 
2.17.1

