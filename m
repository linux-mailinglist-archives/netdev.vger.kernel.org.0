Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA2D3183D63
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 00:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgCLXgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 19:36:53 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33049 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbgCLXgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 19:36:52 -0400
Received: by mail-pf1-f193.google.com with SMTP id n7so4066632pfn.0;
        Thu, 12 Mar 2020 16:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BHD6uqp7YgjeQTLllKGum5ir3AQNVkNcS+0dNSKko9I=;
        b=JES7nxT/etO93DLIiXBqPdSkceugVFXLu7gDR61KmQH0sO1lrVdHowvg2oW/dTimq3
         ++U+cG3eLWpXaJovF+cuh18LvtFWijpdov8xMtRJ2QytegVVQEmUwqPW07Tk6c1pzPcw
         yEZ3s8Ra2oUdSBYwlknhE9S36syWq+sFQgHgNVz3l6/rCi6onBxSCpEJUz6EAtHBDOHG
         AUrj+SoGjcZBBN9uIck1yJo2M0J5h0a16lEIR0nIbIEg4Z37ptEFKQhe3DcJIYWYxRaK
         xAMbsVXnpg52ZG02tv2W1uzOVQeFQYdNQoNxjkjtdxLrOv6VH1dotVkm76P7W42PMnEQ
         MCaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=BHD6uqp7YgjeQTLllKGum5ir3AQNVkNcS+0dNSKko9I=;
        b=JnaTtwdcdjnJvqukWHPjoOAl3kI7OthjKmf9v24eLScrSRvB8udA3uyQQYIN5MxfOT
         n3FJx1/3EsXAXp8R4EKFyfileW/7xDrXzUlQiiLi0PkeTax7N1UdfFRVI8IkpOC5tQ42
         5RlXEx/avJzN2I3f5T7T1dM81mdRx/c3fmTIt/2ktrY1bPBrS53iqe6rqNVEUEaXdEqV
         Wsesiw4R/PmqSM6qTV4LtGTDKq8uy7Xdah/5/SEmiJxH0yfnA6Wtt+/5PHrqXL9xfBXo
         FPyUgJwf7o8ZhgZF6Zdt+kdVz2lPDq1a0xMkECmt1rSAqu11aSZ9GEzttmPfF5JiTFpG
         ISqw==
X-Gm-Message-State: ANhLgQ0ySkSi+l8oPHQOJxCciv/OFyJ+W8/QX1iw8Mcf2lU3P/VRfW2m
        3dlbkv9ex4WZbgHaDCE1CP6y9UY9
X-Google-Smtp-Source: ADFU+vsUWsi3noFKv1I+5Ul2Rsv4+5zX1xLpyEZmKpNoSZNm61oezHqFilm00pi8SNjF+5YHOjsrmg==
X-Received: by 2002:a62:e417:: with SMTP id r23mr10469042pfh.216.1584056210945;
        Thu, 12 Mar 2020 16:36:50 -0700 (PDT)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id d6sm5075225pfn.214.2020.03.12.16.36.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 16:36:50 -0700 (PDT)
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        eric.dumazet@gmail.com, lmb@cloudflare.com
Subject: [PATCH bpf-next 0/7] Add bpf_sk_assign eBPF helper
Date:   Thu, 12 Mar 2020 16:36:41 -0700
Message-Id: <20200312233648.1767-1-joe@wand.net.nz>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new helper that allows assigning a previously-found socket
to the skb as the packet is received towards the stack, to cause the
stack to guide the packet towards that socket subject to local routing
configuration.

This series is a spiritual successor to previous discussions on-list[0]
and in-person at LPC2019[1] to support TProxy use cases more directly
from eBPF programs attached at TC ingress, to simplify and streamline
Linux stack configuration in scale environments with Cilium.

Normally in ip{,6}_rcv_core(), the skb will be orphaned, dropping any
existing socket reference associated with the skb. Existing tproxy
implementations in netfilter get around this restriction by running the
tproxy logic after ip_rcv_core() in the PREROUTING table. However, this
is not an option for TC-based logic (including eBPF programs attached at
TC ingress).

This series proposes to introduce a new metadata destination,
dst_sk_prefetch, which communicates from earlier paths in the stack that
the socket has been prefetched and ip{,6}_rcv_core() should respect this
socket selection and retain the reference on the skb.

