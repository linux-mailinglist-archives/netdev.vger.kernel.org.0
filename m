Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4D05B96BF
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 10:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiIOI6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 04:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbiIOI6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 04:58:24 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11EEC85FF7;
        Thu, 15 Sep 2022 01:58:23 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id u132so17394804pfc.6;
        Thu, 15 Sep 2022 01:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=zkTOv9uhJwZHe5X/pSISabfC9ElIWylHr0JwJD6jVEQ=;
        b=AkaZ9BOkkX/TeKi3N4zNFJTyy6Iz36CXQMxgM4I1lUEki3bX76l69VzkUMgnf7W0u8
         cKTbSVcSX7AwyQN/u7zPC+GRNO0gWo6hseDOSf4p5e4odF8yuMlzGkK3a7ipZlf0ZSRJ
         X5HTUKbBJhT1/hfXegCziQ3ex53BSszcjsT21DN6wCWChZThJ+BtZbWh+yzcGT/Hh0LF
         ytMg6F0Lsn2CNr3SEwIc1SHD2f9lmQST8vFLYW92PEkUARgXYTpROiUCVcgx2gsRxRs/
         yBxTdArBXZxnEvo4hFgcwMFUlcV/e08ZKbhR92UvH2coj97xFqv3YUewMyF8F76gwZ0f
         sBwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=zkTOv9uhJwZHe5X/pSISabfC9ElIWylHr0JwJD6jVEQ=;
        b=reBTtb2p3n2G0NZgZ1FhrZmyuUebaSh68ghQ8yAPNVec+YYY/RMjCSdbsBth69fEob
         QItFliD142cYcLl/jYereHIAM0qewN/cOXTPBhbV8SFkYAOQZSOGCVm3QDBnIuZcOqMH
         ThImzHOvttShKMkzr/TY53z0v9lenZcT1PaInzsJwcIOhEY7SF8GhgascD1q0LMmBNxm
         oBLcNOr30NqsBRlFrBulSELOotbC+9RR9wNobcWoozrRvHWN3cyE+nwiLS846DxGO547
         juj+9dRYmMtSyrjFGbKsKbD2J3djfxSYSJUv1WQvwioDQhXU5ve+QDBRslDPte0rSEpj
         bj8Q==
X-Gm-Message-State: ACgBeo1RexuC1sO5Qwgd5auOZlTSTstW3sf8fJhkYGjh0JMYIRVxFp1j
        raC1NoiqCI6yUp4QtbRuNsE=
X-Google-Smtp-Source: AA6agR5YXHYumi45Lh0TCssdn84BAb4Xl4zYLIH0kZ2/KQytXWeALf7sFtn0cADm5ugXVMpvka24aw==
X-Received: by 2002:a63:c3:0:b0:439:72d7:7e1f with SMTP id 186-20020a6300c3000000b0043972d77e1fmr4694404pga.524.1663232302571;
        Thu, 15 Sep 2022 01:58:22 -0700 (PDT)
Received: from hbh25y.. ([129.227.150.140])
        by smtp.gmail.com with ESMTPSA id x2-20020a655382000000b00412a708f38asm11221315pgq.35.2022.09.15.01.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 01:58:22 -0700 (PDT)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, vladbu@mellanox.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH] net: sched: fix possible refcount leak in tc_new_tfilter()
Date:   Thu, 15 Sep 2022 16:58:04 +0800
Message-Id: <20220915085804.20894-1-hbh25y@gmail.com>
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

tfilter_put need to be called to put the refount got by tp->ops->get to
avoid possible refcount leak when chain->tmplt_ops == NULL or
chain->tmplt_ops != tp->ops.

Fixes: 7d5509fa0d3d ("net: sched: extend proto ops with 'put' callback")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---
 net/sched/cls_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 790d6809be81..51d175f3fbcb 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2137,6 +2137,7 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 	}
 
 	if (chain->tmplt_ops && chain->tmplt_ops != tp->ops) {
+		tfilter_put(tp, fh);
 		NL_SET_ERR_MSG(extack, "Chain template is set to a different filter kind");
 		err = -EINVAL;
 		goto errout;
-- 
2.34.1

