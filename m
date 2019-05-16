Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3EB204FB
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 13:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbfEPLkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 07:40:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727560AbfEPLkD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 07:40:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25B7B20833;
        Thu, 16 May 2019 11:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558006802;
        bh=R/QDBwdKgUBJQZtU6QtGTSezueRphWX7wY2JPUMjJC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gO9cr4ERg9Or9igC2llQzhdQF8XJbmDadM/iQJoeN0IBZPJ7+48ZOE4EN0K2MBKzL
         GLaa3b0DirJewJCa2KP8JcBE/UDg/Ojo5Q86nCFNdERnqLk8YOOlUmC0pPQyUAAXrc
         ktFwWQBYsUwLodmHOhS9hRKW5EfToDlHDoPFu4Og=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alban Crequy <alban@kinvolk.io>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Song Liu <songliubraving@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 22/34] tools: bpftool: fix infinite loop in map create
Date:   Thu, 16 May 2019 07:39:19 -0400
Message-Id: <20190516113932.8348-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190516113932.8348-1-sashal@kernel.org>
References: <20190516113932.8348-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alban Crequy <alban@kinvolk.io>

[ Upstream commit 8694d8c1f82cccec9380e0d3720b84eee315dfb7 ]

"bpftool map create" has an infinite loop on "while (argc)". The error
case is missing.

Symptoms: when forgetting to type the keyword 'type' in front of 'hash':
$ sudo bpftool map create /sys/fs/bpf/dir/foobar hash key 8 value 8 entries 128
(infinite loop, taking all the CPU)
^C

After the patch:
$ sudo bpftool map create /sys/fs/bpf/dir/foobar hash key 8 value 8 entries 128
Error: unknown arg hash

Fixes: 0b592b5a01be ("tools: bpftool: add map create command")
Signed-off-by: Alban Crequy <alban@kinvolk.io>
Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
Acked-by: Song Liu <songliubraving@fb.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/map.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index 1ef1ee2280a28..227766d9f43b1 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -1111,6 +1111,9 @@ static int do_create(int argc, char **argv)
 				return -1;
 			}
 			NEXT_ARG();
+		} else {
+			p_err("unknown arg %s", *argv);
+			return -1;
 		}
 	}
 
-- 
2.20.1

