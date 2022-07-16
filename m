Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C191576DB9
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 14:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiGPMKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 08:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiGPMKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 08:10:10 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C096E1C10A;
        Sat, 16 Jul 2022 05:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=lJTkwXl58eYaowLrV3xUdNnwzw+6NT69JaoxraY3mBY=; b=EI8+37YJtaHw2wjXMeukbElhHY
        95/ctztpHGoQTXmbqAR0/v7cSXqfxTNFX//TOvzcUebMkZ9goDvpW5orqXj54fAry481+YAuDJYZq
        1oMj+efpwDHbm8Fvb7SmGdeO9ARNZa0vJcdPf0IAHnmBIyUzXECOiHSc5xP8PMvZG5F1WuTKbIzyM
        NwRbdwYAa1MEtwDyy2KcquqArpoQBZCSbNdxesLLXW8rBtt1bDOk1XxY6F5Ojw1lSz9hUs1k1AqRm
        7YnWhoYBpPRooOJskYtnF4kbcS4zew3aoji6/EIe3WhZnEsu+mgDvaTMDNpQjtsCvhzyRINcqc8hq
        wUnG8SlsLBLwwfeJ65BqkBpHKt4afFBbXLODh3dmCQWRmnk5VzeSHu5uiIdm66rJ+ixkoDOGebfPk
        ZvAlvW1r3mjeKDujNmV1885cZAi0q8IwisA+zT9JAWHDC2ZeVJtmUwM52qDFpmt9y1RUh9vPx261Y
        LdFQeQ0VCSs5V6QVcivI6D2Oguhqgj0vovOeMotQE1xIb4hb9km0sBQmnTgp97xZTOjcRMchoX/Vs
        hBwOp2mRf1wXBESrKBfOdnR79KLwHIA3qeProu40jCVWAIUxpMVGOI0lFIofv2omNLDT/KTA3MS66
        MIA9tXK/95vtGoPDJ+r3LS4+x3drHNEyD4Ex0Z5ws=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Nikolay Kichukov <nikolay@oldum.net>
Subject: Re: [PATCH v6 00/11] remove msize limit in virtio transport
Date:   Sat, 16 Jul 2022 14:10:05 +0200
Message-ID: <4065120.gss6piHCF5@silver>
In-Reply-To: <YtKm4M8W+rL+buNj@codewreck.org>
References: <cover.1657920926.git.linux_oss@crudebyte.com> <6713865.4mp09fW1HV@silver>
 <YtKm4M8W+rL+buNj@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Samstag, 16. Juli 2022 13:54:08 CEST Dominique Martinet wrote:
> Christian Schoenebeck wrote on Sat, Jul 16, 2022 at 11:54:29AM +0200:
> > > Looks good to me, I'll try to get some tcp/rdma testing done this
> > > weekend and stash them up to next
> > 
> > Great, thanks!
> 
> Quick update on this: tcp seems to work fine, I need to let it run a bit
> longer but not expecting any trouble.
> 
> RDMA is... complicated.
> I was certain an adapter in loopback mode ought to work so I just
> bought a cheap card alone, but I couldn't get it to work (ipoib works
> but I think that's just the linux tcp stack cheating, I'm getting unable
> to resolve route (rdma_resolve_route) errors when trying real rdma
> applications...)
> 
> 
> OTOH, linux got softiwarp merged in as RDMA_SIW which works perfectly
> with my rdma applications, after fixing/working around a couple of bugs
> on the server I'm getting hangs that I can't reproduce with debug on
> current master so this isn't exactly great, not sure where it goes
> wrong :|
> At least with debug still enabled I'm not getting any new hang with your
> patches, so let's call it ok...?

Well, I would need more info to judge or resolve that, like which patch 
exactly broke RDMA behaviour for you?

> I'll send a mail to ex-collegues who might care about it (and
> investigate a bit more if so), and a more open mail if that falls
> short...
> 
> --
> Dominique




