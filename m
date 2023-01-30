Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D16AB6809A7
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 10:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236515AbjA3Jgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 04:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236261AbjA3Jgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 04:36:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150FF301AE;
        Mon, 30 Jan 2023 01:35:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E1D1B80EC0;
        Mon, 30 Jan 2023 09:35:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96AC0C4339B;
        Mon, 30 Jan 2023 09:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675071344;
        bh=SN9wKaB2G3NrGgzP7de/8jvTvNTCaGtJT9amNsOd8kA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uSgsmhFONQ0/iaLG/osEIpXfGnd4HXt9WjlzEhaDNX+U36EtOFE1HmFlHBFOJNCrV
         gBRtgt2iyVelUlcz1gPqsteWQZLKazewegCknZuxbvxkyDOmL+9Nns1m5hLPaE4s6e
         MIXwOJfq8uz6xvceLxqXZgOKuR4oCEcy2GF+3dJ8=
Date:   Mon, 30 Jan 2023 10:35:41 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jaewan Kim <jaewan@google.com>
Cc:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com, adelva@google.com
Subject: Re: [PATCH v6 1/2] mac80211_hwsim: add PMSR capability support
Message-ID: <Y9ePbT7SLQ0gA9+E@kroah.com>
References: <20230124145430.365495-1-jaewan@google.com>
 <20230124145430.365495-2-jaewan@google.com>
 <Y8//ZflAidKNJAVQ@kroah.com>
 <CABZjns5FRY+_WD_G=sjiBxjSwaydgL-wgTAR-PSeh-42OTieRg@mail.gmail.com>
 <Y9dWztPR3FxkLv26@kroah.com>
 <CABZjns6nER31ZbBKQ_QKU0Hrh5V5U_W6Q4vGsE7kt7S5YYy3mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABZjns6nER31ZbBKQ_QKU0Hrh5V5U_W6Q4vGsE7kt7S5YYy3mg@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 05:08:54PM +0900, Jaewan Kim wrote:
> On Mon, Jan 30, 2023 at 2:34 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, Jan 30, 2023 at 12:48:37AM +0900, Jaewan Kim wrote:
> > > On Wed, Jan 25, 2023 at 12:55 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > > > +static int parse_ftm_capa(const struct nlattr *ftm_capa,
> > > > > +                       struct cfg80211_pmsr_capabilities *out)
> > > > > +{
> > > > > +     struct nlattr *tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX + 1];
> > > > > +     int ret = nla_parse_nested(tb, NL80211_PMSR_FTM_CAPA_ATTR_MAX,
> > > > > +                                ftm_capa, hwsim_ftm_capa_policy, NULL);
> > > > > +     if (ret) {
> > > > > +             pr_err("mac80211_hwsim: malformed FTM capability");
> > > >
> > > > dev_err()?
> > >
> > > Is dev_err() the printing error for device code?
> >
> > I am sorry, but I can not understand this question, can you rephrase it?
> 
> I just wanted to know better about `dev_err()`,
> because all existing code in this file uses `pr_err()`,
> and there's no good documentation for `dev_err()`.
> 
> Given your answer below, it seems like that `pr_err()` isn't a good
> choice in this file.
> Am I correct?

Drivers should never be using "raw" pr_*() calls as userspace has no way
of matching up a device and driver to a kernel log message.  That is
what the dev_*() calls provide.

As you are working with a device here (it's in your call-chain
somewhere), then you should use dev_*() calls.  Or use the
networking-specific versions of these as this is part of the network
stack.  But don't use raw pr_() calls please, that doesn't help anyone
out.

thanks,

greg k-h
