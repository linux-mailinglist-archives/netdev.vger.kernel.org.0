Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E84B191037
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 13:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbfHQLW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 07:22:29 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33162 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfHQLW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 07:22:28 -0400
Received: by mail-wr1-f67.google.com with SMTP id u16so3984840wrr.0
        for <netdev@vger.kernel.org>; Sat, 17 Aug 2019 04:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uGqrtStYIQ/gG4009jwt9tOaQZGkVkkXlx2NS4SiirU=;
        b=ZtM9408P+KgDletkOKWAlAdeR4QyapJg85TBbsvBLmOlmikx7HU4TLtj8fWPtGO5pb
         wGMfntiiKHX6RnFeLHAYEQ+BpM40BftYYtJVu8xKz6M6252kQAlCSjOIxZyTvPCES3fU
         5Az6CwpXff6ksO92Mc5WM8UdDiWlhJHqzbvKo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uGqrtStYIQ/gG4009jwt9tOaQZGkVkkXlx2NS4SiirU=;
        b=cESuXC/eTl4xY1DDCaH4wO1XPFJK4exo4xH7SXaYhmOZf8Y5XH2Wv9DUjTcJ1ziKq1
         tVFUCS6eDy3DTnTqsI3PF91BeWQRT2FW0EKEyfS8yCNPbGpf4RSuwKggVE37GkdhOvER
         jsYtKKFDGGNQ546PTwZkmyu3XwAhrdkBkYAGGbK4kVTIhKIPivYVIiPIQivjI9sqTh7h
         0uQQrBnLpWc2cwijTSKvFBAoqQgBC1Ckw1ZARlwkvJWb9YryrlfHL7BisbwswuSK0/40
         ClKqtBCQK9vNhspSjEClESyYqN6i9YO24fYrAyOqLNF6cPFta42rCQtixBGdP9Lp4BIF
         tdBQ==
X-Gm-Message-State: APjAAAUHOvEzeyAyw6h3+KPKdjg8obb6kKJpl3nv8Fqz3O+VqFp/SgNK
        tlz7Z0Y/wKL78YUsJD8tgASAA83XUDpHMA==
X-Google-Smtp-Source: APXvYqzUUe6LtII18GjSQtJq3C+pwGe2SCorDdpnI4svQg2Ve5qN2A5IMizZYMhJfZASKI5aFExSxw==
X-Received: by 2002:a5d:6a45:: with SMTP id t5mr7938283wrw.228.1566040946127;
        Sat, 17 Aug 2019 04:22:26 -0700 (PDT)
Received: from debil.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id o14sm13900244wrg.64.2019.08.17.04.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Aug 2019 04:22:25 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v3 0/4] net: bridge: mdb: allow dump/add/del of host-joined entries
Date:   Sat, 17 Aug 2019 14:22:09 +0300
Message-Id: <20190817112213.27097-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190816.130417.1610388599335442981.davem@davemloft.net>
References: <20190816.130417.1610388599335442981.davem@davemloft.net>
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

v3: fix compiler warning in patch 04 (DaveM)
v2: change patch 04 to avoid double notification and improve host group
    manual removal if no ports are present in the group

Thanks,
 Nik


Nikolay Aleksandrov (4):
  net: bridge: mdb: move vlan comments
  net: bridge: mdb: factor out mdb filling
  net: bridge: mdb: dump host-joined entries as well
  net: bridge: mdb: allow add/delete for host-joined groups

 net/bridge/br_mdb.c       | 175 +++++++++++++++++++++++++-------------
 net/bridge/br_multicast.c |  30 +++++--
 net/bridge/br_private.h   |   2 +
 3 files changed, 142 insertions(+), 65 deletions(-)

-- 
2.21.0

