Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66500481811
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 02:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233947AbhL3B1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 20:27:50 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50680 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233914AbhL3B1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 20:27:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2B53615BF;
        Thu, 30 Dec 2021 01:27:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBD8C36AEC;
        Thu, 30 Dec 2021 01:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640827668;
        bh=gmhKpgwx//FxG+hBJDgWuIZLskpitOCiP65PEI0Gdpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H3IjhKA+nD9uquuAL6o5iQksZw53uoc2O1icGUg4cyuYHWSMLRkZ+x0mttx8Mte0p
         UuyqupAlJWuO8qLPcYkrijDXE2EZXp6CTS8ay7KvEfBVLXZyOKfSEtgqWLbV31us0w
         Mvysy0aqVWZ6sP+/rqvc3kbMNR5XiG52dJX8FYiiyTNusNf12pUYnweq/gF7MoKcHN
         H1EBoKbA6onnQnbHhajjm9LBQ1kVNjr8k/1ZcTH5VQk6q+fS/7C4PoYcMS18zGbdKu
         vrNor68HCoOhLvYAYqC7XV4hcCpE/bnY2drYNe8sSJ52hQV/lPcaLgFe0r86M7X2Kl
         u5NYtXWItZuhA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf-next v2 2/2] bpf: invert the dependency between bpf-netns.h and netns/bpf.h
Date:   Wed, 29 Dec 2021 17:27:42 -0800
Message-Id: <20211230012742.770642-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211230012742.770642-1-kuba@kernel.org>
References: <20211230012742.770642-1-kuba@kernel.org>
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

