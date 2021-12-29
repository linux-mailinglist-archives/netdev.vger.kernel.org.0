Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9BA948174D
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 23:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbhL2Wbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 17:31:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbhL2Wbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 17:31:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D344C061574;
        Wed, 29 Dec 2021 14:31:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB8ADB81A45;
        Wed, 29 Dec 2021 22:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378AFC36AEA;
        Wed, 29 Dec 2021 22:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640817108;
        bh=gmhKpgwx//FxG+hBJDgWuIZLskpitOCiP65PEI0Gdpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kVczEt+fUB9/+/wTqX88tsYZCSLYgAH0KUotPhT6sS1aUsOClDttfNNkttz1Njb9Q
         jokfY4Skw6peRfe+cmMMl5JmKoHEJqXyJ8P2jkWg3YlDjgALoHIxY6LSkDC+0m7eaF
         fx2/IWMQINLkhOasMUeKIfD01OX6VWsGfaKlD3RajZ/Lc280NpnXqSrWn9szSOr4L/
         mK3vEx56Ouo4HxfLjbuxALmtAu+P6Zo4L59xelUIPSDPWLgMx2DVSUpZ/C5qu/rxi+
         mMYNwWFE1V13oYoenYvxxoQHzePL7bMmudSZ2z6dlS6eIDBMWJfVNU65SP5bsRFmvx
         MdFW3GV6eanKg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf-next 2/2] bpf: invert the dependency between bpf-netns.h and netns/bpf.h
Date:   Wed, 29 Dec 2021 14:31:39 -0800
Message-Id: <20211229223139.708975-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211229223139.708975-1-kuba@kernel.org>
References: <20211229223139.708975-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netns/bpf.h gets included by netdevice.h (thru net_namespace.h)
which in turn gets included in a lot of places. We should keep
netns/bpf.h as light-weight as possible.

bpf-netns.h seems to contain more implementation details than
deserves to be included in a netns header. It needs to pull in
uapi/bpf.h to get various enum types.

Move enum netns_bpf_attach_type to netns/bpf.h and invert the
dependency. This makes netns/bpf.h fit the mold of a struct
definition header more clearly, and drops the number of objects
rebuilt when uapi/bpf.h is touched from 7.7k to 1.1k.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/bpf-netns.h | 8 +-------
 include/net/netns/bpf.h   | 9 ++++++++-
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/linux/bpf-netns.h b/include/linux/bpf-netns.h
index 722f799c1a2e..413cfa5e4b07 100644
--- a/include/linux/bpf-netns.h
+++ b/include/linux/bpf-netns.h
@@ -3,15 +3,9 @@
 #define _BPF_NETNS_H
 
 #include <linux/mutex.h>
+#include <net/netns/bpf.h>
 #include <uapi/linux/bpf.h>
 
-enum netns_bpf_attach_type {
-	NETNS_BPF_INVALID = -1,
-	NETNS_BPF_FLOW_DISSECTOR = 0,
-	NETNS_BPF_SK_LOOKUP,
-	MAX_NETNS_BPF_ATTACH_TYPE
-};
-
 static inline enum netns_bpf_attach_type
 to_netns_bpf_attach_type(enum bpf_attach_type attach_type)
 {
diff --git a/include/net/netns/bpf.h b/include/net/netns/bpf.h
index 0ca6a1b87185..2c01a278d1eb 100644
--- a/include/net/netns/bpf.h
+++ b/include/net/netns/bpf.h
@@ -6,11 +6,18 @@
 #ifndef __NETNS_BPF_H__
 #define __NETNS_BPF_H__
 
-#include <linux/bpf-netns.h>
+#include <linux/list.h>
 
 struct bpf_prog;
 struct bpf_prog_array;
 
+enum netns_bpf_attach_type {
+	NETNS_BPF_INVALID = -1,
+	NETNS_BPF_FLOW_DISSECTOR = 0,
+	NETNS_BPF_SK_LOOKUP,
+	MAX_NETNS_BPF_ATTACH_TYPE
+};
+
 struct netns_bpf {
 	/* Array of programs to run compiled from progs or links */
 	struct bpf_prog_array __rcu *run_array[MAX_NETNS_BPF_ATTACH_TYPE];
-- 
2.31.1

