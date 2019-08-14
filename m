Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB7C8DB6A
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729536AbfHNRFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:05:53 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:54045 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728457AbfHNRFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 13:05:50 -0400
Received: by mail-wm1-f41.google.com with SMTP id 10so5204458wmp.3
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 10:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O2/HKTzuPQzXFYnOU04mpGq15x9OswvlZvuEDIRAAnQ=;
        b=V/SyXvw7xrd+MWLR/nh0fkmNxWZ/WQ8km4+6y9dvSkoeS0pJy984CiDAuOnYi5IVK4
         P7Kj4fZwZ5ak+jjhlnu18TVd69ejsSTikKhaDYHQSvHWOavQtMxyCcAjpJJodIWR4ljq
         MJ6F+WcRksuQezr5hpPx3Pj16nxVXikG2YLBI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O2/HKTzuPQzXFYnOU04mpGq15x9OswvlZvuEDIRAAnQ=;
        b=o39SVa33RK+xBnkSOOKlrcfhBuNpbl6pWj6t+1yIBsqqFfM10FMfEBDdMI0McrVazD
         nGH5mhIYQR955GyiihMHBRjxQRvLqKjSMZHDPR8vF5j1m/nK0i0mApEzLxaP0YdgToaG
         uwJMQasrV0JjLIZJxZHuqLVvIqOWP0W6353e8p2a9RYbmlhFlJ3vy7pUAhVVv91IsQvO
         JnUAtuRMKEcLoLw2C35NOKYmBBTQMmy9AwO7qD6zi1xCNQYDvAgQsOdyW9wA/j0zEqMa
         xSYRh6q2wqRcKtxVfGV4bga5ANEKWflSgqZd5cFfeFV7Ax4cNw8mjhBnJsysPYm+0/ZS
         Dp7A==
X-Gm-Message-State: APjAAAVPtWMY1qynl1dN65sSuKngRO3yiQYsKVMWRH5g7TNL++vvtSWk
        ltg9CrhXkyYc0Waos8/Zh+rEFMcTvAk=
X-Google-Smtp-Source: APXvYqyXSfM19Eb4tkyUfv1gY2xoc1LsvJX6UV935a0nB8a9WzTivi4eJj5ahgBUtNvNCiF4JlFnIQ==
X-Received: by 2002:a1c:6504:: with SMTP id z4mr142545wmb.172.1565802348437;
        Wed, 14 Aug 2019 10:05:48 -0700 (PDT)
Received: from wrk.www.tendawifi.com ([79.134.174.40])
        by smtp.gmail.com with ESMTPSA id c6sm332311wma.25.2019.08.14.10.05.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 14 Aug 2019 10:05:47 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v2 0/4] net: bridge: mdb: allow dump/add/del of host-joined entries
Date:   Wed, 14 Aug 2019 20:04:57 +0300
Message-Id: <20190814170501.1808-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <81258876-5f03-002c-5aa8-2d6d00e6d99e@cumulusnetworks.com>
References: <81258876-5f03-002c-5aa8-2d6d00e6d99e@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
This set makes the bridge dump host-joined mdb entries, they should be
treated as normal entries since they take a slot and are aging out.
We already have notifications for them but we couldn't dump them until
now so they remained hidden. We dump them similar to how they're
notified, in order to keep user-space compatibility with the dumped
objects (e.g. iproute2 dumps mdbs in a format which can be fed into
add/del commands) we allow host-joined groups also to be added/deleted via
mdb commands. That can later be used for L2 mcast MAC manipulation as
was recently discussed. Note that iproute2 changes are not necessary,
this set will work with the current user-space mdb code.

Patch 01 - a trivial comment move
Patch 02 - factors out the mdb filling code so it can be
           re-used for the host-joined entries
Patch 03 - dumps host-joined entries
Patch 04 - allows manipulation of host-joined entries via standard mdb
           calls

v2: change patch 04 to avoid double notification and improve host group
    manual removal if no ports are present in the group

Thanks,
 Nik

Nikolay Aleksandrov (4):
  net: bridge: mdb: move vlan comments
  net: bridge: mdb: factor out mdb filling
  net: bridge: mdb: dump host-joined entries as well
  net: bridge: mdb: allow add/delete for host-joined groups

 net/bridge/br_mdb.c       | 173 +++++++++++++++++++++++++-------------
 net/bridge/br_multicast.c |  30 +++++--
 net/bridge/br_private.h   |   2 +
 3 files changed, 141 insertions(+), 64 deletions(-)

-- 
2.21.0

