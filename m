Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC69B6893C1
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 10:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbjBCJbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 04:31:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjBCJbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 04:31:10 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F93A212BC
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 01:31:01 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-50660dd3263so45560127b3.19
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 01:31:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=sRTbWykUitHgvhIuijlROFHq2rLMmEeBT0jym/fZRho=;
        b=ZxWqHCLVjngGEk4ipClqZnRBMhXs5pSp6EiXtCoAYhRe2gcqC2BVj53CiBoI039z8x
         eU7DUl5OyCx6/wcW7k0VZA8iV3j3OcEBzrHOhIZQyXiRuqib7fGkhKrCjUzCHFoMOs16
         +yWvyt+MXChCX+qNjXpNBuJy6m0hOQmvvEVb0zBnDwD2OlV3lTM7aI8lCJS/KeURGuSr
         M3z0oA81BT5p2MGj4XGc2hnjal4j0I4xLfdDM6ybou9L2AOCN7pUZMnKlLIYDnkCN1To
         BtHJojOUK7tZw9t2g3IgkHUZUgvdWQ/pAPsTcm6q1BwooCkviCjPqE/Ge89CRtch43zU
         TWWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sRTbWykUitHgvhIuijlROFHq2rLMmEeBT0jym/fZRho=;
        b=7B8VhyTP6qTnPjblccQpCq16UjtlSUqW+YcjD9U9IgkKBw/vHelHSVLrNB+9Y/UmyA
         KafFzH0uPg9qXpOdqBCpOKeicgSqls9yotgk8ya+n0yzHoA005E+aIcLwhuIiKDdjNIU
         6h0Y4OX8NdpPbcHlWLuA+YUj5BDOlf2d4XhQe0psmpsN2MQLiQG8kvpK4cufqSZu4p7z
         9G7uxkAKf1HkAZSNPC1/jSYVAS2iH7ScL4R6PfbWTh1JoH9eaRvBdZX1nTDQSdh1jRoP
         Dm0VJu20QJEs+ACYr9X80j4dRFNOurmq1uNo6QDIBmb0kt/h7A0WRuuozo31aheC1p7K
         nSWw==
X-Gm-Message-State: AO0yUKUr5/c/7WfHKXJ9SZXCXgjC+sw2jYy/W/KM7XYxqQvjUPHU2ohU
        fCJw+18lgboDLEG8RxizPIrHlPfmE6/G
X-Google-Smtp-Source: AK7set93uK0vjiKvgKPCxErhx5wSC107Pw7JjXaebDJDuLrkzVIe9hoW7AcJu1HsNKq+FLpnrjagECO5pnxG
X-Received: from apusaka-p920.tpe.corp.google.com ([2401:fa00:1:17:dc12:2976:77a:8cb7])
 (user=apusaka job=sendgmr) by 2002:a25:d215:0:b0:863:a092:156d with SMTP id
 j21-20020a25d215000000b00863a092156dmr249062ybg.23.1675416660756; Fri, 03 Feb
 2023 01:31:00 -0800 (PST)
Date:   Fri,  3 Feb 2023 17:30:55 +0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230203173024.1.Ieb6662276f3bd3d79e9134ab04523d584c300c45@changeid>
Subject: [PATCH] Bluetooth: Free potentially unfreed SCO connection
From:   Archie Pusaka <apusaka@google.com>
To:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Ying Hsu <yinghsu@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Archie Pusaka <apusaka@chromium.org>

It is possible to initiate a SCO connection while deleting the
corresponding ACL connection, e.g. in below scenario:

(1) < hci setup sync connect command
(2) > hci disconn complete event (for the acl connection)
(3) > hci command complete event (for(1), failure)

When it happens, hci_cs_setup_sync_conn won't be able to obtain the
reference to the SCO connection, so it will be stuck and potentially
hinder subsequent connections to the same device.

This patch prevents that by also deleting the SCO connection if it is
still not established when the corresponding ACL connection is deleted.

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Ying Hsu <yinghsu@chromium.org>

---

 net/bluetooth/hci_conn.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 61a34801e61e..838f51c272a6 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1061,8 +1061,15 @@ int hci_conn_del(struct hci_conn *conn)
 
 	if (conn->type == ACL_LINK) {
 		struct hci_conn *sco = conn->link;
-		if (sco)
+		if (sco) {
 			sco->link = NULL;
+			/* Due to race, SCO connection might be not established
+			 * yet at this point. Delete it now, otherwise it is
+			 * possible for it to be stuck and can't be deleted.
+			 */
+			if (sco->handle == HCI_CONN_HANDLE_UNSET)
+				hci_conn_del(sco);
+		}
 
 		/* Unacked frames */
 		hdev->acl_cnt += conn->sent;
-- 
2.39.1.519.gcb327c4b5f-goog

