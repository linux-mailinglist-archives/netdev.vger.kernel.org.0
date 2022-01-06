Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFEAF485DB9
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 01:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344178AbiAFAzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 19:55:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344417AbiAFAzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 19:55:04 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 876F1C033241
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 16:52:57 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id e137-20020a25378f000000b0060c1f2f4939so2154315yba.3
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 16:52:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=goq0IvPEqlGG56UWBvUgmc8+zpWIy2x3JolpCp+LIgo=;
        b=jD4o4FMRxHYvTfeTFZd1hn+xdGKqjMascNgSyUgADODXZ1O67NoObbVgl6/8vFPrbz
         AaNAGryS7Bf5rxHk1vC3n8fpd6Dk93+N6HYxZ9p65w8Wkray/auWkU1yeSNVi6//07DP
         EMZt9nZGMo1z/fCpGSO4RMEGtj1t931JSPerzUXLwhwpKgSAXFt2wwWfXIfToFsw6X7m
         j7FostjyhJOQ0XvJgRc5x5RVtWZBg+tyaaKZGWRz5TISDFM2DS2JTPttLZxhGSS82Yxk
         XJ6+pi56SvSxtXc/DlIuovmYfb6wyFDsuw4GknXSOFYtEMl9UshIsm2myLTRiRK8Q9Zl
         xcLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=goq0IvPEqlGG56UWBvUgmc8+zpWIy2x3JolpCp+LIgo=;
        b=A+u39yt1RRzHA5wjaweoj3ohZfHY4zHTWVBadS7g6uWTRo6852jy77xmLiZ6C/TlB1
         Sf6ObvOTp+Svoa1v3pZIx609RMZ/FNBBKZZOHGOtTQJ/sdmA2hddiU2u056z/zH49nfn
         0305h8YmHuimTkkjtzYsPStsZ/RYHog+31/+XsBN8+Q4vMLGVdikaKx7wxo5pTwc+wvA
         krpBlov6y35XcxYYMzXHW8yqPuWZRi+y51grZCKnmLX06OsV37VrkFkiaZ/WEo+QyYQj
         IHWd0Q/CepjTdXO+aR0U+CCm2utQt/AKypyWMymm+VuriiuSN8OMI78FOJvLactGSSMp
         g7xg==
X-Gm-Message-State: AOAM531ct7cdVbzrNohjmojwOuyR4arFz2oc0J44DkZZ9bu423BPeEx5
        3bS4jJcKQhCWKfHa0XsKN8+rSkrAXlS+UA==
X-Google-Smtp-Source: ABdhPJyLpU5VVh/hqpKRY7do4/rnatvsGEHD8/c4IXCd7U6cb8pdZBCxVuwi6NspPTHGqs4bKKJA+e+1D47ZXA==
X-Received: from evitayan.mtv.corp.google.com ([2620:0:1000:5711:bcd2:c148:e081:25e6])
 (user=evitayan job=sendgmr) by 2002:a25:a224:: with SMTP id
 b33mr4429341ybi.507.1641430376779; Wed, 05 Jan 2022 16:52:56 -0800 (PST)
Date:   Wed,  5 Jan 2022 16:52:49 -0800
Message-Id: <20220106005251.2833941-1-evitayan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [PATCH v1 0/2] Fix issues in xfrm_migrate
From:   Yan Yan <evitayan@google.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     netdev@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, lorenzo@google.com,
        maze@google.com, nharold@googlel.com, benedictwong@googlel.com,
        Yan Yan <evitayan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series include two patches to fix two issues in xfrm_migrate.

PATCH 1/2 enables distinguishing SAs and SPs based on if_id during the
xfrm_migrate flow. It fixes the problem that when there are multiple
existing SPs with the same direction, the same xfrm_selector and
different endpoint addresses, xfrm_migrate might fail.

PATCH 2/2 enables xfrm_migrate to handle address family change by
breaking the original xfrm_state_clone method into two steps so as to
update the props.family before running xfrm_init_state.

Yan Yan (2):
  xfrm: Check if_id in xfrm_migrate
  xfrm: Fix xfrm migrate issues when address family changes

 include/net/xfrm.h     |  5 +++--
 net/key/af_key.c       |  2 +-
 net/xfrm/xfrm_policy.c | 14 ++++++++------
 net/xfrm/xfrm_state.c  | 40 ++++++++++++++++++++++++++++------------
 net/xfrm/xfrm_user.c   |  6 +++++-
 5 files changed, 45 insertions(+), 22 deletions(-)


base-commit: 18343b80691560f41c3339119a2e9314d4672c77
-- 
2.34.1.448.ga2b2bfdf31-goog

