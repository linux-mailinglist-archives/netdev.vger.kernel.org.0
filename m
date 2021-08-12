Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA2C3EA791
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 17:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238036AbhHLPan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 11:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238044AbhHLPak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 11:30:40 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5DA9C0617A8
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 08:30:14 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id o3-20020a2541030000b0290557cf3415f8so6495390yba.1
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 08:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Ps9dtDx12941A9SQUJ+R+y8TpeyDNU6PScAxGT8aLeY=;
        b=Pa5YlGdocqVh4d0WXzK8p83jRRi1hUFSP0z6YRA3+wgnOyMl4YpQKdQ/SgA3VnF2IB
         YvkT0nhoZaqWRHaWGHz2aMjB1jK9xG+tllN88nohYh92lZcqmFpOSmNIHc4iW6qXasS6
         hQgGEDcxLFIIXYXl8390H6SXrsRIBhTEQQi57PAH0+SH7ryXMUJJD9m2DT9TU6s67iG+
         2hGRih958f2HURg6/U7yJjlbo89ei0VJdmI3CKt8vyJz5uRF7byGX+Gbd/8Fv+P5yxTG
         duUrqqzaH/gcYxRm/I599FdIwycVw1iqks3ZiD5tUqvvwOXCGyt6wk1kEjZBm0JG8tys
         aOAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Ps9dtDx12941A9SQUJ+R+y8TpeyDNU6PScAxGT8aLeY=;
        b=mSJdZQlB11Yi83Zl/2k4qd99ouFn0EFC5lhsJc5X+KWIAYhNgrCl5aRJt6Aj8z1wZa
         WIcaGHMmoAKkd1ZLs1GXIcnQTqJBr+F7ZF08+QI82sVUoM9SmkeaK3FhLc3WM7bHF+CB
         rAIIImaKhKcD08EUczRpH2M4Qmc2ZnVGocQam+NF7plH5ZoZPW8Ofdm9JwifCwh2ewDP
         y3rPyoG2eb5QMIBm9HzXyHeKEwGuHa5hno7FeaCAEbRXNSSf5zilM/1sC6TF7n4TLZS9
         wBDEMSGkTTthbX7VIWjSo0WFWhcrRVdOo1tn+PGRRjcscap+G/qbYOkRzQzjEk4mQCjF
         6qvQ==
X-Gm-Message-State: AOAM532eS/zuwQxXaqmap5tvDklCw13ZloU8egN2YEgMtkJoSbdoPr+z
        4FGKV8rQsol7YeFU4kfPc2gR7S+aQrNVtEsQqIT4QEVEtld6M4MXe6vWJfZF6eG7fdAm/+cgc4l
        flqVVZedUXkoBkwdMY+N8FFXz+g+dU/mvIKhF8Q5uG7YW3NqCFDNLcw==
X-Google-Smtp-Source: ABdhPJyRfJgmI/klNckeumJ0NsjGjWad5oVhl5JDZVcLbW06bVXxq/+tlp3bKsW9kI4dpYEtWSq8GJQ=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:fa15:8621:e6d2:7ad4])
 (user=sdf job=sendgmr) by 2002:a25:2489:: with SMTP id k131mr2717779ybk.103.1628782214123;
 Thu, 12 Aug 2021 08:30:14 -0700 (PDT)
Date:   Thu, 12 Aug 2021 08:30:09 -0700
Message-Id: <20210812153011.983006-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH bpf-next v2 0/2] bpf: Allow bpf_get_netns_cookie in BPF_PROG_TYPE_CGROUP_SOCKOPT
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We'd like to be able to identify netns from setsockopt hooks
to be able to do the enforcement of some options only in the
"initial" netns (to give users the ability to create clear/isolated
sandboxes if needed without any enforcement by doing unshare(net)).

v2:
- add missing CONFIG_NET

Stanislav Fomichev (2):
  bpf: Allow bpf_get_netns_cookie in BPF_PROG_TYPE_CGROUP_SOCKOPT
  selftests/bpf: verify bpf_get_netns_cookie in
    BPF_PROG_TYPE_CGROUP_SOCKOPT

 kernel/bpf/cgroup.c                        | 19 ++++++++++++++++
 tools/testing/selftests/bpf/verifier/ctx.c | 25 ++++++++++++++++++++++
 2 files changed, 44 insertions(+)

-- 
2.33.0.rc1.237.g0d66db33f3-goog

