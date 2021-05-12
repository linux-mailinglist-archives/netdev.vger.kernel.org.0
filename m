Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45F337EEA6
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 01:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbhELV7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 17:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237185AbhELVmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 17:42:23 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF02DC0430FD
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 14:30:08 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id j10so35730739lfb.12
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 14:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yHTjUhO+jccT08tr4NuDmY1C0NofVxpPleFiCFojqUY=;
        b=lBSsiRftBHglgjc4wzP2MbNCOU77ME8rP1ac6UD2Im2p7Nz5yjJq0Xq7s/7gMRXurm
         0xHAQFWglgEW0TK0/vay6MTBRk9rY8a9pnOGw2nM9nkDdgWJ4KZMLC4GOrMIR7lmFjJl
         xoNMnRQGrl8guz0o+IcsBeTc1gXfqVbeL0B1G42Cf2zQxbd3/NlX7GnBNACyJiA/pklm
         /D0sPOPhD/HaILCZqWhzhCfz5b+X3ezeGYt7XmLDjTJ7XnnmGa5RotrMyF3bUnVEA0GC
         lrBWNPrhCKicy80/+2O6ihxfQ6H9JWygU0G+/R0H0d78k9tzoI4v+eQg3N8SL/kCkai8
         4R6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yHTjUhO+jccT08tr4NuDmY1C0NofVxpPleFiCFojqUY=;
        b=cMO0uhZr46jJYq32coc1tYA/2TbNLLrAOAGwJuw5IjHzyURBztcollhUby99sSMf8+
         F1Nfh5ayYAxLUtDBDTm2UiZx4OpAt4tnBmL2hTqGCJCA2kmPsKq5ieD03RmfxY3xpFzG
         36S5Ljg+skF1kWYPuKIneDivLtpN3XTsvr5PPxWTQM4RnTq7UcHUJgi4QwKsbpdYn+sj
         g8XpES2LqAPuRcZJYK5Ln3a6uSpYWBS3IBec1xMm6naPLhQ6i5KZKlOMAeKJW+RR4fnH
         KDDtZFucI3NlxPDco5NYhVxYuSdXsN7d0NEuu54Hk5TNONTpYJfehFO/zBds46fCh3jr
         VYSw==
X-Gm-Message-State: AOAM533XWxMX3uEmsb93rqMj8/n/TsYXG7q7U4dmOto9m0mmDuniXfCK
        coVxWMjShQYg5EAGoN6yyQQ=
X-Google-Smtp-Source: ABdhPJyipowZnqKUG6uRNACDz/BStdtUgGQ0qpkmXygkxp7KyeC0kyEl9XKN2gk6vTriTGkF+KueLA==
X-Received: by 2002:ac2:54b6:: with SMTP id w22mr26034274lfk.543.1620855007408;
        Wed, 12 May 2021 14:30:07 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id l14sm84997lfc.58.2021.05.12.14.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 14:30:06 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net] netns: export get_net_ns_by_id()
Date:   Thu, 13 May 2021 00:29:56 +0300
Message-Id: <20210512212956.4727-1-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No one loadable module is able to obtain netns by id since the
corresponding function has not been exported. Export it to be able to
use netns id API in loadable modules too as already done for
peernet2id_alloc().

CC: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
 net/core/net_namespace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 43b6ac4c4439..0414406ed664 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -306,6 +306,7 @@ struct net *get_net_ns_by_id(const struct net *net, int id)
 
 	return peer;
 }
+EXPORT_SYMBOL_GPL(get_net_ns_by_id);
 
 /*
  * setup_net runs the initializers for the network namespace object.
-- 
2.26.3

