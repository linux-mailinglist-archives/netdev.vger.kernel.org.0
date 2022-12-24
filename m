Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D22965565E
	for <lists+netdev@lfdr.de>; Sat, 24 Dec 2022 01:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbiLXAEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 19:04:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbiLXAEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 19:04:31 -0500
Received: from smtpout15.r2.mail-out.ovh.net (smtpout15.r2.mail-out.ovh.net [54.36.141.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792A0165AF
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 16:04:28 -0800 (PST)
Received: from ex4.mail.ovh.net (unknown [10.110.103.49])
        by mo512.mail-out.ovh.net (Postfix) with ESMTPS id 21A34248A2;
        Sat, 24 Dec 2022 00:04:25 +0000 (UTC)
Received: from dev-fedora-x86-64.naccy.de (37.65.8.229) by
 DAG10EX1.indiv4.local (172.16.2.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 24 Dec 2022 01:04:24 +0100
From:   Quentin Deslandes <qde@naccy.de>
To:     <qde@naccy.de>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        Dmitrii Banshchikov <me@ubique.spb.ru>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@meta.com>
Subject: [PATCH bpf-next v3 00/16] bpfilter
Date:   Sat, 24 Dec 2022 01:03:46 +0100
Message-ID: <20221224000402.476079-1-qde@naccy.de>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [37.65.8.229]
X-ClientProxiedBy: CAS6.indiv4.local (172.16.1.6) To DAG10EX1.indiv4.local
 (172.16.2.91)
X-Ovh-Tracer-Id: 4758897435487366775
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -85
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrheefgddujecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogetfedtuddqtdduucdludehmdenucfjughrpefhvfevufffkffoggfgtghisehtkeertdertddtnecuhfhrohhmpefsuhgvnhhtihhnucffvghslhgrnhguvghsuceoqhguvgesnhgrtggthidruggvqeenucggtffrrghtthgvrhhnpeejgeehueefjeeihfeugefftdehtdeikeduvdettefgieekffekuefgveekgedvheenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhusghunhhtuhdrtghomhenucfkphepuddvjedrtddrtddruddpfeejrdeihedrkedrvddvleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoehquggvsehnrggttgihrdguvgeqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepjhholhhsrgeskhgvrhhnvghlrdhorhhgpdhlihhnuhigqdhkshgvlhhfthgvshhtsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdgsphhfsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpmhgvsehusghiqhhuvgdrshhpsgdrrhhupdhshhhurghhsehkvghrnhgvlhdrohhrghdpmhihkhholhgrlhesfh
 gsrdgtohhmpdhprggsvghnihesrhgvughhrghtrdgtohhmpdhkuhgsrgeskhgvrhhnvghlrdhorhhgpdgvughumhgriigvthesghhoohhglhgvrdgtohhmpdgurghvvghmsegurghvvghmlhhofhhtrdhnvghtpdhkvghrnhgvlhdqthgvrghmsehmvghtrgdrtghomhdphhgrohhluhhosehgohhoghhlvgdrtghomhdpshgufhesghhoohhglhgvrdgtohhmpdhkphhsihhnghhhsehkvghrnhgvlhdrohhrghdpjhhohhhnrdhfrghsthgrsggvnhgusehgmhgrihhlrdgtohhmpdihhhhssehfsgdrtghomhdpshhonhhgsehkvghrnhgvlhdrohhrghdpmhgrrhhtihhnrdhlrghusehlihhnuhigrdguvghvpdgrnhgurhhiiheskhgvrhhnvghlrdhorhhgpdgurghnihgvlhesihhoghgvrghrsghogidrnhgvthdprghstheskhgvrhhnvghlrdhorhhgpdhnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhoheduvddpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patchset is based on the patches from David S. Miller [1],
Daniel Borkmann [2], and Dmitrii Banshchikov [3].

Note: I've partially sent this patchset earlier due to a
mistake on my side, sorry for then noise.

The main goal of the patchset is to prepare bpfilter for
iptables' configuration blob parsing and code generation.

The patchset introduces data structures and code for matches,
targets, rules and tables. Beside that the code generation
is introduced.

The first version of the code generation supports only "inline"
mode - all chains and their rules emit instructions in linear
approach.

Things that are not implemented yet:
  1) The process of switching from the previous BPF programs to the
     new set isn't atomic.
  2) No support of device ifindex - it's hardcoded
  3) No helper subprog for counters update

