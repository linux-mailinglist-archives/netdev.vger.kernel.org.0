Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A102136D2E
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 13:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbgAJMhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 07:37:18 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:37659 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728010AbgAJMhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 07:37:18 -0500
Received: by mail-qk1-f194.google.com with SMTP id 21so1648482qky.4
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 04:37:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=724E2+k+wYWoJNd3a2e5o4hAZ4Lz1W/Uqd0RV5K3kag=;
        b=A2gYEzogfCN61kgR+N/v10e0lA2w92ArfI9nC44DHktxGL30qxtAvot1GLSSG3/WAZ
         bM0TehTedhLiI0v14g8WnStG0eyyRGd+F/FiiUIjewUTqtrWjYqUm7O+DZiX5MvPcG03
         FpZELEt/KeK3T9X5xUig+Nj26t/toIekcs1Q7+KBPI50OO7lLRlhWNOgip6TlC/oLlFB
         EWlGbaUc7SUIzZazE3EUl/rHrU4p0nUCRdddDBpF3fZnvp2S8JWdB+qRPVvF4jcVXOoz
         RWMxIzcEXCphcftKPE6hq/6r5lwDNzxXnsM1vuoLHNvKrRu/8vvJyhzUSTkFGXZq28BS
         GMPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=724E2+k+wYWoJNd3a2e5o4hAZ4Lz1W/Uqd0RV5K3kag=;
        b=qiii4Lfj2FTvMpzIW44j/K9+mmBojQHSFgK7ZGnwTQ4bbRmKZ0Y96CPbf2ZZgVfke+
         YknNjbJnGdkVZynRC/ir9fJ2fEo25fGx8HZDwtJT0749JIXwjqXwoMtrNL3koKj6AZ8D
         s9ma7JKO+iZUbtmbL3yjzCVdZOuIrs7wos3GqMtLK4SD2UzXAH+uXWwZLvVwcAqasgtr
         P756I49DnMi3X9WkcL8Lru+Dc8G1m428EZ0rEMZSNttfGhAEsV3JZ+NqvEC1Hhh3mNOS
         reIpCizeNRnahz2REvVc3wp+l3F7fWavAN0DQZ9G7SvHUP8OS3OUYhEat+6Y7BdQKUg4
         Z7zw==
X-Gm-Message-State: APjAAAUyFjAoBFO0/Hn2Zd3E5NrDQMdh3WD48YOLk8zoDkungukFdZd6
        9owEEueLKu8PdKm/+yoi10pJEw==
X-Google-Smtp-Source: APXvYqxKMwo/0YnAVD2L/5+Zw4WZ2N2Vo0U2AhPnTT8mfyERJEN0SFmkjHmrT/gOAviRL/q4aXdYbg==
X-Received: by 2002:a37:ac16:: with SMTP id e22mr2965861qkm.186.1578659837194;
        Fri, 10 Jan 2020 04:37:17 -0800 (PST)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id v2sm790814qkj.29.2020.01.10.04.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 04:37:16 -0800 (PST)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Beckett <david.beckett@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net] net/tls: avoid spurious decryption error with HW resync
Date:   Fri, 10 Jan 2020 04:36:55 -0800
Message-Id: <20200110123655.996-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When device loses sync mid way through a record - kernel
has to re-encrypt the part of the record which the device
already decrypted to be able to decrypt and authenticate
the record in its entirety.

The re-encryption piggy backs on the decryption routine,
but obviously because the partially decrypted record can't
be authenticated crypto API returns an error which is then
ignored by tls_device_reencrypt().

Commit 5c5ec6685806 ("net/tls: add TlsDecryptError stat")
added a statistic to count decryption errors, this statistic
can't be incremented when we see the expected re-encryption
error. Move the inc to the caller.

Reported-and-tested-by: David Beckett <david.beckett@netronome.com>
Fixes: 5c5ec6685806 ("net/tls: add TlsDecryptError stat")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 net/tls/tls_sw.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index bb229dc0fa81..5c7c00429f8e 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -256,8 +256,6 @@ static int tls_do_decryption(struct sock *sk,
 			return ret;
 
 		ret = crypto_wait_req(ret, &ctx->async_wait);
-	} else if (ret == -EBADMSG) {
-		TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSDECRYPTERROR);
 	}
 
 	if (async)
@@ -1515,7 +1513,9 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 				if (err == -EINPROGRESS)
 					tls_advance_record_sn(sk, prot,
 							      &tls_ctx->rx);
-
+				else if (err == -EBADMSG)
+					TLS_INC_STATS(sock_net(sk),
+						      LINUX_MIB_TLSDECRYPTERROR);
 				return err;
 			}
 		} else {
-- 
2.23.0

