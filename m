Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36838521F2B
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 17:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346056AbiEJPmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 11:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346594AbiEJPlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 11:41:52 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA1E64B1E5
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 08:37:35 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id l11so9370751pgt.13
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 08:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=PdPlZRsOxRW+YIwMm2Y4AhpXbfEU+U4Qe7uriCAoowI=;
        b=H01PFGwDfKIrrLOmL6Pc+GE9/m+V7WEY9jPA5KqW2sKlso6dB2zAQsuK3idACn1jey
         BNGE2NNbYfA2NuatxiPPQFwx+fbh7qxFN3Pz40EgX/u53jnEf3xU7UKYmov/CI19Akvw
         kXRd67uWNVthqGh2++FDYgqKM/z0FsweFiKM9sshxr2LcbEjdi1p5TFkYUisIhayqJlf
         VP9Q3b3scblQs+f+0FDsHK2WO7VrA111QbHGhnW3vteTds3c1kEL89MOg6NUekRk72+V
         eAdzrHoGBBC6Cb133q0J8LIQWbfND2f2ItoXIDmsdPPrfvu0e8uBx2PBvnQRqb1i6/5M
         ig1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PdPlZRsOxRW+YIwMm2Y4AhpXbfEU+U4Qe7uriCAoowI=;
        b=5dI7GB84/gpWwHyoVb2nhv7PLS5uVGShaGxKRsCTYNX0b+d1nZt901Qdd/I8BskTs3
         xpfYoGgjIUQvBEIHVyXKQo9nWKgwX4JiwS2jQFZ7ApPoIRZa9lQBZcA/BA1YgHJdCTK5
         a/8Mwa8E9/UtiW78pTNzNNjzn4qk/AnrumnQQYUMtpTdhBrGsWQvjYF0jQYXfqkd02wi
         WEjK/7XgxElqyvk2AYKsAxR/4Jglh7qZXCY9MpmbMRgCZ5uKHjGtAT5mnQfzyBhzoTFe
         reN0DxFVqYdcoBnK+doSjTpZSXXBbaoebtIfMumrjzPnfdGCYPWXi0MSQ5cjcfR74NOW
         S4yw==
X-Gm-Message-State: AOAM530RdxhKJ4o+g+sOzG7G0FH8FS/o/34IsxgqeDcfatSaTLnuvLAm
        wFfAoFABvzWd2EFLZNa8JSo=
X-Google-Smtp-Source: ABdhPJyuBRM+PucaxfaZo0xb4WVCIA/irE07DxAIzbtPXEKuLwW0HgzKJEpAkv+rvvBevy0R1SrtfQ==
X-Received: by 2002:a65:4bc2:0:b0:3d0:2d36:ac2 with SMTP id p2-20020a654bc2000000b003d02d360ac2mr3784707pgr.603.1652197055378;
        Tue, 10 May 2022 08:37:35 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id bi10-20020a170902bf0a00b0015e8d4eb1fcsm2211308plb.70.2022.05.10.08.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 08:37:33 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 0/2] net: sfc: fix memory leak in ->mtd_probe() callback
Date:   Tue, 10 May 2022 15:36:17 +0000
Message-Id: <20220510153619.32464-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset fixes memory leak in ->mtd_probe() callback.

The goal of ->mtd_probe() callback is to allocate and initialize
mtd partition and this is global data of sfc driver.

If NIC has 2 ports, ->mtd_probe() callback will be called twice.
So it allocates mtd partition twice and last allocated mtd partition data
will not be used.
So it should be freed, but it doesn't.

This patchset contains patches for ef10 and siena device.
But I tested only ef10(X2522-25G).
Siena version of ->mtd_probe() callback is similar to ef10 version.
So I added it.
But falcon version of ->mtd_probe() code looks different.
So I didn't add.

Taehee Yoo (2):
  net: sfc: ef10: fix memory leak in efx_ef10_mtd_probe()
  net: sfc: siena: fix memory leak in siena_mtd_probe()

 drivers/net/ethernet/sfc/ef10.c  | 5 +++++
 drivers/net/ethernet/sfc/siena.c | 5 +++++
 2 files changed, 10 insertions(+)

-- 
2.17.1

