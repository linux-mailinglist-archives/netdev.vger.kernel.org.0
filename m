Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A35C61274C7
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 05:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbfLTErY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 23:47:24 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:35208 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbfLTErX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 23:47:23 -0500
Received: by mail-pj1-f66.google.com with SMTP id s7so3576607pjc.0;
        Thu, 19 Dec 2019 20:47:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aN12zhf4mlcaV2E22of1kpbrgx4U0ucUVjsbOQtDUz4=;
        b=ET8Oh+6fwGiwWp5+wSIhFpTodb5pMe8Q9Lu4rNBzrlmuWs/wkoIsN8eUlDqoIYfZBF
         Ydi9A8CEL6d4MDX3HTpwx0+raVMffPTPCAdm8b9SDzILaMsaygKkTMTDBNlpI+/Np7HR
         avi/LhBdaTZW8RBs38H8WKyi2K0wgnkWpUVZSBJMJvGU/Jjm6v2vMNZ8H8tsbkd99GSl
         s23Pv9rKa0/ZH3JSoef9xVsUBCxT1zp7POKFZXiHEx7aBkByeGJQkjgcpPSDzohzkmvk
         PVNtF+XPTdnGK2u7l1ldy1JbynIJMKduFYcPK4calelYcfzfdzHFQwO8dHnaWGCRXp+3
         Un9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aN12zhf4mlcaV2E22of1kpbrgx4U0ucUVjsbOQtDUz4=;
        b=TGkhsxjg2R7BfekxCSjSFp4px+fUFbK/W9arGLnTuCtjFRtj4Mll2G6JjzWtPIe2yT
         v4hEGCNk+f0rAIbaAWNtD7jqRuBBeNVOma47wiN5/yFLFRRkitaRuwYwDtMhjXl8r41R
         eO/auCP60FvR+Z2WBL1oqc6wVbzoRxABMfZ5Qsz2hPUnLXsOmMk62OjbF5h5V4AKjOl2
         eU6Z9MGasPCclgNo1IXiQX+4OR5TlDpNrwuW0yve2vo0BkcMlVcrTlvlK69qvY3VHpn/
         NPWozj5cFD2guAZ31/8xT4Vp4ATNzT0evFOTOYVfeIzgKdQRNG69L+PlovAbxyFM+szG
         9R5A==
X-Gm-Message-State: APjAAAWGViT8KINQNAtJB7Rit+nS+tQlJY3yoGENxgg6MjykxavQbyD+
        GwDAtDIkcDbVS7/PMvGQdzQ=
X-Google-Smtp-Source: APXvYqyv2IK999RPM2ym3Yanh5DI+R4t8BSC5a74wES6xt7xZmhV0ugy6lV0u9RfbCSBd7GObf74jg==
X-Received: by 2002:a17:902:6906:: with SMTP id j6mr7693199plk.321.1576817242890;
        Thu, 19 Dec 2019 20:47:22 -0800 (PST)
Received: from CV0038107N9.nsn-intra.net ([2408:84e4:400:2e74:469:cb33:67e2:581f])
        by smtp.gmail.com with ESMTPSA id u26sm10089189pfn.46.2019.12.19.20.47.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Dec 2019 20:47:22 -0800 (PST)
From:   Kevin Kou <qdkevin.kou@gmail.com>
To:     vyasevich@gmail.com
Cc:     nhorman@tuxdriver.com, marcelo.leitner@gmail.com,
        davem@davemloft.net, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        qdkevin.kou@gmail.com
Subject: [PATCH] sctp: do trace_sctp_probe after SACK validation and check
Date:   Fri, 20 Dec 2019 04:47:03 +0000
Message-Id: <20191220044703.88-1-qdkevin.kou@gmail.com>
X-Mailer: git-send-email 2.23.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function sctp_sf_eat_sack_6_2 now performs
the Verification Tag validation, Chunk length validation, Bogu check,
and also the detection of out-of-order SACK based on the RFC2960
Section 6.2 at the beginning, and finally performs the further
processing of SACK. The trace_sctp_probe now triggered before
the above necessary validation and check.

This patch is to do the trace_sctp_probe after the necessary check
and validation to SACK.

Signed-off-by: Kevin Kou <qdkevin.kou@gmail.com>
---
 net/sctp/sm_statefuns.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 42558fa..b4a54df 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -3281,7 +3281,6 @@ enum sctp_disposition sctp_sf_eat_sack_6_2(struct net *net,
 	struct sctp_sackhdr *sackh;
 	__u32 ctsn;
 
-	trace_sctp_probe(ep, asoc, chunk);
 
 	if (!sctp_vtag_verify(chunk, asoc))
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
@@ -3319,6 +3318,8 @@ enum sctp_disposition sctp_sf_eat_sack_6_2(struct net *net,
 	if (!TSN_lt(ctsn, asoc->next_tsn))
 		return sctp_sf_violation_ctsn(net, ep, asoc, type, arg, commands);
 
+	trace_sctp_probe(ep, asoc, chunk);
+
 	/* Return this SACK for further processing.  */
 	sctp_add_cmd_sf(commands, SCTP_CMD_PROCESS_SACK, SCTP_CHUNK(chunk));
 
-- 
1.8.3.1

