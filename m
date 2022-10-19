Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0C07604C45
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 17:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbiJSPxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 11:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232711AbiJSPxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 11:53:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE4632B9C;
        Wed, 19 Oct 2022 08:50:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFA61B824F3;
        Wed, 19 Oct 2022 15:48:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A444C433C1;
        Wed, 19 Oct 2022 15:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666194518;
        bh=3Ruo5jB3xafvIKI2yCrU2v1/8ZFB6GkBfPPKWvQZBTI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jVtcxDVWZC3OicxMHdC71Xxb3H/q0VoNxCyri2oFM+761jEBhUMSlVSS4K8N8yidn
         RIYrThULdf0vFT4jS+wjw1d936khsHUySUkNYWIb/rruad1QAqlW94xxH66NlqOndL
         ct1OE7nLBOfjceBO1fnPhaoz1D2LaPkDKLHkgk0M=
Date:   Wed, 19 Oct 2022 17:48:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     Daniele Palmas <dnlplm@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: usb: qmi_wwan implement tx packets
 aggregation
Message-ID: <Y1AcU0CH/j69uvwx@kroah.com>
References: <20221019132503.6783-1-dnlplm@gmail.com>
 <87lepbsvls.fsf@miraculix.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87lepbsvls.fsf@miraculix.mork.no>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 05:04:31PM +0200, Bjørn Mork wrote:
> Daniele Palmas <dnlplm@gmail.com> writes:
> > I'm aware that rmnet should be the preferred way for qmap, but I think there's
> > still value in adding this feature to qmi_wwan qmap implementation since there
> > are in the field many users of that.
> >
> > Moreover, having this in mainline could simplify backporting for those who are
> > using qmi_wwan qmap feature but are stuck with old kernel versions.
> >
> > I'm also aware of the fact that sysfs files for configuration are not the
> > preferred way, but it would feel odd changing the way for configuring the driver
> > just for this feature, having it different from the previous knobs.
> 
> It's not just that it's not the preferred way.. I believe I promised
> that we wouldn't add anything more to this interface.  And then I broke
> that promise, promising that it would never happen again.  So much for
> my integrity.
> 
> This all looks very nice to me, and the results are great, and it's just
> another knob...
> 

Please no more sysfs files for stuff like this.  This turns into
vendor-specific random files that no one knows how to change over time
with no way to know what userspace tools are accessing them, or if even
anyone is using them at all.

Shouldn't there be standard ethtool apis for this?

> But I don't think we can continue adding this stuff.  The QMAP handling
> should be done in the rmnet driver. Unless there is some reason it can't
> be there? Wouldn't the same code work there?

rmnet would be better, but again, no new sysfs files please,

thanks,

greg k-h
