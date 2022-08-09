Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E140C58D268
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 05:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiHIDlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 23:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiHIDln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 23:41:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C3E1DA41;
        Mon,  8 Aug 2022 20:41:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46A6BB8113A;
        Tue,  9 Aug 2022 03:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568D2C433D7;
        Tue,  9 Aug 2022 03:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660016496;
        bh=TIZFdRQlgXbmimfCbQz8qcn4tib36jWhm+S9ipfzK9M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GZj5tje3MZvLt64+KkNV+4AICGsB6B+06qCIaU/zW7HEPcEmo9YK5PaJBwQ+4h+8O
         0F1qxJfY0kzH4aaBIbp5ZsvFizH24SAvWDr668gb9kfTPqaR1PFK6axZhOgtgo4pKp
         TRKp7CXHeQgFADnjtvmc7Jn0Wv6ZrE3U/JmXMytMPj80QGrRmqAYDhsGNaN+Bby9D7
         J1sW0iDizkaS3DpiGgjhjc861AuWAaPsK3zjN9hFjAhFBbfXLTNuWhX6SfvWtQKWds
         1zKuytelsklEafRawxkoMAWYiCFaM9d2gssXjU66dRvjm0YBcIbiiLDaJXE7t4QY1u
         +4qZq85Hgt8jg==
Date:   Mon, 8 Aug 2022 20:41:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     ecree@xilinx.com, netdev@vger.kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-net-drivers@amd.com,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Saeed Mahameed <saeed@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Shannon Nelson <snelson@pensando.io>,
        Simon Horman <simon.horman@corigine.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [RFC PATCH net-next] docs: net: add an explanation of VF (and
 other) Representors
Message-ID: <20220808204135.040a4516@kernel.org>
In-Reply-To: <71af8654-ca69-c492-7e12-ed7ff455a2f1@gmail.com>
References: <20220805165850.50160-1-ecree@xilinx.com>
        <20220805184359.5c55ca0d@kernel.org>
        <71af8654-ca69-c492-7e12-ed7ff455a2f1@gmail.com>
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

On Mon, 8 Aug 2022 21:44:45 +0100 Edward Cree wrote:
> >> +What functions should have a representor?
> >> +-----------------------------------------
> >> +
> >> +Essentially, for each virtual port on the device's internal switch, t=
here
> >> +should be a representor.
> >> +The only exceptions are the management PF (whose port is used for tra=
ffic to
> >> +and from all other representors)  =20
> >=20
> > AFAIK there's no "management PF" in the Linux model. =20
>=20
> Maybe a bad word choice.  I'm referring to whichever PF (which likely
>  also has an ordinary netdevice) has administrative rights over the NIC /
>  internal switch at a firmware level.  Other names I've seen tossed
>  around include "primary PF", "admin PF".

I believe someone (mellanox?) used the term eswitch manager.
I'd use "host PF", somehow that makes most sense to me.

> >> and perhaps the physical network port (for
> >> +which the management PF may act as a kind of port representor.  Devic=
es that
> >> +combine multiple physical ports and SR-IOV capability may need to hav=
e port
> >> +representors in addition to PF/VF representors). =20
> >=20
> > That doesn't generalize well. If we just say that all uplinks and PFs
> > should have a repr we don't have to make exceptions for all the cases
> > where that's the case. =20
>=20
> We could, but AFAIK that's not how existing drivers behave.  At least
>  when I experimented with a mlx NIC a couple of years ago I don't
>  recall it creating a repr for the primary PF or for the physical port,
>  only reprs for the VFs.

Mellanox is not the best example, I think they don't even support
uplink to uplink forwarding cleanly.

> >> + - Other PFs on the PCIe controller, and any VFs belonging to them. =
=20
> >=20
> > What is "the PCIe controller" here? I presume you've seen the
> > devlink-port doc. =20
>=20
> Yes, that's where I got this terminology from.
> "the" PCIe controller here is the one on which the mgmt PF lives.  For
>  instance you might have a NIC where you run OVS on a SoC inside the
>  chip, that has its own PCIe controller including a PF it uses to drive
>  the hardware v-switch (so it can offload OVS rules), in addition to
>  the PCIe controller that exposes PFs & VFs to the host you plug it
>  into through the physical PCIe socket / edge connector.
> In that case this bullet would refer to any additional PFs the SoC has
>  besides the management one...

IMO the model where there's a overall controller for the entire device
is also a mellanox limitation, due to lack of support for nested
switches.

Say I pay for a bare metal instance in my favorite public could.=20
Why would the forwarding between VFs I spawn be controlled by the cloud
provider and not me?!

But perhaps Netronome was the only vendor capable of nested switching.

