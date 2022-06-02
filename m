Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474E453B143
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 03:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbiFBBNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 21:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233002AbiFBBNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 21:13:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E97528758E;
        Wed,  1 Jun 2022 18:13:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BB30B81C24;
        Thu,  2 Jun 2022 01:13:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7B5C385B8;
        Thu,  2 Jun 2022 01:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654132385;
        bh=G5grTPv26ogr7c4feDvMsv1Nx9g3SxcX632swBPgmFA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j/fzQF0LQ7AWaN1cBLOu8iEJLlHknjw3e1VyogoO6ulcd2KxYKLzvwhK7nMGziPDS
         o4u9SlZbh3rmKzQTK0liyOV1wbfcPg1r+vA315aOVWJsL/mG7sbXLWQMKAjlm4IbF9
         MD2oklRdGFyPVGmavEEXdCwxXmrruk5JjDxRgsI5+kGDD9AaRU2VTJeMSBSxrpLvux
         iW3E+ugLulv+bZJBs7gAqD0lahomkGP3p1q5QTq97CiHYpWei0LIiqab4uKzl3m/ek
         Gu8Ly1OZymHh8KOrrWL7Uqyy5j4sYUYhp1X4JnEauVzV5DMkze/KB/XSR8OhiNmP1Y
         OcEnaOKLsaLWQ==
Date:   Wed, 1 Jun 2022 18:13:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joanne Koong <joannekoong@fb.com>
Cc:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <edumazet@google.com>, <kafai@fb.com>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <testing@vger.kernel.org>,
        Joanne Koong <joannelkoong@gmail.com>,
        <syzbot+015d756bbd1f8b5c8f09@syzkaller.appspotmail.com>,
        Eric Dumazet <edumzet@google.com>
Subject: Re: [PATCH net-next v1 resend 1/2] net: Update bhash2 when socket's
 rcv saddr changes
Message-ID: <20220601181304.6459d831@kernel.org>
In-Reply-To: <20220601201434.1710931-2-joannekoong@fb.com>
References: <20220601201434.1710931-1-joannekoong@fb.com>
        <20220601201434.1710931-2-joannekoong@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Jun 2022 13:14:33 -0700 Joanne Koong wrote:
> From: Joanne Koong <joannelkoong@gmail.com>
>=20
> Commit d5a42de8bdbe ("net: Add a second bind table hashed by port and
> address") added a second bind table, bhash2, that hashes by a socket's po=
rt
> and rcv address.
>=20
> However, there are two cases where the socket's rcv saddr can change
> after it has been binded:
>=20
> 1) The case where there is a bind() call on "::" (IPADDR_ANY) and then
> a connect() call. The kernel will assign the socket an address when it
> handles the connect()
>=20
> 2) In inet_sk_reselect_saddr(), which is called when rerouting fails
> when rebuilding the sk header (invoked by inet_sk_rebuild_header)
>=20
> In these two cases, we need to update the bhash2 table by removing the
> entry for the old address, and adding a new entry reflecting the updated
> address.
>=20
> Reported-by: syzbot+015d756bbd1f8b5c8f09@syzkaller.appspotmail.com
> Fixes: d5a42de8bdbe ("net: Add a second bind table hashed by port and add=
ress")
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> Reviewed-by: Eric Dumazet <edumzet@google.com>

This one needs to be static:

net/ipv4/inet_hashtables.c:830:5: warning: no previous prototype for =E2=80=
=98__inet_bhash2_update_saddr=E2=80=99 [-Wmissing-prototypes]
  830 | int __inet_bhash2_update_saddr(struct sock *sk, struct inet_hashinf=
o *hinfo,
