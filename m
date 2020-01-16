Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15C8713EA8C
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406026AbgAPRo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:44:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:36212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406006AbgAPRoz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:44:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44BDD24783;
        Thu, 16 Jan 2020 17:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196695;
        bh=DafYjLE3n3Q5W7KxpsvOtRj2irNzGbmQnj8g8RiiOkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YnVwU/svH2+E12PSz2+MhkFVKcARMZSlYq88QzWj8qLT88nNcTGi+d59qxqupYb5B
         Cg1x22HZZwkZ1m5G71OdZ0IOkr43gH7b30ndx7+yfsJhbWSCRCtjaPbK1loLw+fwui
         M7mRr+P2GwnqrwCmmUCyu0L44+dK0KU4tt2D0u2E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 089/174] netfilter: ebtables: CONFIG_COMPAT: reject trailing data after last rule
Date:   Thu, 16 Jan 2020 12:41:26 -0500
Message-Id: <20200116174251.24326-89-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116174251.24326-1-sashal@kernel.org>
References: <20200116174251.24326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 680f6af5337c98d116e4f127cea7845339dba8da ]

If userspace provides a rule blob with trailing data after last target,
we trigger a splat, then convert ruleset to 64bit format (with trailing
data), then pass that to do_replace_finish() which then returns -EINVAL.

Erroring out right away avoids the splat plus unneeded translation and
error unwind.

Fixes: 81e675c227ec ("netfilter: ebtables: add CONFIG_COMPAT support")
Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/netfilter/ebtables.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index fd1af7cb960d..e7c170949b21 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -2174,7 +2174,9 @@ static int compat_copy_entries(unsigned char *data, unsigned int size_user,
 	if (ret < 0)
 		return ret;
 
-	WARN_ON(size_remaining);
+	if (size_remaining)
+		return -EINVAL;
+
 	return state->buf_kern_offset;
 }
 
-- 
2.20.1

