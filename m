Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 079F952A6A6
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 17:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349205AbiEQPcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 11:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350036AbiEQPcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 11:32:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659E541615
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 08:32:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3C1CB819A4
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 15:32:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBF0C34113;
        Tue, 17 May 2022 15:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652801557;
        bh=mMIf+15wOIxsjWlDWfnTEaFz7gsZkz0RdS9z2VPneBc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XxE4idqxI2MCiGIdXnsuyx0dX3Pyccfk4eiDOK5W48+8lJl0d7H+WPH037FqlOsCD
         ZMUnozOyrc14XI5K3qXpUEo+s0IMPnyYSjtzrnX3ErAN2LeEB7S6DwbOYK1VLNFNvV
         FQmpEyDcdE0tikVvLieDkzPqG8UAalB/BZ+6phZIrTb+gxnmCZZswdY9XCqZvistcV
         vLzZdzY2CIZsfDleaBu9mUizGvtQHoljCUrNZs/S01v2ifNXeyJkLoW8BzppHZ8a6d
         luWqjc0l3AmH6xUIVQI87kI2kIyWXE3/vXfU978muBO3RPBQJESeypSr8jdc27a1f6
         wslO5RPr+06eQ==
Date:   Tue, 17 May 2022 08:32:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        kernel-team@fb.com
Subject: Re: [PATCH net-next v3 08/10] ptp: ocp: fix PPS source selector
 reporting
Message-ID: <20220517083236.68f0d010@kernel.org>
In-Reply-To: <20220517015428.l6ttuht3ufrl2deb@bsd-mbp.dhcp.thefacebook.com>
References: <20220513225924.1655-1-jonathan.lemon@gmail.com>
        <20220513225924.1655-9-jonathan.lemon@gmail.com>
        <20220516174317.457ec2d1@kernel.org>
        <20220517015428.l6ttuht3ufrl2deb@bsd-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 May 2022 18:54:28 -0700 Jonathan Lemon wrote:
> On Mon, May 16, 2022 at 05:43:17PM -0700, Jakub Kicinski wrote:
> > On Fri, 13 May 2022 15:59:22 -0700 Jonathan Lemon wrote:  
> > > The NTL timecard design has a PPS1 selector which selects the
> > > the PPS source automatically, according to Section 1.9 of the
> > > documentation.
> > > 
> > >   If there is a SMA PPS input detected:
> > >      - send signal to MAC and PPS slave selector.
> > > 
> > >   If there is a MAC PPS input detected:
> > >      - send GNSS1 to the MAC
> > >      - send MAC to the PPS slave
> > > 
> > >   If there is a GNSS1 input detected:
> > >      - send GNSS1 to the MAC
> > >      - send GNSS1 to the PPS slave.MAC
> > > 
> > > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>  
> > 
> > This one and patch 10 need Fixes tags  
> 
> This is for a debugfs entry.  I disagree that a Fixes: tag
> is needed here.
> 
> I'll do it for patch 10 if you insist, but this only happens
> if ptp_clock_register() fails, which not normally seen.

Fixes need a fixes tag and need to target the right tree.
