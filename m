Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17B7E6E46BB
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 13:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbjDQLpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 07:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbjDQLp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 07:45:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3106A7E;
        Mon, 17 Apr 2023 04:44:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89FCA61B5C;
        Mon, 17 Apr 2023 11:44:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34736C433EF;
        Mon, 17 Apr 2023 11:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681731870;
        bh=uiMLMPFMHARzb3ZZXcrGObdxPsgGuiiLacQHilUsWmc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mLT/M/SXHYooBU73zcdfRnycNMAnAWcN2b2TPQbKjvEMiY59qjR9E/4XdVNAt+2qi
         3O7pG3qnjRZk58PmulUm8JZbZ+5QCv+Betz9M5Qvwo7hpW+waFmk5jk/0BxArEc3bg
         j27egPNsxm+WaCJrD1iV1d2TVsuAVJjl0ckr5oySpAAFVvcENYimkkhRsSI2iXLOeo
         XeBbb2QZ2b6Dl7CXTd1q0retKTODmXuMVfz+5CsHg6ujKRV0YkzsTC4FrWopaC1k+f
         jHlgZ5MqGgLP1lwYLKIcJYvvAVfyrxw6p2c/s9ONbqgLJ7HFBCVS8bmqZ0smXD7kXI
         RjgPah36DP8pw==
Date:   Mon, 17 Apr 2023 14:44:25 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>, x86@kernel.org,
        Wangyang Guo <wangyang.guo@intel.com>,
        Arjan van De Ven <arjan@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Subject: Re: [patch V3 0/4] net, refcount: Address dst_entry reference count
 scalability issues
Message-ID: <20230417114425.GA434718@unreal>
References: <20230323102649.764958589@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230323102649.764958589@linutronix.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 09:55:27PM +0100, Thomas Gleixner wrote:
> Hi!
>=20
> This is version 3 of this series. Version 2 can be found here:
>=20
>      https://lore.kernel.org/lkml/20230307125358.772287565@linutronix.de

Hi,

I want to raise your attention to this bug report from Intel.
https://lore.kernel.org/all/202304162125.18b7bcdd-oliver.sang@intel.com/

We (Nvidia) are experiencing similar failures in our regressions too.
Revert of last two patches [1] from this series removed the panics, but
didn't add confidence due to another (???) netdev failure:

[ +10.080020] unregister_netdevice: waiting for eth3 to become free. Usage =
count =3D 2

Thanks=20

[1]
bc9d3a9f2afc net: dst: Switch to rcuref_t reference counting
d288a162dd1c net: dst: Prevent false sharing vs. dst_entry:: __refcnt
