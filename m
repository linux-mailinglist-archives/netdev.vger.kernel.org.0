Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A11D1DBF8E
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 22:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbgETT4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 15:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbgETT4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 15:56:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A15C08C5C0;
        Wed, 20 May 2020 12:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=AvcdAD8zTTSJDfWEpIpfpetvjQ99drHMp3Vtm1fZek8=; b=ma/DUEc/VfLIdSMqChe6fBXtRM
        KFPIi0kExGxuMcY7MKuOHO7HDRL3fZTdRlVLkDNs7CIr3Y81qhwST3zP5iggrt/WXayW1EKMqqag1
        AvC/YCGpoRtlOhSsCppb9mDB78KuJpoGGXo5TuGPK9ngfY+jniQETGjxwv6oE9IfQ7Ni40xZ36pxh
        qAk7tK35dbFwZz+5SSeM6/7oFaHXTh9RiaDcOrrmB/wNmgFnkW3elg7zIJsYQTCrm5fdS8GdfQvzi
        bQ35oJTYDm0DTjgxdbe5Rw1DYcKft1UsNPhk9zD9I1wl67ev9qL0kSTZBwuDqU1mwQI7FPc3zZzm4
        zSwwU/3A==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbUo3-0001ns-KW; Wed, 20 May 2020 19:55:12 +0000
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
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-nvme@lists.infradead.org, target-devel@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
        cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com,
        netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        ceph-devel@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-nfs@vger.kernel.org
Subject: remove kernel_setsockopt and kernel_getsockopt v2
Date:   Wed, 20 May 2020 21:54:36 +0200
Message-Id: <20200520195509.2215098-1-hch@lst.de>
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
the real setsockopt implementation unlike a few drivers that just set
set the fields directly.


Changes since v1:
 - use ->getname for sctp sockets in dlm
 - add a new ->bind_add struct proto method for dlm/sctp
 - switch the ipv6 and remaining sctp helpers to inline function so that
   the ipv6 and sctp modules are not pulled in by any module that could
   potentially use ipv6 or sctp connections
 - remove arguments to various sock_* helpers that are always used with
   the same constant arguments
