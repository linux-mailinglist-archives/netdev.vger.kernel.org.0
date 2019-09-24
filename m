Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D04D2BD4F3
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 00:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410516AbfIXWdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 18:33:10 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43551 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389629AbfIXWdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 18:33:09 -0400
Received: by mail-wr1-f65.google.com with SMTP id q17so3868800wrx.10
        for <netdev@vger.kernel.org>; Tue, 24 Sep 2019 15:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F9W9Sf9x09mCcY56UsI7MWAgHYX1InqA2G+AXTijS0I=;
        b=K6l4pZFNEFo1pwJATU+fxUyse7xlniDO2MGR1frrYNdUpYg14YiNrh2OEcuzHw81IY
         PtQYIbYj/HAbwpy0SSJuqKH4T7e2mRD26WoCmpll8qmHwXrRdZQ+ZY+y2xoEpVdgCMaD
         StLWDvHr9oN5Jwx8u25S+CnHZdUUoGS1rqxFI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F9W9Sf9x09mCcY56UsI7MWAgHYX1InqA2G+AXTijS0I=;
        b=nSaA9caf+GMxt2p6AZ6Llk/FES7cT3faH12hJjX3tNvA5cDmi7RSmJOhHr04ivmdxE
         m3nBzdawoORGbSuAFMKsqh0wveUaMpysE95DLU0gJVrEicaSBDozpnHwIJDYeYTWYBAu
         OSEIEI7jE9UMlry8Z9mF6BAxYB22WWs44GAwlXI5UfkYDw3FfEUmRi8qz54u0AWwrDcC
         Fu+AX6KV8LxvBG76u/G1qqnqs59iM1qUQjepPocCyTUo5lPBbbawwbUGgszFatAP7Mgx
         CL5bX3A1yQyNfVPK9Ij10wKZ8ZgHSo0TsGDif6uIHtGzMn3yPRnirc3+2q+S6xzLILYv
         pBpw==
X-Gm-Message-State: APjAAAWKDCOvyxioyf4wAcNXnJl/PEB5bUpvdH6H88O+xcr7bo2kN04F
        sl/i7BzPC1KC0BbLaHNSp0j8EmUoyMC77So=
X-Google-Smtp-Source: APXvYqzipFB0UVC+ZQV6tb9MrCK6/V7a9ysRucVPK2r1Y17dxq8ThzBLHySFMzNf+bj8s+dKc26uGw==
X-Received: by 2002:adf:9029:: with SMTP id h38mr4974265wrh.155.1569364387549;
        Tue, 24 Sep 2019 15:33:07 -0700 (PDT)
Received: from localhost.localdomain (ip-213-127-82-26.ip.prioritytelecom.net. [213.127.82.26])
        by smtp.googlemail.com with ESMTPSA id x6sm1548991wmf.35.2019.09.24.15.33.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 24 Sep 2019 15:33:06 -0700 (PDT)
From:   Julien Fortin <julien@cumulusnetworks.com>
X-Google-Original-From: Julien Fortin
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com,
        Julien Fortin <julien@cumulusnetworks.com>
Subject: [PATCH iproute2(-next) 1/1] ip: fix ip route show json output for multipath nexthops
Date:   Wed, 25 Sep 2019 00:32:56 +0200
Message-Id: <20190924223256.74017-1-julien@cumulusnetworks.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julien Fortin <julien@cumulusnetworks.com>

print_rta_multipath doesn't support JSON output:

{
    "dst":"27.0.0.13",
    "protocol":"bgp",
    "metric":20,
    "flags":[],
    "gateway":"169.254.0.1"dev uplink-1 weight 1 ,
    "flags":["onlink"],
    "gateway":"169.254.0.1"dev uplink-2 weight 1 ,
    "flags":["onlink"]
},

since RTA_MULTIPATH has nested objects we should print them
in a json array.

With the path we have the following output:

{
    "flags": [],
    "dst": "36.0.0.13",
    "protocol": "bgp",
    "metric": 20,
    "nexthops": [
        {
	    "weight": 1,
	    "flags": [
	        "onlink"
	    ],
	    "gateway": "169.254.0.1",
	    "dev": "uplink-1"
        },
	{
	    "weight": 1,
	    "flags": [
	        "onlink"
            ],
	    "gateway": "169.254.0.1",
	    "dev": "uplink-2"
        }
    ]
}

Fixes: 663c3cb23103f4 ("iproute: implement JSON and color output")

Signed-off-by: Julien Fortin <julien@cumulusnetworks.com>
---
 ip/iproute.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/ip/iproute.c b/ip/iproute.c
index a4533851..5d5f1551 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -649,23 +649,27 @@ static void print_rta_multipath(FILE *fp, const struct rtmsg *r,
 	int len = RTA_PAYLOAD(rta);
 	int first = 1;
 
+	open_json_array(PRINT_JSON, "nexthops");
+
 	while (len >= sizeof(*nh)) {
 		struct rtattr *tb[RTA_MAX + 1];
 
 		if (nh->rtnh_len > len)
 			break;
 
+		open_json_object(NULL);
+
 		if (!is_json_context()) {
 			if ((r->rtm_flags & RTM_F_CLONED) &&
 			    r->rtm_type == RTN_MULTICAST) {
 				if (first) {
-					fprintf(fp, "Oifs: ");
+					print_string(PRINT_FP, NULL, "Oifs: ", NULL);
 					first = 0;
 				} else {
-					fprintf(fp, " ");
+					print_string(PRINT_FP, NULL, " ", NULL);
 				}
 			} else
-				fprintf(fp, "%s\tnexthop ", _SL_);
+				print_string(PRINT_FP, NULL, "%s\tnexthop ", _SL_);
 		}
 
 		if (nh->rtnh_len > sizeof(*nh)) {
@@ -689,22 +693,30 @@ static void print_rta_multipath(FILE *fp, const struct rtmsg *r,
 
 		if ((r->rtm_flags & RTM_F_CLONED) &&
 		    r->rtm_type == RTN_MULTICAST) {
-			fprintf(fp, "%s", ll_index_to_name(nh->rtnh_ifindex));
+			print_string(PRINT_ANY, "dev",
+				     "%s", ll_index_to_name(nh->rtnh_ifindex));
+
 			if (nh->rtnh_hops != 1)
-				fprintf(fp, "(ttl>%d)", nh->rtnh_hops);
-			fprintf(fp, " ");
+				print_int(PRINT_ANY, "ttl", "(ttl>%d)", nh->rtnh_hops);
+
+			print_string(PRINT_FP, NULL, " ", NULL);
 		} else {
-			fprintf(fp, "dev %s ", ll_index_to_name(nh->rtnh_ifindex));
+			print_string(PRINT_ANY, "dev",
+				     "dev %s ", ll_index_to_name(nh->rtnh_ifindex));
+
 			if (r->rtm_family != AF_MPLS)
-				fprintf(fp, "weight %d ",
-					nh->rtnh_hops+1);
+				print_int(PRINT_ANY, "weight",
+					  "weight %d ", nh->rtnh_hops + 1);
 		}
 
 		print_rt_flags(fp, nh->rtnh_flags);
 
 		len -= NLMSG_ALIGN(nh->rtnh_len);
 		nh = RTNH_NEXT(nh);
+
+		close_json_object();
 	}
+	close_json_array(PRINT_JSON, NULL);
 }
 
 int print_route(struct nlmsghdr *n, void *arg)
-- 
2.23.0

