Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA662F890F
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 00:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbhAOXAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 18:00:49 -0500
Received: from mail-pf1-f177.google.com ([209.85.210.177]:46554 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbhAOXAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 18:00:48 -0500
Received: by mail-pf1-f177.google.com with SMTP id w2so6403533pfc.13
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 15:00:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FZQ5OheRPhYN4juPpx9IAVBr+cHSYvSlewu5bXHdzeA=;
        b=RRIkuadUS+WGr6VMR1vrCUn0eWWzZA9vEfE6BIzPlEuNU0UsioIP5pEMsQWtrlYw+9
         TwRh/d27Avk+iFb4w3Yn5ljogJbNRtyCiudtxSAt5fDZiQdrUdZwZ7j+1H1T5nNNcxo9
         t6wSLLImsu9Xmh33SXGcNMV6Y/97uV3XDSdeKhCVl3x4jpJlk08OM9s4DqylOTDnzLcX
         mcntd7L93tcGX7Mmx0ghxtcy7GGxy32e5CBpaMvrU76qEWUBp4hy4/ha14empcnwfLt6
         uEt75XJu7yR7jFNF9xkdhABfH2phLHdmDI97G0MpUYK+Q6u/xg3iweySLjGCtJESr8Df
         s7sw==
X-Gm-Message-State: AOAM530l5VTFHVK9z2NGhhR+CrNAx19aCEMA4Vb1nWsEp3faxqOvLklO
        3HjLOfASQOymk2Y3B81oHTa5QOKXr81gHA==
X-Google-Smtp-Source: ABdhPJxGr/GUUtsVVamUohM50i1tQcrMieabXn6SI5bnq0xSMb0lgwkg/jzaDDqM7hXdynYv9JoVHA==
X-Received: by 2002:a63:521e:: with SMTP id g30mr14757844pgb.369.1610751606962;
        Fri, 15 Jan 2021 15:00:06 -0800 (PST)
Received: from hex.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h1sm9534259pgj.59.2021.01.15.15.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 15:00:06 -0800 (PST)
From:   Edwin Peer <edwin.peer@broadcom.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Edwin Peer <edwin.peer@broadcom.com>
Subject: [PATCH iproute2] iplink: work around rtattr length limits for IFLA_VFINFO_LIST
Date:   Fri, 15 Jan 2021 14:59:50 -0800
Message-Id: <20210115225950.18762-1-edwin.peer@broadcom.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The maximum possible length of an RTNL attribute is 64KB, but the
nested VFINFO list exceeds this for more than about 220 VFs (each VF
consumes approximately 300 bytes, depending on alignment and optional
fields). Exceeding the limit causes IFLA_VFINFO_LIST's length to wrap
modulo 16 bits in the kernel's nla_nest_end().

This patch is a horrible hack exploiting the fact that the full set
of attributes is actually present in the netlink packet, even though
the published length of the nested rtattr may be considerably shorter.
The total number of VFs is known, however, and can instead be used as
the basis for the iteration over the VFINFO list.

As ugly as this solution is, it does appear to be a reasonable and
practical compromise selected from a number of alternate approaches
that were considered and deemed worse or otherwise unworkable:

  - Extending the apparent maximum length of rtattr:

  To do this is a way that maintains ABI compatibility is easier said
  than done. Pushing the nested contents through deflate in response to
  a special request filter flag so that the data still fits within the
  64KB limit was considered (not entirely as crazy as this first sounds
  because there is a lot of redundancy in the data that would definitely
  compress well) as well as approaches based on providing new attribute
  types to pair with ATTR_TYPE_NESTED that extend its length in various
  ways (such as a "more" attribute or an extended attribute header with
  a wider length type). Ultimately these length extension ideas were
  rejected because the client parser APIs are expressed in terms of the
  base rtattr type, which cannot be extended cleanly without tacking on
  kludgy helpers or otherwise conducting major rework of client APIs.

  - Filtering based approaches:

  An obvious idea is to reduce the amount of data actually sent using
  filters. For example, by extending RTEXT_FILTER_SKIP_STATS to the VF
  stats, which make up a large proportion of the dump. But, the problem
  arises when it is the stats that are desired. One now either has to
  filter by VF when requesting full resolution data (ie. fetch each VF
  separately) or one has to pick another subset of fields to exclude
  and stitch the results together in the client. But, the requests are
  not atomic and the VF configuration could have changed in the interim.
  This may be less of a concern when requesting a VF's entire data as
  a whole (at least the data would necessarily apply to the same VF),
  but even so there would then need to be a mechanism to select only
  the VFINFO of interest, which is particularly messy given that we're
  not requesting a top level object here and would involve extensions
  to an otherwise frozen VF query API (and still not be atomic).

  - API redesign:

  The clean solution is to decompose the API into smaller granularity
  requests and otherwise rethink the structure of netlink attributes in
  a V2 RTM_GETLINK redesign. Such ideas are all moot, however, because
  VF config has been punted to switchdev and any new work should happen
  there instead.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
---
 ip/ipaddress.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 571346b15cc3..3be61f49204c 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -1198,13 +1198,13 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
 	}
 
 	if ((do_link || show_details) && tb[IFLA_VFINFO_LIST] && tb[IFLA_NUM_VF]) {
-		struct rtattr *i, *vflist = tb[IFLA_VFINFO_LIST];
-		int rem = RTA_PAYLOAD(vflist);
+		struct rtattr *vf = RTA_DATA(tb[IFLA_VFINFO_LIST]);
+		int i, ignore = 0, num_vf = rta_getattr_u32(tb[IFLA_NUM_VF]);
 
 		open_json_array(PRINT_JSON, "vfinfo_list");
-		for (i = RTA_DATA(vflist); RTA_OK(i, rem); i = RTA_NEXT(i, rem)) {
+		for (i = 0; i < num_vf; vf = RTA_NEXT(vf, ignore), i++) {
 			open_json_object(NULL);
-			print_vfinfo(fp, ifi, i);
+			print_vfinfo(fp, ifi, vf);
 			close_json_object();
 		}
 		close_json_array(PRINT_JSON, NULL);
@@ -2157,22 +2157,20 @@ out:
 static void
 ipaddr_loop_each_vf(struct rtattr *tb[], int vfnum, int *min, int *max)
 {
-	struct rtattr *vflist = tb[IFLA_VFINFO_LIST];
-	struct rtattr *i, *vf[IFLA_VF_MAX+1];
+	int i, ignore = 0, num_vf = rta_getattr_u32(tb[IFLA_NUM_VF]);
+	struct rtattr *vf = RTA_DATA(tb[IFLA_VFINFO_LIST]);
+	struct rtattr *vf_tb[IFLA_VF_MAX+1];
 	struct ifla_vf_rate *vf_rate;
-	int rem;
 
-	rem = RTA_PAYLOAD(vflist);
+	for (i = 0; i < num_vf; vf = RTA_NEXT(vf, ignore), i++) {
+		parse_rtattr_nested(vf_tb, IFLA_VF_MAX, vf);
 
-	for (i = RTA_DATA(vflist); RTA_OK(i, rem); i = RTA_NEXT(i, rem)) {
-		parse_rtattr_nested(vf, IFLA_VF_MAX, i);
-
-		if (!vf[IFLA_VF_RATE]) {
+		if (!vf_tb[IFLA_VF_RATE]) {
 			fprintf(stderr, "VF min/max rate API not supported\n");
 			exit(1);
 		}
 
-		vf_rate = RTA_DATA(vf[IFLA_VF_RATE]);
+		vf_rate = RTA_DATA(vf_tb[IFLA_VF_RATE]);
 		if (vf_rate->vf == vfnum) {
 			*min = vf_rate->min_tx_rate;
 			*max = vf_rate->max_tx_rate;
-- 
2.30.0

