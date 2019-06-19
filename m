Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9788A4B927
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 14:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731796AbfFSMxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 08:53:32 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:52193 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731576AbfFSMxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 08:53:32 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MKKpV-1httFS3L4R-00LmVZ; Wed, 19 Jun 2019 14:53:17 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] netfilter: synproxy: fix nf_synproxy_ipv{4,6}_init() return code
Date:   Wed, 19 Jun 2019 14:53:07 +0200
Message-Id: <20190619125314.1005993-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:sHRKPJxI1zML8tYdc1cfhcMo3aUXVxAOGIhwNfIQjjwRunCOAsx
 NHm/ktqi20sgAtTRnoNS3E45QBQpIjaZVx0+5T9JDOd12yuSjTMfuKf3I2WxHLaP7fgMW6m
 OwZXXHliGncpKNm0YIe9lofpzzzFwQEKcW4afzoDhJsMbevSna3JBee75coK4Xtf9M6zYDI
 ksMK9hUacXQ2WZJ8dL5kw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:SCWUrpyWP2Q=:ut0cProTqarHG0QCVTfh9D
 MjpFumB3sMKmB4UQDW90OwoYEvXD6fN2P5u7C9ipmz67bnCj2+fgixTlHZWi50c5YEvc+Ar0s
 8ss2WW2QFYbWSNP3i72/7XdPkBZGA4mprtHQO4vNyu0B5D1bLM+NUG8E2vzfgaBZxN/Aa0oNd
 4JAmSW2hwHbQanQfSE0rZv990u2wg4KrBD/3M+bpjhkORv74ThiMRcHAWYB2L/VsCykY46tc8
 Zd5FJH/nERhpZZnfoTb74nmUKip5BRjbqoZwsColXihClt81pbpfyG2jB1Wi+sVI1w7b51JKb
 tpKvqT5+L1JlVoCBMtsmPp+RJu5SDDxgW6lBl4e+iesBvqIdQYtqkMTLgREf575P2cTLZewQ2
 QFCXR+ikN+dfMGC9EWSwj266DhSLi09CMgXLyOgB51LsCpBoDGP6qvf3teeRebZydq6Ae0V26
 zqmoMIBUch19Sy+HzSrh8dQDx+4T2X17Hky8gaAP1tYnhsCBzMLr+4+MX4P+YzxpNcXKFDIWB
 pnCqDkDwWHX2ydF47Bw/dsS2NsggITOpih1wQXbijgiINj2u1n6xV/kBFRFhqk844L7d0CEL5
 JQA+koiuVWPxlhVuCcjFXIpdUxzZzYA3vRY1xYK22sEaeS7MX4JORqyTpM3UkbZno0sYQtjZR
 Fy1kLg9kgrx1ImoDpIc+WgpKE7sy+xLDdc0v2h+sfb60PtXAdFKYePZHNTIe2j3XO3WctYQ4l
 nny3uTmIzSdnSB1+favdUtgwez9Lxjyv7snIvA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We return an uninitialized variable on success:

net/netfilter/nf_synproxy_core.c:793:6: error: variable 'err' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
        if (snet->hook_ref4 == 0) {
            ^~~~~~~~~~~~~~~~~~~~

Initialize the return code to zero first.

Fixes: d7f9b2f18eae ("netfilter: synproxy: extract SYNPROXY infrastructure from {ipt, ip6t}_SYNPROXY")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/netfilter/nf_synproxy_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 50677285f82e..283686e972a0 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -788,7 +788,7 @@ static const struct nf_hook_ops ipv4_synproxy_ops[] = {
 
 int nf_synproxy_ipv4_init(struct synproxy_net *snet, struct net *net)
 {
-	int err;
+	int err = 0;
 
 	if (snet->hook_ref4 == 0) {
 		err = nf_register_net_hooks(net, ipv4_synproxy_ops,
@@ -1213,7 +1213,7 @@ static const struct nf_hook_ops ipv6_synproxy_ops[] = {
 int
 nf_synproxy_ipv6_init(struct synproxy_net *snet, struct net *net)
 {
-	int err;
+	int err = 0;
 
 	if (snet->hook_ref6 == 0) {
 		err = nf_register_net_hooks(net, ipv6_synproxy_ops,
-- 
2.20.0

