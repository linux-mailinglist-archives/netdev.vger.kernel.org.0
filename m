Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0D0414316
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 09:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233604AbhIVH6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 03:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233576AbhIVH6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 03:58:32 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38E9C061756;
        Wed, 22 Sep 2021 00:57:00 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id t8so4149915wrq.4;
        Wed, 22 Sep 2021 00:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7TPYhOCF8e9ZbNJvShxEf3njID0tCx4Sal9hKxfcg5w=;
        b=WZPcqWJbgPjbr/SvJLus7OSOi6H7o+ptD7dtypW3tetjzk18WjoLMOILlgVb+trGA1
         3sjH2iCxoxfbJNGFRLD8z/1hDaDBLb4OX5M8WY+83Yrl02IbbiZYF2HXSlhu/F4rrC7M
         wc+3KiYHAnP3nCi5Fi9GWh+zpwui2gta1p4jyjiPZlQa9eH2uJLbmt/qwBemxR5Ui45y
         rlTx6h1Yhso1H/5+thEP7IPykBWvBhSr9Gl6eoizATj6XlUfAb28HiPiPpl+K522EgKL
         lrjfC3PHHkieguPrG3gzCjori5LScNu4aGCalOwo1YI+WSfKBignkYlyV5W6R32XzrNz
         Bu8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7TPYhOCF8e9ZbNJvShxEf3njID0tCx4Sal9hKxfcg5w=;
        b=Lt1ttzEkysE4xT9cDwLJLTyECaXuc2RDRXLfn1b3DTubp061sRuRI9Og47R5XIAYak
         VWG8EkeeulnVhi/Xw3Rb9k7owfUu08bkigKBXgSQaojpGOCTEaWiRq3JyonXeGSCiaGM
         qHCBF/6y9er+A3wCy8coe8Db+5adpKL2HH5phphqEoLDfc3BOTZB0mhs9NXLeIXTWq9J
         kGorFpz5yacctVuV5+TdaCNGMsf/Jyoh6fEKnGr1YH0Turc77r1iid7dzbuZvBvtoqW0
         KnNJ/E//ZOO2JjtWMdC783yIG+0Tlg3x4+Csk8eO3YX2rCDk0Ajwjz73sAeGwU2NHyZC
         TK0g==
X-Gm-Message-State: AOAM530//qOXv8lfZWgUfVpX3+sIJd55m7VYd6S+jvgcHaHTm93DbWbB
        hg2AdkTlwjrBXJAXfYEo7mY=
X-Google-Smtp-Source: ABdhPJyg6XpUonCaiocRGATWsanEjo7HghbxozdpALCXDoxv4f6yojzo+NvIvMrDxl6yAtcIcxOWqw==
X-Received: by 2002:a7b:c442:: with SMTP id l2mr9153675wmi.131.1632297414488;
        Wed, 22 Sep 2021 00:56:54 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id j7sm1673087wrr.27.2021.09.22.00.56.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Sep 2021 00:56:54 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, ciara.loftus@intel.com
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH bpf-next 09/13] selftests: xsk: fix socket creation retry
Date:   Wed, 22 Sep 2021 09:56:09 +0200
Message-Id: <20210922075613.12186-10-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210922075613.12186-1-magnus.karlsson@gmail.com>
References: <20210922075613.12186-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

The socket creation retry unnecessarily registered the umem once for
every retry. No reason to do this. It wastes memory and it might lead
to too many pages being locked at some point and the failure of a
test.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index c5c68b860ae0..aa5660dc0699 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -919,18 +919,17 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 		u64 umem_sz = ifobject->umem->num_frames * ifobject->umem->frame_size;
 		u32 ctr = 0;
 		void *bufs;
+		int ret;
 
 		bufs = mmap(NULL, umem_sz, PROT_READ | PROT_WRITE, mmap_flags, -1, 0);
 		if (bufs == MAP_FAILED)
 			exit_with_error(errno);
 
-		while (ctr++ < SOCK_RECONF_CTR) {
-			int ret;
-
-			ret = xsk_configure_umem(&ifobject->umem_arr[i], bufs, umem_sz);
-			if (ret)
-				exit_with_error(-ret);
+		ret = xsk_configure_umem(&ifobject->umem_arr[i], bufs, umem_sz);
+		if (ret)
+			exit_with_error(-ret);
 
+		while (ctr++ < SOCK_RECONF_CTR) {
 			ret = xsk_configure_socket(&ifobject->xsk_arr[i], &ifobject->umem_arr[i],
 						   ifobject, i);
 			if (!ret)
-- 
2.29.0

