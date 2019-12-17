Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3ED412213C
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 02:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbfLQBBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 20:01:34 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:42534 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbfLQBBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 20:01:33 -0500
Received: by mail-pj1-f65.google.com with SMTP id o11so3767853pjp.9;
        Mon, 16 Dec 2019 17:01:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WTJW9Ivzk5hRbe09ReOHLigQO4MTulCH6iX48/5aFlI=;
        b=A1gNJR7/wb+DHKDZ4diBI7qh8o7kRNr9Ys0wUBo38OIxTIYY+tiGSwm1PrRQZJ0JdK
         zP4ZMZEeV2Z15b9hWwtfCYYJxgBd1u3XXiUwCK4mJH9y7lcTYsj+pAWz7tJn8XJe2YJp
         2NO/D8dCq921rcZru6aYddXbEzLDffRDZ1AKtnydQctxKnt7bmxGR/EX1Tof8jPQmB8o
         z/8VSJ+Pf7iORkeXiEmibmveJTkGEw25v/bxECKU0y/13eG24ub2qjr/7+yZVCDHXTFi
         vCdc+MzeFCROJi5ANyuzfhIlFhxtCCLU7di2/hQIhA9VkXeVudzn2ewfSlYT/rCR8C5h
         DWQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WTJW9Ivzk5hRbe09ReOHLigQO4MTulCH6iX48/5aFlI=;
        b=Sk37hcstxwplmjIxKFa2pTM2f/1gjSoAEifMSIamhl+5K9cAWoIxWhFuhTw6Wsx7kH
         Z8iycOVXlsk5lZaVrmITeCmlkKzDIXkFgh0avXr4UjyKZvY0k49slaFFVeW67jt/JHc5
         oPGTP6g1ndjZ6WwDNvGVf6hWj0v3rWPDwvFUALtJg2S9Dwlf0bZdTYrCtCXgS23naQP+
         mcbFYmA9whsXy6mXN3QCCAnVt4FTNAAYLjJjxVq/RgVS61CK743MAyRlCkRgqYsq9T7F
         JiBljXWbI5DcrJjEqA1feHRN/1sZITUkCfuDSowq1T+dWFgnbqf/25cINF9y1oBh0C6P
         0OHg==
X-Gm-Message-State: APjAAAUQBCDzm7VHI+VouiUPOSnD6L9NYBJ+dCVTehDCn79wsQjIbGr8
        laEyVYCpiPcVte4feLCRh3w=
X-Google-Smtp-Source: APXvYqz0Rrlx4/+4Jy+hIf1QJwF8mKYG67PVSm9bQN7w8aRH2Ea6sEUGrXCqn7VoUUsPL8GDXgk5Xg==
X-Received: by 2002:a17:90b:1115:: with SMTP id gi21mr2787225pjb.95.1576544491991;
        Mon, 16 Dec 2019 17:01:31 -0800 (PST)
Received: from localhost.localdomain ([177.220.172.83])
        by smtp.gmail.com with ESMTPSA id q13sm758706pjc.4.2019.12.16.17.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 17:01:31 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 2B557C0DB9; Mon, 16 Dec 2019 22:01:28 -0300 (-03)
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Xin Long <lucien.xin@gmail.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org
Subject: [PATCH net] sctp: fix memleak on err handling of stream initialization
Date:   Mon, 16 Dec 2019 22:01:16 -0300
Message-Id: <2a040bc8a75c67164a3d0e30726477c1a268c6d7.1576544284.git.marcelo.leitner@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported a memory leak when an allocation fails within
genradix_prealloc() for output streams. That's because
genradix_prealloc() leaves initialized members initialized when the
issue happens and SCTP stack will abort the current initialization but
without cleaning up such members.

The fix here is to always call genradix_free() when genradix_prealloc()
fails, for output and also input streams, as it suffers from the same
issue.

Reported-by: syzbot+772d9e36c490b18d51d1@syzkaller.appspotmail.com
Fixes: 2075e50caf5e ("sctp: convert to genradix")
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/stream.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index df60b5ef24cbf5c6f628ab8ed88a6faaaa422b6d..e0b01bf912b3f3cdbc3f713bcfa50868e4802929 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -84,8 +84,10 @@ static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
 		return 0;
 
 	ret = genradix_prealloc(&stream->out, outcnt, gfp);
-	if (ret)
+	if (ret) {
+		genradix_free(&stream->out);
 		return ret;
+	}
 
 	stream->outcnt = outcnt;
 	return 0;
@@ -100,8 +102,10 @@ static int sctp_stream_alloc_in(struct sctp_stream *stream, __u16 incnt,
 		return 0;
 
 	ret = genradix_prealloc(&stream->in, incnt, gfp);
-	if (ret)
+	if (ret) {
+		genradix_free(&stream->in);
 		return ret;
+	}
 
 	stream->incnt = incnt;
 	return 0;
-- 
2.23.0

