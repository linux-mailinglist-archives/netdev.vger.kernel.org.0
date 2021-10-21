Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E4443666B
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 17:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbhJUPlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 11:41:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40526 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230072AbhJUPlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 11:41:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634830732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+EcsA5xA62SASzXixhmC93KNhr9lJl6sDYMGeSe6uVI=;
        b=D6Gg8/o2Ev85P5N2Whq6fjEmuW9R2L6JxpdKNSugwNk6XzSMZBeecTaAEPnK2bneouEiLN
        B5Iuj1zvXXQjYI6y9+GoW+LPM0Jp/IyY1Gdqvto8snuXLkdLY6rRdgOM3eI4VMg4axXnaO
        er4j5y9/robtFrP8KOxine3Ef4XV7Yk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-qiLlLiIGPquRbJRhNChcgw-1; Thu, 21 Oct 2021 11:38:49 -0400
X-MC-Unique: qiLlLiIGPquRbJRhNChcgw-1
Received: by mail-ed1-f69.google.com with SMTP id g28-20020a50d0dc000000b003dae69dfe3aso778346edf.7
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 08:38:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+EcsA5xA62SASzXixhmC93KNhr9lJl6sDYMGeSe6uVI=;
        b=CTvnLgj1+Y49Oa01cUcILQJJiG1MHIoj1kEojmeImoQv3S90QaVuH1cchU9Itg6jl5
         VzpzhFwUV5rySHFn9c4fn+CWMkljSbk/OJ32bgNFxOc8g0zJw0Ajt/RVI/r1AhXswjMm
         tvZSOuyS6W87roRKfna81HDMO77YFWxaZqo3zWn/LGtRHSipvcDFUfQVXIj28h+vgt4O
         PIpUiZUmxSH1DP9S76DWURIQsgXp2a8oAcqBReP1VCsn313fPrNcMpua6e64GHJJYTlz
         nRkTSgJSUxlj7gTLMDs2GCevE6ZDj4+S7j/QsKAwG2MRB6jDcCdhkzonNAz+yts8dLqy
         pKKw==
X-Gm-Message-State: AOAM532s19bTbVJ26fXca0Aold0OG9PXpI6gcl3bxAJle+PC6tzUTqRG
        Y0Y9hbIxUmt983VfkvwgWgufDWT7rvK+g5Mg6PmSbsmqcHDpvKHreZLe5Ax+iDVrmkJZrbC0E2s
        d9afJ+U6Ukfqke3rL
X-Received: by 2002:a17:906:2f16:: with SMTP id v22mr8071843eji.126.1634830728417;
        Thu, 21 Oct 2021 08:38:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyZR+CO01yUtF69fE5uCzw+dfcRHloUejfPdnzpavQSqGCijkHMjiG35GlcCLD4jjcVPR+jBw==
X-Received: by 2002:a17:906:2f16:: with SMTP id v22mr8071810eji.126.1634830728139;
        Thu, 21 Oct 2021 08:38:48 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id j11sm2659826ejt.114.2021.10.21.08.38.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 08:38:47 -0700 (PDT)
From:   Ondrej Mosnacek <omosnace@redhat.com>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        selinux@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Richard Haines <richard_c_haines@btinternet.com>
Subject: [PATCH] sctp: initialize endpoint LSM labels also on the client side
Date:   Thu, 21 Oct 2021 17:38:46 +0200
Message-Id: <20211021153846.745289-1-omosnace@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The secid* fields in struct sctp_endpoint are used to initialize the
labels of a peeloff socket created from the given association. Currently
they are initialized properly when a new association is created on the
server side (upon receiving an INIT packet), but not on the client side.

As a result, when the client obtains a peeloff socket via
sctp_peeloff(3) under SELinux, it ends up unlabeled, leading to
unexpected denials.

Fix this by calling the security_sctp_assoc_request() hook also upon
receiving a valid INIT-ACK response from the server, so that the
endpoint labels are properly initialized also on the client side.

Fixes: 2277c7cd75e3 ("sctp: Add LSM hooks")
Cc: Richard Haines <richard_c_haines@btinternet.com>
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
---
 include/net/sctp/structs.h | 11 ++++++-----
 net/sctp/sm_statefuns.c    |  5 +++++
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 651bba654d77..033a955592dd 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1356,11 +1356,12 @@ struct sctp_endpoint {
 
 	__u8  strreset_enable;
 
-	/* Security identifiers from incoming (INIT). These are set by
-	 * security_sctp_assoc_request(). These will only be used by
-	 * SCTP TCP type sockets and peeled off connections as they
-	 * cause a new socket to be generated. security_sctp_sk_clone()
-	 * will then plug these into the new socket.
+	/* Security identifiers from incoming (INIT/INIT-ACK). These
+	 * are set by security_sctp_assoc_request(). These will only
+	 * be used by SCTP TCP type sockets and peeled off connections
+	 * as they cause a new socket to be generated.
+	 * security_sctp_sk_clone() will then plug these into the new
+	 * socket.
 	 */
 
 	u32 secid;
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 32df65f68c12..cb291c7f5fb7 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -521,6 +521,11 @@ enum sctp_disposition sctp_sf_do_5_1C_ack(struct net *net,
 	if (!sctp_vtag_verify(chunk, asoc))
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
+	/* Update socket peer label if first association. */
+	if (security_sctp_assoc_request((struct sctp_endpoint *)ep,
+					chunk->skb))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	/* 6.10 Bundling
 	 * An endpoint MUST NOT bundle INIT, INIT ACK or
 	 * SHUTDOWN COMPLETE with any other chunks.
-- 
2.31.1

