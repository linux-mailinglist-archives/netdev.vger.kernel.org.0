Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBFD3665275
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 04:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbjAKDkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 22:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjAKDks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 22:40:48 -0500
Received: from sender4-op-o11.zoho.com (sender4-op-o11.zoho.com [136.143.188.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CCBC616E
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 19:40:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1673408445; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=mA2Z2dT5PLOEGj/IwDqEu3VTi6pqAzUvh5fH2EJoxXkumCeuSzA13LPFMRyBu8CXXtzemG3cgz+k37UiSCGuPiJTgMfXpc0DYh0ESYMFWIWo3YhZYwp2um+H3N6vMcOrZlfx+qNJsRz+w5jMdevz8zTgrpYImT+xfudso+tnb2c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1673408445; h=Content-Type:Content-Transfer-Encoding:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=NGhbMpFSbugVZkfQW3UgG1ozrf04ZOqIWgpS2li0PYE=; 
        b=VWTufF7bSSDxtjQNDXs40Ia7bxLceQu42NbWjKKOZU0P/HsUt07fN8S1sFp7CqLkwmJ/CBOj2VIxWC6dOPCw3fu7JI7khARr1VfGERQRBezxx5fR6hDThx3GcHwoDvBjFSdBKdZr4G8/k8Yj/i1eXof62jnaaKzT+SC0No3Ny0M=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=mcqueen.au;
        spf=pass  smtp.mailfrom=craig@mcqueen.au;
        dmarc=pass header.from=<craig@mcqueen.au>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1673408445;
        s=zmail; d=mcqueen.au; i=craig@mcqueen.au;
        h=Message-ID:Date:Date:MIME-Version:From:From:Subject:Subject:To:To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
        bh=NGhbMpFSbugVZkfQW3UgG1ozrf04ZOqIWgpS2li0PYE=;
        b=aYdV3mmrfAjDFUYJcMosLHXEaSfNZtSLSh5Z/Hl+O3QuAuFXEVxHotnPyJFKw2ec
        2lFFTDLsP7e9LonXUSUNBQhdohBaH98INQ2yVD7KSDfny9xQVNLr1SzP68F7mIx3WGs
        obRWIUtbQ7RwZIdsB+DDQoz0AqbrGz23MR+PlwPo=
Received: from [172.17.17.238] (159-196-145-163.9fc491.syd.nbn.aussiebb.net [159.196.145.163]) by mx.zohomail.com
        with SMTPS id 1673408443073397.3062029847131; Tue, 10 Jan 2023 19:40:43 -0800 (PST)
Message-ID: <09bf9abc-4a43-f1e9-d5f7-5b034c9812eb@mcqueen.au>
Date:   Wed, 11 Jan 2023 14:40:40 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
From:   Craig McQueen <craig@mcqueen.au>
Subject: KSZ8795 incorrect bit definitions for static MAC table
To:     netdev <netdev@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm working on an embedded project with KSZ8794 and kernel 5.15.

I found that after reconfiguring the network interfaces a few times, 
configurations were failing with error ENOSPC. I traced it to the 8 
slots of the static MAC table gradually filling up.

It looks as though several bit definitions for the static MAC address 
table are wrong. I made the changes below. I'm working with kernel 5.15. 
Looking at the latest git repo, it looks as though the KSZ8795 driver 
code has been reworked so ksz8795_masks[] etc is in ksz_common.c rather 
than ksz8795.c. But the bug appears to be still present, and the fix is 
similar.

Note that for KSZ8795, the static MAC address registers are unusual 
because the "FID" and "Use FID" fields have different bit locations for 
reads and writes. But also the "Override" and "Forwarding Ports" 
definitions were just wrong.

Note that the ksz8863_masks[] change has not been tested, but it looks 
right from a read of the data sheet.



commit be8988c1d3f014799a518360fe219ad35b42c9a8 (HEAD -> 
ksz8795-bit-offsets)
Author: Craig McQueen <craig.mcqueen@innerrange.com 
<mailto:craig.mcqueen@innerrange.com>>
Date:   Tue Jan 10 17:16:37 2023 +1100

     ksz8795: Fix bit offsets for static MAC address table

     Refer to KSZ8795CLX data sheet, Microchip document DS00002112E, section
     4.4 "Static MAC Address Table", table 4-16.

     Unusually, the bit locations of the "FID" and "Use FID" fields are
     different for reads and writes.

diff --git a/drivers/net/dsa/microchip/ksz8.h 
b/drivers/net/dsa/microchip/ksz8.h
index 9d611895d3cf..bb98cc3d89f6 100644
--- a/drivers/net/dsa/microchip/ksz8.h
+++ b/drivers/net/dsa/microchip/ksz8.h
@@ -34,8 +34,10 @@ enum ksz_masks {
      VLAN_TABLE_MEMBERSHIP,
      VLAN_TABLE_VALID,
      STATIC_MAC_TABLE_VALID,
-    STATIC_MAC_TABLE_USE_FID,
-    STATIC_MAC_TABLE_FID,
+    STATIC_MAC_TABLE_USE_FID_R,
+    STATIC_MAC_TABLE_USE_FID_W,
+    STATIC_MAC_TABLE_FID_R,
+    STATIC_MAC_TABLE_FID_W,
      STATIC_MAC_TABLE_OVERRIDE,
      STATIC_MAC_TABLE_FWD_PORTS,
      DYNAMIC_MAC_TABLE_ENTRIES_H,
@@ -51,7 +53,8 @@ enum ksz_shifts {
      VLAN_TABLE_MEMBERSHIP_S,
      VLAN_TABLE,
      STATIC_MAC_FWD_PORTS,
-    STATIC_MAC_FID,
+    STATIC_MAC_FID_R,
+    STATIC_MAC_FID_W,
      DYNAMIC_MAC_ENTRIES_H,
      DYNAMIC_MAC_ENTRIES,
      DYNAMIC_MAC_FID,
diff --git a/drivers/net/dsa/microchip/ksz8795.c 
b/drivers/net/dsa/microchip/ksz8795.c
index c9c682352ac3..16b546ad0cd3 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -50,10 +50,12 @@ static const u32 ksz8795_masks[] = {
      [VLAN_TABLE_MEMBERSHIP]        = GENMASK(11, 7),
      [VLAN_TABLE_VALID]        = BIT(12),
      [STATIC_MAC_TABLE_VALID]    = BIT(21),
-    [STATIC_MAC_TABLE_USE_FID]    = BIT(23),
-    [STATIC_MAC_TABLE_FID]        = GENMASK(30, 24),
-    [STATIC_MAC_TABLE_OVERRIDE]    = BIT(26),
-    [STATIC_MAC_TABLE_FWD_PORTS]  = GENMASK(24, 20),
+    [STATIC_MAC_TABLE_USE_FID_R]  = BIT(24),
+    [STATIC_MAC_TABLE_USE_FID_W]  = BIT(23),
+    [STATIC_MAC_TABLE_FID_R]    = GENMASK(31, 25),
+    [STATIC_MAC_TABLE_FID_W]    = GENMASK(30, 24),
+    [STATIC_MAC_TABLE_OVERRIDE]    = BIT(22),
+    [STATIC_MAC_TABLE_FWD_PORTS]  = GENMASK(20, 16),
      [DYNAMIC_MAC_TABLE_ENTRIES_H]  = GENMASK(6, 0),
      [DYNAMIC_MAC_TABLE_MAC_EMPTY]  = BIT(8),
      [DYNAMIC_MAC_TABLE_NOT_READY]  = BIT(7),
@@ -67,7 +69,8 @@ static const u8 ksz8795_shifts[] = {
      [VLAN_TABLE_MEMBERSHIP_S]    = 7,
      [VLAN_TABLE]            = 16,
      [STATIC_MAC_FWD_PORTS]        = 16,
-    [STATIC_MAC_FID]        = 24,
+    [STATIC_MAC_FID_R]        = 25,
+    [STATIC_MAC_FID_W]        = 24,
      [DYNAMIC_MAC_ENTRIES_H]        = 3,
      [DYNAMIC_MAC_ENTRIES]        = 29,
      [DYNAMIC_MAC_FID]        = 16,
@@ -100,8 +103,10 @@ static const u32 ksz8863_masks[] = {
      [VLAN_TABLE_MEMBERSHIP]        = GENMASK(18, 16),
      [VLAN_TABLE_VALID]        = BIT(19),
      [STATIC_MAC_TABLE_VALID]    = BIT(19),
-    [STATIC_MAC_TABLE_USE_FID]    = BIT(21),
-    [STATIC_MAC_TABLE_FID]        = GENMASK(29, 26),
+    [STATIC_MAC_TABLE_USE_FID_R]  = BIT(21),
+    [STATIC_MAC_TABLE_USE_FID_W]  = BIT(21),
+    [STATIC_MAC_TABLE_FID_R]    = GENMASK(29, 26),
+    [STATIC_MAC_TABLE_FID_W]    = GENMASK(29, 26),
      [STATIC_MAC_TABLE_OVERRIDE]    = BIT(20),
      [STATIC_MAC_TABLE_FWD_PORTS]  = GENMASK(18, 16),
      [DYNAMIC_MAC_TABLE_ENTRIES_H]  = GENMASK(5, 0),
@@ -116,7 +121,8 @@ static const u32 ksz8863_masks[] = {
  static u8 ksz8863_shifts[] = {
      [VLAN_TABLE_MEMBERSHIP_S]    = 16,
      [STATIC_MAC_FWD_PORTS]        = 16,
-    [STATIC_MAC_FID]        = 22,
+    [STATIC_MAC_FID_R]        = 22,
+    [STATIC_MAC_FID_W]        = 22,
      [DYNAMIC_MAC_ENTRIES_H]        = 3,
      [DYNAMIC_MAC_ENTRIES]        = 24,
      [DYNAMIC_MAC_FID]        = 16,
@@ -604,9 +610,9 @@ static int ksz8_r_sta_mac_table(struct ksz_device 
*dev, u16 addr,
          data_hi >>= 1;
          alu->is_static = true;
          alu->is_use_fid =
-            (data_hi & masks[STATIC_MAC_TABLE_USE_FID]) ? 1 : 0;
-        alu->fid = (data_hi & masks[STATIC_MAC_TABLE_FID]) >>
-  shifts[STATIC_MAC_FID];
+            (data_hi & masks[STATIC_MAC_TABLE_USE_FID_R]) ? 1 : 0;
+        alu->fid = (data_hi & masks[STATIC_MAC_TABLE_FID_R]) >>
+  shifts[STATIC_MAC_FID_R];
          return 0;
      }
      return -ENXIO;
@@ -633,8 +639,8 @@ static void ksz8_w_sta_mac_table(struct ksz_device 
*dev, u16 addr,
      if (alu->is_override)
          data_hi |= masks[STATIC_MAC_TABLE_OVERRIDE];
      if (alu->is_use_fid) {
-        data_hi |= masks[STATIC_MAC_TABLE_USE_FID];
-        data_hi |= (u32)alu->fid << shifts[STATIC_MAC_FID];
+        data_hi |= masks[STATIC_MAC_TABLE_USE_FID_W];
+        data_hi |= ((u32)alu->fid << shifts[STATIC_MAC_FID_W]) & 
masks[STATIC_MAC_TABLE_FID_W];
      }
      if (alu->is_static)
          data_hi |= masks[STATIC_MAC_TABLE_VALID];


