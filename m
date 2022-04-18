Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70002504C7F
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 08:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236719AbiDRGRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 02:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233647AbiDRGRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 02:17:14 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E5917AB7;
        Sun, 17 Apr 2022 23:14:36 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id n126-20020a1c2784000000b0038e8af3e788so8281450wmn.1;
        Sun, 17 Apr 2022 23:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e8ZuwAsZvFhjWYjd8yTG5wsLv6buaB3HfTucRNG+UqI=;
        b=WBAxuBJojSU2AxQ868FqVcQ6bk55DcVrjS+gy3jAnt3nvDlRlbljqO97Jz3Cz5AMiT
         rA4ZZ5BibfwSetqgnPmUrzvxgW5Rr3ceJV5T4gk8DGbjt369zJGMLqsD8d7D8Sc2b1Wt
         fJPj/M94vOwbducPtV5E9Ih0H1Ei+Oy623kbixxJycErlhhEub46YERI5B0USCLjqV9p
         pvq4FJxxKKN4YNjvfDQwT6GLNuqnymE6X7+nDqcD2WjR/4u3vAx8degW1ZL9ouFlwHW+
         t24S0hCJL4SePnhvBYckJXIkD5weNDMB2sTTJwICx+uvdewNGWsguBuV5ZFlwtHGzKlc
         m02A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e8ZuwAsZvFhjWYjd8yTG5wsLv6buaB3HfTucRNG+UqI=;
        b=3jRnIFeg/QoWyoTlrtU96AnptlJ0Yi95PyytQr2kusvILxroptBtBuESyHQuYfkG8R
         3VUUU6vzfQe69Oje38oIsR7P/thjPhaclsJBFGGPrEF9HOMjmXAYrPtUtTSJ0uKJDIYi
         AMtdolK96ISQ2JBbUIfU79ypqdqcSqHtEBlLRQmnGfq236rLVgaVxT9Fo2DUEhhDDi+k
         WtmI5tUA3F8I9mmmi20A/FLtVpbdHpi2Oa5XeQPPia350nKi6oLriG+mADXxAbnIN/Jo
         bV0HFwutmkLLJEQUsPbGzljxN+rKARdu9rw4pkdZNfVBJRXR/tFdyC+8/UCAZy23XYCj
         3q9Q==
X-Gm-Message-State: AOAM5319Quq09GsaGhytarfRifs/gbveg8eBnjwyZgnf2lloG26hmC3A
        FsGOosYCknj+qLaikUDCA/sSWmYj+CXn7A==
X-Google-Smtp-Source: ABdhPJyPTRA13mBsIiG+RM0ugphkP3LSbXaCVQcb4zssDaNxL91RgVJA7llncwPOS67rRpAbsu7dxw==
X-Received: by 2002:a05:600c:5114:b0:38e:bd9c:9cb0 with SMTP id o20-20020a05600c511400b0038ebd9c9cb0mr13433157wms.153.1650262474907;
        Sun, 17 Apr 2022 23:14:34 -0700 (PDT)
Received: from alaa-emad ([197.57.90.163])
        by smtp.gmail.com with ESMTPSA id z17-20020adfec91000000b0020a98f5f8a7sm1654811wrn.6.2022.04.17.23.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Apr 2022 23:14:34 -0700 (PDT)
From:   Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
To:     outreachy@lists.linux.dev
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ira.weiny@intel.com,
        eng.alaamohamedsoliman.am@gmail.com
Subject: [PATCH v4] intel: igb: igb_ethtool.c: Convert kmap() to kmap_local_page()
Date:   Mon, 18 Apr 2022 08:14:30 +0200
Message-Id: <20220418061430.6605-1-eng.alaamohamedsoliman.am@gmail.com>
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

The use of kmap() is being deprecated in favor of kmap_local_page()
where it is feasible.

With kmap_local_page(), the mapping is per thread, CPU local and not
globally visible. Therefore igb_check_lbtest_frame() is a function
where the use of kmap_local_page() in place of kmap() is correctly
suited.

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

