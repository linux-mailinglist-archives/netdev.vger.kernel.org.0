Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C7528425E
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 00:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgJEWHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 18:07:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726934AbgJEWHt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 18:07:49 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B85AE2068E;
        Mon,  5 Oct 2020 22:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601935669;
        bh=i5T6Od/QvE1PeIR8DSmtodMZ9lTTj1TWKfMn/gqfNkM=;
        h=From:To:Cc:Subject:Date:From;
        b=KAgbtU2OFgdh/E3OGCRbjaNp9ekv8XJY58YemxTAJySwQCGa25KNCDWAiYppWvTM8
         ThJFgbgI5JDbSoLWFr5BkOcIlyPv2w8hoXaTcN7q8Oe6mbbAwTMhydJmagYfnJxK3X
         /dKPZsCLDJqwcx/M0Y6H4ggev8bBBDBSal31M37g=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        johannes@sipsolutions.net, jiri@resnulli.us, andrew@lunn.ch,
        mkubecek@suse.cz, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 0/7] ethtool: allow dumping policies to user space
Date:   Mon,  5 Oct 2020 15:07:32 -0700
Message-Id: <20201005220739.2581920-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This series wires up ethtool policies to ops, so they can be
dumped to user space for feature discovery.

First patch wires up GET commands, and second patch wires up SETs.

The policy tables are trimmed to save space and LoC.

Next - take care of linking up nested policies for the header
(which is the policy what we actually care about). And once header
policy is linked make sure that attribute range validation for flags
is done by policy, not a conditions in the code. New type of policy
is needed to validate masks (patch 6).

Netlink as always staying a step ahead of all the other kernel
API interfaces :)

v2:
 - merge patches 1 & 2 -> 1
 - add patch 3 & 5
 - remove .max_attr from struct ethnl_request_ops

Jakub Kicinski (7):
  ethtool: wire up get policies to ops
  ethtool: wire up set policies to ops
  ethtool: trim policy tables
  ethtool: link up ethnl_header_policy as a nested policy
  netlink: create helpers for checking type is an int
  netlink: add mask validation
  ethtool: specify which header flags are supported per command

 include/net/netlink.h        |  27 +++++---
 include/uapi/linux/netlink.h |   2 +
 lib/nlattr.c                 |  36 ++++++++++
 net/ethtool/bitset.c         |  26 ++++----
 net/ethtool/cabletest.c      |  41 ++++--------
 net/ethtool/channels.c       |  35 ++--------
 net/ethtool/coalesce.c       |  45 ++-----------
 net/ethtool/debug.c          |  24 ++-----
 net/ethtool/eee.c            |  32 +++------
 net/ethtool/features.c       |  30 ++-------
 net/ethtool/linkinfo.c       |  30 ++-------
 net/ethtool/linkmodes.c      |  32 ++-------
 net/ethtool/linkstate.c      |  14 +---
 net/ethtool/netlink.c        | 124 +++++++++++++++++++++++++----------
 net/ethtool/netlink.h        |  35 ++++++++--
 net/ethtool/pause.c          |  27 ++------
 net/ethtool/privflags.c      |  24 ++-----
 net/ethtool/rings.c          |  35 ++--------
 net/ethtool/strset.c         |  25 +++----
 net/ethtool/tsinfo.c         |  13 +---
 net/ethtool/tunnels.c        |  42 ++++--------
 net/ethtool/wol.c            |  24 ++-----
 net/netlink/policy.c         |   8 +++
 23 files changed, 317 insertions(+), 414 deletions(-)

-- 
2.26.2

