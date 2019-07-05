Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18B0160B83
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 20:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfGESqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 14:46:48 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:39767 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfGESqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 14:46:48 -0400
Received: by mail-qk1-f201.google.com with SMTP id j17so10152119qki.6
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 11:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=LPRFSq2jkU0dV73F1lMLde+MhHFzOkKJem3K3J6dAi0=;
        b=kbQqTZXJdTH8T/Llj9Ooyjl+SlCPPBF1cJpg73hImYwD9h0HRdYB82yRUkuIvFfQR6
         QEIuhYPUWeC2UK3Cn1I5UxRvM3FEkom46Z5p9iLzO+ESEdME4tJKCInvgDPTwJRfQPX5
         uetNBN4UZzkOdLReuOga9ulDZGkpqqHyZzSjPXnCF36AKCAlgsZa8EZalyh7IWkO12q4
         KmMo8hW5XOZeO0rLW16E9qZKovkDgQqr4bq84GJPedEFWtcMcTYb2DewFj4SB5hvR/Ad
         o0VFTr+Xq5gjPiD238zaQ5LWCBYqN1A7JaLiV/9OvQBbAURySyxgJG+NaH0ADmJHZmJT
         8L5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=LPRFSq2jkU0dV73F1lMLde+MhHFzOkKJem3K3J6dAi0=;
        b=JyQlKP2gcU9Q8Nbe/inOCyhDIaFHKvPV9IIDHYJaS7mXY9J9OlhUqSGvNP/EiF1jes
         9/ta501nO4i4Srk/g8zA2zUEdRbNUfjnPSZ99I19nPqOtVdO3o3mLfgwR/zjGtIYtnvd
         aQE0z0VTmN2bdUw18TkdxbFsgV+MoJH5PG2De92Gxspw9C5QZ2fIzC5L+ZTJgUj2l8Tk
         chgp8q7rhqWafFZ9eu7U4n5+kUFLLhjIJMl5TA36LelpfysjvIg0PSudZaKFY1wQ1u3m
         v6X+vT9YrRydF8MOKlrAuSXo+rZtZhenzme/cZ/dzi6TwSNOaSrlIjnLXhLmiQZ9qVoO
         XXkw==
X-Gm-Message-State: APjAAAWh6oabwXPsmjgENe8wyFZo+uuW3lIw6zqQzL0wYtV7Gi224smc
        QEbfi19s8qhJYFZdy9eAEb2a5HntRMtsIOHs8dO6su6P3Gi/6VdqoK3NmT86IVy9GUbNu9Vyilb
        dCwgJiWFfy/KnNpGCTxaanwfif/7FBR0JBZ6C1J9jeAxQDzrZvM3R/lEAgoLmsz56
X-Google-Smtp-Source: APXvYqz7LKKOQ83PfBF0cu+4Y/AGrexUsLcG3xrt1rXKbxiuX63y8IGy0KWLgDZuBTB/RyjCkQv5Z8cJRMBB
X-Received: by 2002:a0c:9890:: with SMTP id f16mr4585961qvd.165.1562352407110;
 Fri, 05 Jul 2019 11:46:47 -0700 (PDT)
Date:   Fri,  5 Jul 2019 11:46:43 -0700
Message-Id: <20190705184643.249884-1-ppenkov@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [net-next] net: fib_rules: do not flow dissect local packets
From:   Petar Penkov <ppenkov@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        edumazet@google.com, Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rules matching on loopback iif do not need early flow dissection as the
packet originates from the host. Stop counting such rules in
fib_rule_requires_fldissect

Signed-off-by: Petar Penkov <ppenkov@google.com>
---
 include/net/fib_rules.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/fib_rules.h b/include/net/fib_rules.h
index eba8465e1d86..20dcadd8eed9 100644
--- a/include/net/fib_rules.h
+++ b/include/net/fib_rules.h
@@ -180,9 +180,9 @@ static inline bool fib_rule_port_range_compare(struct fib_rule_port_range *a,
 
 static inline bool fib_rule_requires_fldissect(struct fib_rule *rule)
 {
-	return rule->ip_proto ||
+	return rule->iifindex != LOOPBACK_IFINDEX && (rule->ip_proto ||
 		fib_rule_port_range_set(&rule->sport_range) ||
-		fib_rule_port_range_set(&rule->dport_range);
+		fib_rule_port_range_set(&rule->dport_range));
 }
 
 struct fib_rules_ops *fib_rules_register(const struct fib_rules_ops *,
-- 
2.22.0.410.gd8fdbe21b5-goog

