Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32CBF254020
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 10:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgH0IDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 04:03:36 -0400
Received: from spam.zju.edu.cn ([61.164.42.155]:20972 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727786AbgH0ID0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 04:03:26 -0400
Received: from localhost.localdomain (unknown [210.32.144.184])
        by mail-app4 (Coremail) with SMTP id cS_KCgCnHXmtaEdfNtlgAQ--.29784S4;
        Thu, 27 Aug 2020 16:02:57 +0800 (CST)
From:   Dinghao Liu <dinghao.liu@zju.edu.cn>
To:     dinghao.liu@zju.edu.cn, kjlu@umn.edu
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Scott Mayhew <smayhew@redhat.com>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] gss_krb5: Fix memleak in krb5_make_rc4_seq_num
Date:   Thu, 27 Aug 2020 16:02:50 +0800
Message-Id: <20200827080252.26396-1-dinghao.liu@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cS_KCgCnHXmtaEdfNtlgAQ--.29784S4
X-Coremail-Antispam: 1UD129KBjvdXoW7XFyxJry5ur45GFWxCF17Wrg_yoWfKFX_Wa
        y8XFs8Xa1kWFnF9w47W39xZryvkwn8Arn5WasxKFyfZa1ayFn8A3ykWr1kur15uFWrArZ7
        GF4kAr9xt3WIkjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb-kFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AK
        wVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20x
        vE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4UJVW0owA2z4x0Y4vEx4A2
        jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52
        x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWU
        GwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI4
        8JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2xKxwCY02Avz4vE
        14v_GFyl42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VW8uw4UJr1UMxC20s026x
        CaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_
        JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r
        1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_
        Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JV
        W8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjNJ55UUUUU==
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAg0EBlZdtPrBDAAZsc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When kmalloc() fails, cipher should be freed
just like when krb5_rc4_setup_seq_key() fails.

Fixes: e7afe6c1d486b ("sunrpc: fix 4 more call sites that were using stack memory with a scatterlist")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
---
 net/sunrpc/auth_gss/gss_krb5_seqnum.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/auth_gss/gss_krb5_seqnum.c b/net/sunrpc/auth_gss/gss_krb5_seqnum.c
index 507105127095..88ca58d11082 100644
--- a/net/sunrpc/auth_gss/gss_krb5_seqnum.c
+++ b/net/sunrpc/auth_gss/gss_krb5_seqnum.c
@@ -53,8 +53,10 @@ krb5_make_rc4_seq_num(struct krb5_ctx *kctx, int direction, s32 seqnum,
 		return PTR_ERR(cipher);
 
 	plain = kmalloc(8, GFP_NOFS);
-	if (!plain)
-		return -ENOMEM;
+	if (!plain) {
+		code = -ENOMEM;
+		goto out;
+	}
 
 	plain[0] = (unsigned char) ((seqnum >> 24) & 0xff);
 	plain[1] = (unsigned char) ((seqnum >> 16) & 0xff);
-- 
2.17.1

