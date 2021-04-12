Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D76535CC9A
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244258AbhDLQae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:30:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244766AbhDLQ2c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:28:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBFD96138A;
        Mon, 12 Apr 2021 16:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244726;
        bh=DMw0tzUNNDYjGX04WDWD70Yw2Ofs5bu2bM4vZtKLCJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pL+drsQeaWkYi4VCG4hX46SfJ4i3TN0zZzRMyR0Z3BFeGqyJoNgoDDw4a4PnlQswt
         TngQL/yRMuysImfyQrgQpFV9UsguUXbfPF9w46OeTxbOYkzX/m/vgp1V27D5Tf0zFj
         uyyifQ66JXgtNndK/rXoteJmcX9xnnRXxPBDAGNDk1Tpai6ZDZID0mPzQjOyFAS/dM
         v0ZChi8+XeDAJS3nbg65zVxX2xE9tCM1/pGRgiFTt+bUIQd5yH8ZlS+8TIms7E/zqn
         GEkWc3quFgYZtOad0btKKWvagpAi/DFa8CRhO13Ma+zKFf026uoRujpJYGh7LTvS01
         /GzX8IpLKCbFg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        syzbot+8b6719da8a04beeafcc3@syzkaller.appspotmail.com,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 19/39] net: ieee802154: forbid monitor for set llsec params
Date:   Mon, 12 Apr 2021 12:24:41 -0400
Message-Id: <20210412162502.314854-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162502.314854-1-sashal@kernel.org>
References: <20210412162502.314854-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 88c17855ac4291fb462e13a86b7516773b6c932e ]

This patch forbids to set llsec params for monitor interfaces which we
don't support yet.

Reported-by: syzbot+8b6719da8a04beeafcc3@syzkaller.appspotmail.com
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-3-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index c398f1ac74b8..748e0aac0b78 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1400,6 +1400,9 @@ static int nl802154_set_llsec_params(struct sk_buff *skb,
 	u32 changed = 0;
 	int ret;
 
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
+		return -EOPNOTSUPP;
+
 	if (info->attrs[NL802154_ATTR_SEC_ENABLED]) {
 		u8 enabled;
 
-- 
2.30.2

