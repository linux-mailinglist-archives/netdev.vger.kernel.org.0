Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCFE97D6FC
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 10:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729770AbfHAILm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 04:11:42 -0400
Received: from mail-pf1-f179.google.com ([209.85.210.179]:45544 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729011AbfHAILl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 04:11:41 -0400
Received: by mail-pf1-f179.google.com with SMTP id r1so33584432pfq.12
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 01:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RnXYhAPH8Zh7QPHa4sqFs3QqK8k8vjvpC9+q1vty1RI=;
        b=lxLQpa7FO2vnEO1uWJSZ4lC8QY8O4Q9Nn6Ba34KDrcbk6cq231RDc6XqpH1jGoHvAT
         C5dt5PbzpGDV/DV3ERi45JKqNoyrJi1g/jlnoLOz4wYxfCxV4MtauGCTL7FFqlIBGGbe
         5DZbNDEu+jNJkh6HH/6/GNbIPTiWgHDW0llJfQcdl4HliYU79T3Lz4jcf3F9oa9/4Zkj
         ialhzwnKiNrcrDFV6ORTauBTqJPi8U/xSxlXH0oNSAZrpWbOyvKGI+K8wXKlKDGqIKlM
         QiM3XKntpzF41S7NCIgvzimcpq8CcqaPjSuCZ7OWoec82BS1MBfZkYv2SyYA7j87G+0N
         1hpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RnXYhAPH8Zh7QPHa4sqFs3QqK8k8vjvpC9+q1vty1RI=;
        b=XwFHnP/LjpA4nNghIXjHTLZpAqN2Zfl9Ndjcz2GxQd0NHACNjQ6rES3tQQcKE/Khuk
         560gIpIoptodtxM+KX7EX/UbCKbt8QKzHcw4eUupBTm87cVwIBeucci2L2aQTMVHdp4l
         UhHSowncJAIXqzsDNmzKdqjyp3fZ8ADpgY7ig0AGlmanFc0rVp4BHP2i+HWJ5Zn3LhNs
         VnliRQvxMfZ4+lYEx6Dpp/c9Im0k1nMkhhMkPnd4jCeH+auhZ/lSvaSvM2orqnGoVPlG
         ksMhF4OkMsXJTwJ1TvI+SIxdwX5OLcllAbRPz7cjr2FUNRGA1v61NIZK5lr0SGMno8i3
         Wh0w==
X-Gm-Message-State: APjAAAXx9t2UuBd4IT5OA1pYi1bdaPBCt9McbcYI7uFg0G6dA+osjOnQ
        iNm5470PcVA7G75NGb67RHqC1X+BtQ==
X-Google-Smtp-Source: APXvYqzTO5yubV7ZW7nZh5H6sEWXR7gm6ooKC4AAjkp5VknQ8t8D13fjNcMykF1qYYfMGW8U/vb4Mw==
X-Received: by 2002:a17:90a:8a91:: with SMTP id x17mr7213953pjn.95.1564647100673;
        Thu, 01 Aug 2019 01:11:40 -0700 (PDT)
Received: from localhost.localdomain ([211.196.191.92])
        by smtp.gmail.com with ESMTPSA id br18sm3917286pjb.20.2019.08.01.01.11.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 01:11:40 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [v2,0/2] tools: bpftool: add net attach/detach command to attach XDP prog
Date:   Thu,  1 Aug 2019 17:11:31 +0900
Message-Id: <20190801081133.13200-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, bpftool net only supports dumping progs attached on the
interface. To attach XDP prog on interface, user must use other tool
(eg. iproute2). By this patch, with `bpftool net attach/detach`, user
can attach/detach XDP prog on interface.

    $ ./bpftool prog
    ...
    208: xdp  name xdp_prog1  tag ad822e38b629553f  gpl
      loaded_at 2019-07-28T18:03:11+0900  uid 0
    ...
    $ ./bpftool net attach id 208 xdpdrv enp6s0np1
    $ ./bpftool net
    xdp:
    enp6s0np1(5) driver id 208
    ...
    $ ./bpftool net detach xdpdrv enp6s0np1
    $ ./bpftool net
    xdp:
    ...

While this patch only contains support for XDP, through `net
attach/detach`, bpftool can further support other prog attach types.

XDP attach/detach tested on Mellanox ConnectX-4 and Netronome Agilio.

---
Changes in v2:
  - command 'load/unload' changed to 'attach/detach' for the consistency

Daniel T. Lee (2):
  tools: bpftool: add net attach command to attach XDP on interface
  tools: bpftool: add net detach command to detach XDP on interface

 tools/bpf/bpftool/net.c | 160 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 159 insertions(+), 1 deletion(-)

-- 
2.20.1

