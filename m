Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 402E88DC02
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbfHNRhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:37:55 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:49780 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728219AbfHNRhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 13:37:55 -0400
Received: by mail-pf1-f202.google.com with SMTP id s10so5315281pfd.16
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 10:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=kS4HFtdoUVzLJNg9knOvao1cqPc/u1eyKiHYUxjODT4=;
        b=LhUmTwT5OxGnPet+OShHkEeLVjxxoFPUoy7M1+hZO7Kv1j+ZtQPHVj+liSSH1aCXKn
         cKvbDohuHrot1lp/OdEYaVrb90KzKyhAsJ59QOjgjVr147svzOPzI+lnWH7BfAjO4qUc
         NqOfPWULkbofqDklbEly6cgRQbXvfm87vtZdbD0vLL2ObGZpJ+UGLbdjXo0QKCCjd8Ie
         dKcqtBEwNWlQQy8mnuGdf0OfrzSZX5xte0g0bZJETNeRLvHnXaFWSSTDoNmRu8c0pNa7
         7G72MbnMlJz+T5yb8fLaAUi6h2Gdkd/01PMw8VyOUMVOmX77R1XvE7TeiCCQRHa6Th/J
         VA5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=kS4HFtdoUVzLJNg9knOvao1cqPc/u1eyKiHYUxjODT4=;
        b=byCeo5ZO06np7pifPg9pAk5/cvnIH4HvpQYnlrBKjlvbyKfEHUsmNSzjl9pZVmeBNB
         JJSS/kaIfdt+TjcAUR4L7rW04Rjy4sRbhty5lrz2K6hWAvcSFIa11zdBHgACcV8ilz1r
         lJPq7PkwLnVfbo/W64QmzLp3YTsKY20YF2CL9cTUqIJY6egOmcaj3wzpQrWLi37UqaHx
         CZA0T+YlMtOfu7XyXlIqBfGySpXeXN2TgwSBTU7YYojumxx8AnHHLOBnh5Bd2W6kyMLl
         UtWp9Lq3wNNLFsbkTSNzXbGSUj7j3onNFBLyg1Geo52ZZ0zVIBMG698lY3ROgk9FGC2F
         eaQA==
X-Gm-Message-State: APjAAAWbeu2Vw94TSWAo7AjRQy6miGTAq10NIojKyd13Z5HbMIg9KWND
        6GWsgII7HO1XKZdy7qHiKc8R2UkT2xQeS/Y2QnReWlA16o0fsVNSLGMGiVKyBcYvw34rDrHAyJz
        XNaWHBZOHGgz8cGUj0jhy58FSItXr1ae3zEch+DLDx8GD6kv955JFmg==
X-Google-Smtp-Source: APXvYqy/QCkwe3BXL4AXbk1zRnEO7bfhhJgRgZB82zOeaWwYMR4fWrE+i4W8+ii+MursSPLmIQWeW84=
X-Received: by 2002:a63:5754:: with SMTP id h20mr257145pgm.195.1565804274166;
 Wed, 14 Aug 2019 10:37:54 -0700 (PDT)
Date:   Wed, 14 Aug 2019 10:37:47 -0700
Message-Id: <20190814173751.31806-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH bpf-next v4 0/4] bpf: support cloning sk storage on accept()
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>
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

Let's add new BPF_F_CLONE flag that can be specified when creating
a socket storage map. This new flag indicates that map contents
should be cloned when the socket is cloned.

v4:
* drop 'goto err' in bpf_sk_storage_clone (Yonghong Song)
* add comment about race with bpf_sk_storage_map_free to the
  bpf_sk_storage_clone side as well (Daniel Borkmann)

v3:
* make sure BPF_F_NO_PREALLOC is always present when creating
  a map (Martin KaFai Lau)
* don't call bpf_sk_storage_free explicitly, rely on
  sk_free_unlock_clone to do the cleanup (Martin KaFai Lau)

v2:
* remove spinlocks around selem_link_map/sk (Martin KaFai Lau)
* BPF_F_CLONE on a map, not selem (Martin KaFai Lau)
* hold a map while cloning (Martin KaFai Lau)
* use BTF maps in selftests (Yonghong Song)
* do proper cleanup selftests; don't call close(-1) (Yonghong Song)
* export bpf_map_inc_not_zero

Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Yonghong Song <yhs@fb.com>

Stanislav Fomichev (4):
  bpf: export bpf_map_inc_not_zero
  bpf: support cloning sk storage on accept()
  bpf: sync bpf.h to tools/
  selftests/bpf: add sockopt clone/inheritance test

 include/linux/bpf.h                           |   2 +
 include/net/bpf_sk_storage.h                  |  10 +
 include/uapi/linux/bpf.h                      |   3 +
 kernel/bpf/syscall.c                          |  16 +-
 net/core/bpf_sk_storage.c                     | 104 ++++++-
 net/core/sock.c                               |   9 +-
 tools/include/uapi/linux/bpf.h                |   3 +
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../selftests/bpf/progs/sockopt_inherit.c     |  97 +++++++
 .../selftests/bpf/test_sockopt_inherit.c      | 253 ++++++++++++++++++
 11 files changed, 491 insertions(+), 10 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/sockopt_inherit.c
 create mode 100644 tools/testing/selftests/bpf/test_sockopt_inherit.c

-- 
2.23.0.rc1.153.gdeed80330f-goog
