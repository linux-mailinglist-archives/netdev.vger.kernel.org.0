Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01FF14E52ED
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 14:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236524AbiCWNWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 09:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiCWNWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 09:22:20 -0400
X-Greylist: delayed 915 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 23 Mar 2022 06:20:49 PDT
Received: from m12-16.163.com (m12-16.163.com [220.181.12.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F9193ED0B;
        Wed, 23 Mar 2022 06:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Message-ID:Date:MIME-Version:From:Subject; bh=pFqhD
        y+bFmU8EibEcm8G1vIRqrIaJlJsyZBN0TaFU7g=; b=nws+qvjM0Vpe13/F2w2RX
        XtCgLFAkOC0rbkvn1FNlP/K2kkwo57CUoUGNfoAHYrDhO+QSB4BodDqzi16zLiy7
        Zr8fjONhwyJ1Zr2wRLHOX/lQqL/OOoTqdIgIyfBTqq+0ikUc18b9/SD6103rvJWD
        TrtAnwcdoVc0BQQFxM8O+E=
Received: from [10.8.162.29] (unknown [36.111.140.141])
        by smtp12 (Coremail) with SMTP id EMCowAD3xBECGztipTSUAg--.60843S2;
        Wed, 23 Mar 2022 21:05:07 +0800 (CST)
Message-ID: <0f6d4f89-c08d-b985-075e-a763fec87fc4@163.com>
Date:   Wed, 23 Mar 2022 21:05:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To:     menglong8.dong@gmail.com, dsahern@kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        edumazet@google.com
From:   Jianguo Wu <wujianguo106@163.com>
Subject: [PATCH net-next] tcp: consume packet after do time wait process
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: EMCowAD3xBECGztipTSUAg--.60843S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrurW7uF4DCF15Zr43KFWUXFb_yoWxuFgEka
        4kKF48K34xXrn3Zr47Cr45JF9xK34IkF1rWrsIka4fAas8GFs7uFZ5tFy7Cr97Wa17KF98
        Zrs8J3s0vr1fXjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU0qii3UUUUU==
X-Originating-IP: [36.111.140.141]
X-CM-SenderInfo: 5zxmxt5qjx0iiqw6il2tof0z/1tbiNwPMkFWBm67zmwAAsh
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianguo Wu <wujianguo@chinatelecom.cn>

Using consume_skb() instead of kfree_skb_reason() after do normally
time wait process to be drop monitor friendly.

Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
---
 net/ipv4/tcp_ipv4.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index f9cec62..957d86c 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2154,7 +2154,9 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		goto discard_it;
 	case TCP_TW_SUCCESS:;
 	}
-	goto discard_it;
+
+	consume_skb(skb);
+	return 0;
 }

 static struct timewait_sock_ops tcp_timewait_sock_ops = {
-- 
1.8.3.1

