Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4A2142BB8
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730134AbfFLQDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:03:51 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:34167 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727111AbfFLQDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 12:03:50 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 18A3421FF3;
        Wed, 12 Jun 2019 12:03:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 12 Jun 2019 12:03:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=GDV9hhZ5GxuMS6XRy
        5N2kICLAkIhzOp0RyrylQkM568=; b=VocxbXoLTtARYZ0ifA2gvbkXk83QqEVoN
        wuQ0sdFBYGBKkdLU/wyRh7YiSwRu39dcYjzsrCCmB6UG8XqxnWLb0eQoqerRJbdn
        oA3nEDveaWrK4JOEDHUQYcvcVDMU765TI5lnHyWx7NLhTSiVYtozhx+VlwdGWRwu
        ic2xfHpuRjW90EjKI5DWid+ePORfNF6udeGf8E+77tZvZAUej5WybDyQyAeWrhjU
        kYctNCRvMZuI3QLlJrg4B/A1DpLSrCy+EP898JqpbBVg7CKmNVJk6TFqdYT0E1uR
        88Za6nc3SaRjMB5MuVnyBgpjYywtWsTjHlAmO4wAAGkDIOZudltmg==
X-ME-Sender: <xms:ZCIBXXIoRfYt2iNTXM9AxJzFS1XkeblrYxM0YqSrZWXK_5qS14S8rw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehjedguddtudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpeforghrthihnhgrshcurfhumhhpuhhtihhsuceomheslhgrmhgs
    uggrrdhltheqnecukfhppeefuddrudeigedruddvuddrfedvnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehmsehlrghmsggurgdrlhhtnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:ZCIBXW8sMjexLWhHsv6zYFUc09aziIDFqXPFp59N3smINWN-9j4YIA>
    <xmx:ZCIBXVPjIqwE1kif8vtv3BfAjGI6Cq6nlZM4-t_vuHbrCooZbCSzHA>
    <xmx:ZCIBXS14l6OkmGx5cXWPGP8k2wBkN3wmec2fOa4jpXkW2OYFaX7a4w>
    <xmx:ZiIBXfL9ce1s-lQW3N0Lij6qPJD51A1S8oHt7iwXqnkwbrs5eiBN9w>
Received: from localhost.localdomain (xdsl-31-164-121-32.adslplus.ch [31.164.121.32])
        by mail.messagingengine.com (Postfix) with ESMTPA id F1927380083;
        Wed, 12 Jun 2019 12:03:47 -0400 (EDT)
From:   Martynas Pumputis <m@lambda.lt>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        m@lambda.lt
Subject: [PATCH bpf v2 1/2] bpf: simplify definition of BPF_FIB_LOOKUP related flags
Date:   Wed, 12 Jun 2019 18:05:40 +0200
Message-Id: <20190612160541.2550-1-m@lambda.lt>
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
 include/uapi/linux/bpf.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
-- 
2.21.0

