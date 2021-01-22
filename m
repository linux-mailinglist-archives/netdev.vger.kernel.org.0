Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51ABC300259
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 13:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbhAVMCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 07:02:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727830AbhAVKyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 05:54:39 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B906C0613D6;
        Fri, 22 Jan 2021 02:53:58 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id i17so6036026ljn.1;
        Fri, 22 Jan 2021 02:53:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9ttycuPeReUoQnqmnkr+4N6fpkeVmdnNon7uvunZTO8=;
        b=WuEt3yTfeYvgeVJCoYXrXDsUKICAOPgOX+y17tpiHQZbk1zETenjgFzBtil3cGKzGA
         RfOR5uWpd37wQ0Fpzc6zrazlpCf+W28gpeevCx79RmdM4OkzdTKgEju5u7wUum32jlgX
         a3wCKXcBrjRgrUpsN4VcBXJMI29k1f/ZhDDIzoBwNH8dwPY90m5JuAimIi4bxsgrF4Tk
         CsueL02jHqBrIB0JWg9S1CKJtcGdgX6jyQXGgqet0/dsT/kATu2NADRbMoCbqc3SxDcm
         aGd8cgsrH0Rhjap+TfW0Lry4YoQ4zovEeSIAb7IdGv7M1W2DmmtkSpBjoJV+kQ7ut4Iy
         R6oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9ttycuPeReUoQnqmnkr+4N6fpkeVmdnNon7uvunZTO8=;
        b=Aqv/GzWfD409Q2iQLyr9deqD8fuxF/trztUhwZGm6JvtiOGw0Yvj9m1Nx1IuQ6faAF
         8BKCnc8TzJaO+u9N4AHv5y5bNycFlPITb0S8VQoY7iA2Mvp+cAP+rG4mhLFjg/a0/7nk
         UuxOErYYmxb/pCDbrK4zT2IByRGfVgizyp6xJuyAZqQXDxaHCa9jKw2IJtzynrWHENtr
         IIQuJg+eq6quqNk3ZKuou1y8fLr7elI1U52Y4UTQ799cXJZhTsiMmVupzZkJnEMaWIXh
         zhf/QQBI2JBJaTfkSkDZOvzXhWqVvoGyyQhNFuNxGJLQXAcindYVbM0safNCAYEzozXs
         K3Tg==
X-Gm-Message-State: AOAM532OJUNDGPBthEtWBBdbtft4kEONhiqEcUTguOxULy7eyUpH+B57
        IlUHurLKWR7YRWMzHVontTk=
X-Google-Smtp-Source: ABdhPJwv8PFdERwSrLORMAKf+sTGW4Bp5YQG4TGx3wXXTLDFKO0s+3xgQOmcTLoptsIvKBxpG4UuCg==
X-Received: by 2002:a2e:b896:: with SMTP id r22mr207881ljp.234.1611312836769;
        Fri, 22 Jan 2021 02:53:56 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id g14sm409580lja.120.2021.01.22.02.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 02:53:56 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, kuba@kernel.org,
        jonathan.lemon@gmail.com, maximmi@nvidia.com, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, ciara.loftus@intel.com,
        weqaar.a.janjua@intel.com, andrii@kernel.org
Subject: [PATCH bpf-next 0/3] AF_XDP clean up/perf improvements
Date:   Fri, 22 Jan 2021 11:53:48 +0100
Message-Id: <20210122105351.11751-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series has some clean up/performance improvements for XDP
sockets.

The first two patches are cleanups for the AF_XDP core, and the
restructure actually give a little performance boost.

The last patch adds support for selecting AF_XDP BPF program, based on
what the running kernel supports.

The patches were earlier part of the bigger "bpf_redirect_xsk()"
series [1]. I pulled out the non-controversial parts into this series.

Thanks to Maciej and Magnus for the internal review/comments!

Thanks to Toke, Alexei, and Andrii for the "auto-detection" help;
Instead of basing it on kernel version, a run-time test is
performed. Note that I did not add the probing support to libbpf.c,
where the other probes reside. Instead it's in xsk.c. The reason for
that is that AF_XDP will be moved out from libbpf post-1.0, to libxdp.


Thanks,
Björn

[1] https://lore.kernel.org/bpf/20210119155013.154808-1-bjorn.topel@gmail.com/

Björn Töpel (3):
  xsk: remove explicit_free parameter from __xsk_rcv()
  xsk: fold xp_assign_dev and __xp_assign_dev
  libbpf, xsk: select AF_XDP BPF program based on kernel version

 net/xdp/xsk.c           | 47 +++++++++++++++--------
 net/xdp/xsk_buff_pool.c | 12 ++----
 tools/lib/bpf/xsk.c     | 82 +++++++++++++++++++++++++++++++++++++++--
 3 files changed, 113 insertions(+), 28 deletions(-)


base-commit: 443edcefb8213155c0da22c4a999f4a49858fa39
-- 
2.27.0

