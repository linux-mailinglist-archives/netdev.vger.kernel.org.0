Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09365441F7A
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 18:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbhKARpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 13:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbhKARpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 13:45:43 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072AFC061714
        for <netdev@vger.kernel.org>; Mon,  1 Nov 2021 10:43:10 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id s5so5495402pfg.2
        for <netdev@vger.kernel.org>; Mon, 01 Nov 2021 10:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wl9TvW+MaRuKthAGyDWCvKh7z0gu1qFuwm+YrPhzOCA=;
        b=YnGFInFZ+PCvYp4/+azHfDff9hAXIRyrnqBu6Fio89PAQ59ufoNB+W/f5LqRpCtTv0
         qK0YJ/7XO6Cf47oVuqDS5y2PVoOkAlKkG/BXrwrqA9LxA5x1810mjsG1vCxraScDt9ps
         51YCeHNmjWm2zEsz5roi4Xhhp5ic9Crts26mNGoQVL4lx62FxZ8Rr568lA1P44OEfiBR
         zWAWaRQri9Xe3sRj4vXXnZktdg7Z3K4RBFnRDXQt1gMJw+5SJGmkZEE3feI40d6vdehi
         lUwTgMSeBCxf9/pDE2tiF+zF49x9mTbVm+k5yPI+ObwzQKvhyuoiuS+WBdyIgyiNLiX3
         fXxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wl9TvW+MaRuKthAGyDWCvKh7z0gu1qFuwm+YrPhzOCA=;
        b=gbOEvdAbk9KWumI5pEHBH46EfMkSy2xzvn2ANtKxc4aKpHSP0m0CfvXE4O4DHYiyeG
         MgR0jmeOe51K9V3+H/ESue2YjsH7VAHJLtXWzS2wDOuk8kg8+0SwpxV9/b4i1rtAAld4
         XV3r5fXgsAXZo/g1a31jd8M3H0+bF+v3tYKjlAP5mz1Ocs6BlisOf4uf4hNNgZ163VxU
         VPhlQFPGpFpTk5SLIeSyv0Fu/FAhvLiIXrXOM5Al5f4Xb2bsSH/VExN23Lh9Fi+2ma90
         UFQ/BtQL8R3fTzz0T0IftR6wz50lCHqrvPaQ9oslDwYWV/Xi4LBYLBjEspcbAzdK/OJh
         ivkg==
X-Gm-Message-State: AOAM532/Jqqr0NGbRlCs9/zF6QNAfR9S5kweLO3lsq0yoa9Fykov7SLz
        SKgcoi8PnkieUTwoVQntFEts3x7pI2k=
X-Google-Smtp-Source: ABdhPJzFe9A1caJUqQeJYXgNe3SJYNK+/lWnMqMF7RxSSO9E3XtE8RqwlDsTOt0R52ebFkbP2rYQyQ==
X-Received: by 2002:a63:d2:: with SMTP id 201mr22990848pga.400.1635788589309;
        Mon, 01 Nov 2021 10:43:09 -0700 (PDT)
Received: from localhost.localdomain ([50.45.187.22])
        by smtp.gmail.com with ESMTPSA id b6sm13980592pfv.204.2021.11.01.10.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 10:43:08 -0700 (PDT)
From:   James Prestwood <prestwoj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, roopa@nvidia.com,
        daniel@iogearbox.net, vladimir.oltean@nxp.com, idosch@nvidia.com,
        nikolay@nvidia.com, yajun.deng@linux.dev, zhutong@amazon.com,
        johannes@sipsolutions.net, jouni@codeaurora.org,
        James Prestwood <prestwoj@gmail.com>
Subject: [PATCH 0/3] Make neighbor eviction controllable by userspace
Date:   Mon,  1 Nov 2021 10:36:27 -0700
Message-Id: <20211101173630.300969-1-prestwoj@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v1 -> v2:

 - It was suggested by Daniel Borkmann to extend the neighbor table settings
   rather than adding IPv4/IPv6 options for ARP/NDISC separately. I agree
   this way is much more concise since there is now only one place where the
   option is checked and defined.
 - Moved documentation/code into the same patch
 - Explained in more detail the test scenario and results

v2 -> v3:

 - Renamed 'skip_perm' to 'nocarrier'. The way this parameter is used
   matches this naming.
 - Changed logic to still flush if 'nocarrier' is false.

v3 -> v4:

 - Moved NDTPA_EVICT_NOCARRIER after NDTPA_PAD

v4 -> v5:

 - Went back to the original v1 patchset and changed:
 - Used ANDCONF for IN_DEV macro
 - Got RCU lock prior to __in_dev_get_rcu(). Do note that the logic
   here was extended to handle if __in_dev_get_rcu() fails. If this
   happens the existing behavior should be maintained and set the
   carrier down. I'm unsure if get_rcu() can fail in this context
   though. Similar logic was used for in6_dev_get.
 - Changed ndisc_evict_nocarrier to use a u8, proper handler, and
   set min/max values.

v5 -> v6

 - Added selftests for both sysctl options
 - (arp) Used __in_dev_get_rtnl rather than getting the rcu lock
 - (ndisc) Added in6_dev_put
 - (ndisc) Check 'all' option as well as device specific

v6 -> v7

 - Corrected logic checking all and netdev option

Resend v7:

 - Fixed (hopefully) the issue with CC's only getting the cover letter

v7 -> v8:

 - Added selftests for 'all' options

James Prestwood (3):
  net: arp: introduce arp_evict_nocarrier sysctl parameter
  net: ndisc: introduce ndisc_evict_nocarrier sysctl parameter
  selftests: net: add arp_ndisc_evict_nocarrier

 Documentation/networking/ip-sysctl.rst        |  18 ++
 include/linux/inetdevice.h                    |   2 +
 include/linux/ipv6.h                          |   1 +
 include/uapi/linux/ip.h                       |   1 +
 include/uapi/linux/ipv6.h                     |   1 +
 include/uapi/linux/sysctl.h                   |   1 +
 net/ipv4/arp.c                                |  11 +-
 net/ipv4/devinet.c                            |   4 +
 net/ipv6/addrconf.c                           |  12 +
 net/ipv6/ndisc.c                              |  12 +-
 .../net/arp_ndisc_evict_nocarrier.sh          | 220 ++++++++++++++++++
 11 files changed, 281 insertions(+), 2 deletions(-)
 create mode 100755 tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh

-- 
2.31.1

