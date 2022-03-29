Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42F614EA7AA
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 08:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232866AbiC2GI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 02:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbiC2GI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 02:08:58 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9CB78938;
        Mon, 28 Mar 2022 23:07:16 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id z16so14974894pfh.3;
        Mon, 28 Mar 2022 23:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SMJ7HA+GhWy/IAmB9jNUXH9QEgpFnaJvqxK6ae+CKGY=;
        b=aHHElCWDjalts8TqZ0B6f0CAhdJmHF6sr/aDWMIUeChXC50KWpl/E1z8DjI4dIB1G9
         EYv5TKjH/vv3KzZPbZz6S7SRiw4jHqFWSpAJnBL4mb04HcugZaEgWl8V2kSvgwrj98Ej
         aqSI4F89WvUv+AjjdFKY/7ienbIKVCsnhe+AXBLPZMeFJRKOHmTIdBkuOtZKrJh6Ic3Y
         xTlk6ouqLhQdgGhkbHTC5lfJ0emeaVWP0pELOKp6k7rbKBBfucC3w1ABUXgK0H0dtuQm
         hDDNnJDNToxrNj1EAjcDgzIK4hlKbxLo4WRkzL1gMEvzHUqTP106VTWegDQBC4Y4+dnj
         MlKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SMJ7HA+GhWy/IAmB9jNUXH9QEgpFnaJvqxK6ae+CKGY=;
        b=RV9eE7djElSLk/Exps6stu0muuJW7d9t8NwNKar0jojL7mkI2OtPiW2MNNdF8GSobA
         /RRpIhBF1eNu0SUlp+WxobNNHf/LK/mlC9yUoVZZWkUUqiNgm/Z9geo88nhBTnNvZhXO
         InH/A2lFDJ+ZO6IKCWMT/b2WGJUjRRCLVqhkfV9s/wSJOSFfVCjdF7lSGnea1jstkKUb
         sPmXhJ/PcPVZ2Mvn1bma/44l/walvS9/UPRCouFGD72dsu8cxOrtiRXlZT0iGp8U+o7Z
         pM6zoC3UVbAN6VmBY9JovDWg5o/GK2mCPHCc4itRS7gwPUGRIwZSBOAYLRjXb5NqDTWO
         QJDQ==
X-Gm-Message-State: AOAM533KWpoaFoAOkCVhcs3CdMXVs64NGe4e9/8hVKHC44JXXHWTokEZ
        Xvb9Pa+ZvAvvcD1Augv3z8M=
X-Google-Smtp-Source: ABdhPJyyXXOioKACQFUU6un5fspuVrPVOiEEhudBCJZQTZKQE/ZoF9mH7tf9KH8pDRiTxxYZkZeZrA==
X-Received: by 2002:a63:68c6:0:b0:380:3fbc:dfb6 with SMTP id d189-20020a6368c6000000b003803fbcdfb6mr865178pgc.326.1648534035603;
        Mon, 28 Mar 2022 23:07:15 -0700 (PDT)
Received: from localhost.localdomain ([180.150.111.33])
        by smtp.gmail.com with ESMTPSA id k3-20020a056a00168300b004f7e60da26csm18967112pfc.182.2022.03.28.23.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 23:07:15 -0700 (PDT)
From:   Jamie Bainbridge <jamie.bainbridge@gmail.com>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jamie Bainbridge <jamie.bainbridge@gmail.com>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] sctp: count singleton chunks in assoc user stats
Date:   Tue, 29 Mar 2022 13:13:36 +1000
Message-Id: <3369a5f0a632571d7439377175051039db29f91d.1648522807.git.jamie.bainbridge@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

singleton chunks (INIT, and less importantly SHUTDOWN and SHUTDOWN-
COMPLETE) are not counted in SCTP_GET_ASOC_STATS "sas_octrlchunks"
counter available to the assoc owner.

INIT (and the SHUTDOWN chunks) are control chunks so they should be
counted as such.

Add counting of singleton chunks so they are properly accounted for.

Signed-off-by: Jamie Bainbridge <jamie.bainbridge@gmail.com>
---
 net/sctp/outqueue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index a18609f608fb786b2532a4febbd72a9737ab906c..e2d7c955f07c80da17c7525159aaf8a053432ae3 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -914,6 +914,7 @@ static void sctp_outq_flush_ctrl(struct sctp_flush_ctx *ctx)
 				ctx->asoc->base.sk->sk_err = -error;
 				return;
 			}
+			ctx->asoc->stats.octrlchunks++;
 			break;
 
 		case SCTP_CID_ABORT:
-- 
2.35.1

