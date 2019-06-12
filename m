Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9258342766
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 15:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439285AbfFLNZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 09:25:02 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56009 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437123AbfFLNZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 09:25:01 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 26C8722189;
        Wed, 12 Jun 2019 09:25:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 12 Jun 2019 09:25:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=IFCQ/vms79l7hgd/l
        6vGHNzlJtXLUoIlyBXGe1TKXKg=; b=fL82qqdMH/s8XJkEHQnEySkJpJ1vzFJwY
        9d90SwwCcmz/WQUyXcAA6lLc+m6i6+o3ZS54JRNy5Em/KMKWAAiuhVFoaD5Xa1gK
        +iGnea6QvxI/kRlt/Xh+5L/hs+PKo5RLSbY2Cb5YMxHcWOLsurNsj7l0+ag54XKx
        Uh4EMTe6C+xul93drNzZljp9gQPWYTrXlRXtl5PFZ/s8hVdYRvdPKw+5ssUI/kSb
        Qh5stqkJ7xLdnViNZyidd0kRTmWsYxGx93ag8i4/1hvaxertjxqFPWHFByK1QWC9
        HdQGdRFYIFQhY4fC1ID1h+VLVMIhXaNPT1F1RecnOh+pJpj6A0U7g==
X-ME-Sender: <xms:Kv0AXVRjJmmdaAJqPsIA68E5ifZVqIHJaI4X3hHVoBjCcau-G9pYYQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehjedgieekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepofgrrhhthihnrghsucfruhhmphhuthhishcuoehmsehlrghmsggu
    rgdrlhhtqeenucfkphepudekkedrieefrddvtdejrddvfeehnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehmsehlrghmsggurgdrlhhtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:Kv0AXXUXzghSVG-N8jisQ6wMtWau5igDt49HUKbE4P1sjbLnMCPanA>
    <xmx:Kv0AXR6_qJsV43tzH4P4qKD1zQKDMRmPvgpUW87tFNDB7r9ZKsSRPg>
    <xmx:Kv0AXSGxCTMfoqaz78Ln7QHoqtehiScweOUAmcBHUSse9e_lQ5a1PQ>
    <xmx:LP0AXbWmzbTtuLZJHBbG8PaZ-1ZGSgbLLjm9MCJAHtiqFiFqYrRv2g>
Received: from ceuse.home (235.207.63.188.dynamic.wline.res.cust.swisscom.ch [188.63.207.235])
        by mail.messagingengine.com (Postfix) with ESMTPA id CF3C38005B;
        Wed, 12 Jun 2019 09:24:57 -0400 (EDT)
From:   Martynas Pumputis <m@lambda.lt>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        m@lambda.lt
Subject: [PATCH bpf] bpf: Simplify definition of BPF_FIB_LOOKUP related flags
Date:   Wed, 12 Jun 2019 15:26:45 +0200
Message-Id: <20190612132645.19385-1-m@lambda.lt>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously, the BPF_FIB_LOOKUP_{DIRECT,OUTPUT} flags were defined
with the help of BIT macro. This had the following issues:

- In order to user any of the flags, a user was required to depend
  on <linux/bits.h>.
- No other flag in bpf.h uses the macro, so it seems that an unwritten
  convention is to use (1 << (nr)) to define BPF-related flags.

Signed-off-by: Martynas Pumputis <m@lambda.lt>
---
 include/uapi/linux/bpf.h       | 4 ++--
 tools/include/uapi/linux/bpf.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 63e0cf66f01a..a8f17bc86732 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3376,8 +3376,8 @@ struct bpf_raw_tracepoint_args {
 /* DIRECT:  Skip the FIB rules and go to FIB table associated with device
  * OUTPUT:  Do lookup from egress perspective; default is ingress
  */
-#define BPF_FIB_LOOKUP_DIRECT  BIT(0)
-#define BPF_FIB_LOOKUP_OUTPUT  BIT(1)
+#define BPF_FIB_LOOKUP_DIRECT  (1U << 0)
+#define BPF_FIB_LOOKUP_OUTPUT  (1U << 1)
 
 enum {
 	BPF_FIB_LKUP_RET_SUCCESS,      /* lookup successful */
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 63e0cf66f01a..a8f17bc86732 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3376,8 +3376,8 @@ struct bpf_raw_tracepoint_args {
 /* DIRECT:  Skip the FIB rules and go to FIB table associated with device
  * OUTPUT:  Do lookup from egress perspective; default is ingress
  */
-#define BPF_FIB_LOOKUP_DIRECT  BIT(0)
-#define BPF_FIB_LOOKUP_OUTPUT  BIT(1)
+#define BPF_FIB_LOOKUP_DIRECT  (1U << 0)
+#define BPF_FIB_LOOKUP_OUTPUT  (1U << 1)
 
 enum {
 	BPF_FIB_LKUP_RET_SUCCESS,      /* lookup successful */
-- 
2.21.0

