Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF5D5A5A9C
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 17:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbfIBPcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 11:32:21 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36985 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbfIBPcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 11:32:20 -0400
Received: by mail-pl1-f195.google.com with SMTP id b10so1638082plr.4;
        Mon, 02 Sep 2019 08:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=DiW9yVqBhWtRauUiW8YsGQd2zREZ2Dy2UGJg4F1V4Kc=;
        b=JN4BtcDbFTrT7YoD/epUyxP4L5CK3fduvI4vHti124nm4e6AlfVK5B+S+IZuLqxmqs
         qTU2dXLp7kM+gVpVwc0PshD6CV2pZzypFPTTNYBlpPdzD2lDOQ0hDBO2F4MoDNsavAG+
         +zln+sXfiK8du5hT5Q8kQ1MWfvL//YWU3oGNLSn5OPYFySUKBFz8rWRWqkoKCQlhVy3f
         ZTAHVQOyKfYH47JgcGNqrZM19jKNaCg0UCXXcb/GkBP2mCHEXs8Qs37fAcJ9G4UXJTZ8
         f8u1rdii+5bIOuTT2yCdj6Yi7z4Cu7L5jxbxkfBdHFf224VOoEqsM8bgaaxxhvJM0IiW
         xrxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DiW9yVqBhWtRauUiW8YsGQd2zREZ2Dy2UGJg4F1V4Kc=;
        b=OsduZQ6qqd5S31SvMWWevXT9OUKJ5QNLHw7UpkuQS0v67miP45QEK2eDay+xr6olSr
         C8X/t1+58lQFh048wGHQ2quzYSeYBiiFSNWwDJqgl3R368x9KtDCdpOPUudB0oulXsTj
         YzKWZYmmrg3TUh5Hl+BlWA7EDtGga0ErfuBRMl4ls9jZE7v3rS0amBcOE2WnitPXx68M
         IWw4W49fqkRf2VIWkS7fC8nqdFr+y+1MvX9tS/G3T63Y5SBmn9iFUBBB8+n5JgT0xzDw
         Y1s3rqajmKNvxymw78IWeQVOyB+YogfkcVScEZA7joWA0nyqJ6vY2kEFHS6+w3cM/8+5
         Y4ZQ==
X-Gm-Message-State: APjAAAXmDaJ+cSz/HAo8EXHfiU3CWcWOPg3V+g1Jfmxf6j3VXhzijH5+
        VOXqvIN00bb5ZlD5X4eGViogM2Gf
X-Google-Smtp-Source: APXvYqxMPO/2/ja3HR40TFWVz0/0N9BJfldM3TkPlwH/ZOLXsJmBlRflxvDz5YdCKAkmaFRMPvwiNw==
X-Received: by 2002:a17:902:7592:: with SMTP id j18mr29946188pll.186.1567437870043;
        Mon, 02 Sep 2019 08:24:30 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o129sm17524400pfg.1.2019.09.02.08.24.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Sep 2019 08:24:29 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH net] sctp: use transport pf_retrans in sctp_do_8_2_transport_strike
Date:   Mon,  2 Sep 2019 23:24:21 +0800
Message-Id: <41769d6033d27d629798e060671a3b21f22e2a21.1567437861.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Transport should use its own pf_retrans to do the error_count
check, instead of asoc's. Otherwise, it's meaningless to make
pf_retrans per transport.

Fixes: 5aa93bcf66f4 ("sctp: Implement quick failover draft from tsvwg")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_sideeffect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 1cf5bb5..e52b212 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -547,7 +547,7 @@ static void sctp_do_8_2_transport_strike(struct sctp_cmd_seq *commands,
 	if (net->sctp.pf_enable &&
 	   (transport->state == SCTP_ACTIVE) &&
 	   (transport->error_count < transport->pathmaxrxt) &&
-	   (transport->error_count > asoc->pf_retrans)) {
+	   (transport->error_count > transport->pf_retrans)) {
 
 		sctp_assoc_control_transport(asoc, transport,
 					     SCTP_TRANSPORT_PF,
-- 
2.1.0

