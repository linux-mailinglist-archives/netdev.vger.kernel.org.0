Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 799A66E2F39
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 07:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjDOFtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 01:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjDOFtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 01:49:15 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2905A4EF3
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 22:49:14 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id jg21so50510116ejc.2
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 22:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google; t=1681537752; x=1684129752;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OrHxjozj9Y97lEiYcNHU+1VJEkZJKfJvYo3LQaIdl54=;
        b=Fb7MUrzERZTDIM2m1ox2M5Cpglh5HlkjRbFy8kqmMloPsqIrRUc6QqMEUlKseiY5hj
         qA64609fNkKBvosDOzAYFA26qcoCR7Yj87fOz/A4c3DCEOXi8tCiMW+WJ9vnb/6eIph+
         tPvI5X6tsFuPJ/S4NorWY60UcaWdbb4NdYiUA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681537752; x=1684129752;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OrHxjozj9Y97lEiYcNHU+1VJEkZJKfJvYo3LQaIdl54=;
        b=GzEJnifcG3NCh2cuMsApSuWmMQLVNGwYZHaK+zQWD3QnEt64oIAnu1fnSNKhDitfoR
         YpSNcoU8KxQZdWE0dZq4mob/gkdpFa/ntmgdP3XM3G0WtmEn8yPcp2A4XoLd3KGWuIh9
         LJ3A4mZPZejC3A6V4tPCoIN0rFBizlIk6HH/FJgintsTHCW/AMUux1LUeEvRu9u8/+BQ
         7hORpPJhh39MDSOyXw/ntuPCiPi3ftnJbF2TkIraoUeaPVmOz9biTGPpF06Ugnhj8cGR
         E2IflfII84eHjJTFrpTos0pAr8+G5hMXF52OBH4AFq6B/LNkhWdugvgxcsiZRD5+JQKO
         CaqQ==
X-Gm-Message-State: AAQBX9fHlBkWTLd0beulO/M0SOFO0e1Wjwl8/JwtkgGQ9BAo5X6AkE+g
        hM4F+w2h41OaNbu+6SDnuvVSvQ==
X-Google-Smtp-Source: AKy350Z9Nlpqh7TxlmaQw7ztKHaRdmGvphuxDHwV8dW9aG4Zh5OvVBqI+4//7gu2sR9Xu5moGNttUA==
X-Received: by 2002:a17:906:ce2e:b0:94b:869b:267 with SMTP id sd14-20020a170906ce2e00b0094b869b0267mr1275663ejb.28.1681537752625;
        Fri, 14 Apr 2023 22:49:12 -0700 (PDT)
Received: from perf-sql133-029021.hosts.secretcdn.net ([2620:11a:c018:0:ea8:be91:8d1:f59b])
        by smtp.gmail.com with ESMTPSA id b1-20020a170906038100b00947ccb6150bsm3294856eja.102.2023.04.14.22.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 22:49:12 -0700 (PDT)
From:   Joe Damato <jdamato@fastly.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        Joe Damato <jdamato@fastly.com>
Subject: [PATCH net 1/2] ixgbe: Allow flow hash to be set via ethtool
Date:   Sat, 15 Apr 2023 05:48:54 +0000
Message-Id: <20230415054855.9293-2-jdamato@fastly.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230415054855.9293-1-jdamato@fastly.com>
References: <20230415054855.9293-1-jdamato@fastly.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ixgbe currently returns `EINVAL` whenever the flowhash it set by ethtool
because the ethtool code in the kernel passes a non-zero value for hfunc
that ixgbe should allow.

When ethtool is called with `ETHTOOL_SRXFHINDIR`,
`ethtool_set_rxfh_indir` will call ixgbe's set_rxfh function
with `ETH_RSS_HASH_NO_CHANGE`. This value should be accepted.

When ethtool is called with `ETHTOOL_SRSSH`, `ethtool_set_rxfh` will
call ixgbe's set_rxfh function with `rxfh.hfunc`, which appears to be
hardcoded in ixgbe to always be `ETH_RSS_HASH_TOP`. This value should
also be accepted.

Before this patch:

$ sudo ethtool -L eth1 combined 10
$ sudo ethtool -X eth1 default
Cannot set RX flow hash configuration: Invalid argument

After this patch:

$ sudo ethtool -L eth1 combined 10
$ sudo ethtool -X eth1 default
$ sudo ethtool -x eth1
RX flow hash indirection table for eth1 with 10 RX ring(s):
    0:      0     1     2     3     4     5     6     7
    8:      8     9     0     1     2     3     4     5
   16:      6     7     8     9     0     1     2     3
   24:      4     5     6     7     8     9     0     1
   ...

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index 6cfc9dc16537..821dfd323fa9 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -3131,8 +3131,8 @@ static int ixgbe_set_rxfh(struct net_device *netdev, const u32 *indir,
 	int i;
 	u32 reta_entries = ixgbe_rss_indir_tbl_entries(adapter);
 
-	if (hfunc)
-		return -EINVAL;
+	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP)
+		return -EOPNOTSUPP;
 
 	/* Fill out the redirection table */
 	if (indir) {
-- 
2.25.1

