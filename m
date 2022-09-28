Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60A145EE3F1
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 20:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbiI1SKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 14:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234401AbiI1SKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 14:10:18 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9398780BF9;
        Wed, 28 Sep 2022 11:10:16 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-131886d366cso6680329fac.10;
        Wed, 28 Sep 2022 11:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=arM2Bs8QnOGMnG64FDvQIEvqu+HWfon6/YutU6YooRw=;
        b=pHZ+HFdVtIOElIUzZxDNlcslllZwJCldhDp2KajG17dEXbKWI5gUklt1ikx1FljMcI
         XozS7i5qVIZK6FihIwq6eJPYqake0snA5kFp9FSSesrYQj/CfYJoBs7AuDSb/HfQj9/E
         5pbldJGue+iTvs0iudis6UB5O6NEvb3ZhQ33xTOig3FZDz3w6mqqkqd/5b4vF93SvYzN
         0FtfXgjwcdPyi+ooXk9DSqSsNIAtNILWHVRydSL4l8ytsKTcHL1nUCIkLolCrnjZ40EC
         LgkMURCmnz4cwETfzR5lLKAHAAybK9BhU7evljTKuS5QejGfvoLfo9v4KQGPOxdWwQfb
         PmQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=arM2Bs8QnOGMnG64FDvQIEvqu+HWfon6/YutU6YooRw=;
        b=HbuVt9HqUC8rGftf3DHeRGFH715hO5tsaMF/mefBXaGOa+TQKkylH6MOarm3ST3zo6
         xesLRQEjMESnr3E4GhtCE/7RlHK/xjBGl8nKUSeSP8cw5IAIkRQujghv6PK6mPmIEepb
         jgwJlz1mVqDQAyehLmsErOUYNiM0sdrzBmw8xMN9+h/azuMy1DygmEfTrI7fW9TicdEO
         YTK68Vqcz54eXE3mWWz01eGQoN1EMy7ApD2b3z7gcYDPpFnxAukgnH4xZNT3ULTsfX2f
         r6CV87hRTx5aSBlvTS5ihsAM170T7X+iQPCI23kcfAVOCIxKtNkvR6nhwXz8LgPlG/TN
         WRwQ==
X-Gm-Message-State: ACrzQf2lzgo9nzZRRnXs7P8yRx9fHt9T7mAGKiP289tQJMTO8HYsxiL3
        IVeb77Mk6/iP3fLMYbDyTX0pccGpFisoXg==
X-Google-Smtp-Source: AMsMyM5+VoruVlxqjPGOl9CN4FyP1QWv8vSz1GUN2yKuRjA3t/Je8oYTxTBg4FFUZcfFRindqVfpVQ==
X-Received: by 2002:a05:6870:562c:b0:127:bbe4:3f35 with SMTP id m44-20020a056870562c00b00127bbe43f35mr6388446oao.284.1664388615262;
        Wed, 28 Sep 2022 11:10:15 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id h17-20020a4adcd1000000b004761fdccd76sm2185683oou.17.2022.09.28.11.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 11:10:14 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net] sctp: handle the error returned from sctp_auth_asoc_init_active_key
Date:   Wed, 28 Sep 2022 14:10:13 -0400
Message-Id: <035e28d623263b9c3ccbbea689883d6437aa5aa0.1664388613.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When it returns an error from sctp_auth_asoc_init_active_key(), the
active_key is actually not updated. The old sh_key will be freeed
while it's still used as active key in asoc. Then an use-after-free
will be triggered when sending patckets, as found by syzbot:

  sctp_auth_shkey_hold+0x22/0xa0 net/sctp/auth.c:112
  sctp_set_owner_w net/sctp/socket.c:132 [inline]
  sctp_sendmsg_to_asoc+0xbd5/0x1a20 net/sctp/socket.c:1863
  sctp_sendmsg+0x1053/0x1d50 net/sctp/socket.c:2025
  inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:819
  sock_sendmsg_nosec net/socket.c:714 [inline]
  sock_sendmsg+0xcf/0x120 net/socket.c:734

This patch is to fix it by not replacing the sh_key when it returns
errors from sctp_auth_asoc_init_active_key() in sctp_auth_set_key().
For sctp_auth_set_active_key(), old active_key_id will be set back
to asoc->active_key_id when the same thing happens.

Fixes: 58acd1009226 ("sctp: update active_key for asoc when old key is being replaced")
Reported-by: syzbot+a236dd8e9622ed8954a3@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/auth.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index db6b7373d16c..34964145514e 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -863,12 +863,17 @@ int sctp_auth_set_key(struct sctp_endpoint *ep,
 	}
 
 	list_del_init(&shkey->key_list);
-	sctp_auth_shkey_release(shkey);
 	list_add(&cur_key->key_list, sh_keys);
 
-	if (asoc && asoc->active_key_id == auth_key->sca_keynumber)
-		sctp_auth_asoc_init_active_key(asoc, GFP_KERNEL);
+	if (asoc && asoc->active_key_id == auth_key->sca_keynumber &&
+	    sctp_auth_asoc_init_active_key(asoc, GFP_KERNEL)) {
+		list_del_init(&cur_key->key_list);
+		sctp_auth_shkey_release(cur_key);
+		list_add(&shkey->key_list, sh_keys);
+		return -ENOMEM;
+	}
 
+	sctp_auth_shkey_release(shkey);
 	return 0;
 }
 
@@ -902,8 +907,13 @@ int sctp_auth_set_active_key(struct sctp_endpoint *ep,
 		return -EINVAL;
 
 	if (asoc) {
+		__u16  active_key_id = asoc->active_key_id;
+
 		asoc->active_key_id = key_id;
-		sctp_auth_asoc_init_active_key(asoc, GFP_KERNEL);
+		if (sctp_auth_asoc_init_active_key(asoc, GFP_KERNEL)) {
+			asoc->active_key_id = active_key_id;
+			return -ENOMEM;
+		}
 	} else
 		ep->active_key_id = key_id;
 
-- 
2.31.1

