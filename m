Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1394DAACE4
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 22:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389647AbfIEUUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 16:20:46 -0400
Received: from mail-ua1-f73.google.com ([209.85.222.73]:32932 "EHLO
        mail-ua1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389089AbfIEUUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 16:20:45 -0400
Received: by mail-ua1-f73.google.com with SMTP id w26so678563uan.0
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 13:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Ertwuoc0F7BS07iYDgrZ1kttlchkVvOwwfNw67qhKoI=;
        b=OAUWvl/8MnbTtYqG8YDFZFvfS9+YPSI8QNsvnt2wgMiYg/7wLBCu6LhZ/mt/ZRUchz
         IYIiBOonfrC7wiXYTF53irHxPd64UVSJtsyDK9tC+MXJVH/ETFddWz5SX2nM8FYKXd8N
         qm0WOV6I2Mh1m7KfMGNSdnAUt2jAkoStSsoGaDR7sCjKoBSBcntBhq3lPG1g/9+SQmmM
         5yHQ2zURpBT+Y4BeJF092k0HF/nGdVX12JGaUBfzaY7aXftjii8r7Nl4YpHSouWs6Lni
         vOeqEyvyXqrNHIrXJ9KzPdxan1nFMtFm8rNYE0wB+FPqwWw7+LexAJJlBYPHgfDMJ7Kh
         DtHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Ertwuoc0F7BS07iYDgrZ1kttlchkVvOwwfNw67qhKoI=;
        b=Dcj61zGTpV1IVk3/2N0IXCddVTdvjteGqve1YRrHuaEI28Fb2VUyXHSCrekdaWrLUW
         6NEfXdfd7ZqLkXE15n4N+DT0rkiM003YFcZURsTF2teJpUwdxcV5tNM2m665SkR8+2OE
         f458R17Ln2GvLWtbRUP07DBqH0Tgpp74oSNaPp8LRIv6cLfSIhK7nwU4q3fvhuAwRtT5
         QzUvimuATV5keScY3O+F+Dfpl7vlfw0fP12GprHxQspecvz1zQ21JugoL1ec6O8HVo+m
         fdo9BcU1YDCxTRWN6w6I+M80qeh3/6veQAxiI/m1GNFC6seBv4g09XMHjIkEM6FiP/lT
         wVaA==
X-Gm-Message-State: APjAAAXFxHNwO2aYpjm5z5q130mWL0qSRom4Qsm3YfED0OYNrI/puL0N
        x6XCOnBa9KeLZwapOvhWW0WIiB0/bMCeZw==
X-Google-Smtp-Source: APXvYqxZdWF+O/T+kQ7/eMPLh8Hzk7q3Tu0G+P4RjWNlSPVzPU4EA1OkguR+TLDvfpqGhncl0G3EaDmGnfqVpA==
X-Received: by 2002:ab0:7452:: with SMTP id p18mr2518242uaq.108.1567714844510;
 Thu, 05 Sep 2019 13:20:44 -0700 (PDT)
Date:   Thu,  5 Sep 2019 13:20:41 -0700
Message-Id: <20190905202041.138085-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH net] tcp: ulp: fix possible crash in tcp_diag_get_aux_size()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Luke Hsiao <lukehsiao@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Davide Caratti <dcaratti@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tcp_diag_get_aux_size() can be called with sockets in any state.

icsk_ulp_ops is only present for full sockets.

For SYN_RECV or TIME_WAIT ones we would access garbage.

Fixes: 61723b393292 ("tcp: ulp: add functions to dump ulp-specific information")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Luke Hsiao <lukehsiao@google.com>
Reported-by: Neal Cardwell <ncardwell@google.com>
Cc: Davide Caratti <dcaratti@redhat.com>
---
 net/ipv4/tcp_diag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_diag.c b/net/ipv4/tcp_diag.c
index babc156deabb573f11bba344215d2c3712c4a3cd..81a8221d650a94be53d17354c60ddd0c655eaccf 100644
--- a/net/ipv4/tcp_diag.c
+++ b/net/ipv4/tcp_diag.c
@@ -163,7 +163,7 @@ static size_t tcp_diag_get_aux_size(struct sock *sk, bool net_admin)
 	}
 #endif
 
-	if (net_admin) {
+	if (net_admin && sk_fullsock(sk)) {
 		const struct tcp_ulp_ops *ulp_ops;
 
 		ulp_ops = icsk->icsk_ulp_ops;
-- 
2.23.0.187.g17f5b7556c-goog

