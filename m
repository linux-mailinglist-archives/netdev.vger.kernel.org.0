Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A82345E8F
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 13:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbhCWMw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 08:52:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231338AbhCWMwk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 08:52:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B99CE619B7;
        Tue, 23 Mar 2021 12:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616503957;
        bh=mRfSmzsVcIVbIadqBeT4oBqLsxBa56oCuRtUUGrMpok=;
        h=From:To:Cc:Subject:Date:From;
        b=dMqTWv2afZWj5Mau1JMxfYA7kxXLGNPM8ApL0kZgm0672qqwnDpwudjobI59hNCL5
         AAVnM9vwGVQn8l3bZJv+iJa+sdORsCqm513oGXaRCZymrXkXKFDv1m/C05QoVMt27j
         okhe0gj56VRxdUOelQO9F0qhbxNDMrhEJWj+RqYbm06XxE4fzgZOI0QxbRX6yvfHyJ
         TEU8SXNVImuroAMjfjkInlUwIyXgSfnHcgy+OFi+5b+zdYLX0sbHNoBTr/ZITwK0A/
         t73s18aYtMuuFqGWWwRwBmDKf32qvCGY2nbqutCWSvCPMH0GYfijtpYWJ9WRK/aT0S
         aJy8Q+Y3tgpiw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Alexander Lobakin <alobakin@pm.me>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC net] net: skbuff: fix stack variable out of bounds access
Date:   Tue, 23 Mar 2021 13:52:24 +0100
Message-Id: <20210323125233.1743957-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

gcc-11 warns that the TS_SKB_CB(&state)) cast in skb_find_text()
leads to an out-of-bounds access in skb_prepare_seq_read() after
the addition of a new struct member made skb_seq_state longer
than ts_state:

net/core/skbuff.c: In function ‘skb_find_text’:
net/core/skbuff.c:3498:26: error: array subscript ‘struct skb_seq_state[0]’ is partly outside array bounds of ‘struct ts_state[1]’ [-Werror=array-bounds]
 3498 |         st->lower_offset = from;
      |         ~~~~~~~~~~~~~~~~~^~~~~~
net/core/skbuff.c:3659:25: note: while referencing ‘state’
 3659 |         struct ts_state state;
      |                         ^~~~~

The warning is currently disabled globally, but I found this
instance during experimental build testing, and it seems
legitimate.

Make the textsearch buffer longer and add a compile-time check to
ensure the two remain the same length.

Fixes: 97550f6fa592 ("net: compound page support in skb_seq_read")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/textsearch.h | 2 +-
 net/core/skbuff.c          | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/textsearch.h b/include/linux/textsearch.h
index 13770cfe33ad..6673e4d4ac2e 100644
--- a/include/linux/textsearch.h
+++ b/include/linux/textsearch.h
@@ -23,7 +23,7 @@ struct ts_config;
 struct ts_state
 {
 	unsigned int		offset;
-	char			cb[40];
+	char			cb[48];
 };
 
 /**
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 545a472273a5..dd10d4c5f4bf 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3633,6 +3633,7 @@ static unsigned int skb_ts_get_next_block(unsigned int offset, const u8 **text,
 					  struct ts_config *conf,
 					  struct ts_state *state)
 {
+	BUILD_BUG_ON(sizeof(struct skb_seq_state) > sizeof(state->cb));
 	return skb_seq_read(offset, text, TS_SKB_CB(state));
 }
 
-- 
2.29.2

