Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85640626B2
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390300AbfGHQ50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:57:26 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33307 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbfGHQ50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 12:57:26 -0400
Received: by mail-pl1-f195.google.com with SMTP id c14so8571403plo.0;
        Mon, 08 Jul 2019 09:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=J4OJZdhcQEG0MbDrJj/LSJpyms+lpBysF1BbA2oLwkM=;
        b=p5EkuIVXD690Iz5XRGcvvC052Pfx/s42V5yagSqzMmpuK9LiIl86aGQYukj1tTjgyf
         Y/Uc5Q5GX9Yn1ANX6TUnRDKyQKdTikst2HWL4odmY2yU4fX4kiD06PB9F7Jbk19H0FGf
         jkB4ekj6s/7s7On19+muVsc8CqZXuZSWFwA5lpxQyW4tczgrJr72TkFzGt4a2y+8qJ+u
         2KDBR7NB5bOcMIm8jLAfJ9i/p3gQjGvp8mPo38PW60X9XT5Y7reW385cPrSqi2ylz3B1
         gey2YvYzk7FP8WuLccnGUMQjrFq7MWznpYrlFebSQT4Lk339xAoVu19Kre3Byfp7/Yft
         GWDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=J4OJZdhcQEG0MbDrJj/LSJpyms+lpBysF1BbA2oLwkM=;
        b=Q5mAFieTrmLTDHrGd2cSVPGSZOwxR7dwoyzcLIvTXCJTey2YDWEalWosOIgEkojf5a
         iOgZPxE5bY/GbRDPvfjBZRSuSEkIaof+srdFUacfFuQ6gF4280G+LVFzXU29DfwwXcZX
         OcI2lFMFMwjhjvToPC7Blr9EOlyda7RvnGTynS16UlBav9LkQbkkyapEBoUNwLUS5BqO
         6CscbBt4iOkj5bqQKtQxzwSFNblAhnp1JRN1waE3PttFIDU4QJuWF5PPfR1EKVuwzemB
         d37/FNrrCJmaiN3j73Q5aB2PKDnELZsRK4h9VGp/WNp6cG1jywrrQnj1m5yZnBT6QyoX
         g9Iw==
X-Gm-Message-State: APjAAAXRjjPn748LOaAfJAkEOU1X610FS7i6yTU9tmZr7Yyj/zRYH6NR
        xEmOVC0g3URVc0PtjH+/D0zIZsoa
X-Google-Smtp-Source: APXvYqyX8xIhnhWn9UL6Z1oQM+kL0Tp+Qle9nA7SIQBSpUduFxVCr3IMNcdL5/9qRYn4k/7gdZys4A==
X-Received: by 2002:a17:902:3283:: with SMTP id z3mr26307605plb.176.1562605044783;
        Mon, 08 Jul 2019 09:57:24 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q8sm112967pjq.20.2019.07.08.09.57.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 09:57:24 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCH net-next 1/4] sctp: remove reconf_enable from asoc
Date:   Tue,  9 Jul 2019 00:57:04 +0800
Message-Id: <988dac46cfecb6ae4fa21e40bf16da6faf3da6ab.1562604972.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1562604972.git.lucien.xin@gmail.com>
References: <cover.1562604972.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1562604972.git.lucien.xin@gmail.com>
References: <cover.1562604972.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

asoc's reconf support is actually decided by the 4-shakehand negotiation,
not something that users can set by sockopt. asoc->peer.reconf_capable is
working for this. So remove it from asoc.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h | 3 +--
 net/sctp/associola.c       | 1 -
 net/sctp/sm_make_chunk.c   | 5 ++---
 net/sctp/socket.c          | 7 ++-----
 4 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 0767701..d9e0e1a 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -2051,8 +2051,7 @@ struct sctp_association {
 	     temp:1,		/* Is it a temporary association? */
 	     force_delay:1,
 	     intl_enable:1,
-	     prsctp_enable:1,
-	     reconf_enable:1;
+	     prsctp_enable:1;
 
 	__u8 strreset_enable;
 	__u8 strreset_outstanding; /* request param count on the fly */
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 1999237..321c199 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -262,7 +262,6 @@ static struct sctp_association *sctp_association_init(
 
 	asoc->active_key_id = ep->active_key_id;
 	asoc->prsctp_enable = ep->prsctp_enable;
-	asoc->reconf_enable = ep->reconf_enable;
 	asoc->strreset_enable = ep->strreset_enable;
 
 	/* Save the hmacs and chunks list into this association */
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 9b0e5b0..d784dc1 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -261,7 +261,7 @@ struct sctp_chunk *sctp_make_init(const struct sctp_association *asoc,
 		num_ext += 2;
 	}
 
-	if (asoc->reconf_enable) {
+	if (asoc->ep->reconf_enable) {
 		extensions[num_ext] = SCTP_CID_RECONF;
 		num_ext += 1;
 	}
@@ -2007,8 +2007,7 @@ static void sctp_process_ext_param(struct sctp_association *asoc,
 	for (i = 0; i < num_ext; i++) {
 		switch (param.ext->chunks[i]) {
 		case SCTP_CID_RECONF:
-			if (asoc->reconf_enable &&
-			    !asoc->peer.reconf_capable)
+			if (asoc->ep->reconf_enable)
 				asoc->peer.reconf_capable = 1;
 			break;
 		case SCTP_CID_FWD_TSN:
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 39ea0a3..0424876 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4226,10 +4226,7 @@ static int sctp_setsockopt_reconfig_supported(struct sock *sk,
 	    sctp_style(sk, UDP))
 		goto out;
 
-	if (asoc)
-		asoc->reconf_enable = !!params.assoc_value;
-	else
-		sctp_sk(sk)->ep->reconf_enable = !!params.assoc_value;
+	sctp_sk(sk)->ep->reconf_enable = !!params.assoc_value;
 
 	retval = 0;
 
@@ -7554,7 +7551,7 @@ static int sctp_getsockopt_reconfig_supported(struct sock *sk, int len,
 		goto out;
 	}
 
-	params.assoc_value = asoc ? asoc->reconf_enable
+	params.assoc_value = asoc ? asoc->peer.reconf_capable
 				  : sctp_sk(sk)->ep->reconf_enable;
 
 	if (put_user(len, optlen))
-- 
2.1.0

