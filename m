Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9038F1F2EBA
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732117AbgFIAok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:44:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:59148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729024AbgFHXL7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:11:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C04922151B;
        Mon,  8 Jun 2020 23:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657919;
        bh=iGDstssJZNRPmYGflzsJwE0HzniypEW0XvpWSC3yA2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Htg8w5k1y/J5HtQqrgjsQ6NJoIwdPfmWHKemovmEEC4zZzrEd14CmnrsKHBpi4DZe
         /PyOxqP+EwgfDZee8AY5IE+/EFFzQzc/T/cVtaZJVWBjHSCDAxiKKqX+7tcOZNFf9w
         FhSL2drySbTiFp4CoHoyjrZQ6mF73EfZK7LuSLn8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 269/274] selftests/bpf, flow_dissector: Close TAP device FD after the test
Date:   Mon,  8 Jun 2020 19:06:02 -0400
Message-Id: <20200608230607.3361041-269-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Sitnicki <jakub@cloudflare.com>

[ Upstream commit b8215dce7dfd817ca38807f55165bf502146cd68 ]

test_flow_dissector leaves a TAP device after it's finished, potentially
interfering with other tests that will run after it. Fix it by closing the
TAP descriptor on cleanup.

Fixes: 0905beec9f52 ("selftests/bpf: run flow dissector tests in skb-less mode")
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200531082846.2117903-11-jakub@cloudflare.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/flow_dissector.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
index 92563898867c..9f3634c9971d 100644
--- a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
+++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
@@ -523,6 +523,7 @@ void test_flow_dissector(void)
 		CHECK_ATTR(err, tests[i].name, "bpf_map_delete_elem %d\n", err);
 	}
 
+	close(tap_fd);
 	bpf_prog_detach(prog_fd, BPF_FLOW_DISSECTOR);
 	bpf_object__close(obj);
 }
-- 
2.25.1

