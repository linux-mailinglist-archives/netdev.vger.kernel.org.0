Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A289C6D9D97
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 18:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236554AbjDFQdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 12:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbjDFQdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 12:33:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712767A8D;
        Thu,  6 Apr 2023 09:33:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BEC6645BC;
        Thu,  6 Apr 2023 16:33:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB808C433D2;
        Thu,  6 Apr 2023 16:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680798814;
        bh=cTyaZcL9q+dhbrZewRGmFIE1Q1B/I9YJm6lfhVQDDB4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xmdRF3xBj09L62OvSpjXeC6FDz5wCXSVq7lLb8EeQHA9ApqCM3Yz3Y6CqPln+4tDj
         bGQhxM22hfcAaZTkG4cRxrmrP3AevjnIWg8+niSkx8anfN1jW7qQMjEk2SYWMXwTjq
         65G5n/XUySqcKk0qrmtqVivEUwh0msGKl+w9uRxE=
Date:   Thu, 6 Apr 2023 18:33:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sumitra Sharma <sumitraartsy@gmail.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, Coiby Xu <coiby.xu@gmail.com>,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: qlge: Remove macro FILL_SEG
Message-ID: <2023040618-dedicate-rebalance-90c6@gregkh>
References: <20230405150627.GA227254@sumitra.com>
 <ZC2gJdUA6zGOjX4P@corigine.com>
 <20230406144644.GB231658@sumitra.com>
 <2023040648-zeppelin-escapist-86d1@gregkh>
 <20230406152855.GC231658@sumitra.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406152855.GC231658@sumitra.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 08:28:55AM -0700, Sumitra Sharma wrote:
> On Thu, Apr 06, 2023 at 04:57:44PM +0200, Greg Kroah-Hartman wrote:
> > On Thu, Apr 06, 2023 at 07:46:44AM -0700, Sumitra Sharma wrote:
> > > On Wed, Apr 05, 2023 at 06:21:57PM +0200, Simon Horman wrote:
> > > > On Wed, Apr 05, 2023 at 08:06:27AM -0700, Sumitra Sharma wrote:
> > > > > Remove macro FILL_SEG to fix the checkpatch warning:
> > > > > 
> > > > > WARNING: Macros with flow control statements should be avoided
> > > > > 
> > > > > Macros with flow control statements must be avoided as they
> > > > > break the flow of the calling function and make it harder to
> > > > > test the code.
> > > > > 
> > > > > Replace all FILL_SEG() macro calls with:
> > > > > 
> > > > > err = err || qlge_fill_seg_(...);
> > > > 
> > > > Perhaps I'm missing the point here.
> > > > But won't this lead to err always either being true or false (1 or 0).
> > > > Rather than the current arrangement where err can be
> > > > either 0 or a negative error value, such as -EINVAL.
> > > >
> > > 
> > > Hi Simon
> > > 
> > > 
> > > Thank you for the point you mentioned which I missed while working on this
> > > patch. 
> > > 
> > > However, after thinking on it, I am still not able to get any fix to this
> > > except that we can possibly implement the Ira's solution here which is:
> > > 
> > > https://lore.kernel.org/outreachy/64154d438f0c8_28ae5229421@iweiny-mobl.notmuch/
> > > 
> > > Although we have to then deal with 40 lines of ifs.
> > 
> > Which implies that the current solution is the best one, so I would
> > recommend just leaving it as-is.
> >
> 
> Hi greg
> 
> Before leaving it I would like to know your opinion on the solution Dan is offering.

I still think you should leave it as-is.

thanks,

greg k-h
