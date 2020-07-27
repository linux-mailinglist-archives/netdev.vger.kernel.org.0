Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB6D22FC70
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbgG0Wpa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 27 Jul 2020 18:45:30 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19660 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726846AbgG0Wos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 18:44:48 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RMfrVb003687
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:44:47 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32h4ed6t0b-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:44:47 -0700
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 15:44:45 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id B4C3E3FAB6F5B; Mon, 27 Jul 2020 15:44:44 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH v2 01/21] linux/log2.h: enclose macro arg in parens
Date:   Mon, 27 Jul 2020 15:44:24 -0700
Message-ID: <20200727224444.2987641-2-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
References: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_15:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0 clxscore=1034
 suspectscore=1 mlxlogscore=832 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007270153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

roundup_pow_of_two uses its arg without enclosing it in parens.

A call of the form:

   roundup_pow_of_two(boolval ? PAGE_SIZE : frag_size)

resulted in an compile warning:

warning: ?: using integer constants in boolean context [-Wint-in-bool-context]
              PAGE_SIZE :
../include/linux/log2.h:176:4: note: in definition of macro ‘roundup_pow_of_two’
   (n == 1) ? 1 :  \
    ^
And the resulting code used '1' as the result of the operation.

Fixes: 312a0c170945 ("[PATCH] LOG2: Alter roundup_pow_of_two() so that it can use a ilog2() on a constant")

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/log2.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/log2.h b/include/linux/log2.h
index 83a4a3ca3e8a..c619ec6eff4a 100644
--- a/include/linux/log2.h
+++ b/include/linux/log2.h
@@ -173,7 +173,7 @@ unsigned long __rounddown_pow_of_two(unsigned long n)
 #define roundup_pow_of_two(n)			\
 (						\
 	__builtin_constant_p(n) ? (		\
-		(n == 1) ? 1 :			\
+		((n) == 1) ? 1 :		\
 		(1UL << (ilog2((n) - 1) + 1))	\
 				   ) :		\
 	__roundup_pow_of_two(n)			\
-- 
2.24.1

