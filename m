Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 117B46499C8
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 08:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbiLLHyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 02:54:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbiLLHy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 02:54:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0F2B86A
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 23:54:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA4EBB80B83
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 07:54:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9965C433EF;
        Mon, 12 Dec 2022 07:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670831665;
        bh=5iNQHIrtbx5fBZUVOQRKW2JfC3gJUjQV8lLSrcoRTrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Es+sZLQnZ3lEmTzDCVNVqaFwk8gBo+dIFIZatqVkG7QnyG7YxhK2QEQOV7P9LXnVR
         Ix9/PUESlfIx8Yf4mG1URNJkDMYZ0OOEugRjDfL5dpJrfni320U9U/miTidBoIkUAJ
         oWafJ8iqcs65NIyTDEe/Ts+JOR6QgXvfCa7WdpJar3SXttLQ10KrQ8uBup/EED8BDE
         J/ADwO8PCfaaB8sv9jbZ/IrW0rY5UvdiKxneUeYNy11MAzjsR1E7XGC5wPLvab4TqD
         votqP0DKISCr1Aaa5o4KYMtx17NO8PKS6s2gu0NCMJL4hCxTHqVpJmqqejNrTfUlhs
         7ZLmawW8JbDsg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        David Ahern <dsahern@gmail.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>
Subject: [PATCH iproute2-next v1 1/4] Update XFRM kernel header
Date:   Mon, 12 Dec 2022 09:54:03 +0200
Message-Id: <416ac3c4ca63a7747ed83e1b722f98c17a50bea2.1670830561.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670830561.git.leonro@nvidia.com>
References: <cover.1670830561.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Sync XFRM header upto kernel commit d14f28b8c1de
("xfrm: add new packet offload flag")

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/uapi/linux/xfrm.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
index 4809f9be..23543c33 100644
--- a/include/uapi/linux/xfrm.h
+++ b/include/uapi/linux/xfrm.h
@@ -519,6 +519,12 @@ struct xfrm_user_offload {
  */
 #define XFRM_OFFLOAD_IPV6	1
 #define XFRM_OFFLOAD_INBOUND	2
+/* Two bits above are relevant for state path only, while
+ * offload is used for both policy and state flows.
+ *
+ * In policy offload mode, they are free and can be safely reused.
+ */
+#define XFRM_OFFLOAD_PACKET	4
 
 struct xfrm_userpolicy_default {
 #define XFRM_USERPOLICY_UNSPEC	0
@@ -529,12 +535,14 @@ struct xfrm_userpolicy_default {
 	__u8				out;
 };
 
+#ifndef __KERNEL__
 /* backwards compatibility for userspace */
 #define XFRMGRP_ACQUIRE		1
 #define XFRMGRP_EXPIRE		2
 #define XFRMGRP_SA		4
 #define XFRMGRP_POLICY		8
 #define XFRMGRP_REPORT		0x20
+#endif
 
 enum xfrm_nlgroups {
 	XFRMNLGRP_NONE,
-- 
2.38.1

