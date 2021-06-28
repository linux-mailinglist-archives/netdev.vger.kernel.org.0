Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157893B68E9
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 21:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236221AbhF1TQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 15:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236157AbhF1TQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 15:16:23 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E27BC061574;
        Mon, 28 Jun 2021 12:13:56 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id y17so4010915pgf.12;
        Mon, 28 Jun 2021 12:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RAjeU+Y5XUPaM8GmdFRhS2j+LHxIZ0Syzo2LSB2N+GE=;
        b=E9gDax0X1YV0YTl7VPUUYqMA61gXcUE1y9WPJa2okracM+ESQfogKY4LvZpdct9Rjr
         pYHeKAagTaqr6fInYpBb794doBaeU3yH5k76uzu/WxUIZNw1e7OS9LCL0t7YcX3XYH3I
         muVVJDRBy15Bt79iXgsmsmiHosBSiUCp290LtcrL/qupKVSWYjG8QtNZ7HDPkiPI45no
         CXd9QHQxG4Bvnmvkt7GVwYEdo4aTeOQrPaKBtfyv4niS48NgO9HUVMyl/BSWFZzujoP+
         HNg7Tg3TXJ2DtrBtV+oprLN2DG/22r5bRNGi/pe5I9c/YKMm/fRzd14YVpGBHDbdJYyB
         OZaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RAjeU+Y5XUPaM8GmdFRhS2j+LHxIZ0Syzo2LSB2N+GE=;
        b=UpCg9553aJvPREAiy9HxCrF5ibnTbMMr9G+nZMjfsNwgjP1qLx+YliTwHjMz49v2qz
         N8qwZhxX2KQn5KpiMhNElAiVzKO5+12BVY50l9Y+PGv1Dmt0mTbABzQxB9tencUiJJXE
         TM+D2KJnPE8OPJ5HhDGYm0Uwijwh72+XL98Hs7QRmt5a7WnxDDRNSJoi6S3XYesg7VTF
         H6kgY35Rp2naV570VmtYLFVwUgLsWRc+8g2uAhQUrZnXLU8FJEsv5qU11dyPgNSd6L2s
         cxgnwVDERElKgrFNA6mYXLYBvYKa0VqD4cJcfyx6zOvMkpBGVnNO1N2hMJ5BUFDl9Ui6
         88JQ==
X-Gm-Message-State: AOAM532abXCPjtApGZoufUxFAdRDvpxSkJSgi8PDx+Om2JLOwvBlTavl
        5KY75NyYeUNvE0uegxqsUCo=
X-Google-Smtp-Source: ABdhPJw0RQD23WBcFluZFa6YPjMMRKUkBEPMJCyrh/uwkCTn1IXBVb79L022yfoQUV+aWTM/mTTabg==
X-Received: by 2002:a62:8286:0:b029:2fc:812d:2e70 with SMTP id w128-20020a6282860000b02902fc812d2e70mr21915448pfd.24.1624907636121;
        Mon, 28 Jun 2021 12:13:56 -0700 (PDT)
Received: from horizon.localdomain ([177.220.172.71])
        by smtp.gmail.com with ESMTPSA id c14sm15226806pgv.86.2021.06.28.12.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 12:13:54 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 2E148C13E5; Mon, 28 Jun 2021 16:13:52 -0300 (-03)
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-sctp@vger.kernel.org,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Xin Long <lucien.xin@gmail.com>
Subject: [PATCH net 2/4] sctp: add size validation when walking chunks
Date:   Mon, 28 Jun 2021 16:13:42 -0300
Message-Id: <1f204ae1a2b2dfe6ea49fd9fdd583a4d02a70542.1624904195.git.marcelo.leitner@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1624904195.git.marcelo.leitner@gmail.com>
References: <cover.1624904195.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first chunk in a packet is ensured to be present at the beginning of
sctp_rcv(), as a packet needs to have at least 1 chunk. But the second
one, may not be completely available and ch->length can be over
uninitialized memory.

Fix here is by only trying to walk on the next chunk if there is enough to
hold at least the header, and then proceed with the ch->length validation
that is already there.

Reported-by: Ilja Van Sprundel <ivansprundel@ioactive.com>
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index 8924e2e142c8234dac233e56e923110e266c9834..f72bff93745c44be0dbfa29e754f2872a7d874c2 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -1247,7 +1247,7 @@ static struct sctp_association *__sctp_rcv_walk_lookup(struct net *net,
 
 		ch = (struct sctp_chunkhdr *)ch_end;
 		chunk_num++;
-	} while (ch_end < skb_tail_pointer(skb));
+	} while (ch_end + sizeof(*ch) < skb_tail_pointer(skb));
 
 	return asoc;
 }
-- 
2.31.1

