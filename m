Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C95DC6878A0
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 10:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbjBBJSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 04:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbjBBJSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 04:18:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB72212A
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 01:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675329442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7dJyoNHO/32TPLaVEs81Twv24+CrrrRmx9kYQN/Y+LQ=;
        b=f7mkzExDN7/Ake+aPaSDf6Y+yilTzwi3GkD/9EUlVOIKv0Do8/FVyhBvod3MNzHKvNwGfv
        o5Ria7CHQTC0U7F/0OhaMp0dbBkIwYDja3rpGyvmZgBIXlAmFLfq7va1QfHnU3FODx6PU0
        guJ4GhxafVRfuALUTELEssvA3SXbN8w=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-171-5w-R_1vXO_SG5-hMntpj9w-1; Thu, 02 Feb 2023 04:17:21 -0500
X-MC-Unique: 5w-R_1vXO_SG5-hMntpj9w-1
Received: by mail-pg1-f199.google.com with SMTP id g7-20020a636b07000000b004d1c5988521so739677pgc.22
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 01:17:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7dJyoNHO/32TPLaVEs81Twv24+CrrrRmx9kYQN/Y+LQ=;
        b=MxpMnT96jSFiG9brHzxW6fruCMIBPzsoTS3rbgr8NPx7w1+/eYnFE1qHgSvtxgHFVs
         fYYGDmhODtAoc0QCCk2pzE3Y/mwnxLZZXKBAqzhv4sluv2iyx/+nDDqzTp2EPZQX+n4P
         VbIyBjQIy47U1ZJLhD15dD2b5LStnM7lfcLns+ghEU4RE5/5TvnuBvknCGqhDO9XS3S5
         XPGdt6PXF7DHZapEGCl5w5STNaJ7VO6Uanf/iAe4OjZ72p7E5Z+hsUKJ/cjeMfpT3E7T
         CelarHDp+O+jINwtPKKO7V07T9OnyHZIu5ONE1iXdBSjxqlZhDYRV+m4b7BBfYka7dTq
         BZGQ==
X-Gm-Message-State: AO0yUKUK0517DdhIIwCrEJeCfoZhDEPCZOThVPCKrdtDCZuodnMvaGHj
        zt2PEb5gCCy4VkpnWb7h/aKWnRDQ5XeYx1xJjRU7FH5cOmdTuiNg7P0SPh8Pe7cQXb4voPqUa8y
        5X14vfR+ftSXKOSXoQVGJloPe5FaGLmtN
X-Received: by 2002:a05:6a00:1490:b0:592:e66f:6c8a with SMTP id v16-20020a056a00149000b00592e66f6c8amr1216399pfu.36.1675329439918;
        Thu, 02 Feb 2023 01:17:19 -0800 (PST)
X-Google-Smtp-Source: AK7set8HXWgrX7ktMHZfWQSLtwyZPf0l9/xbxS8B2lY1OAOLUC2DUpf5Kh4Qd5sI4XOhHQC8z4ifjmKdOqnl/bRplEI=
X-Received: by 2002:a05:6a00:1490:b0:592:e66f:6c8a with SMTP id
 v16-20020a056a00149000b00592e66f6c8amr1216388pfu.36.1675329439642; Thu, 02
 Feb 2023 01:17:19 -0800 (PST)
MIME-Version: 1.0
References: <20230131160506.47552-1-ihuguet@redhat.com> <20230201080849.10482-1-ihuguet@redhat.com>
 <20230201110541.1cf6ba7f@kernel.org> <CACT4oueX=MyKoUmzUs5Cdc0k5SuhavY=Toe_EGPgPOA8rVCmRw@mail.gmail.com>
 <Y9t1lRYtHQ+ZLuBq@unreal>
