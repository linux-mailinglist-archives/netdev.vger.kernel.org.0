Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF2D1B19F9
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 01:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgDTXNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 19:13:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbgDTXNy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 19:13:54 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0293620BED;
        Mon, 20 Apr 2020 23:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587424434;
        bh=8HccjXUl6Fdh7KkmrarzhiGqZzQcRKdB5hc5dj/omOM=;
        h=From:To:Cc:Subject:Date:From;
        b=PBVscYT/lI7lxIFDKayFB5cPcfNag7FlSF2t1IpeSVLNQmRWovC74G6V+67QEMqCf
         Q9yXY98ekDP1zUIq40dy0ed4DTfGzn7zT8vg3BNfIrjWnO8HgMkQ4QGT3S0fsBfTgZ
         LnPkBW4fbp3h9iKqupVgvi2VsQ2EUEO8JzJz2EvA=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, trev@larock.ca,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net 0/2] net: Fix looping with vrf, xfrms and qdisc on VRF
Date:   Mon, 20 Apr 2020 17:13:50 -0600
Message-Id: <20200420231352.50855-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Trev reported that use of VRFs with xfrms is looping when a qdisc
is added to the VRF device. The combination of xfrm + qdisc is not
handled by the VRF driver which lost track that it has already
seen the packet.

The XFRM_TRANSFORMED flag is used by the netfilter code for a similar
purpose, so re-use for VRF. Patch 1 drops the #ifdef around setting
the flag in the xfrm output functions. Patch 2 adds a check to
the VRF driver for flag; if set the packet has already passed through
the VRF driver once and does not need to recirculated a second time.

This is a day 1 bug with VRFs; stable wise, I would only take this
back to 4.14. I have a set of test cases which I will submit to
net-next.

David Ahern (2):
  xfrm: Always set XFRM_TRANSFORMED in xfrm{4,6}_output_finish
  vrf: Check skb for XFRM_TRANSFORMED flag

 drivers/net/vrf.c       | 6 ++++--
 net/ipv4/xfrm4_output.c | 2 --
 net/ipv6/xfrm6_output.c | 2 --
 3 files changed, 4 insertions(+), 6 deletions(-)

-- 
2.20.1

