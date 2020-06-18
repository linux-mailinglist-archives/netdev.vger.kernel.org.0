Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8BD1FE5D9
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 04:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387594AbgFRC3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 22:29:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728628AbgFRBQO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:16:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3145921D82;
        Thu, 18 Jun 2020 01:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442974;
        bh=daUevcPQwSz8ypE0/GRlaqeC7kN8wLzXpFUXl6xgYxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yXsyeDbfDPP2z3lrIkMJqmAOEHXmWAnHiNrd3VMV284yxd9zDKpPjNfYyZ73j277t
         j4DZ+9XxzKXeEaoUdtQGCosjuuVOYeHjzqxkSbXBypQsF9fZNfgnLXOuB2LuWF2Uq5
         O0A8BSJAoSmR+ZXTyz51SRRb2xn3aMWyqO5C/Rys=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tobias Klauser <tklauser@distanz.ch>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 377/388] tools, bpftool: Fix memory leak in codegen error cases
Date:   Wed, 17 Jun 2020 21:07:54 -0400
Message-Id: <20200618010805.600873-377-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Klauser <tklauser@distanz.ch>

[ Upstream commit d4060ac969563113101c79433f2ae005feca1c29 ]

Free the memory allocated for the template on error paths in function
codegen.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/20200610130804.21423-1-tklauser@distanz.ch
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/gen.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index f8113b3646f5..f5960b48c861 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -225,6 +225,7 @@ static int codegen(const char *template, ...)
 		} else {
 			p_err("unrecognized character at pos %td in template '%s'",
 			      src - template - 1, template);
+			free(s);
 			return -EINVAL;
 		}
 	}
@@ -235,6 +236,7 @@ static int codegen(const char *template, ...)
 			if (*src != '\t') {
 				p_err("not enough tabs at pos %td in template '%s'",
 				      src - template - 1, template);
+				free(s);
 				return -EINVAL;
 			}
 		}
-- 
2.25.1

