Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83A2916C1D8
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 14:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730080AbgBYNMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 08:12:22 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36184 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgBYNMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 08:12:21 -0500
Received: by mail-qt1-f193.google.com with SMTP id t13so8997748qto.3
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 05:12:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Djv9wBfjM4gpnB4Ig0SaRJ9BZe0bnLt6HxT50dqWLJ4=;
        b=L0i37Q+A3hLDzTziDgQquk5VvPpE430iogJbcC4DNHNsudLOLtFgeSG8CpFdNLRJLg
         9pveRjAUrVNpB3aI1li03SzvJ1ZAGR7HOBeqqIMCSYeV2kP7/gMRoTpnu5RU2lKV+cb2
         teRqr2MFQkb4jqz+FQgD+y79aGgKLPz50+HWU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Djv9wBfjM4gpnB4Ig0SaRJ9BZe0bnLt6HxT50dqWLJ4=;
        b=RtVmZPNK8UUvI26M7h+mIoKuDmP+QxEAh5qnwUOssni3Yec9/zixVmJRmuJ354ZLAx
         5L9jX2Ld4U+pA4n077oj3+lMtYdXl8UX5Y4ZJ6AAvzcvMyEw55et+DglS22PZdbp/M6n
         Glj4c4o4z4MMoUQVQxUMawB2aetY6tKIJ1iyV7Bqqf/zstWskP/5gnjbcIHL4L2V2Iez
         wDV0HaQM9a60HLe0cjCF1TXPMYd8pw3PNt+G6qrCSY3werFGCsXakU7qRFJ2FHThClyF
         EcoX7UxOtWj+YR/0WwkYZ17bekaOUjSp/gbbq3JRiw7CXf8bmS6TepwURExAi5FshyUL
         OquA==
X-Gm-Message-State: APjAAAWDgFMzBRZEDYLpCXnb0RKuoP2z55xm4HZoFXdlMGT197ifPf8t
        7hfukeIvuZyHVw5ZSX4QLJ6a/vplzok=
X-Google-Smtp-Source: APXvYqwU0f3KP3wHKNhOS1PzWtqoONLyCiIV+c/NjhFETJJGBPp/zq23kn8BTJSb9dvnZQ/4SjAQ2g==
X-Received: by 2002:ac8:6697:: with SMTP id d23mr54053129qtp.235.1582636340435;
        Tue, 25 Feb 2020 05:12:20 -0800 (PST)
Received: from eva.nc.rr.com (2606-a000-111d-8179-5cf6-c36e-6f10-b31d.inf6.spectrum.com. [2606:a000:111d:8179:5cf6:c36e:6f10:b31d])
        by smtp.googlemail.com with ESMTPSA id 133sm334759qkh.109.2020.02.25.05.12.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 05:12:19 -0800 (PST)
From:   Donald Sharp <sharpd@cumulusnetworks.com>
To:     netdev@vger.kernel.org, dsahern@kernel.org,
        roopa@cumulusnetworks.com
Subject: [PATCH] ip route: Do not imply pref and ttl-propagate are per nexthop
Date:   Tue, 25 Feb 2020 08:12:13 -0500
Message-Id: <20200225131213.2709230-1-sharpd@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently `ip -6 route show` gives us this output:

sharpd@eva ~/i/ip (master)> ip -6 route show
::1 dev lo proto kernel metric 256 pref medium
4:5::6:7 nhid 18 proto static metric 20
        nexthop via fe80::99 dev enp39s0 weight 1
        nexthop via fe80::44 dev enp39s0 weight 1 pref medium

Displaying `pref medium` as the last bit of output implies
that the RTA_PREF is a per nexthop value, when it is infact
a per route piece of data.

Change the output to display RTA_PREF and RTA_TTL_PROPAGATE
before the RTA_MULTIPATH data is shown:

sharpd@eva ~/i/ip (master)> ./ip -6 route show
::1 dev lo proto kernel metric 256 pref medium
4:5::6:7 nhid 18 proto static metric 20 pref medium
        nexthop via fe80::99 dev enp39s0 weight 1
        nexthop via fe80::44 dev enp39s0 weight 1

Signed-off-by: Donald Sharp <sharpd@cumulusnetworks.com>
---
 ip/iproute.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/ip/iproute.c b/ip/iproute.c
index 93b805c9..07c45169 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -933,9 +933,6 @@ int print_route(struct nlmsghdr *n, void *arg)
 	if (tb[RTA_IIF] && filter.iifmask != -1)
 		print_rta_if(fp, tb[RTA_IIF], "iif");
 
-	if (tb[RTA_MULTIPATH])
-		print_rta_multipath(fp, r, tb[RTA_MULTIPATH]);
-
 	if (tb[RTA_PREF])
 		print_rt_pref(fp, rta_getattr_u8(tb[RTA_PREF]));
 
@@ -951,6 +948,14 @@ int print_route(struct nlmsghdr *n, void *arg)
 				     propagate ? "enabled" : "disabled");
 	}
 
+	if (tb[RTA_MULTIPATH])
+		print_rta_multipath(fp, r, tb[RTA_MULTIPATH]);
+
+	/* If you are adding new route RTA_XXXX then place it above
+	 * the RTA_MULTIPATH else it will appear that the last nexthop
+	 * in the ECMP has new attributes
+	 */
+
 	print_string(PRINT_FP, NULL, "\n", NULL);
 	close_json_object();
 	fflush(fp);
-- 
2.25.0

