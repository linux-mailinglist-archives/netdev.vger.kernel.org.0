Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 271671D3393
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 16:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgENOvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 10:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgENOvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 10:51:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA3AEC061A0C;
        Thu, 14 May 2020 07:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=nFWXSeRD77aVNe1kpUid392p2TPdCScnaKMPBaah9y0=; b=JujPhAbncpPq7/TrdcNHjvZ6fT
        TE5O5Z+NgFJgr1ECjPo6pKap+iRU6jNZDciXJEtH/enfRqr6eJ0leStNP2iOKsOH2UFeTN6mbut9C
        WQ9LJ/5nBfCjQTGqeFrJvhCvCRkV6kMSK8+/IXPoLFb4JSIDVN/ci1cDptV6vG+K2apeRNnBz5AoA
        p/rvszKWyclRfxtRh8qpk4Q4Oj+9upBhZmHjazlYj8B1V4dQZ3Aj/CoK5NjPkue3mldexM85vrV72
        EzH653MBnQIHCH/UHnClxekJlNE0PrKpfuHkUaEL/FeD0vmg1aJgaOycPzOxS8Lmw9bHKj3YOW5Je
        gsCbEywA==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jZFCR-0007so-Ph; Thu, 14 May 2020 14:51:04 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: use symbol_get to create the magic ipv4/ipv6 tunnels
Date:   Thu, 14 May 2020 16:50:57 +0200
Message-Id: <20200514145101.3000612-1-hch@lst.de>
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

Instead this patchset makes the ipip and sit modules export a function
that can be used to create the tunnels, and then uses symbol_get in the
core ipv4/ipv6 code to reference that function at runtime.
