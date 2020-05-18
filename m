Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD10B1D77A9
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 13:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbgERLre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 07:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728041AbgERLr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 07:47:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88ACEC061A0C;
        Mon, 18 May 2020 04:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=CzptVQvO43jJs3G5GLMVm9lezuT7/sLUYMXfvlaV0Hw=; b=P2OvAtabr7SyTvptko1aSa0b4b
        6Zan9x1Nmss8UPA8EfIfVjcOg2X9f3eFNgG5D3617X5ymRZPuEwG0Sz9qlJi+LVkUCg4WZPpY+apr
        q0ILw+0t9DsbF2jxe0XYGFU6ESM/gtqLcG1z4SAYJiH8cKVhib1Zz7DFBBHA+FDFod4/GclRGjoLx
        DfX/m6QONBpsd+KcA8Ehn7TekFTllKPztJ6p6uamFMtU7CRjpCptYJkvRyYG2hPsejFviblkXdxIu
        WWuOBG/5bE2NGzn/tqyAnMD7HiFoiPVrfxdkCU0GnQOVY88uk40nDFa6bpNRvuo40fYH+fzC5T4/S
        eNs2xZUw==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jaeEr-0004Q4-5l; Mon, 18 May 2020 11:47:21 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] ipv6: use ->ndo_tunnel_ctl in addrconf_set_dstaddr
Date:   Mon, 18 May 2020 13:46:55 +0200
Message-Id: <20200518114655.987760-10-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518114655.987760-1-hch@lst.de>
References: <20200518114655.987760-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new ->ndo_tunnel_ctl instead of overriding the address limit
and using ->ndo_do_ioctl just to do a pointless user copy.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/ipv6/addrconf.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index c827edf877414..09cfbf5dd7ce0 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2787,8 +2787,6 @@ static int addrconf_set_sit_dstaddr(struct net *net, struct net_device *dev,
 		struct in6_ifreq *ireq)
 {
 	struct ip_tunnel_parm p = { };
-	mm_segment_t oldfs = get_fs();
-	struct ifreq ifr;
 	int err;
 
 	if (!(ipv6_addr_type(&ireq->ifr6_addr) & IPV6_ADDR_COMPATv4))
@@ -2799,13 +2797,10 @@ static int addrconf_set_sit_dstaddr(struct net *net, struct net_device *dev,
 	p.iph.ihl = 5;
 	p.iph.protocol = IPPROTO_IPV6;
 	p.iph.ttl = 64;
-	ifr.ifr_ifru.ifru_data = (__force void __user *)&p;
 
-	if (!dev->netdev_ops->ndo_do_ioctl)
+	if (!dev->netdev_ops->ndo_tunnel_ctl)
 		return -EOPNOTSUPP;
-	set_fs(KERNEL_DS);
-	err = dev->netdev_ops->ndo_do_ioctl(dev, &ifr, SIOCADDTUNNEL);
-	set_fs(oldfs);
+	err = dev->netdev_ops->ndo_tunnel_ctl(dev, &p, SIOCADDTUNNEL);
 	if (err)
 		return err;
 
-- 
2.26.2

