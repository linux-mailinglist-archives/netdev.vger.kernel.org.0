Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 255896E8ADD
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 09:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233941AbjDTHEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 03:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233928AbjDTHEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 03:04:39 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7931F4C01
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 00:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=auD7QkRQ14Hr/6j8BJu0txfYfBdk33Ka1rme/uVV0Ic=;
        t=1681974277; x=1683183877; b=ObJpydsyHSaf6ZRhYEEghm1CtsdvV6LqnQ27HiY02wQTZjF
        4wUkhtKiwJxnCVyA6GDX0zuqg2qfqYNM9mnqNejQu0FBc9I9/n/OIq2aO4rD42TS8xlEkn9ndVBAm
        ptOjyztG/6GB1sMjTARR65FmerwDR1eI8bXeCHtMCDPzc8AFgX1KXfvakGz9jvJR3/hRTAHb91N0M
        /s0vCF2B9OL7y7A6whclIsd52VUjC/Il5gzXptD8lo9A0G6AEzsYVSLefv7liHy8b+A8VLB4ZzkmW
        rbGBcv8A9nYha3FMjN0T/Xav4R/TbSrNRWKgkpLz0WvK/Sc+99lohzwpX4JZRUwg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ppOLE-003Mhk-02;
        Thu, 20 Apr 2023 09:04:28 +0200
Message-ID: <3bbd72dff85f3b3b081b1275d50c07dc4fbf62c8.camel@sipsolutions.net>
Subject: Re: [PATCH v1 net] netlink: Use copy_to_user() for optval in
 netlink_getsockopt().
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kuniyuki Iwashima <kuniyu@amazon.com>, netdev@vger.kernel.org
Date:   Thu, 20 Apr 2023 09:04:26 +0200
In-Reply-To: <20230419160908.5469e9bf@kernel.org>
References: <20230419004246.25770-1-kuniyu@amazon.com>
         <d098026456c8393463e6cf33195edc19369c220b.camel@sipsolutions.net>
         <20230419160908.5469e9bf@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-04-19 at 16:09 -0700, Jakub Kicinski wrote:
> On Wed, 19 Apr 2023 09:17:37 +0200 Johannes Berg wrote:
> > > @@ -1754,39 +1754,17 @@ static int netlink_getsockopt(struct socket *=
sock, int level, int optname,
> > >=20
> > >         switch (optname) {
> > >         case NETLINK_PKTINFO:
> > > -               if (len < sizeof(int))
> > > -                       return -EINVAL;
> > > -               len =3D sizeof(int); =20
> >=20
> > On the other hand, this is actually accepting say a u64 now, and then
> > sets only 4 bytes of it, though at least it also sets the size to what
> > it wrote out.
> >=20
> > So I guess here we can argue either
> >  1) keep writing len to 4 and set 4 bytes of the output
> >  2) keep the length as is and set all bytes of the output
> >=20
> > but (2) gets confusing if you say used 6 bytes buffer as input? I mean,
> > yeah, I'd really hope nobody does that.
> >=20
> > If Jakub is feeling adventurous maybe we should attempt to see if we
> > break anything by accepting only =3D=3D sizeof(int) rather than >=3D ..=
. :-)
>=20
> Can't think of a strong reason either way, so I'd keep the check=20
> and len setting as is.

Yeah, fair. The only reason really would be to make it very clear that
using something bigger than an int isn't going to work right.

johannes

