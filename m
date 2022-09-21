Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0392C5BFA2A
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 11:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbiIUJGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 05:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbiIUJGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 05:06:16 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4920D7A538;
        Wed, 21 Sep 2022 02:06:14 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id d64-20020a17090a6f4600b00202ce056566so13552424pjk.4;
        Wed, 21 Sep 2022 02:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=VzZStH5UD9Ugil1QH1Ivqzqr3mKYxOMviab20JVXFhE=;
        b=ImWXlRFaJrCeQAssnA6dSFYbjwoPDKAiF+/9xHDiF88g2vj2vAh+cvI4BjB3NDs2ze
         ilnQaVEoDNsBMIgQw6BWc0ubSlUTVTmlhMdnFvvtwk4es5hdUU++UfjQhqMeDp55bNiJ
         On25mDmfTxK3Uk/JEy6hl/VA6RAN5F+N07WoKQAXGNO8Xs5QZ5WSQlJA2K19YrnKGoeV
         bFuHO+XvOKynHJwOfRqKhibRNtzQ7CBWxCSsjEDaBRtpELxE4Qy+R1vCilWZNJYgIyDW
         HMfcRqiqyCUMg0CgjIQWn9UA30mxTtdjmaTsbm5Vhs8zpCkoF4MB0InSknTo8FGd7atc
         0CJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=VzZStH5UD9Ugil1QH1Ivqzqr3mKYxOMviab20JVXFhE=;
        b=doWu2YLGNfOU07pgby/cvK40hcXlLU+uFHqd1DNotelbHKbrOyPcVfDIAb6K7uTDG1
         MAW+eg83zJAdR/L3x//UCNgpZmgM4fPamsa8vZiaN2+NKkTt2aq3IRj5N5YgBmPmPPD8
         tKRxqVvvWnSv+15seioiRTzoaS2b9faHmDRE/TPeFkYYfHzTMQAVeO1Yb2N6w6v7YZAd
         PpsOMSYPJT4Ml4CV+bJ5lfoad+jGrX3f9e7ocIuygIUjwCQtC7vaf8X8RLmijRHKf4j6
         DwpLnGA12gCzWmZVsaHtWZobuVpvz6jTiIuq4CFkV57VXrhdqXJtw9rmOlt0D5Dv1nci
         0jNw==
X-Gm-Message-State: ACrzQf3qkO3wZjMJ6jCYJMX/qJCo3OJKPud2PHQQjDt/DmY+3hJfbpvh
        CbwTjaaBpOtvtcwk4LHNONA=
X-Google-Smtp-Source: AMsMyM4zrm4/SU23SPvoIUV/VMIK6ziKZIhfAFu7IaKLBUywluoyGAAUpIN4hnaLQTvorK6UbeEfBA==
X-Received: by 2002:a17:90b:4f86:b0:203:bbe8:137c with SMTP id qe6-20020a17090b4f8600b00203bbe8137cmr4490043pjb.47.1663751173952;
        Wed, 21 Sep 2022 02:06:13 -0700 (PDT)
Received: from hbh25y.. ([129.227.150.140])
        by smtp.gmail.com with ESMTPSA id y26-20020aa79afa000000b0053ebe7ffddcsm1582095pfp.116.2022.09.21.02.06.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 02:06:12 -0700 (PDT)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, paulb@mellanox.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH] net: sched: act_ct: fix possible refcount leak in tcf_ct_init()
Date:   Wed, 21 Sep 2022 17:06:00 +0800
Message-Id: <20220921090600.29673-1-hbh25y@gmail.com>
X-Mailer: git-send-email 2.34.1
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

nf_ct_put need to be called to put the refcount got by tcf_ct_fill_params
to avoid possible refcount leak when tcf_ct_flow_table_get fails.

Fixes: c34b961a2492 ("net/sched: act_ct: Create nf flow table per zone")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---
 net/sched/act_ct.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index d55afb8d14be..3646956fc717 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1412,6 +1412,8 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 cleanup:
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
+	if (params->tmpl)
+		nf_ct_put(params->tmpl);
 	kfree(params);
 	tcf_idr_release(*a, bind);
 	return err;
-- 
2.34.1

