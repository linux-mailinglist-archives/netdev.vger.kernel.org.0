Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E701920D3DD
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 21:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730541AbgF2TCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730509AbgF2TCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:02:42 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C2FC02A552;
        Mon, 29 Jun 2020 06:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=hCeEFPJauELL9pZELwR8NI9hO7+eRck24vlEYcHykOI=; b=jWJmLvGHLCXZqD+9nHGBpk8RJJ
        tZEw3mH374vZSArhHhnpGf3fzMx6xn+4T+ORiEdT5+4lPhWyDdnz3JjTZh9/3Wtck2vqFScH/9G/J
        u4LVSP/cj9xTJk4Ckay1YCcJrlSpYpCPwix/DUpDcxoNbuscvo6HKYUYw09OpXMQGOUG1UPKk5h1R
        I3eShOTEfFGU9Ja0KzA7j41GBHdpp5HO/DOzw6cKjpixzfNV8H9j71Gb6OnIfIM/OBDTmJC5gUL61
        YFnCpxS9+nbGCj3YwQd7bAh3L87CfMsmO+LuaXEzqneInL6n6Nzaas0SsF/W9iCpEmQP30CE7l3I7
        yMgYzDrw==;
Received: from [2001:4bb8:184:76e3:c71:f334:376b:cf5f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jptS5-0004Wr-LR; Mon, 29 Jun 2020 13:04:02 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: add an API to check if a streamming mapping needs sync calls
Date:   Mon, 29 Jun 2020 15:03:55 +0200
Message-Id: <20200629130359.2690853-1-hch@lst.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

this series lifts the somewhat hacky checks in the XSK code if a DMA
streaming mapping needs dma_sync_single_for_{device,cpu} calls to the
DMA API.


Diffstat:
 Documentation/core-api/dma-api.rst |    8 +++++
 include/linux/dma-direct.h         |    1 
 include/linux/dma-mapping.h        |    5 +++
 include/net/xsk_buff_pool.h        |    6 ++--
 kernel/dma/direct.c                |    6 ++++
 kernel/dma/mapping.c               |   10 ++++++
 net/xdp/xsk_buff_pool.c            |   54 ++-----------------------------------
 7 files changed, 37 insertions(+), 53 deletions(-)
