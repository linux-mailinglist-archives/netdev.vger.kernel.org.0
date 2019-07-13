Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82FCA67984
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 11:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbfGMJnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jul 2019 05:43:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36386 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726626AbfGMJnd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Jul 2019 05:43:33 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9B60C88313;
        Sat, 13 Jul 2019 09:43:33 +0000 (UTC)
Received: from renaissance-vector.redhat.com (ovpn-116-49.ams2.redhat.com [10.36.116.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7636E60C4D;
        Sat, 13 Jul 2019 09:43:32 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org
Subject: [PATCH iproute2] tc: util: constrain percentage in 0-100 interval
Date:   Sat, 13 Jul 2019 11:44:07 +0200
Message-Id: <c0a9b4ce15d5389ac59fbf572f5f1b3030ec4c90.1563011008.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Sat, 13 Jul 2019 09:43:33 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

parse_percent() currently allows to specify negative percentages
or value above 100%. However this does not seems to make sense,
as the function is used for probabilities or bandiwidth rates.

Moreover, using negative values leads to erroneous results
(using Bernoulli loss model as example):

$ ip link add test type dummy
$ ip link set test up
$ tc qdisc add dev test root netem loss gemodel -10% limit 10
$ tc qdisc show dev test
qdisc netem 800c: root refcnt 2 limit 10 loss gemodel p 90% r 10% 1-h 100% 1-k 0%

Using values above 100% we have instead:

$ ip link add test type dummy
$ ip link set test up
$ tc qdisc add dev test root netem loss gemodel 140% limit 10
$ tc qdisc show dev test
qdisc netem 800f: root refcnt 2 limit 10 loss gemodel p 40% r 60% 1-h 100% 1-k 0%

This commit changes parse_percent() with a check to ensure
percentage values stay between 1.0 and 0.0.
parse_percent_rate() function, which already employs a similar
check, is adjusted accordingly.

With this check in place, we have:

$ ip link add test type dummy
$ ip link set test up
$ tc qdisc add dev test root netem loss gemodel -10% limit 10
Illegal "loss gemodel p"

Fixes: 927e3cfb52b58 ("tc: B.W limits can now be specified in %.")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 tc/tc_util.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/tc/tc_util.c b/tc/tc_util.c
index 53d15e08e9734..b90d256c33a4a 100644
--- a/tc/tc_util.c
+++ b/tc/tc_util.c
@@ -198,7 +198,7 @@ int parse_percent(double *val, const char *str)
 	char *p;
 
 	*val = strtod(str, &p) / 100.;
-	if (*val == HUGE_VALF || *val == HUGE_VALL)
+	if (*val > 1.0 || *val < 0.0)
 		return 1;
 	if (*p && strcmp(p, "%"))
 		return -1;
@@ -226,16 +226,16 @@ static int parse_percent_rate(char *rate, size_t len,
 	if (ret != 1)
 		goto malf;
 
-	if (parse_percent(&perc, str_perc))
+	ret = parse_percent(&perc, str_perc);
+	if (ret == 1) {
+		fprintf(stderr, "Invalid rate specified; should be between [0,100]%% but is %s\n", str);
+		goto err;
+	} else if (ret == -1) {
 		goto malf;
+	}
 
 	free(str_perc);
 
-	if (perc > 1.0 || perc < 0.0) {
-		fprintf(stderr, "Invalid rate specified; should be between [0,100]%% but is %s\n", str);
-		return -1;
-	}
-
 	rate_bit = perc * dev_mbit * 1000 * 1000;
 
 	ret = snprintf(rate, len, "%lf", rate_bit);
@@ -247,8 +247,9 @@ static int parse_percent_rate(char *rate, size_t len,
 	return 0;
 
 malf:
-	free(str_perc);
 	fprintf(stderr, "Specified rate value could not be read or is malformed\n");
+err:
+	free(str_perc);
 	return -1;
 }
 
-- 
2.20.1