In-Reply-To: <Y9t1lRYtHQ+ZLuBq@unreal>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Thu, 2 Feb 2023 10:17:08 +0100
Message-ID: <CACT4oudF=goErh_DBP_u+xz+eWw7bm06ngEPPCAHTBWz4aDkzQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/4] sfc: support unicast PTP
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, richardcochran@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, Yalin Li <yalli@redhat.com>,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 2, 2023 at 9:38 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Thu, Feb 02, 2023 at 08:08:10AM +0100, =C3=8D=C3=B1igo Huguet wrote:
> > On Wed, Feb 1, 2023 at 8:05 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Wed,  1 Feb 2023 09:08:45 +0100 =C3=8D=C3=B1igo Huguet wrote:
> > > > v2: fixed missing IS_ERR
> > > >     added doc of missing fields in efx_ptp_rxfilter
> > >
> > > 1. don't repost within 24h, *especially* if you're reposting
> > > because of compilation problems
> > >
> > > https://www.kernel.org/doc/html/next/process/maintainer-netdev.html
> >
> > Sorry, I wasn't aware of this.
> >
> > > 2. please don't repost in a thread, it makes it harder for me
> > > to maintain a review queue
> >
> > What do you mean? I sent it with `git send-email --in-reply-to`, I
> > thought this was the canonical way to send a v2 and superseed the
> > previous version.
>
> It was never canonical way. I'm second to Jakub, it messes review and
> acceptance flow so badly that I prefer to do not take such patches due
> to possible confusion.

I was so sure about this that it has confused me a lot. But I've found
where my mistake came from: in the past I made a few contributions to
the Buildroot project, and there they explicitly request to do it
because they say that patchwork automatically marks the previous
version as superseded. But yes, of course you're right: in kernel's
documentation it explicitly says not to do it.

>
> >
> > > 3. drop the pointless inline in the source file in patch 4
> > >
> > > +static inline void efx_ptp_remove_one_filter(struct efx_nic *efx,
> > > +                                            struct efx_ptp_rxfilter =
*rxfilter)
> >
> > This is the second time I get pushback because of this. Could you
> > please explain the rationale of not allowing it?
> >
> > I understand that the compiler probably will do the right thing with
> > or without the `inline`, and more being in the same translation unit.
> > Actually, I checked the style guide [1] and I thought it was fine like
> > this: it says that `inline` should not be abused, but it's fine in
> > cases like this one. Quotes from the guide:
> >   "Generally, inline functions are preferable to macros resembling func=
tions"
> >   "A reasonable rule of thumb is to not put inline at functions that
> > have more than 3 lines of code in them"
> >
> > I have the feeling that if I had made it as a macro it had been
> > accepted, but inline not, despite the "prefer inline over macro".
> >
> > I don't mind changing it, but I'd like to understand it so I can
> > remember the next time. And if it's such a hard rule that it's
> > considered a "fail" in the patchwork checks, maybe it should be
> > documented somewhere.
>
> GCC will automatically inline your not-inline function anyway.
>
> Documentation/process/coding-style.rst
>    958 15) The inline disease
> ...
>    978 Often people argue that adding inline to functions that are static=
 and used
>    979 only once is always a win since there is no space tradeoff. While =
this is
>    980 technically correct, gcc is capable of inlining these automaticall=
y without
>    981 help, and the maintenance issue of removing the inline when a seco=
nd user
>    982 appears outweighs the potential value of the hint that tells gcc t=
o do
>    983 something it would have done anyway.

I also saw that, but this paragraph seems to talk about functions of
*any* size, for which many people think that it's good to add `inline`
if they're used *only once*. That's not this case, but instead this
case seems to fit well in the cases where the guide says that it's OK
to use them:
"Generally, inline functions are preferable to macros resembling functions"
"A reasonable rule of thumb is to not put inline at functions that
have more than 3 lines of code in them".

Just to be clear: there are a lot of discussions and opinions about
how to use inline, and some rules about its usage are needed (mainly
limiting it). What I mean is that we have some written rules, but if
there are additional rules that are being applied, maybe they should
be written too. That way we would avoid work in reviews and resends
(because I checked the coding-style regarding this topic before
sending the patch), and we the developers would understand better the
technical reasons behind it.

> > Thanks!
> >
> > [1] https://www.kernel.org/doc/html/latest/process/coding-style.html
> >
> >
> > --
> > =C3=8D=C3=B1igo Huguet
> >
>


--=20
=C3=8D=C3=B1igo Huguet

