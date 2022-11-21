Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2ACA631D84
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 10:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbiKUJ4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 04:56:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbiKUJ4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 04:56:50 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B276EB6F;
        Mon, 21 Nov 2022 01:56:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=N4lVpsueUHUdCp5w3Zio4avq0ue/SBSOIvxxSXJmDaI=; b=P8nX7m1si+aS8DLO8SpioKygFN
        LsqJz7GOBDw1Q/081y8TDWYyaZf42Q7Kep+ZHWc4/U3orSQCAsHyQR0hHH14FmnHlvRKDY/BwUPV0
        qpC8VcFmdkDIsBcCwekwuqK/9AJwT+ZPyoEXX0Wqr5BT4pHDgonbUJgW1Nzxuame8QUiQJX7ccr3I
        aRK2jxyt9QK1o1VizgOOE03qDSY+h2ALJjAAlzdcGmA+UjS0S65lbQwboBIZG4qiDQWpid0nIZc3m
        iAUs72icxhloFEDCyvssxLbb1W+xOHsN8/uPO1zBBm6VY4W9H0+Zd1faTS9s4P/dyaOgAF9dpeDgw
        d8xSZhKw==;
Received: from [2001:4bb8:199:6d04:3c43:44c4:4e80:d8ad] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ox3XW-00C2CN-6E; Mon, 21 Nov 2022 09:56:34 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Greg Ungerer <gerg@linux-m68k.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-m68k@lists.linux-m68k.org, uclinux-dev@uclinux.org,
        netdev@vger.kernel.org
Subject: fix dma_alloc_coherent on m68knommu / coldfire
Date:   Mon, 21 Nov 2022 10:56:29 +0100
Message-Id: <20221121095631.216209-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

this series ensures dma_alloc_coherent returns NULL for m68knommu and
coldfire given that these platforms can't actually allocate dma coherent
memory after fixing what is according to an old mail from Greg the
only driver that actually uses memory returned by dma_alloc_coherent on
those platforms.
