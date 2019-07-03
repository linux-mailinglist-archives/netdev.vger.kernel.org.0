Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C98E5E9E5
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 19:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbfGCRCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 13:02:02 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:44565 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727200AbfGCRCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 13:02:02 -0400
Received: by mail-pg1-f202.google.com with SMTP id a21so1953690pgh.11
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 10:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=PtzfnXHwir5t+OK6oGGR3xyRGAh0lHKhLg6y74Z7SLI=;
        b=FizreZQfOB54x6CBxj83tADQPZPzVR8/wChupBATHtmbdgjnMryGONlVDgnxLjKuYq
         3VV5dEtzc3rOyy5BHnKAdcoRvGWEwoVjf/4+gik2NSUYKmlR/p8FJLpB3I4CraYn178/
         R/xmnUwfUUzqNmcvqRa/NCBw5cTyAwsSFFBHR5IN84dyIor/8zLJdz85Vq6yeh6BiG3p
         iMtK0ogb/8C/lHsfN6RP4nJpyWYaK7/S5EDQUK9vud4VnpKOCcjvX9dRX+YJrnb+bMkk
         OpdJazGd+BNI/aHArshaRwnW1fF14xznm3LZ54tHv8PTFWFF/fkib1YSARjkYPSwmc3l
         4y2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=PtzfnXHwir5t+OK6oGGR3xyRGAh0lHKhLg6y74Z7SLI=;
        b=mjb2iv/2T+e4QrK8jX2tim8MLEXLUc/78FEj+JbrFPoXDoiTw1Fv/FcTVW4eQ1wCeO
         SfJhG+GcqWH7cpLN7Y9bCDvzOyBRpMA1ZJ5VIjj5FD9rPEdx6oRMfo0vvF7wK8PPC/ty
         bL1+X9BFbmZxmty1kuik3JbrwCQ8XlYlfAOeMknswNVttA2mhHaf5xae259H6uqlZj4v
         Sx3GWl54uSm9HLTisnNMaiaqws6TBuWvwP0q6YCH+XhTBtEJ6LVSgRQ8frX1jGPHYCbu
         vX4gg3x9WWHTmD9ieZkSFZmjdBlQq/KpUBWFi/hlFDuqSVx7M89kyjt8lXHAmTv1S+ou
         nFCA==
X-Gm-Message-State: APjAAAXQl4tPS8gPfjZ3RwdDqWc7Pop+t/bWi5jiQs48wvq9+jAPXCnq
        5sR4kPsuP3FtckMg1KEUq61+f2D9tm1B
X-Google-Smtp-Source: APXvYqwFUIvxlm1JZsLTU/DwtWcZRSkjscpz9PkPbEih6Nz94MHK2bwBsb5v9GSWKe3fWIQGB7QB2+hNQMz9
X-Received: by 2002:a63:c03:: with SMTP id b3mr38912759pgl.68.1562173321483;
 Wed, 03 Jul 2019 10:02:01 -0700 (PDT)
Date:   Wed,  3 Jul 2019 10:01:12 -0700
Message-Id: <20190703170118.196552-1-brianvv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next RFC v3 0/6] bpf: add BPF_MAP_DUMP command to dump
 more than one entry per call
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Brian Vazquez <brianvv@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This introduces a new command to retrieve a variable number of entries
from a bpf map.

This new command can be executed from the existing BPF syscall as
follows:

err =  bpf(BPF_MAP_DUMP, union bpf_attr *attr, u32 size)
using attr->dump.map_fd, attr->dump.prev_key, attr->dump.buf,
attr->dump.buf_len
returns zero or negative error, and populates buf and buf_len on
succees

This implementation is wrapping the existing bpf methods:
map_get_next_key and map_lookup_elem
the results show that even with a 1-elem_size buffer, it runs ~40 faster
than the current implementation, improvements of ~85% are reported when
the buffer size is increased, although, after the buffer size is around
5% of the total number of entries there's no huge difference in
increasing it.

Tested:
Tried different size buffers to handle case where the bulk is bigger, or
the elements to retrieve are less than the existing ones, all runs read
a map of 100K entries. Below are the results(in ns) from the different
runs:

buf_len_1:	 69038725 entry-by-entry: 112384424 improvement
38.569134
buf_len_2:	 40897447 entry-by-entry: 111030546 improvement
63.165590
buf_len_230:	 13652714 entry-by-entry: 111694058 improvement
87.776687
buf_len_5000:	 13576271 entry-by-entry: 111101169 improvement
87.780263
buf_len_73000:	 14694343 entry-by-entry: 111740162 improvement
86.849542
buf_len_100000:	 13745969 entry-by-entry: 114151991 improvement
87.958187
buf_len_234567:	 14329834 entry-by-entry: 114427589 improvement
87.476941

Changelog:

v3:
- add explanation of the API in the commit message
- fix masked errors and return them to user
- copy last_key from return buf into prev_key if it was provided
- run test with kpti and retpoline mitigations

v2:
- use proper bpf-next tag

Brian Vazquez (6):
  bpf: add bpf_map_value_size and bp_map_copy_value helper functions
  bpf: add BPF_MAP_DUMP command to dump more than one entry per call
  bpf: keep bpf.h in sync with tools/
  libbpf: support BPF_MAP_DUMP command
  selftests/bpf: test BPF_MAP_DUMP command on a bpf hashmap
  selftests/bpf: add test to measure performance of BPF_MAP_DUMP

 include/uapi/linux/bpf.h                |   9 +
 kernel/bpf/syscall.c                    | 252 ++++++++++++++++++------
 tools/include/uapi/linux/bpf.h          |   9 +
 tools/lib/bpf/bpf.c                     |  28 +++
 tools/lib/bpf/bpf.h                     |   4 +
 tools/lib/bpf/libbpf.map                |   2 +
 tools/testing/selftests/bpf/test_maps.c | 147 +++++++++++++-
 7 files changed, 388 insertions(+), 63 deletions(-)

-- 
2.22.0.410.gd8fdbe21b5-goog

