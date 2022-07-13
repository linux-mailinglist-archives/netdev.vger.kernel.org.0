Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 463D757340F
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 12:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235929AbiGMKXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 06:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236021AbiGMKX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 06:23:29 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D81FB8E9;
        Wed, 13 Jul 2022 03:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=wHmQ4QutF9xLy8a32/xGDr4CB2rcz5qRvqhIsboHxus=; b=FCMpJerlIFQDhcbFGN31XMhAlB
        Dyb1l9AOPzR26jZVjqfwDKgBNmKaTYL7nVXoA1xai6NsXQeQQ82Qzu589JcDOZfcDGzuAiO+R0o5g
        fIPQi9dnf81OW5s4HZkKLLqY5LPwNfFrvSe6ACpDCPVthMmSBMHdVr/kHEC8kiR3izaHxZdceeGhi
        5romADZ0TD7SoBKMNsygQcPINfBc3vg8Wa4Gfp/ewx5OvPWnpxN37hKdt8ufHXwkp86aVv7eNXrBc
        i8tYPo8uVO8dhZecQCjxTogwEK95Oqp498g+hstlJm/xJ/+3FFEprFpk+AYMbbbfweuppmgQlAArX
        QrKjHzP2FnJp6E/eu7UF5UzyLsdnmlX3O6hZKPsvDox7jAUBpwb+rDXDUhmFK8jkmLTNFHdRKELW+
        a33x8rNmc+JRWYifK1WMN/pIqHBwGXvm8yxhj5uJAVnsRLqBYcXphx6xtTq7qJTXMAvgbl03FM8+D
        CutdT+XiAoBlWHfbOz3balCpDiXuYsx30BwPfQybZ3B3V2uSg2N69pJzgSaGipwn3tofYDBSqOARK
        76E4aiOGlLSh+xAG0nYZtr1PofnrUboxRWnapzHgqWT3cR4oej7MaDMiRGnBy3Of+zEj4YCMcYRpI
        GzK3XIU2qpRX+/RTTFVzP1jnbeDC77jN4sjQvyA8Y=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Latchesar Ionkov <lucho@ionkov.net>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        Nikolay Kichukov <nikolay@oldum.net>
Subject: Re: [V9fs-developer] [PATCH v5 11/11] net/9p: allocate appropriate reduced
 message buffers
Date:   Wed, 13 Jul 2022 12:22:50 +0200
Message-ID: <3177156.tURSKFNe1E@silver>
In-Reply-To: <Ys6QlcShhji2sx9V@codewreck.org>
References: <cover.1657636554.git.linux_oss@crudebyte.com> <4284956.GYXQZuIPEp@silver>
 <Ys6QlcShhji2sx9V@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mittwoch, 13. Juli 2022 11:29:57 CEST Dominique Martinet wrote:
> Christian Schoenebeck wrote on Wed, Jul 13, 2022 at 11:19:48AM +0200:
> > > - for this particular patch, we can still allocate smaller short buffers
> > > for requests, so we should probably keep tsize to 0.
> > > rsize there really isn't much we can do without a protocol change
> > > though...
> > 
> > Good to know! I don't have any RDMA setup here to test, so I rely on what
> > you say and adjust this in v6 accordingly, along with the strcmp -> flag
> > change of course.
> 
> Yeah... I've got a connect-x 3 (mlx4, got a cheap old one) card laying
> around, I need to find somewhere to plug it in and actually run some
> validation again at some point.
> Haven't used 9p/RDMA since I left my previous work in 2020...
> 
> I'll try to find time for that before the merge
> 
> > As this flag is going to be very RDMA-transport specific, I'm still
> > scratching my head for a good name though.
> 
> The actual limitation is that receive buffers are pooled, so something
> to like pooled_rcv_buffers or shared_rcv_buffers or anything along that
> line?

OK, I'll go this way then, as it's the easiest to do, can easily be refactored 
in future if someone really cares, and it feels less like a hack than 
injecting "if transport == rdma" into client code directly.

Best regards,
Christian Schoenebeck


