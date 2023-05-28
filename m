Return-Path: <netdev+bounces-5963-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B3C67713B47
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 19:37:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67F851C209B2
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 17:37:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37CB0568B;
	Sun, 28 May 2023 17:36:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B93D611C
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 17:36:15 +0000 (UTC)
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5BCE4
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 10:36:07 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f6094cb2ebso16560515e9.3
        for <netdev@vger.kernel.org>; Sun, 28 May 2023 10:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1685295365; x=1687887365;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yejeJuBSt+D3FgC1LjNPeG+dJYpbJqtooI8scLwtIN4=;
        b=eD/qEuL79GN8tB8avqp9pE04vjjOZUEvY4jSmQjkSHthOSvGpYn8pcsr37VZTuZ9i9
         etUOwsVyTj8fQ/ysbGKL6ULlXG3l+FOJe9wEwvLm+x+XNtX03lzMKGvAdOqO3Ed1B6Te
         b5IexFVNcMHNCbYhcpzttk9QpSfpWW4aL5515RKB7Cp+lZQ21yT3qClFgET2n9I6mgg+
         gFBu4jCxmIhmiJNDS+DChU0EgZz1yMx3tqRWTizJCP4K9Jm9UW+OkhT0zFssIKIXi1es
         5Hii5YLhoNYZ2xUJKvZ9Fb24ZRUF68oFVbWAykcGONPU+riDpR01KTHCwMTFA0ZyFdyx
         ZEmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685295365; x=1687887365;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yejeJuBSt+D3FgC1LjNPeG+dJYpbJqtooI8scLwtIN4=;
        b=V3WSJpYrLp40I2L09/O9o/aM9IHyXMcWzjV/oEMYak73lY16jUPeTK94WHJ1nmdgZn
         51GFTQhGRLIUBxNdkGw0zmhq8eqLVETaF/o6rcxVNaNfvuRfngSxeocqLhfHORtXlo8m
         77dkT8nh1V3sf75mye/OInTUK2Fc7e6wucGHnL5POd7h3LYTlke5sDw4v1tLk6+Lt44L
         9bNp4E+HI1Q94eBAReUJ401pkVGNr13wfZor2MsIqXbrOwNEfe4ID1cf55eMcYYkrZyf
         Yu7CU1QRJhacJIKqTkwEsH44kG8gKCKOEbrcqqq53/WhqhlxxzsXhwAbi23gv1gZeczs
         tlgQ==
X-Gm-Message-State: AC+VfDx7fmJfm69jWY++8KcMmcRoLa3u0JPcBy+r3XOs0IperCiCopsz
	TRwERhTq3Sv3ycaci4CoLbs9pw==
X-Google-Smtp-Source: ACHHUZ5zNl3zF4sunxXpSeBG3iqIPgqD04067JaBJ74OUYwYvldF1w22zbYhhUqfSIf20nyOjqan8Q==
X-Received: by 2002:a7b:c058:0:b0:3f4:2bb3:a5c9 with SMTP id u24-20020a7bc058000000b003f42bb3a5c9mr8194128wmc.8.1685295365690;
        Sun, 28 May 2023 10:36:05 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id z10-20020a7bc7ca000000b003f602e2b653sm15334523wmk.28.2023.05.28.10.36.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 May 2023 10:36:05 -0700 (PDT)
From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Sun, 28 May 2023 19:35:28 +0200
Subject: [PATCH net 3/8] selftests: mptcp: pm nl: skip if MPTCP is not
 supported
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230528-upstream-net-20230528-mptcp-selftests-support-old-kernels-part-1-v1-3-a32d85577fc6@tessares.net>
References: <20230528-upstream-net-20230528-mptcp-selftests-support-old-kernels-part-1-v1-0-a32d85577fc6@tessares.net>
In-Reply-To: <20230528-upstream-net-20230528-mptcp-selftests-support-old-kernels-part-1-v1-0-a32d85577fc6@tessares.net>
To: mptcp@lists.linux.dev, Mat Martineau <martineau@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Shuah Khan <shuah@kernel.org>, Christoph Paasch <cpaasch@apple.com>, 
 Florian Westphal <fw@strlen.de>, Davide Caratti <dcaratti@redhat.com>, 
 Kishen Maloor <kishen.maloor@intel.com>
Cc: netdev@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Matthieu Baerts <matthieu.baerts@tessares.net>, stable@vger.kernel.org
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1180;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=tPfgNXcbGxjjigcC15QgaIpP9qgezD0npYcEzdUe0K4=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkc5EAqrtp68GHwFx1tEZAaK+guHZ+yfGRfd+/T
 1SfzH5iUrWJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZHORAAAKCRD2t4JPQmmg
 c/vtD/0Y66v71A4hyVzVrUApbKDsorh2KklzRJFGUG9nRZPGbAKJH1A+Q7e5u1RlW5g42px05n0
 kux0by6ETPv9BOpZAPq1l3R7sMfpBgYD2UCC3Z51gBq0fzb59IemlzHQzCXvAt8G+qKyKgrhK4p
 ac2J6ESDlIvOVJLHgAsrRwm+UIteYmwiRn8SzH1MyzHAd1qK/NhlosqOvLf4yjB5HBs0jcXu/tK
 eCy5Olv81clL8VTy2rVJ4JHjgDumZ0kA/OnyFTld+wkcnxIE6qJwfdM265vCJCIMpvE+3xzMKww
 NqDEKWG/tryCeAjHJ3exhwT6lLtpL3X7H/IMIewhdsyyTl7THyxLRVljoXOqY2nc4Zc1sALziyM
 o4jWBG81Cv3eRjDeofbOg5MXIzp44IDXrvo1qhZASQvACemEH9Ebr8HINJaTSxyl/H3hRvPvkQx
 wfdR1zMMOuUNxa2T8oJdHAKCmXTO5VZr2mB2hS1PGXKYdiExzQk2ZfeuNQhAW5o7w7t3pKJ373k
 Ws5K22eTkowiiKr3hfmrqi7Yr4zodYabHSIrXJ2ZRntFbglfHhdN3pgmwfXdZNoVza/38oKR2dm
 Tb6tod7L5uP35oNrYif2zvv03UyQIeZgp9BmEdJBQo/huIBUGvepG/YJenk+5GmguMxhoH2Fpjb
 LoTp5Anc0c6MB0Q==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Selftests are supposed to run on any kernels, including the old ones not
supporting MPTCP.

A new check is then added to make sure MPTCP is supported. If not, the
test stops and is marked as "skipped".

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: eedbc685321b ("selftests: add PM netlink functional tests")
Cc: stable@vger.kernel.org
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/pm_netlink.sh | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/pm_netlink.sh b/tools/testing/selftests/net/mptcp/pm_netlink.sh
index 89839d1ff9d8..32f7533e0919 100755
--- a/tools/testing/selftests/net/mptcp/pm_netlink.sh
+++ b/tools/testing/selftests/net/mptcp/pm_netlink.sh
@@ -1,6 +1,8 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
+. "$(dirname "${0}")/mptcp_lib.sh"
+
 ksft_skip=4
 ret=0
 
@@ -34,6 +36,8 @@ cleanup()
 	ip netns del $ns1
 }
 
+mptcp_lib_check_mptcp
+
 ip -Version > /dev/null 2>&1
 if [ $? -ne 0 ];then
 	echo "SKIP: Could not run test without ip tool"

-- 
2.39.2


