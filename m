Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5794B95F8
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 03:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbiBQCko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 21:40:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbiBQCkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 21:40:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C2BC20
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 18:40:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EF3AB820CC
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 02:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7C9C004E1;
        Thu, 17 Feb 2022 02:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645065627;
        bh=4JhVAR1ogiNI2Zsga4Kqx5MUWw35NFogEyuj+xodayE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LCilwvRGr7zN5PfV5fBKyG6+yaqmH9Ck9hVCtByyZ2f2bH3w+SLw2BQT1dS3N6VYg
         c3hsv7scMpeElb1Ru/56KjOZ/d/g2eTZd5/NgmXt7L21KwqsSR6EtSuDUCOcqerfV3
         AeuXYoGbseY273DnkDEVvyktE6hIsmMFn+yj8fL1TfT4/rvViQSWZClTBaxhU5UHgf
         Ulicsib7baJLSiH5KU5l+4Akyyc2ip3jxkpl5ZG/tsUW1FaF/AefUmwsCNaB7ABe6x
         fcr34267NgHZsfm6fws+ewwMnOmyffeCT6u3UpNXi16Ll4+wu6RKX8cIBegFwFHYJb
         +UHFKaWZ/kZTg==
Date:   Wed, 16 Feb 2022 18:40:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>,
        Guillaume Nault <gnault@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        stephen@networkplumber.org, netdev@vger.kernel.org
Subject: Re: [RFC iproute2] tos: interpret ToS in natural numeral system
Message-ID: <20220216184025.153816f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <6dbf4b79-70d4-ed6c-0fd4-c393ab1c90b3@gmail.com>
References: <20220216194205.3780848-1-kuba@kernel.org>
        <20220216222352.GA3432@pc-4.home>
        <6dbf4b79-70d4-ed6c-0fd4-c393ab1c90b3@gmail.com>
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

On Wed, 16 Feb 2022 18:52:43 -0700 David Ahern wrote:
> On 2/16/22 3:23 PM, Guillaume Nault wrote:
> > On Wed, Feb 16, 2022 at 11:42:05AM -0800, Jakub Kicinski wrote:  
> >> Silently forcing a base numeral system is very painful for users.
> >> ip currently interprets tos 10 as 0x10. Imagine user's bash script
> >> does:
> >>
> >>   .. tos $((TOS * 2)) ..
> >>
> >> or any numerical operation on the ToS.
> >>
> >> This patch breaks existing scripts if they expect 10 to be 0x10.  
> > 
> > I agree that we shouldn't have forced base 16 in the first place.
> > But after so many years I find it a bit dangerous to change that.  
> 
> I agree. In this case the change in behavior will not be very obvious
> and could lead to confusion. I think this is something we have to live with.
> 
> > 
> > What about just printing a warning when the value isn't prefixed with
> > '0x'? Something like (completely untested):
> > 
> > @@ -535,6 +535,12 @@ int rtnl_dsfield_a2n(__u32 *id, const char *arg)
> >  	if (!end || end == arg || *end || res > 255)
> >  		return -1;
> >  	*id = res;
> > +
> > +	if (strncmp("0x", arg, 2))
> > +		fprintf(stderr,
> > +			"Warning: dsfield and tos parameters are interpreted as hexadecimal values\n"
> > +			"Use 'dsfield 0x%02x' to avoid this message\n", res);
> > +
> >  	return 0;
> >  }  
> 
> That seems reasonable to me to let users know of this behavior.

SGTM!
