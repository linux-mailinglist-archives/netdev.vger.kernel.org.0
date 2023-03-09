Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9ACA6B1CE2
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 08:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbjCIHtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 02:49:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbjCIHtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 02:49:17 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C475E1924;
        Wed,  8 Mar 2023 23:47:11 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id n5so910135pfv.11;
        Wed, 08 Mar 2023 23:47:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678348025;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hH6w8aDTHHGmr5ss4kp7zLJEI+UrSruaARLEvYxT/Ns=;
        b=Jfga99as4sUZR/5nJLi8Hpi0rii77ylY8BNny0flNexzyRRyO4UnXfrNEVZApU5Idd
         B+Fxqu4doFJ0O5wOQJ0XLh6GarSAG58Zwd+psBzECkBN9Goz9KAR0wk/+rkCrp7dhjiB
         A7joRRdhqlGx8Ovxz3Vfcp/rc0o+jOW+z4Nt9K/7EM3A5O3vKXJNttCoIZg8FFcK7pZF
         6W0kOnEsrfmR9RcFkVzBB9ML71NAQIA0WLl5czheQ4ntu8k/akv+rto6GAG7muX9EYiz
         Zmvq3yUOPmtUGMmh5IiGOhYcTSXrzkDW8FIiI97bU49OQk56Y/AEavbKVLOCefx87r2e
         JuiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678348025;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hH6w8aDTHHGmr5ss4kp7zLJEI+UrSruaARLEvYxT/Ns=;
        b=8DXC7g5SwuvxA65oUukS1fvU/gg9xEgMUgdQw2ozZTWDmIJtJJGBN+RqjPZAinJ+tc
         HDWplQuniOio42CK60yHY6Nj2+ZhRvSs73mhi3KNcu0G67ExGz/+nQ0JPlFcoDXZjCY0
         NakqZb8WLHvxKHWsVlMdtvzB6VXu4qhNhgNXwXahj/ye9b3+wywYF7p/Y2PCG3jbuBrb
         s28to0bE+N1Gve6JiZUvaDTaORGnSGhse4rC8CBlGvhdW0H6k31AumY9v657BPCHyB8O
         VrXwVLci8DPb5YoZhalcFKjZZOKNN0rLcPWJOho6lRZxgEq5PDtW9x6j6pVt9PDnkCLB
         xXXg==
X-Gm-Message-State: AO0yUKWiNI9w6NXiR0FUQUyxg4VsXg5p2lmpTPwdEhYoKpkMOHzMAyXg
        Awgi5YVPDSJKX4OjVV/kdBU=
X-Google-Smtp-Source: AK7set/JBnA6LgCAcvKXuufNL0rSbzmQOkVhyz5GG+65MEN9oD7bnQ18Tcfq4FFWFJGIydTzhwolRg==
X-Received: by 2002:a62:3142:0:b0:5dc:e543:c62d with SMTP id x63-20020a623142000000b005dce543c62dmr15211058pfx.23.1678348025584;
        Wed, 08 Mar 2023 23:47:05 -0800 (PST)
Received: from ideal-drum-1.localdomain (23.105.204.76.16clouds.com. [23.105.204.76])
        by smtp.gmail.com with ESMTPSA id c5-20020a62e805000000b005a7f8a326a3sm10537800pfi.50.2023.03.08.23.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 23:47:05 -0800 (PST)
From:   ZhengHan Wang <wzhmmmmm@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ZhengHan Wang <wzhmmmmm@gmail.com>
Subject: [PATCH] Bluetooth: Fix double free in hci_conn_cleanup
Date:   Thu,  9 Mar 2023 15:46:45 +0800
Message-Id: <20230309074645.74309-1-wzhmmmmm@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reports a slab use-after-free in hci_conn_hash_flush [1].
After releasing an object using hci_conn_del_sysfs in the 
hci_conn_cleanup function, releasing the same object again 
using the hci_dev_put and hci_conn_put functions causes a double free.
Here's a simplified flow:

hci_conn_del_sysfs:
  hci_dev_put
    put_device
      kobject_put
        kref_put
          kobject_release
            kobject_cleanup
              kfree_const
                kfree(name)

hci_dev_put:
  ...
    kfree(name)

hci_conn_put:
  put_device
    ...
      kfree(name)

This patch drop the hci_dev_put and hci_conn_put function 
call in hci_conn_cleanup function, because the object is 
freed in hci_conn_del_sysfs function.

Link: https://syzkaller.appspot.com/bug?id=1bb51491ca5df96a5f724899d1dbb87afda61419 [1]

Signed-off-by: ZhengHan Wang <wzhmmmmm@gmail.com>
---
 net/bluetooth/hci_conn.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index acf563fbdfd9..a0ccbef34bc2 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -152,10 +152,6 @@ static void hci_conn_cleanup(struct hci_conn *conn)
 	hci_conn_del_sysfs(conn);
 
 	debugfs_remove_recursive(conn->debugfs);
-
-	hci_dev_put(hdev);
-
-	hci_conn_put(conn);
 }
 
 static void le_scan_cleanup(struct work_struct *work)
-- 
2.25.1

