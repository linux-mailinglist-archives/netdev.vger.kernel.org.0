Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC02225633
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 05:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgGTDiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 23:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgGTDiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 23:38:11 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E74C0619D2;
        Sun, 19 Jul 2020 20:38:11 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id di5so6781196qvb.11;
        Sun, 19 Jul 2020 20:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=oaIzGEEZveiQMSCkbwAGqZZaFN7FoxKI0NJhSLnSxgo=;
        b=AJrEQYs+wh33p+xo/eX/nWpGmj0C2AO1VNt6OnCM/lEy6NqjMgXNSeYIFoQtUIxkcL
         I7ZAEbJFUuWqmYkAEJ+zmaUc57XCpcNr0NXOEXEt3DUAtoor7heG8D1c37yJtHL9yCdQ
         pm4eMZI7AnFXxYYObu1rfnkl5BQJOjZ9Pd50ZrCgg5p7xXumvkVeI6A+1BIqnht4xw20
         /nf0fvaeOfF5GDv/46V1fD+mMjrop3O35Ei22YY9AlLfz1zQCu6WK0avCC9QmxP1mwU/
         abCpuFCcYPLBfl+4mPeh6Ie6xB33Aw9fYJqIVqrHQ6UXBw/nzUzEy4MUhCOeWBQIKZif
         X/Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=oaIzGEEZveiQMSCkbwAGqZZaFN7FoxKI0NJhSLnSxgo=;
        b=YUMTBs8AYVodpk/oBkG7W3lDnpZOxykkdCfXzw7osUEWomPx3mGapd/DcPeq13RrRp
         SQI/KNOXpf/7mPUqKVRoVE86/9vVxP2gAHPrj2njJYzRVahuh9loy8bd3e1oLrGsv2YO
         vnu4Vm7yOqAcAFoySj5iVOs7BVtWUqmO5IjaTyO+NSIUPyAmKSyW3vEXQ3CHrPvd1C86
         r0bjuCe6x5a0WPGyIpHgrJQVStMEl8jqFAtQOAsnEgWJJrWS7ml9jHu0ufO4GoQN5ypB
         47nZqQWisFEWD0KvIZDUJBtdAFK/vvnMXVQh40em4TEGMM+kNB0kZmQinXIcbAdEVpAb
         C9IQ==
X-Gm-Message-State: AOAM5305zA/hyc6eE8h4HclMH6jj3MtyYa0uc9UGqG8gUvqKQxv8GCTg
        m0QE4lk9YtiaRSEaOcaVMyKoz8GOHsB16AlSsig=
X-Google-Smtp-Source: ABdhPJxvXBGS0BD/InarfWy7hgLYeN2zRMrqKRpMyOetQ7B1qzkJJhfNXzpPpGn7ndjLOlugNRSPQ6CvDTUN2kAreEI=
X-Received: by 2002:a0c:f842:: with SMTP id g2mr20183756qvo.181.1595216290583;
 Sun, 19 Jul 2020 20:38:10 -0700 (PDT)
MIME-Version: 1.0
From:   lebon zhou <lebon.zhou@gmail.com>
Date:   Mon, 20 Jul 2020 04:34:58 +0000
Message-ID: <CAEQHRfAC9me4hGA+=+wcOpx+TAzqS723-kr_Y_Ej8dnWHp2fTw@mail.gmail.com>
Subject: [PATCH] Fix memory overwriting issue when copy an address to user space
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When application provided buffer size less than sockaddr_storage, then
kernel will overwrite some memory area which may cause memory corruption,
e.g.: in recvmsg case, let msg_name=malloc(8) and msg_namelen=8, then
usually application can call recvmsg successful but actually application
memory get corrupted.

Fix to return EINVAL when application buffer size less than
sockaddr_storage.

Signed-off-by: lebon.zhou <lebon.zhou@gmail.com>
---
 net/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/socket.c b/net/socket.c
index 976426d03f09..dc32b1b899df 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -229,7 +229,7 @@ static int move_addr_to_user(struct
sockaddr_storage *kaddr, int klen,
         return err;
     if (len > klen)
         len = klen;
-    if (len < 0)
+    if (len < 0 || len < klen)
         return -EINVAL;
     if (len) {
         if (audit_sockaddr(klen, kaddr))
--
2.22.0
