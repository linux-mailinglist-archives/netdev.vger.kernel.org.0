Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC5E95F8B6B
	for <lists+netdev@lfdr.de>; Sun,  9 Oct 2022 15:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbiJINAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 09:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiJINAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 09:00:48 -0400
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9155224BFF;
        Sun,  9 Oct 2022 06:00:45 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4MlhtZ2ZDLz6Pm4S;
        Sun,  9 Oct 2022 20:58:30 +0800 (CST)
Received: from k01.huawei.com (unknown [10.67.174.197])
        by APP2 (Coremail) with SMTP id Syh0CgDHX9T6xUJjwRQEAA--.16593S2;
        Sun, 09 Oct 2022 21:00:43 +0800 (CST)
From:   Xu Kuohai <xukuohai@huaweicloud.com>
To:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Hou Tao <houtao1@huawei.com>,
        Dmitrii Dolgov <9erthalion6@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Kui-Feng Lee <kuifeng@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: [PATCH bpf-next 0/5] Fix bugs found by ASAN when running selftests
Date:   Sun,  9 Oct 2022 09:18:25 -0400
Message-Id: <20221009131830.395569-1-xukuohai@huaweicloud.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: Syh0CgDHX9T6xUJjwRQEAA--.16593S2
X-Coremail-Antispam: 1UD129KBjvdXoWruFyftFWDArW7AF4rZr47Jwb_yoW3ArXEyF
        4IqrykZFZrCa9IyFW5C3Z3WrWxC3yYqryIvFsrtr97J34j9r1UAF4kKFWSy3y8W3y3Jrya
        vFykX3y09r1aqjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb2xYFVCjjxCrM7AC8VAFwI0_Xr0_Wr1l1xkIjI8I6I8E6xAIw20E
        Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
        A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
        67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
        0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IY
        c2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s
        026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF
        0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0x
        vE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E
        87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUFDGOUUUUU
X-CM-SenderInfo: 50xn30hkdlqx5xdzvxpfor3voofrz/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        MAY_BE_FORGED,SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xu Kuohai <xukuohai@huawei.com>

Xu Kuohai (5):
  libbpf: Fix use-after-free in btf_dump_name_dups
  libbpf: Fix memory leak in parse_usdt_arg()
  selftests/bpf: Fix memory leak caused by not destroying skeleton
  selftest/bpf: Fix memory leak in kprobe_multi_test
  selftest/bpf: Fix error usage of ASSERT_OK in xdp_adjust_tail.c

 tools/lib/bpf/btf_dump.c                      | 47 +++++++++++----
 tools/lib/bpf/usdt.c                          | 59 +++++++++++--------
 .../selftests/bpf/prog_tests/bpf_iter.c       |  4 +-
 .../bpf/prog_tests/kprobe_multi_test.c        | 17 +++---
 .../selftests/bpf/prog_tests/map_kptr.c       |  3 +-
 .../selftests/bpf/prog_tests/tracing_struct.c |  3 +-
 .../bpf/prog_tests/xdp_adjust_tail.c          |  6 +-
 7 files changed, 88 insertions(+), 51 deletions(-)

-- 
2.25.1

