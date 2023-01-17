Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 703F366D6C8
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 08:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbjAQHTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 02:19:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234106AbjAQHTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 02:19:39 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C741C22DC7
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 23:19:38 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id s67so21292205pgs.3
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 23:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5fl11/Q4zSVGzUB2sTNnjT/Fh0Q8bG09DtS3M7GVU9s=;
        b=hLD6hiDQHy+C0VUo7PDQhbFAwUA8QgXW37HujwSZ0okfR0RUdGUhZAC1oIVR4EujPg
         4P1vJK41+dluP/SFW37sSEMQpFPDl7GVHmP7luRMReFm1EOyt0vqSJXIW8xl+KySk5vv
         Wzy3Z0da8hwbV5lTaTObx3x6PtJ+osWqF/bW+q8uBKsxxrRbeqM2qSsRlpxvSKLuWy2/
         sFZgY7kknANLXr0dk1w7RWJS8XYoSj/9pGTWweINMPBr8RwGtsmBeljD8stdlnmB7f1J
         StKW+LcywwNIPHdRzUyACJa2KXrZX5gpR5ZjfWvwTafp9XXJZGrFAIUPBNKVnchQdrUr
         XAsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5fl11/Q4zSVGzUB2sTNnjT/Fh0Q8bG09DtS3M7GVU9s=;
        b=IwniFowDM3dArlAVIHYTixpdXBwWzeu9YCq/xGHaLrfisED8nsA/7Me+bMXARwCzQz
         zCo4glCMlEdzEfa+dbwPcyqnCQe3KFcPxDJ32zTDKF4m3Vnfry9iMBbukn8jOz4toboX
         9j4wNXyryR63Vjy5O1KfFdEfYcwqASkL/pWKPLU6fIuqHSBopXvxwpeqUmOX6G23Y1DG
         E5Vgo+hj4567ufnfnivkwJ3rnfwphHpIaXRvRkKx1rXeLgf/tdsaEkjUjdOvhd98Pw8t
         ejRKuu9iHqkmOtnYelmOHownWyDUDNlDdL/rukzGI1BS6CwCQphl+TR2nX5tJmNysRzq
         YXcw==
X-Gm-Message-State: AFqh2kognQqu4/R8jZhyLPpdvkvgFYOOfhsnEmMeaGIq/rrAcfrfjc3e
        /MmmatGpPCsgB7i1brHAPclWX+WrVnhh5ryZ
X-Google-Smtp-Source: AMrXdXuN4spmb+R3UM0nL3mUJ4p8phFksAuqmBYrZdXlApgoy+Tw0k+4JorrWWDK7Pe8yGWGF2kHmg==
X-Received: by 2002:a62:1751:0:b0:56b:3758:a2d9 with SMTP id 78-20020a621751000000b0056b3758a2d9mr2498730pfx.21.1673939976996;
        Mon, 16 Jan 2023 23:19:36 -0800 (PST)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id f12-20020aa7968c000000b005871b73e27dsm5972552pfk.33.2023.01.16.23.19.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 23:19:36 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 iproute2-next 1/2] Revert "tc/tc_monitor: print netlink extack message"
Date:   Tue, 17 Jan 2023 15:19:24 +0800
Message-Id: <20230117071925.3707106-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230117071925.3707106-1-liuhangbin@gmail.com>
References: <20230113034353.2766735-1-liuhangbin@gmail.com>
 <20230117071925.3707106-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 0cc5533b ("tc/tc_monitor: print netlink extack message")
as the commit mentioned is not applied to upstream.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v2: no update
---
 tc/tc_monitor.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tc/tc_monitor.c b/tc/tc_monitor.c
index 64f31491..b656cfbc 100644
--- a/tc/tc_monitor.c
+++ b/tc/tc_monitor.c
@@ -42,9 +42,6 @@ static int accept_tcmsg(struct rtnl_ctrl_data *ctrl,
 	if (timestamp)
 		print_timestamp(fp);
 
-	if (n->nlmsg_type == NLMSG_DONE)
-		nl_dump_ext_ack_done(n, 0, 0);
-
 	if (n->nlmsg_type == RTM_NEWTFILTER ||
 	    n->nlmsg_type == RTM_DELTFILTER ||
 	    n->nlmsg_type == RTM_NEWCHAIN ||
-- 
2.38.1

