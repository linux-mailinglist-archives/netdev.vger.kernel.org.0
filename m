Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A26A936D3B
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 09:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfFFHVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 03:21:36 -0400
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:59637 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfFFHVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 03:21:36 -0400
X-Greylist: delayed 354 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Jun 2019 03:21:36 EDT
Received: from glumotte.dev.6wind.com. (unknown [10.16.0.195])
        by proxy.6wind.com (Postfix) with ESMTP id B8F632C6039;
        Thu,  6 Jun 2019 09:15:39 +0200 (CEST)
From:   Olivier Matz <olivier.matz@6wind.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: [PATCH net 0/2] ipv6: fix EFAULT on sendto with icmpv6 and hdrincl
Date:   Thu,  6 Jun 2019 09:15:17 +0200
Message-Id: <20190606071519.5841-1-olivier.matz@6wind.com>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following code returns EFAULT (Bad address):

  s = socket(AF_INET6, SOCK_RAW, IPPROTO_ICMPV6);
  setsockopt(s, SOL_IPV6, IPV6_HDRINCL, 1);
  sendto(ipv6_icmp6_packet, addr);   /* returns -1, errno = EFAULT */

The problem is fixed in the second patch. The first one aligns the
code to ipv4, to avoid a race condition in the second patch.

Olivier Matz (2):
  ipv6: use READ_ONCE() for inet->hdrincl as in ipv4
  ipv6: fix EFAULT on sendto with icmpv6 and hdrincl

 net/ipv6/raw.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

-- 
2.11.0

