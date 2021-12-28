Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5EC0480A82
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 15:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234654AbhL1Os3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 09:48:29 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56522 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhL1Os3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 09:48:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D3C1B8122C;
        Tue, 28 Dec 2021 14:48:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FAD5C36AE8;
        Tue, 28 Dec 2021 14:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640702907;
        bh=CyQJyk0HvSNVhixuKb9a3dLBsqlKf7j34qj2YxYKiVM=;
        h=From:To:Cc:Subject:Date:From;
        b=CgIRjhScbDIs8gz9Ge6YPqHpwrrrcjvRopO2iAkgrPgC5b1m2ZO6+ahDft2AGm/Bu
         hdfTb4/46AGbxt2l/4CJmzG0JkFKU2OFvWa9tHQ+DKkB71HIJEEfeHYniciaY3CbbA
         /1hOXqbU8VgBMbHCOkzmet82KePTu68L2JDaTKoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] SUNRPC: use default_groups in kobj_type
Date:   Tue, 28 Dec 2021 15:48:23 +0100
Message-Id: <20211228144823.393067-1-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2138; h=from:subject; bh=CyQJyk0HvSNVhixuKb9a3dLBsqlKf7j34qj2YxYKiVM=; b=owGbwMvMwCRo6H6F97bub03G02pJDImnlberfvt6KPDyU5vGKxM3z3jDq9NwXfJod4xL1INN7b62 i++/7IhlYRBkYpAVU2T5so3n6P6KQ4pehranYeawMoEMYeDiFICbrMMwz9Y/uvbmxqf7+z2bZCUDzv 25FZurz7Bgxiztzy+KrzC8K85QfZ8iJnr/ut8bAA==
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are currently 2 ways to create a set of sysfs files for a
kobj_type, through the default_attrs field, and the default_groups
field.  Move the sunrpc sysfs code to use default_groups field which has
been the preferred way since aa30f47cf666 ("kobject: Add support for
default attribute groups to kobj_type") so that we can soon get rid of
the obsolete default_attrs field.

Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Anna Schumaker <anna.schumaker@netapp.com>
Cc: linux-nfs@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/sysfs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/sysfs.c b/net/sunrpc/sysfs.c
index 2766dd21935b..b1aea3419218 100644
--- a/net/sunrpc/sysfs.c
+++ b/net/sunrpc/sysfs.c
@@ -422,6 +422,7 @@ static struct attribute *rpc_sysfs_xprt_attrs[] = {
 	&rpc_sysfs_xprt_change_state.attr,
 	NULL,
 };
+ATTRIBUTE_GROUPS(rpc_sysfs_xprt);
 
 static struct kobj_attribute rpc_sysfs_xprt_switch_info =
 	__ATTR(xprt_switch_info, 0444, rpc_sysfs_xprt_switch_info_show, NULL);
@@ -430,6 +431,7 @@ static struct attribute *rpc_sysfs_xprt_switch_attrs[] = {
 	&rpc_sysfs_xprt_switch_info.attr,
 	NULL,
 };
+ATTRIBUTE_GROUPS(rpc_sysfs_xprt_switch);
 
 static struct kobj_type rpc_sysfs_client_type = {
 	.release = rpc_sysfs_client_release,
@@ -439,14 +441,14 @@ static struct kobj_type rpc_sysfs_client_type = {
 
 static struct kobj_type rpc_sysfs_xprt_switch_type = {
 	.release = rpc_sysfs_xprt_switch_release,
-	.default_attrs = rpc_sysfs_xprt_switch_attrs,
+	.default_groups = rpc_sysfs_xprt_switch_groups,
 	.sysfs_ops = &kobj_sysfs_ops,
 	.namespace = rpc_sysfs_xprt_switch_namespace,
 };
 
 static struct kobj_type rpc_sysfs_xprt_type = {
 	.release = rpc_sysfs_xprt_release,
-	.default_attrs = rpc_sysfs_xprt_attrs,
+	.default_groups = rpc_sysfs_xprt_groups,
 	.sysfs_ops = &kobj_sysfs_ops,
 	.namespace = rpc_sysfs_xprt_namespace,
 };
-- 
2.34.1