Another problem is using iptables' blobs for tests and filter
table initialization. While it saves lines something more
maintainable should be done here.

The plan for the next iteration:
  1) Add a helper program for counters update
  2) Handle ifindex

Patches 1/2 adds definitions of the used types.
Patch 3 adds logging to bpfilter.
Patch 4 adds an associative map.
Patch 5 add runtime context structure.
Patches 6/7 add code generation infrastructure and TC code generator.
Patches 8/9/10/11/12 add code for matches, targets, rules and table.
Patch 13 adds code generation for table.
Patch 14 handles hooked setsockopt(2) calls.
Patch 15 adds filter table
Patch 16 uses prepared code in main().

Due to poor hardware availability on my side, I've not been able to
benchmark those changes. I plan to get some numbers for the next iteration.

FORWARD filter chain is now supported, however, it's attached to
TC INGRESS along with INPUT filter chain. This is due to XDP not supporting
multiple programs to be attached. I could generate a single program
out of both INPUT and FORWARD chains, but that would prevent another
BPF program to be attached to the interface anyway. If a solution
exists to attach both those programs to XDP while allowing for other
programs to be attached, it requires more investigation. In the meantime,
INPUT and FORWARD filtering is supported using TC.

Most of the code in this series was written by Dmitrii Banshchikov,
my changes are limited to v3. I've tried to reflect this fact in the
commits by adding 'Co-developed-by:' and 'Signed-off-by:' for Dmitrii,
please tell me this was done the wrong way.

v2 -> v3
Chains:
  * Add support for FORWARD filter chain.
  * Add generation of BPF bytecode to assess whether a packet should be
    forwarded or not, using bpf_fib_lookup().
  * Allow for multiple programs to be attached to TC.
  * Allow for multiple TC hooks to be used.
Code generation:
  * Remove duplicated BPF bytecode generation.
  * Fix a bug regarding jump offset during generation.
  * Remove support for XDP from the series, as it's not currently
    used.
Table:
  * Add new filter_table_update_counters() virtual call. It updates
    the table's counter stored in the ipt_entry structure. This way,
    when iptables tries to fetch the values of the counters, bpfilter only
    has to copy the ipt_entry cached in the table structure.
Logging:
  * Refactor logging primitives.
Sockopts:
  * Add support for userspace counters querying.
Rule:
  * Store the rule's index inside struct rule, to each counters'
    map usage.

v1 -> v2
Maps:
  * Use map_upsert instead of separate map_insert and map_update
Matches:
  * Add a new virtual call - gen_inline. The call is used for
  * inline generating of a rule's match.
Targets:
  * Add a new virtual call - gen_inline. The call is used for inline
    generating of a rule's target.
Rules:
  * Add code generation for rules
Table:
  * Add struct table_ops
  * Add map for table_ops
  * Add filter table
  * Reorganize the way filter table is initialized
Sockopts:
  * Install/uninstall BPF programs while handling
    IPT_SO_SET_REPLACE
Code generation:
  * Add first version of the code generation
Dependencies:
  * Add libbpf

v0 -> v1
IO:
  * Use ssize_t in pvm_read, pvm_write for total_bytes
  * Move IO functions into sockopt.c and main.c
Logging:
  * Use LOGLEVEL_EMERG, LOGLEVEL_NOTICE, LOGLEVE_DEBUG
    while logging to /dev/kmsg
  * Prepend log message with <n> where n is log level
  * Conditionally enable BFLOG_DEBUG messages
  * Merge bflog.{h,c} into context.h
Matches:
  * Reorder fields in struct match_ops for tight packing
  * Get rid of struct match_ops_map
  * Rename udp_match_ops to xt_udp
  * Use XT_ALIGN macro
  * Store payload size in match size
  * Move udp match routines into a separate file
Targets:
  * Reorder fields in struct target_ops for tight packing
  * Get rid of struct target_ops_map
  * Add comments for convert_verdict function
Rules:
  * Add validation
Tables:
  * Combine table_map and table_list into table_index
  * Add validation
Sockopts:
  * Handle IPT_SO_GET_REVISION_TARGET

1. https://lore.kernel.org/patchwork/patch/902785/
2. https://lore.kernel.org/patchwork/patch/902783/
3. https://kernel.ubuntu.com/~cking/stress-ng/stress-ng.pdf

