Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B215425794
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 18:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242665AbhJGQTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 12:19:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242652AbhJGQSz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 12:18:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E76B611C3;
        Thu,  7 Oct 2021 16:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633623422;
        bh=8sAV6q+14eiHBjK3Y1sRwJSYdxxyN2jhUlobDg8wR3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qp8bT3qmqYLZfGCQb1/rnKOH+4khEsO/N8Ceo+Abrs0CIEo567L0MuSPBvUXytrXi
         BnbFzQBHuQaYsFzznwyAJyamkn4EDmiJM8iH3PApUsy65pVKJ+VrbkaOAH8xPEm5Io
         g6HYhUkhclMpFeyWvpKA5XnEXVTwXHbLIgio/ZqRhBpwN9dgMMST46hgwFi/rJLy+G
         AeNT/iudXpfvflCMchMbxAHELUK/i9S+/b0En+0WnsyM5gkd2OqU1tsFDqz4T1BjEk
         4hONHA7Ag5HGjarzCbKPrlDt1m9kxHvMjfD5gG20KZAGRbZjERoQVNmCl0/77EcVCy
         D0HJGcOxAA9Gg==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, pabeni@redhat.com,
        juri.lelli@redhat.com, netdev@vger.kernel.org
Subject: [PATCH net-next 3/3] ppp: use the correct function to check if a netdev name is in use
Date:   Thu,  7 Oct 2021 18:16:52 +0200
Message-Id: <20211007161652.374597-4-atenart@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007161652.374597-1-atenart@kernel.org>
References: <20211007161652.374597-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A new helper to detect if a net device name is in use was added. Use it
here as the return reference from __dev_get_by_name was discarded.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 drivers/net/ppp/ppp_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index fb52cd175b45..1180a0e2445f 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -1161,7 +1161,7 @@ static int ppp_unit_register(struct ppp *ppp, int unit, bool ifname_is_set)
 		if (!ifname_is_set) {
 			while (1) {
 				snprintf(ppp->dev->name, IFNAMSIZ, "ppp%i", ret);
-				if (!__dev_get_by_name(ppp->ppp_net, ppp->dev->name))
+				if (!netdev_name_in_use(ppp->ppp_net, ppp->dev->name))
 					break;
 				unit_put(&pn->units_idr, ret);
 				ret = unit_get(&pn->units_idr, ppp, ret + 1);
-- 
2.31.1

