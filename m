Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3508E843
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 11:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730774AbfHOJaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 05:30:35 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40267 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfHOJae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 05:30:34 -0400
Received: by mail-pf1-f194.google.com with SMTP id w16so1080043pfn.7;
        Thu, 15 Aug 2019 02:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o8ppvLOl3saOvysYo18eS3SnMUcJZgXDM6TpeIZgdv0=;
        b=WIyv95VjmHlA3jkwfsQmBMf5pbmFDq1ksWune3EDFhvaGzfC5D900b4L+v5WApn0Eu
         nQmxTNnnHA1IDZd+GgL3/roApZO9pGdzg8vZRXY1SmCz+Q2JZwjGA2Z1at3587rmvHgd
         2j2N3g4AkGD3lb3BaIpp48sggNObeoaQf9NTGZngxHgU+UtY8WLVJ7f5NQflh+qtiGZJ
         0Z9P7JIu0fMBPQ7yZ5CVANZAslfpVGByvU7qbeHoAswLhCuDNOR5g/GfEKVG4nxdHVsZ
         /PbkqJdioG6JJIA/PvZ/MLiNkqKRdSNe7BUVdKB8L9A8kQH92qjuJTWdJvSpVhtjsa9+
         3rsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o8ppvLOl3saOvysYo18eS3SnMUcJZgXDM6TpeIZgdv0=;
        b=AyCeg3YOnxcOv23OAK2f7y7YiLE4MWmMx+u4B+dYvSRGPmaGlE0lGOw0/YjckCqB6r
         B/auuxvkYkLGXTLpHKX75eyI8HpuGnZIVgZRsnon+Su7VG6nkMwh2FxQDDWjJ7vPQMRG
         mKBQlLMj18bkVNiuEyTSF/LsGLPk+EgzaRk0CNFvgkwfEQT5y6EbvzKqT6qaXTmiNMGV
         8IGX8HT6FLzJ/hIZajXwNse7Ko1YR/g5PEPlhXlNoRk8oW3H5TZHp2B4Zah5hAsH1+SM
         42O2SWf5gv0CYpxtLvl9SsQiWU+WGvLfUBvy18kX7kYg6AIoQuWEkizPCelhni4cCFbT
         WGyA==
X-Gm-Message-State: APjAAAVcXxkN8lZpFcEz4qp4/CUzPDlOhYcPvZLhWSesTUrIgqBceW94
        +3Etnn9dNlCpie+qzttm/9Q=
X-Google-Smtp-Source: APXvYqyeOtltvTvv4GBEwzWh2vOoUDIHASsSYRL4GR1aFDTSBXxf56Ml/D1mpttMIhDqyzQTXQZDgQ==
X-Received: by 2002:aa7:9117:: with SMTP id 23mr4492379pfh.206.1565861434007;
        Thu, 15 Aug 2019 02:30:34 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id g10sm2204195pfb.95.2019.08.15.02.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 02:30:33 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        bjorn.topel@intel.com, bruce.richardson@intel.com,
        songliubraving@fb.com, bpf@vger.kernel.org
Subject: [PATCH bpf-next v5 0/2] net: xdp: XSKMAP improvements
Date:   Thu, 15 Aug 2019 11:30:12 +0200
Message-Id: <20190815093014.31174-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series (v5 and counting) add two improvements for the XSKMAP,
used by AF_XDP sockets.

1. Automatic cleanup when an AF_XDP socket goes out of scope/is
   released. Instead of require that the user manually clears the
   "released" state socket from the map, this is done
   automatically. Each socket tracks which maps it resides in, and
   remove itself from those maps at relase. A notable implementation
   change, is that the sockets references the map, instead of the map
   referencing the sockets. Which implies that when the XSKMAP is
   freed, it is by definition cleared of sockets.

2. The XSKMAP did not honor the BPF_EXIST/BPF_NOEXIST flag on insert,
   which this patch addresses.


Thanks,
Björn

v1->v2: Fixed deadlock and broken cleanup. (Daniel)
v2->v3: Rebased onto bpf-next
v3->v4: {READ, WRITE}_ONCE consistency. (Daniel)
        Socket release/map update race. (Daniel)
v4->v5: Avoid use-after-free on XSKMAP self-assignment [1]. (Daniel)
        Removed redundant assignment in xsk_map_update_elem().
        Variable name consistency; Use map_entry everywhere.

[1] https://lore.kernel.org/bpf/20190802081154.30962-1-bjorn.topel@gmail.com/T/#mc68439e97bc07fa301dad9fc4850ed5aa392f385

Björn Töpel (2):
  xsk: remove AF_XDP socket from map when the socket is released
  xsk: support BPF_EXIST and BPF_NOEXIST flags in XSKMAP

 include/net/xdp_sock.h |  18 ++++++
 kernel/bpf/xskmap.c    | 133 ++++++++++++++++++++++++++++++++++-------
 net/xdp/xsk.c          |  50 ++++++++++++++++
 3 files changed, 179 insertions(+), 22 deletions(-)

-- 
2.20.1

