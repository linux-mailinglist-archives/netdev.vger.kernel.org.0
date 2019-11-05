Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 030FCEF6EC
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 09:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388125AbfKEILU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 03:11:20 -0500
Received: from mail-lf1-f47.google.com ([209.85.167.47]:46470 "EHLO
        mail-lf1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388021AbfKEILU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 03:11:20 -0500
Received: by mail-lf1-f47.google.com with SMTP id 19so9211253lft.13
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 00:11:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6xSFE4g0gY9czO8TwiEEGqsWaa81e8Ul+cCq6vuH+IA=;
        b=wlQlXCYO+/9EbApNjgMhjYp9wpSy75ZPuYAWB8VKQKBX7ARXR1OVtM58CSWg0CoQU5
         zxlf1du+2ubetE4QzVTTqJ7rA/hEW3tfRgbKNqUUphn7sxwvWKN+FW0yjcoW/ci4YsmL
         y3c7LU5tFYjt4UjzxyjTIJ+W2aWft+eBoQDUHYtlLeT1RppLXPiK/61eaI1IglOOh/IN
         KJefgymntKFYJZbccwXqXePOjo9Rh1XXv11BDb9QKGDMTFeaG/cbIjVnh3A7O152LqcG
         Abgha4kFeUQPqGC9aT6lKJyAw82Op9hjBwJbHV4D51QkLnjJLpyCFPykLSAfGupH7fZT
         v5ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6xSFE4g0gY9czO8TwiEEGqsWaa81e8Ul+cCq6vuH+IA=;
        b=AUOC5nyzKcMIJ/ZmJpCcx02XK+KfATVviXay8X1a3BWrJ5d+6t2nkOcjW8vr6wqGsB
         iIrilYxgjSIs3X5vYNLiiGJfePxPuJxjN4Fnu7mla2135p1mk4rUl0P+55EoKhgQjwRv
         +Wy4wYD9B/qZ2rTc2zCDdQ0fX3zNbnAjOmMiu1n8b4Gd3Y0S977RcFCND6nSQ+xTlCs/
         85tjFU9lEUM6bw4ko/TCLEkLdRM1A6mQEQiL54eF4eBKjzDYlPOlaCaCwRJiJEzCOwcQ
         6EGypaAHbxq68HeeYFavm5FQiiwuu57MwxXr8tp2bXn2+adBLqdsS1esGKN2Tsf/1Gpp
         MSMQ==
X-Gm-Message-State: APjAAAVc8xlhB+ss2ri7giNszgKsnddYgrSJ70F7hMOOFGtwSWEboQa5
        3YX1Y4qUD3dGD43Z2X6kVeewyw==
X-Google-Smtp-Source: APXvYqy0cgx16CNi5YxZgqZqXkti4pby1AXyKJj0oZxklimaDslnxqWQgKMKxBaqMNz/fUaPppPd2Q==
X-Received: by 2002:a19:6a03:: with SMTP id u3mr17885682lfu.190.1572941478028;
        Tue, 05 Nov 2019 00:11:18 -0800 (PST)
Received: from mimer.lulea.netrounds.lan ([195.22.87.57])
        by smtp.gmail.com with ESMTPSA id m7sm7275986lfp.22.2019.11.05.00.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 00:11:17 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     nicolas.dichtel@6wind.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH 0/5] Add namespace awareness to Netlink methods
Date:   Tue,  5 Nov 2019 09:11:07 +0100
Message-Id: <20191105081112.16656-1-jonas@norrbonn.se>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, Netlink has partial support for acting outside of the current
namespace.  It appears that the intention was to extend this to all the
methods eventually, but it hasn't been done to date.

With this series RTM_SETLINK, RTM_NEWLINK, RTM_NEWADDR, and RTM_NEWNSID
are extended to respect the selection of the namespace to work in.

/Jonas

Jonas Bonn (5):
  rtnetlink: allow RTM_SETLINK to reference other namespaces
  rtnetlink: skip namespace change if already effect
  rtnetlink: allow RTM_NEWLINK to act upon interfaces in arbitrary
    namespaces
  net: ipv4: allow setting address on interface outside current
    namespace
  net: namespace: allow setting NSIDs outside current namespace

 net/core/net_namespace.c | 19 ++++++++++
 net/core/rtnetlink.c     | 79 ++++++++++++++++++++++++++++++++++------
 net/ipv4/devinet.c       | 56 ++++++++++++++++++++--------
 3 files changed, 127 insertions(+), 27 deletions(-)

-- 
2.20.1

