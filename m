Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60C01EA16F
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 17:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbfJ3QG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 12:06:26 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42632 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbfJ3QG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 12:06:26 -0400
Received: by mail-lj1-f194.google.com with SMTP id a21so3274773ljh.9
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 09:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Nuru03JnuH9fx/0jdmmXx1/PTVnjDFz/0xAAwcHtc6M=;
        b=ICsVkYM1vIvPi88fM8Yr6EORt/Wl3EhfOLIJHPnVYeD6l9iL54sh/1DGGUvqQXm307
         OngRr94mQeBwVn1SpryjzNIPccTIcyyIK0s5cGJ+rvsJ3HLKHKCvMdlyT3bKA3xATulO
         gz2jNz0ipWmU4F7OLuBvvjuZYc5Df6rGdXr7GoWuFgmkKuWSCRFM2bWaSyuHK0b3TQTh
         fpC3f4GJzq6qm4N2fGA4j0yCU3R23PLw/MHKdU9dmmhIsJ9uWKuG3WLwLablVlyJTDMw
         e0pQb+olSBgfN8RexVMczn9oDn4RXuvwvLHCo9v/RCSWcLxIBMrGB9gO4rbSImhLsuhE
         91SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Nuru03JnuH9fx/0jdmmXx1/PTVnjDFz/0xAAwcHtc6M=;
        b=k2DlO1a2kgiOfxVc4p72spYC9GIfbe38gf0lphgBEFoNzcZnRfmesCNZBN64SAJ9Ws
         6iIS9j347u4NRoyhpmEgxs5d2Dzhb60bjUs7GLZl7e8BljeHKQ3/4a7UYHRw8HPUcdoz
         g0CPmfrnwEtA/9zayiMiL31w8eHSRtkQN2jT9oKQe6nO86uCQb+APaNqYxsoztek4V0a
         nkKWk6CU6mcrt9hFJsLIMJBQtHjIY2K/28RmXrlpQd3Lx8xE4yMqGU04GNTQwv1tfu+0
         B6O4dRbbQ0zqskjX8B2v4OyN2pPDxMLBeZ1lG6PqD3A45y255rZ/AnDpvRWX7SO1/E03
         mt0A==
X-Gm-Message-State: APjAAAXUehckbzXbx8oDXRU7PY5CnbGmcZQXvAKB4G20HrazoKRGA6Cp
        k+80JUR3JiuP5pZhaNhmL/Z/3Q==
X-Google-Smtp-Source: APXvYqzVM2Pfy2j/t89/o38T/MRIjQ0HVsIRoMn2xR+ftH7uTiq8+TOtzNgduXcB1glD8MEkeVf/Aw==
X-Received: by 2002:a2e:b0c9:: with SMTP id g9mr350704ljl.95.1572451582533;
        Wed, 30 Oct 2019 09:06:22 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id a28sm155643ljn.16.2019.10.30.09.06.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Oct 2019 09:06:21 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com,
        syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com,
        Eric Biggers <ebiggers@kernel.org>,
        herbert@gondor.apana.org.au, glider@google.com,
        linux-crypto@vger.kernel.org
Subject: [PATCH net] net/tls: fix sk_msg trim on fallback to copy mode
Date:   Wed, 30 Oct 2019 09:05:42 -0700
Message-Id: <20191030160542.30295-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sk_msg_trim() tries to only update curr pointer if it falls into
the trimmed region. The logic, however, does not take into the
account pointer wrapping that sk_msg_iter_var_prev() does.
This means that when the message was trimmed completely, the new
curr pointer would have the value of MAX_MSG_FRAGS - 1, which is
neither smaller than any other value, nor would it actually be
correct.

Special case the trimming to 0 length a little bit.

This bug caused the TLS code to not copy all of the message, if
zero copy filled in fewer sg entries than memcopy would need.

Big thanks to Alexander Potapenko for the non-KMSAN reproducer.

Fixes: d829e9c4112b ("tls: convert to generic sk_msg interface")
Reported-by: syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com
Reported-by: syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
Daniel, John, does this look okay?

CC: Eric Biggers <ebiggers@kernel.org>
CC: herbert@gondor.apana.org.au
CC: glider@google.com
CC: linux-crypto@vger.kernel.org

 net/core/skmsg.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index cf390e0aa73d..c42c145216b1 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -276,7 +276,10 @@ void sk_msg_trim(struct sock *sk, struct sk_msg *msg, int len)
 	 * However trimed data that has not yet been used in a copy op
 	 * does not require an update.
 	 */
-	if (msg->sg.curr >= i) {
+	if (!msg->sg.size) {
+		msg->sg.curr = 0;
+		msg->sg.copybreak = 0;
+	} else if (msg->sg.curr >= i) {
 		msg->sg.curr = i;
 		msg->sg.copybreak = msg->sg.data[i].length;
 	}
-- 
2.23.0

