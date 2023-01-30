Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF7ED681646
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 17:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236652AbjA3QZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 11:25:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235891AbjA3QZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 11:25:37 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF523B0C5;
        Mon, 30 Jan 2023 08:25:36 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id o5so10513839qtr.11;
        Mon, 30 Jan 2023 08:25:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=t1Lofa+1gMMiJHccJk+sMJ3ZPMPxoWE/XN7foApWXHM=;
        b=S+OEVHB7eC+gLbOGk0sGAq4K2qzCssrIdv3u+QqZ1qkgk1BhHfGpTSAlJQmFOsBcBX
         wlkOTkHC8Uu0v0bJZeQMgSIsnPAWtdELKPm51LspyPOKjdQbYijDCChAwkEt75jPGaST
         OEz2SmDtQ6M3QQ1kGHFLzVBTxkYUYGpvhjCcqZJsUxTLyYysRALQ3JBhTKd0bdHROIBB
         WlVeovtQMgs9IviXRVX3Ok++rg1LUFgnwO8aUGvpQsTUx1Lzi7FbSE4z2X0L8PVSkadg
         xBsPEuaDREBoAnIm3qPHxf70zjwY4zlEQTJKLMlW2ilSZzlRehwT3+jE2HWNUbJn0Zpx
         hjiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t1Lofa+1gMMiJHccJk+sMJ3ZPMPxoWE/XN7foApWXHM=;
        b=M7suXrWamC1bcpbcJgYYCaGIMfZ6OcZEyF5eqaSulwmevPwPmVuQAQRo/9z/AnM7mS
         PI3SOhrI7BGx/T3wmpOWN7cJ6czqe/CWnzhAD2X7+UzcwxyIOjXSR9y6eIIT9NZ4Ah2O
         oXQYWBxRjFYQsPHvmMD0r8ww7ChLfLatu3KaejY/DBFHs2Bb5MMI4ZufOfJu/DnFj+Xe
         fKt0oD9E2eaJJD/wZ7eIbEAEnfw9nF9jVpEVpWGJoCRpP4TG53MOjRfhtzXL4lpo+1in
         CafZ9gefqiyABJ1D77PMcGqoV7zqqEFqttqi//JkbLUmCKw91Ww/OZgc14z0wGxUPBwd
         4MSw==
X-Gm-Message-State: AFqh2krEC1uFbJev7nDUaqaCxy2H7EiqFT189HublyXgEN5f0NRwg8Ps
        XZBRrqoY2+R5ZYtZotiCQM1j5E1M8qP6Dw==
X-Google-Smtp-Source: AMrXdXvYFJNieNtdvtaGOzfmmibEXFTe9uKNy5wmYBXatcz73lwjpQDR0yoqrR7GCk5ZZf4f1AopRA==
X-Received: by 2002:ac8:70da:0:b0:39c:da21:6bb3 with SMTP id g26-20020ac870da000000b0039cda216bb3mr72862066qtp.56.1675095935109;
        Mon, 30 Jan 2023 08:25:35 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id s39-20020a05622a1aa700b003a7e38055c9sm8298660qtc.63.2023.01.30.08.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 08:25:34 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH net] sctp: do not check hb_timer.expires when resetting hb_timer
Date:   Mon, 30 Jan 2023 11:25:33 -0500
Message-Id: <d958c06985713ec84049a2d5664879802710179a.1675095933.git.lucien.xin@gmail.com>
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

It tries to avoid the frequently hb_timer refresh in commit ba6f5e33bdbb
("sctp: avoid refreshing heartbeat timer too often"), and it only allows
mod_timer when the new expires is after hb_timer.expires. It means even
a much shorter interval for hb timer gets applied, it will have to wait
until the current hb timer to time out.

In sctp_do_8_2_transport_strike(), when a transport enters PF state, it
expects to update the hb timer to resend a heartbeat every rto after
calling sctp_transport_reset_hb_timer(), which will not work as the
change mentioned above.

The frequently hb_timer refresh was caused by sctp_transport_reset_timers()
called in sctp_outq_flush() and it was already removed in the commit above.
So we don't have to check hb_timer.expires when resetting hb_timer as it is
now not called very often.

Fixes: ba6f5e33bdbb ("sctp: avoid refreshing heartbeat timer too often")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/transport.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index ca1eba95c293..2f66a2006517 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -196,9 +196,7 @@ void sctp_transport_reset_hb_timer(struct sctp_transport *transport)
 
 	/* When a data chunk is sent, reset the heartbeat interval.  */
 	expires = jiffies + sctp_transport_timeout(transport);
-	if ((time_before(transport->hb_timer.expires, expires) ||
-	     !timer_pending(&transport->hb_timer)) &&
-	    !mod_timer(&transport->hb_timer,
+	if (!mod_timer(&transport->hb_timer,
 		       expires + get_random_u32_below(transport->rto)))
 		sctp_transport_hold(transport);
 }
-- 
2.31.1

