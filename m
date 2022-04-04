Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55C5B4F0D7A
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 03:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357253AbiDDByh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 21:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235878AbiDDByh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 21:54:37 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DAAEAE48;
        Sun,  3 Apr 2022 18:52:42 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id x31so7588868pfh.9;
        Sun, 03 Apr 2022 18:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=peU3m6xX748JtFgTX4y7BDRBSLamYXJGhioH1D/Rhfc=;
        b=m60KkGqRmZZRfPaekz8IbR3FStPNzyDwufkpGDh3Da65IFVOOKF5ZdohUlJz9u92hA
         mBf8193jprIeTmXnfOD3MUbmEAmaLQxuqOuXqhhD4sBjELFm7z93wYdup0RJzxLJsEPf
         OUQiAkwXGqODYLzICGcq6PR//2ER/JoxYs9CIWEr1vIInAy0h5d+TIR3Dh7OCBInQrp2
         8UUASplgYsS/6V7ncSoti5y/XDMKNKTiB2KFeMJlbEdNkuRvszwD09vKFbbNw9LCvVXB
         cizQCnp0a3NF6GLmIjrCG1CRmCPftJnhgPmSUoU5yu3qNCNDHAUbZuRS7DCfUyoe4AVd
         XdYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=peU3m6xX748JtFgTX4y7BDRBSLamYXJGhioH1D/Rhfc=;
        b=DfSh8tE8Tbeef5tcunb0esbSJBgirPwJZKyofQTQgW58UAef3CrezLUjEJ06tflZFA
         W6iHrFspQ1wXnvxWg507mBfsqYInZb6K/xZ9c6ayHhdfsF/xGQbTjKlMRHM1Iu1KZkEh
         A6yo8wbNtNHvwrueNMmN4MoM6vqhdMb8TgetnyiRaOWp2KaK/hEndHkcuJHDTm1jn4eL
         nKU9cArQDqeJ8q5QsEtUbfppHwO/QrTA+0yAY2KGXXkTHpEVySV+CW+qTT8vprDQnBLi
         VOmuD2sKAS3STAW+Cl7RhtVWl6ePZJtuzNnqNe1+8SkFAes6SQEux+roCDMN9Fsyid8X
         gpgQ==
X-Gm-Message-State: AOAM531Qo92hh3q+dFiqJ+51AdoDcXnHdQpcpzQ7tm1Eq1uiItnY0tdm
        ufK1a2ugcSz2AMyh+EC0LSAg0X135PyQgg==
X-Google-Smtp-Source: ABdhPJzRAiZG5f+epTr97aydrRVocpUScAJamCoC4moYu0vS4nITd9GD0VPv4gPmdqtwkxgRGs3N4A==
X-Received: by 2002:aa7:8889:0:b0:4fd:aae0:a94c with SMTP id z9-20020aa78889000000b004fdaae0a94cmr21686694pfe.76.1649037161245;
        Sun, 03 Apr 2022 18:52:41 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id pi2-20020a17090b1e4200b001c7b15928e0sm19640856pjb.23.2022.04.03.18.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 18:52:40 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, omosnace@redhat.com
Subject: [PATCH net] sctp: use the correct skb for security_sctp_assoc_request
Date:   Sun,  3 Apr 2022 21:52:31 -0400
Message-Id: <a77a584b3ce9761eb5dda5828192e1cab94571f0.1649037151.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yi Chen reported an unexpected sctp connection abort, and it occurred when
COOKIE_ECHO is bundled with DATA Fragment by SCTP HW GSO. As the IP header
is included in chunk->head_skb instead of chunk->skb, it failed to check
IP header version in security_sctp_assoc_request().

According to Ondrej, SELinux only looks at IP header (address and IPsec
options) and XFRM state data, and these are all included in head_skb for
SCTP HW GSO packets. So fix it by using head_skb when calling
security_sctp_assoc_request() in processing COOKIE_ECHO.

Fixes: e215dab1c490 ("security: call security_sctp_assoc_request in sctp_sf_do_5_1D_ce")
Reported-by: Yi Chen <yiche@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_statefuns.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 7f342bc12735..883f9b849ee5 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -781,7 +781,7 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
 		}
 	}
 
-	if (security_sctp_assoc_request(new_asoc, chunk->skb)) {
+	if (security_sctp_assoc_request(new_asoc, chunk->head_skb ?: chunk->skb)) {
 		sctp_association_free(new_asoc);
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 	}
@@ -2262,7 +2262,7 @@ enum sctp_disposition sctp_sf_do_5_2_4_dupcook(
 	}
 
 	/* Update socket peer label if first association. */
-	if (security_sctp_assoc_request(new_asoc, chunk->skb)) {
+	if (security_sctp_assoc_request(new_asoc, chunk->head_skb ?: chunk->skb)) {
 		sctp_association_free(new_asoc);
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 	}
-- 
2.31.1

