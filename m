Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 802784229F
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 12:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408143AbfFLKgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 06:36:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44073 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406315AbfFLKgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 06:36:35 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hb0cC-00078V-SU; Wed, 12 Jun 2019 10:36:24 +0000
From:   Colin King <colin.king@canonical.com>
To:     Florian Westphal <fw@strlen.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] xfrm: fix missing break on AF_INET6 case
Date:   Wed, 12 Jun 2019 11:36:24 +0100
Message-Id: <20190612103624.27246-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

It appears that there is a missing break statement for the AF_INET6 case
that falls through to the default WARN_ONCE case. I don't think that is
intentional. Fix this by adding in the missing break.

Addresses-Coverity: ("Missing break in switch")
Fixes: 4c203b0454b5 ("xfrm: remove eth_proto value from xfrm_state_afinfo")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/xfrm/xfrm_input.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 8a00cc94c32c..6088bc2dc11e 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -376,6 +376,7 @@ static int xfrm_prepare_input(struct xfrm_state *x, struct sk_buff *skb)
 		break;
 	case AF_INET6:
 		skb->protocol = htons(ETH_P_IPV6);
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		break;
-- 
2.20.1

