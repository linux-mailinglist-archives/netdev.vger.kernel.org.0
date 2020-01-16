Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 539CF13F4BF
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404217AbgAPSvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:51:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:43304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387629AbgAPRIs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:08:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9516205F4;
        Thu, 16 Jan 2020 17:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194528;
        bh=+1SbirVJ/IyS3tu9c+GI5RoSNlHihK6fBZBfyPRruwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HVug6EDA5OYxbISIueoQejRNE15OstowuFGI0Iwb1pv4DstGBlN1oykYafdN+W8z8
         JmC3TTl5o+xivjpaBYEPyxSu4g7Fk2ydAHc9tcbeQlI5jrHsdu5Z6SOWbbSgROOVcN
         yz+SgnOWlkgbYC9iJt/rJp8rz0yTRGaYX0CKAf0s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anton Protopopov <a.s.protopopov@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 417/671] bpf: fix the check that forwarding is enabled in bpf_ipv6_fib_lookup
Date:   Thu, 16 Jan 2020 12:00:55 -0500
Message-Id: <20200116170509.12787-154-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anton Protopopov <a.s.protopopov@gmail.com>

[ Upstream commit 56f0f84e69c7a7f229dfa524b13b0ceb6ce9b09e ]

The bpf_ipv6_fib_lookup function should return BPF_FIB_LKUP_RET_FWD_DISABLED
when forwarding is disabled for the input device.  However instead of checking
if forwarding is enabled on the input device, it checked the global
net->ipv6.devconf_all->forwarding flag.  Change it to behave as expected.

Fixes: 87f5fc7e48dd ("bpf: Provide helper to do forwarding lookups in kernel FIB table")
Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 91b950261975..9daf1a4118b5 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4367,7 +4367,7 @@ static int bpf_ipv6_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
 		return -ENODEV;
 
 	idev = __in6_dev_get_safely(dev);
-	if (unlikely(!idev || !net->ipv6.devconf_all->forwarding))
+	if (unlikely(!idev || !idev->cnf.forwarding))
 		return BPF_FIB_LKUP_RET_FWD_DISABLED;
 
 	if (flags & BPF_FIB_LOOKUP_OUTPUT) {
-- 
2.20.1

