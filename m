Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26B91D07C2
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 08:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730140AbgEMG2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 02:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729992AbgEMG2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 02:28:19 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89577C061A0E;
        Tue, 12 May 2020 23:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=AG2RtlJ7y9O44y7CM+5Y55kgsqMdi5zmGGc+3SDRxq8=; b=WCEMuVgh4ZCeigkMFy94+mId1g
        gh0Igbk9vi9s0Nf0anxjWE8uw6ABaQK+5+LaKpNFUHA+zf0D919KpO4aJY2VWo7p1QEdzsWYbfYE1
        ONYsiXd9fdvHslF9UXMZqp6QUOnmxAYZwP2dn34xAmDZzON/e8nSVNnr721D+sw/O5rHr7UcsK6mO
        HSxECWTkiypKRzFQFHzArwuIE38ZopK9LEyh7+kEKbL+4aJLTGj2I5cW3gZ22+vmtXtEY9Pl73HhN
        vcT29xWjHPMXK5XFCdsQA+ZaH+xRK6mUJGYid122hF4Ce47/IUMWYtLRChUrGSjyNKanSSQmBUX9v
        ypmYTpGg==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYkqx-0003lt-48; Wed, 13 May 2020 06:26:51 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, drbd-dev@lists.linbit.com,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org,
        target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, cluster-devel@redhat.com,
        ocfs2-devel@oss.oracle.com, netdev@vger.kernel.org,
        linux-sctp@vger.kernel.org, ceph-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-nfs@vger.kernel.org
Subject: remove kernel_setsockopt and kernel_getsockopt
Date:   Wed, 13 May 2020 08:26:15 +0200
Message-Id: <20200513062649.2100053-1-hch@lst.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

this series removes the kernel_setsockopt and kernel_getsockopt
functions, and instead switches their users to small functions that
implement setting (or in one case getting) a sockopt directly using
a normal kernel function call with type safety and all the other
benefits of not having a function call.

In some cases these functions seem pretty heavy handed as they do
a lock_sock even for just setting a single variable, but this mirrors
the real setsockopt implementation - counter to that a few kernel
drivers just set the fields directly already.

Nevertheless the diffstat looks quite promising:

 42 files changed, 721 insertions(+), 799 deletions(-)
