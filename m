Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C08D6125B43
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 07:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfLSGKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 01:10:22 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44648 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfLSGKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 01:10:22 -0500
Received: by mail-pg1-f194.google.com with SMTP id x7so2533060pgl.11;
        Wed, 18 Dec 2019 22:10:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xMF/TojBWQfbm302Q19EAXhnW35epVx/C2QbiWAVRrg=;
        b=o0VfzyZB2XM7zcVQpekRJ7iX2OsxCDxX5kp8yBCEgrG+HKjNFxYkydoWgfxj8GvPkL
         erqxOqefTcCgisfku6IVKJpfCEIzaG6gZ1DCi84sOUsrKmSlnzcKa8G5dnTVVBq/LTDA
         xarxhRAHcqF6iRoN+FVoGX9ATS9V6yBAmXnissEWKPjPuJKvg5L6arFg+WwAG1YFyKes
         BCmjAGkWwOtCVHCXvV8Bl1T8kydyxjI5yvio7MqVJTGenPQN5XLkCFLyWFR7Zpgpz0nz
         HyB2buyw/N7UTeg0Qxw/2PzrfWwhtanKveX9TxEIMEaooeKezkzorcfwAlkXFLCKev+5
         Bu2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xMF/TojBWQfbm302Q19EAXhnW35epVx/C2QbiWAVRrg=;
        b=gD8A4D+mOnsgg+2E3rqbOu0ZJN6gOwtJPf145LGZ635IXs6jkpagvO/KBwIOo/rWVp
         89UMP8TROVYGbe6JG9yJ3LnpDEMV8Dp8aIdKXKUVkhQ7V+jqkATwakFypgGHmTKjX6Kz
         LYVdL8gthFojDhjtbD/H6Pxh9vej3N/dVg5XDcqkp2JT+pnMWmn9kGfXbSiuF123Ge3E
         UAp4MlkTXkQbSwJ+qNa/8kijV9S4c6LnJcXXkmWrJ285w3nWHsbhh1LB1RvhKWBXCVlX
         4HOXtwKBoMXqhc2/fLlXdm1WGDJfczoN532JFRFiS64FnDopvdTlLLLBKrao6je6pc1u
         B1NA==
X-Gm-Message-State: APjAAAVpXdelXRe2Vj1cMf/BTv9Gtn7IUoF9vqc2EHs4GBXDJLs1wsGH
        Yb5SkSqY9letViMh+kIdShQ3QSJfIGv2dA==
X-Google-Smtp-Source: APXvYqwIM8ATVD+44r7227adjeEPmzMhZWSR1FtHFSYBY1i/1z54aTHyMNTsecpOjwHlFcmCjph3Aw==
X-Received: by 2002:a65:6794:: with SMTP id e20mr7374003pgr.152.1576735821334;
        Wed, 18 Dec 2019 22:10:21 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr04-ext.fm.intel.com. [192.55.55.39])
        by smtp.gmail.com with ESMTPSA id t23sm6465062pfq.106.2019.12.18.22.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 22:10:20 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        bpf@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v2 0/8] Simplify xdp_do_redirect_map()/xdp_do_flush_map() and XDP maps
Date:   Thu, 19 Dec 2019 07:09:58 +0100
Message-Id: <20191219061006.21980-1-bjorn.topel@gmail.com>
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

v1->v2 [1]:
  * Removed 'unused-variable' compiler warning (Jakub)

[1] https://lore.kernel.org/bpf/20191218105400.2895-1-bjorn.topel@gmail.com/

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
 kernel/bpf/xskmap.c    | 18 ++--------
 net/core/filter.c      | 63 ++++++----------------------------
 net/xdp/xsk.c          | 17 ++++-----
 8 files changed, 75 insertions(+), 197 deletions(-)

-- 
2.20.1

