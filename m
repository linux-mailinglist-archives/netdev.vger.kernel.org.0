Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E2E4D36F8
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236878AbiCIRRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 12:17:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237135AbiCIRRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 12:17:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70065CF3B5;
        Wed,  9 Mar 2022 09:15:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F15AEB82229;
        Wed,  9 Mar 2022 17:15:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC9FC340E8;
        Wed,  9 Mar 2022 17:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646846110;
        bh=SkM8iGSGYhgOrIRJdrVqhWJ2hKO7IhD4kGpAJ6LqKt4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SbUK4DFBP2PrFAFmiPEvsEutUFrVrh3/zaMf+HSp7Fuk+SmIYazUGgzuCP27Wtuxi
         KSblCR77Lva4Rk7SJiCI8G60pjpk/7MI+9+LbJGr8UAcZajU0DbEIylqV6qKWYEGYo
         4wrFhkSpB2Ojtdh2Ru54sJ2VbOj6F6Dcis8lJdZ5TPr3NVBJ71SK8Un2oncRWnh5nB
         nIe9lPYE/IcME30vI2xeWlvdBchUb7Ca0QK0pY4GE7qs1B1/W0nH0APSMLHQrMgi1Q
         OgHnqGW6R7Eba5iR9YGMCzueMG9TnDiFHgLmjJadIZm74x2fxUXhsBx0rDfcZMVcax
         KIgHL0fASyfcw==
Date:   Wed, 9 Mar 2022 09:15:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH net] xdp: xdp_mem_allocator can be NULL in
 trace_mem_connect().
Message-ID: <20220309091508.4e48511f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87sfrt7i1i.fsf@toke.dk>
References: <YiC0BwndXiwxGDNz@linutronix.de>
        <875yovdtm4.fsf@toke.dk>
        <YiDM0WRlWuM2jjNJ@linutronix.de>
        <87y21l7lmr.fsf@toke.dk>
        <YiZIEVTRMQVYe8DP@linutronix.de>
        <87sfrt7i1i.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 07 Mar 2022 19:07:37 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Sebastian Andrzej Siewior <bigeasy@linutronix.de> writes:
>=20
> > On 2022-03-07 17:50:04 [+0100], Toke H=C3=B8iland-J=C3=B8rgensen wrote:=
 =20
> >>=20
> >> Right, looking at the code again, the id is only assigned in the path
> >> that doesn't return NULL from __xdp_reg_mem_model().
> >>=20
> >> Given that the trace points were put in specifically to be able to pair
> >> connect/disconnect using the IDs, I don't think there's any use to
> >> creating the events if there's no ID, so I think we should fix it by
> >> skipping the trace event entirely if xdp_alloc is NULL. =20
> >
> > This sounds like a reasonable explanation. If nobody disagrees then I
> > post a new patch tomorrow and try to recycle some of what you wrote :) =
=20
>=20
> SGTM :)

Was the patch posted? This seems to be a 5.17 thing, so it'd be really
really good if the fix was in net by tomorrow morning! :S
