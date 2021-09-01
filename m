Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51C0B3FD80E
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 12:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239848AbhIAKtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 06:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238624AbhIAKtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 06:49:11 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 162F6C0617AF;
        Wed,  1 Sep 2021 03:48:12 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id u15so1545202wmj.1;
        Wed, 01 Sep 2021 03:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+UtgQWxRuRa4KqJ5d42yoDTYxOmZXpdqTSuXxXkZPMQ=;
        b=qlgz9BQKgjp09WhettPa53X4gLlsRrtcw3deR9+1OkTkhFGMM0PU0Yw8Pe1O9PZLrI
         Y5udMnAhxxBHtkMdxcQjoCAFXGSFyQfTX+6tQd6EG5dWYN4sUMMo2+rPgNLvr0BiTRTM
         i2tiFBMiBsxNG7a9bvXA84m4M2c1uU1F5eXLPceH7P6dtt7j0BSMlWU1yLEQo3GaeS6J
         Aqb4HR6pLmMAigLI0yC34OAhSG35lCCtwLmRzoHAbb7kZkNOdKE6+kIDvzelW77IRjKz
         ICBccCl+ANNxc5PsHKSIUlFQbmUR+T0/a3Dm1LiCT8tpjrG7KRNLa+0kqkENA/dUQkgv
         s/Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+UtgQWxRuRa4KqJ5d42yoDTYxOmZXpdqTSuXxXkZPMQ=;
        b=ac/XtdBVFUxUQ0O9Q6Rm2VfzMedNVSgzlvWUMLnIVHekXYrE/8RPaiYOzn61rzHqUf
         GgRAs+ieSv/4Vcx117h1Ko8L+tSiM23yhYo/f0qD3LFnYLYZC7qU653VnshNWEQViXru
         Bv4IFyagtHN3LIcV0bqbnObzA2dlXUGQj3GM05QHzn8Co9EMTf95HL+/r1uvq8b150bd
         oY5OCJLBk1H9H/VFB/8bH+39NjYAt6xkrcS7Hm9RiLdlVBpv/SgoTfEIq+N6bBAXbFQu
         pxoDFDMP+17i3yIuKS4S5+1wllKFUokYvblCrs49onTIatjB55COuyW6RRSl/yQAwiDd
         V6AQ==
X-Gm-Message-State: AOAM532Yr9laB2itAheJTk5qIWEweiU0Ra6B6MDIrSMSsTWhGOHYbY2m
        jfdQznXFjbzw3riwEgPLFTE=
X-Google-Smtp-Source: ABdhPJwyWv/0nYwD4xPUYloVvWwNA/NOvid8Yo1zBLBorjJYy8S2dbGnMS15/PaYuHN9zG95/EDXLA==
X-Received: by 2002:a7b:c7cc:: with SMTP id z12mr8771854wmk.108.1630493290732;
        Wed, 01 Sep 2021 03:48:10 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id r12sm21530843wrv.96.2021.09.01.03.48.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Sep 2021 03:48:10 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next 08/20] selftests: xsk: add use_poll to ifobject
Date:   Wed,  1 Sep 2021 12:47:20 +0200
Message-Id: <20210901104732.10956-9-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210901104732.10956-1-magnus.karlsson@gmail.com>
References: <20210901104732.10956-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Add a use_poll option to the ifobject so that we do not need to use a
test specific if-statement in the test runner.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 5 ++++-
 tools/testing/selftests/bpf/xdpxceiver.h | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 8ef58081d4d2..9a98c45933c5 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -393,6 +393,7 @@ static void __test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
 
 		ifobj->umem = &ifobj->umem_arr[0];
 		ifobj->xsk = &ifobj->xsk_arr[0];
+		ifobj->use_poll = false;
 
 		if (i == tx)
 			ifobj->fv.vector = tx;
@@ -684,7 +685,7 @@ static void send_pkts(struct ifobject *ifobject)
 	while (pkt_cnt < ifobject->pkt_stream->nb_pkts) {
 		u32 sent;
 
-		if (test_type == TEST_TYPE_POLL) {
+		if (ifobject->use_poll) {
 			int ret;
 
 			ret = poll(fds, 1, POLL_TMOUT);
@@ -1071,6 +1072,8 @@ static void run_pkt_test(struct test_spec *test, int mode, int type)
 		testapp_validate_traffic(test);
 		break;
 	case TEST_TYPE_POLL:
+		test->ifobj_tx->use_poll = true;
+		test->ifobj_rx->use_poll = true;
 		test_spec_set_name(test, "POLL");
 		testapp_validate_traffic(test);
 		break;
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 15eab31b3b32..e02a4dd71bfb 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -135,6 +135,7 @@ struct ifobject {
 	u32 src_ip;
 	u16 src_port;
 	u16 dst_port;
+	bool use_poll;
 	u8 dst_mac[ETH_ALEN];
 	u8 src_mac[ETH_ALEN];
 };
-- 
2.29.0

