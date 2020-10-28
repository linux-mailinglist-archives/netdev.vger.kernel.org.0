Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7E229DBFC
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390943AbgJ2ASq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:18:46 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:29390 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731729AbgJ1WqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:46:00 -0400
Received: from pps.filterd (m0122332.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09SIXhii018398;
        Wed, 28 Oct 2020 18:35:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=jan2016.eng; bh=QHRCVLp4CAAwVNTHi/ogi2zDhO/Ww8e02Wo9o2T4ZXU=;
 b=Shv1VdaHl3wv1eMhc+9blvSS58jcluZjyrOq6/40JBTfNH24N7Szo4+FaOdxDTmaTSxu
 L8v5lq81AEyYkP2gR6wFr5nPaZ34w1wl5XN/MAncei72TvVRPtl2tdQ3ZlgmDyTD/FuF
 SDi8L7FPjEGwmsZ0yA370uoRU9h8LBefWd46K1duxE5LfbHI3HTM95ffrjvj5Z7dqb3T
 XLhUemzcgoeNJtZimjdKQ11IrcLAL2szH6a+UU2F76nuTl2aMXrWHzd8PRR/OD39Eclf
 1NKkRiR6/shGBeZ2N0mx08RD3DN/PswFRSE/12CLocn9dBXlfVKUfcMNYSSvm7lwJgo4 kw== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 34ccbhn25w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 18:35:57 +0000
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.16.0.42/8.16.0.42) with SMTP id 09SIZ2vW031609;
        Wed, 28 Oct 2020 14:35:56 -0400
Received: from prod-mail-relay10.akamai.com ([172.27.118.251])
        by prod-mail-ppoint1.akamai.com with ESMTP id 34f29jh4pc-1;
        Wed, 28 Oct 2020 14:35:56 -0400
Received: from bos-mpr1x.145bw.corp.akamai.com (bos-mpr1x.bos01.corp.akamai.com [172.19.34.200])
        by prod-mail-relay10.akamai.com (Postfix) with ESMTP id 86E553D8DE;
        Wed, 28 Oct 2020 18:35:56 +0000 (GMT)
From:   Puneet Sharma <pusharma@akamai.com>
To:     stephen@networkplumber.org, dsahern@kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH iproute2] tc: add print options to fix json output
Date:   Wed, 28 Oct 2020 14:35:54 -0400
Message-Id: <20201028183554.18078-1-pusharma@akamai.com>
X-Mailer: git-send-email 2.24.1 (Apple Git-126)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-28_08:2020-10-28,2020-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010280119
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-28_08:2020-10-28,2020-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 clxscore=1031 mlxlogscore=999 spamscore=0 adultscore=0 phishscore=0
 malwarescore=0 priorityscore=1501 bulkscore=0 mlxscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010280119
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 184.51.33.18)
 smtp.mailfrom=pusharma@akamai.com smtp.helo=prod-mail-ppoint1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, json for basic rules output does not produce correct json
syntax. The following fixes were done to correct it for extended
matches for use with "basic" filters.

tc/f_basic.c: replace fprintf with print_uint to support json output.
fixing this prints "handle" tag correctly in json output.

tc/m_ematch.c: replace various fprintf with correct print.
add new "ematch" tag for json output which represents
"tc filter add ... basic match '()'" string. Added print_raw_string
to print raw string instead of key value for json.

lib/json_writer.c: add jsonw_raw_string to print raw text in json.

lib/json_print.c: add print_color_raw_string to print string
depending on context.

