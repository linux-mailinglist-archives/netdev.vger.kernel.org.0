Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6FA06E3B74
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 21:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjDPTMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 15:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjDPTMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 15:12:46 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E753330C1
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 12:12:42 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id xi5so58772271ejb.13
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 12:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google; t=1681672361; x=1684264361;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PWA/HXzUdJz0H+XyZalEsfv+ELOZVQCrtHlubc/pGGk=;
        b=EhtLWp8bAj3+4DQEtWBmbwW3pMm5Niq1GLUU5LK/4TgCbLiNIF+JkwbO5Sruaq1TIJ
         euf3f8UBh8u1GgCADAc/+TO7Ke8H8XSy85Os95KcuVbrYcTpKX6nlV5Ge42FxzXSVw3T
         mfd2+aR3PDKkfeImiEVXsnLwUEcarQfRzahr8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681672361; x=1684264361;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PWA/HXzUdJz0H+XyZalEsfv+ELOZVQCrtHlubc/pGGk=;
        b=U608TojuVsb1B08auP/21pDd/+aUZ/7XFJiqIzof1/LBhkQnspPKK2fJbwbeU2dJkL
         RTgKWTHm/ENuDj31aa5nthHysTBV4BXZ8bRCSdgkZy3wG6S+2viyomSuhc89ePDQ6tbE
         IO6PARsVh3coJr4jlWFTP/RhPwS8Mui9isAEhhwtaPspM/dNYeym+7Wt01x8Ki14X0YO
         oCXT5/8gJRt04/weUaFC4y3vpPbw6fMruFc34wj2RaimNR8nRRSRFY/gYRhNPiwtposc
         VCaT4WpTi/EwhNUz+82rlgB+/nf7Z8WvO7sn62yrxDj55yojz1n1kk3C/l3DjnXb2NOB
         h1gg==
X-Gm-Message-State: AAQBX9fmJKLJWMiHhvH3uNeYqQNZEPB/URxjQQnxpjdMq/h/YRhavHfW
        I4AJKajAQBAWZklxvYWmXwMkSg==
X-Google-Smtp-Source: AKy350Y/ztfBTpaxswzpYlhnRokanjnwvwIKpEEbNey2UIY/AnxQ9CpItZN+i4lMBZeuvNLmPEPCUw==
X-Received: by 2002:a17:906:fa18:b0:928:796d:71e8 with SMTP id lo24-20020a170906fa1800b00928796d71e8mr5343112ejb.3.1681672361270;
        Sun, 16 Apr 2023 12:12:41 -0700 (PDT)
Received: from perf-sql133-029021.hosts.secretcdn.net ([2620:11a:c018:0:ea8:be91:8d1:f59b])
        by smtp.gmail.com with ESMTPSA id mp30-20020a1709071b1e00b00947ed087a2csm5463902ejc.154.2023.04.16.12.12.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Apr 2023 12:12:41 -0700 (PDT)
From:   Joe Damato <jdamato@fastly.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        sridhar.samudrala@intel.com, Joe Damato <jdamato@fastly.com>
Subject: [PATCH net v2 1/2] ixgbe: Allow flow hash to be set via ethtool
Date:   Sun, 16 Apr 2023 19:12:22 +0000
Message-Id: <20230416191223.394805-2-jdamato@fastly.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230416191223.394805-1-jdamato@fastly.com>
References: <20230416191223.394805-1-jdamato@fastly.com>
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
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
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

