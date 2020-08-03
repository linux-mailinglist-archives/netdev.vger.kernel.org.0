Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C72E23A975
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 17:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgHCPe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 11:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726511AbgHCPe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 11:34:56 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCAE2C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 08:34:56 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id lx9so11870pjb.2
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 08:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=gLUrVb6fxflKlvAlZUcaIiwSuEfwUbLcDbN7BzzKqGA=;
        b=RpX/RSTQkXqSeAFoi/pJM7IEWQdwaAtBpJ/GE95ye30zS/Q2bfRpCpO3D7EfTyF9MD
         gtGLxE9zL/4DdNgHIvm7pCzjtlQHCCx5Usg1tbEVG9YK452Fd6KmhXVg+g9uIqdGtlTk
         j6G7w96S+VnUQH70gy3PlrNqhSlCq+DnI+E63LKbi69DfsyNjt0AGFVumSIPAHAueW6L
         HDeK536pok1A/bnG8YDOmTGXn12XL7jpg8hlEpfVYpKKGD1K2hfhwLt9MWQNs280cTl6
         aouMK7EzsHpyJy2RHO0GTKQIZvCYcnhPRY9OatUKQzc40qzdGbZJbjQ/MdQVOwmG9a18
         3zdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=gLUrVb6fxflKlvAlZUcaIiwSuEfwUbLcDbN7BzzKqGA=;
        b=iv08Q6HvOwyEDjcOl3m5bxfWz+Vl2t6HYSdh3LGAgHantpUZ/b7bCHE900C1xi06tr
         l+Om/ABFb71dNqulczimx4QnggumNTBteXOAmqYmyxSo7de0AuGw6aqvyHTDTzWzFIS+
         V/8LKmlyb4DYUos9dTumOWdNW6B7UbyJaOlpreG/fV8dH/7NADOsh4BaVaT8kgcw5PKD
         GUzDNUawzVHWbY7/aQ0DIDVG/pYyNuZSJPByKXZYla86t4QyzKVJPmcIz8Kn8AXYlq+G
         /8j/nBrnkLsGx5SeKTdfpFVQP3lYfPps5QDJYAj5K7UOczUzrxWaj5Ha5GgkYGKu+zvZ
         fPKw==
X-Gm-Message-State: AOAM531ZICUp/FR+mbe+TqU1UgUoZLft+bkjiCY7ZQvou7hccbL9k/+n
        maq2TY/q0j3GVzMskGinqz8cqg0Ompc=
X-Google-Smtp-Source: ABdhPJx4ZnsTIHhcCP4u+MtEz8eyZE+rVNYQ7w0b8vU7QR8LK+F9gkCg/oKXqummosn0PQlvhWRbDw==
X-Received: by 2002:a17:90a:9b88:: with SMTP id g8mr17880562pjp.143.1596468896032;
        Mon, 03 Aug 2020 08:34:56 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j13sm19918184pfa.149.2020.08.03.08.34.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Aug 2020 08:34:55 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH net 0/2] net: fix a mcast issue for tipc udp media
Date:   Mon,  3 Aug 2020 23:34:45 +0800
Message-Id: <cover.1596468610.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1 is to add a function to get the dev by source address,
whcih will be used by Patch 2.

Xin Long (2):
  ipv6: add ipv6_dev_find()
  tipc: set ub->ifindex for local ipv6 address

 include/net/addrconf.h |  2 ++
 net/ipv6/addrconf.c    | 39 +++++++++++++++++++++++++++++++++++++++
 net/tipc/udp_media.c   |  8 ++++++++
 3 files changed, 49 insertions(+)

-- 
2.1.0

