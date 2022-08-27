Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EACF65A334E
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 03:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbiH0BGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 21:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbiH0BGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 21:06:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E9C7A74FE
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 18:06:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DCCA61BD2
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 01:06:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80369C433D6;
        Sat, 27 Aug 2022 01:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661562402;
        bh=A6WMCLvtYG4I6W0kBFnzIXcSzGSd5iQnmn6Bo02JRKA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WrcuI2KqJjMueBacfZ1tAtfuzJU/FZN5MY+Jyd3Cwp3xhqyi/AREcyxkLjwp+aL3E
         5kedYleaTlPZB1t29Gtp0KlyfxsfUWgVFDvcQt+kTPLVeMURLF+WRcbIoRZOirp3kt
         07u6owmdSaMpluD4lgqTnTGYfYkpcW7WymcL/RQ2D5/RqgAuQGNX9xXNa13mue5NbL
         J72P3tVVU4N55DfO2wdQKwzbubwjhigks+0o/4zXZK55qmE0yZYuRawxx5lHtqNZy/
         PHdkm7xuqjm/Gkij0Jstk+KmmKvMtGd+AjhneKFMXb9ahxuSamKBCKSWi02AsZmPJx
         LB9m8vAm44zNw==
Date:   Fri, 26 Aug 2022 18:06:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thorsten Glaser <t.glaser@tarent.de>
Cc:     netdev@vger.kernel.org
Subject: Re: inter-qdisc communication?
Message-ID: <20220826180641.1e856c1d@kernel.org>
In-Reply-To: <49bb3aa4-a6d0-7f38-19eb-37f270443e7e@tarent.de>
References: <5aea96db-9248-6cff-d985-d4cd91a429@tarent.de>
        <20220826170632.4c975f21@kernel.org>
        <49bb3aa4-a6d0-7f38-19eb-37f270443e7e@tarent.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 27 Aug 2022 02:45:02 +0200 (CEST) Thorsten Glaser wrote:
> > How do you add latency on ingress? =F0=9F=A4=94=20
> > The ingress qdisc is just a stub to hook classifiers/actions.  =20
>=20
> Oh, damn. Then, I guess, I=E2=80=99ll have to do that on egress on
> the other interface, which makes it at least symmetric for
> passing traffic but catch not the set of traffic it should.
> Especially not the traffic terminating locally. Meh.
>=20
> The question remains the same, just the use case magically
> mutated under me.
>=20
> (Maybe if there were documentation like an intro to qdisc
> writing like I asked for already, I=E2=80=99d have known that.)

These days the recommendation for adding workload specific sauce=20
at the qdisc layer is to use the fq qdisc (mq + fq if you have=20
a multi queue device) and add a BPF program on top (cls-bpf)
which sets transmission times for each packet.

Obviously you can still write a qdisc if you wish or your needs=20
are sufficiently hardcore.

On the docs, nothing official AFAIK, if it doesn't pop up in=20
the first two pages of Google results it probably doesn't exist :(
