Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34C072061E9
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392440AbgFWUwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 16:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392864AbgFWUri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 16:47:38 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA03AC061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 13:47:38 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id t194so135491wmt.4
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 13:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uv7xIdydepaKJnDBGkm+1SZ9hRYqS6as0NEV32nUerQ=;
        b=WhsCKEmAKCzXCOj5ZmN9FqMRB9Q8KlNOSPEc/KIIXN54z54HJuPthWufBdup+uEi/f
         4nmei+myBeh/U+9F6FLuklNrS8dtyXKu3yZ/SKs0wjxiUj1WQJNEctBrV/5U31E+43Jg
         hmVLHjfyo2D2hPcHJkpE8QOHpIxH+QTLzGl0g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uv7xIdydepaKJnDBGkm+1SZ9hRYqS6as0NEV32nUerQ=;
        b=SUCqro2P2cu6eeJG4ZNv7H135Z2XLLYWRvjxe5h2V/Wt7hBMLyc9xuMkDsAnNAHsQq
         /OihuRM1YtLhaloBRGRpxzWXFJc5SshiONwA35w+sZ95mE4mmPMcptkzT/0mijGt02Hn
         VSXjveL6XZQC0yru2GO1KWhdidHlRQwmPtv2UazPpzvp+doO+lyX2R5qprATpJRKKpR+
         zk5p5QtdlYU/ly1n5uhxk9ywAW/0znKIbrJn7tLUr4h4feOg6gSEhI6MF9mM3uKPavQi
         a0v/4FU3UzyGCTDvlGp1cdnlghXHx+YuTiKtMEXhXT4gvYNkRelAllxLHkFcZtpebHnv
         kHgA==
X-Gm-Message-State: AOAM530/APJdzF2PhpolaOP/M9bR5OPO9qzl1bLOlotISd4hOsvGhGEA
        qApEQEHWbsjPH3us0gWCYHFO9E+KPEg84w==
X-Google-Smtp-Source: ABdhPJxrWJwMA26TcZVW0vU+55iD/EwW7TSoP0U2CzumQfe0/eXJmp+9PiBoCnMMvtgl/1n555WzcQ==
X-Received: by 2002:a05:600c:24c:: with SMTP id 12mr26814284wmj.28.1592945257157;
        Tue, 23 Jun 2020 13:47:37 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id j6sm5686924wmb.3.2020.06.23.13.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 13:47:36 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, anuradhak@cumulusnetworks.com,
        davem@davemloft.net, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 0/4] net: bridge: fdb activity tracking
Date:   Tue, 23 Jun 2020 23:47:14 +0300
Message-Id: <20200623204718.1057508-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
This set adds extensions needed for EVPN multi-homing proper and
efficient mac sync. User-space (e.g. FRR) needs to be able to track
non-dynamic entry activity on per-fdb basis depending if a tracked fdb is
currently peer active or locally active and needs to be able to add new
peer active fdb (static + track + inactive) without refreshing it to get
real activity tracking. Patch 02 adds a new NDA attribute - NDA_FDB_EXT_ATTRS
to avoid future pollution of NDA attributes by bridge or vxlan. New
bridge/vxlan specific fdb attributes are embedded in NDA_FDB_EXT_ATTRS,
which is used in patch 03 to pass the new NFEA_ACTIVITY_NOTIFY attribute
which controls if an fdb should be tracked and also reflects its current
state when dumping. It is treated as a bitfield, current valid bits are:
 1 - mark an entry for activity tracking
 2 - mark an entry as inactive to avoid multiple notifications and
     reflect state properly

Patch 04 adds the ability to avoid refreshing an entry when changing it
via the NFEA_DONT_REFRESH flag. That allows user-space to mark a static
entry for tracking and keep its real activity unchanged.
The set has been extensively tested with FRR and those changes will
be upstreamed if/after it gets accepted.

Thanks,
 Nik


Nikolay Aleksandrov (4):
  net: bridge: fdb_add_entry takes ndm as argument
  net: neighbor: add fdb extended attribute
  net: bridge: add option to allow activity notifications for any fdb
    entries
  net: bridge: add a flag to avoid refreshing fdb when changing/adding

 include/uapi/linux/neighbour.h |  24 +++++++
 net/bridge/br_fdb.c            | 127 ++++++++++++++++++++++++++++-----
 net/bridge/br_private.h        |   4 ++
 net/core/neighbour.c           |   1 +
 4 files changed, 139 insertions(+), 17 deletions(-)

-- 
2.25.4

