Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFAAE330C5F
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 12:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbhCHL3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 06:29:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbhCHL3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 06:29:15 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07259C06174A;
        Mon,  8 Mar 2021 03:29:15 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id p21so20386711lfu.11;
        Mon, 08 Mar 2021 03:29:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wSXMuIgIAUA+amLMZ20gsCEn4zpPiHgfPAph2mmiBD4=;
        b=XWss/uLwm5zaujVON13jcvkWRPgp3y2oMxZUeT7H0H9dsrrRVRjDUNrUPzIY0mxG70
         RulpkTaIKJZdERMhvpQ2ejEfNYFKO4fXFALYLrSi7aNUTLkyslC58uZxllo4U3J4NFvC
         9Xsc3Y3qRO6CPSW6qP7+Xb/VX+xMKtR5JhXivfrsqG0FH3gES2YZHecRUkdDGx6UTeO/
         BaSyPwNC7ZiM9uyNwZFapqrRiffrn86xlZrsd+pulqErALYxiubTt2fDeXLfyTEI5VdM
         cNC/7ExQHjx9HxGllsbg6RCFINyhl5oNNDzC7lT4MVGQszIDKd8o5tc6yfrv/qVBV9+f
         ZWpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wSXMuIgIAUA+amLMZ20gsCEn4zpPiHgfPAph2mmiBD4=;
        b=c5tV9A4zEasr42dTo9GGVR/Ojs5UYzmQNzZaYkOz1XuyodpoSnwm1Ei0bBUwORYt48
         X4ATmZunq3zGWLmhAD8Ue0g9u/Hsg6/mDt71bnz35GUssAhaCcBXTUYj9TczuZmteEXx
         SC6AhezLuZY0iBYeYImgnyYPucFv00+9ppzw9ysFI1r0SA/1yDZRXhajaeSqd+70KYjf
         UZ8iRzg6t+xbJlmXs8OcFmEgtYIk7mgzN9TTlMAofkdbrtpYBOe+H8AgRJIT3DDRPry7
         w3C4qoUfaA8RX8y/J3U1tCoSzVwo7CsCXhFQSezp3+1iWAL40dM+ZCQgpSf/w3B57LdG
         IoQA==
X-Gm-Message-State: AOAM533ESaZ1aEiHce4PMmZE7xBnL0WjlHiGCVqPDgCTYNjpHBPZATbe
        aWc6Cqr3ObVkNGAgh8Rvhkk=
X-Google-Smtp-Source: ABdhPJwCLywPi2RdkjW4AzJTyesrtsU1J8skr6Iiwp54r4RD0aRYNd7AfE5fzYpUtLtOexdxu2/A3A==
X-Received: by 2002:ac2:446d:: with SMTP id y13mr13995766lfl.365.1615202953562;
        Mon, 08 Mar 2021 03:29:13 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id w23sm1456145lji.127.2021.03.08.03.29.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 03:29:12 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        bjorn.topel@intel.com, maciej.fijalkowski@intel.com,
        hawk@kernel.org, toke@redhat.com, magnus.karlsson@intel.com,
        john.fastabend@gmail.com, kuba@kernel.org, davem@davemloft.net
Subject: [PATCH bpf-next v6 0/2] Optimize bpf_redirect_map()/xdp_do_redirect()
Date:   Mon,  8 Mar 2021 12:29:05 +0100
Message-Id: <20210308112907.559576-1-bjorn.topel@gmail.com>
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

Performance-wise I got 4% improvement for XSKMAP
(sample:xdpsock/rx-drop), and 8% (sample:xdp_redirect_map) on my
machine.

@Jesper/@Toke I kept your Acked-by: for patch 2. Let me know, if you
don't agree with that decision.

More details in each commit.

Changelog:
v5->v6:  Removed REDIR enum, and instead use map_id and map_type. (Daniel)
         Applied Daniel's fixups on patch 1. (Daniel)
v4->v5:  Renamed map operation to map_redirect. (Daniel)
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
v4:  https://lore.kernel.org/bpf/20210226112322.144927-1-bjorn.topel@gmail.com/
v5:  https://lore.kernel.org/bpf/20210227122139.183284-1-bjorn.topel@gmail.com/

Björn Töpel (2):
  bpf, xdp: make bpf_redirect_map() a map operation
  bpf, xdp: restructure redirect actions

 include/linux/bpf.h        |  26 ++---
 include/linux/filter.h     |  31 +++++-
 include/net/xdp_sock.h     |  19 ----
 include/trace/events/xdp.h |  62 ++++++-----
 kernel/bpf/cpumap.c        |   9 +-
 kernel/bpf/devmap.c        |  17 ++-
 kernel/bpf/verifier.c      |  13 ++-
 net/core/filter.c          | 209 ++++++++++++++-----------------------
 net/xdp/xskmap.c           |  17 ++-
 9 files changed, 195 insertions(+), 208 deletions(-)


base-commit: 5e6d87315279db3abe69e2ebfd05fa8f5c014295
-- 
2.27.0

