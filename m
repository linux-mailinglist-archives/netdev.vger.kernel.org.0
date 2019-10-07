Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 988C5CDAD5
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 06:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbfJGDxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 23:53:43 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:42871 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbfJGDxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 23:53:43 -0400
Received: by mail-qk1-f195.google.com with SMTP id f16so11331031qkl.9
        for <netdev@vger.kernel.org>; Sun, 06 Oct 2019 20:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=brk9vgONbCAk0GCVLJv/izIYpHoTmZWXVAiSs253Ntc=;
        b=W77s44ko3vGhyiAgRjl1OaHD+S3HVwIC7UldnKSTpVOwcBtWYbkwht31gvAR7v95CK
         HnGcvpH6+xAoFsRQkLiGzqI2ae99OvoMMQIMpAlB4AaC4ZyxCg/V0PcURZJ0LolSg8EE
         BevWSZyf2EF5UpbLR/FIWsra0CGLFPQXmioHJ5Q2KZunXRIIn6/iaeK5iv33HPPtjq/V
         0hGPRHw1M9ckavOdU2YnrdLuk44TgozlDSrht6WSSBqqeExGx6IFkW9zfOD/V5RTn2bS
         yEF+QzA3eXypS5bd8HsXHtICuaCSdNKfXlwPrMCjI1jLzIfJUWD4w+wSH6Hzqj5tjblu
         EZPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=brk9vgONbCAk0GCVLJv/izIYpHoTmZWXVAiSs253Ntc=;
        b=WivRLrtqBvAXuUh5KZB2YZRbDjezs8OaTXP/o09T9Axhu6yDJmelArfMQxeYOOE6eD
         zQ4VRjJBR5hWQqt0KbHjK+JUajbwiZyTG5riRPVuT6iH4aKcj2Sqv5HhUEtwpmnGddKX
         ic/SZpXn0U45QQWwKjH7xECz/oroDyHRcz/xnI2f1p6oML87CtpMTwWVp02/CrmC4lbw
         sJZJznfqeCffqhZsunlMpFjIQEvtCc/F9s8ntnWDAAmcMNyduJ3ZjgsJOSReKz45z+BI
         z/V8Eoqpou5qt6OaS+v0y1tSjwVcWYS8RxMN5URdCYhU14Zfj1rKuGpM7ykfMXyhzBsj
         uMig==
X-Gm-Message-State: APjAAAWkEJzswsdkG6MMZbUN541iqr7frQ6Qnq5cHZGSdnN7xNEpmtou
        zHXCBLbh9gNug9E2pYR2UQ+qMObpnrU=
X-Google-Smtp-Source: APXvYqzLSQ1379tM9CXOsXOcQ/UhI058k+5prMFn31HiC7/XC/1wMXO7MvvjfmLTFAdHA0q6Pyqj6w==
X-Received: by 2002:a05:620a:16d2:: with SMTP id a18mr21713699qkn.104.1570420422173;
        Sun, 06 Oct 2019 20:53:42 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 4sm7469863qtf.87.2019.10.06.20.53.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Oct 2019 20:53:41 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        willemb@google.com
Cc:     oss-drivers@netronome.com, davejwatson@fb.com, borisp@mellanox.com,
        aviadye@mellanox.com, john.fastabend@gmail.com,
        daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [RFC 1/2] net/tls: don't clear socket error if strparser aborted
Date:   Sun,  6 Oct 2019 20:53:22 -0700
Message-Id: <20191007035323.4360-2-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191007035323.4360-1-jakub.kicinski@netronome.com>
References: <20191007035323.4360-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If strparser encounters an error it reports it on the socket and
stops any further processing. TLS RX will currently pick up that
error code with sock_error(), and report it to user space once.
Subsequent read calls will block indefinitely.

Since the error condition is not cleared and processing is not
restarted it seems more correct to keep returning the error
rather than sleeping.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 net/tls/tls_sw.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index de7561d4cfa5..a9ca2dbe0531 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1245,8 +1245,11 @@ static struct sk_buff *tls_wait_data(struct sock *sk, struct sk_psock *psock,
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 
 	while (!(skb = ctx->recv_pkt) && sk_psock_queue_empty(psock)) {
-		if (sk->sk_err) {
-			*err = sock_error(sk);
+		if (unlikely(sk->sk_err)) {
+			if (ctx->strp.stopped)
+				*err = -sk->sk_err;
+			else
+				*err = sock_error(sk);
 			return NULL;
 		}
 
-- 
2.21.0

