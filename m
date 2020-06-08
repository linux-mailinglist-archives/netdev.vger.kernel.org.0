Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B901F2988
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732686AbgFIABQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:01:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730946AbgFHXW2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:22:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9F1E208B8;
        Mon,  8 Jun 2020 23:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658548;
        bh=wJyh5j0fx3dTdY/TvsFuOEKeXxSb+H8xonC0coZh0V0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ywm0/pZwDZcF+0gSsWQd2lp21yqA9KL/sqOgacny5NDQYwTZdtndliWpLCB1iqptj
         OuzHMDtTeGa7zJr/UlApwL2mhEj3UNIpArL+rbUMrsyXs5FaL736ZO6lfaJHnmA5NJ
         MbbNPFlNFpI7xe5iJguvW+jRBkVTb596sso5kPw8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anton Protopopov <a.s.protopopov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 169/175] bpf: Fix map permissions check
Date:   Mon,  8 Jun 2020 19:18:42 -0400
Message-Id: <20200608231848.3366970-169-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anton Protopopov <a.s.protopopov@gmail.com>

[ Upstream commit 1ea0f9120c8ce105ca181b070561df5cbd6bc049 ]

The map_lookup_and_delete_elem() function should check for both FMODE_CAN_WRITE
and FMODE_CAN_READ permissions because it returns a map element to user space.

Fixes: bd513cd08f10 ("bpf: add MAP_LOOKUP_AND_DELETE_ELEM syscall")
Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20200527185700.14658-5-a.s.protopopov@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 946cfdd3b2cc..e7af1ac69d75 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1118,7 +1118,8 @@ static int map_lookup_and_delete_elem(union bpf_attr *attr)
 	map = __bpf_map_get(f);
 	if (IS_ERR(map))
 		return PTR_ERR(map);
-	if (!(map_get_sys_perms(map, f) & FMODE_CAN_WRITE)) {
+	if (!(map_get_sys_perms(map, f) & FMODE_CAN_READ) ||
+	    !(map_get_sys_perms(map, f) & FMODE_CAN_WRITE)) {
 		err = -EPERM;
 		goto err_put;
 	}
-- 
2.25.1

