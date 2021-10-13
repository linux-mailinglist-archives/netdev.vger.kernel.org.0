Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28DFC42B7F4
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 08:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237918AbhJMGw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 02:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbhJMGww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 02:52:52 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2C1C061570;
        Tue, 12 Oct 2021 23:50:50 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id ec8so5780497edb.6;
        Tue, 12 Oct 2021 23:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rJuE6Pp9lkDOOOTalExDw5jNyfW6/ykHvOQPHpnMcnQ=;
        b=WSztpwpydnYASkv73NyidXyVf9vx22yndzvImhNv5g3NN+LZHyQTxnVhjqZWah5+51
         O+PpOXT+cDy2XWR4+q8Wv973ut+16yacHkpJFe7dXuh+bdDzWwZd49QToFGfEnd83Qq3
         pNFtGge7d2kRgJpHlaEgIvrUmb23gdzzlZBv03EQHolCD5eqwuRcrJXmLkKQinJUipAu
         oNfO+j+poCO0iHHV/c64sBj6l3PWQCZaX3nqUQiskIuiXZ3oDzmGH3hAQOEZllxDy8yk
         zBWDk2kDdCmmlH6QLRvAlk1PsYA80CgYl2r56xT+xWACxhZQE8ZwDgsJN8aoKKcrDTYN
         5dKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rJuE6Pp9lkDOOOTalExDw5jNyfW6/ykHvOQPHpnMcnQ=;
        b=n7S3twYf6Vt3zfY82A8j+IEEiysnraEKJ4zc1XWj9QZH3pqqgRD5KbelyJs85gDulG
         18O5EKPyj012QUWt48tgC9CD86ommOjrzcTL2/HW8kmilWLaFFcld+R+PseBwh5USSbu
         HGpqqgcoA0rfQ1ruRonJgNJmYjQW/kqnwekqdRWaE9oENLR9LEVvUcoD2nO6mQ2ItSMt
         cmf16QOhkITBGlwCVdEw7iHE+AS0xxV8tPyb6wZdkKcKHDwcvAuaK70mi9XcSLF/u7bm
         7PkfGk2frp+Z29E2nsdzKMdlnge80NQlOfjxn10fEVLNqAYoR/mxiobk/v17tGwk33Oi
         0qvw==
X-Gm-Message-State: AOAM532YmMDfmVapcd+eECfJl4eEljqYThy89cCW47pVJR7RTOagElhA
        n998DBwpWsD17bo7ApriUuk=
X-Google-Smtp-Source: ABdhPJyrFw3rn6IHBty5/kP1xrHecojrR8X6QfUbWvzX1/Lqtkn+DoqNjp2Z0r4mra4jbwiedSUC4g==
X-Received: by 2002:a17:906:712:: with SMTP id y18mr37710983ejb.408.1634107848578;
        Tue, 12 Oct 2021 23:50:48 -0700 (PDT)
Received: from ponky.lan ([2a04:241e:501:3870:6346:a6a3:f7ea:349e])
        by smtp.gmail.com with ESMTPSA id m15sm4568710edd.5.2021.10.12.23.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 23:50:47 -0700 (PDT)
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
Subject: [PATCH v2 0/4] tcp: md5: Fix overlap between vrf and non-vrf keys
Date:   Wed, 13 Oct 2021 09:50:34 +0300
Message-Id: <cover.1634107317.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With net.ipv4.tcp_l3mdev_accept=1 it is possible for a listen socket to
accept connection from the same client address in different VRFs. It is
also possible to set different MD5 keys for these clients which differ
only in the tcpm_l3index field.

This appears to work when distinguishing between different VRFs but not
between non-VRF and VRF connections. In particular:

 * tcp_md5_do_lookup_exact will match a non-vrf key against a vrf key.
This means that adding a key with l3index != 0 after a key with l3index
== 0 will cause the earlier key to be deleted. Both keys can be present
if the non-vrf key is added later.
 * _tcp_md5_do_lookup can match a non-vrf key before a vrf key. This
casues failures if the passwords differ.

This can be fixed by making tcp_md5_do_lookup_exact perform an actual
exact comparison on l3index and by making  __tcp_md5_do_lookup perfer
vrf-bound keys above other considerations like prefixlen.

The fact that keys with l3index==0 affect VRF connections is usually
not desirable, VRFs are meant to be completely independent. This
behavior needs to preserved for backwards compatiblity. Also,
applications can just bind listen sockets to VRF and never specify
TCP_MD5SIG_IFINDEX at all.

So far the combination of TCP_MD5SIG_IFINDEX with tcpm_ifindex == 0
was an error, accept this to mean "key only applies to default VRF".
This is what applications using VRFs for traffic separation want.

This also contains tests for the second part. It does not contain
tests for overlapping keys, that would require more changes in
nettest to add multiple keys. These scenarios are also covered by
my tests for TCP-AO, especially around this area:
https://github.com/cdleonard/tcp-authopt-test/blob/main/tcp_authopt_test/test_vrf_bind.py

Changes since V1:
* Accept (TCP_MD5SIG_IFINDEX with tcpm_ifindex == 0)
* Add flags for explicitly including or excluding TCP_MD5SIG_IFINDEX
to nettest
* Add few more tests in fcnal-test.sh.
Link to v1: https://lore.kernel.org/netdev/3d8387d499f053dba5cd9184c0f7b8445c4470c6.1633542093.git.cdleonard@gmail.com/

Leonard Crestez (4):
  tcp: md5: Fix overlap between vrf and non-vrf keys
  tcp: md5: Allow MD5SIG_FLAG_IFINDEX with ifindex=0
  selftests: nettest: Add --{do,no}-bind-key-ifindex
  selftests: net/fcnal: Test --{do,no}-bind-key-ifindex

 include/net/tcp.h                         |  5 +-
 net/ipv4/tcp_ipv4.c                       | 45 ++++++++++++-----
 net/ipv6/tcp_ipv6.c                       | 15 +++---
 tools/testing/selftests/net/fcnal-test.sh | 60 +++++++++++++++++++++++
 tools/testing/selftests/net/nettest.c     | 28 ++++++++++-
 5 files changed, 130 insertions(+), 23 deletions(-)


base-commit: d1f24712a86abd04d82cf4b00fb4ab8ff2d23c8a
-- 
2.25.1

