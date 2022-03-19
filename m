Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 895744DE5F1
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 05:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242109AbiCSEbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 00:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242084AbiCSEbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 00:31:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33BAD1CE2
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 21:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6166760AD3
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 04:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B0B5C340EC;
        Sat, 19 Mar 2022 04:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647664213;
        bh=3EiGwIdMTup4l1o1YRS+f5S/7LmyapzcdcQeioIO6xU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xm8q5TzJOruAdclVzEDRVDzKUrE2xlKV/7pkrwZUlapEYv2ZgfeTfkE+NQDvK82zM
         f3KhUnnG7vPnaRE0azYKCUz7SvEwL9UBd3AtUguMsRJ39vhaqlyZZuLHQeCJCpJnF2
         2yxAXrCH98qcC4ZFuUuyCZ4g7KY6FAimXmTd8/jJyUDp3yQvVtdYwmfoZs0Tduaf9O
         Q7CWdR1TxQic84KjQLAUtNixXH1uc94MugRlAphpOxnl9kBy2RDiWJRXqwcvxl527f
         O2HoyOzEWbl+w6evqdxsnrXRYs/58o2Jgu/TaBuqKEjHJbZyVmeM+sBNkiesoVL/dZ
         LxM5isuPrAL+g==
Date:   Fri, 18 Mar 2022 21:30:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yinjun Zhang <yinjun.zhang@corigine.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: Re: [PATCH net-next 10/10] nfp: nfdk: implement xdp tx path for
 NFDK
Message-ID: <20220318213012.482a1edf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220319015546.GB18238@nj-rack01-04.nji.corigine.com>
References: <20220318101302.113419-1-simon.horman@corigine.com>
        <20220318101302.113419-11-simon.horman@corigine.com>
        <20220318105645.3ee1cb6c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220319015546.GB18238@nj-rack01-04.nji.corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 19 Mar 2022 09:55:46 +0800 Yinjun Zhang wrote:
> On Fri, Mar 18, 2022 at 10:56:45AM -0700, Jakub Kicinski wrote:
> > On Fri, 18 Mar 2022 11:13:02 +0100 Simon Horman wrote: =20
> > > From: Yinjun Zhang <yinjun.zhang@corigine.com>
> > >=20
> > > Due to the different definition of txbuf in NFDK comparing to NFD3,
> > > there're no pre-allocated txbufs for xdp use in NFDK's implementation,
> > > we just use the existed rxbuf and recycle it when xdp tx is completed.
> > >=20
> > > For each packet to transmit in xdp path, we cannot use more than
> > > `NFDK_TX_DESC_PER_SIMPLE_PKT` txbufs, one is to stash virtual address,
> > > and another is for dma address, so currently the amount of transmitted
> > > bytes is not accumulated. Also we borrow the last bit of virtual addr
> > > to indicate a new transmitted packet due to address's alignment
> > > attribution.
> > >=20
> > > Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
> > > Signed-off-by: Fei Qin <fei.qin@corigine.com>
> > > Signed-off-by: Simon Horman <simon.horman@corigine.com> =20
> >=20
> > Breaks 32 bit :( =20
>=20
> You mean 32-bit arch? I'd thought of that, but why needn't
> `NFCT_PTRMASK` take that into account?

Simpler than that, I just meant the build.
It's about casting between 64b types and pointers:

drivers/net/ethernet/netronome/nfp/nfdk/dp.c: In function =E2=80=98nfp_nfdk=
_xdp_complete=E2=80=99:
drivers/net/ethernet/netronome/nfp/nfdk/dp.c:827:38: warning: cast to point=
er from integer of different size [-Wint-to-pointer-cast]
  827 |                                      (void *)NFDK_TX_BUF_PTR(txbuf[=
0].raw),
      |                                      ^
drivers/net/ethernet/netronome/nfp/nfdk/dp.c: In function =E2=80=98nfp_nfdk=
_tx_xdp_buf=E2=80=99:
drivers/net/ethernet/netronome/nfp/nfdk/dp.c:909:24: warning: cast from poi=
nter to integer of different size [-Wpointer-to-int-cast]
  909 |         txbuf[0].raw =3D (u64)rxbuf->frag | NFDK_TX_BUF_INFO_SOP;
      |                        ^
