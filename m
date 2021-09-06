Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61430401CB3
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 15:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242792AbhIFN6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 09:58:20 -0400
Received: from smtpbg587.qq.com ([113.96.223.105]:33663 "EHLO smtpbg587.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232432AbhIFN6T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Sep 2021 09:58:19 -0400
X-QQ-mid: bizesmtp46t1630936616tmdbv0zp
Received: from localhost.localdomain (unknown [171.223.98.107])
        by esmtp6.qq.com (ESMTP) with 
        id ; Mon, 06 Sep 2021 21:56:55 +0800 (CST)
X-QQ-SSF: 01000000004000C0D000B00A0000000
X-QQ-FEAT: XNS/ZC4vffVNTZkm0uumHZ4/n+M4rXDPjCyZ8nrcw4j6Bxk6m+1S5KOBzrKfH
        cJhrGyTYPiscoVi1Uz0mxlqM9rKHDqETyOUhq0UkWfgXFTJSiEnoe7okpUBooYlgq5uSG1c
        efMlZXCqF71t1qMad3H2iXvqxVdsrdPqKjRiWe+HDuEktC0T48P6V8JtK1GcZpfnh7lbk22
        JwHM58u0HZHr2IkDzVuIGri1/4QV7/DTnhrOyN0srAFrzecY4tfLoNZIAClR+Wc6tPV5Ix1
        TCzHxF/YGdK2o6e3h8m6gG2i3UC+YLJEV1bCvotM8JcE6fPKoVA5pQLx6ORNHJ+nexzyDTY
        6skN9UNOZ0vAmlo8Laqfu/yOgfAgA==
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     davem@davemloft.net
Cc:     timur@kernel.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] net: qcom/emac: Replace strlcpy with strscpy
Date:   Mon,  6 Sep 2021 21:56:53 +0800
Message-Id: <20210906135653.109449-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The strlcpy should not be used because it doesn't limit the source
length. As linus says, it's a completely useless function if you
can't implicitly trust the source string - but that is almost always
why people think they should use it! All in all the BSD function
will lead some potential bugs.

But the strscpy doesn't require reading memory from the src string
beyond the specified "count" bytes, and since the return value is
easier to error-check than strlcpy()'s. In addition, the implementation
is robust to the string changing out from underneath it, unlike the
current strlcpy() implementation.

Thus, We prefer using strscpy instead of strlcpy.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 drivers/net/ethernet/qualcomm/emac/emac-ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qualcomm/emac/emac-ethtool.c b/drivers/net/ethernet/qualcomm/emac/emac-ethtool.c
index 79e50079ed03..f72e13b83869 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac-ethtool.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac-ethtool.c
@@ -100,7 +100,7 @@ static void emac_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
 
 	case ETH_SS_STATS:
 		for (i = 0; i < EMAC_STATS_LEN; i++) {
-			strlcpy(data, emac_ethtool_stat_strings[i],
+			strscpy(data, emac_ethtool_stat_strings[i],
 				ETH_GSTRING_LEN);
 			data += ETH_GSTRING_LEN;
 		}
-- 
2.33.0

