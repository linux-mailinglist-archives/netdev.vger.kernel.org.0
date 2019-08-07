Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18FFF85033
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 17:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388746AbfHGPrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 11:47:24 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:34831 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388573AbfHGPrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 11:47:24 -0400
Received: by mail-pl1-f202.google.com with SMTP id s21so52609982plr.2
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 08:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=FB7cYJl37GdYtFaxc/8cPlb39n5o+VtlMRz941XZmBs=;
        b=YYfYso7jj0Mt0nR7vmsPM8MVIm3znMDXfEARxHjBpImFO7k9Gr51Trr80tjEgKQq6t
         DXPZZxmH1K7ngOnSHFCwqrHwnyp7C+npwOR187yn4zinqHX7Z2bn4OjD1l386zK2kKer
         eKZHXMzb8U52EaJOQyXTfwtzIbFgHP2MLYriTXnPzUWovi3C+CCRIOp1Cw0jCjzrlB1Z
         wCq2JTl20CpFZtTMpUTH5QI8S88K+XwdOhwUa48H5gLLoJjlpDdC98zvcx4K/SIqF9Rh
         mfQG9pOMrCXJXvvf8RHFQMfV3bGLJaqJ6MNThk9HbAd2b2Z2bRhDZsijgUqE8q1m0bzU
         B3PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=FB7cYJl37GdYtFaxc/8cPlb39n5o+VtlMRz941XZmBs=;
        b=fX7WzGh0mEWQWhVyIbFsdnpY/yG/xqxJTcY4DMQ9aekpcFW7GxC6gvUZcv9TFOcvEu
         QPLdicss7eRhD4TdkyzM2Vk0pDoE6+aU6u6awgyI7NF2+77XirFb66+C1zG0KICeoIsV
         EY4PdS5a0ULVQicEiT0U0Txa+KmeZTBPj9BHr7Ag4p5dLEMHCqus/2Ql6XFag0cMLlQX
         maDrxcNvXY49jhcUuU5bQO0q6uPLTZV7lnwW/i+qv7vNlAafKpSQJ7zeveIx82BbdRTN
         j7ooPPzRAxrqD5qEvS0Ac4Hk+sxpUrQ97L3UYGh37DY5niicizJZhZ5kxYuvWKxscsiO
         30Yw==
X-Gm-Message-State: APjAAAWsUUQRjLIzB24xF7ms45OBo3urBejrX2XTF9yZJFFQKFTjXc7M
        1IcnFXjzjGf8hTcTo5OPsX28x1L4KjEH2HElv2qeAGPNFsJtmIqGyOr6yw8ORJPeW0TFkP4fNYS
        MUXyNoEGHNe8sFxN/5+2C2nEWw2uVywMApmQhKxf1W9vuN4daQlnmsQ==
X-Google-Smtp-Source: APXvYqxOBipQ1nU/PK2ksfFxIR3S5nRdfHn+QDw0GR5JnLLwvqoTfG3AsFq82CUxRqQwIatZ+sLRSCI=
X-Received: by 2002:a65:4341:: with SMTP id k1mr8276047pgq.153.1565192842902;
 Wed, 07 Aug 2019 08:47:22 -0700 (PDT)
Date:   Wed,  7 Aug 2019 08:47:17 -0700
Message-Id: <20190807154720.260577-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
Subject: [PATCH bpf-next 0/3] bpf: support cloning sk storage on accept()
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently there is no way to propagate sk storage from the listener
socket to a newly accepted one. Consider the following use case:

        fd = socket();
        setsockopt(fd, SOL_IP, IP_TOS,...);
        /* ^^^ setsockopt BPF program triggers here and saves something
         * into sk storage of the listener.
         */
        listen(fd, ...);
        while (client = accept(fd)) {
                /* At this point all association between listener
                 * socket and newly accepted one is gone. New
                 * socket will not have any sk storage attached.
                 */
        }

Let's add new BPF_SK_STORAGE_GET_F_CLONE flag that can be passed to
bpf_sk_storage_get. This new flag indicates that that particular
bpf_sk_storage_elem should be cloned when the socket is cloned.

Cc: Martin KaFai Lau <kafai@fb.com>

Stanislav Fomichev (3):
  bpf: support cloning sk storage on accept()
  bpf: sync bpf.h to tools/
  selftests/bpf: add sockopt clone/inheritance test

 include/net/bpf_sk_storage.h                  |  10 +
 include/uapi/linux/bpf.h                      |   1 +
 net/core/bpf_sk_storage.c                     | 102 ++++++-
 net/core/sock.c                               |   9 +-
 tools/include/uapi/linux/bpf.h                |   1 +
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../selftests/bpf/progs/sockopt_inherit.c     | 102 +++++++
 .../selftests/bpf/test_sockopt_inherit.c      | 252 ++++++++++++++++++
 9 files changed, 473 insertions(+), 8 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/sockopt_inherit.c
 create mode 100644 tools/testing/selftests/bpf/test_sockopt_inherit.c

-- 
2.22.0.770.g0f2c4a37fd-goog
