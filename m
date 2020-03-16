Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7360186607
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 09:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729959AbgCPIDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 04:03:32 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35762 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728302AbgCPIDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 04:03:32 -0400
Received: by mail-wr1-f65.google.com with SMTP id d5so19579790wrc.2
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 01:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G7uFnAhbGnCAd/35b6KpxEmZOXqJ7W+aXdu//w3IrGw=;
        b=lCsPEzZO8/bdrKy1WMYMs0gJO79PlrZ1kl53xRJsOOj8a+cFZo2179IttDcTkpLvQw
         NDuaOuWfJ2KUP2V/Ut6ScQkKSbL7QBxqTvANvNGnZyxYgxFNVi2cg+5jpOvIcbREuJoy
         896xqS14t3g9rYaEyakDO1TyzKJ2r0fYZMeHHpJ5c5rKYt/6SMtKT9cgA3ZBKn7lElp0
         agOnrjWKqWQK3wzIItve+I4lhIBqHDYL5g+zu+T/QrXpcjFLdo5LgzZOU7URpeuS7D64
         cuFUxq7SCzYRW2hYzk7cN17DCJ3lg2YhlgLd9zeTWGtd6FDJ6GkpiHinr2rIeo3zZY/w
         ZosQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G7uFnAhbGnCAd/35b6KpxEmZOXqJ7W+aXdu//w3IrGw=;
        b=Vy2bROWoBIHGFdnBX6mOwYjzgGeSWOAJp9OCyRb55XRn4mBjqkicCa/WTZnUT55mgv
         xiJlMJCRtH+IVeQvEZbABjEXa/AMp8la7fDtB3Bm3oaISN4fk3XdPSOESgOtI4KYLl26
         0RRBOGDHNkvPOzQXbNrdIRWMwBWN67VM1PMvVLo27XfAQpXaaHUn98eKTDyIZDwrFy4w
         Caivcu/mO8biIhHY/6L8fF8hgc4wlCxLVxFNlSzX9PFCd602P8cKxUPedb8eKFKjFUwf
         /pKnmQ395mpDGI0RGQZShw9CNBrKt4lfsMHyPhVpv9TDjxe3a6/gJBwats+XBK75Dn04
         4pnQ==
X-Gm-Message-State: ANhLgQ3iH2/ZF+kMQn1qbWNS3OJc37aNglqfdPG0OHrhmAM0WxPCOjta
        BNefK5Ef7VnwyNwk0yodDUxyXIuKXOo=
X-Google-Smtp-Source: ADFU+vszAci6+gVYgn6bZt762S2hi8rjJalPttblIxw7Rk+XUtJy9d0M0SzNSgW3VBOrCKsw86vP0A==
X-Received: by 2002:adf:bad0:: with SMTP id w16mr32723670wrg.233.1584345807821;
        Mon, 16 Mar 2020 01:03:27 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id o10sm45630972wru.38.2020.03.16.01.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 01:03:26 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        pablo@netfilter.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        paulb@mellanox.com
Subject: [patch net-next] net: sched: set the hw_stats_type in pedit loop
Date:   Mon, 16 Mar 2020 09:03:25 +0100
Message-Id: <20200316080325.6513-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

For a single pedit action, multiple offload entries may be used. Set the
hw_stats_type to all of them.

Fixes: 44f865801741 ("sched: act: allow user to specify type of HW stats for a filter")
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 net/sched/cls_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 2046102a763e..363264ca2e09 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3614,6 +3614,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 				entry->mangle.val = tcf_pedit_val(act, k);
 				entry->mangle.offset = tcf_pedit_offset(act, k);
 				entry = &flow_action->entries[++j];
+				entry->hw_stats_type = act->hw_stats_type;
 			}
 		} else if (is_tcf_csum(act)) {
 			entry->id = FLOW_ACTION_CSUM;
-- 
2.21.1

