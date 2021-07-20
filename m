Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D6F3D035C
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 22:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236904AbhGTUJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 16:09:12 -0400
Received: from novek.ru ([213.148.174.62]:46616 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237722AbhGTTzD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 15:55:03 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 1912350348D;
        Tue, 20 Jul 2021 23:33:14 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 1912350348D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1626813196; bh=eVQ3jRrHM5EkL75xx6ilsGGHrZUs8yLWYzo9rRQOEj0=;
        h=From:To:Cc:Subject:Date:From;
        b=hCYRoL4fcXBHQochGlbwJQF3DaNBnGnput2ZeLHSS8W8JEn1mKQnOw+1jKQxjmhd2
         W9KzkVqgoyhSKqaIPwm85Ugv3JJwmdFAx8NwcmnUqX/k/gxa1k4mec8WO1pRJdaQGN
         mg17KOmK2WlV3OO4gyy+1cu27p5qbb4Dpc3k9ZFs=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Xin Long <lucien.xin@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [PATCH net v3 0/2] Fix PMTU for ESP-in-UDP encapsulation
Date:   Tue, 20 Jul 2021 23:35:27 +0300
Message-Id: <20210720203529.21601-1-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.18.4
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bug 213669 uncovered regression in PMTU discovery for UDP-encapsulated
routes and some incorrect usage in udp tunnel fields. This series fixes
problems and also adds such case for selftests

v3:
 - update checking logic to account SCTP use case
v2:
 - remove refactor code that was in first patch
 - move checking logic to __udp{4,6}_lib_err_encap
 - add more tests, especially routed configuration

Vadim Fedorenko (2):
  udp: check encap socket in __udp_lib_err
  selftests: net: add ESP-in-UDP PMTU test

 net/ipv4/udp.c                        |  25 ++-
 net/ipv6/udp.c                        |  25 ++-
 tools/testing/selftests/net/nettest.c |  55 ++++++-
 tools/testing/selftests/net/pmtu.sh   | 212 +++++++++++++++++++++++++-
 4 files changed, 298 insertions(+), 19 deletions(-)

-- 
2.18.4

