Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F171E7CC1
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 14:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgE2MKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 08:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgE2MKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 08:10:09 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E753C03E969;
        Fri, 29 May 2020 05:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=VtzD/DOrIbOSbWqnH7ekyZS7ktdyydGbSi7u5pKRl0c=; b=gsUvQZcTaDoWTT2KCICsr9QqEp
        p5U8dPpzp/FmP1kAVFcsJPNlPUDl3k8sKIANK0cXFoK0q/Q9295kCxvgQbL3rPujMpQhJHzyXfDC4
        A47pcS7In+Nf9iR/g1sxo8FBbkIf7uLelLjFCd1K/3Ece2T3FmShRHEGlt9X4oyY4CrKBOSAKiYJZ
        9DNuKB1siT7+BI5SjBDOuCsBeFmGJDI6bPsJn00PQ6r/j2JpnOZtuxRlC1x0KN36mRmi1KdaK7kS6
        kUnTztljy/5i2bydZL1r9rhQTVSsV2A7uxZl4eGjKWt13JGRdsryCXudkIlU8jZIio5SKmGGUhu/T
        dZdYGJow==;
Received: from p4fdb1ad2.dip0.t-ipconnect.de ([79.219.26.210] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jedpf-0006KS-K2; Fri, 29 May 2020 12:09:52 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     David Laight <David.Laight@ACULAB.COM>, linux-sctp@vger.kernel.org,
        linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        netdev@vger.kernel.org
Subject: remove kernel_setsockopt v4
Date:   Fri, 29 May 2020 14:09:39 +0200
Message-Id: <20200529120943.101454-1-hch@lst.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave and Marcelo,

now that only the dlm calls to sctp are left for kernel_setsockopt,
while we haven't really made much progress with the sctp setsockopt
refactoring, how about this small series that splits out a
sctp_setsockopt_bindx_kernel that takes a kernel space address array
to share more code as requested by Marcelo.  This should fit in with
whatever variant of the refator of sctp setsockopt we go with, but
just solved the immediate problem for now.

Changes since v3:
 - dropped all the merged patches, just sctp setsockopt left now
 - factor out a new sctp_setsockopt_bindx_kernel helper instead of
   duplicating a small amount of logic

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
