Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31DE05769E2
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbiGOWZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbiGOWZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:25:34 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626A265D6E;
        Fri, 15 Jul 2022 15:25:33 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 1ED10C01D; Sat, 16 Jul 2022 00:25:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657923932; bh=EgCvy39owjpXR/ZA9X5SA+DJCioLvCBh4wrj89/LUI0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zzWYzGHRPvfgEUFFDK2Szh9uTznbiTgpaGHc/BEXdmXF0giRP8bCW+ZN5GI+yfcyc
         L2KobqZkPJG0yCCrhhExbAKrdThiOhsyzBUpQVytkEutRCHDSs6AJ61+WILfJ89KzM
         EiHRTHKbw8bLTQjbmG4V93Weh/QsGExkPI11dteVYYjMNYCKxlLGA8p1rMOGqqvnFR
         gOx2+k8BHYuDISsR9PPZUTC/oegpEn2ecDB75YOX6ASTple5jabwGIjYMGcbSGELNo
         FbJLrJs07vnwjcHgjl6oYZkZ+9Soel43DfVJtYknWCpc2aU4LbWmutjF/z/zszQ+75
         3VLVTDOmogQXA==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 0B840C009;
        Sat, 16 Jul 2022 00:25:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657923931; bh=EgCvy39owjpXR/ZA9X5SA+DJCioLvCBh4wrj89/LUI0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b82VBKymA8c4i+j+YO6hmXXGQPWmVA0PJF/K1vh9zGzGQnihIPcNuKiIA67zTIF3o
         G5/SkDa8ixeWt4GjHigD1Q6o1Gk1lR6T3uoYS8MnO03YgM4NTCtAdEwZU+xRez8+zg
         zSs6a1gd6IyX0NhDWTfeJkpmvORij87nikRaJJmc6Vk/CV/0TL6a6SOE/WptDbNua3
         U+PISoNV2z8i/IzRbNBD8WTG7qipA9bQyutuscE1FuFAlA/FYI7UtFqdT+sbpojP1K
         W+tOsDpAm1rPJ90cDNQVpApvkqN9N0nYQ1dd4jengLH064ogb90GPg6IasQl3eubN7
         fKkYn8nimRYsQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 9127998f;
        Fri, 15 Jul 2022 22:25:25 +0000 (UTC)
Date:   Sat, 16 Jul 2022 07:25:10 +0900
From:   asmadeus@codewreck.org
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     ericvh@gmail.com, lucho@ionkov.net, linux_oss@crudebyte.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, tomasbortoli@gmail.com,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: 9p: fix possible refcount leak in p9_read_work()
Message-ID: <YtHpRizqDf7+4WVb@codewreck.org>
References: <20220712104438.30800-1-hbh25y@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220712104438.30800-1-hbh25y@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangyu Hua wrote on Tue, Jul 12, 2022 at 06:44:38PM +0800:
> p9_req_put need to be called when m->rreq->rc.sdata is NULL to avoid
> possible refcount leak.
> 
> Fixes: 728356dedeff ("9p: Add refcount to p9_req_t")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>

I realize I didn't reply to this -- I've reworded the commit message a
bit and queued it for 5.20:
https://github.com/martinetd/linux/commit/4ac7573e1f9333073fa8d303acc941c9b7ab7f61

I'll have a look at the RDMA path you pointed at once I can find time to
make this adapter work, and will credit you for it as well

--
Dominique
