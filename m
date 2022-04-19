Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8311507D3E
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 01:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357423AbiDSXqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 19:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355340AbiDSXqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 19:46:01 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB989205D0;
        Tue, 19 Apr 2022 16:43:17 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id x18so31142wrc.0;
        Tue, 19 Apr 2022 16:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jpkNlHRMQuG+lJdQ+TUaFjLfxZlD8sn5DIiknsBbDyg=;
        b=FHAUUHCg0T3/vQIQ/bRF+okFzhmCwTsm49QMr/HtsZY8D9NoBitjzbzAPlvKWo66mA
         yUnvDeEbuMhjeA807IQhUI8Ctj3s439/+etFMhsfgrAA4Smy1dcxpn/EJH6TyW6FEAXR
         0qJYEt8SkyFHjGdFjWy9fFJFKT0wFvbTjlg+365GEgIVkIXwPnyr3W3h9VMyJMureiGc
         fIHdnE6wXYFzj2+u0dkSRs8aoLp39jBwBr3S6YvvhjCJvDa/XZxCiBjH6txwEF+AhdOm
         fLy55B3TJrSbtkusmN4BB31KPN4I8UbQ8lMsuSCLDa2Kr87s9Q4E3TeaX1denTp6psgF
         mEsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jpkNlHRMQuG+lJdQ+TUaFjLfxZlD8sn5DIiknsBbDyg=;
        b=VTUGno1gY7OVHiaHSogwAQUX0zZr6IkrFFbfDVtPXRVP3F7VIOk1VY0DZqHAcVMUDY
         6M5jlEnh+Fq0zDAAMYZkFHZ9cZ0+sp7YukeDIVkas2FBFhGZBqT0OGflNytcAjsOu5PP
         OL49EboBI/iaVxBme6c4On47fmRvMZABsbUIMGxFTT9zI1HvCHaLj2R04iK7Ty1A4tzW
         fK9KF9ydVQ8AVnI8jHY/O0Ha9YNDwfQbEEw9IWZAwzHlfoPG7xAIHqxL8nVoulzZTyse
         EQH/7p6cGCOUyYWIpQ9Uis6N71dlxQqiEsKzLz+rCpSDS5JXy1mA1178G42RvZ7NVqUb
         yvBg==
X-Gm-Message-State: AOAM530M0+EIE54uQAvS/2SgQVq4CqQm7v2+WQ1UCLUqxG6OOaxfuS/6
        KMHFjUf2lMtoVK+5SJug4Hg=
X-Google-Smtp-Source: ABdhPJz1SgnnztC1b+XjTbtAXZve8DQ0RYcKvnNS+M9/iIN1yJ4iCUjDKX3GZOoZrrU6LsOZfnM1eQ==
X-Received: by 2002:adf:de90:0:b0:20a:8e73:aff1 with SMTP id w16-20020adfde90000000b0020a8e73aff1mr11180895wrl.151.1650411796437;
        Tue, 19 Apr 2022 16:43:16 -0700 (PDT)
Received: from alaa-emad ([102.41.109.205])
        by smtp.gmail.com with ESMTPSA id z17-20020adfec91000000b0020a98f5f8a7sm5623982wrn.6.2022.04.19.16.43.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 16:43:16 -0700 (PDT)
From:   Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
To:     outreachy@lists.linux.dev
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ira.weiny@intel.com,
        eng.alaamohamedsoliman.am@gmail.com
Subject: [PATCH v5] igb: Convert kmap() to kmap_local_page()
Date:   Wed, 20 Apr 2022 01:43:13 +0200
Message-Id: <20220419234313.10324-1-eng.alaamohamedsoliman.am@gmail.com>
X-Mailer: git-send-email 2.35.2
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

kmap() is being deprecated and these usages are all local to the thread
so there is no reason kmap_local_page() can't be used.

Replace kmap() calls with kmap_local_page().

Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
---
changes in V2:
	fix kunmap_local path value to take address of the mapped page.
---
changes in V3:
	edit commit message to be clearer
---
changes in V4:
	edit the commit message
---
changes in V5:
	-edit commit subject
	-edit commit message
---
 drivers/net/ethernet/intel/igb/igb_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index 2a5782063f4c..c14fc871dd41 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -1798,14 +1798,14 @@ static int igb_check_lbtest_frame(struct igb_rx_buffer *rx_buffer,
 
 	frame_size >>= 1;
 
-	data = kmap(rx_buffer->page);
+	data = kmap_local_page(rx_buffer->page);
 
 	if (data[3] != 0xFF ||
 	    data[frame_size + 10] != 0xBE ||
 	    data[frame_size + 12] != 0xAF)
 		match = false;
 
-	kunmap(rx_buffer->page);
+	kunmap_local(data);
 
 	return match;
 }
-- 
2.35.2

