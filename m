Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D09E33C3EC4
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 20:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235781AbhGKSfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 14:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbhGKSfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 14:35:37 -0400
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFDF4C0613DD
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 11:32:50 -0700 (PDT)
Received: by mail-oo1-xc36.google.com with SMTP id e203-20020a4a55d40000b029025f4693434bso431078oob.3
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 11:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ERkmkf6rZ7IRgG3dZCtHVrLHv372iihkx7KB9E1cios=;
        b=TYk6ZcH8M/Ipl5aUCoLdo5q/JQ0ZNxQPOjmrKesCca27fU6ut9s5jf1jVuSdL5Ow19
         v38JTTC5Gg4mCgKgEPjL3H7dkrcFfIRkxl+NiiXQMTLuHrqctyIXOWeRalW+nS/b/el7
         i0qQt60xXXlCNiSsFcj4290y71a2I0odf54Gvc5MuRHCUpka1xYKnLAhzb/lVByQ+AbD
         IZ/nNN6vGJjgrJ0JVv2mUZ0UD6PZv/7pBSyVWLKO/lkk0xxg/XlWQAJ73eEeKpHKCQqw
         vTt2kHUNN7vmeHtJMJ5sdJ0dwjgRp1I8E3USUQVhm/jjTf9cyorTy+qSezFkhyxJFoV5
         jKGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ERkmkf6rZ7IRgG3dZCtHVrLHv372iihkx7KB9E1cios=;
        b=H3kVEDtrygwFJg3AuUZ76oW5RYGlU386r2gtVGCQpfsORRglH+tPES2K/b6g0knAaG
         13Rk6xcbW5bjzePdvWDhx7a+pWJnhhLgeynt0wQsxBj0wxblpywwdO6cqrD7ikRQD7Ih
         w8uBa8cbvvlytJPmWrTz5wDKrj/sn+s05gtYRHYjIgK329A36z387tF0G/DCW+rVHesR
         WIZQg87IqXEqQz/i5ffWv+6CiLEt7r4yEwlqnUMcqZ2djebBe7MivXAZ0JjqbqU1wU70
         IdgcaXViuUBXjgHO5ziLgmB/jM12gkijAPwbozc8Vm3Z4vB01QCSWz0nftLEkzH7UOS6
         J86g==
X-Gm-Message-State: AOAM530qAnMSLfufHvUtJbVWUkWe24mh5eVU5IBkyXeAbYuUBfO14IcK
        v2qiVyVPOGmZa5g1TKeHDwlxfS3pxHs=
X-Google-Smtp-Source: ABdhPJx/Tjn0MMAOGQQHiemnhY+mHDr5vKGLhE+A7uJNpUV3dlSumDv4zs/PgQboX1fySUMhCXaEeQ==
X-Received: by 2002:a4a:ae8c:: with SMTP id u12mr34627516oon.3.1626028369929;
        Sun, 11 Jul 2021 11:32:49 -0700 (PDT)
Received: from unknown.attlocal.net (76-217-55-94.lightspeed.sntcca.sbcglobal.net. [76.217.55.94])
        by smtp.gmail.com with ESMTPSA id o1sm2648675oik.19.2021.07.11.11.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 11:32:49 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [Patch net-next v2] net_sched: use %px to print skb address in trace_qdisc_dequeue()
Date:   Sun, 11 Jul 2021 11:32:34 -0700
Message-Id: <20210711183234.7889-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210711183234.7889-1-xiyou.wangcong@gmail.com>
References: <20210711183234.7889-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qitao Xu <qitao.xu@bytedance.com>

Print format of skbaddr is changed to %px from %p, because we want
to use skb address as a quick way to identify a packet.

Note, trace ring buffer is only accessible to privileged users,
it is safe to use a real kernel address here.

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
---
 include/trace/events/qdisc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/qdisc.h b/include/trace/events/qdisc.h
index 330d32d84485..58209557cb3a 100644
--- a/include/trace/events/qdisc.h
+++ b/include/trace/events/qdisc.h
@@ -41,7 +41,7 @@ TRACE_EVENT(qdisc_dequeue,
 		__entry->txq_state	= txq->state;
 	),
 
-	TP_printk("dequeue ifindex=%d qdisc handle=0x%X parent=0x%X txq_state=0x%lX packets=%d skbaddr=%p",
+	TP_printk("dequeue ifindex=%d qdisc handle=0x%X parent=0x%X txq_state=0x%lX packets=%d skbaddr=%px",
 		  __entry->ifindex, __entry->handle, __entry->parent,
 		  __entry->txq_state, __entry->packets, __entry->skbaddr )
 );
-- 
2.27.0

