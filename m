Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 602823D1E0
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 18:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391887AbfFKQKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 12:10:41 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33695 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388744AbfFKQKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 12:10:41 -0400
Received: by mail-wr1-f66.google.com with SMTP id n9so13747479wru.0
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 09:10:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ulmrB1M1DDT72zla1G6gkOgL2vb0K8XE0ODAv0qua40=;
        b=tllFi0F3ivo+OjgOHFJAWJZzT9eVpET5dWr8q4Cg8stRYKH5ajU4QXpqH1O0sqGUYm
         dhJSG51fUNqSArONvR12IYliq6d7SUgz9pe9X8oCHMIQ8bryYcuA3WEDDpgsEykIpfRW
         TotSlmqTswHT5XtC2hHGfZ9l1KpLTT4MAtp35wP65K8CuRaPXBoWEBLKoWDupqPZMd8m
         jHnJtTH7fGi8lEzMlhMmdkpQudzX66oIMZoOEbGUKE9jXGJPsPI3PVRjfv+MrLaQxVxi
         E4qY2JxvTUIjVrbEFhoJTyhoQcSGHTJ//qS1FPlEvs55KVsMhksFHcCRUCOJlZqXd4i3
         mbmA==
X-Gm-Message-State: APjAAAXHtjpJWFuFzz4dGFSIsriLhp/fnkg9o2amaPJuftz5IiL33oKE
        +/pRo9YkS0Kd79Rr04rVtCpWevMq7dY=
X-Google-Smtp-Source: APXvYqzHu9gMHfQ4rdmW1Uwb45lYXGaenT9JOPseqCadNvN+xunS5iU0vccy148Ae1+2R7bQNqPw+A==
X-Received: by 2002:adf:da48:: with SMTP id r8mr32073929wrl.18.1560269439549;
        Tue, 11 Jun 2019 09:10:39 -0700 (PDT)
Received: from mcroce-redhat.mxp.redhat.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id y18sm4286981wmd.29.2019.06.11.09.10.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 09:10:37 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH iproute2 v2 0/3] refactor the cmd_exec()
Date:   Tue, 11 Jun 2019 18:10:28 +0200
Message-Id: <20190611161031.12898-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor the netns and ipvrf code so less steps are needed to exec commands
in a netns or a VRF context.
Also remove some code which became dead. bloat-o-meter output:

$ bloat-o-meter ip.old ip
add/remove: 1/4 grow/shrink: 3/4 up/down: 174/-312 (-138)
Function                                     old     new   delta
netns_add                                    971    1058     +87
cmd_exec                                     207     256     +49
on_netns_exec                                 32      60     +28
do_switch                                      -      10     +10
netns_restore                                 69      67      -2
do_ipvrf                                     811     802      -9
netns_switch                                 838     822     -16
on_netns_label                                45       -     -45
do_netns                                    1226    1180     -46
do_each_netns                                 57       -     -57
on_netns                                      60       -     -60
netns_save                                    77       -     -77
Total: Before=668234, After=668096, chg -0.02%

Matteo Croce (3):
  netns: switch netns in the child when executing commands
  ip vrf: use hook to change VRF in the child
  netns: make netns_{save,restore} static

 include/namespace.h |  2 --
 include/utils.h     |  6 ++---
 ip/ip.c             |  1 -
 ip/ipnetns.c        | 56 +++++++++++++++++++++++++++++++++------------
 ip/ipvrf.c          | 12 ++++++----
 lib/exec.c          |  7 +++++-
 lib/namespace.c     | 31 -------------------------
 lib/utils.c         | 27 ----------------------
 8 files changed, 58 insertions(+), 84 deletions(-)

-- 
2.21.0

