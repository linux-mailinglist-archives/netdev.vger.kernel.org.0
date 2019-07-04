Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51FC85F90A
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 15:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbfGDNVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 09:21:31 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39166 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727026AbfGDNVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 09:21:30 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x64DJtmC007998;
        Thu, 4 Jul 2019 06:21:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=nZCfGDpUi7ipPKNZ5eAzsq61c9N3eh1qw3q2obPLDEk=;
 b=qHpUxx/XzUv77nsWG4Ub4s0OkIyC2BE5cOmnetXhAHMbiFMtKXEdyZWRFPFP2gkZJ5dn
 2H6s3xy3YYqutFKJJgPWqeDDrg5tKrxDb3JmPEBfc9oWkinpTdmU0IcXG3Xi1SvYhVEV
 UJD+L/r6j+J4qO28oLslWOwqGtaj4rdU8bw6dooCws13b4IWSjauhhx18YsiUwKAUfZP
 QVwciaul6NMRr769qE5bDNO1lduvziJa/JSjq93FjbBkTE7sWBS93TIMYSyoGB86RVPC
 NO2gbty3z6syx6RoPSHDe5LJ5NFN4U7D8LUY+66MOw/oND44ODbtmOKK/CIW7Kynnoza +A== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2tgtf75hbb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 04 Jul 2019 06:21:28 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 4 Jul
 2019 06:21:26 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Thu, 4 Jul 2019 06:21:26 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 91C553F703F;
        Thu,  4 Jul 2019 06:21:26 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x64DLQPN013657;
        Thu, 4 Jul 2019 06:21:26 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x64DLQvP013656;
        Thu, 4 Jul 2019 06:21:26 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <mkalderon@marvell.com>,
        <aelior@marvell.com>
Subject: [PATCH net-next v2 1/4] devlink: Add APIs to publish/unpublish the port parameters.
Date:   Thu, 4 Jul 2019 06:20:08 -0700
Message-ID: <20190704132011.13600-2-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190704132011.13600-1-skalluru@marvell.com>
References: <20190704132011.13600-1-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-04_06:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kernel has no interface to publish the devlink port parameters. This is
required for exporting the port params to the user space, so that user
can read or update the port params.
This patch adds devlink interfaces (for drivers) to publish/unpublish the
devlink port parameters.

Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 include/net/devlink.h |  2 ++
 net/core/devlink.c    | 42 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 6625ea0..47a1e8f 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -653,6 +653,8 @@ int devlink_port_params_register(struct devlink_port *devlink_port,
 void devlink_port_params_unregister(struct devlink_port *devlink_port,
 				    const struct devlink_param *params,
 				    size_t params_count);
+void devlink_port_params_publish(struct devlink_port *devlink_port);
+void devlink_port_params_unpublish(struct devlink_port *ddevlink_port);
 int devlink_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
 				       union devlink_param_value *init_val);
 int devlink_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 89c5337..0cd7994 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6380,6 +6380,48 @@ void devlink_port_params_unregister(struct devlink_port *devlink_port,
 }
 EXPORT_SYMBOL_GPL(devlink_port_params_unregister);
 
+/**
+ *	devlink_port_params_publish - publish port configuration parameters
+ *
+ *	@devlink_port: devlink port
+ *
+ *	Publish previously registered port configuration parameters.
+ */
+void devlink_port_params_publish(struct devlink_port *devlink_port)
+{
+	struct devlink_param_item *param_item;
+
+	list_for_each_entry(param_item, &devlink_port->param_list, list) {
+		if (param_item->published)
+			continue;
+		param_item->published = true;
+		devlink_param_notify(devlink_port->devlink, devlink_port->index,
+				     param_item, DEVLINK_CMD_PORT_PARAM_NEW);
+	}
+}
+EXPORT_SYMBOL_GPL(devlink_port_params_publish);
+
+/**
+ *	devlink_port_params_unpublish - unpublish port configuration parameters
+ *
+ *	@devlink_port: devlink port
+ *
+ *	Unpublish previously registered port configuration parameters.
+ */
+void devlink_port_params_unpublish(struct devlink_port *devlink_port)
+{
+	struct devlink_param_item *param_item;
+
+	list_for_each_entry(param_item, &devlink_port->param_list, list) {
+		if (!param_item->published)
+			continue;
+		param_item->published = false;
+		devlink_param_notify(devlink_port->devlink, devlink_port->index,
+				     param_item, DEVLINK_CMD_PORT_PARAM_DEL);
+	}
+}
+EXPORT_SYMBOL_GPL(devlink_port_params_unpublish);
+
 static int
 __devlink_param_driverinit_value_get(struct list_head *param_list, u32 param_id,
 				     union devlink_param_value *init_val)
-- 
1.8.3.1

