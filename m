Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6B1436874
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 18:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbhJUQ6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 12:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbhJUQ6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 12:58:39 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3920FC0613B9
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 09:56:21 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id z20-20020a17090abd9400b001a1b91abc81so1242671pjr.0
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 09:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=QOVg8F6MnW2XCQcKeiHkiuap1SHFNbsyw5SXe2eZOCQ=;
        b=ZEpiOJKnZIkY7CwGzvGXI0mSY3QdWQ+tmk+uTCP1rQx9T+VOXI3zQwajg/Oc/LYYhk
         O+0ReVnViawhOaDWpOUsfZNUelqz07YnOg3gIdHGHP6AnnDfryaaaQ6lQ8pQ+2VIbiXz
         DrnWcPGxlA2DLrFLBREZRcMc7T4R891bZN2m0YcGqWxtX12fP5FpenvJ8C7MVInNAgxa
         deESq46YjLd8/XTFne6VpZBCRlm4OfyMKNoflaLsdOV8c9RHuxI0XwF/TgrhnnI6k3FN
         qH16kCoyNCsRgqRyjb3b3WWH0cEj2+Uvs9qGoo5r9Gs0lriwyBP3V8QNxdsEFzesPrdx
         vRhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=QOVg8F6MnW2XCQcKeiHkiuap1SHFNbsyw5SXe2eZOCQ=;
        b=04mIJfCJQekedxQ3UCdKOrx8U1lF8IOzVKCDpvceeMItpvLLuBekA2A1qR9iLCgRG6
         QxqBYJvBTz5yj7uYVycWLAO+zmrBjtvG4+3JI0xjZlyixz7Y4hUh/l0ryJ3bxqxTQcaY
         nVM5SFF8Wrzu4IOrrz+oIqjeGlQAYT9zJieZQdCA8vjvySEg9Z8aGJjnkDtEVSZJ14N8
         8bP0Bdv08xl5So+9qVyNInqZb5htF3IWfa1GxYVFRxitIUOQ8m0bju4V0BHTRd1yfcZb
         cKpN4DPXqe+iiULfJ+Jbut8+ivWYNyt8fd1zu+GISlXhheRhFsiiZ+X2vxXfb0tYc6tk
         yCRQ==
X-Gm-Message-State: AOAM532h/M/6rtTgu97XkkGdlUUMmla+uFgYpWMnzDzH6cQPenX4zLDU
        M4LSxMaAwTmX9cJkILY4kvdbhouTn4sVFbXmFMYUF3kXpex3iO7kl5sLqKROM0vKmksIfQJenNd
        dTR6BF4sqt6vFtYvhUL5P7mUX8MqzOibgfqxBwSa3tN7i+BylgB6QQQ==
X-Google-Smtp-Source: ABdhPJzj1fXcZGe2UeB+/qb4rg4ObREK9FiVsNtzpFhYt1FcWBc9nuGW5V9GgyRkFTQTxfZbRA/kHcY=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:5d22:afc4:e329:550e])
 (user=sdf job=sendgmr) by 2002:a63:b21a:: with SMTP id x26mr5363433pge.418.1634835380643;
 Thu, 21 Oct 2021 09:56:20 -0700 (PDT)
Date:   Thu, 21 Oct 2021 09:56:15 -0700
Message-Id: <20211021165618.178352-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH bpf-next v4 0/3] libbpf: use func name when pinning programs
 with LIBBPF_STRICT_SEC_NAME
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 15669e1dcd75 ("selftests/bpf: Normalize all the rest SEC() uses")
broke flow dissector tests. With the strict section names, bpftool isn't
able to pin all programs of the objects (all section names are the
same now). To bring it back to life let's do the following:

- teach libbpf to pin by func name with LIBBPF_STRICT_SEC_NAME
- enable strict mode in bpftool (breaking cli change)
- fix custom flow_dissector loader to use strict mode
- fix flow_dissector tests to use new pin names (func vs sec)

v4:
- fix comment spelling (Quentin Monnet)
- retry progtype without / (Quentin Monnet)

v3:
- clarify program pinning in LIBBPF_STRICT_SEC_NAME,
  for real this time (Andrii Nakryiko)
- fix possible segfault in __bpf_program__pin_name (Andrii Nakryiko)

v2:
- add github issue (Andrii Nakryiko)
- remove sec_name from bpf_program.pin_name comment (Andrii Nakryiko)
- add cover letter (Andrii Nakryiko)

Stanislav Fomichev (3):
  libbpf: use func name when pinning programs with
    LIBBPF_STRICT_SEC_NAME
  bpftool: conditionally append / to the progtype
  selftests/bpf: fix flow dissector tests

 tools/bpf/bpftool/main.c                       |  4 ++++
 tools/bpf/bpftool/prog.c                       |  9 +++++++--
 tools/lib/bpf/libbpf.c                         | 13 +++++++++++--
 tools/lib/bpf/libbpf_legacy.h                  |  3 +++
 .../selftests/bpf/flow_dissector_load.c        | 18 +++++++++++-------
 .../selftests/bpf/flow_dissector_load.h        | 10 ++--------
 .../selftests/bpf/test_flow_dissector.sh       | 10 +++++-----
 7 files changed, 43 insertions(+), 24 deletions(-)

-- 
2.33.0.1079.g6e70778dc9-goog

