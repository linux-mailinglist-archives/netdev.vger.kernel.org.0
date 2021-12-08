Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C24446D0DA
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 11:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbhLHKWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 05:22:45 -0500
Received: from m12-16.163.com ([220.181.12.16]:27685 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231454AbhLHKWo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 05:22:44 -0500
X-Greylist: delayed 913 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Dec 2021 05:22:43 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Message-ID:Date:MIME-Version:From:Subject; bh=1f0Gd
        E1+Xg2u0V2qKXvE22XZ4+FTAM2/SETjfpsxtlc=; b=FWX0sJgA4Va3VsEMA1K+K
        l5fqp58ckYdruNt+4FSrWp7Oe5SFN3Uln2o7Xkq34OOabfhoLE2bngPamp6lHxW8
        iqlktYTZjDCQs8/EKSxZu8GiCDqNwoHFGEaYKB7+xPjM5tFnoaHDyPdCW97N1IDI
        k2zjFp4YHPnUDWeBiCg2WI=
Received: from [192.168.16.98] (unknown [110.86.5.93])
        by smtp12 (Coremail) with SMTP id EMCowAB3TE31grBhQg8gBA--.156S2;
        Wed, 08 Dec 2021 18:03:41 +0800 (CST)
Message-ID: <900742e5-81fb-30dc-6e0b-375c6cdd7982@163.com>
Date:   Wed, 8 Dec 2021 18:03:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Cc:     willemb@google.com, davem@davemloft.net
From:   Jianguo Wu <wujianguo106@163.com>
Subject: [PATCH] udp: using datalen to cap max gso segments
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: EMCowAB3TE31grBhQg8gBA--.156S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Gw4fur1fXw4kWF4UJr4DCFg_yoWfKwbEgr
        n5Xa18Gr1DJFsrZrs2kFsYqFW09F429Fs5ZFnIyFyYkay5Gr4jywsFqFZ3GFnrC39Yvr13
        ZrWqv3y5tw18CjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUednY5UUUUU==
X-Originating-IP: [110.86.5.93]
X-CM-SenderInfo: 5zxmxt5qjx0iiqw6il2tof0z/1tbiRAZjkFSIjWOpSgAAsg
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianguo Wu <wujianguo@chinatelecom.cn>

The max number of UDP gso segments is intended to cap to UDP_MAX_SEGMENTS,
this is checked in udp_send_skb():

    if (skb->len > cork->gso_size * UDP_MAX_SEGMENTS) {
        kfree_skb(skb);
        return -EINVAL;
    }

skb->len contains network and transport header len here, we should use
only data len instead.

Fixes: bec1f6f69736 ("udp: generate gso with UDP_SEGMENT")
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
---
 net/ipv4/udp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 8bcecdd6aeda..23b05e28490b 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -916,7 +916,7 @@ static int udp_send_skb(struct sk_buff *skb, struct flowi4 *fl4,
 			kfree_skb(skb);
 			return -EINVAL;
 		}
-		if (skb->len > cork->gso_size * UDP_MAX_SEGMENTS) {
+		if (datalen > cork->gso_size * UDP_MAX_SEGMENTS) {
 			kfree_skb(skb);
 			return -EINVAL;
 		}
-- 
1.8.3.1

