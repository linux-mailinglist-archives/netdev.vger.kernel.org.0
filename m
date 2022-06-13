Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB91547E38
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 05:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbiFMDpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 23:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiFMDpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 23:45:32 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66EDB1260C
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 20:45:30 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id v4so2047446plp.8
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 20:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3Wxg3U+5D8fpO2CZORZAqLiCHbqt6Bc2EUkzLHiwqOU=;
        b=WRgWCUEo6HS50H8PFnlOGwZ0WJod7AwjObge4uNzPK6qiCui/bvDuh5tMWi8I0EUCO
         mCxIGBQyLKCCRKMTh2rdQ3AgVacpLyUIX0jiF5co1VsvryLNUBoxwdQ5ULe2ty/ndxvw
         dZo1VdO7AmiUt8/Hj/etBy0LBKvTCvU1IZ2yP+kl2FwNXkRZJVb7DP1gAlUXLrdE5QXP
         wok5cBOfUylAjd2a2NVmVePHcRbhaiJ1onLtmaef+986MpwN5sjajEu4cypEzwAbT3x4
         EcNyuFzKizTMja1//caTivXwd/EoDQMuGMhgWmSkddfWvfx0WnkrS1rSAc9YCTiSHWTr
         wAZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3Wxg3U+5D8fpO2CZORZAqLiCHbqt6Bc2EUkzLHiwqOU=;
        b=snBOLFKbHnpDF6PirKiUj9n09glUEzxqcbiA2GYlkSSeHT1fHuuuF3K4YQm+Abd33E
         ppMnyK1EgIEHZiDz16KG3Zysb21p8Sob0G1u7jni6ldwgO2+eq40ORKSfX28fqb9p8sE
         lUsnsHpAdjAdFPqNbUp+LZar1BUmcAPldQDPE9y14c4V4+jh+J/JVzterxhhfK9wXBAh
         wlowY44aAiGPfdRfQqqnkK8+D4WeFM15ErOh4tr/WBOCrT62Q+fCVQ1jwafS1cX2S2+9
         e8OK/KZgFqOIw/HP9/CqBqBq1PtlHe5oTePd4yUkdjcdni6kG1IR9l2mnOIsdIx9bfqa
         Y4Rg==
X-Gm-Message-State: AOAM531s5YiCbmkySRu8tU4dC7F0QyeTuAlx0mno621sGpUc9kAJqhZW
        VwpB9Ld2mkzdrfo+/gx3CwRkVg==
X-Google-Smtp-Source: ABdhPJw8j3/81+1Ure63L8OB0av8ZUyXnSdUe/z8WMnsAWi2r+FuWZFmjYtaancU0hGNdetxTzfWCw==
X-Received: by 2002:a17:902:7282:b0:164:17f6:e36a with SMTP id d2-20020a170902728200b0016417f6e36amr55486230pll.139.1655091929929;
        Sun, 12 Jun 2022 20:45:29 -0700 (PDT)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id u13-20020a170902714d00b0015e8d4eb1dfsm3810769plm.41.2022.06.12.20.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jun 2022 20:45:29 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        michal.simek@xilinx.com, netdev@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Andy Chiu <andy.chiu@sifive.com>
Subject: [PATCH net-next 0/2] net: axienet: fix DMA Tx error
Date:   Mon, 13 Jun 2022 11:42:00 +0800
Message-Id: <20220613034202.3777248-1-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We ran into multiple DMA TX errors while writing files over a network
block device running on top of a DMA-connected AXI Ethernet device on
64-bit RISC-V machines. The errors indicated that the DMA had fetched a
null descriptor and we found that the reason for this is that AXI DMA had
unexpectedly processed a partially updated tail descriptor pointer. To
fix it, we suggest that the driver should use one 64-bit write instead
of two 32-bit writes to perform such update if possible. For those
archectures where double-word load/stores are unavailable, e.g. 32-bit
archectures, force a driver probe failure if the driver finds 64-bit
capability on DMA.

Andy Chiu (2):
  net: axienet: make the 64b addresable DMA depends on 64b archectures
  net: axienet: Use iowrite64 to write all 64b descriptor pointers

 drivers/net/ethernet/xilinx/xilinx_axienet.h  | 51 +++++++++++++++++++
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 28 ++--------
 2 files changed, 55 insertions(+), 24 deletions(-)

-- 
2.36.0

