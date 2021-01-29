Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A8A308CD4
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 19:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232776AbhA2Szo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 13:55:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbhA2Szf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 13:55:35 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86428C061574
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 10:54:51 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id x81so9770066qkb.0
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 10:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SyKp7y6hL+Fge8vJmMexyAxPwcSsu+VHAMhqiORPM9c=;
        b=FPDcwwhKRwmpzxsfo2dR/HR/oGEsnZiKz1PyV5s+AuGXDSAeq+9kHxYLiMry8AE9B7
         1yIiHktZxMMyE6XiJpfsBUnMlHFzr2gTKL2UJA83LbjxaOQ6jGC5JjZdt9cpnZSpAVbu
         za693GSytvtkxCAbtUyqRVUeAOXn9aK40P2nLIKSP0gkXQdCjzPaavzwfxv4hF6hJVqM
         vWXQ0uq2g/75aLlfoIVggBb5k0dmmrzKRjiDvzGqvBE77QZKs6acKfivoF2SaOwPwo94
         ioZy+fsOR4sBgmiWP1gm3aoQvnDyRfULqcWLu4HMhm+fnNDjO425Szs9qRbY9AKoknfC
         Oicw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SyKp7y6hL+Fge8vJmMexyAxPwcSsu+VHAMhqiORPM9c=;
        b=s1/MBAu/+uatpPBNMZUc57/fQDU/C4S/GYWXfrGu3AR83IpgiEdIONp/fIjZFM1Utb
         kYiDllnlUVmJsrbVxJZDUu5BA0jAqJ66l4ydPKHcUaHkxcAWVYO+z4G9uqmKkZc60xkg
         yPDUzt9qJvz3uHR/aI2xvcdMhkCrWzss5PWvHhFWj0pxMioTZR7WKd66kWvL8wGdz5IS
         KKfrCXYNgsaVQ9hU4RPfhRQ3ejJsndvhGbFuAm31puJcM4EWT50vNhz/PzWdxl/5lLc0
         tSmuQyB4IxzalOkOQDoO75Z/wO560Z7MvNgD/MOrR3kUMCSVdlOIUbIB1fLYi4l+28u7
         sjCA==
X-Gm-Message-State: AOAM532NW8x0w9OWsMx6CAe9QKkaH30T66hd4EnbqbfsC0o5k+Whupgl
        SdFz0Lk/VDkdlEdmUZNfKFk=
X-Google-Smtp-Source: ABdhPJymF39V7KKWA2Okn4RO8vW/T1t9uyYwtSDNpWlltyPzQx73QilC+qJbtVwHUv33z+byTTKhDA==
X-Received: by 2002:a37:aa09:: with SMTP id t9mr5631419qke.214.1611946490814;
        Fri, 29 Jan 2021 10:54:50 -0800 (PST)
Received: from soy.nyc.corp.google.com ([2620:0:1003:312:7220:84ff:fe09:3008])
        by smtp.gmail.com with ESMTPSA id t184sm6710947qkd.100.2021.01.29.10.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 10:54:50 -0800 (PST)
From:   Neal Cardwell <ncardwell.kernel@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next] tcp: shrink inet_connection_sock icsk_mtup enabled and probe_size
Date:   Fri, 29 Jan 2021 13:54:38 -0500
Message-Id: <20210129185438.1813237-1-ncardwell.kernel@gmail.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neal Cardwell <ncardwell@google.com>

This commit shrinks inet_connection_sock by 4 bytes, by shrinking
icsk_mtup.enabled from 32 bits to 1 bit, and shrinking
icsk_mtup.probe_size from s32 to an unsuigned 31 bit field.

This is to save space to compensate for the recent introduction of a
new u32 in inet_connection_sock, icsk_probes_tstamp, in the recent bug
fix commit 9d9b1ee0b2d1 ("tcp: fix TCP_USER_TIMEOUT with zero window").

This should not change functionality, since icsk_mtup.enabled is only
ever set to 0 or 1, and icsk_mtup.probe_size can only be either 0
or a positive MTU value returned by tcp_mss_to_mtu()

Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/inet_connection_sock.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index c11f80f328f1..10a625760de9 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -120,14 +120,14 @@ struct inet_connection_sock {
 		__u16		  rcv_mss;	 /* MSS used for delayed ACK decisions	   */
 	} icsk_ack;
 	struct {
-		int		  enabled;
-
 		/* Range of MTUs to search */
 		int		  search_high;
 		int		  search_low;
 
 		/* Information on the current probe. */
-		int		  probe_size;
+		u32		  probe_size:31,
+		/* Is the MTUP feature enabled for this connection? */
+				  enabled:1;
 
 		u32		  probe_timestamp;
 	} icsk_mtup;
-- 
2.30.0.365.g02bc693789-goog

