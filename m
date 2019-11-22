Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07C53107A26
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 22:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfKVVqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 16:46:06 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37405 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfKVVqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 16:46:06 -0500
Received: by mail-lj1-f194.google.com with SMTP id d5so9002537ljl.4
        for <netdev@vger.kernel.org>; Fri, 22 Nov 2019 13:46:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qMUrrw0GbXh12kGMuQLweai6rEE3OXWB1rshrHYqG2o=;
        b=0z7juBeq8oq+4lLmAJj0oruotdW6innIUJQMBO5+ci8/dgTuU3wVBEzC8fqvfBen5+
         ce9k+4DDjd3xbBzQ9nhjXandOYsexAlDbV6Gof5FRQBbQ0SQ9wIUaFFcJS7sivXc9C3Z
         Tu3mfAUumHA6BMMNOCdkMekNXcznZLUAqnD8s0dMxRqNfgzrS/jObL56ax73+7QqQ8qe
         YK5D1daRDDzL0PsFLPQwJcLFwpsLYuSg30fkR4IOk6i05ulCXVfJ6D1dHYKG369gIoLu
         jVIR/0XCCjSg2Zwlr10wrZpg5J+edLTpY0MSmnUHCwSf5iuvWFsSJi/wwNhO9mPRTpUX
         ZkYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qMUrrw0GbXh12kGMuQLweai6rEE3OXWB1rshrHYqG2o=;
        b=XsJpR+R6qmRjlzEAaFc/vmRgmt/gComKJPdy22i0EwIvQIlKGtIOinxgtVPifFC9EL
         14tqb3vLjBMGZOoUyULcX6onUDBhz8lkzmIYFWN9T6AmyVHxLUxXGzC7donf85pznOGy
         224zmiBtA65De0PV9zDd9TjbtJHNj7Jm+JIdQ8oZPUA0E8Q+8vO3807uCqKZ4HVl+3sR
         slhew04c8GFUBES6BrmRB4cp68gXhGD2vd+7c2IXQN7Au+FpqusBpr378/27b7noeFyL
         LKNu4uOt8Ebm3She7gRDummqSuoTO/jFQCFgr9qc38MAsGlQibJxpL4BFsrlByyEZj/t
         iSHw==
X-Gm-Message-State: APjAAAV0gbQQycPCMi9d1J/DitT6RzAuuNaqqOkqsGmaxs8MIlT3X5cp
        rnz1MNeWjoSSv5/O48GdkHdsGQ==
X-Google-Smtp-Source: APXvYqyHPRP6YY9evC4pvkjSxZ7vtprpXTIHTgVuXBav0YseJqJBeIZTpMiFNILolT1AcB1jDmX9cA==
X-Received: by 2002:a2e:9802:: with SMTP id a2mr13935876ljj.254.1574459163204;
        Fri, 22 Nov 2019 13:46:03 -0800 (PST)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id w11sm4031280lji.45.2019.11.22.13.45.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Nov 2019 13:46:01 -0800 (PST)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        syzbot+df0d4ec12332661dd1f9@syzkaller.appspotmail.com
Subject: [RFC net] net/tls: clear SG markings on encryption error
Date:   Fri, 22 Nov 2019 13:45:53 -0800
Message-Id: <20191122214553.20982-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When tls_do_encryption() fails the SG lists are left with the
SG_END and SG_CHAIN marks in place. One could hope that once
encryption fails we will never see the record again, but that
is in fact not true. Commit d3b18ad31f93 ("tls: add bpf support
to sk_msg handling") added special handling to ENOMEM and ENOSPC
errors which mean we may see the same record re-submitted.

In all honesty I don't understand why we need the ENOMEM handling.
Waiting for socket memory without setting SOCK_NOSPACE on any
random memory allocation failure seems slightly ill advised.

Having said that, undoing the SG markings seems wise regardless.

Reported-by: syzbot+df0d4ec12332661dd1f9@syzkaller.appspotmail.com
Fixes: 130b392c6cd6 ("net: tls: Add tls 1.3 support")
Fixes: d3b18ad31f93 ("tls: add bpf support to sk_msg handling")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
John, I'm sending this mostly to ask if we can safely remove
the ENOMEM handling? :)

I was going to try the sockmap tests myself, but looks like the current
LLVM 10 build I get from their debs just segfaults when trying to build
selftest :/

Also there's at least one more bug in this piece of code, TLS 1.3
can't assume there's at least one free SG entry.

 net/tls/tls_sw.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 24161750a737..4a0ea87b20cf 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -737,6 +737,19 @@ static int tls_push_record(struct sock *sk, int flags,
 	if (rc < 0) {
 		if (rc != -EINPROGRESS) {
 			tls_err_abort(sk, EBADMSG);
+
+			i = msg_pl->sg.end;
+			if (prot->version == TLS_1_3_VERSION) {
+				sg_mark_end(sk_msg_elem(msg_pl, i));
+				sg_unmark_end(sk_msg_elem(msg_pl, i));
+			}
+			sk_msg_iter_var_prev(i);
+			sg_unmark_end(sk_msg_elem(msg_pl, i));
+
+			i = msg_en->sg.end;
+			sk_msg_iter_var_prev(i);
+			sg_unmark_end(sk_msg_elem(msg_en, i));
+
 			if (split) {
 				tls_ctx->pending_open_record_frags = true;
 				tls_merge_open_record(sk, rec, tmp, orig_end);
-- 
2.23.0

