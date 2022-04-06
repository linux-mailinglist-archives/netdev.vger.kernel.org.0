Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B718E4F611E
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 16:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234325AbiDFOJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 10:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234894AbiDFOIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 10:08:13 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99DFD4E7D85
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 02:54:51 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id z1so2379573wrg.4
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 02:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HDhSTbbW7xXt8kqWzs+odsHOCgWSTvr/1d4TircSL8c=;
        b=Cglbp+8erWtMAybQPfgniVDgULgXV1FIx2lWhh+ndRv6/yVS1vEfPpBl1540hb/ZWx
         ed2pDH3hC5bVypVktwiakQhNiKHQq8dVv+7UoHSlHGU/9bzBRq6UsxCefVE0M4M0PG8U
         q/2MChgohk86gzizfoe/v7QpjKiUkUK1NNtkgyfBCnIHLuibobUhp3WGWx3bdS9/+AZc
         LPVb6ZbTZT2dYgRYioRlZybpIWfu14pv3YDHgvre2kiYFmGgFfO7l/6gb6oJPvi0r+E+
         zi5DAQYDN8H/dsOz7Ej/3iRoUmUi/Vr7MZytFGPK6NYsgnK7XcCqSTaFiocpVW9OMGS3
         wrlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HDhSTbbW7xXt8kqWzs+odsHOCgWSTvr/1d4TircSL8c=;
        b=s3Eqa4g66DPFgQC0Zwd9aaz8OYZuU+E3c/feWo3HpLsvH/AX1TlXtpMYBHa2g01PUN
         ZxElPjw7ZTKw47SVXcD7VXLBZx8XmXGcIsT3dISq/1N7yGdWIXob+r8Yatsed1YDOyw5
         EaWX6FNOeT88RruDA+zf3bJR5qlf8DF8ySx2/DrqRGh2JN3f/KpGSkpBrbwgfnUsiha2
         sEnNbPFNw4OTXEdlmJKsBncqrX7uj6jEapyPEkCZVhqxB/RWD+UL2BtKG+nNDhRP7I+g
         uTcCzzCLW4u5YWKhN42dVAWrXF8X8io5MzEESxgMxJwVaEmRuxfiwYrUNKHabn2AEnOI
         ln4A==
X-Gm-Message-State: AOAM533ZYVeY75TwdQ2Zh7Mz7Ts/4wmYnwFdvuFBgfWnKKYLGywvgstg
        WCpsTm+KehkFD1CRaRae6KK+MObcSc1CpQ==
X-Google-Smtp-Source: ABdhPJzVecx24aeX/XIXr3Kiz4wmki4YASU5CCzxkxqXdEV7PZeWLJ04FsCtb5yIhRTgAPsBatD8pQ==
X-Received: by 2002:a5d:64c4:0:b0:206:10e0:d73b with SMTP id f4-20020a5d64c4000000b0020610e0d73bmr5787095wri.412.1649238782416;
        Wed, 06 Apr 2022 02:53:02 -0700 (PDT)
Received: from gojira.dev.6wind.com ([185.13.181.2])
        by smtp.gmail.com with ESMTPSA id f18-20020a5d6652000000b001e669ebd528sm13874604wrw.91.2022.04.06.02.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 02:53:01 -0700 (PDT)
From:   Olivier Matz <olivier.matz@6wind.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, intel-wired-lan@osuosl.org,
        Paul Menzel <pmenzel@molgen.mpg.de>, stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net v2 0/2] ixgbe: fix promiscuous mode on VF
Date:   Wed,  6 Apr 2022 11:52:50 +0200
Message-Id: <20220406095252.22338-1-olivier.matz@6wind.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

These 2 patches fix issues related to the promiscuous mode on VF.

Comments are welcome,
Olivier

Cc: stable@vger.kernel.org
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Changes since v1:
- resend with CC intel-wired-lan
- remove CC Hiroshi Shimamoto (address does not exist anymore)

Olivier Matz (2):
  ixgbe: fix bcast packets Rx on VF after promisc removal
  ixgbe: fix unexpected VLAN Rx in promisc mode on VF

 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
2.30.2

