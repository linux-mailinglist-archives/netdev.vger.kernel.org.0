Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D10733CB73
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 03:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbhCPCbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 22:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233085AbhCPCbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 22:31:46 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C9FC06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 19:31:46 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id lr1-20020a17090b4b81b02900ea0a3f38c1so2876592pjb.0
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 19:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=b1qtY86HeiupYYtico3pCitAfhMt4CtEmG+eFuN+gIA=;
        b=nHiF46E0GQFX7vkClWactpglrqDkxq4NX23MCmFFLR/JI9pYLUsVIDEXiPlyLPkrgI
         9LyyuuG+qm7ajDMbmqZhT925baVcNQj8XODQ/2T02RKrTU8vUzvVmS5rSegE0Uo7a8V2
         V8UhP1Wd2qjvQ+VTQ0z6OFwX9mUx19S72RYw4aORBhfdf+Owi+Oppr4BAXqMKCImEG+N
         sU/dRANYTbg0iwwg0pgY2ztN0uce4qHX7leJogEv/E2KM+Wvyb1nIb68Z6e6D1QWfT7T
         ntqJkkFFF7Ex5cgo7oRRxJ3A3SfuGgLM7aF29CQptXVV4rIk2H2wqxiiz1zwHvODCqyv
         IEnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=b1qtY86HeiupYYtico3pCitAfhMt4CtEmG+eFuN+gIA=;
        b=AnuNcp6Ddy5dcn4TTHM8HDMdP+c9WC2JkisPpGi5iU0zm09thf5CG8FiH+AmyaHnvp
         94Azw8jWQrCLDu6nLliBUq/vGkbqFyq51vxEkQNAxny4NnrfhGUccgQgujFd1y4h+5or
         QgpAHfMQFDVbuu/7d5n9LtwY1SXBW+CFjJnomopYWDQFtAO00DkvEUSpD0H99I0dcXTP
         mtxGn6ElMP9Lai/4fH24m7oxQW51LHs27ncGND4SAx8pRyphDe0jWHgp4gWVU3ng+k8v
         +ZhTYq5pDAaMCelJsQKEeby/Qr+QSJAovuwEiqIP2xBtCtFUR3bjc0CwXGu5kPQ6KD/p
         96iQ==
X-Gm-Message-State: AOAM533ooRyjhsNFM9DTJspoqwG4++DeSanVji4PLJYkviQRZQoA2g8V
        vS99fXWgK8xo+f35UT7gpPvQLKSz/4QvLA==
X-Google-Smtp-Source: ABdhPJxe4y+Z3kYrsfWpLji1X7zlSRxrke5r9r8iYT5ccZ9N6iyip/yBBMNlFWC+4cxEo1hs0hs3nA==
X-Received: by 2002:a17:90a:b311:: with SMTP id d17mr2349711pjr.228.1615861905853;
        Mon, 15 Mar 2021 19:31:45 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id t18sm8687743pgg.33.2021.03.15.19.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 19:31:45 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 0/4] ionic Tx updates
Date:   Mon, 15 Mar 2021 19:31:32 -0700
Message-Id: <20210316023136.22702-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just as the Rx path recently got a face lift, it is time for the Tx path to
get some attention.  The original TSO-to-descriptor mapping was ugly and
convoluted and needed some deep work.  This series pulls the dma mapping
out of the descriptor frag mapping loop and makes the dma mapping more
generic for use in the non-TSO case.

Shannon Nelson (4):
  ionic: simplify TSO descriptor mapping
  ionic: generic tx skb mapping
  ionic: simplify tx clean
  ionic: aggregate Tx byte counting calls

 .../net/ethernet/pensando/ionic/ionic_dev.h   |   6 +-
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 374 +++++++++---------
 2 files changed, 186 insertions(+), 194 deletions(-)

-- 
2.17.1

