Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE3616407F
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 10:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgBSJgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 04:36:09 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43665 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgBSJgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 04:36:09 -0500
Received: by mail-pl1-f193.google.com with SMTP id p11so9318959plq.10;
        Wed, 19 Feb 2020 01:36:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=USv22fMY4lRbm7kdOlrco6KeUFWgxCIZrYv0NUecR8k=;
        b=mFl+Rpghcx4xs9gygrl7xbkfupYFtIeXXg7A2VrlMXSkKuMQsWKeCG26GbJDCiOieA
         OjvFeZpZfmYjIpBwwOBC9csCzviJo3jbxes07OuwfMKnYxJUcVKvyfaQepkrHlLQx9es
         OV7Iu2BxOSRlY1uWn0azWWlBlxhrfAL1rnIEVUnSViqd4vKaKk30ZnHvziLZcbICXXdJ
         rLShTFl9eQRoiKGW0P2xPeeBunLdmhwGgSpuuQMZFkTJMTClvncjNGMTqkyzJhTPZ7l7
         bVuNYv9kA+TX8kwieNjO4JqyjO3IVcfqL78VqmZ1CUZaxtive881yHsaUaEmaKDPtOo0
         yKTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=USv22fMY4lRbm7kdOlrco6KeUFWgxCIZrYv0NUecR8k=;
        b=BnqxSqgb2PCsdaQaiqsFx6PyJxYz4A8QlguJcIIK6LB6qseV1pRAe9qC/opNUtm1/Z
         q2kTuAS1gmtlSj2KUBi2npYm/ys6/JvmZ7NUcjc9xk74+S5A4A7hXxwGpY+HEzjbOdXU
         hVpa5xxZ+PwoYXsJOar9WFMD7nIGFDkxLopYce2iXGl7IbJrFEqq8LTe++FQVnz8ltpL
         XFbveUc9719dJSVdDnIdYe6b7fL7GeVPKbtt0xmamfoSMCDmVCV8l3LWSGX3SWDCw2k6
         OEsOgjkf8Fyyc6I4WByIQAnXT2hwcmaajRqP94bct8GfUzEK6+X/QPiXoGJyhVeumOXi
         EyZQ==
X-Gm-Message-State: APjAAAUMbtOMaR3X4PdQv3XPBrbLxvQYFqeT2wgZeNDX2PO0vOqHDZ73
        i/zFEE4z/nfH3RIHD1KkySQ=
X-Google-Smtp-Source: APXvYqyK7T17usTuMnhZLEVXZVGy6SV0GxYbz6ukrtcwQEV2x5dPjBIC/2rZ3TlaqMsCMFAuKp/yxQ==
X-Received: by 2002:a17:902:9a09:: with SMTP id v9mr24385277plp.341.1582104968248;
        Wed, 19 Feb 2020 01:36:08 -0800 (PST)
Received: from localhost.localdomain ([146.196.37.220])
        by smtp.googlemail.com with ESMTPSA id x197sm2119217pfc.1.2020.02.19.01.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 01:36:07 -0800 (PST)
From:   Amol Grover <frextrite@gmail.com>
To:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        Amol Grover <frextrite@gmail.com>
Subject: [PATCH] sunrpc: Pass lockdep expression to RCU lists
Date:   Wed, 19 Feb 2020 15:05:05 +0530
Message-Id: <20200219093504.16290-1-frextrite@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

detail->hash_table[] is traversed using hlist_for_each_entry_rcu
outside an RCU read-side critical section but under the protection
of detail->hash_lock.

Hence, add corresponding lockdep expression to silence false-positive
warnings, and harden RCU lists.

Signed-off-by: Amol Grover <frextrite@gmail.com>
---
 net/sunrpc/cache.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index f740cb51802a..5db5f5b94726 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -97,7 +97,8 @@ static struct cache_head *sunrpc_cache_add_entry(struct cache_detail *detail,
 	spin_lock(&detail->hash_lock);
 
 	/* check if entry appeared while we slept */
-	hlist_for_each_entry_rcu(tmp, head, cache_list) {
+	hlist_for_each_entry_rcu(tmp, head, cache_list,
+				 lockdep_is_held(&detail->hash_lock)) {
 		if (detail->match(tmp, key)) {
 			if (cache_is_expired(detail, tmp)) {
 				hlist_del_init_rcu(&tmp->cache_list);
-- 
2.24.1

