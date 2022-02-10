Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F59A4B192D
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 00:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345497AbiBJXLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 18:11:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242400AbiBJXLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 18:11:45 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D415F45;
        Thu, 10 Feb 2022 15:11:45 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id x5so7142207qtw.10;
        Thu, 10 Feb 2022 15:11:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ZBdSYHCr3USYo6W485UfRkjDE4guUfBuyMH5Mb4JqDU=;
        b=noirHY6GF4V4i8t+uu5JZQoNb9aCpruRdnEm1zuUkGMxjiGL/QA+2jJvW5q696QSYt
         ArH2xdXNKzx5VAWJf1ZbXj6Kin8p6qbXiG8tHG5RXG6uOggXjgywln0c3VNSq7sLigyy
         z7NvvKNREN8owyh9M01OFt2t8EjXllkRx7rL32xroe+PX7EzcvAgPKIArIqn+8ZjlOOK
         BwiWD5bNNWfkAbLL7OZzG+zIgoGXfWQmbCHioMYE/Hixd6D2RclBD1TwsJtxlKfyxR1a
         3Iql8/K0PmZQ89a+14GQBXllOV38XKrUISn4vaAL9wPTv2tPQ/awzdPhwhPpDuTRlRvK
         fafA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZBdSYHCr3USYo6W485UfRkjDE4guUfBuyMH5Mb4JqDU=;
        b=T/ArRcZvgshtDP5falXRVxZIoXaUH3aibUQH7mteOqyVjtM888YPFuSl+n4AR1dAAY
         0y8G9wD7pgV0mnfRErAWxNap014CmfLCG468+8YuH0ge3XLIXaQCC4z3eKZ8pvWT+bhn
         fauyjpfMGvN5o+h9opSRZ5mcdZz3KTV2ToQeFBSmvxo5Qh8gb7NZD5M0Yx743qPgNcIo
         KXKhenNcsIM2T19WbOEjNvnXPP2olxlRGlGmEUpJAGsENAfV3k3KhM6EJhsP2Bpf4jnE
         C8H9zUKkQ0iigpx6f3mor0+r4OGlTps+KUMLVcV6oluLPyHbUhxAUNEfZai9v2EJ6fc/
         fH2w==
X-Gm-Message-State: AOAM530mccGS8+RQAR+VBqiWOmDy6BA4CM2eQsStI65ra4Gb/OagNf4y
        GLGnXvNBObXrlJGSB1BSFEU=
X-Google-Smtp-Source: ABdhPJyRNHJTVVPj+RR6tyohLG29mySY3xnZq28upNS8nrO1spe/OPmQyWpzHExT/NjogD+tlz2nxw==
X-Received: by 2002:a05:622a:349:: with SMTP id r9mr6655005qtw.37.1644534704732;
        Thu, 10 Feb 2022 15:11:44 -0800 (PST)
Received: from localhost ([12.28.44.171])
        by smtp.gmail.com with ESMTPSA id h5sm11242509qti.95.2022.02.10.15.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 15:11:44 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Laight <David.Laight@aculab.com>,
        Joe Perches <joe@perches.com>, Dennis Zhou <dennis@kernel.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Nicholas Piggin <npiggin@gmail.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Alexey Klimov <aklimov@redhat.com>,
        linux-kernel@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH 09/49] ice: replace bitmap_weight with bitmap_empty
Date:   Thu, 10 Feb 2022 14:48:53 -0800
Message-Id: <20220210224933.379149-10-yury.norov@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220210224933.379149-1-yury.norov@gmail.com>
References: <20220210224933.379149-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ice_vf_has_no_qs_ena() calls bitmap_weight() to check if any bit
of a given bitmap is set. It's better to use bitmap_empty() in that
case because bitmap_empty() stops traversing the bitmap as soon as it
finds first set bit, while bitmap_weight() counts all bits
unconditionally.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 39b80124d282..9a86eeb6e3f2 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -267,8 +267,8 @@ ice_set_pfe_link(struct ice_vf *vf, struct virtchnl_pf_event *pfe,
  */
 static bool ice_vf_has_no_qs_ena(struct ice_vf *vf)
 {
-	return (!bitmap_weight(vf->rxq_ena, ICE_MAX_RSS_QS_PER_VF) &&
-		!bitmap_weight(vf->txq_ena, ICE_MAX_RSS_QS_PER_VF));
+	return bitmap_empty(vf->rxq_ena, ICE_MAX_RSS_QS_PER_VF) &&
+		bitmap_empty(vf->txq_ena, ICE_MAX_RSS_QS_PER_VF);
 }
 
 /**
-- 
2.32.0

