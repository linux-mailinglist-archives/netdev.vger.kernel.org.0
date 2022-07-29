Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF32584DB2
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 10:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235335AbiG2Iwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 04:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235341AbiG2Iwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 04:52:31 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0659783216
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 01:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659084751; x=1690620751;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=74cyOkIGGHhTsGQ59iNOnqZuh9PV91KCMxRyhZ7HDfo=;
  b=AW/LkGmvcsJu0g388fx2le3vplR96QsO9RxivbnLr5/CiUU3IsIsFZMT
   JXLki3owZkqgyB6+Zu034ar4O7x0kJlcGSWVeBERb7V1EbwdvejjiMHnB
   QGeFZpi3egcME8xVNg5UUlqNr7PQMz1/LsoO1fg5+YPAl13/VHvMXUuk6
   CTeV9YFT2aJEoobf5ni/HzSD74oAX2oA6ULOXV8fiq/WrmdMZxTPPdXy7
   ffGVoGJRpT0AuVyUH5Z2qxVsAgq2aVj/9YviBViYvV3DVIJjSt8DUK+zm
   yJGTuMKyNGH4IPj3tYF1jZUL8CK1v5AY4BtSIqQ/ApDrzon8VFi0F26mZ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10422"; a="289924233"
X-IronPort-AV: E=Sophos;i="5.93,200,1654585200"; 
   d="scan'208";a="289924233"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 01:52:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,200,1654585200"; 
   d="scan'208";a="601222060"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga002.jf.intel.com with ESMTP; 29 Jul 2022 01:52:29 -0700
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 26T8qR3A020937;
        Fri, 29 Jul 2022 09:52:28 +0100
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, gnault@redhat.com
Subject: [PATCH iproute-next v4 1/3] lib: refactor ll_proto functions
Date:   Fri, 29 Jul 2022 10:50:33 +0200
Message-Id: <20220729085035.535788-2-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220729085035.535788-1-wojciech.drewek@intel.com>
References: <20220729085035.535788-1-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move core logic of ll_proto_n2a and ll_proto_a2n
to utils.c and make it more generic by allowing to
pass table of protocols as argument (proto_tb).
Introduce struct proto with protocol ID and name to
allow this. This wil allow to use those functions by
other use cases.

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
 include/utils.h | 10 ++++++++++
 lib/ll_proto.c  | 33 ++++++++-------------------------
 lib/utils.c     | 34 ++++++++++++++++++++++++++++++++++
 3 files changed, 52 insertions(+), 25 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index 9765fdd231df..eeb23a64f008 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -369,4 +369,14 @@ void inc_indent(struct indent_mem *mem);
 void dec_indent(struct indent_mem *mem);
 void print_indent(struct indent_mem *mem);
 
+struct proto {
+	int id;
+	const char *name;
+};
+
+int proto_a2n(unsigned short *id, const char *buf,
+	      const struct proto *proto_tb, size_t tb_len);
+const char *proto_n2a(unsigned short id, char *buf, int len,
+		      const struct proto *proto_tb, size_t tb_len);
+
 #endif /* __UTILS_H__ */
diff --git a/lib/ll_proto.c b/lib/ll_proto.c
index 342ea2eefa4c..925e2caa05e5 100644
--- a/lib/ll_proto.c
+++ b/lib/ll_proto.c
@@ -28,10 +28,8 @@
 
 
 #define __PF(f,n) { ETH_P_##f, #n },
-static const struct {
-	int id;
-	const char *name;
-} llproto_names[] = {
+
+static const struct proto llproto_names[] = {
 __PF(LOOP,loop)
 __PF(PUP,pup)
 __PF(PUPAT,pupat)
@@ -90,31 +88,16 @@ __PF(TEB,teb)
 };
 #undef __PF
 
-
-const char * ll_proto_n2a(unsigned short id, char *buf, int len)
+const char *ll_proto_n2a(unsigned short id, char *buf, int len)
 {
-        int i;
+	size_t len_tb = ARRAY_SIZE(llproto_names);
 
-	id = ntohs(id);
-
-        for (i=0; !numeric && i<sizeof(llproto_names)/sizeof(llproto_names[0]); i++) {
-                 if (llproto_names[i].id == id)
-			return llproto_names[i].name;
-	}
-        snprintf(buf, len, "[%d]", id);
-        return buf;
+	return proto_n2a(id, buf, len, llproto_names, len_tb);
 }
 
 int ll_proto_a2n(unsigned short *id, const char *buf)
 {
-        int i;
-        for (i=0; i < sizeof(llproto_names)/sizeof(llproto_names[0]); i++) {
-                 if (strcasecmp(llproto_names[i].name, buf) == 0) {
-			 *id = htons(llproto_names[i].id);
-			 return 0;
-		 }
-	}
-	if (get_be16(id, buf, 0))
-		return -1;
-	return 0;
+	size_t len_tb = ARRAY_SIZE(llproto_names);
+
+	return proto_a2n(id, buf, llproto_names, len_tb);
 }
diff --git a/lib/utils.c b/lib/utils.c
index 53d310060284..dd3cdb31239c 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -1925,3 +1925,37 @@ void print_indent(struct indent_mem *mem)
 	if (mem->indent_level)
 		printf("%s", mem->indent_str);
 }
+
+const char *proto_n2a(unsigned short id, char *buf, int len,
+		      const struct proto *proto_tb, size_t tb_len)
+{
+	int i;
+
+	id = ntohs(id);
+
+	for (i = 0; !numeric && i < tb_len; i++) {
+		if (proto_tb[i].id == id)
+			return proto_tb[i].name;
+	}
+
+	snprintf(buf, len, "[%d]", id);
+
+	return buf;
+}
+
+int proto_a2n(unsigned short *id, const char *buf,
+	      const struct proto *proto_tb, size_t tb_len)
+{
+	int i;
+
+	for (i = 0; i < tb_len; i++) {
+		if (strcasecmp(proto_tb[i].name, buf) == 0) {
+			*id = htons(proto_tb[i].id);
+			return 0;
+		}
+	}
+	if (get_be16(id, buf, 0))
+		return -1;
+
+	return 0;
+}
-- 
2.31.1

