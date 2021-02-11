Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2E5F319514
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 22:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhBKVWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 16:22:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhBKVV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 16:21:57 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0879C061574
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 13:21:16 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id t29so4497069pfg.11
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 13:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HRZOJxzCHwT0reCGGK+KaofPFtCaQ2rI7qh06CwdxEg=;
        b=ClF0oXpY1QVR20HBrOUAOqDdaCAXMuMktBCIxOuL8y61UquRd509yuyjBK0HznkQNl
         B8eqrnY6nB9MJm9q+xwBHVTIWsW66f1PgMhQLL9vf1QBolzFc9hBSdW6qbsyMYtQSBrv
         NZpvAt8TsSpMgW8qhcHbz1uksfcO55waKW++sq3ChxEIVEqVU1zHwVVn9BgAJODtcmwm
         Xm9sxwXZ9UDHFgde/PJX9k3vmzV/XTt0vCHetP+WxRLvT18vQQzdH2xOSb4PDPX+hLSE
         FYstHCyz9TtRpAwWYTRm+c3JiEjDjm7OaRVUGLVKeOiQMMp27d+cJ+5jRLpAsPANhsx6
         fVdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HRZOJxzCHwT0reCGGK+KaofPFtCaQ2rI7qh06CwdxEg=;
        b=iYjgoKRnM+rtWQqDcU2GeFKtZLAt/WJAwFBeeHHBJjOzFt93GvAspxSOelj+3bGAmT
         KYFZxq8ci35X7PJEiJTr76u/jQ2+9sUoPNucmfv73I37LmheIpkaL+FcQnDSwm/7fx2Q
         q/LVHV1jCcLvaPLpirwpqMHigherAQL7A2IMFWc/hyne9pL5knmDB4bCxw0gqIDCzrJw
         H4ouG7E1Qzl4wTKl+iX3Xvwi3HpKPhOdYLRNo4xqDTEQ83aXjDaIOakrQh1jXrs3k6kO
         qrTptg3aBZgh+Bl/H6Jk3Kq9zK4Nt5WyKO3h3BubD1VZSiT1DMYsyVy/SpwBHNRKczt9
         P9ZA==
X-Gm-Message-State: AOAM531wqPbdqkT0h7ExsoBv3JxVxj8u42TBwdqyfDmkQ4YX6OiTKmro
        kN4bCSTI9lGf18bMYtSeXEw=
X-Google-Smtp-Source: ABdhPJwT1mOcwROVjxWvk5mwx7FuQH64lSJq/xFRT1ZbgPbUet2TqMNkk5k11Iy6fGjHrr1vN1wUTw==
X-Received: by 2002:a62:ae0b:0:b029:1d9:eb3f:8900 with SMTP id q11-20020a62ae0b0000b02901d9eb3f8900mr9457166pff.53.1613078476345;
        Thu, 11 Feb 2021 13:21:16 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:345e:2ee8:3e18:6b43])
        by smtp.gmail.com with ESMTPSA id e198sm6761922pfh.126.2021.02.11.13.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 13:21:15 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com,
        David Ahern <dsahern@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next] tcp: Sanitize CMSG flags and reserved args in tcp_zerocopy_receive.
Date:   Thu, 11 Feb 2021 13:21:07 -0800
Message-Id: <20210211212107.662291-1-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

Explicitly define reserved field and require it and any subsequent
fields to be zero-valued for now. Additionally, limit the valid CMSG
flags that tcp_zerocopy_receive accepts.

Fixes: 7eeba1706eba ("tcp: Add receive timestamp support for receive zerocopy.")
Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Suggested-by: David Ahern <dsahern@gmail.com>
Suggested-by: Leon Romanovsky <leon@kernel.org>
Suggested-by: Jakub Kicinski <kuba@kernel.org>
---
 include/uapi/linux/tcp.h |  2 +-
 net/ipv4/tcp.c           | 11 ++++++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 42fc5a640df4..8fc09e8638b3 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -357,6 +357,6 @@ struct tcp_zerocopy_receive {
 	__u64 msg_control; /* ancillary data */
 	__u64 msg_controllen;
 	__u32 msg_flags;
-	/* __u32 hole;  Next we must add >1 u32 otherwise length checks fail. */
+	__u32 reserved; /* set to 0 for now */
 };
 #endif /* _UAPI_LINUX_TCP_H */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e1a17c6b473c..9896ca10bb34 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2030,6 +2030,7 @@ static int tcp_zerocopy_vm_insert_batch(struct vm_area_struct *vma,
 		err);
 }
 
+#define TCP_VALID_ZC_MSG_FLAGS   (TCP_CMSG_TS)
 static void tcp_recv_timestamp(struct msghdr *msg, const struct sock *sk,
 			       struct scm_timestamping_internal *tss);
 static void tcp_zc_finalize_rx_tstamp(struct sock *sk,
@@ -4152,13 +4153,21 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 			return -EFAULT;
 		if (len < offsetofend(struct tcp_zerocopy_receive, length))
 			return -EINVAL;
-		if (len > sizeof(zc)) {
+		if (unlikely(len > sizeof(zc))) {
+			err = check_zeroed_user(optval + sizeof(zc),
+						len - sizeof(zc));
+			if (err < 1)
+				return err == 0 ? -EINVAL : err;
 			len = sizeof(zc);
 			if (put_user(len, optlen))
 				return -EFAULT;
 		}
 		if (copy_from_user(&zc, optval, len))
 			return -EFAULT;
+		if (zc.reserved)
+			return -EINVAL;
+		if (zc.msg_flags &  ~(TCP_VALID_ZC_MSG_FLAGS))
+			return -EINVAL;
 		lock_sock(sk);
 		err = tcp_zerocopy_receive(sk, &zc, &tss);
 		release_sock(sk);
-- 
2.30.0.478.g8a0d178c01-goog

