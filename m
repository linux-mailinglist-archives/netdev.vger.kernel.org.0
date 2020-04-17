Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 502CD1AD651
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 08:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbgDQGl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 02:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728078AbgDQGl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 02:41:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC7D8C061A0C;
        Thu, 16 Apr 2020 23:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=LUNyqPWJqquUKD2oqL+iraXTObA9TCNzymZP74tcC+Y=; b=T5mEIVUteHeakVWU7MEeYp5dB8
        S4bgAaEsDIdp427v1Kdf66UwpOSrdxE10r1rc3hpXeePr/wzRYvTQIPMtrKnA1zkp6tj74PheHfKC
        ID680hG/ATLsq4Bb+xCqqwPQOa+uc6MMr4dJ4qfyVizbtL5pCwDHnnsI7Dq4iQ9equ80LnWRLcJf7
        1i4Eag26ZCL9m556PgAlJ2MP87NGlTAiu3DH/Jnw2tH8t2jDKCNQswgDiD8dUhGQTBLGCiPeLQdCA
        ARIcJK3Qlfg5esx3VbpTk8wazj2SqXy14kQ1l5AZddvtZKIGMGx+h9Uwv5sBrJqZNVJV4YNxj0xN5
        0in7FM2Q==;
Received: from [2001:4bb8:184:4aa1:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jPKhA-0002hC-Vx; Fri, 17 Apr 2020 06:41:49 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: pass kernel pointers to the sysctl ->proc_handler method
Date:   Fri, 17 Apr 2020 08:41:40 +0200
Message-Id: <20200417064146.1086644-1-hch@lst.de>
X-Mailer: git-send-email 2.25.1
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
