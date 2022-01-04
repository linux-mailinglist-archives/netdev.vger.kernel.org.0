Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7039948499B
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 21:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233365AbiADU7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 15:59:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiADU7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 15:59:20 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4B4C061761;
        Tue,  4 Jan 2022 12:59:20 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id r5so33730024pgi.6;
        Tue, 04 Jan 2022 12:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VQyCF3djAmOFhQyPxWDMxHb/jQnUuZ5YYM4f7z23PhQ=;
        b=Qmb6wRtleudBLjESDuMEsome4T8KKQuaKSUQJSvRjL9FjpR0GKg18PYXDEGspmfOos
         korc04ilzqys9iFjgT9XrgfFZS0GFxE4TNmCj2t2moOV1VXYbYJak0vjT00d5dlXLwf2
         O6XpXZCn7KyFIqPXdt7OKqNME6oSLbVqkAaWX/XoOJyzY/cHb3+taYFgTR/tp8bBGQbZ
         mmOt9K79Naza9Z0savlpi55Hjv9hPz3r5eU17nuamT9gxL8OMU7ySrgP+5S11mL8cT/P
         MPiU910u8swht+SJlq+gXAMhhErU6wCC3mUtmgHArpnhd8K+j7mzlj1EcAl0pW7Yw6/X
         LRoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VQyCF3djAmOFhQyPxWDMxHb/jQnUuZ5YYM4f7z23PhQ=;
        b=z5GEd4WFoNmJ2gJ1mvkZVvY4KQO4kwmz5pxVVwkwaK6OYwA7kH1HZ6PhXe4uhJrIkc
         m0nv8KeEv+6A4g6Za8vTGZ20MwNpGIUd7xBUdoGaAsL4tgpaRCOBdsABmRnwMyTAA60e
         ZxKavG2VtDZufc/bauu0tf3eVrTjEG2fhWyBnn+Y9qUW+7Xtm1KEQZqs1m18BOELFqMJ
         NYPzbWISLNaTx0QQ3LuBmSqWjzo0wRqMuaz9LzpCe2lKF51zmq4paiOpbD2Ks4Fi0TFu
         EiWYCfULWsYG6xqYSjglxHM5a59o8Ubn+rCqAM9uZzoIshJbYTw6j1JcxxaeR0f2SZLK
         feAw==
X-Gm-Message-State: AOAM530u5VrGHiTzzTXFdLcj9Osm1F6IchvEB+4Ecbvth0qAgQpZNtLi
        L/C1vOdGDOVNdVWbXcMb3DCQzbi0EEA=
X-Google-Smtp-Source: ABdhPJwhXsXHTN01NMAV/Zkz9RfHBrXEjGwwaJAV+74pwq35S7GAsdYl+L/2nrp1pjybgP0Zvt+31Q==
X-Received: by 2002:a63:2acd:: with SMTP id q196mr46470468pgq.370.1641329960027;
        Tue, 04 Jan 2022 12:59:20 -0800 (PST)
Received: from localhost.localdomain ([71.236.223.183])
        by smtp.gmail.com with ESMTPSA id f16sm45647600pfj.6.2022.01.04.12.59.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 12:59:19 -0800 (PST)
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, joamaki@gmail.com,
        john.fastabend@gmail.com
Subject: [PATCH bpf-next] bpf, sockmap: fix return codes from tcp_bpf_recvmsg_parser()
Date:   Tue,  4 Jan 2022 12:59:18 -0800
Message-Id: <20220104205918.286416-1-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Applications can be confused slightly because we do not always return the
same error code as expected, e.g. what the TCP stack normally returns. For
example on a sock err sk->sk_err instead of returning the sock_error we
return EAGAIN. This usually means the application will 'try again'
instead of aborting immediately. Another example, when a shutdown event
is received we should immediately abort instead of waiting for data when
the user provides a timeout.

These tend to not be fatal, applications usually recover, but introduces
bogus errors to the user or introduces unexpected latency. Before
'c5d2177a72a16' we fell back to the TCP stack when no data was available
so we managed to catch many of the cases here, although with the extra
latency cost of calling tcp_msg_wait_data() first.

To fix lets duplicate the error handling in TCP stack into tcp_bpf so
that we get the same error codes.

These were found in our CI tests that run applications against sockmap
and do longer lived testing, at least compared to test_sockmap that
does short-lived ping/pong tests, and in some of our test clusters
we deploy.

Its non-trivial to do these in a shorter form CI tests that would be
appropriate for BPF selftests, but we are looking into it so we can
ensure this keeps working going forward. As a preview one idea is to
pull in the packetdrill testing which catches some of this.

Fixes: c5d2177a72a16 ("bpf, sockmap: Fix race in ingress receive verdict with redirect to self")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/ipv4/tcp_bpf.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index f70aa0932bd6..9b9b02052fd3 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -196,12 +196,39 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
 		long timeo;
 		int data;
 
+		if (sock_flag(sk, SOCK_DONE))
+			goto out;
+
+		if (sk->sk_err) {
+			copied = sock_error(sk);
+			goto out;
+		}
+
+		if (sk->sk_shutdown & RCV_SHUTDOWN)
+			goto out;
+
+		if (sk->sk_state == TCP_CLOSE) {
+			copied = -ENOTCONN;
+			goto out;
+		}
+
 		timeo = sock_rcvtimeo(sk, nonblock);
+		if (!timeo) {
+			copied = -EAGAIN;
+			goto out;
+		}
+
+		if (signal_pending(current)) {
+			copied = sock_intr_errno(timeo);
+			goto out;
+		}
+
 		data = tcp_msg_wait_data(sk, psock, timeo);
 		if (data && !sk_psock_queue_empty(psock))
 			goto msg_bytes_ready;
 		copied = -EAGAIN;
 	}
+out:
 	release_sock(sk);
 	sk_psock_put(sk, psock);
 	return copied;
-- 
2.33.0

