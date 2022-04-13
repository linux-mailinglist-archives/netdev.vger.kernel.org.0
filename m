Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09C4F4FFE52
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 21:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237917AbiDMTDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 15:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237843AbiDMTDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 15:03:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78EDB387AA;
        Wed, 13 Apr 2022 12:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gGzlD5A4418uUOPHT5N2mBkui3mXPqkvbOvSDqYFo/U=; b=xcjwy8mOfbFQX2l5L/6wNiXMcd
        SEB/7Qixa335aqP6HdeSabI4s2OLf5TOrL88lAwjPnm0kFloYfdSS6bvHOSA3sVKvXfG8ouhjxcql
        WlQrwsK4bT+OTzhu+/TIGDR2+jJ4dKMNSHBT7p7fqi4NreV4n9tXuHU9tiBbyNioq4D6uU5sxNVLQ
        D/tp3CGIsocA4hXMgabSDfnjrzpwRTRxQLWy0ksHSvGFXz+ge6rpdXz5xqptmR3kakhat7jhzCHLs
        c3ReufnyjneR9qhI1N3YUS74usrjVMgETKzIyfibFm0Jas66kBGxEqpkfXStY61SXqX5vCU8GOE8l
        Ul9yEzNg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1neiEF-002HCZ-9Z; Wed, 13 Apr 2022 19:00:35 +0000
Date:   Wed, 13 Apr 2022 12:00:35 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Yan Zhu <zhuyan34@huawei.com>, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        keescook@chromium.org, kpsingh@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        liucheng32@huawei.com, netdev@vger.kernel.org,
        nixiaoming@huawei.com, songliubraving@fb.com,
        xiechengliang1@huawei.com, yhs@fb.com, yzaikin@google.com,
        zengweilin@huawei.com, leeyou.li@huawei.com,
        laiyuanyuan.lai@huawei.com
Subject: Re: [PATCH v4 sysctl-next] bpf: move bpf sysctls from
 kernel/sysctl.c to bpf module
Message-ID: <Ylcd0zvHhi96zVi+@bombadil.infradead.org>
References: <Yk4XE/hKGOQs5oq0@bombadil.infradead.org>
 <20220407070759.29506-1-zhuyan34@huawei.com>
 <3a82460b-6f58-6e7e-a3d9-141f42069eda@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a82460b-6f58-6e7e-a3d9-141f42069eda@iogearbox.net>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 13, 2022 at 04:45:00PM +0200, Daniel Borkmann wrote:
> On 4/7/22 9:07 AM, Yan Zhu wrote:
> > We're moving sysctls out of kernel/sysctl.c as its a mess. We
> > already moved all filesystem sysctls out. And with time the goal is
> > to move all sysctls out to their own subsystem/actual user.
> > 
> > kernel/sysctl.c has grown to an insane mess and its easy to run
> > into conflicts with it. The effort to move them out is part of this.
> > 
> > Signed-off-by: Yan Zhu <zhuyan34@huawei.com>
> 
> Acked-by: Daniel Borkmann <daniel@iogearbox.net>
> 
> Given the desire is to route this via sysctl-next and we're not shortly
> before but after the merge win, could we get a feature branch for bpf-next
> to pull from to avoid conflicts with ongoing development cycle?

Sure thing. So I've never done this sort of thing, so forgive me for
being new at it. Would it make sense to merge this change to sysctl-next
as-is today and put a frozen branch sysclt-next-bpf to reflect this,
which bpf-next can merge. And then sysctl-next just continues to chug on
its own? As-is my goal is to keep sysctl-next as immutable as well.

Or is there a better approach you can recommend?

  Luis
