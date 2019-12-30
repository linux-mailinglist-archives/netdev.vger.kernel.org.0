Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 567C512CEF4
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 11:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbfL3Kc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 05:32:27 -0500
Received: from mail.wangsu.com ([123.103.51.227]:41779 "EHLO wangsu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726196AbfL3Kc1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 05:32:27 -0500
X-Greylist: delayed 2179 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Dec 2019 05:32:23 EST
Received: from 137.localdomain (unknown [59.61.78.232])
        by app2 (Coremail) with SMTP id 4zNnewBnR8yiyQledHAHAA--.7S2;
        Mon, 30 Dec 2019 17:55:47 +0800 (CST)
From:   Pengcheng Yang <yangpc@wangsu.com>
To:     edumazet@google.com
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pengcheng Yang <yangpc@wangsu.com>
Subject: [PATCH] tcp: fix "old stuff" D-SACK causing SACK to be treated as D-SACK
Date:   Mon, 30 Dec 2019 17:54:41 +0800
Message-Id: <1577699681-14748-1-git-send-email-yangpc@wangsu.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: 4zNnewBnR8yiyQledHAHAA--.7S2
X-Coremail-Antispam: 1UD129KBjvJXoW7KrW8Zw4Dtw18GFy7tr4xWFg_yoW8GrykpF
        Z8Gr42gry8GFyIk34jqFykX3W8Kws5CF4agr4UCrnIkwnrGw4fWF1vga1a9r1xKrZ7Cr4S
        vryj9rWDuFyUZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9I1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l8cAvFVAK
        0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4
        x0Y4vE2Ix0cI8IcVCY1x0267AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28E
        F7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F4
        0EFcxC0VAKzVAqx4xG6I80ewAv7VCjz48v1sIEY20_Gr4lYx0Ec7CjxVAajcxG14v26r1j
        6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI
        8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc2xSY4AK67AK6r4fMxAIw28IcxkI7VAK
        I48JMxAIw28IcVCjz48v1sIEY20_Gr4l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxV
        AFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
        zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
        4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_
        WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJb
        IYCTnIWIevJa73UjIFyTuYvjfU4gAwDUUUU
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we receive a D-SACK, where the sequence number satisfies:
	undo_marker <= start_seq < end_seq <= prior_snd_una
we consider this is a valid D-SACK and tcp_is_sackblock_valid()
returns true, then this D-SACK is discarded as "old stuff",
but the variable first_sack_index is not marked as negative
in tcp_sacktag_write_queue().

If this D-SACK also carries a SACK that needs to be processed
(for example, the previous SACK segment was lost), this SACK
will be treated as a D-SACK in the following processing of
tcp_sacktag_write_queue(), which will eventually lead to
incorrect updates of undo_retrans and reordering.

Fixes: fd6dad616d4f ("[TCP]: Earlier SACK block verification & simplify access to them")
Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
---
 net/ipv4/tcp_input.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 88b987c..0238b55 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1727,8 +1727,11 @@ static int tcp_sack_cache_ok(const struct tcp_sock *tp, const struct tcp_sack_bl
 		}
 
 		/* Ignore very old stuff early */
-		if (!after(sp[used_sacks].end_seq, prior_snd_una))
+		if (!after(sp[used_sacks].end_seq, prior_snd_una)) {
+			if (i == 0)
+				first_sack_index = -1;
 			continue;
+		}
 
 		used_sacks++;
 	}
-- 
1.8.0

