Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 052F84FAEC8
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 18:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242149AbiDJQNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 12:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242447AbiDJQNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 12:13:01 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3373047571
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 09:10:50 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-de3eda6b5dso14853339fac.0
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 09:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FtbF/FUaqCZ0HQhw5G+AvnU+iO22jbw/rXVk0VcUXm4=;
        b=pHH8rnTEp5VQVk20mnMsn69nJZqEZwScYpOig4WPsqjO80i0TvLlAxuZcJm6Lnpnzv
         qC3jQvgWBvJaieY5orYuDnPrIXNmsV3gyjVOastx2nq4FGb8TJAukmMifIRhIVJUmdXl
         wKGa9lITurFkkflBfJ1x4g/Z49QAumSUK2BRdxrY8Gur5hGzOYh99EoGwPRrBJMtFDgp
         0SNVsG8DwywMRj3ZTlGFCmG6QsuIJA/ynmMIyvW/FZNck1QC94CRObDI/BnXS64WeqaG
         +yh3ZMihXtYbyVCo/kHlwpfcgkHDEMPpPi0HPid9J9OppMBbIeGtEz9P9NO8jHJ9oepu
         3GWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FtbF/FUaqCZ0HQhw5G+AvnU+iO22jbw/rXVk0VcUXm4=;
        b=Q53iRA/7t0t7GodYrDQRl3VBwZtbGjzQnNcTsYAwhrGeSu5a7/LTVJX2BybZbPOx5F
         OBXSKv1TJpIgsRZZsBRsyfOvN9C4w+MzzWZP0cvhA+PQyMOnLV7gScH46/reIlsgx2DJ
         zGT1f/kbnm6UV+GhhNCPUM0VhGawOgo+FCh6MHei/bpfMwl+c7fg+KNbBnXCbpvUAnOv
         DTwhOiY+0x/ptkBVD53XGfyZsWrhn8U5Rg7WUPhJubv+AvVWab2jZw8vEfeRh0i2F2Fu
         U5HNeXZdz9IyLaDmLq1oT7g5Vgo9lzRfdrMJtovCJJJvUVZY1eLEqsvBbfrFyfWYSq08
         lCIA==
X-Gm-Message-State: AOAM532j/T54s55K6vn6TqyP0+tLa9D4UYKtUfxK4oiIIOOzHb2L4aih
        8jHq0gCPm/HKO155OlSlm2GrPiFk7rM=
X-Google-Smtp-Source: ABdhPJxratcSA9Db8iOiK4G0FAGQBMrUv9ANix+PaLfnWnTJNJ+rkNlS/6cqTQLNd3GSrP+ljzB2xQ==
X-Received: by 2002:a05:6870:3906:b0:e1:f53e:173d with SMTP id b6-20020a056870390600b000e1f53e173dmr12807216oap.77.1649607049378;
        Sun, 10 Apr 2022 09:10:49 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:9a32:f478:4bc0:f027])
        by smtp.gmail.com with ESMTPSA id v21-20020a4ade95000000b00320f814c73bsm10550200oou.47.2022.04.10.09.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Apr 2022 09:10:49 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf-next v1 0/4] sockmap: some performance optimizations
Date:   Sun, 10 Apr 2022 09:10:38 -0700
Message-Id: <20220410161042.183540-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.32.0
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

From: Cong Wang <cong.wang@bytedance.com>

This patchset contains two optimizations for sockmap. The first one
eliminates a skb_clone() and the second one eliminates a memset(). After
this patchset, the throughput of UDP transmission via sockmap gets
improved by 61%.

Cong Wang (4):
  tcp: introduce tcp_read_skb()
  net: introduce a new proto_ops ->read_skb()
  skmsg: get rid of skb_clone()
  skmsg: get rid of unncessary memset()

 include/linux/net.h |  3 ++
 include/net/tcp.h   |  1 +
 include/net/udp.h   |  3 +-
 net/core/skmsg.c    | 48 ++++++++++++-------------------
 net/ipv4/af_inet.c  |  3 +-
 net/ipv4/tcp.c      | 69 +++++++++++++++++++++++++++++++++++++++------
 net/ipv4/udp.c      | 11 ++++----
 net/ipv6/af_inet6.c |  3 +-
 net/unix/af_unix.c  | 23 ++++++---------
 9 files changed, 102 insertions(+), 62 deletions(-)

-- 
2.32.0

