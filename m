Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8163DF3A57
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 22:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfKGVU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 16:20:59 -0500
Received: from mail-vk1-f201.google.com ([209.85.221.201]:44300 "EHLO
        mail-vk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbfKGVU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 16:20:58 -0500
Received: by mail-vk1-f201.google.com with SMTP id 131so1702061vkb.11
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 13:20:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=6u+JVwA832DZQxhqfbOLyuFUBvBp6cNKT0wKluwBqRo=;
        b=lEBiQrXrWG2wgDQ5zKGOW/z/xlj8J49kypK3w0hinwPeCT677Eg7dvxvkhFgzLrVqp
         S++7WbHgea82mstavCEFzyAMWY2wuwq8Gerfc6BtUeAYtbIRoNAQRmlMIlYfTHwz7oKj
         KEqkrXA7ENGPmHoLzYoeQsjdWmgeezFvZWulnoQQvenVlih4e3cFhM06gBQhN7u8Ct/c
         ApHxqmKj8SoZKcMNLlIfyG6E1KlG42g+IqSSbvwQGSrrpxeCZEs8ICdFG5Umpkqyzwx7
         z2KtetpehWpXXq2oXZktoFUXD3+AfQW2EySMRbXSOosav1cNFn9Nko7ktJP3P63PHCm9
         4q8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=6u+JVwA832DZQxhqfbOLyuFUBvBp6cNKT0wKluwBqRo=;
        b=ldiWPjiTcQWkgPBooRC7kctgIY7ulRhQ3bn/Ssug2usvDWvKZFWuCFlX8XUNEwyh2b
         V9MdsnuUo1u3ONH+wDhceUxOnBK2hwi1I9g2O3rrw9UOlPCjhgTAD3g/3tetHQg+jHx4
         cVlgGTuCQ9Yojw/8E134JyEr0jxS2zHvZ/HJW4BiszV5KkboDIDS4asJJma9dK93U4FY
         3wfci8BqzSFn9kaC7g+16Mm6xjQ/Da70Zp/IeO2uea0i0jGht7xQAyKZLxJR6VubYeNe
         /+LCggphb9ExNV7V9Ztn9ijBqe+ukI1+Ue/JFy35JXk6ynUD9pFZ4PIY/xS2iWQ2qq6H
         MvWQ==
X-Gm-Message-State: APjAAAWwNn4IW/qQgInlUZ4qEIC/+Tgg5L6qkQpcD3JsVzUIEeBsHGYJ
        LbnMCi+KCi2mhbo9pVNFZuBwQO5tfVf4
X-Google-Smtp-Source: APXvYqzpumSDeu8ZP1lfOlkqBFt9sUKekSDorrhgsHkr2cVXPIkQgi5uqfL4smd7tma3keIpb+KCpr07/yBA
X-Received: by 2002:ac5:c7b1:: with SMTP id d17mr1927609vkn.90.1573161657334;
 Thu, 07 Nov 2019 13:20:57 -0800 (PST)
Date:   Thu,  7 Nov 2019 13:20:20 -0800
Message-Id: <20191107212023.171208-1-brianvv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [RFC bpf-next 0/3] bpf: adding map batch processing support
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Stanislav Fomichev <sdf@google.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Brian Vazquez <brianvv@google.com>, Yonghong Song <yhs@fb.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a follow up in the effort to batch bpf map operations to reduce
the syscall overhead with the map_ops. I initially proposed the idea and
the discussion is here:
https://lore.kernel.org/bpf/20190724165803.87470-1-brianvv@google.com/

Yonghong talked at the LPC about this and also proposed and idea that
handles the special weird case of hashtables by doing traversing using
the buckets as a reference instead of a key. Discussion is here:
https://lore.kernel.org/bpf/20190906225434.3635421-1-yhs@fb.com/

This RFC proposes a way to extend batch operations for more data
structures by creating generic batch functions that can be used instead
of implementing the operations for each individual data structure,
reducing the code that needs to be maintained. The series contains the
patches used in Yonghong's RFC and the patch that adds the generic
implementation of the operations plus some testing with pcpu hashmaps
and arrays. Note that pcpu hashmap shouldn't use the generic
implementation and it either should have its own implementation or share
the one introduced by Yonghong, I added that just as an example to show
that the generic implementation can be easily added to a data structure.

What I want to achieve with this RFC is to collect early feedback and see if
there's any major concern about this before I move forward. I do plan
to better separate this into different patches and explain them properly
in the commit messages.

Current known issues where I would like to discuss are the followings:

- Because Yonghong's UAPI definition was done specifically for
  iterating buckets, the batch field is u64 and is treated as an u64
  instead of an opaque pointer, this won't work for other data structures
  that are going to use a key as a batch token with a size greater than
  64. Although I think at this point the only key that couldn't be
  treated as a u64 is the key of a hashmap, and the hashmap won't use
  the generic interface.
- Not all the data structures use delete (because it's not a valid
  operation) i.e. arrays. So maybe lookup_and_delete_batch command is
  not needed and we can handle that operation with a lookup_batch and a
  flag.
- For delete_batch (not just the lookup_and_delete_batch). Is this
  operation really needed? If so, shouldn't it be better if the
  behaviour is delete the keys provided? I did that with my generic
  implementation but Yonghong's delete_batch for a hashmap deletes
  buckets.

Brian Vazquez (1):
  bpf: add generic batch support

Yonghong Song (2):
  bpf: adding map batch processing support
  tools/bpf: test bpf_map_lookup_and_delete_batch()

 include/linux/bpf.h                           |  21 +
 include/uapi/linux/bpf.h                      |  22 +
 kernel/bpf/arraymap.c                         |   4 +
 kernel/bpf/hashtab.c                          | 331 ++++++++++
 kernel/bpf/syscall.c                          | 573 ++++++++++++++----
 tools/include/uapi/linux/bpf.h                |  22 +
 tools/lib/bpf/bpf.c                           |  59 ++
 tools/lib/bpf/bpf.h                           |  13 +
 tools/lib/bpf/libbpf.map                      |   4 +
 .../map_tests/map_lookup_and_delete_batch.c   | 245 ++++++++
 .../map_lookup_and_delete_batch_array.c       | 118 ++++
 11 files changed, 1292 insertions(+), 120 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch.c
 create mode 100644 tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch_array.c

-- 
2.24.0.432.g9d3f5f5b63-goog

