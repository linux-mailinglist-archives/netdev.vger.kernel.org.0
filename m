Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C41E94F6DE9
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 00:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237139AbiDFWnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 18:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiDFWnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 18:43:31 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41D9D95C8;
        Wed,  6 Apr 2022 15:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+WIA2q0pmyXTrZ0eOlA9UZBi8s5TS5ILt11uq0tkv4M=; b=gpwnf3R91zYcnEE8S+QFl4Pyj8
        rO/0fZBeKQ9GsdWtpD5cre6S+irKUoOhJ5bq4HUb5K4rxkIGv8ZNMc0LFhRgT6tSnUjC802MqJeK+
        gmHC2v4eKWMX9ajIkyiJtB7oT+DKpTysfX+CWNVo72qLKtczkUpOcp8hqTX4/3lJ+bj0yDrklmUGh
        KOPzXJv8WZthp74yQV7tIet98IgKZkvQLd6REiTjTRVk4lU2vX+jQykweMK2BDohchavVLXwywxij
        sLwEuCW7x5KC3ECovNLHguysxCA/06V9B9P0HnMW1vCiW0X/UGHpW/mDmQ+5h+KBVAFE9bFVw3Nci
        0pQwyEOA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ncEL5-0089eh-7f; Wed, 06 Apr 2022 22:41:23 +0000
Date:   Wed, 6 Apr 2022 15:41:23 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Yan Zhu <zhuyan34@huawei.com>, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        keescook@chromium.org, kpsingh@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        liucheng32@huawei.com, netdev@vger.kernel.org,
        nixiaoming@huawei.com, songliubraving@fb.com,
        xiechengliang1@huawei.com, yhs@fb.com, yzaikin@google.com,
        zengweilin@huawei.com
Subject: Re: [PATCH v3 sysctl-next] bpf: move bpf sysctls from
 kernel/sysctl.c to bpf module
Message-ID: <Yk4XE/hKGOQs5oq0@bombadil.infradead.org>
References: <Yh1dtBTeRtjD0eGp@bombadil.infradead.org>
 <20220302020412.128772-1-zhuyan34@huawei.com>
 <Yh/V5QN1OhN9IKsI@bombadil.infradead.org>
 <d8843ebe-b8df-8aa0-a930-c0742af98157@iogearbox.net>
 <YiFb/lZzPDIIf2rC@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YiFb/lZzPDIIf2rC@bombadil.infradead.org>
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

On Thu, Mar 03, 2022 at 04:23:26PM -0800, Luis Chamberlain wrote:
> On Fri, Mar 04, 2022 at 12:44:48AM +0100, Daniel Borkmann wrote:
> > On 3/2/22 9:39 PM, Luis Chamberlain wrote:
> > > On Wed, Mar 02, 2022 at 10:04:12AM +0800, Yan Zhu wrote:
> > > > We're moving sysctls out of kernel/sysctl.c as its a mess. We
> > > > already moved all filesystem sysctls out. And with time the goal is
> > > > to move all sysctls out to their own susbsystem/actual user.
> > > > 
> > > > kernel/sysctl.c has grown to an insane mess and its easy to run
> > > > into conflicts with it. The effort to move them out is part of this.
> > > > 
> > > > Signed-off-by: Yan Zhu <zhuyan34@huawei.com>
> > > 
> > > Daniel, let me know if this makes more sense now, and if so I can
> > > offer take it through sysctl-next to avoid conflicts more sysctl knobs
> > > get moved out from kernel/sysctl.c.
> > 
> > If this is a whole ongoing effort rather than drive-by patch,
> 
> It is ongoing effort, but it will take many releases before we tidy
> this whole thing up.
> 
> > then it's
> > fine with me. 
> 
> OK great. Thanks for understanding the mess.
> 
> > Btw, the patch itself should also drop the linux/bpf.h
> > include from kernel/sysctl.c since nothing else is using it after the
> > patch.
> 
> I'll let Yan deal with that.

Yan, feel free to resubmit based on sysctl-next [0].

[0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/log/?h=sysctl-next

  Luis
