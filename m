Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F641E564F
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 07:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbgE1FRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 01:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgE1FNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 01:13:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213F7C08C5C3;
        Wed, 27 May 2020 22:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=WsnuuUW/8mNG5XgJndzFDlP4ZHaqtmjvrkyJ/evyN2A=; b=c3NXta7lrMrelp/uYGPfAaa966
        8FvaQiUf4V98AHB/jCXkfgscBXsFw4O9RoTBbXu69lPUnRpW3L2lwaDhI1JL+c/R+6XC6W1GP/2Wd
        Cr4aoUNeG+SLIrHNMVjQElvuPUT3WovkTfWaKM44g5p1RhzGtTs19UBh1G8RjOAlg/SRr7CE/PHSp
        /VVyQt3mSNfWkIGTPN2D+XOMLXnvrbD240ABfnwZp6A9pchmZaJjxwV7O2Div5+NEmg5/VzVz3ZJl
        MGiO7dqDADVjXVznEmvy0cfLpsTpyGFeUSCFflDRpysUfHCGVw+a/f/NB96VbC/aiG2e20C2e2oeE
        TiQCXfnQ==;
Received: from p4fdb1ad2.dip0.t-ipconnect.de ([79.219.26.210] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jeAqN-0001QR-LQ; Thu, 28 May 2020 05:12:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, drbd-dev@lists.linbit.com,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-nvme@lists.infradead.org, target-devel@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
        cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com,
        netdev@vger.kernel.org, ceph-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-nfs@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: remove most callers of kernel_setsockopt v3
Date:   Thu, 28 May 2020 07:12:08 +0200
Message-Id: <20200528051236.620353-1-hch@lst.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

this series removes most callers of the kernel_setsockopt functions, and
instead switches their users to small functions that implement setting a
sockopt directly using a normal kernel function call with type safety and
all the other benefits of not having a function call.

In some cases these functions seem pretty heavy handed as they do
a lock_sock even for just setting a single variable, but this mirrors
the real setsockopt implementation unlike a few drivers that just set
set the fields directly.


Changes since v2:
 - drop the separately merged kernel_getopt_removal
 - drop the sctp patches, as there is conflicting cleanup going on
 - add an additional ACK for the rxrpc changes

Changes since v1:
 - use ->getname for sctp sockets in dlm
 - add a new ->bind_add struct proto method for dlm/sctp
 - switch the ipv6 and remaining sctp helpers to inline function so that
   the ipv6 and sctp modules are not pulled in by any module that could
   potentially use ipv6 or sctp connections
 - remove arguments to various sock_* helpers that are always used with
   the same constant arguments
