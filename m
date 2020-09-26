Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8589127982C
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 11:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbgIZJ01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 05:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgIZJ00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 05:26:26 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD84AC0613CE;
        Sat, 26 Sep 2020 02:26:26 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id kk9so736083pjb.2;
        Sat, 26 Sep 2020 02:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=EoXTg89vWulktaKV9WUf5FA5R7Hxe2mYsOu9pJnZ92Y=;
        b=mona7MExxElD46h3dsWgHtnjpOtE/bWLDT+DMc/vOavno0lgMekwKiWOeLyDjkk7n4
         NBltTXvnSMpxxsCx+htM46j9mjmPE72bLki+STrpFhHj3kRubiD6nOYLn2dIbnnt89xM
         lOI11IGJWFQXf4iTqtGE88RMgdd8NWUA9M8jhxHSVJNScMGlQr8L/Vt/3ZWxbcLnbSgc
         iY9XVhvymouOgc8ASbANycfRAgv+7vzKACd2jOvcNHyciB/eTIpzLmZ6dxBHCzN5swg1
         E1s+UE2wsJpcZK03PKZPNVZzFKkvEO7xnOpWFmQ4wpXjY5284tUR3JrjOD0qRN+nPzRK
         uRGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=EoXTg89vWulktaKV9WUf5FA5R7Hxe2mYsOu9pJnZ92Y=;
        b=GIBwYa8MmIx+eItH43wLufZ4cZGbHQr4PmybsZj/3aBUwHVj2fazPltxMQ+q/iZko4
         xiThf29PWuCoGP/xRVik4ST+/wiiiRXlHXbuT867rNjqPR7NHQpDRNQ1qrR99CjaoXxn
         CwDnbJY0bBGiMfSS+UgapsK5AsEtDsPeINBj/OczR4WKzxeXxBdXiih8LV3g3+Ph25rw
         o0Q7Sg+HBCtKFkTxZ/QATBT6IZGPmXT0Ky5m47OE9Eqw7Bb1PUV3+WyD63NrDSM+1KFw
         6z6BfMOFIUDEFbGbit2SD1kHjhhn5I50Nna1UP+6+B+2atPlP4Mkbfv+fWsOubkq48m/
         /VyQ==
X-Gm-Message-State: AOAM533sHc0Idaph0IHMDqPEzd4V365EvtLDQFcdhZ3YHtmY40zLah+F
        /KpztrXda16JbO4nbSHiR2A=
X-Google-Smtp-Source: ABdhPJxVin+kg3Bl9BPzaY3B3kIFsVlKig91jO1lzlI/FEDRWrVbeqb0xbThgeg0z4WdwHNpWoU3CA==
X-Received: by 2002:a17:90a:a78d:: with SMTP id f13mr1465833pjq.69.1601112386296;
        Sat, 26 Sep 2020 02:26:26 -0700 (PDT)
Received: from localhost.localdomain (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id l14sm1314765pjy.1.2020.09.26.02.26.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 26 Sep 2020 02:26:25 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org
Subject: [PATCH bpf-next] xsk: fix possible crash in socket_release when out-of-memory
Date:   Sat, 26 Sep 2020 11:26:13 +0200
Message-Id: <1601112373-10595-1-git-send-email-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Fix possible crash in socket_release when an out-of-memory error has
occurred in the bind call. If a socket using the XDP_SHARED_UMEM flag
encountered an error in xp_create_and_assign_umem, the bind code
jumped to the exit routine but erroneously forgot to set the err value
before jumping. This meant that the exit routine thought the setup
went well and set the state of the socket to XSK_BOUND. The xsk socket
release code will then, at application exit, think that this is a
properly setup socket, when it is not, leading to a crash when all
fields in the socket have in fact not been initialized properly. Fix
this by setting the err variable in xsk_bind so that the socket is not
set to XSK_BOUND which leads to the clean-up in xsk_release not being
triggered.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Reported-by: syzbot+ddc7b4944bc61da19b81@syzkaller.appspotmail.com
Fixes: 1c1efc2af158 ("xsk: Create and free buffer pool independently from umem")
---
I have not been able to reproduce this issue using the syzkaller
config and reproducer, so I cannot guarantee it fixes it. But this bug
is real and it is triggered by an out-of-memory in
xp_create_and_assign_umem, just like syzcaller injects, and would lead
to the same crash in dev_hold in xsk_release.
---
 net/xdp/xsk.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 3895697..ba4dfb1 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -703,6 +703,7 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 			xs->pool = xp_create_and_assign_umem(xs,
 							     umem_xs->umem);
 			if (!xs->pool) {
+				err = -ENOMEM;
 				sockfd_put(sock);
 				goto out_unlock;
 			}
-- 
2.7.4

