Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB8D413F518
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436637AbgAPSyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:54:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:41004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389264AbgAPRIC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:08:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8071B205F4;
        Thu, 16 Jan 2020 17:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194481;
        bh=y/nZ42/FMMXceNUw7WAIY9pg7MUgfngQZU/ejKKMVf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lxkRJdz/Jg0ZVpe+LoRAy28Ehf5LtnGp+nCQ2F3hsLJeeeIH+HEY5Y0zzIG+GhiIM
         HahhqQt/ycuNTwkS31ps1paXfX5sfkAOcsEe+g032PgfZimBx6DpfN/P8iVEQjpv9e
         BFhYnGhGyRk/M91POHi9lkPbc8jw7RakF6FLAORg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 383/671] signal/bpfilter: Fix bpfilter_kernl to use send_sig not force_sig
Date:   Thu, 16 Jan 2020 12:00:21 -0500
Message-Id: <20200116170509.12787-120-sashal@kernel.org>
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

From: "Eric W. Biederman" <ebiederm@xmission.com>

[ Upstream commit 1dfd1711de2952fd1bfeea7152bd1687a4eea771 ]

The locking in force_sig_info is not prepared to deal with
a task that exits or execs (as sighand may change).  As force_sig
is only built to handle synchronous exceptions.

Further the function force_sig_info changes the signal state if the
signal is ignored, or blocked or if SIGNAL_UNKILLABLE will prevent the
delivery of the signal.  The signal SIGKILL can not be ignored and can
not be blocked and SIGNAL_UNKILLABLE won't prevent it from being
delivered.

So using force_sig rather than send_sig for SIGKILL is pointless.

Because it won't impact the sending of the signal and and because
using force_sig is wrong, replace force_sig with send_sig.

Cc: Alexei Starovoitov <ast@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Fixes: d2ba09c17a06 ("net: add skeleton of bpfilter kernel module")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bpfilter/bpfilter_kern.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bpfilter/bpfilter_kern.c b/net/bpfilter/bpfilter_kern.c
index 94e88f510c5b..450b257afa84 100644
--- a/net/bpfilter/bpfilter_kern.c
+++ b/net/bpfilter/bpfilter_kern.c
@@ -25,7 +25,7 @@ static void shutdown_umh(struct umh_info *info)
 		return;
 	tsk = get_pid_task(find_vpid(info->pid), PIDTYPE_PID);
 	if (tsk) {
-		force_sig(SIGKILL, tsk);
+		send_sig(SIGKILL, tsk, 1);
 		put_task_struct(tsk);
 	}
 	fput(info->pipe_to_umh);
-- 
2.20.1

