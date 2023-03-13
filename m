Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9230C6B7901
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 14:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbjCMNbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 09:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbjCMNbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 09:31:09 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CFB2D7D
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 06:30:24 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id k37so8020730wms.0
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 06:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678714220;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e7C99rZN5cSjegvMDvypX0kszBTwc2louT9gaVOUjkY=;
        b=34qssFIV8UfMbTJHRgeVtr+xs4HkB+DT5AnsnCdRiAT7wrPyD4qwUP91HUJtByKcw6
         wH/r8mtW9EEXduuDH90agIykiQpjWTX9REs4Ugqy+8uFhmwO2v/F2yzFfBrhQ7aPR8MG
         8smgVTuY2Dy8USMMHErbv1dMwDFB/37DugzXAik9YatI2gacHKwt6d6p1KMw6IDl4kG7
         O4AAhD2m9jnPR7XbOlTRvbEACDOdM0s3CblqqioHbx617M73wl5pDzJE1wuVJVUvyEnu
         IU3W/qS4cgL5O3a0nyNnh4Gm66MgmPzu99fiMYTmK6+X/4GSBt1KVgwoYqCan4QYEGsv
         qSBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678714220;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e7C99rZN5cSjegvMDvypX0kszBTwc2louT9gaVOUjkY=;
        b=EMCh1XDcCIWnv/IWSJN1StDnLrZBx5QGmIh2+7q2jdDMRVfH2L3fBL6Vliq6LFHfoG
         JLxFoQw+KBackWcEUyTAnzDlM6om5flMktghoHhB4FWTAJ4DWm6oHN8ExmijtijHKMmq
         YwQMVEuf+Gcew4QzwE/DGUi/7BrVcPDvJIxH9L77Wm4j9uoIkUS8CjQI6UDRNROdAzJi
         F5cGlBtMhpMv6bAK4ciz2N+nFyylNG1kHomLqzGWfytQwtZusIzp22lZ39qCLr31SfgQ
         ZHtCRkCP9V9c7rMz0ENgf3xuePh8OZYMGiwxOqkuYtFoVp5gsFeSL9zmmZF/NMP8N0T+
         ewAg==
X-Gm-Message-State: AO0yUKWu+LwiYOTwAJyLZ3ycEERzIi/gnJbrBJGhK/eRc+hCP8pG3jUF
        SGjyI0ojVhYo6Kzz6/YzPqPbsaiC7lJQHmnEJP0=
X-Google-Smtp-Source: AK7set8CJxPe66VCOMbhaKGP85L8peY4yIh/t0Hsnhb3fH9WHnuExMO6ZuWQK8Wb1QTk1FOQ1U/C0g==
X-Received: by 2002:a05:600c:4e8c:b0:3eb:4cb5:dfa with SMTP id f12-20020a05600c4e8c00b003eb4cb50dfamr9973356wmq.31.1678714220110;
        Mon, 13 Mar 2023 06:30:20 -0700 (PDT)
Received: from debil.. (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id o1-20020a05600c4fc100b003e2096da239sm10148274wmq.7.2023.03.13.06.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 06:30:19 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     syoshida@redhat.com, j.vosburgh@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com,
        syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net 2/2] selftests: rtnetlink: add a bond test trying to enslave non-eth dev
Date:   Mon, 13 Mar 2023 15:28:34 +0200
Message-Id: <20230313132834.946360-3-razor@blackwall.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230313132834.946360-1-razor@blackwall.org>
References: <20230313132834.946360-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new selftest for the recent bonding bug hit by syzbot[1] which
causes a warning and results in wrong device flags (IFF_SLAVE missing).
The test adds two bond devices and a nlmon device, enslaves one of the
bond devices to the other and then tries to enslave the nlmon device to
the enslaved bond testing the bond_enslave() error path when trying to
enslave a non-eth device. It checks that both MASTER and SLAVE flags are
properly restored.

If the flags are properly restored we get:
PASS: enslaved bond device has flags restored properly

[1] https://syzkaller.appspot.com/bug?id=391c7b1f6522182899efba27d891f1743e8eb3ef

Cc: Shigeru Yoshida <syoshida@redhat.com>
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 tools/testing/selftests/net/rtnetlink.sh | 36 ++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
index 275491be3da2..02964b2afd8d 100755
--- a/tools/testing/selftests/net/rtnetlink.sh
+++ b/tools/testing/selftests/net/rtnetlink.sh
@@ -1225,6 +1225,40 @@ kci_test_bridge_parent_id()
 	echo "PASS: bridge_parent_id"
 }
 
+kci_test_enslaved_bond_non_eth()
+{
+	local ret=0
+
+	ip link add name test-nlmon0 type nlmon
+	ip link add name test-bond0 type bond
+	ip link add name test-bond1 type bond
+	ip link set dev test-bond0 master test-bond1
+	ip link set dev test-nlmon0 master test-bond0 1>/dev/null 2>/dev/null
+
+	ip -d l sh dev test-bond0 | grep -q "SLAVE"
+	if [ $? -ne 0 ]; then
+		echo "FAIL: IFF_SLAVE flag is missing from the bond device"
+		check_err 1
+	fi
+	ip -d l sh dev test-bond0 | grep -q "MASTER"
+	if [ $? -ne 0 ]; then
+		echo "FAIL: IFF_MASTER flag is missing from the bond device"
+		check_err 1
+	fi
+
+	# on error we return before cleaning up as that may hang the system
+	if [ $ret -ne 0 ]; then
+		return 1
+	fi
+
+	# clean up any leftovers
+	ip link del dev test-bond0
+	ip link del dev test-bond1
+	ip link del dev test-nlmon0
+
+	echo "PASS: enslaved bond device has flags restored properly"
+}
+
 kci_test_rtnl()
 {
 	local ret=0
@@ -1276,6 +1310,8 @@ kci_test_rtnl()
 	check_err $?
 	kci_test_bridge_parent_id
 	check_err $?
+	kci_test_enslaved_bond_non_eth
+	check_err $?
 
 	kci_del_dummy
 	return $ret
-- 
2.39.2

