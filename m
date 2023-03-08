Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A23AB6AFB64
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 01:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbjCHAk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 19:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbjCHAkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 19:40:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DEBEBDC4
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 16:39:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8F41B8136B
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 00:39:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F07C433A0;
        Wed,  8 Mar 2023 00:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678235970;
        bh=IaHVxqH13ozSxPEzkbI4LMAPDZlHSfv/ZdhDicu9tCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tq1OMzEj4/hrvkokAeL9Qd4+uUvLstkbl6y9bFof9Pzum6bSzLV3wGV4XoBGnS2bs
         hMexWnSrHBNptf+sFbYJ97LYkTHWMhua0UgH8xIIo668gj3i1L/Mn3sX497uFh1A5p
         f0VOhOiVm5Un4o7KFwDVILKVlbvCK/UAoBIKbP5AbbDPvYy/R1yvqRf1VJ4m7Kam58
         h83NyEsrfmQZx1FWWciNnDXOKSjPar+rk7nSsiDDlYZlHs2lcUFh1GSSpDc05U1mIU
         pK2GblrxLxcNSXHy5aLwIFCOTBbT4tXyF+DPhaLUDkC4+AtUVYOefkKCr/gwko/mnM
         GWn/eNn6B9yPw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        lorenzo@kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 2/2] tools: ynl: fix enum-as-flags in the generic CLI
Date:   Tue,  7 Mar 2023 16:39:23 -0800
Message-Id: <20230308003923.445268-3-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230308003923.445268-1-kuba@kernel.org>
References: <20230308003923.445268-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo points out that the generic CLI is broken for the netdev
family. When I added the support for documentation of enums
(and sparse enums) the client script was not updated.
It expects the values in enum to be a list of names,
now it can also be a dict (YAML object).

Reported-by: Lorenzo Bianconi <lorenzo@kernel.org>
Fixes: e4b48ed460d3 ("tools: ynl: add a completely generic client")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/lib/nlspec.py | 7 +++++--
 tools/net/ynl/lib/ynl.py    | 9 ++-------
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/tools/net/ynl/lib/nlspec.py b/tools/net/ynl/lib/nlspec.py
index 7c1cf6c1499e..a34d088f6743 100644
--- a/tools/net/ynl/lib/nlspec.py
+++ b/tools/net/ynl/lib/nlspec.py
@@ -104,8 +104,9 @@ jsonschema = None
     as declared in the "definitions" section of the spec.
 
     Attributes:
-        type          enum or flags
-        entries       entries by name
+        type            enum or flags
+        entries         entries by name
+        entries_by_val  entries by value
     Methods:
         get_mask      for flags compute the mask of all defined values
     """
@@ -117,9 +118,11 @@ jsonschema = None
         prev_entry = None
         value_start = self.yaml.get('value-start', 0)
         self.entries = dict()
+        self.entries_by_val = dict()
         for entry in self.yaml['entries']:
             e = self.new_entry(entry, prev_entry, value_start)
             self.entries[e.name] = e
+            self.entries_by_val[e.raw_value()] = e
             prev_entry = e
 
     def new_entry(self, entry, prev_entry, value_start):
diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index a842adc8e87e..90764a83c646 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -303,11 +303,6 @@ genl_family_name_to_id = None
         self.sock.setsockopt(Netlink.SOL_NETLINK, Netlink.NETLINK_CAP_ACK, 1)
         self.sock.setsockopt(Netlink.SOL_NETLINK, Netlink.NETLINK_EXT_ACK, 1)
 
-        self._types = dict()
-
-        for elem in self.yaml.get('definitions', []):
-            self._types[elem['name']] = elem
-
         self.async_msg_ids = set()
         self.async_msg_queue = []
 
@@ -353,13 +348,13 @@ genl_family_name_to_id = None
 
     def _decode_enum(self, rsp, attr_spec):
         raw = rsp[attr_spec['name']]
-        enum = self._types[attr_spec['enum']]
+        enum = self.consts[attr_spec['enum']]
         i = attr_spec.get('value-start', 0)
         if 'enum-as-flags' in attr_spec and attr_spec['enum-as-flags']:
             value = set()
             while raw:
                 if raw & 1:
-                    value.add(enum['entries'][i])
+                    value.add(enum.entries_by_val[i].name)
                 raw >>= 1
                 i += 1
         else:
-- 
2.39.2