example:
$ tc -s -d -j filter show dev <eth_name> ingress
Before:
...
"options": {handle 0x2
  (
    cmp(u8 at 9 layer 1 eq 6)
    OR cmp(u8 at 9 layer 1 eq 17)
  ) AND ipset(test-ipv4 src)

            "actions": [{
...

After:
[{
...
"options": {
    "handle": 1,
    "ematch": "(cmp(u8 at 9 layer 1 eq 6)OR cmp(u8 at 9 layer 1 eq 17)) AND ipset(test-ipv4 src)",
...
]

Signed-off-by: Puneet Sharma <pusharma@akamai.com>
---
 include/json_print.h  |  1 +
 include/json_writer.h |  1 +
 lib/json_print.c      | 17 +++++++++++++++++
 lib/json_writer.c     |  5 +++++
 tc/f_basic.c          |  2 +-
 tc/m_ematch.c         | 26 ++++++++++++++++----------
 6 files changed, 41 insertions(+), 11 deletions(-)

diff --git a/include/json_print.h b/include/json_print.h
index 50e71de4..91af7295 100644
--- a/include/json_print.h
+++ b/include/json_print.h
@@ -67,6 +67,7 @@ _PRINT_FUNC(s64, int64_t)
 _PRINT_FUNC(bool, bool)
 _PRINT_FUNC(null, const char*)
 _PRINT_FUNC(string, const char*)
+_PRINT_FUNC(raw_string, const char*)
 _PRINT_FUNC(uint, unsigned int)
 _PRINT_FUNC(u64, uint64_t)
 _PRINT_FUNC(hhu, unsigned char)
diff --git a/include/json_writer.h b/include/json_writer.h
index b52dc2d0..afb561a6 100644
--- a/include/json_writer.h
+++ b/include/json_writer.h
@@ -31,6 +31,7 @@ void jsonw_name(json_writer_t *self, const char *name);
 /* Add value  */
 __attribute__((format(printf, 2, 3)))
 void jsonw_printf(json_writer_t *self, const char *fmt, ...);
+void jsonw_raw_string(json_writer_t *self, const char *value);
 void jsonw_string(json_writer_t *self, const char *value);
 void jsonw_bool(json_writer_t *self, bool value);
 void jsonw_float(json_writer_t *self, double number);
diff --git a/lib/json_print.c b/lib/json_print.c
index fe0705bf..ff76afba 100644
--- a/lib/json_print.c
+++ b/lib/json_print.c
@@ -186,6 +186,23 @@ int print_color_string(enum output_type type,
 	return ret;
 }
 
+int print_color_raw_string(enum output_type type,
+			enum color_attr color,
+			const char *key,
+			const char *fmt,
+			const char *value)
+{
+	int ret = 0;
+
+	if (_IS_JSON_CONTEXT(type))
+		jsonw_raw_string(_jw, fmt);
+	else if (_IS_FP_CONTEXT(type)) {
+		ret = color_fprintf(stdout, color, fmt, value);
+ 	}
+
+	return ret;
+}
+
 /*
  * value's type is bool. When using this function in FP context you can't pass
  * a value to it, you will need to use "is_json_context()" to have different
diff --git a/lib/json_writer.c b/lib/json_writer.c
index 88c5eb88..80ab0a20 100644
--- a/lib/json_writer.c
+++ b/lib/json_writer.c
@@ -51,6 +51,11 @@ static void jsonw_eor(json_writer_t *self)
 	self->sep = ',';
 }
 
+void jsonw_raw_string(json_writer_t *self, const char *str)
+{
+	for (; *str; ++str)
+		putc(*str, self->out);
+}
 
 /* Output JSON encoded string */
 /* Handles C escapes, does not do Unicode */
diff --git a/tc/f_basic.c b/tc/f_basic.c
index 7b19cea6..444d4297 100644
--- a/tc/f_basic.c
+++ b/tc/f_basic.c
@@ -119,7 +119,7 @@ static int basic_print_opt(struct filter_util *qu, FILE *f,
 	parse_rtattr_nested(tb, TCA_BASIC_MAX, opt);
 
 	if (handle)
-		fprintf(f, "handle 0x%x ", handle);
+		print_uint(PRINT_ANY, "handle", "handle 0x%x ", handle);
 
 	if (tb[TCA_BASIC_CLASSID]) {
 		SPRINT_BUF(b1);
diff --git a/tc/m_ematch.c b/tc/m_ematch.c
index 8840a0dc..eee3819f 100644
--- a/tc/m_ematch.c
+++ b/tc/m_ematch.c
@@ -408,7 +408,7 @@ static int print_ematch_seq(FILE *fd, struct rtattr **tb, int start,
 		hdr = RTA_DATA(tb[i]);
 
 		if (hdr->flags & TCF_EM_INVERT)
-			fprintf(fd, "NOT ");
+			print_raw_string(PRINT_ANY, NULL, "NOT ", NULL);
 
 		if (hdr->kind == 0) {
 			__u32 ref;
@@ -417,14 +417,15 @@ static int print_ematch_seq(FILE *fd, struct rtattr **tb, int start,
 				return -1;
 
 			ref = *(__u32 *) data;
-			fprintf(fd, "(\n");
+			print_raw_string(PRINT_ANY, NULL, "(", NULL);
+			print_string(PRINT_FP, NULL, "\n", NULL);
 			for (n = 0; n <= prefix; n++)
-				fprintf(fd, "  ");
+				print_string(PRINT_FP, NULL, "  ", NULL);
 			if (print_ematch_seq(fd, tb, ref + 1, prefix + 1) < 0)
 				return -1;
 			for (n = 0; n < prefix; n++)
-				fprintf(fd, "  ");
-			fprintf(fd, ") ");
+				print_string(PRINT_FP, NULL, "  ", NULL);
+			print_raw_string(PRINT_ANY, NULL, ") ", NULL);
 
 		} else {
 			struct ematch_util *e;
@@ -437,20 +438,21 @@ static int print_ematch_seq(FILE *fd, struct rtattr **tb, int start,
 				fprintf(fd, "%s(", e->kind);
 				if (e->print_eopt(fd, hdr, data, dlen) < 0)
 					return -1;
-				fprintf(fd, ")\n");
+				print_raw_string(PRINT_ANY, NULL, ")", NULL);
+				print_string(PRINT_FP, NULL, "\n", NULL);
 			}
 			if (hdr->flags & TCF_EM_REL_MASK)
 				for (n = 0; n < prefix; n++)
-					fprintf(fd, "  ");
+					print_string(PRINT_FP, NULL, "  ", NULL);
 		}
 
 		switch (hdr->flags & TCF_EM_REL_MASK) {
 			case TCF_EM_REL_AND:
-				fprintf(fd, "AND ");
+				print_raw_string(PRINT_ANY, NULL, "AND ", NULL);
 				break;
 
 			case TCF_EM_REL_OR:
-				fprintf(fd, "OR ");
+				print_raw_string(PRINT_ANY, NULL, "OR ", NULL);
 				break;
 
 			default:
@@ -477,9 +479,13 @@ static int print_ematch_list(FILE *fd, struct tcf_ematch_tree_hdr *hdr,
 		if (parse_rtattr_nested(tb, hdr->nmatches, rta) < 0)
 			goto errout;
 
-		fprintf(fd, "\n  ");
+		print_string(PRINT_FP, NULL, "\n  ", NULL);
+		print_string(PRINT_JSON, "ematch", NULL, NULL);
+		print_raw_string(PRINT_JSON, NULL, "\"", NULL);
 		if (print_ematch_seq(fd, tb, 1, 1) < 0)
 			goto errout;
+
+		print_raw_string(PRINT_JSON, NULL, "\",", NULL);
 	}
 
 	err = 0;
-- 
2.24.1 (Apple Git-126)

