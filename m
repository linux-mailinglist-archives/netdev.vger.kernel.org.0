Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CACDE485899
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 19:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243125AbiAESlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 13:41:09 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33606 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243116AbiAESlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 13:41:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D6C6B81D46;
        Wed,  5 Jan 2022 18:41:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F37C36AE0;
        Wed,  5 Jan 2022 18:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641408066;
        bh=i0KRcBQtthz/kEcTgYuuCYQynolYf9Qi/rP3f/111/g=;
        h=From:To:Cc:Subject:Date:From;
        b=QvN+J1mZ5Ca33TbowC/mjDThCj71fiUMbrcGvBO0n9dacBRf4rzbA/BBACCbtcJO+
         Iyn1jbKWI39B4OtCcCsfvFHtypdpuKlqoBFifeDuYy2hYPmsni6MXOeG32+Ey+CVjg
         ls5zuKR4tGWCoXi3AlUtRmUV+cbZYpuW7hcc6CiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Cristobal Forno <cforno12@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org
Subject: [PATCH] ethernet: ibmveth: use default_groups in kobj_type
Date:   Wed,  5 Jan 2022 19:41:01 +0100
Message-Id: <20220105184101.2859410-1-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1636; h=from:subject; bh=i0KRcBQtthz/kEcTgYuuCYQynolYf9Qi/rP3f/111/g=; b=owGbwMvMwCRo6H6F97bub03G02pJDIlXn9nenXbIUcI1aH7F5NsT562zlVtpqNBq+sD7lnFc1qGH Mzcc74hlYRBkYpAVU2T5so3n6P6KQ4pehranYeawMoEMYeDiFICJHH/BME9bOu3LvGMJd5ev+vHg8a Tf4SE8TR8Z5rtu8VTkf3504yfFUwW55k/zV810mgIA
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are currently 2 ways to create a set of sysfs files for a
kobj_type, through the default_attrs field, and the default_groups
field.  Move the ibmveth sysfs code to use default_groups
field which has been the preferred way since aa30f47cf666 ("kobject: Add
support for default attribute groups to kobj_type") so that we can soon
get rid of the obsolete default_attrs field.

Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Cristobal Forno <cforno12@linux.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: netdev@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmveth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 45ba40cf4d07..22fb0d109a68 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1890,6 +1890,7 @@ static struct attribute *veth_pool_attrs[] = {
 	&veth_size_attr,
 	NULL,
 };
+ATTRIBUTE_GROUPS(veth_pool);
 
 static const struct sysfs_ops veth_pool_ops = {
 	.show   = veth_pool_show,
@@ -1899,7 +1900,7 @@ static const struct sysfs_ops veth_pool_ops = {
 static struct kobj_type ktype_veth_pool = {
 	.release        = NULL,
 	.sysfs_ops      = &veth_pool_ops,
-	.default_attrs  = veth_pool_attrs,
+	.default_groups = veth_pool_groups,
 };
 
 static int ibmveth_resume(struct device *dev)
-- 
2.34.1

