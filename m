Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887FD260060
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731028AbgIGQr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:47:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:49084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730350AbgIGQfM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 12:35:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6098221E7;
        Mon,  7 Sep 2020 16:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496511;
        bh=TYi4kWw7AUWwK2bR6sXAbhGmQqnAW9uobvtqfk7wdEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=htTUbge9HPMwxJsWhW9zLUTW1g0sb9hZfPPtXOunfiGrP2kjtrV6I3Ms6HOGeGYOF
         tNVDGLcJ31gpUvqX1yatW3qqL+cfBSEB/mC+6YrYb+RsbHlLoKjW2Iq+uivUHBp/Su
         WO3myUq9+wNGbKWEpjhrUCkNRLnRgDvgQUx0qUHI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        syzbot+d451401ffd00a60677ee@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 08/17] cfg80211: regulatory: reject invalid hints
Date:   Mon,  7 Sep 2020 12:34:51 -0400
Message-Id: <20200907163500.1281543-8-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163500.1281543-1-sashal@kernel.org>
References: <20200907163500.1281543-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 47caf685a6854593348f216e0b489b71c10cbe03 ]

Reject invalid hints early in order to not cause a kernel
WARN later if they're restored to or similar.

Reported-by: syzbot+d451401ffd00a60677ee@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=d451401ffd00a60677ee
Link: https://lore.kernel.org/r/20200819084648.13956-1-johannes@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/reg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index b95d1c2bdef7e..9eb9d34cef7b1 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2408,6 +2408,9 @@ int regulatory_hint_user(const char *alpha2,
 	if (WARN_ON(!alpha2))
 		return -EINVAL;
 
+	if (!is_world_regdom(alpha2) && !is_an_alpha2(alpha2))
+		return -EINVAL;
+
 	request = kzalloc(sizeof(struct regulatory_request), GFP_KERNEL);
 	if (!request)
 		return -ENOMEM;
-- 
2.25.1

