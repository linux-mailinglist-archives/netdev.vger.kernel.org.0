Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88B3E122CF0
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 14:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbfLQNcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 08:32:45 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:45638 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727286AbfLQNcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 08:32:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1576589563; x=1608125563;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xFBgFF359VKnRAXaxtzuRfTSQoaKQ3ji8za7lRotgcg=;
  b=vTaRVEwibQNmo9msk9I0p55K5TKc+gJ8SRGh3cTo/LI+YYgWxZHxKyPb
   dmzKmdfg8BYwIiyaxMadKJa34Mi0H/g9T9tNa9W2pvZJy+stCYJgrW/yS
   heLMgZjVRnHoxn6oQ3lcG7BGHYfxW0EieTyRBg8A06qnVpAnz39HNFI5T
   Q=;
IronPort-SDR: 97FMGiWWh4D2HG4sFPz60bCjTRTep23ZDvDxTj7NuVeDDXnY0adm9qcQvFrCAQnLxQcJRhgZia
 6Iqi+PNSLcLg==
X-IronPort-AV: E=Sophos;i="5.69,325,1571702400"; 
   d="scan'208";a="14007166"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-715bee71.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 17 Dec 2019 13:32:32 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-715bee71.us-east-1.amazon.com (Postfix) with ESMTPS id 9B9ABA1CFC;
        Tue, 17 Dec 2019 13:32:29 +0000 (UTC)
Received: from EX13D32EUB003.ant.amazon.com (10.43.166.165) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Tue, 17 Dec 2019 13:32:29 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D32EUB003.ant.amazon.com (10.43.166.165) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 17 Dec 2019 13:32:28 +0000
Received: from u2f063a87eabd5f.cbg10.amazon.com (10.125.106.135) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Tue, 17 Dec 2019 13:32:26 +0000
From:   Paul Durrant <pdurrant@amazon.com>
To:     <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Paul Durrant <pdurrant@amazon.com>, Wei Liu <wei.liu@kernel.org>,
        "Paul Durrant" <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next 3/3] xen-netback: remove 'hotplug-status' once it has served its purpose
Date:   Tue, 17 Dec 2019 13:32:18 +0000
Message-ID: <20191217133218.27085-4-pdurrant@amazon.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191217133218.27085-1-pdurrant@amazon.com>
References: <20191217133218.27085-1-pdurrant@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Removing the 'hotplug-status' node in netback_remove() is wrong; the script
may not have completed. Only remove the node once the watch has fired and
has been unregistered.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
---
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Paul Durrant <paul@xen.org>
Cc: "David S. Miller" <davem@davemloft.net>
---
 drivers/net/xen-netback/xenbus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index 682e5e20971b..17b4950ec051 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -648,6 +648,7 @@ static void hotplug_status_changed(struct xenbus_watch *watch,
 
 		/* Not interested in this watch anymore. */
 		unregister_hotplug_status_watch(be);
+		xenbus_rm(XBT_NIL, be->dev->nodename, "hotplug-status");
 	}
 	kfree(str);
 }
@@ -959,7 +960,6 @@ static int netback_remove(struct xenbus_device *dev)
 	if (be->vif) {
 		kobject_uevent(&dev->dev.kobj, KOBJ_OFFLINE);
 		xen_unregister_watchers(be->vif);
-		xenbus_rm(XBT_NIL, dev->nodename, "hotplug-status");
 		xenvif_free(be->vif);
 		be->vif = NULL;
 	}
-- 
2.20.1

