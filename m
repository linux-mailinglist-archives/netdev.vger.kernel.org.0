Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD128D65E
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 16:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbfHNOkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 10:40:35 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50936 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfHNOke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 10:40:34 -0400
Received: by mail-wm1-f68.google.com with SMTP id v15so4826501wml.0
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 07:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MHZKJD3O96CYycYAww/OgcUVDON2lbDy33AAvVQm3jI=;
        b=NldIB9N9PO1nliz1xNKKn/2NA1LHMamHG/sVz+FBW6flX38Ti9erpdA39bqvIAhaaW
         DuP5LYLzNtdaPR3X6q3oWpJaGqIihzMqJh2NAjmwVmfM6tOKwgiQRlmoawQejARS0/Rt
         jTPH+TV7U693szIuaT+lDyi89FKjdcodYZVMI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MHZKJD3O96CYycYAww/OgcUVDON2lbDy33AAvVQm3jI=;
        b=cqc1qml5STU/AAoaFZADuUm9EEBg+3qbdDOHxPVV1JrJNyO3mrHYqx2RfQIKg3zDzU
         LXaNQR4vropx2EHR9QPNc2By2Nh2qP1niQjbH0nFGDQqxwAtrWBGtY8ucrTQwEYjS96A
         mZv0tdAyvv2UlIQ3cH/T0HuFABTaU4ZC7WuZkSYz8DjE3/ORxahiZTHY+Zx3Cz0UqfLx
         0S4Fkua+rWDsSK9LV0P4dAi8ITsvreQAYj9R5ynx/m/FqXeGavm/MbpaQx1utQg0HYW1
         yFcBQ1/iO0EpVHhKYSACX8lH9fB5dadYv8dO1uxuoeAVjvZK6CzbL4YdIeRvzoel1zVu
         eWjA==
X-Gm-Message-State: APjAAAV8L/JBzj+e9vNHRFlnWmGEdmb9NYy2rQdOPOGzE4C/JPTaHC9Z
        86vo1sLJCPY5HbR22Y4OJ3ZoJaXE5bg=
X-Google-Smtp-Source: APXvYqxuxacPXxY2kwnWoW7pIax7IPnwnDm71EHQV5QsniPNYeKCwOPX2FVU9xWiO15yMmupQeoyyg==
X-Received: by 2002:a1c:4d0c:: with SMTP id o12mr9176595wmh.62.1565793632453;
        Wed, 14 Aug 2019 07:40:32 -0700 (PDT)
Received: from wrk.www.tendawifi.com ([79.134.174.40])
        by smtp.gmail.com with ESMTPSA id o8sm3383874wma.1.2019.08.14.07.40.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 14 Aug 2019 07:40:31 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 0/4] net: bridge: mdb: allow dump/add/del of host-joined entries
Date:   Wed, 14 Aug 2019 17:40:20 +0300
Message-Id: <20190814144024.9710-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
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

Thanks,
 Nik

Nikolay Aleksandrov (4):
  net: bridge: mdb: move vlan comments
  net: bridge: mdb: factor out mdb filling
  net: bridge: mdb: dump host-joined entries as well
  net: bridge: mdb: allow add/delete for host-joined groups

 net/bridge/br_mdb.c       | 171 +++++++++++++++++++++++++-------------
 net/bridge/br_multicast.c |  24 ++++--
 net/bridge/br_private.h   |   2 +
 3 files changed, 133 insertions(+), 64 deletions(-)

-- 
2.21.0

