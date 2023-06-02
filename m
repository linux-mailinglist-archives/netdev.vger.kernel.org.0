Return-Path: <netdev+bounces-7285-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4530671F877
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 04:36:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 018B52819CF
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 02:36:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F0FE15AF;
	Fri,  2 Jun 2023 02:35:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7882EED8
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 02:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01ACC4339C;
	Fri,  2 Jun 2023 02:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685673354;
	bh=GzrxYV1wFORtWJWjfX1KhonCgQpI+EAERTIYQwlPBuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rS4uhD1Ulb1iHooceqFwhp2s3n9jcKjXj50RW9UU9QAzWl0cQ2YuGGSeFqhmf3UER
	 t7QvtVj2OYc+PngNKGfXX8naBoQvpC62Gf/RoqG7rY0Rc1n+Q0j3LjMJMR523wtEpw
	 AGY0NT5/1ktEQCA4K43JLVG+r75ybgDNz5ilCV5N7QeZc/JdXTD4My9Jr4ZkSLGz/a
	 rhlwfSME9jUkZt4OQuljicrccKjNjChqe1zz8TgXPc92XvOMXYf2C5jCg1UEl/GEn4
	 AoGzMZKuAgnPb21TjITm6P2Z5QEs6gUizjwBTl5i6qafs9YXm8OD2C9y8+VO9YG8Ul
	 DIpwLu8UKfi3w==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 01/10] tools: ynl-gen: add extra headers for user space
Date: Thu,  1 Jun 2023 19:35:39 -0700
Message-Id: <20230602023548.463441-2-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230602023548.463441-1-kuba@kernel.org>
References: <20230602023548.463441-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make sure all relevant headers are included, we allocate memory,
use memcpy() and Linux types without including the headers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index be664510f484..5823ddf912f6 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -2103,6 +2103,13 @@ _C_KW = {
             cw.nl()
         headers = ['uapi/' + parsed.uapi_header]
     else:
+        cw.p('#include <stdlib.h>')
+        if args.header:
+            cw.p('#include <string.h>')
+            cw.p('#include <linux/types.h>')
+        else:
+            cw.p(f'#include "{parsed.name}-user.h"')
+            cw.p('#include "ynl.h"')
         headers = [parsed.uapi_header]
     for definition in parsed['definitions']:
         if 'header' in definition:
-- 
2.40.1


