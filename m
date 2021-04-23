Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 284C3369008
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 12:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242014AbhDWKFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 06:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241997AbhDWKFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 06:05:47 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2AD8C061756
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 03:05:09 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id a4so47788803wrr.2
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 03:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WOEa3H9ikuixMJBnj2BWjU2Lt8l1O0JIiIqWbM9kpD8=;
        b=pizEhOxllejzw/8cviEnPDfzzWXgysABi96iBqVvHDG1iXJK/pYLRhoNySP4d9eP9q
         PKW1r2ou2j1/7Ceb/oT7pI763fbyqD7s5xEn85KWeF0IJuRUY12G9/rMJCwl99+qNPeJ
         zXepmL5egnTXebZVP7TqRZfuMdMDITBqflQCMA/7cCgbPEuj5dEb08M8Hd/jlpVn2QvU
         7NSjQ+BwO7QADLzz0kiD+dQHjKDRAGZapHbWzZhFqzZf8BVN8OJ6UxmAFoAKlTQB12y+
         2+8GCPhrqvp7YFme5icmLl9NbvPW7n+qOvn6s+VY4RG8obwz+WHRDG2vfSsHO8z+6K/U
         FJjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WOEa3H9ikuixMJBnj2BWjU2Lt8l1O0JIiIqWbM9kpD8=;
        b=Dk3VLgVpVC9fwfKVBOIHVTvtz22UXBuD+96m1NaBAp3IwOAvsUwra5OLd4NcvOEY3H
         Xg31BOfB1fmlL9U6/gXNMlMIz88BJkI6+dhln6VEXu0F9RLYl412ShU5Gm9uSWyofYSr
         DL9ZKj+s873t/UGoDpqftVQGkyzsrFl7sP6ALEjXkyZxnpmIPdNybTfKEAGms61cotvB
         2Hc1frrpNzR+4Vvyy9gcoO58mdkb9F/I0DY0GZLJNUtT0DLlGaGHtiItDGCqcxOVnqsj
         +X/jfHMjxrBTsRjG2u2k8MaBYHtXCQJunz0R2jhR3zsHN3DRyEFwiojO6CXBG8DdOUEc
         jqWA==
X-Gm-Message-State: AOAM532xNscTNpWdxtc/7XWB2h2/vYpwll1rUCJpzMEoQiiZeNQR1Wwg
        KjT/dL5x1SR7uJpQZdwmhNY=
X-Google-Smtp-Source: ABdhPJwsnMZlDbqV2YXuKVj/0Ix/n/fmzLvCeqQlH158jIuHWh0Betz0dYC2WcyeJPHt2CvixCpEiA==
X-Received: by 2002:a5d:69d0:: with SMTP id s16mr3705364wrw.102.1619172308621;
        Fri, 23 Apr 2021 03:05:08 -0700 (PDT)
Received: from localhost.localdomain ([188.149.128.194])
        by smtp.gmail.com with ESMTPSA id t12sm8599481wrs.42.2021.04.23.03.05.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Apr 2021 03:05:08 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, intel-wired-lan@lists.osuosl.org,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com
Cc:     netdev@vger.kernel.org, brouer@redhat.com
Subject: [PATCH intel-net 4/5] igb add correct exception tracing for XDP
Date:   Fri, 23 Apr 2021 12:04:45 +0200
Message-Id: <20210423100446.15412-5-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210423100446.15412-1-magnus.karlsson@gmail.com>
References: <20210423100446.15412-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Add missing exception tracing to XDP when a number of different
errors can occur. The support was only partial. Several errors
where not logged which would confuse the user quite a lot not
knowing where and why the packets disappeared.

Fixes: 9cbc948b5a20 ("igb: add XDP support")
Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index a45cd2b416c8..45fcfc536b38 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -8402,18 +8402,20 @@ static struct sk_buff *igb_run_xdp(struct igb_adapter *adapter,
 		break;
 	case XDP_TX:
 		result = igb_xdp_xmit_back(adapter, xdp);
+		if (result == IGB_XDP_CONSUMED)
+			goto out_failure;
 		break;
 	case XDP_REDIRECT:
 		err = xdp_do_redirect(adapter->netdev, xdp, xdp_prog);
-		if (!err)
-			result = IGB_XDP_REDIR;
-		else
-			result = IGB_XDP_CONSUMED;
+		if (err)
+			goto out_failure;
+		result = IGB_XDP_REDIR;
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
 		fallthrough;
 	case XDP_ABORTED:
+out_failure:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
 		fallthrough;
 	case XDP_DROP:
-- 
2.29.0

