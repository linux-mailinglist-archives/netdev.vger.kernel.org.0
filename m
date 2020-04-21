Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48D031B2DFC
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 19:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729174AbgDURPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 13:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725990AbgDURPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 13:15:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2056C061A41;
        Tue, 21 Apr 2020 10:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=W8axj1eYgRYYRX2IQ40eJJVIFVT2v4KgmokU8bsvFAY=; b=X9i2yk4C0hVTSdB1gn4yaNizE5
        0wS91equLcghgOBIh0bXpLvdn99Ku7W68bTpV5ABMV+2Z0ZbgoAZhZjwZLwNIozlVzaypdnCYBijD
        mB8SAmUHf20zWC1DsZMKeaNH3yxKkyN5DbvrJvLshbzhNS4RcYozf3h/R9K7I3kYmoO3St7GDFgAv
        Rl/ZiuLTng2AEJWW/fkauc+uLnEZWnKeRf9nfgc3bIGDxgAZfoMXJo76pz+hm5wDagEnYBMTn4j1V
        yB8emZ/Ts2sX3h6l7jmbr1ffaRwGpGtq4m9V9pDCOFPTNGPLZhv7ksynot0BRpHmrRNLMuPJRXgUk
        rgr7P6nw==;
Received: from [2001:4bb8:191:e12c:c70:4a89:bc61:3] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jQwUn-0006Zf-1w; Tue, 21 Apr 2020 17:15:41 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: pass kernel pointers to the sysctl ->proc_handler method v2
Date:   Tue, 21 Apr 2020 19:15:34 +0200
Message-Id: <20200421171539.288622-1-hch@lst.de>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

this series changes the sysctl ->proc_handler methods to take kernel
pointers.  This simplifies some of the pointer handling in the methods
(which could probably be further simplified now), and gets rid of the
set_fs address space overrides used by bpf.

Changes since v1:
 - drop a patch merged by Greg
 - don't copy data out on a write
 - fix buffer allocation in bpf
