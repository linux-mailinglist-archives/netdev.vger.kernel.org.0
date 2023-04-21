Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 866206EA566
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 09:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbjDUH5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 03:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbjDUH45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 03:56:57 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C9293CF
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 00:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=6hvtgqxg4108qb4Zoc2XugS31jCXQcPTvMTng0Ny80M=;
        t=1682063814; x=1683273414; b=rkVnO3NkvXMh0FkGfP5wNDBafwsGDBMDKbUXeY4bZnBO/tH
        +axCkUsUePEaust3+3UwuEWdxTQGdij7wgqJPcxfIQ8pHQOAG9naGAumVyUWs/Ca5Zyntat13GLqf
        A4sQPZdTMEE7J81Dgy/ZBBnqKRld+NJQDaBIxTsOqk2YLernfw5tp8HA9QRkVbtCxjz2zCUpO5z5q
        ZEJJwL1s14sj983bPfT7F3fNPjogPXdrNqk+Zn+uTlZUlsZZwrpzbex7lvNfetUZqwvghzxJERbdM
        TS1Cf6bXg//gR5rMT24UJDSpkSkxER3l7gEnT/orRnZtOnuG6KigOcpuvXdljrsQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ppldG-004LMK-2Y;
        Fri, 21 Apr 2023 09:56:39 +0200
Message-ID: <4624a731a9a222bc116364d26cfdfd8067a3acfc.camel@sipsolutions.net>
Subject: Re: [PATCH v2 net] netlink: Use copy_to_user() for optval in
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
Date:   Fri, 21 Apr 2023 09:56:37 +0200
In-Reply-To: <20230420233351.77166-1-kuniyu@amazon.com>
References: <20230420233351.77166-1-kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-04-20 at 23:33 +0000, Kuniyuki Iwashima wrote:
> Brad Spencer provided a detailed report [0] that when calling getsockopt(=
)
> for AF_NETLINK, some SOL_NETLINK options set only 1 byte even though such
> options require more than int as length.

Nit: not "more than" but "at least" (and sizeof(int), I guess).

> The options return a flag value that fits into 1 byte, but such behaviour
> confuses users who do not initialise the variable before calling
> getsockopt() and do not strictly check the returned value as char.
>=20
> Currently, netlink_getsockopt() uses put_user() to copy data to optlen an=
d
> optval, but put_user() casts the data based on the pointer, char *optval.
> As a result, only 1 byte is set to optval.

Maybe as a future thing, we should make the getsockopt method prototype
have void here, so this kind of thing becomes a compilation error? That
affects a fair number I guess, though I can't think of any socket
options that really _should_ be just a char, so if it fails anywhere
that might uncover additional bugs (and potentially avoid future ones)?


johannes
