Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC44498662
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 18:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244388AbiAXRUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 12:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244373AbiAXRUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 12:20:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A350C06173B;
        Mon, 24 Jan 2022 09:20:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0231FB8119D;
        Mon, 24 Jan 2022 17:20:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02849C340E5;
        Mon, 24 Jan 2022 17:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643044826;
        bh=3hY5cykoSrCG6faw9+cAQvoqX65QcDMJEdibm+FY190=;
        h=From:To:Cc:Subject:Date:From;
        b=NoXURqnP2oyFVry6TlJVY6Xg/7TzaHsvLv7AA9JDf1vPZ1zjXgDINPKqyPrdoZo2n
         vY8IDw0BPqeTMGdeKzR1xu8IUwLj73htpMyXXkrsh2Xwr03XdAaE1lXvkInaO0ipnx
         nOfD2dwSGUFmxshsWlLMUeoH3KKy5eUnCetWCTd9RYksZBmwIjMshQqDx68Tz3KMlh
         eqjG4y/p7W2sLc36RV1rwlfaht9JlRYEVz84eofSJnNx8SZeq9DcKyUHVB7SSg8CFp
         OyaHFeERLPqGY+ClsVNDdlPkLFOyaVFMq6WG8TRbN0ikLyDCtZBMw3Ldlj3Exb5P2t
         3bY6eCLY34cJg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, dsahern@kernel.org,
        komachi.yoshiki@gmail.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com, andrii.nakryiko@gmail.com
Subject: [RFC bpf-next 0/2] introduce bpf fdb lookup helper for xdp
Date:   Mon, 24 Jan 2022 18:20:14 +0100
Message-Id: <cover.1643044381.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to bpf_xdp_ct_lookup routine, introduce
br_fdb_find_port_from_ifindex unstable helper in order to accelerate
linux bridge with XDP. br_fdb_find_port_from_ifindex will perform a
lookup in the associated bridge fdb table and it will return the
output ifindex if the destination address is associated to a bridge
port or -ENODEV for BOM traffic or if lookup fails.

Lorenzo Bianconi (2):
  net: bridge: add unstable br_fdb_find_port_from_ifindex helper
  samples: bpf: add xdp fdb lookup program

 net/bridge/br.c            |  21 +++++
 net/bridge/br_fdb.c        |  67 +++++++++++++---
 net/bridge/br_private.h    |  12 +++
 samples/bpf/Makefile       |   9 ++-
 samples/bpf/xdp_fdb.bpf.c  |  68 +++++++++++++++++
 samples/bpf/xdp_fdb_user.c | 152 +++++++++++++++++++++++++++++++++++++
 6 files changed, 319 insertions(+), 10 deletions(-)
 create mode 100644 samples/bpf/xdp_fdb.bpf.c
 create mode 100644 samples/bpf/xdp_fdb_user.c

-- 
2.34.1

