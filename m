Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9224E4822A7
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 08:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242773AbhLaH4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 02:56:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbhLaH4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 02:56:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777BFC061574;
        Thu, 30 Dec 2021 23:56:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1B90B81D18;
        Fri, 31 Dec 2021 07:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290A4C36AE9;
        Fri, 31 Dec 2021 07:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640937406;
        bh=fopNdx8omm5Fdxk8QkckX3qGnamr+tEqCZEK4dP7puk=;
        h=From:To:Cc:Subject:Date:From;
        b=Pz6XF5xm12yC8AYxLuKDsvK6ovNbvw7tjgt1d7b0v7gOGwlMYDZGnTU5s3CnDWNto
         xb5wErjn/8bzjxkKG7L7sIp0PYEfn8+YUvtPqGRjU91CFqEBWcR19OVL0s+9MhzQ2k
         Vnf04KmzpLmz6qUfqv8m+yAqwaj6+ZjsEVVEH7KIoCAUcxE57xQOr1ax95GMXfrvMt
         sZUHm7NzYdx/pH1ltPgQFL66WBXcIA7YeZ0cj8utelX+yw4PJVHJ3/QYYxuvC0ppgL
         mv/amhRqz0nV8+FSYsUBRnajE8HkOm3dMZn7kwQS60qniLfQmZz76ILeaB3cnmWYuN
         ABLgm7Ko19o+w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH net] scripts/pahole-flags.sh: Make sure pahole --version works
Date:   Thu, 30 Dec 2021 23:56:07 -0800
Message-Id: <20211231075607.94752-1-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

I had a broken pahole and it's been driving me crazy to see tons of the
following error messages on every build.

pahole: symbol lookup error: pahole: undefined symbol: btf_gen_floats
scripts/pahole-flags.sh: line 12: [: : integer expression expected
scripts/pahole-flags.sh: line 16: [: : integer expression expected

Address this by redirecting pahole --version stderr to devnull,
and validate stdout has a non empty string, otherwise exit silently.

Fixes: 9741e07ece7c ("kbuild: Unify options for BTF generation for vmlinux and modules")
CC: Andrii Nakryiko <andrii@kernel.org>
CC: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 scripts/pahole-flags.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/pahole-flags.sh b/scripts/pahole-flags.sh
index e6093adf4c06..b3b53f890d40 100755
--- a/scripts/pahole-flags.sh
+++ b/scripts/pahole-flags.sh
@@ -7,7 +7,8 @@ if ! [ -x "$(command -v ${PAHOLE})" ]; then
 	exit 0
 fi
 
-pahole_ver=$(${PAHOLE} --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/')
+pahole_ver=$(${PAHOLE} --version 2>/dev/null | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/')
+[ -z "${pahole_ver}" ] && exit 0
 
 if [ "${pahole_ver}" -ge "118" ] && [ "${pahole_ver}" -le "121" ]; then
 	# pahole 1.18 through 1.21 can't handle zero-sized per-CPU vars
-- 
2.33.1