> >> + - PFs and VFs on other PCIe controllers on the device (e.g. for any =
embedded
> >> +   System-on-Chip within the SmartNIC). =20
>=20
> ... and this bullet to the PFs the host sees.
>=20
> >> + - PFs and VFs with other personalities, including network block devi=
ces (such
> >> +   as a vDPA virtio-blk PF backed by remote/distributed storage). =20
> >=20
> > IDK how you can configure block forwarding (which is DMAs of command
> > + data blocks, not packets AFAIU) with the networking concepts..
> > I've not used the storage functions tho, so I could be wrong. =20
>=20
> Maybe I'm way off the beam here, but my understanding is that this
>  sort of thing involves a block interface between the host and the
>  NIC, but then something internal to the NIC converts those
>  operations into network operations (e.g. RDMA traffic or Ceph TCP
>  packets), which then go out on the network to access the actual
>  data.  In that case the back-end has to have network connectivity,
>  and the obvious=E2=84=A2 way to do that is give it a v-port on the v-swi=
tch
>  just like anyone else.

I see. I don't think this covers all implementations.=20

> >> +An example of a PCIe function that should *not* have a representor is=
, on an
> >> +FPGA-based NIC, a PF which is only used to deploy a new bitstream to =
the FPGA,
> >> +and which cannot create RX and TX queues. =20
> >=20
> > What's the thinking here? We're letting everyone add their own
> > exceptions to the doc? =20
>=20
> It was just the only example I could come up with of the more general
>  rule: if it doesn't have the ability to send and receive packets over
>  the network (directly or indirectly), then it won't have a virtual
>  port on the virtual switch, and so it doesn't make sense for it to
>  have a representor.
> No way to TX =3D nothing will ever be RXed on the rep; no way to RX =3D no
>  way to deliver anything you TX from the rep.  And nothing for TC
>  offload to act upon either for the same reasons.

No need to mention that, I'd think. Seems obvious.

> >> For example, ``ndo_start_xmit()`` might send the
> >> +packet, specially marked for delivery to the representee, through a T=
X queue
> >> +attached to the management PF. =20
> >=20
> > IDK how common that is, RDMA NICs will likely do the "dedicated queue
> > per repr" thing since they pretend to have infinite queues. =20
>=20
> Right.  But the queue is still created by the driver bound to the mgmt
>  PF, and using that PF for whatever BAR accesses it uses to create and
>  administer the queue, no?
> That's the important bit, and the details of how the NIC knows which
>  representee to deliver it to (dedicated queue, special TX descriptor,
>  whatever) are vendor-specific magic.  Better ways of phrasing that
>  are welcome :)

"TX queue attached to" made me think of a netdev Tx queue with a qdisc
rather than just a HW queue. No better ideas tho.

> >> +How are representors identified?
> >> +--------------------------------
> >> +
> >> +The representor netdevice should *not* directly refer to a PCIe devic=
e (e.g.
> >> +through ``net_dev->dev.parent`` / ``SET_NETDEV_DEV()``), either of the
> >> +representee or of the management PF. =20
> >=20
> > Do we know how many existing ones do?  =20
>=20
> Idk.  From a quick look on lxr, mlx5 and ice do; as far as I can tell
>  nfp/flower does for "phy_reprs" but not "vnic_reprs".  nfp/abm does.
>=20
> My reasoning for this "should not" here is that a repr is a pure
>  software device; compare e.g. if you build a vlan netdev on top of
>  eth0 it doesn't inherit eth0's device.
> Also, at least in theory this should avoid the problem with OpenStack
>  picking the wrong netdevice that you mentioned in [2], as this is
>  what controls the 'device' symlink in sysfs.

It makes sense. The thought I had was "what if a user reads this and
assumes it's never the case". But to be fair "should not" !=3D "must not"
so we're probably good with your wording as is.

> >> + - ``pf<N>``, PCIe physical function index *N*.
> >> + - ``vf<N>``, PCIe virtual function index *N*.
> >> + - ``sf<N>``, Subfunction index *N*. =20
> >=20
> > Yeah, nah... implement devlink port, please. This is done by the core,
> > you shouldn't have to document this. =20
>=20
> Oh huh, I didn't know about __devlink_port_phys_port_name_get().
> Last time I looked, the drivers all had their own
>  .ndo_get_phys_port_name implementations (which is why I did one for
>  sfc), and any similarity between their string formats was purely an
>  (undocumented) convention.  TIL!
> (And it looks like the core uses `c<N>` for my `if<N>` that you were
>  so horrified by.  Devlink-port documentation doesn't make it super
>  clear whether controller 0 is "the controller that's in charge" or
>  "the controller from which we're viewing things", though I think in
>  practice it comes to the same thing.)

I think we had a bit. Perhaps @external? The controller which doesn't
have @external =3D=3D true should be the local one IIRC. And by extension
presumably in charge.
