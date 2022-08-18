Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7EB5986A8
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 16:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343910AbiHRO6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 10:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343891AbiHRO6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 10:58:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D1E2EF;
        Thu, 18 Aug 2022 07:58:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CD03B821C8;
        Thu, 18 Aug 2022 14:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9CF2C433D7;
        Thu, 18 Aug 2022 14:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660834689;
        bh=luR6i3/V/eJO/gG0ZpCGa1hqwnYHscYwGEBAjl6sHKA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i2v6ZUpkzQSSzHrqICDibacK4Zhv5qKPs8VVF6miieOMl8KDym7iiL4TinmbxQZfc
         5HPhDnlGsPxvYTcU9kENPDfLRNbyBJM41ROtxLWNQXtz+NSYAld3r7raFmUTVLD2Cy
         SZkwX+bFj5dIJ/lGD/I3bLapl1O6vrjcSNre0h40=
Date:   Thu, 18 Aug 2022 16:58:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     duoming@zju.edu.cn
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        briannorris@chromium.org, amitkarwar@gmail.com,
        ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, johannes@sipsolutions.net,
        rafael@kernel.org
Subject: Re: [PATCH v7 1/2] devcoredump: remove the useless gfp_t parameter
 in dev_coredumpv and dev_coredumpm
Message-ID: <Yv5TefZcrUPY1Qjc@kroah.com>
References: <cover.1660739276.git.duoming@zju.edu.cn>
 <b861ce56ba555109a67f85a146a785a69f0a3c95.1660739276.git.duoming@zju.edu.cn>
 <YvzicURy8t2JdQke@kroah.com>
 <176e7de7.8a223.182ac1fbc47.Coremail.duoming@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176e7de7.8a223.182ac1fbc47.Coremail.duoming@zju.edu.cn>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 10:05:37PM +0800, duoming@zju.edu.cn wrote:
> Hello,
> 
> On Wed, 17 Aug 2022 14:43:29 +0200 Greg KH wrote:
> 
> > On Wed, Aug 17, 2022 at 08:39:12PM +0800, Duoming Zhou wrote:
> > > The dev_coredumpv() and dev_coredumpm() could not be used in atomic
> > > context, because they call kvasprintf_const() and kstrdup() with
> > > GFP_KERNEL parameter. The process is shown below:
> > > 
> > > dev_coredumpv(.., gfp_t gfp)
> > >   dev_coredumpm(.., gfp_t gfp)
> > >     dev_set_name
> > >       kobject_set_name_vargs
> > >         kvasprintf_const(GFP_KERNEL, ...); //may sleep
> > >           kstrdup(s, GFP_KERNEL); //may sleep
> > > 
> > > This patch removes gfp_t parameter of dev_coredumpv() and dev_coredumpm()
> > > and changes the gfp_t parameter of kzalloc() in dev_coredumpm() to
> > > GFP_KERNEL in order to show they could not be used in atomic context.
> > > 
> > > Fixes: 833c95456a70 ("device coredump: add new device coredump class")
> > > Reviewed-by: Brian Norris <briannorris@chromium.org>
> > > Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
> > > Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> > > ---
> > > Changes in v7:
> > >   - Remove gfp_t flag in amdgpu device.
> > 
> > Again, this creates a "flag day" where we have to be sure we hit all
> > users of this api at the exact same time.  This will prevent any new
> > driver that comes into a maintainer tree during the next 3 months from
> > ever being able to use this api without cauing build breakages in the
> > linux-next tree.
> > 
> > Please evolve this api to work properly for everyone at the same time,
> > like was previously asked for so that we can take this change.  It will
> > take 2 releases, but that's fine.
> 
> Thank you for your reply, I will evolve this api to work properly for everyone.
> If there are not any new drivers that use this api during the next 3 months, 
> I will send this patch again. Otherwise, I will wait until there are not new
> users anymore.

No, that is not necessary.  Do the work now so that there is no flag day
and you don't have to worry about new users, it will all "just work".

thanks,

greg k-h
