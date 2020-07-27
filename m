Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC0022E9F5
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 12:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbgG0KYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 06:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbgG0KYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 06:24:41 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACBABC061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 03:24:39 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id di22so4555319edb.12
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 03:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ew/mvZaAa0MKQUJkHMxg0jxr2TRBwbh2Nmfpyl37I+I=;
        b=aK37klo/FRI+TgL6WW4qP8UtbBGyDnsRZUlfEJUAD/Zhb4ZYwL87atfbrsCS7sqOHB
         0mt9no0Ql7VZNC65lXXoAxUSUOZX4WIt+lhlzqWAjTZRpsdh1c+ZaD44a2+sG96s/doS
         QlKDuTFYIFOCDAgNZVaDF+5s3yBUUHDiIe5+jHKVuzs+OtHqq624tCaqInOIJ1neLFQi
         ACSQXNV7Xds9AVa9HI57xesgyYgY0EwLC02F44WnWY34gVLu0o4t9va9ejWDe3Yn6TMb
         ljKhcFx/NNkNkK1dwvMV0lpdJmuqfPihEAfTYO5v79EVFbhd0QoJAvGnfJXEz8BkLFXW
         HCcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ew/mvZaAa0MKQUJkHMxg0jxr2TRBwbh2Nmfpyl37I+I=;
        b=P7byiD4xbonK9WlBvfUVETlQtrtxRUZHAQbuWR1RYck9ibyy99HhYoLTE5MfM43E2Z
         9RLC4KtIXgVyofjtgTCrnPDeg2eLeuY653gdSDje6iVdvtfbZkPrgAnNGLpBEXIRx/qY
         vJH9ZO+d6bED0Bt8hSo3DLr2uR11Mz9oqUvjsWKqjWrZBxiYnBP1VMgt3LPCYfaDEVg6
         YUW4KprOt2mJiIjkTrHF8JxQQTTEXQJJBSbo6IGqJ89fm7M5VR+Qj2OtDohiuPzbIHCb
         TBTkAqt6SxAoNmJiXDaBzX+v9FSyV98wJYv2hjN8oKifi9R2QLfQg0qAuBw/dPOBivX1
         IYZg==
X-Gm-Message-State: AOAM531ZewmJvVh719yuPDoQOvwxSuCVEcjwVdtHyeEspNdLBaGcNZeC
        FoQTX5J9uI0YTLNxusDA5U9ovz7DhC2mTw==
X-Google-Smtp-Source: ABdhPJwACpz1Dt3WO295Cwmim5Oa3IRv/WSdlVIoUiactVYTBc/WgFp7/aZtBQlfVR+IHaJzlZulYQ==
X-Received: by 2002:aa7:cdd2:: with SMTP id h18mr13654178edw.387.1595845477601;
        Mon, 27 Jul 2020 03:24:37 -0700 (PDT)
Received: from tsr-vdi-mbaerts.nix.tessares.net (static.23.216.130.94.clients.your-server.de. [94.130.216.23])
        by smtp.gmail.com with ESMTPSA id i9sm1498756ejb.48.2020.07.27.03.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 03:24:37 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] mptcp: fix joined subflows with unblocking sk
Date:   Mon, 27 Jul 2020 12:24:33 +0200
Message-Id: <20200727102433.3422117-1-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unblocking sockets used for outgoing connections were not containing
inet info about the initial connection due to a typo there: the value of
"err" variable is negative in the kernelspace.

This fixes the creation of additional subflows where the remote port has
to be reused if the other host didn't announce another one. This also
fixes inet_diag showing blank info about MPTCP sockets from unblocking
sockets doing a connect().

Fixes: 41be81a8d3d0 ("mptcp: fix unblocking connect()")
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/protocol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 3980fbb6f31e..c0abe738e7d3 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1833,7 +1833,7 @@ static int mptcp_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	/* on successful connect, the msk state will be moved to established by
 	 * subflow_finish_connect()
 	 */
-	if (!err || err == EINPROGRESS)
+	if (!err || err == -EINPROGRESS)
 		mptcp_copy_inaddrs(sock->sk, ssock->sk);
 	else
 		inet_sk_state_store(sock->sk, inet_sk_state_load(ssock->sk));
-- 
2.27.0

