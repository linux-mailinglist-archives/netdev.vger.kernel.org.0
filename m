Return-Path: <netdev+bounces-9743-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E340972A59F
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 23:54:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DCD3281AE7
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:54:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DED8E24E8C;
	Fri,  9 Jun 2023 21:53:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB8123C8B
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 21:53:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A49C4339C;
	Fri,  9 Jun 2023 21:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686347622;
	bh=/rfswinmgP6TjttXB72YAHMz5samhnt4yUfyVMeCD4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RUfoqPmlS5AoQDc1ecDY9AJtZQT/19nFjcCstjlwgfmRBXeW7ay5/sRr+bdSrXue+
	 tMp4ijoGg/fvnfrDOBmMRbQBDpUbfjsHvwL10OD/v7S8a/ypJPt59jUGET3xnhB30R
	 UcFbGYRpHZvO3c9wTTWBX1+iiosrPxYeVB6jeLxaeGsez1IGUM1QLJ2yvrwx2XEvCz
	 DZO32m0wcc3KsiabnPgUglyhYWd921HfNkwlrnGfDuNWHgkfGVlmWev/eqwF0W9haA
	 Mu4LhzBwEE7hUM1c4xI5eUTaweELmGphCONkZC/L3P0OZje4Cu4SLMjDUc/i68FvBO
	 rKjuKCMlnXopw==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	dsahern@gmail.com,
	mkubecek@suse.cz,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/2] net: ethtool: don't require empty header nests
Date: Fri,  9 Jun 2023 14:53:31 -0700
Message-Id: <20230609215331.1606292-3-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230609215331.1606292-1-kuba@kernel.org>
References: <20230609215331.1606292-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Ethtool currently requires a header nest (which is used to carry
the common family options) in all requests including dumps.

  $ cli.py --spec netlink/specs/ethtool.yaml --dump channels-get
  lib.ynl.NlError: Netlink error: Invalid argument
  nl_len = 64 (48) nl_flags = 0x300 nl_type = 2
	error: -22      extack: {'msg': 'request header missing'}

  $ cli.py --spec netlink/specs/ethtool.yaml --dump channels-get \
           --json '{"header":{}}';  )
  [{'combined-count': 1,
    'combined-max': 1,
    'header': {'dev-index': 2, 'dev-name': 'enp1s0'}}]

Requiring the header nest to always be there may seem nice
from the consistency perspective, but it's not serving any
practical purpose. We shouldn't burden the user like this.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ethtool/netlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 08120095cc68..5dd5e8222c45 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -96,6 +96,8 @@ int ethnl_parse_header_dev_get(struct ethnl_req_info *req_info,
 	int ret;
 
 	if (!header) {
+		if (!require_dev)
+			return 0;
 		NL_SET_ERR_MSG(extack, "request header missing");
 		return -EINVAL;
 	}
-- 
2.40.1


