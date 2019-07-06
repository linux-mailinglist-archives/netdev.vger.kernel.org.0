Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 874326112E
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 16:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfGFOzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 10:55:39 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:35026 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfGFOzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 10:55:39 -0400
Received: by mail-yw1-f65.google.com with SMTP id o7so2752129ywi.2
        for <netdev@vger.kernel.org>; Sat, 06 Jul 2019 07:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=aqzxLuFIRMqozG27VsEtQz5ad1QEoMEjqWcaCG0BFvE=;
        b=dtJjTLjuZtoO/0eVFX5fwdgfbB2WSnPD8bEoKaMItok1tNkbZUWdPbQ86GRMvDEYyV
         KoaJwm9x/iL9VwUgRRq2KFYWJ34xI1cIkdprgQ75OLZV8tUqbIgOikD7zgM71cUjS7It
         YzCy9RqYuifbny4ul5QXk1UCIJpN7pIADJi6PwP310daXoMSW7lkEx+vysS6QBimtBVs
         g1G/u8PGgWLgx6Xy+zCdsINjcsodOhaJVbpc9XPE/VMojWd1FN2ZPE9aJdI+dUhF3AOY
         ztsJb1sGn6vbMcFO3xCEE/gYBkHaNH1CKLLTJ7qOWuDjNTkvTo8jW+TKTM0brrvaKGV4
         bHYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aqzxLuFIRMqozG27VsEtQz5ad1QEoMEjqWcaCG0BFvE=;
        b=IiSRWECayDfyK62rvsnu9QnhQgf7vuT+Pge4AZo79de3ug9LoyUr0eK6ryD3WcJuux
         AvgNVBC3Q/G/pIUBTd3AxIqBoBH6n2Xuku7+nhWmarh+i6q3QPR8+JUhxU54ZOT56i2y
         MnDsD/ihmjjfx6Tih7fk9uGlRn/wq4Sx1FPxBdfGiHT70mNF4TfEG8U/nWGecCKftbim
         UIyrwAd/CPPLIWrCCW19QWbgVKfNQrGHyL0Tg9f9c+GjPnXjZ6qC6SUg3JH3BrbuxSvQ
         W6tNbOK68+LmAng3wgH/gxToQKLhO2Aku7AuF80BaeAT2f8KhO57KMyWnCQYSEUGDI1P
         hKxg==
X-Gm-Message-State: APjAAAWlZxzDWpt9hPyJWkYeBCmJ7hImvWM7vyhFG7n0YRFTR8T87U22
        kSKl7ujn1WucOBrapIl9Hte0Yexekw==
X-Google-Smtp-Source: APXvYqyJjUIJNOPbv5S0oE8Zy7CwAKg6SqPUNwgvpFhkAmeStqDXFlX+b1coXH9JXux7vv2ECwKmzw==
X-Received: by 2002:a81:798a:: with SMTP id u132mr5928060ywc.432.1562424938514;
        Sat, 06 Jul 2019 07:55:38 -0700 (PDT)
Received: from localhost.localdomain (75-58-56-234.lightspeed.rlghnc.sbcglobal.net. [75.58.56.234])
        by smtp.gmail.com with ESMTPSA id q63sm4586361ywq.17.2019.07.06.07.55.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 06 Jul 2019 07:55:37 -0700 (PDT)
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netdev@vger.kernel.org
Cc:     idosch@idosch.org, nikolay@cumulusnetworks.com, dsahern@gmail.com,
        Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: [PATCH net-next v2 0/3] net: Multipath hashing on inner L3
Date:   Sat,  6 Jul 2019 10:55:16 -0400
Message-Id: <20190706145519.13488-1-ssuryaextr@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series extends commit 363887a2cdfe ("ipv4: Support multipath
hashing on inner IP pkts for GRE tunnel") to include support when the
outer L3 is IPv6 and to consider the case where the inner L3 is
different version from the outer L3, such as IPv6 tunneled by IPv4 GRE
or vice versa. It also includes kselftest scripts to test the use cases.

v2: Clarify the commit messages in the commits in this series to use the
    term tunneled by IPv4 GRE or by IPv6 GRE so that it's clear which
    one is the inner and which one is the outer (per David Miller).

Stephen Suryaputra (3):
  ipv4: Multipath hashing on inner L3 needs to consider inner IPv6 pkts
  ipv6: Support multipath hashing on inner IP pkts
  selftests: forwarding: Test multipath hashing on inner IP pkts for GRE
    tunnel

 Documentation/networking/ip-sysctl.txt        |   1 +
 net/ipv4/route.c                              |  21 +-
 net/ipv6/route.c                              |  36 +++
 .../net/forwarding/gre_inner_v4_multipath.sh  | 305 +++++++++++++++++
 .../net/forwarding/gre_inner_v6_multipath.sh  | 306 ++++++++++++++++++
 .../forwarding/ip6gre_inner_v4_multipath.sh   | 304 +++++++++++++++++
 .../forwarding/ip6gre_inner_v6_multipath.sh   | 305 +++++++++++++++++
 7 files changed, 1274 insertions(+), 4 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/gre_inner_v4_multipath.sh
 create mode 100755 tools/testing/selftests/net/forwarding/gre_inner_v6_multipath.sh
 create mode 100755 tools/testing/selftests/net/forwarding/ip6gre_inner_v4_multipath.sh
 create mode 100755 tools/testing/selftests/net/forwarding/ip6gre_inner_v6_multipath.sh

-- 
2.17.1

