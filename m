Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36209EC17F
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 12:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730190AbfKALEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 07:04:08 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44555 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729855AbfKALEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 07:04:08 -0400
Received: by mail-pf1-f193.google.com with SMTP id q26so6801581pfn.11;
        Fri, 01 Nov 2019 04:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1UssbocCrSzp9lhCJqOrGEs9I7QNiMf4ozawtM1wkU8=;
        b=rxpqnyAbgAtoMQc2BQRULGWmWM1WNWKOLQIcw8lMJjx60rGxjOr0j9cbInogFpHTl0
         T1WgEEPjQY0ZrOWoAEOPSr/I5Q1e6PoanPSB1/WyBY7nLDaT9M6B+rLZAZhmKkwdYW7f
         beiPf/dkTmzfT8Jz6NDSI/9axnwRYl95P95U7JvEk/t/KIzDOhfkPMmm5y7oXtuTxcW8
         5X0YdUmeMIAhLF3TIMAYqVE6oYVYjYlBLFJxnTfhIqasO2Td4uzxot2ez/qRLBWJk8MB
         /iqpsE7B2k15Oj5m4Siae8lyIf81muzvbILgrCbu0bGjvj3UwCa2XN8XCXXTnf8LZTux
         aniw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1UssbocCrSzp9lhCJqOrGEs9I7QNiMf4ozawtM1wkU8=;
        b=joSfgZ3kzH38cvJbCwzqot4XIXGG1J/gGmQII5vg5ao+0Ae9+P4NfhmXXSzGq1vzYr
         EbAovokYvrMOPo/Fq4rDKRqm4wCrNFgF+FMOm89kn3Z3gd0DH89UMOeTjd5uTeyFDne4
         ubc6ePkhJprU+GYzTc5+2nFr/XkO4dMmVYeTr4fDlMV84Rzsh5RQfYQDAlxZK2kgoFof
         OBJ3SFUe6V7BhUpxCsmUiiv3dNYBlY+CvS7HoqYKLK+RbDeQXSxgzn9O0KBt1AOirSz7
         o5dSVEmQ+1SjLSDTuxlQzQZZ4oaIfYKpCXlQ2Eor3NeO1iPE7EdzkldTvbtcyZM0FHt/
         X5gw==
X-Gm-Message-State: APjAAAVUHlbvaNb7QljYVpI6h7cikzT0T0Ldw1PLBNJzCAS9OZTq8xSE
        hgWS4tXS5TOu205j6+OPgI6p+gLI8TfM5w==
X-Google-Smtp-Source: APXvYqwsglVukG3TccUZu6yLaxGv/BioFI9VcspeiAzmZXmzARD1Gbm55e0pAiJBRgxKqYyIbLZQMw==
X-Received: by 2002:a63:ee48:: with SMTP id n8mr13156943pgk.374.1572606245488;
        Fri, 01 Nov 2019 04:04:05 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com (jfdmzpr04-ext.jf.intel.com. [134.134.137.73])
        by smtp.gmail.com with ESMTPSA id c6sm6939767pfj.59.2019.11.01.04.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 04:04:04 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        jonathan.lemon@gmail.com, toke@redhat.com
Subject: [PATCH bpf-next v5 0/3] xsk: XSKMAP performance improvements
Date:   Fri,  1 Nov 2019 12:03:43 +0100
Message-Id: <20191101110346.15004-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set consists of three patches from Maciej and myself which are
optimizing the XSKMAP lookups.  In the first patch, the sockets are
moved to be stored at the tail of the struct xsk_map. The second
patch, Maciej implements map_gen_lookup() for XSKMAP. The third patch,
introduced in this revision, moves various XSKMAP functions, to permit
the compiler to do more aggressive inlining.

Based on the XDP program from tools/lib/bpf/xsk.c where
bpf_map_lookup_elem() is explicitly called, this work yields a 5%
improvement for xdpsock's rxdrop scenario. The last patch yields 2%
improvement.

Jonathan's Acked-by: for patch 1 and 2 was carried on. Note that the
overflow checks are done in the bpf_map_area_alloc() and
bpf_map_charge_init() functions, which was fixed in commit
ff1c08e1f74b ("bpf: Change size to u64 for bpf_map_{area_alloc,
charge_init}()").

Cheers,
Björn and Maciej

[1] https://patchwork.ozlabs.org/patch/1186170/

v1->v2: * Change size/cost to size_t and use {struct, array}_size
          where appropriate. (Jakub)
v2->v3: * Proper commit message for patch 2.
v3->v4: * Change size_t to u64 to handle 32-bit overflows. (Jakub)
        * Introduced patch 3.
v4->v5: * Use BPF_SIZEOF size, instead of BPF_DW, for correct
          pointer-sized loads. (Daniel)

Björn Töpel (2):
  xsk: store struct xdp_sock as a flexible array member of the XSKMAP
  xsk: restructure/inline XSKMAP lookup/redirect/flush

Maciej Fijalkowski (1):
  bpf: implement map_gen_lookup() callback for XSKMAP

 include/linux/bpf.h    |  25 ---------
 include/net/xdp_sock.h |  51 ++++++++++++++-----
 kernel/bpf/xskmap.c    | 112 +++++++++++++----------------------------
 net/xdp/xsk.c          |  33 +++++++++++-
 4 files changed, 106 insertions(+), 115 deletions(-)

-- 
2.20.1

