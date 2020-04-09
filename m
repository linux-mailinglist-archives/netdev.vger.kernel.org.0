Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54CCE1A390E
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 19:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgDIRmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 13:42:16 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43047 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgDIRmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 13:42:13 -0400
Received: by mail-pf1-f195.google.com with SMTP id l1so2497604pff.10
        for <netdev@vger.kernel.org>; Thu, 09 Apr 2020 10:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sslab.ics.keio.ac.jp; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0wmybZU2XYC2ZQZ6lGBEg07+Q6ic1u6zQ08/WgqtdVE=;
        b=GxK81g5FBJ92hDAuB3j7A6f3OXdPrAuS646UimLd/yyBcfDvfcaSaqv6N3slbFBySb
         7f5d1EolpYJ4Hg7bdcUtW4cH5UOE5WYQKSUPmCajFmfqivS6UOP2pbNO8ulvrNur29y0
         QnKB1OBb7RJxn2hGmyYlD8MFlBiGU+GZQTgbQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0wmybZU2XYC2ZQZ6lGBEg07+Q6ic1u6zQ08/WgqtdVE=;
        b=f3LHus4/fqcx29hGjmAo1U9sIsZIOLOfKMdB8DQgLidwZtY6e93+spKZUoxzEjYPLx
         iWP+qyKpUkEMafTcPH1O8C1uXLQ3Vm6asJg8hidwal3iWns9c8cnxYjZLCyOL31pTnfc
         aQGGq6Tb0UjYsg67gdtVTtYVbOlmu70DCkOe90O/PhwCutcz/p7lPoyW8TfEzYpvSunt
         +3v0yikwiX13flVc4CqwfnhWBjupTZRJDCQf22MActz0rE8x2ctywfT3KczMLyhAbEYX
         n+nqeZqshuHHnkakLFJkWU8Ci0/vKOgnRA31o5sOesgns5C63CS7WNWifxIdozcs1o8G
         T3+g==
X-Gm-Message-State: AGi0PuaY4jzzJ8DtlsStt+45o60+w5ZQAdSD/XHnokweiMY20QGvpkWw
        9KrVrtFPyLjj/4cHXEo/kwFDyA==
X-Google-Smtp-Source: APiQypJ4shH8Bv2b1K68QcLJdeS1QZon1I4ElY5DpScBRbUghLnzZ2+fu/chvC9jeb2siGu3fNepeQ==
X-Received: by 2002:a62:4ec4:: with SMTP id c187mr677435pfb.223.1586454132444;
        Thu, 09 Apr 2020 10:42:12 -0700 (PDT)
Received: from brooklyn.i.sslab.ics.keio.ac.jp (sslab-relay.ics.keio.ac.jp. [131.113.126.173])
        by smtp.googlemail.com with ESMTPSA id e187sm19140287pfe.143.2020.04.09.10.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 10:42:11 -0700 (PDT)
From:   Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
Cc:     keitasuzuki.park@sslab.ics.keio.ac.jp,
        takafumi.kubota1012@sslab.ics.keio.ac.jp, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        oss-drivers@netronome.com (open list:NETRONOME ETHERNET DRIVERS),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] nfp: Fix memory leak in nfp_resource_acquire()
Date:   Thu,  9 Apr 2020 17:41:11 +0000
Message-Id: <20200409174113.28635-1-keitasuzuki.park@sslab.ics.keio.ac.jp>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200409150210.15488-1-keitasuzuki.park@sslab.ics.keio.ac.jp>
References: <20200409150210.15488-1-keitasuzuki.park@sslab.ics.keio.ac.jp>
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes a memory leak in nfp_resource_acquire(). res->mutex is
alllocated in nfp_resource_try_acquire(). However, when
msleep_interruptible() or time_is_before_eq_jiffies() fails, it falls
into err_fails path where res is freed, but res->mutex is not.

Fix this by changing call to free to nfp_resource_release().

Signed-off-by: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
---
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_resource.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_resource.c
index ce7492a6a98f..95e7bdc95652 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_resource.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_resource.c
@@ -200,7 +200,7 @@ nfp_resource_acquire(struct nfp_cpp *cpp, const char *name)
 
 err_free:
 	nfp_cpp_mutex_free(dev_mutex);
-	kfree(res);
+	nfp_resource_release(res);
 	return ERR_PTR(err);
 }
 
-- 
2.17.1

