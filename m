Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7E654A1AD
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 23:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234886AbiFMVnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 17:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352282AbiFMVnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 17:43:35 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C541D63A0
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 14:43:33 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id hf12-20020a17090aff8c00b001e2c0a2584cso2001pjb.1
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 14:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+dbqcGyic4c3zYFWxW8WIDheVsDHS+XGvESBEzG7d5k=;
        b=RfOQUrYJ7JQYov7qHkHG0D3CZvnSFd0EoNZxA2h9so3t5ghC6pS+NNf1FUtITajexh
         7gUCIGccN3LwOTdXDbBwTD7+XrbjD2eCTvMc+5aogoJg1NLhjoh/3JkVtiEXluDPD8/L
         62qDQT3rOniALV5GkhgmyKlJ0ekgyrY+4qVRR8hFt1yxoFe8SFc7VrHnqhP4/alrQ73A
         c9U55RUCY452wxUYwC2/CIcZF5HS7c00CsCKbWjA9q8EMErbMw8OpDaDmyFENmglX0pi
         VcnxlZOluUestMBBMo1Fj+JfcG64pqGogk3OFtPZrn7i+1602wbbcfm481/yPdWJKvJk
         6tbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+dbqcGyic4c3zYFWxW8WIDheVsDHS+XGvESBEzG7d5k=;
        b=HaQoTU267flE+oknx4J+pImw4YpsgeoJxJTSf+re9c1UgQTt47PjL4fk3ZwWjaxgLm
         FLiULnEROIDIbyzoednu6i7lMUUmt+WPfScAy2BXohO7nAkLdTrnJftuIhHTG7K/H3WV
         lnNL1g6Qi7+aG01SUDSInyCje2SH38zeVud9XOwRqU8E2D1f0tpQ8ahPZ5nNUBwIaHoy
         1yVOBXFT6jlciG6OwJ53w/LnUICN3J5wMOxp8VdmRxs8RTLuK/w4h+DHfwB6SkUprjtL
         f+u2hwN49BulSJ9yi74ASBBxjtmfR4znoIZ+70/LpvusIGMYgLy5/6sQQhKQDKkMLSo/
         q34A==
X-Gm-Message-State: AOAM5316ZsAflFjhjeQXDOyVWIqKViFQpgVs1TnXoRXJk99Wj7pXXTLF
        qBb0C0mflhmG1JZWsZRuwjVmcwNn/TYg
X-Google-Smtp-Source: ABdhPJw9jT9qWcmLHduAjFOWxEbRFk+OM7kyD/MBa5/84G/LeQ3nXO0nTD06s+nhmadhnxgd80/26tvZV5NP
X-Received: from jiangzp-glinux-dev.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:4c52])
 (user=jiangzp job=sendgmr) by 2002:a05:6a00:b51:b0:51c:1219:569d with SMTP id
 p17-20020a056a000b5100b0051c1219569dmr1278341pfo.2.1655156613295; Mon, 13 Jun
 2022 14:43:33 -0700 (PDT)
Date:   Mon, 13 Jun 2022 14:43:27 -0700
In-Reply-To: <20220613214327.15866-1-jiangzp@google.com>
Message-Id: <20220613144322.kernel.v1.1.Ia621daca5b03278ee09314c59659b64c901408cf@changeid>
Mime-Version: 1.0
References: <20220613214327.15866-1-jiangzp@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [kernel PATCH v1 1/1] Bluetooth: mgmt: Fix refresh cached connection info
From:   Zhengping Jiang <jiangzp@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Zhengping Jiang <jiangzp@google.com>,
        Brian Gix <brian.gix@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set the connection data before calling get_conn_info_sync, so it can be
verified the connection is still connected, before refreshing cached
values.

Fixes: 47db6b42991e6 ("Bluetooth: hci_sync: Convert MGMT_OP_GET_CONN_INFO")
Signed-off-by: Zhengping Jiang <jiangzp@google.com>
---

Changes in v1:
- Set connection data before calling hci_cmd_sync_queue

 net/bluetooth/mgmt.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 74937a8346488..cfbea6fa04335 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -6828,11 +6828,14 @@ static int get_conn_info(struct sock *sk, struct hci_dev *hdev, void *data,
 
 		cmd = mgmt_pending_new(sk, MGMT_OP_GET_CONN_INFO, hdev, data,
 				       len);
-		if (!cmd)
+		if (!cmd) {
 			err = -ENOMEM;
-		else
+		} else {
+			hci_conn_hold(conn);
+			cmd->user_data = hci_conn_get(conn);
 			err = hci_cmd_sync_queue(hdev, get_conn_info_sync,
 						 cmd, get_conn_info_complete);
+		}
 
 		if (err < 0) {
 			mgmt_cmd_complete(sk, hdev->id, MGMT_OP_GET_CONN_INFO,
@@ -6844,9 +6847,6 @@ static int get_conn_info(struct sock *sk, struct hci_dev *hdev, void *data,
 			goto unlock;
 		}
 
-		hci_conn_hold(conn);
-		cmd->user_data = hci_conn_get(conn);
-
 		conn->conn_info_timestamp = jiffies;
 	} else {
 		/* Cache is valid, just reply with values cached in hci_conn */
-- 
2.36.1.476.g0c4daa206d-goog

