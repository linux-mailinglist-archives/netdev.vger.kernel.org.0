Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 937ADEABBA
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 09:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfJaIsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 04:48:14 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45104 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbfJaIsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 04:48:13 -0400
Received: by mail-pf1-f196.google.com with SMTP id c7so3859425pfo.12;
        Thu, 31 Oct 2019 01:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5uA20OarGty9EZTObGAfRdvDBWNEx/jAFJPomXszEiw=;
        b=YRnxfz7wfulcgOEEn1gV6qxt1IgOCmJwtF8Spdo+SehlzZ8K8T64fijPUq7XbqbQRT
         fXGHINj4211btPkGoKxB+fn/zeUUa7F/zex3Stn5JKEaNKZit0hUvmk8RDdxTLlj6KgH
         Wh9gTqNDUonpCD5CyibIN8oVEbsG0GRMcuWi2dGaMKrgjJbwnsEX87vCULzS/bg/d++l
         jBxjZFAvcAxNJoHhp+w0iRORg9qR4x77D+RJC1i8KIlJQoo0ZSCxajIYd4mY5HspfM1V
         pjlT8/8mOfEFskU5hP87KmyJH4zizvoa9n/IaNpOPSy7iIc/CvFNdHmDP69sDg5FA3Zw
         FNAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5uA20OarGty9EZTObGAfRdvDBWNEx/jAFJPomXszEiw=;
        b=TO+RVrrAQPJgFRjLUNIznwNyMQsXNp8DynW67HpiuPAY6D/dPDO8Dm+8XnqQ+JGAb9
         f2zFaFfB7IHwf9wzzI76Kyp9TWdl1E9Vl2mW0MomHePl3rQbFhBbmXijZeCUycOD8ggF
         MtvAOUlyaRPjulDJ5ay3WkmgeC1rUxIrjWqG0y+6HUPZgXlQslvu7PeFsiexsLookT2M
         lLw0uQE61hfLow3OsT2eqHR6nXJoNa6U6fy4sjzuoS87UWlGaUz1ytsty5wg+osXoEJU
         a35ko0Ig3mFZNNBLUH0OT/YO+VO6qkKcK1kvn1ckDcGLfkx1YYmGg3wNIADbxzLHUhJh
         TVhQ==
X-Gm-Message-State: APjAAAW5S5QmJ6olmGDpQbjhx4hTt/74oiRfFDYL/IDOS+3rYT0rvL63
        Aj+ASxygAYxcY5kFhdj+OTIGyrJ6UW57wA==
X-Google-Smtp-Source: APXvYqwdo1Av7lZSHsDk1oyhFpzeImbiI7tO9JfmCeSKD9xeS9EdFZJC2+rfJnR9nphYRX0SfbKlJg==
X-Received: by 2002:a62:ac14:: with SMTP id v20mr5164335pfe.193.1572511692503;
        Thu, 31 Oct 2019 01:48:12 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.45])
        by smtp.gmail.com with ESMTPSA id 4sm3335507pfz.185.2019.10.31.01.48.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 01:48:11 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        jonathan.lemon@gmail.com, toke@redhat.com
Subject: [PATCH bpf-next v4 0/3] xsk: XSKMAP performance improvements
Date:   Thu, 31 Oct 2019 09:47:46 +0100
Message-Id: <20191031084749.14626-1-bjorn.topel@gmail.com>
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

Jonathan's Acked-by: for patch 1 and 2 was carried on to the v4. Note
that the overflow checks are done in the bpf_map_area_alloc() and
bpf_map_charge_init() functions, which was fixed in [1], but not
applied to the bpf tree yet.

Cheers,
Björn and Maciej

[1] https://patchwork.ozlabs.org/patch/1186170/

v1->v2: * Change size/cost to size_t and use {struct, array}_size
          where appropriate. (Jakub)
v2->v3: * Proper commit message for patch 2.
v3->v4: * Change size_t to u64 to handle 32-bit overflows. (Jakub)
        * Introduced patch 3

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

