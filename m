Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81DB45CF0E
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 14:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbfGBMFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 08:05:04 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45637 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726252AbfGBMFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 08:05:04 -0400
Received: by mail-wr1-f66.google.com with SMTP id f9so17459830wre.12
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 05:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z8dZZIPpeZ1Qw73KcIU6q0OGE71quMthD7zEmsELvnY=;
        b=WaX5g02y0EPpCZNkzhaCztvLQ4Ru36Q/9DnYFyUVnT0Lt2Ro7A+fs9wicsQPbmRCRB
         4CRVtdcJRyW27MwQnkNt+FgU/9GS5MdEme98/kchdypCjlY0t9uaTr0Lrop/lxd1XHgk
         erq8PbI4Sm3m38nhYGFMzmqGR5/S8/Jvpj4CQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z8dZZIPpeZ1Qw73KcIU6q0OGE71quMthD7zEmsELvnY=;
        b=XpYkc0WEuDwsbWW92tWFOfj5SHJepiHie/5X37LvBk2U5YH0N+WSPDHah62MjNANQE
         Pi/Z0SQN/D0lx2VPPwuNIHuGat5r87ym8oS8mua/r2mkxE9a4lSId8F5ro3yGK1tLAZ9
         zhFOlXaUKYjSxjOD5g6CmZzhDYEK3IRqRGBU/TWMnZQ79eQKOVWr1w45Goty9FlbyI5z
         LEVPckmP+9203hnbhBbwupxrYHMzZUtvnjSS7EbkG3zVFscpaax9YWC1L+KyP4Rvcw3y
         J3XJD73Gtf00ApZokbkFCGHyppKk3WMTje/uAb/YQTCW9qGwzY9KfmmZUpsF8zoRkXlg
         J0yw==
X-Gm-Message-State: APjAAAX8YCpiVZwgOs3YkRQu2pSUdUZdcmQTTJe9iMEvFSA93gMX3BJJ
        5kR/KrW+M1JYEojxU7XcgeHSZG8mJvU=
X-Google-Smtp-Source: APXvYqxSvvR0qkSlyguGfRbfByRydHf5S7LBqHmC+qbtMiQVH/XrqNL4opuMaag4Wu6VRzDleQPELg==
X-Received: by 2002:a05:6000:11ca:: with SMTP id i10mr3816459wrx.56.1562069102074;
        Tue, 02 Jul 2019 05:05:02 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x5sm2542655wmf.33.2019.07.02.05.05.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 05:05:01 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        martin@linuxlounge.net, bridge@lists.linux-foundation.org,
        yoshfuji@linux-ipv6.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net 0/4] net: bridge: fix possible stale skb pointers
Date:   Tue,  2 Jul 2019 15:00:17 +0300
Message-Id: <20190702120021.13096-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
In the bridge driver we have a couple of places which call pskb_may_pull
but we've cached skb pointers before that and use them after which can
lead to out-of-bounds/stale pointer use. I've had these in my "to fix"
list for some time and now we got a report (patch 01) so here they are.
Patches 02-04 are fixes based on code inspection. Also patch 01 was
tested by Martin Weinelt, Martin if you don't mind please add your
tested-by tag to it by replying with Tested-by: name <email>.
I've also briefly tested the set by trying to exercise those code paths.

Thanks,
 Nik

Nikolay Aleksandrov (4):
  net: bridge: mcast: fix stale nsrcs pointer in igmp3/mld2 report
    handling
  net: bridge: mcast: fix stale ipv6 hdr pointer when handling v6 query
  net: bridge: don't cache ether dest pointer on input
  net: bridge: stp: don't cache eth dest pointer before skb pull

 net/bridge/br_input.c     |  8 +++-----
 net/bridge/br_multicast.c | 23 +++++++++++++----------
 net/bridge/br_stp_bpdu.c  |  3 +--
 3 files changed, 17 insertions(+), 17 deletions(-)

-- 
2.21.0

