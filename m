Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D206327847E
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 11:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbgIYJ4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 05:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgIYJ4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 05:56:46 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E5CC0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 02:56:46 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id a9so2608520wmm.2
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 02:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bzDm8G/cn3qy5MEO2xEcUhRgUy+JqIMCV/2pYJenhxE=;
        b=j57yctE04pTbklVxzB1rVHqqrGAGeD8r7eWPn69BC4pO8Zz/iYrmwvYRy1xBIZp5wM
         iJ/KHAB4qnqdlfE37IfW7xT8NC1D/hpJQFHA6fh5Y75vKuh9b2ddamN2cuo3bVf8b5Xj
         N8CM6J2mOk7AhjSwlYsCF5W7g8/VaA5oVZOxs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bzDm8G/cn3qy5MEO2xEcUhRgUy+JqIMCV/2pYJenhxE=;
        b=cXRT2JxO/Q7FVl9v/XFmvgbIWulCNjJ1ahHXC4zc/i0KWGimK6lYYKj6KwXifJgujW
         exLJ0DPu8Y0Jx/J+7wtX9xF5I4E7Zt81i3MwmPADwZxB0pBu4Q0JtSo54gJWC/mEBto2
         N5ciYMDJoT4N3M0vTrekeJwlkUBREeV+uTBSn0eyKErL7W5hLzvoK0o1uaZdQyiuWN6M
         +VaIjmwfl96P9c/Jf/JfSwzOODa9N1qhidsf2YKuWMQao0ZXxIdICS7M9q+VWZLajU1v
         dB6cACrsZ/Gcydse5kpJmjjVhlKhI17IcyGn7e1ym5NWz2f9wtq00HZ6ZfQYff+Bsa44
         imNQ==
X-Gm-Message-State: AOAM533VSkk9974OAL4GKN6CfEkaxAn3+5sHi/R0b+phj4qG7JwZ7evJ
        opfWfOIs9ZixPbKzDyTjxZ+DSQ==
X-Google-Smtp-Source: ABdhPJz9peTJYuOZKo0Imiu3pbOUxg3owyK8cqVjQVI1uU6qy9mMykUgIybrXiS635H7BlFISQnSzA==
X-Received: by 2002:a1c:1f08:: with SMTP id f8mr2232547wmf.168.1601027805131;
        Fri, 25 Sep 2020 02:56:45 -0700 (PDT)
Received: from antares.lan (e.0.c.6.b.e.c.e.a.c.9.7.c.2.1.0.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:12c:79ca:eceb:6c0e])
        by smtp.gmail.com with ESMTPSA id l10sm2225084wru.59.2020.09.25.02.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 02:56:44 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next 0/4] Sockmap copying
Date:   Fri, 25 Sep 2020 10:56:26 +0100
Message-Id: <20200925095630.49207-1-lmb@cloudflare.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable calling map_update_elem on sockmaps from bpf_iter context. This
in turn allows us to copy a sockmap by iterating its elements.

The change itself is tiny, all thanks to the ground work from Martin,
whose series [1] this patch is based on. I updated the tests to do some
copying, and also included two cleanups.

I'm sending this out now rather than when Martin's series has landed
because I hope this can get in before the merge window (potentially)
closes this weekend.

1: https://lore.kernel.org/bpf/20200925000337.3853598-1-kafai@fb.com/

Lorenz Bauer (4):
  bpf: sockmap: enable map_update_elem from bpf_iter
  selftests: bpf: Add helper to compare socket cookies
  bpf: selftests: remove shared header from sockmap iter test
  selftest: bpf: Test copying a sockmap and sockhash

 kernel/bpf/verifier.c                         |   2 +-
 net/core/sock_map.c                           |   3 +
 .../selftests/bpf/prog_tests/sockmap_basic.c  | 100 +++++++++++-------
 .../selftests/bpf/progs/bpf_iter_sockmap.c    |  32 ++++--
 .../selftests/bpf/progs/bpf_iter_sockmap.h    |   3 -
 5 files changed, 90 insertions(+), 50 deletions(-)
 delete mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_sockmap.h

-- 
2.25.1