Quentin Deslandes (16):
  bpfilter: add types for usermode helper
  tools: add bpfilter usermode helper header
  bpfilter: add logging facility
  bpfilter: add map container
  bpfilter: add runtime context
  bpfilter: add BPF bytecode generation infrastructure
  bpfilter: add support for TC bytecode generation
  bpfilter: add match structure
  bpfilter: add support for src/dst addr and ports
  bpfilter: add target structure
  bpfilter: add rule structure
  bpfilter: add table structure
  bpfilter: add table code generation
  bpfilter: add setsockopt() support
  bpfilter: add filter table
  bpfilter: handle setsockopt() calls

 include/uapi/linux/bpfilter.h                 |  154 +++
 net/bpfilter/Makefile                         |   16 +-
 net/bpfilter/codegen.c                        | 1040 +++++++++++++++++
 net/bpfilter/codegen.h                        |  183 +++
 net/bpfilter/context.c                        |  168 +++
 net/bpfilter/context.h                        |   24 +
 net/bpfilter/filter-table.c                   |  344 ++++++
 net/bpfilter/filter-table.h                   |   18 +
 net/bpfilter/logger.c                         |   52 +
 net/bpfilter/logger.h                         |   80 ++
 net/bpfilter/main.c                           |  132 ++-
 net/bpfilter/map-common.c                     |   51 +
 net/bpfilter/map-common.h                     |   19 +
 net/bpfilter/match.c                          |   55 +
 net/bpfilter/match.h                          |   37 +
 net/bpfilter/rule.c                           |  286 +++++
 net/bpfilter/rule.h                           |   37 +
 net/bpfilter/sockopt.c                        |  533 +++++++++
 net/bpfilter/sockopt.h                        |   15 +
 net/bpfilter/table.c                          |  391 +++++++
 net/bpfilter/table.h                          |   59 +
 net/bpfilter/target.c                         |  203 ++++
 net/bpfilter/target.h                         |   57 +
 net/bpfilter/xt_udp.c                         |  111 ++
 tools/include/uapi/linux/bpfilter.h           |  175 +++
 .../testing/selftests/bpf/bpfilter/.gitignore |    8 +
 tools/testing/selftests/bpf/bpfilter/Makefile |   57 +
 .../selftests/bpf/bpfilter/bpfilter_util.h    |   80 ++
 .../selftests/bpf/bpfilter/test_codegen.c     |  338 ++++++
 .../testing/selftests/bpf/bpfilter/test_map.c |   63 +
 .../selftests/bpf/bpfilter/test_match.c       |   69 ++
 .../selftests/bpf/bpfilter/test_rule.c        |   56 +
 .../selftests/bpf/bpfilter/test_target.c      |   83 ++
 .../selftests/bpf/bpfilter/test_xt_udp.c      |   48 +
 34 files changed, 4999 insertions(+), 43 deletions(-)
 create mode 100644 net/bpfilter/codegen.c
 create mode 100644 net/bpfilter/codegen.h
 create mode 100644 net/bpfilter/context.c
 create mode 100644 net/bpfilter/context.h
 create mode 100644 net/bpfilter/filter-table.c
 create mode 100644 net/bpfilter/filter-table.h
 create mode 100644 net/bpfilter/logger.c
 create mode 100644 net/bpfilter/logger.h
 create mode 100644 net/bpfilter/map-common.c
 create mode 100644 net/bpfilter/map-common.h
 create mode 100644 net/bpfilter/match.c
 create mode 100644 net/bpfilter/match.h
 create mode 100644 net/bpfilter/rule.c
 create mode 100644 net/bpfilter/rule.h
 create mode 100644 net/bpfilter/sockopt.c
 create mode 100644 net/bpfilter/sockopt.h
 create mode 100644 net/bpfilter/table.c
 create mode 100644 net/bpfilter/table.h
 create mode 100644 net/bpfilter/target.c
 create mode 100644 net/bpfilter/target.h
 create mode 100644 net/bpfilter/xt_udp.c
 create mode 100644 tools/include/uapi/linux/bpfilter.h
 create mode 100644 tools/testing/selftests/bpf/bpfilter/.gitignore
 create mode 100644 tools/testing/selftests/bpf/bpfilter/Makefile
 create mode 100644 tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_codegen.c
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_map.c
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_match.c
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_rule.c
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_target.c
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_xt_udp.c

--
2.38.1
