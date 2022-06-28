Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8586255E090
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345761AbiF1M2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 08:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345736AbiF1M2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 08:28:18 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC265175AC;
        Tue, 28 Jun 2022 05:28:09 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LXP4F0H3Tz689Py;
        Tue, 28 Jun 2022 20:27:25 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 28 Jun 2022 14:28:07 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kpsingh@kernel.org>, <john.fastabend@gmail.com>,
        <songliubraving@fb.com>, <kafai@fb.com>, <yhs@fb.com>,
        <dhowells@redhat.com>
CC:     <keyrings@vger.kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v6 3/5] scripts: Handle unsigned type prefix in bpf_doc.py
Date:   Tue, 28 Jun 2022 14:27:48 +0200
Message-ID: <20220628122750.1895107-4-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220628122750.1895107-1-roberto.sassu@huawei.com>
References: <20220628122750.1895107-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml751-chm.china.huawei.com (10.201.108.201) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While unsigned long is an accepted parameter type, the regular expression
validating helper prototypes does not correctly take into account types
composed by multiple words.

The regular expression:

((const )?(struct )?(\w+|\.\.\.)( \**\w+)?)

accepts only const and struct as prefix before the type. The following part
of the regular expression expects a word with [a-zA-Z0-9_] characters
(without space), so it would get just unsigned. Parsing words with \w+ in
greedy mode makes the regular expression work even if the type is composed
by two words, but not always. It wouldn't have been the case in possessive
mode \w++ (don't give back characters to match the regular expression).

Simply adding unsigned as possible prefix is not correct, as the struct
unsigned combination is not legal. Make instead struct and unsigned as
alternatives, so that the following new combinations are legal:

unsigned type
struct type
const unsigned type

and not:

struct unsigned type

The regular expression is a preliminary check. The type, other than being
legal, must be also present in the known_types array.

Don't mention the change in the regular expression description, as it is
assumed that type implies also multiple words types.

At this point, don't switch from greedy to possessive mode (\w+ -> \w++) to
avoid partial parsing of the type of helper parameters, as this
functionality has only been added recently in Python 3.11.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 scripts/bpf_doc.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/bpf_doc.py b/scripts/bpf_doc.py
index a0ec321469bd..25e79d811487 100755
--- a/scripts/bpf_doc.py
+++ b/scripts/bpf_doc.py
@@ -124,7 +124,7 @@ class HeaderParser(object):
         #   - Same as above, with "const" and/or "struct" in front of type
         #   - "..." (undefined number of arguments, for bpf_trace_printk())
         # There is at least one term ("void"), and at most five arguments.
-        p = re.compile(' \* ?((.+) \**\w+\((((const )?(struct )?(\w+|\.\.\.)( \**\w+)?)(, )?){1,5}\))$')
+        p = re.compile(' \* ?((.+) \**\w+\((((const )?((struct )|(unsigned )?)(\w+|\.\.\.)( \**\w+)?)(, )?){1,5}\))$')
         capture = p.match(self.line)
         if not capture:
             raise NoHelperFound
-- 
2.25.1

