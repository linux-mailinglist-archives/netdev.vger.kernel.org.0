Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBE8658E28
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 00:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbfF0WtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 18:49:03 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45251 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbfF0WtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 18:49:02 -0400
Received: by mail-qt1-f196.google.com with SMTP id j19so4275164qtr.12;
        Thu, 27 Jun 2019 15:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CBL7Iqg7TmTQjdm5GQzSJKEFJ96A3dOqtVJC/dibvRM=;
        b=K5VBM5EzhOIIVp3ueIEhyEHlxH9OKb+ejx/+nlmBtk94ne8EVG04h+gPyVIMycDNVI
         cXN1u2ut4GW9lvrTex8beNfLA6IPT118GBZuGdek5GYnmVuTG8D2hJXkrhsbgOeN7E5M
         jyrh2Voza7+3KUFUzNTOTqISmZF3ktVHzwhzPYw0PW3J7c00BM2CBVAua5xynmXATN92
         hMuswLl5koS2uenr07+0tVVbq6n7PKZnR/0c0ooq2+SJwMs2/JPpYgyhzF/Q13+g3Ylx
         o17NzfNhv/3r/nW4AI2xnCZzwzSHvHeNS5jeTuTcJYElQ1mNOeI+58Iy/JqsAfNxqofD
         ZQ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CBL7Iqg7TmTQjdm5GQzSJKEFJ96A3dOqtVJC/dibvRM=;
        b=DzuGxYbNCyBnzuzHP/yI/qbu/Y3EbvxiXdptaEFQQuJ4gi+pQU/uok0n+AWmbl9k+w
         bSJ/k2wXNqEMejp81LnhmdW0F22QJLy/1YpMPayfLuM670sR82UnkJGUT2VVrJpor09+
         lAqSz0Aao/d6yPOQkPSqDjiuP/Wz/5IHv84szontvRrRiRJj0yNsiCvxc9TDtgqDnVMW
         EUiXi8kSxrOOOqs9ZMLVc+qesFBW9TaLNV5e5VnluQF/NQlHfCNQfD4opr5jT4HHxK2m
         TBUBjX1HR5+l0Jt6s/oBDW/aBElq6sl9iyKWxaft9xvyVoAGueM1bTjgBp1/T1mYDNwg
         Bbhw==
X-Gm-Message-State: APjAAAXA+ejYaAwApcMYVF4ZvVAgq0SJI0y2Rpy3Ip5tSXF/Bz4IZxd0
        bHbefdVmYRQ5sxv16AV2Xyc=
X-Google-Smtp-Source: APXvYqw7rfpi2+0ancH0LkDPrQowsR9VX1tzNQadBi2CNPlrUB5KOXprL+MtCo7I2qd38XsumwkaTg==
X-Received: by 2002:a0c:9214:: with SMTP id a20mr5416764qva.195.1561675741780;
        Thu, 27 Jun 2019 15:49:01 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:1699:3b71:f1f7:949e:f780])
        by smtp.gmail.com with ESMTPSA id m44sm230434qtm.54.2019.06.27.15.49.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 15:49:01 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id D0ECFC3B91; Thu, 27 Jun 2019 19:48:58 -0300 (-03)
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Xin Long <lucien.xin@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        linux-sctp@vger.kernel.org, Hillf Danton <hdanton@sina.com>
Subject: [PATCH net] sctp: fix error handling on stream scheduler initialization
Date:   Thu, 27 Jun 2019 19:48:10 -0300
Message-Id: <bcbc85604e53843a731a79df620d5f92b194d085.1561675505.git.marcelo.leitner@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It allocates the extended area for outbound streams only on sendmsg
calls, if they are not yet allocated.  When using the priority
stream scheduler, this initialization may imply into a subsequent
allocation, which may fail.  In this case, it was aborting the stream
scheduler initialization but leaving the ->ext pointer (allocated) in
there, thus in a partially initialized state.  On a subsequent call to
sendmsg, it would notice the ->ext pointer in there, and trip on
uninitialized stuff when trying to schedule the data chunk.

The fix is undo the ->ext initialization if the stream scheduler
initialization fails and avoid the partially initialized state.

Although syzkaller bisected this to commit 4ff40b86262b ("sctp: set
chunk transport correctly when it's a new asoc"), this bug was actually
introduced on the commit I marked below.

Reported-by: syzbot+c1a380d42b190ad1e559@syzkaller.appspotmail.com
Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
Tested-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/stream.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index 93ed07877337eace4ef7f4775dda5868359ada37..25946604af85c09917e63e5c4a8d7d6fa2caebc4 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -153,13 +153,20 @@ int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
 int sctp_stream_init_ext(struct sctp_stream *stream, __u16 sid)
 {
 	struct sctp_stream_out_ext *soute;
+	int ret;
 
 	soute = kzalloc(sizeof(*soute), GFP_KERNEL);
 	if (!soute)
 		return -ENOMEM;
 	SCTP_SO(stream, sid)->ext = soute;
 
-	return sctp_sched_init_sid(stream, sid, GFP_KERNEL);
+	ret = sctp_sched_init_sid(stream, sid, GFP_KERNEL);
+	if (ret) {
+		kfree(SCTP_SO(stream, sid)->ext);
+		SCTP_SO(stream, sid)->ext = NULL;
+	}
+
+	return ret;
 }
 
 void sctp_stream_free(struct sctp_stream *stream)
-- 
2.21.0

