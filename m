Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0613683696
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 20:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbjAaTae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 14:30:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231917AbjAaTac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 14:30:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E03B5246
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 11:30:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95D4C616D6
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 19:30:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E95C433D2;
        Tue, 31 Jan 2023 19:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675193431;
        bh=FsC/V2WiTztOSBosymNmoSAu7YkpTqUCJBzw6LlFI5Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eOCfkqsMqJ0E3U1QWJSsRiduTa0/GF5X4vXSntqTuOzuHyBKFNv2wTBTOPSf6B/Hc
         otl4pieLlD375qRlx7a5VPxFwi40gFORsWQHE/ppaWYQceBKlhBLZW/j8kBBETUnGm
         Jte9kU5tjRbWXvStGX3PLw/7NO93m05b1hAdFzK41A+aJr0hES0td9aeoPyEtdRWnT
         CqK0e/vRUJdTSiQ28HURBbV4rqgoeoORbhMcqc7xDw2VkTvD2du9Qk2Zarh5wTtQVw
         Hpx/BkxV91B4J24APnS2OdZIb085dcdXreseOqMYAnYqj2Dd8GfQFdxl600yACGki8
         Fn03EsNUJQAnA==
Date:   Tue, 31 Jan 2023 11:30:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     netdev <netdev@vger.kernel.org>, "hare@suse.com" <hare@suse.com>,
        David Howells <dhowells@redhat.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        "jmeneghi@redhat.com" <jmeneghi@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH v2 2/3] net/handshake: Add support for PF_HANDSHAKE
Message-ID: <20230131113029.7647e475@kernel.org>
In-Reply-To: <9B7B66AA-E885-4317-8FE7-C9ABC94E027C@oracle.com>
References: <167474840929.5189.15539668431467077918.stgit@91.116.238.104.host.secureserver.net>
        <167474894272.5189.9499312703868893688.stgit@91.116.238.104.host.secureserver.net>
        <20230128003212.7f37b45c@kernel.org>
        <860B3B8A-1322-478E-8BF9-C5A3444227F7@oracle.com>
        <20230130203526.52738cba@kernel.org>
        <9B7B66AA-E885-4317-8FE7-C9ABC94E027C@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 Jan 2023 15:18:02 +0000 Chuck Lever III wrote:
> > On Jan 30, 2023, at 11:35 PM, Jakub Kicinski <kuba@kernel.org> wrote:
> > On Sat, 28 Jan 2023 14:06:49 +0000 Chuck Lever III wrote:  
> >> poll/listen/accept is the simplest and most natural way of
> >> materializing a socket endpoint in a process that I can think
> >> of. It's a well-understood building block. What specifically
> >> is troubling you about it?  
> > 
> > poll/listen/accept yes, but that's not the entire socket interface. 
> > Our overall experience with the TCP ULPs is rather painful, proxying
> > all the other callbacks here may add another dimension.  
> >
> > Also I have a fear (perhaps unjustified) of reusing constructs which are
> > cornerstones of the networking stack and treating them as abstractions.  
> 
> OK, then I take this as a NAK for listen/poll/accept in
> any form. I need some finality here because we need to
> move forward.

To be clear - if Paolo, Eric or someone else who knows the socket layer
better than I do thinks that your current implementation is good then 
I won't stand in the way. 

> >  kernel                          user space
> > 
> >   notification     ---------->
> > (new connection awaits)
> > 
> >                    <----------
> >                                  request (target fd=100)
> >   
> >                    ---------->  
> >   reply
> > (fd 100 is installed;
> >  extra params)  
> 
> What type of notification do you prefer for this? You've
> said in the past that RT signals are not appropriate. It
> would be easy for user space to simply wait on nlm_recvmsg()
> but I worry that netlink is not a reliable message service.

There are various bits and bobs in netlink which are supposed to help.
A socket which subscribed to notifications should get an error if a
delivery fails (netlink_overrun()). The kernel commonly supports a GET
request which the user space can exercise after missing notifications 
to get back in sync.

> And, do you have a preferred mechanism or code sample for
> installing a socket descriptor? 

I must admit - I don't.
