Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFB245F793B
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 15:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiJGNtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 09:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiJGNts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 09:49:48 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 811FE120A9
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 06:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=DpqbCXW0geEwvoWfMhwmzMB6/b9H6N5L/d/czEc01g8=;
        t=1665150586; x=1666360186; b=nbvVdyhipA2XSgqCM1Cqy3NOh+E3wK93k3kQHYuziwRZRQT
        yuwjHEGoJFg0udEg/8Oghawy2uDN2qHoyyntjeDH0JclAZkdlhH8ducLabI7VoV7yUeeov3+rwYQQ
        5Pat0bYBbKzaz90/oJaV8+WGtbmMwughKP/VvPhjbDdgKu9LZecVwxt9caCyYNQPoUIvVeqAYEZqk
        GGBShAFh29MEgjlNye6Lh2PY6nR+uGkSXdXh1qsD4syKJBExbIUxkHkesWsVAUkDebR9S4S4eFJnL
        c+w7qixitJYu+Mev5Uxv6Sh4RE15pretMaa4MdYnsIR21RQu6hecZ1VMxsEHjpSg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ognjT-000Osw-2d;
        Fri, 07 Oct 2022 15:49:43 +0200
Message-ID: <ff12253b6855305cc3fa518af30e8ac21019b684.camel@sipsolutions.net>
Subject: Re: [RFC PATCH net-next 1/3] netlink: add support for formatted
 extack messages
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Edward Cree <ecree.xilinx@gmail.com>, ecree@xilinx.com,
        netdev@vger.kernel.org, linux-net-drivers@amd.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        marcelo.leitner@gmail.com
Date:   Fri, 07 Oct 2022 15:49:42 +0200
In-Reply-To: <1aafd0ec-5e01-9b01-61a5-48f3945c3969@gmail.com>
References: <cover.1665147129.git.ecree.xilinx@gmail.com>
         <a01a9a1539c22800b2a5827cf234756f13fa6b97.1665147129.git.ecree.xilinx@gmail.com>
         <34a347be9efca63a76faf6edca6e313b257483b6.camel@sipsolutions.net>
         <1aafd0ec-5e01-9b01-61a5-48f3945c3969@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-10-07 at 14:46 +0100, Edward Cree wrote:
> On 07/10/2022 14:35, Johannes Berg wrote:
> >=20
> > > +#define NL_SET_ERR_MSG_FMT(extack, fmt, args...) do {		\
> > > +	struct netlink_ext_ack *__extack =3D (extack);		\
> > > +								\
> > > +	scnprintf(__extack->_msg_buf, NETLINK_MAX_FMTMSG_LEN,	\
> > > +		  (fmt), ##args);				\
> >=20
> > Maybe that should print some kind of warning if the string was longer
> > than the buffer? OTOH, I guess the user would notice anyway, and until
> > you run the code nobody can possibly notice ... too bad then?
> >=20
> > Maybe we could at least _statically_ make sure that the *format* string
> > (fmt) is shorter than say 60 chars or something to give some wiggle roo=
m
> > for the print expansion?
> >=20
> > 	/* allow 20 chars for format expansion */
> > 	BUILD_BUG_ON(strlen(fmt) > NETLINK_MAX_FMTMSG_LEN - 20);
> >=20
> > might even work? Just as a sanity check.
>=20
> Hmm, I don't think we want to prohibit the case of (say) a 78-char format
>  string with one %d that's always small-valued in practice.
> In fact if you have lots of % in the format string the output could be
>  significantly *shorter* than fmt.
> So while I do like the idea of a sanity check, I don't see how to do it
>  without imposing unnecessary limitations.
>=20

Yeah, I agree. We could runtime warn but that's also pretty useless.

I guess we just have to be careful - but I know from experience that
won't work ;-)

(and some things like %pM or even %p*H can expand a lot anyway)

Unless maybe we printed a warning together with the full string, so the
user could recover it? WARN_ON() isn't useful though, the string should
be enough to understand where it came from.

Anyway just thinking out loud :)

johannes
