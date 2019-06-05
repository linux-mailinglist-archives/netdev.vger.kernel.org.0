Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDA1C36646
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 23:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfFEVGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 17:06:51 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:60447 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbfFEVGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 17:06:50 -0400
Received: from orion.localdomain ([77.2.1.21]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MBlpC-1hOgQB2mxo-00CDaq; Wed, 05 Jun 2019 23:06:43 +0200
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     pshelar@ovn.org, davem@davemloft.net, netdev@vger.kernel.org,
        dev@openvswitch.org
Subject: [PATCH] net: openvswitch: drop unneeded likely() call around IS_ERR()
Date:   Wed,  5 Jun 2019 23:06:40 +0200
Message-Id: <1559768800-18763-1-git-send-email-info@metux.net>
X-Mailer: git-send-email 1.9.1
X-Provags-ID: V03:K1:Q0dMVNlWg9Jugz820HJgEoP92ieTHn0R4pNNu/4D0178AMiTNJA
 2pbG0EUsUk5rT/7rQ+Oa2DpHh7NtfbB3rFCQu3vf/+qhcltN1aaWiUQwcWBlNkDQ8sRj8oD
 O2l0sqEhqlDjiJgELCviecqAYisKKctWUbBdmEfGDaTZnQLVvCYgeffxGPgXGRROq0Fv/ix
 6bOtupJsJY3OSHr0Jo/3A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:OLwNnzRBr9k=:w1lVm35MLec14dcy+nNU/l
 bvHwPeRbM0WDL6IhhWFAZBg1/1kY0WJv9vb+G8E+alDOZVOBe/EaFn0WL7ShK7YvU8vQJEpWy
 xPtWaqORf8nC3f3Cdv1AMl6DmlOQUn8trItWZmcfbg9Q5U75NCMzbimC1lNipRjOuThFX1t7A
 yMX12gJ6RPZ3XAL//79dkiMqMC+/LBiKi33Ew+Uft45iaExd5ojgBTw2PyEreElmr5KYXmsxR
 zImQfbGZsKEJXtjZLhZYxRACtmETZ+R2c7IYtYBvnN2F90ZHbGGxOG1lkI/t7U8s209UME/Gh
 mOexaBHRHQzwwPRCBSIxdlJReHknbUIp7F+A38BkADStRFy3jGIQ289GfBmMgsfxeLxSnDYR8
 hpjg2ei0eiitYIe+Qi9MW3iFHn3ZCBkPPsTDt8muOUH7xLwFkzI/VDqnV6DPln2RPjibIqldN
 M+ANjavxXPMjbLJVbjvw/T6sfX9MrGofdM+eRzqhZoxlXcaT7xm8aV8Bn0rmQtGdSlAwpprn5
 vW/4+2LBN8arbnfZJq2Px/ka6toX7AIwkbyX5o5MZc3UBLJOsJ5nRO1l4GSCnFIxEzUzmW8BZ
 q815SLbJC9dH2c5MJIaxs/KvPsKid53twoz8eNZxRQAtrBiia1tqkT3naKgKX6ORyBlbuyIiA
 UlUGGcGVlOt2kQM8C38PG60iA29GU86XUqUpzFUCuzOXZ578k/imvrZC0qZyaWbsCJQLwoOuR
 WbhXrAm3/u9RXwnSIryg1hSjgOsVLUE+yI8EuA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Enrico Weigelt <info@metux.net>

IS_ERR() already calls unlikely(), so this extra likely() call
around the !IS_ERR() is not needed.

Signed-off-by: Enrico Weigelt <info@metux.net>
---
 net/openvswitch/datapath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index dc9ff93..4076e08 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1347,7 +1347,7 @@ static int ovs_flow_cmd_del(struct sk_buff *skb, struct genl_info *info)
 	reply = ovs_flow_cmd_alloc_info((const struct sw_flow_actions __force *) flow->sf_acts,
 					&flow->id, info, false, ufid_flags);
 	if (likely(reply)) {
-		if (likely(!IS_ERR(reply))) {
+		if (!IS_ERR(reply)) {
 			rcu_read_lock();	/*To keep RCU checker happy. */
 			err = ovs_flow_cmd_fill_info(flow, ovs_header->dp_ifindex,
 						     reply, info->snd_portid,
-- 
1.9.1

