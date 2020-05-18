Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8F0B1D77BC
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 13:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbgERLsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 07:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgERLrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 07:47:16 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA95C061A0C;
        Mon, 18 May 2020 04:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=y+NOERPGxSMEwqlbJod6h8RjHirscgQzvQWuQ1avJsk=; b=UOVq7zit6XfF5sFUiRGylQrzgd
        vgP09r82JXnrFsdeqD4O6wO0mxQmCYN6EG3mhgM9C85WyhmwaoAZsvS5CP/lne5GGs4o/Jl1fUgK/
        khMajTYoIvIHqbVVnfvgPVX3qfjO/JlskJ8BmDCKJvizfG8rG4xp07IQme17ct2zI52syVQY7JBww
        4h+pB/JGZ44cmk7Z0UCnbOZfpYM426jFu8QAps1VKV5QbstpYZuVoptJtJ8PSIBFSA9Ap8vFWH0rW
        sRZvp1rMsJJSbqmom9bpqJIE+l3owStFvhol3ZRNVrU+t0JNqICyKeqWVNJPiaJCpx5pD6vMYocH9
        uW53/UZw==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jaeEU-0004N9-Cr; Mon, 18 May 2020 11:46:58 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: add a new ->ndo_tunnel_ctl method to avoid a few set_fs calls
Date:   Mon, 18 May 2020 13:46:46 +0200
Message-Id: <20200518114655.987760-1-hch@lst.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

both the ipv4 and ipv6 code have an ioctl each that can be used to create
a tunnel using code that doesn't live in the core kernel or ipv6 module.
Currently they call ioctls on the tunnel devices to create these, for
which the code needs to override the address limit, which is a "feature"
I plan to get rid of.

Instead this patchset adds a new ->ndo_tunnel_ctl that can be used for
the tunnel configuration using struct ip_tunnel_parm.  The method is
either invoked from a helper that does the uaccess and can be wired up
as ndo_do_ioctl method, or directly from the magic IPV4/6 ioctls that
create tunnels with kernel space arguments.
