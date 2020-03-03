Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 650D9176F8B
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 07:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725840AbgCCGht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 01:37:49 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40228 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbgCCGht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 01:37:49 -0500
Received: by mail-qk1-f194.google.com with SMTP id m2so2342391qka.7
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 22:37:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tyTDn5ptDtqAMWn5o4KiEKWBu8oBDrlUuB7PYf1Z0Ms=;
        b=UXYKzJDPJ9rwLua3Zd/4MX+K8juLE81r6Cl9k9+EhVqRSGMlrd9RUl2CgKQZMQEm79
         izy0ZBo8Z2C6FJ9ALbkjIBJP7943J3mnHl/miVuM9WkExAdjlw2qr6FvSb8duTL8n3aY
         yAE6p0k7B7jDQSeLRvu7ZonDOGuvyWv9SG45YkVl/r52kOy2740CugzLRKhrE1LuOpUs
         zuaHZgvyCezysBIS7MzN4O0tmqfVPhS7aVIj2Gcq8a/iDuw5rhIXMmRJHEKt2pK5+zT1
         9dORZqPA6Od9CN9NlBH9cmmxc+pDwN6LSf628ak9x6AIb5SnzdlBGtP1E0rPLfyOS+0g
         Nk9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tyTDn5ptDtqAMWn5o4KiEKWBu8oBDrlUuB7PYf1Z0Ms=;
        b=sb9WfYqh8oDIzU4kUuh4krQL9n4XMKxyU9enq4Fjv50y/slyePUO2rIYH5SdSCY325
         qtJCAXzjgEKORQOlPswHuznmjnSnCLHU2ILPPLPeMeOFhVZgm37pqC/liX+tbFPh4+b6
         eOZrX5OYqe0rUeXhDp6nMWSWFjEkWE60/yRUmt8c2ha6BhWg+/sP8WjmAfMnKXFaeAG3
         iMNrgkBJclFqDHYTACinH6yTN+dMZrlsg1Ll4L82EjTLakpZ3P4qieqJrsfzD4aZhDTZ
         IcUsWJGqFEwgZwOWwL8V91hvmdEzrF3WHpNJK2cqZiDVdknhS/rjYW0sLAyFeVKE4JeD
         FknA==
X-Gm-Message-State: ANhLgQ2MCc8GhxZ0dzRqsO7ZZsOPM8iAz7jITAfGla2iQ5A6xxFzSdmw
        DM1Zz0DAp0fzyf0Up3ELrj5/Sb1c28M=
X-Google-Smtp-Source: ADFU+vvOHmV4PRt9Xar7YmYA2S3000BDNLAKkq8EUBwp3lJfCVTHGNzOgapVF7JfWHn90jJAKbxXTQ==
X-Received: by 2002:a37:4c81:: with SMTP id z123mr2770365qka.320.1583217468564;
        Mon, 02 Mar 2020 22:37:48 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x4sm3599929qto.56.2020.03.02.22.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 22:37:48 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        David Miller <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 0/3] Fix IPv6 peer route update
Date:   Tue,  3 Mar 2020 14:37:33 +0800
Message-Id: <20200303063736.4904-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently we have two issues for peer route update on IPv6.
1. When update peer route metric, we only updated the local one.
2. If peer address changed, we didn't remove the old one and add new one.

The first two patches fixed these issues and the third patch add new
tests to cover it.

With the fixes and updated test:
]# ./fib_tests.sh
IPv6 prefix route tests
    TEST: Default metric                                                [ OK ]
    TEST: User specified metric on first device                         [ OK ]
    TEST: User specified metric on second device                        [ OK ]
    TEST: Delete of address on first device                             [ OK ]
    TEST: Modify metric of address                                      [ OK ]
    TEST: Prefix route removed on link down                             [ OK ]
    TEST: Prefix route with metric on link up                           [ OK ]
    TEST: Set metric with peer route on local side                      [ OK ]
    TEST: User specified metric on local address                        [ OK ]
    TEST: Set metric with peer route on peer side                       [ OK ]
    TEST: Modify metric with peer route on local side                   [ OK ]
    TEST: Modify metric with peer route on peer side                    [ OK ]

IPv4 prefix route tests
    TEST: Default metric                                                [ OK ]
    TEST: User specified metric on first device                         [ OK ]
    TEST: User specified metric on second device                        [ OK ]
    TEST: Delete of address on first device                             [ OK ]
    TEST: Modify metric of address                                      [ OK ]
    TEST: Prefix route removed on link down                             [ OK ]
    TEST: Prefix route with metric on link up                           [ OK ]
    TEST: Modify metric of .0/24 address                                [ OK ]
    TEST: Set metric of address with peer route                         [ OK ]
    TEST: Modify metric of address with peer route                      [ OK ]

Tests passed:  22
Tests failed:   0


Hangbin Liu (3):
  net/ipv6: need update peer route when modify metric
  net/ipv6: remove the old peer route if change it to a new one
  selftests/net/fib_tests: update addr_metric_test for peer route
    testing

 net/ipv6/addrconf.c                      | 41 +++++++++++++++++++-----
 tools/testing/selftests/net/fib_tests.sh | 34 ++++++++++++++++++--
 2 files changed, 64 insertions(+), 11 deletions(-)

-- 
2.19.2

