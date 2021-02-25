Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E1332591D
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 22:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbhBYV5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 16:57:44 -0500
Received: from smtp-17-i2.italiaonline.it ([213.209.12.17]:57611 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234900AbhBYVzl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 16:55:41 -0500
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([87.20.116.197])
        by smtp-17.iol.local with ESMTPA
        id FOYQlNUJ2lChfFOYXlkbgJ; Thu, 25 Feb 2021 22:52:22 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614289942; bh=j7GRCoTejXM7B9fJVl1bTmRrEzrTT3KamKBLcuWoSdk=;
        h=From;
        b=aQXhC9sBNN93GeYw4esKYoNGJMPZMNLWgrYE83abP0Nw/CGXJoyoPv+KAzAnF5E/l
         QvzHd+pKIbGa5AvOD3OyDMhHTCw8Rvr5nzCK+GvkJCyAxH0CfjXBJ6ePScVG/lOzRA
         +zidJq7s9Vq/B9LusPURVs7elE+g/X3RRzCaDQB4g/Awe4Uq23D7bf64xwJs+zV2tb
         3XsrkAN/+r1CijnWd1r4OQ9ByTRFxqaAOcAEDNN5K2hZoGVRKzuXL799Ea4wnu0CCG
         FOBnyXHLLYjfZN8dsqk5DQJzxKDKcXJvwl7OdBFm4UEpfkp67a6+0axJRdpCSe0kTh
         MU32eX7SV0vuQ==
X-CNFS-Analysis: v=2.4 cv=S6McfKgP c=1 sm=1 tr=0 ts=60381c16 cx=a_exe
 a=AVqmXbCQpuNSdJmApS5GbQ==:117 a=AVqmXbCQpuNSdJmApS5GbQ==:17
 a=6WxvSi62EpDuW4hn7DoA:9
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@systec-electronic.com>,
        Federico Vaga <federico.vaga@gmail.com>,
        Dario Binacchi <dariobin@libero.it>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 3/6] can: c_can: fix control interface used by c_can_do_tx
Date:   Thu, 25 Feb 2021 22:51:52 +0100
Message-Id: <20210225215155.30509-4-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210225215155.30509-1-dariobin@libero.it>
References: <20210225215155.30509-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfPTJVu/b4W/lDf0Rt18zHhRwMpHd1BkDGPYy0FpY80gMrR9Lu9WZompAs77KBBfKMdwZRlBBH0dvhFQeVLFKK3CGvAcOJ9BD+RkDPijbzbJ3Z27HSyBc
 wOItyxSDdpNDePV3OQmXEkG8mE+tGXsQF8jRD4tyIDGWGWu38s5QBQSmCDxTGITHVYuagr0DE6ux1lOJmBJLkiKh/+KzCfJ4EasyY0JTKmaBasKwIzQW8Qbs
 zDmkMzh4RpdZ3+LQ7eD2HvBgJaW52frQ/+d4jYvj+EAkgYOg61k/oPt65aqOjlBY2p+ZLpQ0xcu6e7OyYI/vrSHv2iElTTs5XgFDYkrqMyuKfJ0YNpnOAqKI
 uLEv/KOtms3BQNVwz8jXT+O5EcO57ZEj1kx3URL0OnNPHZnSLJzlPy5GOVQ4cv6hdTM7qX8LeomhWpfTVUg2+F7oBIXeUkYxwsF+Gm8iOm/93z9s22z2TVGZ
 9ycaHOc35NAnPDFgttLcf/FWbfYOIhR15SNPqlHsaxAE+bIUd3JgDVQU156m8nM/LkduMCAvsqhPEpbuBNsWqi2kKlTKkkSYze6oiIlhwcSWmHwVnFd3/zhX
 /8fLDv61eFQezQaSTPPE8ok9UUayGvdQIpwM8phZkaTEvGtXYtlnfY2xiM2iMSusGT3X7yelQqEURw3j1XJQXGkpU7knR/CsxnNTsKrOwQP1eQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to commit 640916db2bf7 ("can: c_can: Make it SMP safe") let RX use
IF1 (i.e. IF_RX) and TX use IF2 (i.e. IF_TX).

Signed-off-by: Dario Binacchi <dariobin@libero.it>
---

(no changes since v1)

 drivers/net/can/c_can/c_can.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index dbcc1c1c92d6..69526c3a671c 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -732,7 +732,7 @@ static void c_can_do_tx(struct net_device *dev)
 		idx--;
 		pend &= ~(1 << idx);
 		obj = idx + C_CAN_MSG_OBJ_TX_FIRST;
-		c_can_inval_tx_object(dev, IF_RX, obj);
+		c_can_inval_tx_object(dev, IF_TX, obj);
 		can_get_echo_skb(dev, idx, NULL);
 		bytes += priv->dlc[idx];
 		pkts++;
-- 
2.17.1

