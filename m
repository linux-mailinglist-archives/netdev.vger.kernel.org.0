Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0491DD540
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbgEURuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728955AbgEURrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:47:47 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0EEC061A0E;
        Thu, 21 May 2020 10:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=kqJI+EWtfQBeipsmoEMHCkNSuLmdDpilpY83QLnguS8=; b=KemRXJ4w/7h3tazT2J4TGpsOmV
        XpvdXZMxOD+ZZETKw0TIPS0fVlKHuTavsoyyNgO8AuNzyPIfJ9QDEIPk3nbgEanNM0YncS9cqFqXy
        Y1WZfYZ10VWcz2/eo8oE+n24Y0PMtoJf/+lRCWMAzOB7q8256Jn0q3l8kT/G4GUM6G1tZv50YJdQf
        MgCjTS2w7B0x62+alnyV+rht4F/aWJ9IxvBzvt5SiKe51c6cRPZfi+Mm6Tg9ybqTUecS00o/bY1KJ
        fH9QmGhYQm0+aR3EztdU30Sx9DvwYZS43AFDx9hhGM542R/cYH0WuFY3E6VosrAlJllqPA/NK2ZYV
        V5TW1rvA==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpI0-0002rk-4t; Thu, 21 May 2020 17:47:28 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: do a single memdup_user in sctp_setsockopt
Date:   Thu, 21 May 2020 19:46:35 +0200
Message-Id: <20200521174724.2635475-1-hch@lst.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

based on the review of Davids patch to do something similar I dusted off
the series I had started a few days ago to move the memdup_user or
copy_from_user from the inidividual sockopts into sctp_setsockopt,
which is done with one patch per option, so it might suit Marcelo's
taste a bit better.  I did not start any work on getsockopt.
