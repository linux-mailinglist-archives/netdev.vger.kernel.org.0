Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D66942EA0C
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 09:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235970AbhJOH26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 03:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233389AbhJOH26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 03:28:58 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BACC061570;
        Fri, 15 Oct 2021 00:26:51 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id i20so33559120edj.10;
        Fri, 15 Oct 2021 00:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=99NyzCMkjnvlYZIABFIbk6tOxw0lawvBeezR5Wj/vBw=;
        b=akaBBnw5J8T562lM7re75ZbDFuBMNVQF8fGI5qB0ldQsbcJw3Fw0vy8g5Gv8Rvtj1R
         8DNzOX4ib2UqBX2rFxI9raT93cOXqdVjOkt+Fko0D8OQ7e/Xvvg+oqeDbXaWe0frtS6b
         lTqq9jhtOfa0UIwwxnw8+n+IFliHuLzW2gts6hN8jnBXERaNh/OpgE77clpMmN4/z+q0
         ROnigcV5/4CRoU6GzbsIz+6kmwBDj6qDqXpZsHaij7LAIFPZS9S14+AjOIHaKgHUrkMq
         YMGslIZ2RlcJH5uFXtD7ITDyG0mgRYp+hV3R608JbYu+IZkls4K2EUPDRDpyFxhE5719
         8rOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=99NyzCMkjnvlYZIABFIbk6tOxw0lawvBeezR5Wj/vBw=;
        b=WZsmXamET7aFQOUZmwyfAB5RWLAD8Q2fy6B2TdTkUI8KUJX0um9msCpylHBkHb8oeg
         C5hZvbZwjMJyeRVjGG4WKGZolr4GR7pqXVWjYtBa7zexlwR7zrdp5frv68pNIdehweCb
         GJmjNXkPcj5gGFs+WBf85t3PVVBdHUvfql/KRJW0ztOVFwFpi9qJtoJyCYG/7KY1vzqB
         4NgVJebbqmZrTfZ1hnXUFCDPEjX3FENGHM9d53ahoYdttT6qk991LaraXBVPr0ecWQf1
         ks64dHTHvv2YOzJQz+75NuZrur8DJP/IBRXQEJHPIv1qamXMMbTSccV8vJYzqzmZ6PM/
         IPeA==
X-Gm-Message-State: AOAM530d9myt0uD9aFsZiMVGoSYF4MgxrxBmfmc3Lrh5Mgj3wVKpRnm4
        1VkpfoXth4NqKD3A33G6PnI=
X-Google-Smtp-Source: ABdhPJxlENUNa1yGJ2pgtxz4sJjmuY+IahmFVtJQDoLdVxYnJQDIOyCCfW74g3Qd00rj3IFbgNVvZQ==
X-Received: by 2002:a05:6402:3588:: with SMTP id y8mr15117328edc.285.1634282810511;
        Fri, 15 Oct 2021 00:26:50 -0700 (PDT)
Received: from ponky.lan ([2a04:241e:501:3870:bac1:743:3859:80df])
        by smtp.gmail.com with ESMTPSA id l25sm3873107edc.31.2021.10.15.00.26.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 00:26:49 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Yonghong Song <yhs@fb.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/4] tcp: md5: Fix overlap between vrf and non-vrf keys
Date:   Fri, 15 Oct 2021 10:26:03 +0300
Message-Id: <cover.1634282515.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With net.ipv4.tcp_l3mdev_accept=1 it is possible for a listen socket to
accept connection from the same client address in different VRFs. It is
also possible to set different MD5 keys for these clients which differ only
in the tcpm_l3index field.

This appears to work when distinguishing between different VRFs but not
between non-VRF and VRF connections. In particular:

* tcp_md5_do_lookup_exact will match a non-vrf key against a vrf key. This
means that adding a key with l3index != 0 after a key with l3index == 0
will cause the earlier key to be deleted. Both keys can be present if the
non-vrf key is added later.
* _tcp_md5_do_lookup can match a non-vrf key before a vrf key. This casues
failures if the passwords differ.

This can be fixed by making tcp_md5_do_lookup_exact perform an actual exact
comparison on l3index and by making  __tcp_md5_do_lookup perfer vrf-bound
keys above other considerations like prefixlen.

The fact that keys with l3index==0 affect VRF connections is usually not
desirable, VRFs are meant to be completely independent. This behavior needs
to preserved for backwards compatibility. Also, applications can just bind
listen sockets to VRF and never specify TCP_MD5SIG_FLAG_IFINDEX at all.

So far the combination of TCP_MD5SIG_FLAG_IFINDEX with tcpm_ifindex == 0
was an error, accept this to mean "key only applies to default VRF". This
is what applications using VRFs for traffic separation want.

This also contains tests for the second part. It does not contain tests for
overlapping keys, that would require more changes in nettest to add
multiple keys. These scenarios are also covered by my tests for TCP-AO,
especially around this area:
https://github.com/cdleonard/tcp-authopt-test/blob/main/tcp_authopt_test/test_vrf_bind.py

Changes since V2:
* Rename --do-bind-key-ifindex to --force-bind-key-ifindex
* Fix referencing TCP_MD5SIG_FLAG_IFINDEX as TCP_MD5SIG_IFINDEX
Link to v2: https://lore.kernel.org/netdev/cover.1634107317.git.cdleonard@gmail.com/

Changes since V1:
* Accept (TCP_MD5SIG_IFINDEX with tcpm_ifindex == 0)
* Add flags for explicitly including or excluding TCP_MD5SIG_FLAG_IFINDEX
to nettest
* Add few more tests in fcnal-test.sh.
Link to v1: https://lore.kernel.org/netdev/3d8387d499f053dba5cd9184c0f7b8445c4470c6.1633542093.git.cdleonard@gmail.com/

Leonard Crestez (4):
  tcp: md5: Fix overlap between vrf and non-vrf keys
  tcp: md5: Allow MD5SIG_FLAG_IFINDEX with ifindex=0
  selftests: nettest: Add --{force,no}-bind-key-ifindex
  selftests: net/fcnal: Test --{force,no}-bind-key-ifindex

 include/net/tcp.h                         |  5 +-
 net/ipv4/tcp_ipv4.c                       | 45 ++++++++++++-----
 net/ipv6/tcp_ipv6.c                       | 15 +++---
 tools/testing/selftests/net/fcnal-test.sh | 60 +++++++++++++++++++++++
 tools/testing/selftests/net/nettest.c     | 28 ++++++++++-
 5 files changed, 130 insertions(+), 23 deletions(-)


base-commit: 40088915f547b52635f022c1e1e18df65ae3153a
-- 
2.25.1

