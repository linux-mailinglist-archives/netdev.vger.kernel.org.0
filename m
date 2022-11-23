Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB1E7634E9A
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 05:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234684AbiKWEJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 23:09:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234338AbiKWEJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 23:09:50 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB9B6E54D
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 20:09:49 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id f71-20020a25384a000000b006dd7876e98eso15245901yba.15
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 20:09:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gglhREQDkaHxLIhp8j1JCYsbvlNejceTayiRnE7kMjI=;
        b=BFKCbd1QGdTwe9LlgMJQ/g9FnAflvVk8BJoiSBfVsUzeDtAuLzKvehcZXxT+ieEN0B
         gCJdf1ek2aP5x3uE+tV3tz9OKlrYVGLn9pybS6vkQldX62cgW5eV8/eQJeN60xK+zzpZ
         ze6amA4yn47pwRxQQFRM8chfIWqu3dWfEAhL/NCn65D4P/SUG0ArY5vaYObSruFyWpZH
         FSjd6HzyAQx4GeFVVtj7N4pv84JvxCh69e76MIIOD0buGSaY1i+Z6NgUSQC3xl9iaIUb
         wMqNEDm3SrG3H+xsLCLbLrnWzFLs33mbYQGsD7aJw8GgbDg08+FPM+2onFX0VnIkNH94
         oywA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gglhREQDkaHxLIhp8j1JCYsbvlNejceTayiRnE7kMjI=;
        b=Pw1SjDQLwBmsoUI9qe1oKPXiKmB6CU1puO5XG2K6WuNIQhnW1v3FrSlQY6mJI6t/BA
         llIRCyEbTQGS4X8E42ujPCWNmDbl1nhOPuuKoPA4i9x+jkwahzcAEkbBmwT2gBjrUBK8
         7HJNG8otndr2ya9GtLmKb00CnypYmHmpCMZEsz7G2kfniwl+FFsOpypdZPspXEwCh3yg
         tE7+NcCylpLaeyjMc4spdrKpMc+QCkQcDB6WDY6fQBQaI8LyyWQyi71Z0XHdE1WFH12b
         WPqsDNju6rPM1gkiBD0vK1AfWIY7p8TGI7PX84CJ7AMuulrL+hukvpZb8QLBVXGICqGZ
         uTIg==
X-Gm-Message-State: ANoB5plLSprTeQBKnwxU4f2KqK/DAQNBE1kxzdVtYydTKpg1CZftk+jF
        tPJrEdu9PRQ01/wrA8JgGzkCm/RLkuCaMjnfzbdkrplcEQNR/D3O6QBhEbjRFP0XFzLTkbELzL0
        1mhmdvoFmxVnp50PrJIrIZlu4/KiLUrYAl+3exVnfvliYUhRVrHBAYQ==
X-Google-Smtp-Source: AA0mqf5pmnOmdKEhBl9m2jj+4cdEBx7ZLgJ4FD1g1kmQxkuhJ4nOd0kK95ptpkR+fFOdiG88UblWDz8=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a25:ba92:0:b0:6d3:66bb:786b with SMTP id
 s18-20020a25ba92000000b006d366bb786bmr25910828ybg.459.1669176588984; Tue, 22
 Nov 2022 20:09:48 -0800 (PST)
Date:   Tue, 22 Nov 2022 20:09:47 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221123040947.1015721-1-sdf@google.com>
Subject: [PATCH net-next] net: use %pS for kfree_skb tracing event location
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the cases where 'reason' doesn't give any clue, it's still
nice to be able to track the kfree_skb caller location. %p doesn't
help much so let's use %pS which prints the symbol+offset.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/trace/events/skb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 50a974f7dfb4..25ab1ff9423d 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -42,7 +42,7 @@ TRACE_EVENT(kfree_skb,
 		__entry->reason = reason;
 	),
 
-	TP_printk("skbaddr=%p protocol=%u location=%p reason: %s",
+	TP_printk("skbaddr=%p protocol=%u location=%pS reason: %s",
 		  __entry->skbaddr, __entry->protocol, __entry->location,
 		  __print_symbolic(__entry->reason,
 				   DEFINE_DROP_REASON(FN, FNe)))
-- 
2.38.1.584.g0f3c55d4c2-goog

