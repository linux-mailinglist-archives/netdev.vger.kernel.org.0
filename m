Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2CAF1281D0
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 19:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbfLTSDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 13:03:52 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45240 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727391AbfLTSDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 13:03:51 -0500
Received: by mail-pg1-f194.google.com with SMTP id b9so5288770pgk.12;
        Fri, 20 Dec 2019 10:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FAEvr8klz2XDkzltwC8mw+zAPjrSB24j/93vCNbDxvw=;
        b=Dextb+QY7pv8zH/1Yb/fwMsFL0ffNyb5CwyHy2WWf/BYVwp3WYfDVdBojSxCrP+DLp
         6OulupzbVeqBFHtDcds4xY8JZscl4JxXmVTRCwiZvR3V6tVcd+drvLm/uqboDJWF9BjH
         LULBLh8Xhb2Jz376JVPRBKgJ036ZcTkEC1F198Vj9pjC3b42OM+2aXvU0IQ/PzfrfgYC
         MNpaUoHcTAG01JsqgqY6HHKkRPmWnh04Y2qRnPzLG+y0plLC4ckBXNL3xvzKVK4La5E6
         7/pfk1t8pxNm6YNy5A5D8G1MrDlRYC7e99EzC0N0UqtaID1MEF3wYamR9ggtizg+Lasu
         aAgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FAEvr8klz2XDkzltwC8mw+zAPjrSB24j/93vCNbDxvw=;
        b=Pgthyxae5KDkvJ3cRLCbe8vYOB0LV11i0rfkSrkrHyre1cQuBGRQrBGP3Y8n96IX6h
         SJDAn08/LTExrhy/V1KXZqTPmudMR8tYeQwnrDeB8AOc07soQ6+uQ8kBev/jLABDSa65
         xZBGV8dwXd3cL8iVeZVakLHDqvaHkyjiduy2KfrKIHV7QJvEWoUpZz+tX4AwitXqAh4V
         QnPopAegY+51QGu3D4BklqNuRtW8np/evZ3Lo8zDzcXf9oguvTCATaXY4N3CEPa/ymOZ
         /B4UQL/pUSLrkKWdC51b30sgacC9IlzGrXbcIR5OR1h0pj8SVVK/o9uiRD6Z7kwlO4sC
         j/hw==
X-Gm-Message-State: APjAAAVFSU8WpUmOtt4qcuCU6hPQX08kCSYXkoR+S5oelPQK1hLQa9+4
        effPkTjakLMNovELLuUWl2Ul0PVRXeE=
X-Google-Smtp-Source: APXvYqz8+1UwgAt4RmU4j7QYjfpI/cy9IUCOHH3KG02F9jIZio8vCJRDA6JcbTcfPsSUMVnjMg1NGg==
X-Received: by 2002:aa7:8b17:: with SMTP id f23mr17825121pfd.197.1576865030820;
        Fri, 20 Dec 2019 10:03:50 -0800 (PST)
Received: from localhost.localdomain ([2001:1284:f013:b9c8:9c5e:a64b:e068:9fbd])
        by smtp.gmail.com with ESMTPSA id d26sm11845840pgv.66.2019.12.20.10.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 10:03:50 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id DF9EDC161F; Fri, 20 Dec 2019 15:03:46 -0300 (-03)
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org,
        Xin Long <lucien.xin@gmail.com>,
        syzbot <syzbot+9a1bc632e78a1a98488b@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com
Subject: [PATCH net] sctp: fix err handling of stream initialization
Date:   Fri, 20 Dec 2019 15:03:44 -0300
Message-Id: <d41d8475f8485f571152b3f3716d7f474b5c0e79.1576864893.git.marcelo.leitner@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fix on 951c6db954a1 fixed the issued reported there but introduced
another. When the allocation fails within sctp_stream_init() it is
okay/necessary to free the genradix. But it is also called when adding
new streams, from sctp_send_add_streams() and
sctp_process_strreset_addstrm_in() and in those situations it cannot
just free the genradix because by then it is a fully operational
association.

The fix here then is to only free the genradix in sctp_stream_init()
and on those other call sites  move on with what it already had and let
the subsequent error handling to handle it.

Tested with the reproducers from this report and the previous one,
with lksctp-tools and sctp-tests.

Reported-by: syzbot+9a1bc632e78a1a98488b@syzkaller.appspotmail.com
Fixes: 951c6db954a1 ("sctp: fix memleak on err handling of stream initialization")
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/stream.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index 6a30392068a04bfcefcb14c3d7f13fc092d59cd3..c1a100d2fed39c2d831487e05fcbf5e8d507d470 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -84,10 +84,8 @@ static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
 		return 0;
 
 	ret = genradix_prealloc(&stream->out, outcnt, gfp);
-	if (ret) {
-		genradix_free(&stream->out);
+	if (ret)
 		return ret;
-	}
 
 	stream->outcnt = outcnt;
 	return 0;
@@ -102,10 +100,8 @@ static int sctp_stream_alloc_in(struct sctp_stream *stream, __u16 incnt,
 		return 0;
 
 	ret = genradix_prealloc(&stream->in, incnt, gfp);
-	if (ret) {
-		genradix_free(&stream->in);
+	if (ret)
 		return ret;
-	}
 
 	stream->incnt = incnt;
 	return 0;
@@ -123,7 +119,7 @@ int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
 	 * a new one with new outcnt to save memory if needed.
 	 */
 	if (outcnt == stream->outcnt)
-		goto in;
+		goto handle_in;
 
 	/* Filter out chunks queued on streams that won't exist anymore */
 	sched->unsched_all(stream);
@@ -132,24 +128,28 @@ int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
 
 	ret = sctp_stream_alloc_out(stream, outcnt, gfp);
 	if (ret)
-		goto out;
+		goto out_err;
 
 	for (i = 0; i < stream->outcnt; i++)
 		SCTP_SO(stream, i)->state = SCTP_STREAM_OPEN;
 
-in:
+handle_in:
 	sctp_stream_interleave_init(stream);
 	if (!incnt)
 		goto out;
 
 	ret = sctp_stream_alloc_in(stream, incnt, gfp);
-	if (ret) {
-		sched->free(stream);
-		genradix_free(&stream->out);
-		stream->outcnt = 0;
-		goto out;
-	}
+	if (ret)
+		goto in_err;
+
+	goto out;
 
+in_err:
+	sched->free(stream);
+	genradix_free(&stream->in);
+out_err:
+	genradix_free(&stream->out);
+	stream->outcnt = 0;
 out:
 	return ret;
 }
-- 
2.23.0

