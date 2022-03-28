Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D989E4E965E
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 14:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242383AbiC1MTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 08:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240611AbiC1MTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 08:19:30 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039124CD58;
        Mon, 28 Mar 2022 05:17:50 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id bc27so12113226pgb.4;
        Mon, 28 Mar 2022 05:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=oUSFct37zkSbySokydCM2OT/2wssM+Jk2IoqjA4FsqU=;
        b=ppbYEBCS7tDVUg27I4Xi6BgnH8UFjOESa4W9JBQQ2XvDdj9pGfiZ73gPNieBbI7F3l
         mbJsZQJwYotihRUX0NCxsD5sRNqL0CVPxA0caz+JpQ8H7npWc6kO2xaL2qVKDlXql/kU
         0mcasAyhO/OgRbs3xb9VX70/1KtRchT9SiuBOVHE4Dv9AF3pFDWCfWNhla98HZmIk+Oa
         vya2YOhJ1yU6ygZIg8irEmMQ9oGUPX9KmdQcBlFc8vlXK71orOlwOAgabiAWDJKDVl18
         JDhR6YH9gspPvLVOPJXj2EW2XGFgZIasbInqDxMIqZR0hZ6phFre5WoEUzKxGNazRA0q
         MktQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=oUSFct37zkSbySokydCM2OT/2wssM+Jk2IoqjA4FsqU=;
        b=D5cxLbtWnfK57Py7I638m3fKQMKOrPYLcupAyXxq2u+uaub4nRvq2WrnYULSvHRys8
         4Ds98c1U86a5h0xliKigdJ2AoKrAMo822zcANS16TFHThasJ/n5q/PqLscYUEkgsX1Gg
         JiVCJ+PkdOP588Ekr3q5pRKfroG2rB1z0GTn9jnGpDMHLLk+O/fb6IqH3it2t3NO/YxU
         Y8XwiWug8vp0lBZ+Ne4YOEHZmnASJbJa4FmcZpqycZt3CbvurVc0GCfHWuklhigOjWXd
         HITNgSJByOy2Mkrnasot8gNTadCaitmSgnZLNxjJXe5ZE6hbDAw6yP4PkjjSTsFVNmbq
         0FwA==
X-Gm-Message-State: AOAM530up8uWD6T+QGW1l23/AgiagffoP1+kvgWkNDh3iWHniYDgXpfL
        FWRBWcMVisCbUs24lzsGshs=
X-Google-Smtp-Source: ABdhPJzu+JiVMVMSLQgW0JxkEsT3FWdFn8zoTgJ4+22NW5GX3GXhWckTX0KDYTRbkjXYx82J78BI+A==
X-Received: by 2002:a05:6a00:b51:b0:4fa:ece9:15e4 with SMTP id p17-20020a056a000b5100b004faece915e4mr21831961pfo.27.1648469869494;
        Mon, 28 Mar 2022 05:17:49 -0700 (PDT)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id y12-20020a17090a784c00b001c6bdafc995sm17721701pjl.3.2022.03.28.05.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 05:17:49 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v2] carl9170: tx: fix an incorrect use of list iterator
Date:   Mon, 28 Mar 2022 20:17:39 +0800
Message-Id: <20220328121739.654-1-xiam0nd.tong@gmail.com>
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

