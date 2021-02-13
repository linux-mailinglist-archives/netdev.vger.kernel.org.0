Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A4331AE2F
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 22:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbhBMVpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 16:45:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhBMVpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 16:45:11 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0726CC061574;
        Sat, 13 Feb 2021 13:44:28 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id y199so3783461oia.4;
        Sat, 13 Feb 2021 13:44:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OPxC4jiuTOSPuWpJpRwIHsBHSdYi9KDPoiD9DGUPK7U=;
        b=sMlLxQvN8Hh61h33KKQDVkTCzmPUuQpOKi19Un9R6/zoZj+OQ1JfZd3K4hxHGy7+uv
         pe7lZI8kFnfEy1bVOQZYhtC6LQt5BM0JKpGCxSjDl3sghR/cYDBULp+WeQac5hJN9Kyp
         2f7eJuQnNc/u53pXEEA3m5KO4FRmnSbK5snXqIa8c4Nl1zCFaFPl/gmFHeToHaf6WXvu
         vLLhiABiq/yQtiejXtxD5Ei+fgpsb2qiJT5XRhKQwS/kY+1HYi/rf66hbQ9sogQb6n4J
         aHFTi8wPs5vCyyDRpzAW+LsirZiEcUJX1fO1C6F3bUMpSw7Gn72Pol+eWRArsF2e2zMp
         grZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OPxC4jiuTOSPuWpJpRwIHsBHSdYi9KDPoiD9DGUPK7U=;
        b=bQcpi7+1EGigyX/dSODYgzzJklxd8frlyfyNMqCl9UAxu1tumX/dsXxo75TC3kcLni
         q9zqBFMKp4jxUCrnwAAFDTOIRiFKiiZfsPafjOlf5lpM9OX22CxIeXp3mZIfBeHi5h2k
         cxW79499r9sA9RArJCldpl3VsqU0KVKoisiR18LaoPdDjtlNIJNYbuhywXhqTFJfohax
         C7csLhtm5nq/UiwMNDaGVPW2FNRMg8ijST2Ei/2JqeVXLeXSX8XIOjcLDUbB7m6yeBDf
         GgYU/YEe8Iu0oEoaz0OLw6JW0rAhCy7ssVJ1zxFExvU9DbeYbpg8t1/dvmsJ+eZLpy4G
         oUGA==
X-Gm-Message-State: AOAM531yKoxyiLmYJXAjDIKRiu62uX1Da5tlqTtfN+9ZH1DjhRZQbv2n
        ueD5lNlAjY9IYLksUHfl7HSol6cWEMkNmQ==
X-Google-Smtp-Source: ABdhPJwySfwlnIk8KL1PlxhdKcgsxtDlFhzzyl4JO5AowCnJ9T/z+9W1i3oDX3W56uUhrmYbJohskg==
X-Received: by 2002:aca:d4c3:: with SMTP id l186mr3905726oig.70.1613252667266;
        Sat, 13 Feb 2021 13:44:27 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:108:c15a:7f7a:df71])
        by smtp.gmail.com with ESMTPSA id c17sm2509674otp.58.2021.02.13.13.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 13:44:26 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf-next v3 0/5] sock_map: clean up and refactor code for BPF_SK_SKB_VERDICT
Date:   Sat, 13 Feb 2021 13:44:16 -0800
Message-Id: <20210213214421.226357-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

This patchset is the first series of patches separated out from
the original large patchset, to make reviews easier. This patchset
does not add any new feature or change any functionality but merely
cleans up the existing sockmap and skmsg code and refactors it, to
prepare for the patches followed up. This passed all BPF selftests.

The original whole patchset is available on github:
https://github.com/congwang/linux/tree/sockmap

and this patchset is also available on github:
https://github.com/congwang/linux/tree/sockmap1

---
v3: fix a few Kconfig compile errors
    remove an unused variable
    add a comment for bpf_convert_data_end_access()

v2: split the original patchset
    compute data_end with bpf_convert_data_end_access()
    get rid of psock->bpf_running
    reduce the scope of CONFIG_BPF_STREAM_PARSER
    do not add CONFIG_BPF_SOCK_MAP

Cong Wang (5):
  bpf: clean up sockmap related Kconfigs
  skmsg: get rid of struct sk_psock_parser
  bpf: compute data_end dynamically with JIT code
  skmsg: use skb ext instead of TCP_SKB_CB
  sock_map: rename skb_parser and skb_verdict

 include/linux/bpf.h                           |  20 +-
 include/linux/bpf_types.h                     |   2 -
 include/linux/skbuff.h                        |   3 +
 include/linux/skmsg.h                         |  85 ++++++--
 include/net/tcp.h                             |  38 +---
 include/net/udp.h                             |   4 +-
 init/Kconfig                                  |   1 +
 net/Kconfig                                   |   7 +-
 net/core/Makefile                             |   2 +-
 net/core/filter.c                             |  48 +++--
 net/core/skbuff.c                             |   7 +
 net/core/skmsg.c                              | 194 +++++++++---------
 net/core/sock_map.c                           |  74 +++----
 net/ipv4/Makefile                             |   2 +-
 net/ipv4/tcp_bpf.c                            |   2 -
 .../selftests/bpf/prog_tests/sockmap_listen.c |   8 +-
 .../selftests/bpf/progs/test_sockmap_listen.c |   4 +-
 17 files changed, 269 insertions(+), 232 deletions(-)

-- 
2.25.1

