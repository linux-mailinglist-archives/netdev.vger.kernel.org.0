Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5D83A1134
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238937AbhFIKgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 06:36:13 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:40853 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238857AbhFIKgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 06:36:10 -0400
Received: by mail-pj1-f65.google.com with SMTP id mp5-20020a17090b1905b029016dd057935fso1122429pjb.5;
        Wed, 09 Jun 2021 03:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q/qUEiTaZqU80Aj83G+P7i7Qbg/nqwjKGvNvAhi7mBs=;
        b=jPhTasggZ+p7tcBGoZAKbkPMkJEuvXFGWFPOJzRufjattCvvGUHMJq2VonqhH17cmx
         N+22FR8fdBUTEwcgDg2T0NdEqKklny0uWO6ujNHn10Ndl9ler/hl+vT36xJD3OJFH3vW
         SoBi/dl4YAm/NQPX3k+TwAqigAc8IvdGnBERaejHz6i2Ol2WPcNWOANpCQJImvvWNDZ/
         Dt1VA9ghdyaUD60a6v6gbF9mdtOJjVnkP6yAljwwo39pV0BhGGNr1YJIzmYgkM3Zht0C
         fH8mtyxaXbWt0TqMkXMduz+1v1T3kGtsGkvvDpqZCb3bKeeofYh6NMYWWNSoINl8izCY
         1Qvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q/qUEiTaZqU80Aj83G+P7i7Qbg/nqwjKGvNvAhi7mBs=;
        b=QQw+v11aQyIG2HMUkSijVWwxDZZefnTcQv+kul5I+o+Y4vCTBzMn6dOYZMJeup0/WS
         8bVxktcIlGU5RIMfzQGDvr98a1QqjQDddduAPv5/k2m/LSud5PRBA+HOauQ0TfVOHNin
         nmNOy3vsIAjCmFsoQmAopl+/q7nx5KiSpayPFagmNiQWEZh+KqYEAbNr1OXewW5YbDwk
         2Cf25vC5sXGEJcJ8kg/8UN3aj3I36atIU0nZ7h90FwrPrsLoevKxDEP4YgqK9rUsSduR
         DgsrTB5TTNfBkVdxSBGAPdRM8SgzUABBjfxJiCeHpsE9TNQma9Dstm7A5ZUUFbNzPLyr
         1fUw==
X-Gm-Message-State: AOAM530PWKQhVu/x/tfRgWOmdsZZFpvBsytL0tKzimnUTRAoF8JWFGaO
        m0vfR69o6aWqSdpkhYONDF51/7RZ7MB29A==
X-Google-Smtp-Source: ABdhPJwwqD6LZ0rKa1dtnBgdCAhdfndizRuLG2we/psS/iclQ9ZOwsb8qAU6pgoBInRfhY+rb4NgUg==
X-Received: by 2002:a17:902:7b8a:b029:109:7bdb:ed9 with SMTP id w10-20020a1709027b8ab02901097bdb0ed9mr4663206pll.73.1623234783885;
        Wed, 09 Jun 2021 03:33:03 -0700 (PDT)
Received: from localhost ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id u2sm528161pfg.67.2021.06.09.03.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 03:33:03 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     jmaloy@redhat.com
Cc:     ying.xue@windriver.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH v2 net-next 0/2] net: tipc: fix FB_MTU eat two pages and do some code cleanup
Date:   Wed,  9 Jun 2021 18:32:49 +0800
Message-Id: <20210609103251.534270-1-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

In the first patch, FB_MTU is redefined to make sure data size will not
exceed PAGE_SIZE. Besides, I removed the alignment for buf_size in
tipc_buf_acquire, because skb_alloc_fclone will do the alignment job.

In the second patch, I removed align() in msg.c and replace it with
ALIGN().




Menglong Dong (2):
  net: tipc: fix FB_MTU eat two pages
  net: tipc: replace align() with ALIGN in msg.c

 net/tipc/bcast.c |  2 +-
 net/tipc/msg.c   | 31 ++++++++++++++-----------------
 net/tipc/msg.h   |  3 ++-
 3 files changed, 17 insertions(+), 19 deletions(-)

-- 
2.32.0

