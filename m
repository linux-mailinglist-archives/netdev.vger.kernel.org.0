Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55D99A8A0A
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731826AbfIDP6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 11:58:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731774AbfIDP6N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 11:58:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 454C723401;
        Wed,  4 Sep 2019 15:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612692;
        bh=1mpdEmxlulUxMm5dMbUBfyxVH2N8bAtQhPgQoAI14Lk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zX1dHb6bNxMJCpAEth9ULEbpuaGzsz6HsdtL/4+tbvG8/qK/NBwKUfoYktRnZopF4
         ghwDbU5K2P9xngGuj9yzZhUM4iYOOtU3JFOsCi7PwL65BwAEK/ojz5ApEoWwmKOEM3
         hop2H++4kZGLr2ISPUL5Zk889pxnLP/ppi6fU4+A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quentin Monnet <quentin.monnet@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 20/94] tools: bpftool: close prog FD before exit on showing a single program
Date:   Wed,  4 Sep 2019 11:56:25 -0400
Message-Id: <20190904155739.2816-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Quentin Monnet <quentin.monnet@netronome.com>

[ Upstream commit d34b044038bfb0e19caa8b019910efc465f41d5f ]

When showing metadata about a single program by invoking
"bpftool prog show PROG", the file descriptor referring to the program
is not closed before returning from the function. Let's close it.

Fixes: 71bb428fe2c1 ("tools: bpf: add bpftool")
Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/prog.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 7a4e21a315236..d41651afe5f64 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -362,7 +362,9 @@ static int do_show(int argc, char **argv)
 		if (fd < 0)
 			return -1;
 
-		return show_prog(fd);
+		err = show_prog(fd);
+		close(fd);
+		return err;
 	}
 
 	if (argc)
-- 
2.20.1

