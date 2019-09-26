Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27FDABF5E7
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 17:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbfIZP3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 11:29:55 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42223 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727216AbfIZP3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 11:29:55 -0400
Received: by mail-pg1-f194.google.com with SMTP id z12so1749395pgp.9
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 08:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3IaQaUaOC7gxNDY3Sjf7KbwOk9VgJTLZwA7QHGUjlm0=;
        b=TQcISXVu41AytbQ5yXE79JJif2u/e0IQVQ8EQ7sftI5Fyl8ohud8iOpejUumV9JFnT
         I9nIhEQcEC8aXjH/Jhu8G+1BPZGrGE5xEoxZsI9Ou3rTi0TY4Bq0T47V7ZAwhQme/pIb
         bRU0pXPoS8zZnDo3Gi+6i4lx92lI6FNWkLrA8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3IaQaUaOC7gxNDY3Sjf7KbwOk9VgJTLZwA7QHGUjlm0=;
        b=Jy0ZMBMnI5Jm4VTPoxnZ5mbVlzMwHt7CXswrIawaoOD4iAPu1TCdw940JZlc2rAPP4
         h8yUBXDoYCmFqEk6G93waqAaG1I2repb0pnh+sxHqKi1QJdLwmglpRpRMC6WTsWQFqF+
         rL67ZOPsnGEdAkqu4/iP+cGZ0T/ih7thUx2UnfnyPYl1WYosKmPmAxAYZQN8mF15VCi+
         r9URTEHaC0Th8NzTALEW9yglYZcPt0QpiZ9h08Lp5CLwh5JNHhEdq5WLRR1uU7Fr5TTa
         tEoG4k0aO6B3aR2bdNjLXgnVylxRWynwdU9+I3ayeDc1bvnCVHcvbrMxX00l1ZY6rvoG
         BnhQ==
X-Gm-Message-State: APjAAAVJJTVS+GKbY0E3ml0lcjOTpX3g6eIRuPp7YNeKEyVpq/usoE+8
        Ubjm9dEyzb3E5ir8G0hefLO2oZpn7GP69Xs=
X-Google-Smtp-Source: APXvYqxK6t4o6ZnKxke/LfpoTv6HY/9D7MnRon3wNhIaRnj3ZjT7oUBQ8yUpvH6mF4aA3yaCVnE9tQ==
X-Received: by 2002:a63:161b:: with SMTP id w27mr3885084pgl.38.1569511793923;
        Thu, 26 Sep 2019 08:29:53 -0700 (PDT)
Received: from localhost.localdomain ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id n6sm2239020pgp.12.2019.09.26.08.29.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 26 Sep 2019 08:29:52 -0700 (PDT)
From:   Julien Fortin <julien@cumulusnetworks.com>
X-Google-Original-From: Julien Fortin
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, dsahern@gmail.com,
        Julien Fortin <julien@cumulusnetworks.com>
Subject: [PATCH iproute2(-next) v2 1/1] ip: fix ip route show json output for multipath nexthops
Date:   Thu, 26 Sep 2019 17:29:34 +0200
Message-Id: <20190926152934.9121-1-julien@cumulusnetworks.com>
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
 ip/iproute.c | 46 ++++++++++++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff --git a/ip/iproute.c b/ip/iproute.c
index a4533851..32bb52df 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -649,24 +649,26 @@ static void print_rta_multipath(FILE *fp, const struct rtmsg *r,
 	int len = RTA_PAYLOAD(rta);
 	int first = 1;
 
+	open_json_array(PRINT_JSON, "nexthops");
+
 	while (len >= sizeof(*nh)) {
 		struct rtattr *tb[RTA_MAX + 1];
 
 		if (nh->rtnh_len > len)
 			break;
 
-		if (!is_json_context()) {
-			if ((r->rtm_flags & RTM_F_CLONED) &&
-			    r->rtm_type == RTN_MULTICAST) {
-				if (first) {
-					fprintf(fp, "Oifs: ");
-					first = 0;
-				} else {
-					fprintf(fp, " ");
-				}
-			} else
-				fprintf(fp, "%s\tnexthop ", _SL_);
-		}
+		open_json_object(NULL);
+
+		if ((r->rtm_flags & RTM_F_CLONED) &&
+		    r->rtm_type == RTN_MULTICAST) {
+			if (first) {
+				print_string(PRINT_FP, NULL, "Oifs: ", NULL);
+				first = 0;
+			} else {
+				print_string(PRINT_FP, NULL, " ", NULL);
+			}
+		} else
+			print_string(PRINT_FP, NULL, "%s\tnexthop ", _SL_);
 
 		if (nh->rtnh_len > sizeof(*nh)) {
 			parse_rtattr(tb, RTA_MAX, RTNH_DATA(nh),
@@ -689,22 +691,30 @@ static void print_rta_multipath(FILE *fp, const struct rtmsg *r,
 
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

