Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B498A4D5CF0
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 09:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347338AbiCKIDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 03:03:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237155AbiCKID0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 03:03:26 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880231B84FA;
        Fri, 11 Mar 2022 00:02:23 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id e6so6863500pgn.2;
        Fri, 11 Mar 2022 00:02:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FQQzdTx4AXRc0UqtDWCC5ACivflzrCQnePi6OUu3CnY=;
        b=oXuBGb1ekwEcPik1Skv2Fud4W+/BLF+UgdNx8W3TV0XH00cT/oJnY2jDp4Xo38CwZE
         RxW1FtQYYKqOr9IXiaEDFEkz6w55QEvrSf27A7ug65Gxn7m7850A+cigFBtZkBg/0vin
         KdJW71wQbmknr/t5zatXElITjF/xbj+qIwlz+lQhfjQqt9aM2+PlQa2kq0kwwIKEsJSF
         q2DlzXLdvl7B0VB5rt4UtdCRwsZJvQATmJCXexMG8QNCFuREixR+9jeFYd4Ca86G9iPZ
         jmYEDFC+1j1F6SexGZinW9BVlV5H60GtrEG9wKxz3a1ubHO9NvCnfezcpjK3LbnesmUV
         UjWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FQQzdTx4AXRc0UqtDWCC5ACivflzrCQnePi6OUu3CnY=;
        b=4BkqjcrHxcOo3nvpPRZFr9O36zxHQjI0IFXaSto8K8lU70uJdDlmf9BdppBiWX2r5I
         HLg60r7IAo4NNl85iMHOvB3EVTVDcHB8TQSFiF7g6jW6OGTnFdJ8JtMpZN8IxDtwg96o
         Agxo7CG3ynv+d3WjxKXjIbCRFbzovNaMqOxB9mKuBTbEVGWc4a4iBxEF23SpCacSJS1o
         NJqxncqdfLEqSe3YCIg5hv6umBBOZM+YesA3XZDyf91cKfk2dkZv4SqV2wmsUZjhIcgH
         Ne7PXHDgn7cBnQNBmUFpGuAuF1WyHMcYrZymQgEMBMtTBROIsX83yfJ6WY4qSaxckHsw
         tPQg==
X-Gm-Message-State: AOAM532TCobGjAbBIA9d3vKBxKWenkDSAw0/ozbjJCQ0nV2FrbMDSYkR
        7m2Aq91nDv/1ZA7yS9aVtcw=
X-Google-Smtp-Source: ABdhPJxpdkaTnc5mX0kbOkSmB598KHBiETpwSD98+GxI2nb8FzlGSPxE1F+GVG/dsKobhveVBZmwvg==
X-Received: by 2002:a63:90c7:0:b0:37c:7a8c:c2d3 with SMTP id a190-20020a6390c7000000b0037c7a8cc2d3mr7476395pge.473.1646985743045;
        Fri, 11 Mar 2022 00:02:23 -0800 (PST)
Received: from slim.das-security.cn ([103.84.139.54])
        by smtp.gmail.com with ESMTPSA id b2-20020a056a000a8200b004f1111c66afsm10660741pfl.148.2022.03.11.00.02.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 00:02:22 -0800 (PST)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     yashi@spacecubics.com, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, kuba@kernel.org, mailhol.vincent@wanadoo.fr,
        stefan.maetje@esd.eu, paskripkin@gmail.com,
        remigiusz.kollataj@mobica.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH] can: mcba_usb: fix possible double dev_kfree_skb in mcba_usb_start_xmit
Date:   Fri, 11 Mar 2022 16:02:08 +0800
Message-Id: <20220311080208.45047-1-hbh25y@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need to call dev_kfree_skb when usb_submit_urb fails beacause
can_put_echo_skb deletes original skb and can_free_echo_skb deletes the cloned
skb.

Fixes: 51f3baad7de9 ("can: mcba_usb: Add support for Microchip CAN BUS Analyzer")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---
 drivers/net/can/usb/mcba_usb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index 77bddff86252..7c198eb5bc9c 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -364,7 +364,6 @@ static netdev_tx_t mcba_usb_start_xmit(struct sk_buff *skb,
 xmit_failed:
 	can_free_echo_skb(priv->netdev, ctx->ndx, NULL);
 	mcba_usb_free_ctx(ctx);
-	dev_kfree_skb(skb);
 	stats->tx_dropped++;
 
 	return NETDEV_TX_OK;
-- 
2.25.1

