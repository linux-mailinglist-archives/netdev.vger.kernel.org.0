Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B63D607596
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 13:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiJULCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 07:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiJULCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 07:02:42 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7021425FD06
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 04:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=pJcp6g7CIfQJ6GjbKC9pe/tKr/mSwQS3l5pSw4QUrmc=;
        t=1666350161; x=1667559761; b=jO3A7qk+egGjPIsEgHhOuArLLDVOTYciDypfuyoUNXRO47f
        dsDdHa9U129ug6yQ8IHoHcBs69TnXG79u5comFZDL3yLrYTHPGOBCTejYKFJARsx/Is1HTTmzBJvK
        YZQkEXFb8fy0AnK/S5pGmzPr9pm9Wut1LZ3H3ktHF9iKuCt+WCw914oX1IU7RWo56ieIyXDDfCx6Z
        CrpPBN6Dewa3qWg1r5zPpJK4n5S9aUgFe25MpgC8O9vtCwX+J2cyBDP06VNnPi0kKGC3wiI+9zSrK
        jXR6Z2qA664tiSa3QQExXJ6u1OErT3pSnbV5ZXiKjaNWKEGHCHsDvDvj3ufdK+xg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1olpnM-00Cpst-1e;
        Fri, 21 Oct 2022 13:02:32 +0200
Message-ID: <8380d344eb5bc084f457920b0133e58ae05f6f2b.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 12/13] genetlink: allow families to use split
 ops directly
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jiri@resnulli.us, razor@blackwall.org,
        nicolas.dichtel@6wind.com, gnault@redhat.com,
        jacob.e.keller@intel.com, fw@strlen.de
Date:   Fri, 21 Oct 2022 13:02:31 +0200
In-Reply-To: <20221020110950.6e91f9bb@kernel.org>
References: <20221018230728.1039524-1-kuba@kernel.org>
         <20221018230728.1039524-13-kuba@kernel.org>
         <a23c47631957c3ba3aaa87bc325553da04f99a0c.camel@sipsolutions.net>
         <20221019122504.0cb9d326@kernel.org>
         <dfac0b6e09e9739c7f613cb8ed77c81f9db0bb44.camel@sipsolutions.net>
         <20221019125745.3f2e7659@kernel.org>
         <683f4c655dd09a2af718956e8c8d56e6451e11ac.camel@sipsolutions.net>
         <20221020110950.6e91f9bb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-10-20 at 11:09 -0700, Jakub Kicinski wrote:
> On Thu, 20 Oct 2022 09:32:17 +0200 Johannes Berg wrote:
> > Hmm. The codegen/YAML part likely won't really happen for all of the
> > families so perhaps some simplification would be good?
> >=20
> > I feel like I probably should've changed this when adding
> > GENL_DONT_VALIDATE_DUMP_STRICT / GENL_DONT_VALIDATE_STRICT, but I guess
> > that's too late now :(
> >=20
> > I guess we could add another set of flags, but that'd be annoying.
>=20
> Perhaps we could hang it of the .resv_start_op as well?

Yes, hopefully? Maybe?

> Any op past that would treat policy =3D=3D NULL as reject all?

Right. The only danger is that someone already added new stuff somewhere
and bad/broken userspace already used it with garbage attrs.

But the chances of that are probably low.

So I'd say go for it, and worst case we bump up the resv_start_op for
anything that breaks? Wouldn't be a huge loss either.

> We'd need to add GENL_DONT_VALIDATE_DO for families which=20
> want to parse inside the callbacks. I wonder if people would
> get annoyed.

Why would anyone really want to _parse_ in the callbacks?

johannes
