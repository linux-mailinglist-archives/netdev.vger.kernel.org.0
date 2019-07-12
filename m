Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05BAF675CC
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 22:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727584AbfGLUSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 16:18:17 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36938 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbfGLUSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 16:18:17 -0400
Received: by mail-pl1-f195.google.com with SMTP id b3so5284304plr.4
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 13:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R4zB8vgMBUTW2ln8XvPODiDL/1gjRsfa5CzHgNFgLLc=;
        b=hc/fMojfL485UP5oK6ZmEcgy5DDOTx2OITY2WtFRdfSx4QkpPkrf2h0FxSskIcBLXt
         RH2kvqlIL3b88ddq5XcdEoNVoDAfhw0OY+XwZ+TPi2v53OYz1TPsA+4Z3utc5x/K+/sA
         4wkXYi0dMpxRa6ug7d7SZXKVfdirxrdMST50eP0KY7smPlqylMBIV+FiLJh8AfdzyOrO
         1+/+eS0BVKnfFecneNWcekVKjOEeL1i+D0gYRtJWiSKQSCipio3iflm9ifLUsmB8PIBu
         ka1WOXu8AHCPAs5089/2X0xpTQGI+lCEARRbO6YTs4Two7TAL6xw+eRNoElpGpSdssEF
         Te7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R4zB8vgMBUTW2ln8XvPODiDL/1gjRsfa5CzHgNFgLLc=;
        b=o9rLPdHxf5NqIYk/nmzbbjMSFRPt0vSDkZn1tyhYbIUCzmubXzsRqmAj2de0mnL6Do
         lhyXmhp4m826dPT8anvI7+UHCQz3EG7W8frJAi1d/+Ju53dCuSEizYpmt523p/pYZZCX
         T/0KZXCwGJouOiq8N6bfRJQOV2jT3xpVh0GfgBjUWly4g5IZrCyo2n8+jAm+Lu2zK1p1
         ppJM4TTsl2suxn/sQJa0zJdTQ/T4wTsAgu9oykZvtK0j6CIxD/5IhCDw+kcZkfGtIc0f
         7Ks+zyPkUxNne0Y5PIyzOkPuWmIb3i9ZUUCMkmE5nNx9oWBu5OK2hKSHYJWsbEMEtO/W
         1URQ==
X-Gm-Message-State: APjAAAV+2OTJ/JcOriyalFTIEjU5+FU/ELFfA56wx4vzmLtDJstQN6PM
        OOVp5dtYzbEOizOCJwmysJIMoHf/xQk=
X-Google-Smtp-Source: APXvYqxXLSSRnMmlqj0C7em4BEfe/ZBYDXB7pQ51riWMfFS0Q/G8F+xAvW8VYYgCHjB7fc+x7l2SBA==
X-Received: by 2002:a17:902:3181:: with SMTP id x1mr13561367plb.135.1562962696138;
        Fri, 12 Jul 2019 13:18:16 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id q4sm8883630pjq.27.2019.07.12.13.18.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 12 Jul 2019 13:18:14 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, Julian Anastasov <ja@ssi.bg>,
        David Ahern <dsahern@gmail.com>
Subject: [Patch net] fib: relax source validation check for loopback packets
Date:   Fri, 12 Jul 2019 13:17:49 -0700
Message-Id: <20190712201749.28421-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a rare case where we redirect local packets from veth to lo,
these packets fail to pass the source validation when rp_filter
is turned on, as the tracing shows:

  <...>-311708 [040] ..s1 7951180.957825: fib_table_lookup: table 254 oif 0 iif 1 src 10.53.180.130 dst 10.53.180.130 tos 0 scope 0 flags 0
  <...>-311708 [040] ..s1 7951180.957826: fib_table_lookup_nh: nexthop dev eth0 oif 4 src 10.53.180.130

So, the fib table lookup returns eth0 as the nexthop even though
the packets are local and should be routed to loopback nonetheless,
but they can't pass the dev match check in fib_info_nh_uses_dev().

It should be safe to relax this check for this special case, as
normally packets coming out of loopback device still have skb_dst
so they won't even hit this slow path.

Cc: Julian Anastasov <ja@ssi.bg>
Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/ipv4/fib_frontend.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 317339cd7f03..8662a44a28f9 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -388,6 +388,12 @@ static int __fib_validate_source(struct sk_buff *skb, __be32 src, __be32 dst,
 	fib_combine_itag(itag, &res);
 
 	dev_match = fib_info_nh_uses_dev(res.fi, dev);
+	/* This is rare, loopback packets retain skb_dst so normally they
+	 * would not even hit this slow path.
+	 */
+	dev_match = dev_match || (res.type == RTN_LOCAL &&
+				  dev == net->loopback_dev &&
+				  IN_DEV_ACCEPT_LOCAL(idev));
 	if (dev_match) {
 		ret = FIB_RES_NHC(res)->nhc_scope >= RT_SCOPE_HOST;
 		return ret;
-- 
2.21.0

