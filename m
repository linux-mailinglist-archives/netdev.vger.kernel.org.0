Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5149496400
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 18:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380551AbiAURf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 12:35:26 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:33773 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351773AbiAURfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 12:35:24 -0500
Received: from localhost.localdomain (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 1D9EC2012377;
        Fri, 21 Jan 2022 18:35:20 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 1D9EC2012377
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1642786520;
        bh=uMUn33AjoBSgP0OMagGEKSsNaHK41vbeEd+My58eauk=;
        h=From:To:Cc:Subject:Date:From;
        b=kBJCgUtViokDP5yHFs4oRUq48O3m600acX2x1StbubR84yHum2Sg9aDKv7fTVqV9B
         05QNhd/JGwgLHPYm9jPd7+R3UPc6ETg6g58tHoUD/jI8Tq8q+IfGx/oJFdoYVAlttq
         oe3cYUFNVe95Njz+eh/E343hazVV5R2nH+juVltD1J4i+9diyHGwKbmj8IHbQ1TDSs
         5RjLFfUzZgInKUdcLrZZLzgy0p3MqeY5gt2WeiCy7SGZ/7rfpBsQZjhej+Fuu+6utE
         QsUUCQ8914/0XApgeUFLsTFvVVFCs5DaZlQ3hNrfz3YwT3AyedAn2lFNZYWeRxrLVL
         4OSkGr7Kjptzg==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        oliver.sang@intel.com, idosch@nvidia.com, lkp@lists.01.org,
        lkp@intel.com, justin.iurman@uliege.be
Subject: [PATCH net] selftests: net: ioam: Fixes b63c5478e9
Date:   Fri, 21 Jan 2022 18:34:49 +0100
Message-Id: <20220121173449.26918-1-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IOAM queue-depth data field was added a few weeks ago, but the test unit
was not updated accordingly. Here is the fix, thanks for the report.

Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 tools/testing/selftests/net/ioam6_parser.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/ioam6_parser.c b/tools/testing/selftests/net/ioam6_parser.c
index 8f6997d35816..d9d1d4190126 100644
--- a/tools/testing/selftests/net/ioam6_parser.c
+++ b/tools/testing/selftests/net/ioam6_parser.c
@@ -240,11 +240,8 @@ static int check_ioam6_data(__u8 **p, struct ioam6_trace_hdr *ioam6h,
 		*p += sizeof(__u32);
 	}
 
-	if (ioam6h->type.bit6) {
-		if (__be32_to_cpu(*((__u32 *)*p)) != 0xffffffff)
-			return 1;
+	if (ioam6h->type.bit6)
 		*p += sizeof(__u32);
-	}
 
 	if (ioam6h->type.bit7) {
 		if (__be32_to_cpu(*((__u32 *)*p)) != 0xffffffff)
-- 
2.25.1

