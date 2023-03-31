Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 045876D16F2
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 07:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbjCaFt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 01:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjCaFtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 01:49:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27411BDF1
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 22:49:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A29546235C
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 05:49:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45DCBC433EF;
        Fri, 31 Mar 2023 05:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680241763;
        bh=Yw7/GHvt9TVDQ0FbQUD794UyOwYG/rHTIXocgA5C7LE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=du2lux+4z9fuJkw+E6h2GjDEFOwWUxi1LNlEdskQymXIu7TWkeLonGYMpFMsKWJm5
         cwN7rWKopbMNIdCQCCyjXGocaiSbwrz36xddItWnKUfudh7zmB1CnCOdstX9JsyawG
         YV//Q6Cq4eytj2Dj2Vq5Z5L5eOKot3eLbyyuu5jSk8UQ33oTmVtWX7uYRLFicgLXh5
         +zrv+iPjC6Mz4SiShQZqlKPhe6iU3+AeFCkCdFnBf5/5g3Zqt5a/6mgzbG+PvyNQH+
         v27F+nbcr0xyxB691M6io1e9dyyumVaqItwMc8wPhieWjnLFF808FO9vAQCEKzL61O
         NjOYjKeTPH4Yg==
Date:   Thu, 30 Mar 2023 22:49:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Boris Pismenny <borisp@nvidia.com>, john.fastabend@gmail.com,
        Paolo Abeni <pabeni@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        linux-nvme@lists.infradead.org,
        Chuck Lever <chuck.lever@oracle.com>,
        kernel-tls-handshake@lists.linux.dev,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 10/18] nvme-tcp: fixup send workflow for kTLS
Message-ID: <20230330224920.3a47fec9@kernel.org>
In-Reply-To: <634385cc-35af-eca0-edcb-1196a95d1dfa@grimberg.me>
References: <20230329135938.46905-1-hare@suse.de>
        <20230329135938.46905-11-hare@suse.de>
        <634385cc-35af-eca0-edcb-1196a95d1dfa@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Mar 2023 18:24:04 +0300 Sagi Grimberg wrote:
> > kTLS does not support MSG_EOR flag for sendmsg(), and in general
> > is really picky about invalid MSG_XXX flags.  
> 
> CC'ing TLS folks.
>
> Can't tls simply ignore MSG_EOR instead of consumers having to be 
> careful over it?

I think we can support EOR, I don't see any fundamental problem there.

> > So ensure that the MSG_EOR flags is blanked out for TLS, and that
> > the MSG_SENDPAGE_LAST is only set if we actually do sendpage().  
> 
> You mean MSG_SENDPAGE_NOTLAST.
> 
> It is also a bit annoying that a tls socket dictates different behavior
> than a normal socket.
> 
> The current logic is rather simple:
> if more data comming:
> 	flags = MSG_MORE | MSG_SENDPAGE_NOTLAST
> else:
> 	flags = MSG_EOR
> 
> Would like to keep it that way for tls as well. Can someone
> explain why this is a problem with tls?

Some of the flags are call specific, others may be internal to the
networking stack (e.g. the DECRYPTED flag). Old protocols didn't do 
any validation because people coded more haphazardly in the 90s.
This lack of validation is a major source of technical debt :(