My initial implementation of the dst_sk_prefetch held no metadata and
was simply a unique pointer that could be used to make this
determination in the ip receive core. However, throughout the testing
phase it became apparent that this minimal implementation was not enough
to allow socket redirection for traffic between two local processes.
Specifically, if the destination was retained as the dst_sk_prefetch
metadata destination, or if the destination was dropped from the skb,
then during ip{,6}_rcv_finish_core() the destination would be considered
invalid and subject the packet to routing. In this case, loopback
traffic from 127.0.0.1 to 127.0.0.1 would be considered martian (both
martian source and martian destination) because that layer assumes that
any such loopback traffic would already have the valid loopback
destination configured on the skb so the routing check would be skipped.

To resolve this issue, I extended dst_sk_prefetch to act as a wrapper
for any existing destination (such as the loopback destination) by
stashing the existing destination into a per-cpu variable for the
duration of processing between TC ingress hook and the ip receive core.
Since the existing destination may be reference-counted, close attention
must be paid to any paths that may cause the packet to be queued for
processing on another CPU, to ensure that the reference is not lost. To
this end, the TC logic checks if the eBPF program return code may
indicate intention to pass the packet anywhere other than up the stack;
the error paths in skb cleanup handle the dst_sk_prefetch; and finally
after the skb_orphan check in ip receive core the original destination
reference (if available) is restored to the skb.

The eBPF API extension itself, bpf_sk_assign() is pretty straightforward
in that it takes an skb and socket, and associates them together. The
helper takes its own reference to the socket to ensure it remains
accessible beyond the release of rcu_read_lock, and the socket is
associated to the skb; the subsequent release of that reference is
handled by existing skb cleanup functions. Additionally, the helper
associates the new dst_sk_prefetch destination with the skb to
communicate the socket prefetch intention with the ingress path.

Finally, tests (courtesy Lorenz Bauer) are added to validate the
functionality. In addition to testing with the selftests in the tree,
I have validated the runtime behaviour of the new helper by extending
Cilium to make use of the functionality in lieu of existing tproxy
logic.

This series is laid out as follows:
* Patches 1-2 prepare the dst_sk_prefetch for use by sk_assign().
* Patch 3 extends the eBPF API for sk_assign and uses dst_sk_prefetch to
  store the socket reference and retain it through ip receive.
* Patch 4 is a minor optimization to prefetch the socket destination for
  established sockets.
* Patches 5-7 add and extend the selftests with examples of the new
  functionality and validation of correct behaviour.

[0] https://www.mail-archive.com/netdev@vger.kernel.org/msg303645.html
[1] https://linuxplumbersconf.org/event/4/contributions/464/

Joe Stringer (6):
  dst: Move skb_dst_drop to skbuff.c
  dst: Add socket prefetch metadata destinations
  bpf: Add socket assign support
  dst: Prefetch established socket destinations
  selftests: bpf: Extend sk_assign for address proxy
  selftests: bpf: Improve debuggability of sk_assign

Lorenz Bauer (1):
  selftests: bpf: add test for sk_assign

 include/linux/skbuff.h                        |   1 +
 include/net/dst.h                             |  14 --
 include/net/dst_metadata.h                    |  31 +++
 include/uapi/linux/bpf.h                      |  23 +-
 net/core/dst.c                                |  44 ++++
 net/core/filter.c                             |  28 +++
 net/core/skbuff.c                             |  18 ++
 net/ipv4/ip_input.c                           |   5 +-
 net/ipv6/ip6_input.c                          |   5 +-
 net/sched/act_bpf.c                           |   3 +
 tools/include/uapi/linux/bpf.h                |  18 +-
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../selftests/bpf/progs/test_sk_assign.c      | 127 ++++++++++
 tools/testing/selftests/bpf/test_sk_assign.c  | 231 ++++++++++++++++++
 tools/testing/selftests/bpf/test_sk_assign.sh |  22 ++
 16 files changed, 555 insertions(+), 19 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_sk_assign.c
 create mode 100644 tools/testing/selftests/bpf/test_sk_assign.c
 create mode 100755 tools/testing/selftests/bpf/test_sk_assign.sh

-- 
2.20.1

