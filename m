Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31F0C6A520B
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 04:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjB1DuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 22:50:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbjB1DuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 22:50:03 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6AAE069
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 19:50:02 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id c1so9069121plg.4
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 19:50:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vGEZaS/atbYeqgpVUDpRG7yJgjkR/XxfljYXuqLuPk8=;
        b=GrtW4Pjk/H7su3PESElbMjIhyTTM8pplp59rvirLjeGMQQ/a/FH8Nx05JZZQnyZ4Jg
         R2LMg2dVwok7d014kTY4pNvM1I4iSD6J0yfAnRufbaBE3n8cA54a6DqGzWmrSts0SPMy
         wyoFgM9MzPVj0vkvSpiMSz6MiGd1kOsWEJ88oNOGK+TpYPMxGMsL5XDAI7WtzfGZiX+W
         u1alaLCmknDfJh8Af0Y/4BJSH/mEFgZY+m+MDJSmu96vrETw9qnj/qYiGs9TQlmQN6Lx
         UM7UOVGF2kGNMk5miPUjACEXpmXodao7fvcvUeUbADPKAQ5gNlGI2+dlFg0qBqWlVLyd
         LIJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vGEZaS/atbYeqgpVUDpRG7yJgjkR/XxfljYXuqLuPk8=;
        b=VnO7D3rFn4vB5RtZfVsMZKwyV28zk71aRak/uWyXfCnCSIhntljw7QoUKZC+haDFOL
         irQb+b4uQC7Tw/QkohDeRuplR9pH/DIIGZLGXIq2QoVtOjQtAZneeaTyuHZ93U1kbm0y
         +dXxBsYZmEtDtI5gkux/uv5rHEUlQEorYad+Mtu5QA7EriRcXDrOyT9YGpeV+A3SoH5g
         8Vt8fHVhHcmB/QMAcGIv+MwLrMEDeBW3fu+uSqDAw3dofF4N7U1Rm/HGAVrnJP1Xvl9d
         xa4iLCarIj2tNLBDqxXdwQ4SjWO3mGToaf2KgRg4RtrfMnm1k0VKMjH5BjrhRKxIne0P
         7WUw==
X-Gm-Message-State: AO0yUKV1B6rcu3wHyhrRC52WN05rwXljwrJlsU5uNc9qO82tNPOAjGQe
        D4b9cyG/cW1izUMP3/z2iRckWL4/XyiHFDrQ
X-Google-Smtp-Source: AK7set+oR5Fhpb7l2ikLjZPAEF9WNqJbbNl7HQzfdjC4uTuaPGdbs9P+zw1eAwAQNoPex6adALbcfw==
X-Received: by 2002:a17:902:da8a:b0:199:1e42:2983 with SMTP id j10-20020a170902da8a00b001991e422983mr11151599plx.34.1677556201707;
        Mon, 27 Feb 2023 19:50:01 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id iz12-20020a170902ef8c00b0019945535973sm5348301plb.63.2023.02.27.19.49.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 19:50:00 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH iproute2] u32: fix TC_U32_TERMINAL printing
Date:   Tue, 28 Feb 2023 11:49:55 +0800
Message-Id: <20230228034955.1215122-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
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

We previously printed an asterisk if there was no 'sel' or 'TC_U32_TERMINAL'
flag. However, commit 1ff22754 ("u32: fix json formatting of flowid")
changed the logic to print an asterisk only if there is a 'TC_U32_TERMINAL'
flag. Therefore, we need to fix this regression.

Fixes: 1ff227545ce1 ("u32: fix json formatting of flowid")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tc/f_u32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tc/f_u32.c b/tc/f_u32.c
index bfe9e5f9..de2d0c9e 100644
--- a/tc/f_u32.c
+++ b/tc/f_u32.c
@@ -1273,7 +1273,7 @@ static int u32_print_opt(struct filter_util *qu, FILE *f, struct rtattr *opt,
 	if (tb[TCA_U32_CLASSID]) {
 		__u32 classid = rta_getattr_u32(tb[TCA_U32_CLASSID]);
 		SPRINT_BUF(b1);
-		if (sel && (sel->flags & TC_U32_TERMINAL))
+		if (!sel || !(sel->flags & TC_U32_TERMINAL))
 			print_string(PRINT_FP, NULL, "*", NULL);
 
 		print_string(PRINT_ANY, "flowid", "flowid %s ",
-- 
2.38.1

