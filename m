Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAA91366AA
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 23:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbfFEVTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 17:19:17 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:54899 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbfFEVTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 17:19:16 -0400
Received: from orion.localdomain ([77.2.1.21]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MVv4X-1h9eBa1aWT-00RtRb; Wed, 05 Jun 2019 23:19:15 +0200
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH] drivers: net: vxlan: drop unneeded likely() call around IS_ERR()
Date:   Wed,  5 Jun 2019 23:19:13 +0200
Message-Id: <1559769553-24214-1-git-send-email-info@metux.net>
X-Mailer: git-send-email 1.9.1
X-Provags-ID: V03:K1:vihkw4Ta7ffWZGf1DzM4rk0z5CparAY+tTIX/fKckLdg1apDB+k
 I1LHC9Sb1mCdpTGw8VmRdBOeKQuhtvjC8idKXkP3ZAUCSI3vIbXGIMbqAVjIVEf1QMlvBnh
 t98GJOObH1MOjrt2JuCVpVyzALXcXvGjXb6+IEVtbkPJICECbGfoyuuk5Xnys+cQnWP0e1u
 i75DzyCklN9Q8qBBcqZEA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:cB4wgoy+1cU=:E9EjD6TxIvjBdBq2z3MVTA
 y+H7Nb1uyDmfbRnkU2IlsI3ClbGkuGAvOm0YGdhMQhw2CsKOBYaCN3bl2qLI0FL+N8IjDEIQt
 ejVOH4hiyu1YC0Fw6cQVfRD+UxqeM9oz0EcSa/jLAPwh6ZwxtFdkGDxZOb3Hh9ko4e93dfMAr
 ZwsCPHDNUnnEwjmisihf/AbJjj4BUkLMpRY8A7zvopUOojvpWeocaVwmrcfHacARzFnRVB4TQ
 QXcO5qH9DmNcrLNG1SzhQn3RT9l/7jD9PzSRaNFVas0ErwLkZ+IDK7DQGa19KOyGL5BZcBHnQ
 +DUbgoTTaH81NaHrOZT9JtH4mBrSZuxhRgnyAGpMQc2ikn8l+/7FLx0HY4wct33bvpzrh59Am
 sOfCBbMjHl6v61TQhY4wl8KlRxcACZsgduhkyyx7+3+xJ+GxAEZ9aQQdqpxPuAJCH1ARgUnjF
 QTfjrNElpnLlNhWEqP4bpfw01gAn8eXkRPgJ/VVAQ+hnf6QLAj8rrHiIS2NL+iHcHW+xf4bEL
 YBNDth3uoUdlo2imzNFEBchObaUDdlCxnXagFZifJqYEGhszEyt67BgPvfOOVGK33cWsPTfQJ
 D9F1nf8Q4AxYFoMcyb8hpotnGltnHdGvppWsbTx2nWF8ysI9UWmIiUdKEve0QeMRrfhRpUGGx
 XVx6hqRrEjh7dESB4QPHYd1mqlzAfxXNjpZdex89BgNm8xJgakANrVKmxzymmbTR2ha1qrxOR
 XLQ1SpcQBhgqkLIH30eHSeV2bNDyC6kt3E1pjw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Enrico Weigelt <info@metux.net>

IS_ERR() already calls unlikely(), so this extra likely() call
around the !IS_ERR() is not needed.

Signed-off-by: Enrico Weigelt <info@metux.net>
---
 drivers/net/vxlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 5994d54..f31d226 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2222,7 +2222,7 @@ static struct rtable *vxlan_get_route(struct vxlan_dev *vxlan, struct net_device
 	fl4.fl4_sport = sport;
 
 	rt = ip_route_output_key(vxlan->net, &fl4);
-	if (likely(!IS_ERR(rt))) {
+	if (!IS_ERR(rt)) {
 		if (rt->dst.dev == dev) {
 			netdev_dbg(dev, "circular route to %pI4\n", &daddr);
 			ip_rt_put(rt);
-- 
1.9.1

