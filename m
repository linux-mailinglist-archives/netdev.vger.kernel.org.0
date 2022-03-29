Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 334B64EB695
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 01:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239854AbiC2XQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 19:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbiC2XQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 19:16:43 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A6CB71;
        Tue, 29 Mar 2022 16:14:59 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id w8so18971422pll.10;
        Tue, 29 Mar 2022 16:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GVyk3VeB+5cu02fn2mqPCn1EetZXu1aDKXOdGuWh/Ds=;
        b=McZcb7XmFsqQa/36lU8fFgx8zDKaMXEP9iqDrkYQiLEIs2Nms1+cipVVMp9Au0qSbO
         Px2cgZmTpQzQCmxn6lSV3XCJfb/VSWlGZ2DMsgwF6rU1xyVX5HkfCJzVVGcQFkimGMkJ
         9YZzmeu8ZGDrL1q7Z0eJRgYJo8T5NA+lqqH7/d23YfodZHL7/WW37fSpwrxNM27E/w81
         ENhPZhyjzg/45Yhhh9OIf9KId2qP8kIPKK2PWHGs5T/sNGKLM6baFdE1SRsXIQxpS2D7
         NxsM7mB5xRJY2Z9+beRrmqzmRvoFQk7p23MGcE+/ZmCD5RThlYwQlIyk3Z4yY9+9/9uV
         WByA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GVyk3VeB+5cu02fn2mqPCn1EetZXu1aDKXOdGuWh/Ds=;
        b=EtqNS2AwbF09cBqrMNxBBky/gSeDgFS5vTTrj/ac9Dwh9X6jDcsh6jDyAjTVRwvQRj
         DL/ibr+b3iw4Ka38AQr2rMKelaq5eQp20eseqtwP+EDOXY+T6CB7/bgVb1blbSkbgx1i
         6FjDRWE58gfDDDW1qsYrau+uwUT3ounYDGgaYSLOEjeShJAkdbqTAZCniNWkf7m32fuh
         d8s03P2O+cn5F18fhuSFy36qkvJMy/Esu2j2noCC3f62BBz+FVTAgOqUFQG5VVjvDp2Z
         ozQ6kIuEOzaudaQr0Mb0gO81nT2q7YiTJ7qeGz5SsyKOUJr0argPAHpiJMuTOXFEWLrs
         fWXQ==
X-Gm-Message-State: AOAM533TitaMv66ACpA0VErkffQMImhjPmyNuOVsAIEk3BNn0W1Qg+Jc
        tyEuK+eAnOsOKCiThjpd3mU=
X-Google-Smtp-Source: ABdhPJwmtKuwYq2XJxrZVYHeNhf7EWn2H2TFkD0FothD52FPa3avc11q27bQUw4qun3Uz8pU9AW5cg==
X-Received: by 2002:a17:90a:de98:b0:1c7:1bed:67f7 with SMTP id n24-20020a17090ade9800b001c71bed67f7mr1572000pjv.199.1648595698633;
        Tue, 29 Mar 2022 16:14:58 -0700 (PDT)
Received: from localhost.localdomain ([180.150.111.33])
        by smtp.gmail.com with ESMTPSA id j14-20020a056a00174e00b004f66ce6367bsm23336390pfc.147.2022.03.29.16.14.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 16:14:57 -0700 (PDT)
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
Subject: [PATCH v2 net] sctp: count singleton chunks in assoc user stats
Date:   Wed, 30 Mar 2022 09:13:42 +1000
Message-Id: <c2abe2f2ba779cbb453e65a7ddae1654baa17623.1648595611.git.jamie.bainbridge@gmail.com>
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

Singleton chunks (INIT, HEARTBEAT PMTU probes, and SHUTDOWN-
COMPLETE) are not counted in SCTP_GET_ASOC_STATS "sas_octrlchunks"
counter available to the assoc owner.

These are all control chunks so they should be counted as such.

Add counting of singleton chunks so they are properly accounted for.

Fixes: 196d67593439 ("sctp: Add support to per-association
statistics via a new SCTP_GET_ASSOC_STATS call")

Signed-off-by: Jamie Bainbridge <jamie.bainbridge@gmail.com>
---
 net/sctp/outqueue.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index a18609f608fb786b2532a4febbd72a9737ab906c..bed34918b41f24810677adc0cd4fbd0859396a02 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -914,6 +914,7 @@ static void sctp_outq_flush_ctrl(struct sctp_flush_ctx *ctx)
 				ctx->asoc->base.sk->sk_err = -error;
 				return;
 			}
+			ctx->asoc->stats.octrlchunks++;
 			break;
 
 		case SCTP_CID_ABORT:
@@ -939,6 +940,7 @@ static void sctp_outq_flush_ctrl(struct sctp_flush_ctx *ctx)
 		case SCTP_CID_HEARTBEAT:
 			if (chunk->pmtu_probe) {
 				sctp_packet_singleton(ctx->transport, chunk, ctx->gfp);
+				ctx->asoc->stats.octrlchunks++;
 				break;
 			}
 			fallthrough;
-- 
2.35.1

