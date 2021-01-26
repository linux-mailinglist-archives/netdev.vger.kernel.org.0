Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E39305BE5
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 13:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S314006AbhAZWyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 17:54:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728664AbhAZFLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 00:11:38 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6691C06174A
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 21:10:58 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id e9so9187575plh.3
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 21:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Ymp0vyRLDjL3vzeLl2sh/mrw+RMUkWYZ1Z84MCBnJ4E=;
        b=EnOglYULSi6h0BhZze24P6z+hgssNMxKpoKKQJ30L8VeR7oZIhvH7vR1OEOpCpejXU
         mbCADO3XwTa0CcfKRZy4HrPe2mAMXLG0lhvjLdrqfxqwm/R4TgqaImWxK4BwWdP6FtT6
         ORrtGkpS7REolIWL8t+ejhKBeebTaMhUn0cPKLutd2fuzK06sLQWHiDVVMNuMIFXn4Kf
         ZkOTqWBk9S7V8W+/JvupZtgLOvq0z++6WGa/uUSvMoKbYN1cRfHqJOCGLBp1lLavqaOl
         NuavdUXdy70beYEZFqoN7kidfG1rtLTbmwX0vBHdITmiVEN8zlUe+LH0lLlo8zDxfDam
         xkQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Ymp0vyRLDjL3vzeLl2sh/mrw+RMUkWYZ1Z84MCBnJ4E=;
        b=TaL2/O075PBuQdrIonzuSIQqq2P4Hrc0lI0Y3L3Rb2Rij1HlDBtqWkaq9aGi/YOh8W
         uNjLDiLVlXJ4Bs2sjVlRZnsUOJH9aGGtP9AyimXE3Hm2Iudy0rxDVGV1xcEc3R2r0wWg
         PyU6M1iJvy0kbsKJH9b/KItm4Gw2fPkFRSKrr6XK+Jio1+cgtzZAPApmmpVWgjSp/8ox
         xy3RcGiiyJafJP/aSbznqc83V+XvkQZoCCAMTC3ipnElDD9uCtz40pdJbOt17HpmHiv3
         E5kAx/WCZk3931iWW+JZG9rAACPI1mbi9m6DkfBqWO3aWozQw++2LRGZlmeCxYGZakcK
         VT4Q==
X-Gm-Message-State: AOAM532tlS6X8n4U3OYkcowqQksOQLXIUubA+3G9MoA8dgVPoMDE5S+V
        LuZxb451gDa1qejrpE3vzkuHdsXii1pK8g==
X-Google-Smtp-Source: ABdhPJw4cfEM7L052upYs6TKtUPK8GMdsRZQdrth9c/DUPlDdWDAgXV3GZXM0l39EfQiH51L1eWwvQ==
X-Received: by 2002:a17:90a:3ec3:: with SMTP id k61mr4143459pjc.126.1611637858171;
        Mon, 25 Jan 2021 21:10:58 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s21sm922239pjz.13.2021.01.25.21.10.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Jan 2021 21:10:57 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        pabeni@redhat.com, Willem de Bruijn <willemb@google.com>,
        Martin Varghese <martin.varghese@nokia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        David Howells <dhowells@redhat.com>
Subject: [PATCHv4 net-next 0/2] net: enable udp v6 sockets receiving v4 packets with UDP GRO
Date:   Tue, 26 Jan 2021 13:10:47 +0800
Message-Id: <cover.1611637639.git.lucien.xin@gmail.com>
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

Xin Long (2):
  udp: call udp_encap_enable for v6 sockets when enabling encap
  rxrpc: call udp_tunnel_encap_enable in rxrpc_open_socket

 drivers/net/bareudp.c    | 6 ------
 include/net/udp.h        | 1 +
 include/net/udp_tunnel.h | 3 +--
 net/ipv4/udp.c           | 6 ++++++
 net/ipv6/udp.c           | 4 +++-
 net/rxrpc/local_object.c | 6 +-----
 6 files changed, 12 insertions(+), 14 deletions(-)

-- 
2.1.0

