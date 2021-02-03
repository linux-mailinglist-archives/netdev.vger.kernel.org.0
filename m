Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC19130D5A2
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 09:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232866AbhBCIzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 03:55:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232591AbhBCIzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 03:55:13 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 090F1C061573
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 00:54:33 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id z21so16860970pgj.4
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 00:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=WW/1oS09fe/Xpd3aL+qLkZRimgVwhSlQWA9NjUqCCDs=;
        b=tsiGxnr4ZbGRxCopqBElLcEJR5glvTc8oS3Kf01N1EnkRrJmqWNmiHoAycDryrJ/wa
         hDLgf+hKNkW4txkp6/TygVUrNN5KNfMfOiTgYKz6cC8VPc9PKnSluny0B0ojWTTusGR8
         SHKs7MoAnKaXInMiGInLPDU3frXNYVKYWVXKuu1UiqOcAfeRQum8fvyEK9O2+77eTRBP
         UafCXehXalGob+jIxorPLDXxV2PwCKmdNHjzAJhifhB9bMaml0sWT0cxHDQbdAS0DVzm
         f8a7p6HSP0L2XUc5hfLvTdTtmCS7GfSxmifcvqf0iMFshyzdchnAZV9W1NbgvL9vfk2i
         2Scg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=WW/1oS09fe/Xpd3aL+qLkZRimgVwhSlQWA9NjUqCCDs=;
        b=lMOrF7P6GHmWuCrCX8qa1vhTnkaX2+hLtFV7nBh5xP08cfzpshMuQFGagD21m0GkH6
         uqtGO3qZPX+62tfeJ2bBoZBGC9M7zoFid4jVhk0ONt6kGLJO4JKvcvxuw7ZIHkAdKMUj
         ekHUEl/R1aZsKlirtLAbAL7Wf8NeQlP4ARZTknDfk05sFyl+u88xHFSOz+9Uc5WRTUg6
         PKHWwafc/YEgtOO2ng5i0BPa288y88y7Drc604IwsIoIMnCd9FGx60TDtD3v8Yo99Jrf
         bcjiynuDdQoMN0UldDvTVKz5MrCklqEI/N2+hpi26byMgs8d18hEQfSs0o9/vYkiVP6w
         /cVQ==
X-Gm-Message-State: AOAM5307ndnPN9hyb+vO1pUAhnCF77f+DvbUNFJybEd72O5dQeqjxS97
        5DZHWqealRQgXViXRh5LtBc8QEo9MHoT4g==
X-Google-Smtp-Source: ABdhPJy02I/4wXm7EfY5zxtIrx2PnTi6psPAXlp//R6x2HgSqXlISuBtKXJy7MZKA2ppRUL9AMLmyQ==
X-Received: by 2002:a63:cd08:: with SMTP id i8mr2500398pgg.425.1612342471881;
        Wed, 03 Feb 2021 00:54:31 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o13sm523425pfp.27.2021.02.03.00.54.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Feb 2021 00:54:31 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        pabeni@redhat.com, Willem de Bruijn <willemb@google.com>,
        Martin Varghese <martin.varghese@nokia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        David Howells <dhowells@redhat.com>
Subject: [PATCHv5 net-next 0/2] net: enable udp v6 sockets receiving v4 packets with UDP
Date:   Wed,  3 Feb 2021 16:54:21 +0800
Message-Id: <cover.1612342376.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, udp v6 socket can not process v4 packets with UDP GRO, as
udp_encap_needed_key is not increased when udp_tunnel_encap_enable()
is called for v6 socket.

This patchset is to increase it and remove the unnecessary code in
bareudp in Patch 1/2, and improve rxrpc encap_enable by calling
udp_tunnel_encap_enable().

v1->v4:
  - See patch 1/2.
v4->v5:
  - See patch 2/2.

Xin Long (2):
  udp: call udp_encap_enable for v6 sockets when enabling encap
  rxrpc: call udp_tunnel_encap_enable in rxrpc_open_socket

 drivers/net/bareudp.c    | 6 ------
 include/net/udp.h        | 1 +
 include/net/udp_tunnel.h | 3 +--
 net/ipv4/udp.c           | 6 ++++++
 net/ipv6/udp.c           | 4 +++-
 net/rxrpc/local_object.c | 7 ++-----
 6 files changed, 13 insertions(+), 14 deletions(-)

-- 
2.1.0

