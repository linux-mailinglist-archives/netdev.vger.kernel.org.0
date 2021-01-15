Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E311C2F73B6
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 08:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731404AbhAOHa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 02:30:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727554AbhAOHa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 02:30:58 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D6FC061757
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 23:30:18 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id u4so4696600pjn.4
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 23:30:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=PyaZsW/cAOnYyFogOk//97UnJPSn3qTM6A08/9IUrrw=;
        b=CIPeVTqIcK+q5U07vbdgp74l0x7t+jnNKv1lWn8AAuqGqSKGN6MJww7jfNabAqPSo1
         0OrlfboYYXb/fKYJHVl2lCcgeV6sKROS8HLbN2jtA7iz2DFVH8olqaocOS8q9x7qetwy
         qO7pJmPLie8ajRnTh3pOnGSbijwSAzNSkRQJl9WQYZ6d9wXgrkRxpgtL4h7Sf5JEq4Wo
         6ViLDe4MHSA4y1c9fGXdKtwQr7MEDf0cIxqUHuRImANO3GzRsExLVDiyp5QW7uryouAj
         uZplME81xG1aExg+zFi6LRXwAcygnzRGp4SZt0yeMVS+HKfYLVuJAqQh7jrs0AtJJ1UU
         TZAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PyaZsW/cAOnYyFogOk//97UnJPSn3qTM6A08/9IUrrw=;
        b=j1UluqLNNw/d25zlstbz7A+4gqscwWUpy8idkmdepkT63YCSmvqdPqtmcZ57R+9Qis
         8dsOPK75Xqyl+5G/eEPXZRbpu9HJRCGd0mDa4pmEja9ExHqMCiKD0WxR9OD+zqoNhcNA
         UwuUne/TfGc1vz8je/ZglNeaDbL4c8/fxLXtqDmgF6HRM7CJvY+oDQoRB5oGZBCS5/gc
         gr/Ne6et5Yznshan+51fvJC91PSEnLS4bnDzrVh57yJTF3QbGvgJ0p9WZKR9tQ869aQU
         j4hcrsPk8u0tdIh/Z/12CAezEmKYivDxuBmA9/DRadfzHEhYzrHY5STBgYZUjRNZgvEk
         tbag==
X-Gm-Message-State: AOAM530wlrclAqFJ/HIXxWFHgVuBsCHA3LKJxBHe56BVxEkXeYwKjdW5
        mS0z1h+yToOmpbVHgJZYMCocE3bBklFhIQ==
X-Google-Smtp-Source: ABdhPJzVujo7i6rTLcPyBpQNgAvvosinsVKij+aUSdOAI7Ig4UveWuRzcIqC6sl5mx20U96baWqlhA==
X-Received: by 2002:a17:90a:301:: with SMTP id 1mr9334594pje.195.1610695817679;
        Thu, 14 Jan 2021 23:30:17 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z13sm7511451pjz.42.2021.01.14.23.30.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Jan 2021 23:30:17 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        pabeni@redhat.com, Willem de Bruijn <willemb@google.com>,
        Martin Varghese <martin.varghese@nokia.com>
Subject: [PATCHv2 net-next 0/2] net: enable udp v6 sockets receiving v4 packets with UDP GRO
Date:   Fri, 15 Jan 2021 15:30:07 +0800
Message-Id: <cover.1610695758.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, udp v6 socket can not process v4 packets with UDP GRO, as
udp_encap_needed_key is not increased when udp_tunnel_encap_enable()
is called for v6 socket. This patchset is to increase it and remove
the unnecessary code in bareudp.

v1->v2:
  - see Patch 1/2.

Xin Long (2):
  udp: call udp_encap_enable for v6 sockets when enabling encap
  Revert "bareudp: Fixed bareudp receive handling"

 drivers/net/bareudp.c    | 6 ------
 include/net/udp.h        | 1 +
 include/net/udp_tunnel.h | 3 +--
 net/ipv4/udp.c           | 6 ++++++
 net/ipv6/udp.c           | 4 +++-
 5 files changed, 11 insertions(+), 9 deletions(-)

-- 
2.1.0

