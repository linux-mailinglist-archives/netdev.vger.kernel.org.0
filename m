Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18359122CEF
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 14:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbfLQNcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 08:32:45 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:59273 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728109AbfLQNcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 08:32:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1576589556; x=1608125556;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FAYXJj84UoQTVVBnxHAl8dNCc4arpYx+KqB8fudTUbg=;
  b=PiiAW0EtyhJXfOREs8KkOhK5iL92X7OegSkgIGdtwRPDOs6rj/4ecZL2
   9BPVGqlsSCPK26kSiopvqca/C8KLEhhIbGYZjA5WfzAk5kcwCa02rMnus
   ausazFBePldpv9XfrBQMLdITd1RoRDPa2GpdS7a+ak0fTI2mXXeEUyOqe
   g=;
IronPort-SDR: FzkCJqPLkG3ZjnmxE5thsvs7TUTJE/iTfT8QiWibj+CfSjnm/tx4FJL13ae/9AZAkjY69DAtnI
 V9tBGVig7/oQ==
X-IronPort-AV: E=Sophos;i="5.69,325,1571702400"; 
   d="scan'208";a="15379907"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 17 Dec 2019 13:32:29 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id B7154281EA1;
        Tue, 17 Dec 2019 13:32:27 +0000 (UTC)
Received: from EX13D32EUC004.ant.amazon.com (10.43.164.121) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Tue, 17 Dec 2019 13:32:27 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D32EUC004.ant.amazon.com (10.43.164.121) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 17 Dec 2019 13:32:26 +0000
Received: from u2f063a87eabd5f.cbg10.amazon.com (10.125.106.135) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Tue, 17 Dec 2019 13:32:24 +0000
From:   Paul Durrant <pdurrant@amazon.com>
To:     <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Paul Durrant <pdurrant@amazon.com>, Wei Liu <wei.liu@kernel.org>,
        "Paul Durrant" <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next 2/3] xen-netback: switch state to InitWait at the end of netback_probe()...
Date:   Tue, 17 Dec 2019 13:32:17 +0000
Message-ID: <20191217133218.27085-3-pdurrant@amazon.com>
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

...as the comment above the function states.

The switch to Initialising at the start of the function is somewhat bogus
as the toolstack will have set that initial state anyway. To behave
correctly, a backend should switch to InitWait once it has set up all
xenstore values that may be required by a initialising frontend. This
patch calls backend_switch_state() to make the transition at the
appropriate point.

NOTE: backend_switch_state() ignores errors from xenbus_switch_state()
      and so this patch removes an error path from netback_probe(). This
      means a failure to change state at this stage (in the absence of
      other failures) will leave the device instantiated. This is highly
      unlikley to happen as a failure to change state would indicate a
      failure to write to xenstore, and that will trigger other error
      paths. Also, a 'stuck' device can still be cleaned up using 'unbind'
      in any case.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
---
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Paul Durrant <paul@xen.org>
Cc: "David S. Miller" <davem@davemloft.net>
---
 drivers/net/xen-netback/xenbus.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index bb61316d79de..682e5e20971b 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -992,11 +992,6 @@ static int netback_probe(struct xenbus_device *dev,
 	be->dev = dev;
 	dev_set_drvdata(&dev->dev, be);
 
-	be->state = XenbusStateInitialising;
-	err = xenbus_switch_state(dev, XenbusStateInitialising);
-	if (err)
-		goto fail;
-
 	sg = 1;
 
 	do {
@@ -1098,6 +1093,8 @@ static int netback_probe(struct xenbus_device *dev,
 	if (err)
 		pr_debug("Error writing feature-ctrl-ring\n");
 
+	backend_switch_state(be, XenbusStateInitWait);
+
 	script = xenbus_read(XBT_NIL, dev->nodename, "script", NULL);
 	if (IS_ERR(script)) {
 		err = PTR_ERR(script);
-- 
2.20.1

