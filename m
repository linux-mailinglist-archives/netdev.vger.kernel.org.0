Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 115C84E9692
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 14:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242472AbiC1MaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 08:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235479AbiC1MaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 08:30:11 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE7BBC24;
        Mon, 28 Mar 2022 05:28:30 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id y6so12108087plg.2;
        Mon, 28 Mar 2022 05:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=aN5/hKK6I1K6W9z7M8xOelNKPU03XYlOEFKuLiH80Tc=;
        b=CJeVYurf1hwoW3weRdc17ajFoOMKjRxQzEVCrRLYJPBM/ml56HKeitZICvK7bTTujJ
         l1E28no6b/Tnr6F6H/uHPgJQo5EU3PVyoJEtbxqYhMb/JNyn/uhaPGQDO/GlZZdh1dYu
         OAUIFLAIR6AgD+FizlMUc/+qmeFH83O9L5LcjhegUdDkXXri70RauZ2dYFK47ve4vAsI
         68AfC+PxYnF1D1XgprvyJ8RJO7+L14z/MOScidjJdwNStAuWBKMu/L9PFHpMywEU14V1
         kqfShh7MnSkFmnNFYMVH7m/HCBfc+cxzrpHVcWd+LneD68NhnSa1feZCN6P5hKx0BAAr
         QE9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aN5/hKK6I1K6W9z7M8xOelNKPU03XYlOEFKuLiH80Tc=;
        b=FFDE3z5wisHSiDVMklNIl/bM/UpN8gHkFWU/wskcvIE5AA3CfpeZvvxGj9/gf4Lo+B
         5qY/MI3IIis4COBXSWcuUchqo6I9uwFh37ZlL33ezY0IPPFx8YUCjizJrsvK7uy7zQwv
         wdJJes8EbIFBbjJ1fojCB4IoPrgy6npz5A08bYcVlboWXAkP2AfU+1YWZXGa2IZSnbYX
         z3qJp4dFjUPR2PNdeYIASj/ZzS/ZFrdFNWzCNuzZ3ivJYxIhc6r9M4ZfcfJqUItuEqpT
         JGriV0WPYqjQJwML072o/AoywZ4H0p3GbBa11cRbtf70zDik4uOvIEPbxTVSurbCffNu
         snpw==
X-Gm-Message-State: AOAM533zJZySHHV1MMaDfu78NrDqz18bcD4CwfWc4KNuNVPnpl/s2CVT
        JJiL6/MBLfcfpkxImgSJrgA=
X-Google-Smtp-Source: ABdhPJxOljhQBzZmvpdhVjQt9DSij++CMKx645kMD7vT8Hv3Wm7k4kUdXflESuU3PvSfTpUMXYKMqw==
X-Received: by 2002:a17:90a:840a:b0:1c9:5c4f:5e83 with SMTP id j10-20020a17090a840a00b001c95c4f5e83mr16907129pjn.144.1648470510126;
        Mon, 28 Mar 2022 05:28:30 -0700 (PDT)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id d5-20020a056a0010c500b004faee9887ccsm15194942pfu.64.2022.03.28.05.28.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 05:28:29 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v2] carl9170: tx: fix an incorrect use of list iterator
Date:   Mon, 28 Mar 2022 20:28:20 +0800
Message-Id: <20220328122820.1004-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the previous list_for_each_entry_continue_rcu() don't exit early
(no goto hit inside the loop), the iterator 'cvif' after the loop
will be a bogus pointer to an invalid structure object containing
the HEAD (&ar->vif_list). As a result, the use of 'cvif' after that
will lead to a invalid memory access (i.e., 'cvif->id': the invalid
pointer dereference when return back to/after the callsite in the
carl9170_update_beacon()).

The original intention should have been to return the valid 'cvif'
when found in list, NULL otherwise. So just return NULL when no
entry found, to fix this bug.

Cc: stable@vger.kernel.org
Fixes: 1f1d9654e183c ("carl9170: refactor carl9170_update_beacon")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---

changes since v1:
 - just return NULL when no entry found (Christian Lamparter)

v1:https://lore.kernel.org/lkml/20220327072947.10744-1-xiam0nd.tong@gmail.com/

---
 drivers/net/wireless/ath/carl9170/tx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index 1b76f4434c06..791f9f120af3 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -1558,6 +1558,9 @@ static struct carl9170_vif_info *carl9170_pick_beaconing_vif(struct ar9170 *ar)
 					goto out;
 			}
 		} while (ar->beacon_enabled && i--);
+
+		/* no entry found in list */
+		return NULL;
 	}
 
 out:
-- 
2.17.1

