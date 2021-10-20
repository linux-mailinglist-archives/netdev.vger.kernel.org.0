Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42DFD43561E
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 00:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbhJTWwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 18:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhJTWwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 18:52:23 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4F7C061749
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 15:50:08 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id mz2-20020a17090b378200b001a150b49105so1143349pjb.3
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 15:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=OcgFrrYD37Wn+oCtjGIiFNqHOQIgGNIkkT6mluEZSUI=;
        b=Dbu9DCn91W3CuRQvfdNw+Gl6CZoi2li0KOs8NOxI3mvH/KofGOHYcnaVRH94hLVH7y
         Yj8S7gWTHPHoBr04QB27UbZGjLx48QiW7ovFEl60UryUnzyUvXJ0Z+dVM3KYhM/UMimA
         gAqkwttMu6RfePiusMQ8rh6DUmKe5XbQvyfZzM40I9xTl9HsjxKEX83FSDerCvvcJ3aV
         QqHuhZklkUdeiYIThG2oU9BpBXfx+plARncES2bs02TJ5GjsJ6d83QNbFCOip9Xyws2Y
         7Jytlgg2uiCx7jlcykQqb7WsRgsmRC2dsUyEUPaPFcNiw7H2eukURfjub2Cmvz5qqEjf
         fHgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=OcgFrrYD37Wn+oCtjGIiFNqHOQIgGNIkkT6mluEZSUI=;
        b=tnWhmzqkr/rSQAbGkuN7kclzj6nNJ6cHioXDWhEfrwzrTWeWwq9K/jDTwbAuyn4Zbz
         UJ3cDJzcMUMt3uCVqxpYFj2cWHxd99v+O6E6N+mXohm1pGvbu6Syx+OdNF1bCAl0T5Pp
         zrLEbt1YFDY5EG/QJT88RP4K2IKi6RgIQrqeo+5gFD2Obf7V0/Lo4VuWtv619Yayil2+
         RdHHrEvlRJKsA/VegBY+MIxC1SPN+chtHc3X9rROefNIj2bdiDw1UC89zRCYJzMME2Gy
         AVYwAaPVgitj9W8Rd9Q0MLn1SQmaTgKqhp9eU9GFLJWXh9O9Jw4PIhwn6Axvuhq895Pq
         HylQ==
X-Gm-Message-State: AOAM530voA1LxOPljkpkHhPaPITJy9DcLBUPo7wY/49sGRhJyhOkGmt+
        52qDA6w+W4L2H5IUJY26wrDjmIYK9VEV2vEAn+yURjpFqntmWKGE/3N0SnwBfpKpp1zVL2uky+z
        HdJc6WYisLlOB+u+0eideIp1KrLxrQ0yo8Hlq/Qd/Ry44LiZKjt10Qg==
X-Google-Smtp-Source: ABdhPJzbNJ2hvEgX0+bNfa2nXNzYb50IQAFyhfFSmDJZcwmtxAC8M6c0ejmfO90Z+RlppX061RcodIk=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:dcf9:6f58:d879:8452])
 (user=sdf job=sendgmr) by 2002:a17:902:758b:b0:13e:8b1:e49f with SMTP id
 j11-20020a170902758b00b0013e08b1e49fmr1848732pll.6.1634770207600; Wed, 20 Oct
 2021 15:50:07 -0700 (PDT)
Date:   Wed, 20 Oct 2021 15:50:02 -0700
Message-Id: <20211020225005.2986729-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH bpf-next v3 0/3] libbpf: use func name when pinning programs
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
  bpftool: don't append / to the progtype
  selftests/bpf: fix flow dissector tests

 tools/bpf/bpftool/main.c                       |  4 ++++
 tools/bpf/bpftool/prog.c                       | 15 +--------------
 tools/lib/bpf/libbpf.c                         | 13 +++++++++++--
 tools/lib/bpf/libbpf_legacy.h                  |  3 +++
 .../selftests/bpf/flow_dissector_load.c        | 18 +++++++++++-------
 .../selftests/bpf/flow_dissector_load.h        | 10 ++--------
 .../selftests/bpf/test_flow_dissector.sh       | 10 +++++-----
 7 files changed, 37 insertions(+), 36 deletions(-)

-- 
2.33.0.1079.g6e70778dc9-goog

