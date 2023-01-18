Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8DC2671082
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 03:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbjARCDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 21:03:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjARCDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 21:03:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 146161ABEF
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 18:03:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87DB3615AA
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 02:03:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E8CC433D2;
        Wed, 18 Jan 2023 02:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674007433;
        bh=dP37bvcL+HlwdBG5/kr58iLnWW52IYlAxQ7NGZhGjcI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uAhgXF0DE9zXh+JYjGSxY11DvJulGReGXTKeHUJCDDuC/Ndb0FEDpvFKndOo9VHf8
         Btx9PALDyTiOjekwJXTC/FvaRPMviDz8SFvztPZHGiJmks4iqNPOxMsgLtmnpnkKPA
         +G1PUm3BqbUWeI+443LUVjjVPC6smcNQLHujEKzkE3j2lBjNm9nJfbYH+W1tYZHF/b
         3dP6sWxMTvOUPKAoYhsraZMBi7AkhsLLJr9v7eBGZvKimnDPE3261R+t4k7Jy6b3sG
         eCGy+RkYcdCUk0zBW2Tx7bTcxmPFSiBUfog282bd1H1XH9rufa6aA6HKAuTwPAXdGm
         UOUEgyOpOg+fw==
Date:   Tue, 17 Jan 2023 18:03:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org, Frantisek Krenzelok <fkrenzel@redhat.com>
Subject: Re: [PATCH net-next 0/5] tls: implement key updates for TLS1.3
Message-ID: <20230117180351.1cf46cb3@kernel.org>
In-Reply-To: <cover.1673952268.git.sd@queasysnail.net>
References: <cover.1673952268.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please CC all the maintainers.

On Tue, 17 Jan 2023 14:45:26 +0100 Sabrina Dubroca wrote:
> This adds support for receiving KeyUpdate messages (RFC 8446, 4.6.3
> [1]). A sender transmits a KeyUpdate message and then changes its TX
> key. The receiver should react by updating its RX key before
> processing the next message.
>=20
> This patchset implements key updates by:
>  1. pausing decryption when a KeyUpdate message is received, to avoid
>     attempting to use the old key to decrypt a record encrypted with
>     the new key
>  2. returning -EKEYEXPIRED to syscalls that cannot receive the
>     KeyUpdate message, until the rekey has been performed by userspace

Why? We return to user space after hitting a cmsg, don't we?
If the user space wants to keep reading with the old key - =F0=9F=A4=B7=EF=
=B8=8F

>  3. passing the KeyUpdate message to userspace as a control message
>  4. allowing updates of the crypto_info via the TLS_TX/TLS_RX
>     setsockopts
>=20
> This API has been tested with gnutls to make sure that it allows
> userspace libraries to implement key updates [2]. Thanks to Frantisek
> Krenzelok <fkrenzel@redhat.com> for providing the implementation in
> gnutls and testing the kernel patches.

Please explain why - the kernel TLS is not faster than user space,=20
the point of it is primarily to enable offload. And you don't add
offload support here.
=20
> Note: in a future series, I'll clean up tls_set_sw_offload and
> eliminate the per-cipher copy-paste using tls_cipher_size_desc.

Yeah, I think it's on Vadim's TODO list as well.
