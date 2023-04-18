Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 773586E5D68
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 11:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbjDRJb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 05:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjDRJb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 05:31:27 -0400
Received: from mta-64-226.siemens.flowmailer.net (mta-64-226.siemens.flowmailer.net [185.136.64.226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46BAA59DC
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 02:31:23 -0700 (PDT)
Received: by mta-64-226.siemens.flowmailer.net with ESMTPSA id 20230418093119bc01c4187ddbe3a376
        for <netdev@vger.kernel.org>;
        Tue, 18 Apr 2023 11:31:20 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; s=fm1;
 d=siemens.com; i=florian.bezdeka@siemens.com;
 h=Date:From:Subject:To:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Cc:References:In-Reply-To;
 bh=CqK3hsqP4ZsT3ZUY+isIcg9eKHACr0lAiNG1+JRla6g=;
 b=qgSvw768XrHXL9zjoF5Fi+WBoNdMdWHl324bLBiS9wq1u4tQkr2ulODt4ZPNSvEiHuxy2w
 RKE2yu8Sb8Bi5ojr66/Z5zlRmyQQ9lRmWdbz4qoWuBo9sjNznGinj7y4/74qtLGJqMnle6KC
 e1VTaI9CzcGE4fniV7kl20klcOhV8=;
Message-ID: <98a4831de6c2ae4a3eb8d29dcd114a6e96c34f94.camel@siemens.com>
Subject: Re: [PATCH net v3 1/1] igc: read before write to SRRCTL register
From:   Florian Bezdeka <florian.bezdeka@siemens.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Song Yoong Siang <yoong.siang.song@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Vedang Patel <vedang.patel@intel.com>,
        Jithu Joseph <jithu.joseph@intel.com>,
        Andre Guedes <andre.guedes@intel.com>,
        Stanislav Fomichev <sdf@google.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        David Laight <David.Laight@ACULAB.COM>
Cc:     brouer@redhat.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-hints@xdp-project.net,
        stable@vger.kernel.org
Date:   Tue, 18 Apr 2023 11:31:16 +0200
In-Reply-To: <e7b9cb2c-1c18-7354-8d33-a924b5ae1d5b@redhat.com>
References: <20230414154902.2950535-1-yoong.siang.song@intel.com>
         <934a4204-1920-f5e1-bcde-89429554d0d6@redhat.com>
         <e7b9cb2c-1c18-7354-8d33-a924b5ae1d5b@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Flowmailer-Platform: Siemens
Feedback-ID: 519:519-68982:519-21489:flowmailer
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2023-04-17 at 16:24 +0200, Jesper Dangaard Brouer wrote:
> On 14/04/2023 22.05, Jesper Dangaard Brouer wrote:
> > =20
> > On 14/04/2023 17.49, Song Yoong Siang wrote:
> > > igc_configure_rx_ring() function will be called as part of XDP progra=
m
> > > setup. If Rx hardware timestamp is enabled prio to XDP program setup,
> > > this timestamp enablement will be overwritten when buffer size is
> > > written into SRRCTL register.
> > >=20
> > > Thus, this commit read the register value before write to SRRCTL
> > > register. This commit is tested by using xdp_hw_metadata bpf selftest
> > > tool. The tool enables Rx hardware timestamp and then attach XDP prog=
ram
> > > to igc driver. It will display hardware timestamp of UDP packet with
> > > port number 9092. Below are detail of test steps and results.
> > >=20
> [...]
> > >=20
> > > Fixes: fc9df2a0b520 ("igc: Enable RX via AF_XDP zero-copy")
> > > Cc: <stable@vger.kernel.org> # 5.14+
> > > Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
> > > Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> > > Reviewed-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > > ---
> >=20
> > LGTM, thank for the adjustments :-)
> >=20
> > Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> >=20
>=20
> Tested-by: Jesper Dangaard Brouer <brouer@redhat.com>
>=20
> I can confirm that this patch fix the issue I experienced with igc.
>=20
> This patch clearly fixes a bug in igc when writing the SRRCTL register.
> (as bit 30 in register is "Timestamp Received Packet" which got cleared=
=20
> before).
>=20
> Florian might have found another bug around RX timestamps, but this
> patch should be safe and sane to apply as is.

After a closer look I'm quite sure now that this patch should fix my
issue as well. The register will be overwritten when setting up a
XSK_POOL as well:

igc_bpf
  igc_xdp_setup_pool
    igc_enable_rx_ring
      igc_configure_rx_ring
        wr32(IGC_SRRCTL)

I already removed the BPF loading (which is the use case that the patch
description mentions) from my setup to limit the search scope. If you
like you could extend the patch description, but I'm fine with it.

Thanks a lot for all the support / ideas! Highly appreciated!

Florian

>=20
> > > v2 -> v3: Refactor SRRCTL definitions to more human readable definiti=
ons
> > > v1 -> v2: Fix indention
> > > ---
> > > =C2=A0 drivers/net/ethernet/intel/igc/igc_base.h | 11 ++++++++---
> > > =C2=A0 drivers/net/ethernet/intel/igc/igc_main.c |=C2=A0 7 +++++--
> > > =C2=A0 2 files changed, 13 insertions(+), 5 deletions(-)
>=20

