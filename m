Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 102F22FF7C1
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 23:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbhAUWLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 17:11:03 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:44804 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbhAUWLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 17:11:01 -0500
X-Greylist: delayed 563 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jan 2021 17:10:59 EST
Received: from localhost.localdomain (38.25-200-80.adsl-dyn.isp.belgacom.be [80.200.25.38])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 1F7F9200F4BE;
        Thu, 21 Jan 2021 23:01:03 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 1F7F9200F4BE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1611266463;
        bh=ttrqnaLzi5NM4KopCkahy1OPJPElLcfQpdqz+/sT864=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HIgPk730/c1IhLH7lVpW4CPSo+ikb1Wbaj9olHwHuOfrhbp1SvX76lxjApek9yU/Z
         4/l7gwtEWdbbMOsBon5aQvwsUvNPNgBn4/qn1ryx16V+RugfpzR4xcA8KeUk6ghiOQ
         RUSQW1hdBMit2a24VStF7MhTQJYD2O4N7KvZkjMVZ3nrOH3GdOiIlb2ecXDnV9y1WE
         IgJ963+e+v5npEhhWUsMXhqmc1CTKxEc5/doh4Kud6dAshu9FKvgUWucqOsDe57xoY
         +LRVRlbHHIVJGgEEWvL25UM84flcZb4x1YLohhkovW1sMMWDaKv6oEJGCAHnEq5BJv
         3gfZOYJiv98NA==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, alex.aring@gmail.com,
        Justin Iurman <justin.iurman@uliege.be>
Subject: [PATCH net 1/1] uapi: fix big endian definition of ipv6_rpl_sr_hdr
Date:   Thu, 21 Jan 2021 23:00:44 +0100
Message-Id: <20210121220044.22361-2-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210121220044.22361-1-justin.iurman@uliege.be>
References: <20210121220044.22361-1-justin.iurman@uliege.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following RFC 6554 [1], the current order of fields is wrong for big
endian definition. Indeed, here is how the header looks like:

+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|  Next Header  |  Hdr Ext Len  | Routing Type  | Segments Left |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| CmprI | CmprE |  Pad  |               Reserved                |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

This patch reorders fields so that big endian definition is now correct.

  [1] https://tools.ietf.org/html/rfc6554#section-3

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 include/uapi/linux/rpl.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/rpl.h b/include/uapi/linux/rpl.h
index 1dccb55cf8c6..708adddf9f13 100644
--- a/include/uapi/linux/rpl.h
+++ b/include/uapi/linux/rpl.h
@@ -28,10 +28,10 @@ struct ipv6_rpl_sr_hdr {
 		pad:4,
 		reserved1:16;
 #elif defined(__BIG_ENDIAN_BITFIELD)
-	__u32	reserved:20,
+	__u32	cmpri:4,
+		cmpre:4,
 		pad:4,
-		cmpri:4,
-		cmpre:4;
+		reserved:20;
 #else
 #error  "Please fix <asm/byteorder.h>"
 #endif
-- 
2.17.1

