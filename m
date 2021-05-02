Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 152F1370F0B
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 22:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbhEBUiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 16:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbhEBUiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 16:38:00 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A579C06174A;
        Sun,  2 May 2021 13:37:08 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id d10so2288883pgf.12;
        Sun, 02 May 2021 13:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=rIhNysPMquyg1QvY8ihROhCNGvw7I9hCF0zYiRgI33s=;
        b=SxTXTUpdgUemT1VGl11TfLSs2IygJnY3garQ9xa8yAy0hHC5/1zfbYdSYRRUXpDVcW
         gzEw8HDKhuWB/ymJwqirIOJazw9KyuLV5uvfvY279+50IjsnNh6xDuEPCyB80Ekoo3kk
         KJVa0l55ErXH6j5HK4bmm2/46Ngo70KunIlpios7Qcn7+3K6klDjbb+etc4WTMMjAt6J
         Z29RS01C370VM8jATSWmLLD77nPoEOoDIysOm/hecjp3sd64kw7/SPF34zipjQ75zLdx
         ej9P8lMmJXUiEhhFHthayogSkUaQ7xKWIpfxvVkhlT1XQ5+x27F2igsq0p8jUirWpnta
         ZcSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rIhNysPMquyg1QvY8ihROhCNGvw7I9hCF0zYiRgI33s=;
        b=eUL6zI2gP0cfTLuNvQ6JmX/z7YzNq/SenKjT7Y88omptS2VHo33PaQbg80IGLOPACM
         T4zc+ya11L6bsjamQOrSwi9Kw/G7MgkOiqg7QHjPO+oQe8okbVvbGoTjHynBm/KJTZ3Z
         1gOCmffis+w0tOr6APeIT9BQTQ2qF2IsToO53pvzZBE2KOWaseKI0XPalFXs9B6tpj+y
         qsPVH3ggbFkPnMJFnO49cwFDT/STKsBohjuK+JzkR37bwOjs5HFP2ZncJxDdRCuem7IS
         euwno6P8CNZukSgeaMGYyesvj7te/vyryuj6RWZqHGEN1E2EBDY8R2PECAOpKxG0YdS5
         8p2Q==
X-Gm-Message-State: AOAM531r/WZN8KndrnjM7b2cGKpxYovzMTPzvADaFUBCAMrkRJvYvZJk
        qGMCuF9+VIZIV03bf99FHXQx8M9ybrqG6g==
X-Google-Smtp-Source: ABdhPJweLdp+yq8P59k2jmcSrQbvCrtxwWYlmytDpeHhC5gahroBifE9uqFgDeBT64SCvSPQSdrfdQ==
X-Received: by 2002:a63:ff22:: with SMTP id k34mr15026595pgi.336.1619987827250;
        Sun, 02 May 2021 13:37:07 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y23sm6687931pfb.83.2021.05.02.13.37.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 May 2021 13:37:06 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        jere.leppanen@nokia.com
Subject: [PATCH net 0/2] sctp: fix the incorrect revert
Date:   Mon,  3 May 2021 04:36:57 +0800
Message-Id: <cover.1619987699.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 35b4f24415c8 ("sctp: do asoc update earlier in
sctp_sf_do_dupcook_a") only keeps the SHUTDOWN and
COOKIE-ACK with the same asoc, not transport.

So instead of revert commit 145cb2f7177d ("sctp: Fix bundling
of SHUTDOWN with COOKIE-ACK"), we should revert 12dfd78e3a74
("sctp: Fix SHUTDOWN CTSN Ack in the peer restart case").

Xin Long (2):
  Revert "Revert "sctp: Fix bundling of SHUTDOWN with COOKIE-ACK""
  Revert "sctp: Fix SHUTDOWN CTSN Ack in the peer restart case"

 net/sctp/sm_make_chunk.c | 6 +-----
 net/sctp/sm_statefuns.c  | 6 +++---
 2 files changed, 4 insertions(+), 8 deletions(-)

-- 
2.1.0

