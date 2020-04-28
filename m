Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 257241BCFF8
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 00:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgD1WaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 18:30:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:57104 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725934AbgD1WaE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 18:30:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1A777ACAB;
        Tue, 28 Apr 2020 22:30:02 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id AF873E128C; Wed, 29 Apr 2020 00:30:00 +0200 (CEST)
Message-Id: <cover.1588112572.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 0/2] improve the logic of fallback from netlink to
 ioctl
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>
Date:   Wed, 29 Apr 2020 00:30:00 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At the moment, ethtool falls back to ioctl implementation whenever either
in response to request type not implemented in kernel or netlink interface
is unavailable or netlink request fails with EOPNOTSUPP error code. This is
not perfect as EOPNOTSUPP can have different meanings and we only want to
fall back if it is caused by kernel lacking netlink implementation of the
request. In other cases, we would needlessly repeat the same failure trying
both netlink and ioctl.

These two patches improve the logic to avoid such duplicate failures and
improve handling of cases where fallback to ioctl is impossible for other
reasons (e.g. wildcard device name or no ioctl handler).

Michal Kubecek (2):
  refactor interface between ioctl and netlink code
  netlink: use genetlink ops information to decide about fallback

 ethtool.c          |  51 +++---------
 netlink/extapi.h   |  14 ++--
 netlink/monitor.c  |  15 +++-
 netlink/netlink.c  | 193 ++++++++++++++++++++++++++++++++++++++-------
 netlink/netlink.h  |   6 ++
 netlink/parser.c   |   7 ++
 netlink/settings.c |   7 ++
 7 files changed, 220 insertions(+), 73 deletions(-)

-- 
2.26.2

