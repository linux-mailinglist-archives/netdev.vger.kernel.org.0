Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3121463823
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 15:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243099AbhK3O6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 09:58:21 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:58722 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242880AbhK3O4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 09:56:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 717A2CE1A70;
        Tue, 30 Nov 2021 14:53:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42599C53FC7;
        Tue, 30 Nov 2021 14:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283980;
        bh=y8sSD1M0rmRs8aa71ZeIsNb3AxdnPDLqgJeWwCEXq7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q83jGDYnNRXge6TYofA5qtA+/CSZPmkWrR9Qs/niXywqPiPVWOn5ojPFqFVGylq/y
         6Mv8FQDwWx4RlGHPZD22CLIuMNOFU6l4aoPGGKldfMfMpJu9ZON9NndPhV/76oAEk2
         09VZYs9HG/Kg2d4scE0b3zzVSPfXcb2V3FvLXKxoNXLguNg4OPD3XVhACFfy7/WYmR
         HB4NsRrPNdRfjAa+I0ZTYgssSmVQ0Zem4/T2S917758CaLnu5XxT1aN1goTvWlzwLq
         NqDP4yBUhG5Zn+O5K43C7XFz+53gvLuTr9yejp36DefLVAbBiiBI8Oqmd0T5rIIRPT
         OM87ScZLGvAuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Zhijian <zhijianx.li@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, shuah@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 08/17] selftests/tc-testings: Be compatible with newer tc output
Date:   Tue, 30 Nov 2021 09:52:32 -0500
Message-Id: <20211130145243.946407-8-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145243.946407-1-sashal@kernel.org>
References: <20211130145243.946407-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Li Zhijian <zhijianx.li@intel.com>

[ Upstream commit ac2944abe4d7732f29a79f063c9cae7df2a3e3cc ]

old tc(iproute2-5.9.0) output:
 action order 1: bpf action.o:[action-ok] id 60 tag bcf7977d3b93787c jited default-action pipe
newer tc(iproute2-5.14.0) output:
 action order 1: bpf action.o:[action-ok] id 64 name tag bcf7977d3b93787c jited default-action pipe

It can fix below errors:
 # ok 260 f84a - Add cBPF action with invalid bytecode
 # not ok 261 e939 - Add eBPF action with valid object-file
 #       Could not match regex pattern. Verify command output:
 # total acts 0
 #
 #       action order 1: bpf action.o:[action-ok] id 42 name  tag bcf7977d3b93787c jited default-action pipe
 #        index 667 ref 1 bind 0

Signed-off-by: Li Zhijian <zhijianx.li@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/tc-testing/tc-tests/actions/bpf.json | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/bpf.json b/tools/testing/selftests/tc-testing/tc-tests/actions/bpf.json
index 1a9b282dd0be2..7590f883d7edf 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/bpf.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/bpf.json
@@ -66,7 +66,7 @@
         "cmdUnderTest": "$TC action add action bpf object-file $EBPFDIR/action.o section action-ok index 667",
         "expExitCode": "0",
         "verifyCmd": "$TC action get action bpf index 667",
-        "matchPattern": "action order [0-9]*: bpf action.o:\\[action-ok\\] id [0-9]* tag [0-9a-f]{16}( jited)? default-action pipe.*index 667 ref",
+        "matchPattern": "action order [0-9]*: bpf action.o:\\[action-ok\\] id [0-9].* tag [0-9a-f]{16}( jited)? default-action pipe.*index 667 ref",
         "matchCount": "1",
         "teardown": [
             "$TC action flush action bpf",
-- 
2.33.0

