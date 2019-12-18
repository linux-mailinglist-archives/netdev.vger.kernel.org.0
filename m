Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE74124518
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 11:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbfLRKyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 05:54:14 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41560 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbfLRKyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 05:54:14 -0500
Received: by mail-pg1-f196.google.com with SMTP id x8so1065801pgk.8;
        Wed, 18 Dec 2019 02:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hwpsUhyZsfHCNjF4eNiWzpTYwTbv88FHlBd9oVRH0pE=;
        b=om7cunqP96nf6trFocxjZWI4Xx3VUf5dQbESRPBLMZWof4rg99kN8wpk17n+2Zm5KY
         VoI3RP8A+arAoKlNenMMIdeEvXXyUMgrV/H4/lvuFdgiLUkw0jJNFNYmdmBeih1FIXDz
         M1E0c6y80Y+HGtsTZpr10JciXJ9/9hEt4LiwJVC0BLj3Z+IxDj3kIH6rh+K+yJ3cTttf
         lvH5ljonxS3HXGsU8OoivjtPUFRpWCeiuthYIm+xPTe3GNvh6f8siZElY1ZMicbJWjdS
         3ZlmWchAsLtC0MuSyxCrDd09aIJRJ/a6RniAdRcODsS4cxkJK7qOFtKUx5aqTyERbMhd
         GE7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hwpsUhyZsfHCNjF4eNiWzpTYwTbv88FHlBd9oVRH0pE=;
        b=GE4M4y1TXL3zKyl+vewhDESOz31WNgkHoPvPhAZQl8uog0ZMp0utAQlvD2sMR7DMgH
         xW6wtaCajqb1LUbYXgTxTIvJ+oVGPNpl6Go33feWvVewE2Q1Ut1P+1+aT2D6h95Qs+Pc
         ZVfrn3F5nYr4RRvdzPe1Bj7zLszOl5CfvfybQVuv8iAfUvhYJ6+cOMNykYluWQJ0gv3t
         Oj29XvUihFAbQeczlfySjXGoXftjYmX5FSI1Q9AFEfkC69w6kDKHculN41xoZPD1Tz0F
         1a5S5Jn7EOjmA9o3yrvPxaAgNKSYm6ct9GQ9+PAPR+RO4N9zIA40KVyhGtnUC8CMAa3P
         953w==
X-Gm-Message-State: APjAAAWGcn2KEc8ALdx15dSJGpYWMvnhm5qFwK9/MMIOvutBzdUUaK/X
        mJA1+0/hcr/aU6WmA9F396XQ8+J/y1aIDQ==
X-Google-Smtp-Source: APXvYqwuc592zteIatBecsGu/KvnMOiQhY9KWS34GG6Sjzv93msd+8PW1nMg2ZMn/p/N2wKsNT/RhQ==
X-Received: by 2002:aa7:9118:: with SMTP id 24mr2394656pfh.182.1576666453164;
        Wed, 18 Dec 2019 02:54:13 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id k9sm2339000pje.26.2019.12.18.02.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 02:54:12 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        bpf@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Subject: [PATCH bpf-next 0/8] Simplify xdp_do_redirect_map()/xdp_do_flush_map() and XDP maps
Date:   Wed, 18 Dec 2019 11:53:52 +0100
Message-Id: <20191218105400.2895-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series aims to simplify the XDP maps and
xdp_do_redirect_map()/xdp_do_flush_map(), and to crank out some more
performance from XDP_REDIRECT scenarios.

The first part of the series simplifies all XDP_REDIRECT capable maps,
so that __XXX_flush_map() does not require the map parameter, by
moving the flush list from the map to global scope.

This results in that the map_to_flush member can be removed from
struct bpf_redirect_info, and its corresponding logic.

Simpler code, and more performance due to that checks/code per-packet
is moved to flush.

Pre-series performance:
  $ sudo taskset -c 22 ./xdpsock -i enp134s0f0 -q 20 -n 1 -r -z
  
   sock0@enp134s0f0:20 rxdrop xdp-drv 
                  pps         pkts        1.00       
  rx              20,797,350  230,942,399
  tx              0           0          
  
  $ sudo ./xdp_redirect_cpu --dev enp134s0f0 --cpu 22 xdp_cpu_map0
  
  Running XDP/eBPF prog_name:xdp_cpu_map5_lb_hash_ip_pairs
  XDP-cpumap      CPU:to  pps            drop-pps    extra-info
  XDP-RX          20      7723038        0           0
  XDP-RX          total   7723038        0
  cpumap_kthread  total   0              0           0
  redirect_err    total   0              0
  xdp_exception   total   0              0

Post-series performance:
  $ sudo taskset -c 22 ./xdpsock -i enp134s0f0 -q 20 -n 1 -r -z

   sock0@enp134s0f0:20 rxdrop xdp-drv 
                  pps         pkts        1.00       
  rx              21,524,979  86,835,327 
  tx              0           0          
  
  $ sudo ./xdp_redirect_cpu --dev enp134s0f0 --cpu 22 xdp_cpu_map0

  Running XDP/eBPF prog_name:xdp_cpu_map5_lb_hash_ip_pairs
  XDP-cpumap      CPU:to  pps            drop-pps    extra-info
  XDP-RX          20      7840124        0           0          
  XDP-RX          total   7840124        0          
  cpumap_kthread  total   0              0           0          
  redirect_err    total   0              0          
  xdp_exception   total   0              0          
  
Results: +3.5% and +1.5% for the ubenchmarks.

Björn Töpel (8):
  xdp: simplify devmap cleanup
  xdp: simplify cpumap cleanup
  xdp: fix graze->grace type-o in cpumap comments
  xsk: make xskmap flush_list common for all map instances
  xdp: make devmap flush_list common for all map instances
  xdp: make cpumap flush_list common for all map instances
  xdp: remove map_to_flush and map swap detection
  xdp: simplify __bpf_tx_xdp_map()

 include/linux/bpf.h    |  8 ++---
 include/linux/filter.h |  1 -
 include/net/xdp_sock.h | 11 +++---
 kernel/bpf/cpumap.c    | 76 ++++++++++++++--------------------------
 kernel/bpf/devmap.c    | 78 ++++++++++--------------------------------
 kernel/bpf/xskmap.c    | 16 ++-------
 net/core/filter.c      | 63 ++++++----------------------------
 net/xdp/xsk.c          | 17 ++++-----
 8 files changed, 74 insertions(+), 196 deletions(-)

-- 
2.20.1

