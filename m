Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB67E1EBE88
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 16:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbgFBO6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 10:58:42 -0400
Received: from www62.your-server.de ([213.133.104.62]:37376 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbgFBO6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 10:58:42 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jg8NE-0007bj-1K; Tue, 02 Jun 2020 16:58:40 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     alexei.starovoitov@gmail.com
Cc:     lmb@cloudflare.com, alan.maguire@oracle.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf 0/3] Fix csum unnecessary on bpf_skb_adjust_room
Date:   Tue,  2 Jun 2020 16:58:31 +0200
Message-Id: <cover.1591108731.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25831/Tue Jun  2 14:41:03 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes an issue originally reported by Lorenz Bauer where using
the bpf_skb_adjust_room() helper hid a checksum bug since it wasn't adjusting
CHECKSUM_UNNECESSARY's skb->csum_level after decap. The fix is two-fold:
 i) We do a safe reset in bpf_skb_adjust_room() to CHECKSUM_NONE with an opt-
    out flag BPF_F_ADJ_ROOM_NO_CSUM_RESET.
ii) We add a new bpf_csum_level() for the latter in order to allow users to
    manually inc/dec the skb->csum_level when needed.
The series is rebased against latest bpf-next tree. It can be applied there,
or to bpf after the merge win sync from net-next.

Thanks!

Daniel Borkmann (3):
  bpf: Fix up bpf_skb_adjust_room helper's skb csum setting
  bpf: add csum_level helper for fixing up csum levels
  bpf, selftests: adapt cls_redirect to call csum_level helper

 include/linux/skbuff.h                        |  8 +++
 include/uapi/linux/bpf.h                      | 51 ++++++++++++++++++-
 net/core/filter.c                             | 46 ++++++++++++++++-
 tools/include/uapi/linux/bpf.h                | 51 ++++++++++++++++++-
 .../selftests/bpf/progs/test_cls_redirect.c   |  9 ++--
 5 files changed, 158 insertions(+), 7 deletions(-)

-- 
2.21.0

