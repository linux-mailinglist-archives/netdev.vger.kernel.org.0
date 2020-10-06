Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD0B32845D3
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 08:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgJFGMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 02:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgJFGMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 02:12:18 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80B1C0613A7
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 23:12:17 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id o25so7413960pgm.0
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 23:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3iJn/SEkkuagk6iNHHSbaftdnkGl8+optOMxbRPz3jk=;
        b=U8hpGB4GSBayuzOK3SR37ML1nqFdWRwWQbdzEA+KgsO70Rkp5RYsl18VMUYCNCFO06
         Pu4Y23BqffRIhqF6VozmcrFNxNMisHV7AcO2yhgpIiEKPW9IH66D5OTAHj6cMCxw0nP/
         u7FXvdK/BoPm1CsV5h+iiqPfb55wN1MoNuBlD5mUU1uVYv+z8zK+9/blO7ZL1kTAR51x
         qKSEO+FvlQZXv2LiHNpXQausarJxuFWHvM0nCJcol7HDh7Eyx5V2DuWR72fbekMhC82a
         SJ8s7xcML9+sLV7fXk21OPhbzZZybUgYjJEvUP47z5Z9yDXqwgcqjoVBLVm9yqdjVFhr
         B5TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3iJn/SEkkuagk6iNHHSbaftdnkGl8+optOMxbRPz3jk=;
        b=ZaTlr5kks8G3zeL8gzFkA4co3UqEHxs88XnVTwLBp0N4SQV7u6hwYkjU7EEZeIimcF
         957iUGu5i2JrG+aKNfsPwY6WZuQNTmCRaHEOYeOkNrcZhNlnuCW5AcP4TwwTdu0rBXNZ
         C0FVmVKih04zEsE1GBM6r7BF39cIDwN0MZivUkZzbJe8uFIl/m+G6TJoxDFz4RcGFw+w
         bcoLFsboEdSRFfUtVgKlRRkR/UhfWeE84QPJ91bMY1i3A9tTVkrB7OFSVQJdl4qTEKWo
         6lAbfYh10EH+LCWoA/8jnKjHcVyVT5/v+DYK9/lbXbMBeIpirxjas7rxh3xg3US79fSX
         CYgA==
X-Gm-Message-State: AOAM532u2egbp8pAuWuwHiwHjMLZ+rRjp3R7ctkWLyqQI+IBgP+fZgKI
        BOujAgTY8ywiI97enATBdi4=
X-Google-Smtp-Source: ABdhPJx5W4ivBXJySaJs46khpZJVwAiNkLi3lSq3Wy+TpiIpkM8/QY4Mk6OC1IkSXKq0ybikYePCnw==
X-Received: by 2002:aa7:9f04:0:b029:13e:d13d:a08c with SMTP id g4-20020aa79f040000b029013ed13da08cmr3027299pfr.35.1601964737066;
        Mon, 05 Oct 2020 23:12:17 -0700 (PDT)
Received: from localhost.localdomain ([49.207.203.202])
        by smtp.gmail.com with ESMTPSA id c12sm2046410pfj.164.2020.10.05.23.12.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 23:12:16 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     m.grzeschik@pengutronix.de, kuba@kernel.org, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, petkan@nucleusys.com,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [next-next v3 01/10] net: arcnet: convert tasklets to use new tasklet_setup() API
Date:   Tue,  6 Oct 2020 11:41:50 +0530
Message-Id: <20201006061159.292340-2-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201006061159.292340-1-allen.lkml@gmail.com>
References: <20201006061159.292340-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 drivers/net/arcnet/arcnet.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/arcnet/arcnet.c b/drivers/net/arcnet/arcnet.c
index e04efc0a5..69d8920e3 100644
--- a/drivers/net/arcnet/arcnet.c
+++ b/drivers/net/arcnet/arcnet.c
@@ -393,9 +393,9 @@ static void arcnet_timer(struct timer_list *t)
 	}
 }
 
-static void arcnet_reply_tasklet(unsigned long data)
+static void arcnet_reply_tasklet(struct tasklet_struct *t)
 {
-	struct arcnet_local *lp = (struct arcnet_local *)data;
+	struct arcnet_local *lp = from_tasklet(lp, t, reply_tasklet);
 
 	struct sk_buff *ackskb, *skb;
 	struct sock_exterr_skb *serr;
@@ -483,8 +483,7 @@ int arcnet_open(struct net_device *dev)
 		arc_cont(D_PROTO, "\n");
 	}
 
-	tasklet_init(&lp->reply_tasklet, arcnet_reply_tasklet,
-		     (unsigned long)lp);
+	tasklet_setup(&lp->reply_tasklet, arcnet_reply_tasklet);
 
 	arc_printk(D_INIT, dev, "arcnet_open: resetting card.\n");
 
-- 
2.25.1

