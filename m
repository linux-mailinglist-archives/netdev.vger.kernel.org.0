Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9AC435F05
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 12:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbhJUKa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 06:30:26 -0400
Received: from m12-13.163.com ([220.181.12.13]:54171 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230077AbhJUKaZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 06:30:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Message-ID:Date:MIME-Version; bh=E/zyX
        jWnvryD8n+yDTFG12C9dF9Gd7XSTPPLpGAB9LQ=; b=gURZ1PMUYD9N8QFdniuuL
        8zh5rQ3hdKGZe2KUF796dyXQSpXUDMdo/xYIbD9WMg6rOnuUvxPEAYDcR8cl2LjK
        NMfoZw+TNJUzylPU3C2p8xl8rVFypvhY2HFlHn1108c6K3apvMjnFuXOcdxRluaO
        W8PUipIequsNQMRi6/Wdzs=
Received: from [192.168.16.199] (unknown [110.80.1.46])
        by smtp9 (Coremail) with SMTP id DcCowACXn6OSQHFhtsJiKQ--.14959S2;
        Thu, 21 Oct 2021 18:27:31 +0800 (CST)
To:     netdev@vger.kernel.org
Cc:     willemb@google.com, davem@davemloft.net, jchapman@katalix.com
From:   Jianguo Wu <wujianguo106@163.com>
Subject: [PATCH] udp: reduce padding field unused to 1-byte in struct udp_sock
Message-ID: <126b8cf1-0b44-ee99-8598-a10acebc5a47@163.com>
Date:   Thu, 21 Oct 2021 18:27:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: DcCowACXn6OSQHFhtsJiKQ--.14959S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jw4fWFWkGry3JrWxury7trb_yoWDXwc_C3
        WfArs3Grs7JrW7Xw4IyF9IqF4ag3ykJFnxuwnakr43Grn5ZFsIgwnxXF9Fya15Wa97WFn5
        Z3Wvq34fArn3GjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUY2YLPUUUUU==
X-Originating-IP: [110.80.1.46]
X-CM-SenderInfo: 5zxmxt5qjx0iiqw6il2tof0z/xtbBiBMzkFaEAyET9gAAst
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianguo Wu <wujianguo@chinatelecom.cn>

In commit 342f0234c71b ("[UDP]: Introduce UDP encapsulation type for L2TP"),
it includes a padding field(__u8 unused[3]) to put the new encap_rcv field
on a 4-byte boundary.

But commit bec1f6f69736 ("udp: generate gso with UDP_SEGMENT") and a new 2-bytes
field gso_size, so we should cut 2-bytes padding.

Fixes: bec1f6f69736 udp: generate gso with UDP_SEGMENT)
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
---
 include/linux/udp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/udp.h b/include/linux/udp.h
index ae66dad..c1b4e5b 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -70,7 +70,7 @@ struct udp_sock {
 #define UDPLITE_SEND_CC  0x2  		/* set via udplite setsockopt         */
 #define UDPLITE_RECV_CC  0x4		/* set via udplite setsocktopt        */
 	__u8		 pcflag;        /* marks socket as UDP-Lite if > 0    */
-	__u8		 unused[3];
+	__u8		 unused;
 	/*
 	 * For encapsulation sockets.
 	 */
-- 
1.8.3.1

