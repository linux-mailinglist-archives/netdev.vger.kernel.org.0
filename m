Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83763261F3
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 12:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbhBZLYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 06:24:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbhBZLYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 06:24:14 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665D4C061574;
        Fri, 26 Feb 2021 03:23:34 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id k12so1177351ljg.9;
        Fri, 26 Feb 2021 03:23:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EPJggBpeYb8eU28hV8H8bOeLw1mBPLVDdvNDQZfoxnY=;
        b=c6IHZ+hbCajvFp0QM7BurCtS4orThxLtfhq9ptRpu2xZdNswijWUS57uYzf1Cdm0U3
         TCxlqllRjfgX3iW9PpCkUuA3n5d53ddsNGPWxzy4zxbrZECEUGXHacl98n2oyTTE+knK
         x9YEV/qDid4cYsb4W0UZw0JiJj+50p6PwyKqaRO+GIdKDC7hP39vN9dUckiscrXLtQOz
         nd/o3JwQ1ioZ/xYIjcCYyc6eLjwMZQYtNbpVekV27jgQbQArA0HpMuahVK2JHUeA+OH8
         LVKtiOZbr4JPOocBBIpU+4xKztAeQF+hMO68TjALB5P7FDYhmvjtWpoleP1V4YnjT+Yp
         UXFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EPJggBpeYb8eU28hV8H8bOeLw1mBPLVDdvNDQZfoxnY=;
        b=MwMZZ8MTmp2uys4MMp5t5GvDusCUBekpDXSHv/vAaJhCOy4/D/D4PVJEfeLLn4MHna
         oJVHcPxu6jEF/TEA5E1OfP72qzqD5pO5kYclxA8iO4yGvuwFsX7zo+VUTQFeIgAheOKv
         scHZ39g10IMhuAvVtgkpc795BGPnF3QTO9WVeB8DWBfvcVtFUTHm5L79lW1VRzE1T4df
         aHBq/+LPnXFA4jMf17AARf7e0OoSG2TojD07vcIAW2Zb2BAZ3J9gufIj86J0m9obS4Mv
         Ww4IqxlSM+h85C3ym4q5Bo/LIlAI94AFQIz+u7NIfNvnseJFsNKu6fdwMqrPETANP5PS
         9vOw==
X-Gm-Message-State: AOAM530XRPBpEbL8oy7crcfkcPSQWpBtODUvmb+oyS5Od46VojzV0HVe
        a2rqhJQ0YZyFWZNRojtqBWE=
X-Google-Smtp-Source: ABdhPJzPMybU2Rz/dWr+I0OBqC4FZewyhuPI+fXfauzu5WVq29LLfS4QMs422gDDn1XEiReKw9ttfw==
X-Received: by 2002:a2e:9244:: with SMTP id v4mr1499954ljg.196.1614338612929;
        Fri, 26 Feb 2021 03:23:32 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id c11sm1352282lfb.104.2021.02.26.03.23.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 03:23:31 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        bjorn.topel@intel.com, maciej.fijalkowski@intel.com,
        hawk@kernel.org, toke@redhat.com, magnus.karlsson@intel.com,
        john.fastabend@gmail.com, kuba@kernel.org, davem@davemloft.net
Subject: [PATCH bpf-next v4 0/2] Optimize bpf_redirect_map()/xdp_do_redirect()
Date:   Fri, 26 Feb 2021 12:23:20 +0100
Message-Id: <20210226112322.144927-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi XDP-folks,

This two patch series contain two optimizations for the
bpf_redirect_map() helper and the xdp_do_redirect() function.

The bpf_redirect_map() optimization is about avoiding the map lookup
dispatching. Instead of having a switch-statement and selecting the
correct lookup function, we let bpf_redirect_map() be a map operation,
where each map has its own bpf_redirect_map() implementation. This way
the run-time lookup is avoided.

The xdp_do_redirect() patch restructures the code, so that the map
pointer indirection can be avoided.

Performance-wise I got 3% improvement for XSKMAP
(sample:xdpsock/rx-drop), and 4% (sample:xdp_redirect_map) on my
machine.

More details in each commit.

@Jesper/Toke I dropped your Acked-by: on the first patch, since there
were major restucturing. Please have another look! Thanks!

Changelog:
v3->v4:  Made bpf_redirect_map() a map operation. (Daniel)

v2->v3:  Fix build when CONFIG_NET is not set. (lkp)

v1->v2:  Removed warning when CONFIG_BPF_SYSCALL was not set. (lkp)
         Cleaned up case-clause in xdp_do_generic_redirect_map(). (Toke)
         Re-added comment. (Toke)

rfc->v1: Use map_id, and remove bpf_clear_redirect_map(). (Toke)
         Get rid of the macro and use __always_inline. (Jesper)

rfc: https://lore.kernel.org/bpf/87im7fy9nc.fsf@toke.dk/ (Cover not on lore!)
v1:  https://lore.kernel.org/bpf/20210219145922.63655-1-bjorn.topel@gmail.com/
v2:  https://lore.kernel.org/bpf/20210220153056.111968-1-bjorn.topel@gmail.com/
v3:  https://lore.kernel.org/bpf/20210221200954.164125-3-bjorn.topel@gmail.com/


Cheers,
Björn

Björn Töpel (2):
  bpf, xdp: make bpf_redirect_map() a map operation
  bpf, xdp: restructure redirect actions

 include/linux/bpf.h        |  26 ++----
 include/linux/filter.h     |  39 +++++++-
 include/net/xdp_sock.h     |  19 ----
 include/trace/events/xdp.h |  66 ++++++++-----
 kernel/bpf/cpumap.c        |  10 +-
 kernel/bpf/devmap.c        |  19 +++-
 kernel/bpf/verifier.c      |  11 ++-
 net/core/filter.c          | 183 ++++++++++++-------------------------
 net/xdp/xskmap.c           |  20 +++-
 9 files changed, 195 insertions(+), 198 deletions(-)


base-commit: 9c8f21e6f8856a96634e542a58ef3abf27486801
-- 
2.27.0

