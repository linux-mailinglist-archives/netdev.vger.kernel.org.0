Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A92F6353A59
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 02:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhDEAbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 20:31:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36420 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231757AbhDEAbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Apr 2021 20:31:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617582671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qegaL49eQ0ulAGqlQqr7hH6RdMrVNCo8k8O6Uq9V76E=;
        b=P5qmX1FOqCHYBE77C7nw9DbkK8f+WDUISDM08jVvw+ecb5Iea67ggZfv6kojauiglgDNNt
        Os+2v8gprQaJC/x2y385YCGTzGrwB9YeWcVCJExHoweSZ1X2C1v1JebypBGHh69S+p+uoh
        WAz11iqp437J5tAWwFoikAb/96m433M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518--W0lacKHNAG3w7X0vgBtfw-1; Sun, 04 Apr 2021 20:31:10 -0400
X-MC-Unique: -W0lacKHNAG3w7X0vgBtfw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C7CC6B9C1;
        Mon,  5 Apr 2021 00:31:09 +0000 (UTC)
Received: from carbon.redhat.com (ovpn-113-102.rdu2.redhat.com [10.10.113.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BCB8A37DD;
        Mon,  5 Apr 2021 00:31:08 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     stefan@datenfreihafen.org
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH RESEND wpan 08/15] net: ieee802154: forbid monitor for del llsec dev
Date:   Sun,  4 Apr 2021 20:30:47 -0400
Message-Id: <20210405003054.256017-9-aahringo@redhat.com>
In-Reply-To: <20210405003054.256017-1-aahringo@redhat.com>
References: <20210405003054.256017-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch forbids to del llsec dev for monitor interfaces which we
don't support yet. Otherwise we will access llsec mib which isn't
initialized for monitors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 net/ieee802154/nl802154.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 0d7dc9478b56..17c782d4cdae 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1781,6 +1781,9 @@ static int nl802154_del_llsec_dev(struct sk_buff *skb, struct genl_info *info)
 	struct nlattr *attrs[NL802154_DEV_ATTR_MAX + 1];
 	__le64 extended_addr;
 
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
+		return -EOPNOTSUPP;
+
 	if (!info->attrs[NL802154_ATTR_SEC_DEVICE] ||
 	    nla_parse_nested_deprecated(attrs, NL802154_DEV_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_DEVICE], nl802154_dev_policy, info->extack))
 		return -EINVAL;
-- 
2.26.3

