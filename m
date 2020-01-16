Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C86313F41C
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391289AbgAPSr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:47:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:49080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390038AbgAPRKg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:10:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEB9B24684;
        Thu, 16 Jan 2020 17:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194635;
        bh=2B3bXT8CnI5hWe6k7KaJCeDE79boiM4jCqVDhJWvomA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=02vIvWHcevE37jvquAF9jqTq4UGdCWfDv5/X7DrGqMaeZXqIS59ABEpqJtF3/vrzY
         TWRdfiVI82vhVsNyhOHcH60W+VYNHYhTtp0BwIY6ZntypcqMxEJlJJij21h3WSiJ7P
         X+EgRNPRzDZEL5oSmwrrlR6eTckf/6z/mJ6xT05E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quentin Monnet <quentin.monnet@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 494/671] tools: bpftool: fix arguments for p_err() in do_event_pipe()
Date:   Thu, 16 Jan 2020 12:02:12 -0500
Message-Id: <20200116170509.12787-231-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Quentin Monnet <quentin.monnet@netronome.com>

[ Upstream commit 9def249dc8409ffc1f5a1d7195f1c462f2b49c07 ]

The last argument passed to some calls to the p_err() functions is not
correct, it should be "*argv" instead of "**argv". This may lead to a
segmentation fault error if CPU IDs or indices from the command line
cannot be parsed correctly. Let's fix this.

Fixes: f412eed9dfde ("tools: bpftool: add simple perf event output reader")
Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/map_perf_ring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/map_perf_ring.c b/tools/bpf/bpftool/map_perf_ring.c
index 6d41323be291..8ec0148d7426 100644
--- a/tools/bpf/bpftool/map_perf_ring.c
+++ b/tools/bpf/bpftool/map_perf_ring.c
@@ -205,7 +205,7 @@ int do_event_pipe(int argc, char **argv)
 			NEXT_ARG();
 			cpu = strtoul(*argv, &endptr, 0);
 			if (*endptr) {
-				p_err("can't parse %s as CPU ID", **argv);
+				p_err("can't parse %s as CPU ID", *argv);
 				goto err_close_map;
 			}
 
@@ -216,7 +216,7 @@ int do_event_pipe(int argc, char **argv)
 			NEXT_ARG();
 			index = strtoul(*argv, &endptr, 0);
 			if (*endptr) {
-				p_err("can't parse %s as index", **argv);
+				p_err("can't parse %s as index", *argv);
 				goto err_close_map;
 			}
 
-- 
2.20.1

