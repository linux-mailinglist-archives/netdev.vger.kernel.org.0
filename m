Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 427C410B74F
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 21:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbfK0USC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 15:18:02 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45784 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbfK0USC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 15:18:02 -0500
Received: by mail-lj1-f193.google.com with SMTP id n21so25849794ljg.12
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 12:18:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w5gQgA8v/HX14VDHHSlOUpz5qEAJHrEInj+L4mAu6kU=;
        b=wnCh/D/5s2kkqDt+MzgOvBzXGLGLQ7bC0JEEhb8xL23azT+TyPRHxvUhjImrVjeCv3
         Snbv3eVRVgg5C5upmplDCVRjpB5/ds3Yd5MxU0i3bOHdfdUCtKWdGU7c7CO3k8z3pzlt
         7shyoomJh2s+VYbgJSGXn0Dp6KQfdzg54bvHx7P5RFJL+J4+JAPif5CSUmfyS7y0XtO7
         SFtwxjip2vroqROBnnoQj1AxKf76g5EUDsf2l1ZQAh8yxFLPX1DF7sivruScqrbaz+ut
         B7tRM5YkY2KhKHScbwLgTnRLb0ALqeWYXnBoA+SZmP1/0tNSKvLKkDu3D/HDYkhAF9rG
         cUNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w5gQgA8v/HX14VDHHSlOUpz5qEAJHrEInj+L4mAu6kU=;
        b=YTUkjHeFGs5iv+Q2cwo2HdGDwWFdDs3pmwHCjXsMjCwV1bGOfaLfG8+2cY9rLTJBTl
         VoqHKiAegO1CzONRD0RBRvXG4tcdVnzrd8+domafKvQhSURikc3PSucESFWe8Xnn/XU7
         O7RdymnpnvMoCmN1fT/jW06jI9Ru9+PUYwsJZvA9uziezDqZrMXh7eCL8ZzZxTwjTqph
         HzW76Di6b8YPj3Qpzy0u5r44Ugdftz4DbZdDFGXD9kHS0bZEJKwmL8hfttNKeTj9zH/N
         L3OPHt328AQIyz51F0m/LFPVQgVea/FvoGaMIDwPAbAQwiukoKZwSObhi8bmBUqmsktE
         SUyQ==
X-Gm-Message-State: APjAAAXIKUeQ2yUSKp3irkGvSooYY26gh3E8pviXxZeR1bWIwUgXL4zm
        sda3LZzGOnODsgGuKMxQa3ZasA==
X-Google-Smtp-Source: APXvYqxkS1ZKTxIiO68eMriRpO65+39Nfwzvzt+U2AIcDTJlA532080E2PQZpfg42HhltaQKBRoq9g==
X-Received: by 2002:a2e:3009:: with SMTP id w9mr33242841ljw.74.1574885880044;
        Wed, 27 Nov 2019 12:18:00 -0800 (PST)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r22sm7759739lji.71.2019.11.27.12.17.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Nov 2019 12:17:59 -0800 (PST)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net, john.fastabend@gmail.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        syzbot+df0d4ec12332661dd1f9@syzkaller.appspotmail.com,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net 2/8] net/tls: free the record on encryption error
Date:   Wed, 27 Nov 2019 12:16:40 -0800
Message-Id: <20191127201646.25455-3-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191127201646.25455-1-jakub.kicinski@netronome.com>
References: <20191127201646.25455-1-jakub.kicinski@netronome.com>
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

As suggested by John free the record, the BPF code is already
doing just that.

Reported-by: syzbot+df0d4ec12332661dd1f9@syzkaller.appspotmail.com
Fixes: d3b18ad31f93 ("tls: add bpf support to sk_msg handling")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 net/tls/tls_sw.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 70e3c0c1af50..dbba51b69d21 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -771,8 +771,14 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
 
 	policy = !(flags & MSG_SENDPAGE_NOPOLICY);
 	psock = sk_psock_get(sk);
-	if (!psock || !policy)
-		return tls_push_record(sk, flags, record_type);
+	if (!psock || !policy) {
+		err = tls_push_record(sk, flags, record_type);
+		if (err) {
+			*copied -= sk_msg_free(sk, msg);
+			tls_free_open_rec(sk);
+		}
+		return err;
+	}
 more_data:
 	enospc = sk_msg_full(msg);
 	if (psock->eval == __SK_NONE) {
-- 
2.23.0

