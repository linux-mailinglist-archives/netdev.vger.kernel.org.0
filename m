Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03CB76EC6B1
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 09:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbjDXHDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 03:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbjDXHCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 03:02:53 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0FA30E2
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 00:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=hf6T9j0i6OkNVduK2bx9nwgoDXdlGLl9HOcZShzy0Z4=;
        t=1682319768; x=1683529368; b=qw3HxW0QPZJL83PQDzBCpzMjdPbWm4SGdMfKd6xChDiaKFI
        Nc/Yzrje7IHT8D/LIAWy3om/SS9aEqF/BHSLkVPEnVsRmBwlw9b3oIcXjA4H4tA64wypzFeVbasK9
        6fkm98AKaU21aQ61UdlqJLHEl7l4oTYSpbhB4zcxLUr24A8g9y0ogm+aiQ1kj5PZa+QEJO0V/Ezaa
        1oOfX0I/SBBtSBNkSr7zoQ8BvLaZA8UDQoHu5TMf9JD/1pSk+F/NvpTXF5Y7gS0cI0Ee+Hsu9Vmu+
        U71nAxjnTXohzVHyBNXUAt0pufa+kgLowvUYth5sSN++BSTPVJyjj+aWkLxJ3kYQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pqqDc-0078Lv-1I;
        Mon, 24 Apr 2023 09:02:36 +0200
Message-ID: <f13c5bea08f87289446b48b3c0a095a5c25b20bf.camel@sipsolutions.net>
Subject: Re: [PATCH v3 net] netlink: Use copy_to_user() for optval in
 netlink_getsockopt().
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Patrick McHardy <kaber@trash.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Christophe Ricard <christophe-h.ricard@st.com>,
        David Ahern <dsahern@gmail.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Brad Spencer <bspencer@blackberry.com>
Date:   Mon, 24 Apr 2023 09:02:35 +0200
In-Reply-To: <20230421185255.94606-1-kuniyu@amazon.com>
References: <20230421185255.94606-1-kuniyu@amazon.com>
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

On Fri, 2023-04-21 at 18:52 +0000, Kuniyuki Iwashima wrote:
> Brad Spencer provided a detailed report [0] that when calling getsockopt(=
)
> for AF_NETLINK, some SOL_NETLINK options set only 1 byte even though such
> options require at least sizeof(int) as length.
>=20
> The options return a flag value that fits into 1 byte, but such behaviour
> confuses users who do not initialise the variable before calling
> getsockopt() and do not strictly check the returned value as char.
>=20
> Currently, netlink_getsockopt() uses put_user() to copy data to optlen an=
d
> optval, but put_user() casts the data based on the pointer, char *optval.
> As a result, only 1 byte is set to optval.
>=20
> To avoid this behaviour, we need to use copy_to_user() or cast optval for
> put_user().
>=20
> Note that this changes the behaviour on big-endian systems, but we docume=
nt
> that the size of optval is int in the man page.
>=20
>   $ man 7 netlink
>   ...
>   Socket options
>        To set or get a netlink socket option, call getsockopt(2) to read
>        or setsockopt(2) to write the option with the option level argumen=
t
>        set to SOL_NETLINK.  Unless otherwise noted, optval is a pointer t=
o
>        an int.
>=20
> Fixes: 9a4595bc7e67 ("[NETLINK]: Add set/getsockopt options to support mo=
re than 32 groups")
> Fixes: be0c22a46cfb ("netlink: add NETLINK_BROADCAST_ERROR socket option"=
)
> Fixes: 38938bfe3489 ("netlink: add NETLINK_NO_ENOBUFS socket flag")
> Fixes: 0a6a3a23ea6e ("netlink: add NETLINK_CAP_ACK socket option")
> Fixes: 2d4bc93368f5 ("netlink: extended ACK reporting")
> Fixes: 89d35528d17d ("netlink: Add new socket option to enable strict che=
cking on dumps")
> Reported-by: Brad Spencer <bspencer@blackberry.com>
> Link: https://lore.kernel.org/netdev/ZD7VkNWFfp22kTDt@datsun.rim.net/
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>


Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

Thanks!

johannes
