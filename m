Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE3B26944C2
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 12:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbjBMLmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 06:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbjBMLmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 06:42:09 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85F5AD07;
        Mon, 13 Feb 2023 03:42:07 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1676288526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x4VPdoQ34H5+UJSjJ7zXGVQPDVqelS5TJcTA3oWud1g=;
        b=bFPX5m2oSyTtgkdr1q4f67FaMOn91lBmIrLpkP1SUUIwyym1qUy51o7fFgPI6iMC3anKUj
        I3NVfT2AZhnV6rsBlJ+kNa9VIHf6V6bYPhuPh1CAuqVYwzvH3bvO1LbX5OijLx20t6jMLO
        V8lFyFQGW56LguB4ocEhS895i7rCQm+x/UU8NyboXJ2NT4x+eG9xuFUHqyMEdqopZ+yxiR
        Es9aU8c5/U849ih5TIecUol4CLWCFQG25w0NN8R3fpUhqhe8jkBhU0dJ5uK22ffvqJQluo
        ZrBBM/PjGT1JtSm71wDrrc7qoDwJNlE/6Y5URKLar8md8IomV8we/c64K825fw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1676288526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x4VPdoQ34H5+UJSjJ7zXGVQPDVqelS5TJcTA3oWud1g=;
        b=cE6/nqlT3INVUQ91GMKBukG9pwKjLSXniWpLxr/qS/XyXmJ847vT+oJgR2X2rHzB3+FKwe
        BqgJmPyhkf9NxmDA==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        UNGLinuxDriver@microchip.com, Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Aaron Conole <aconole@redhat.com>
Subject: Re: [RFC PATCH net-next] selftests: forwarding: add a test for MAC
 Merge layer
In-Reply-To: <20230210221243.228932-1-vladimir.oltean@nxp.com>
References: <20230210221243.228932-1-vladimir.oltean@nxp.com>
Date:   Mon, 13 Feb 2023 12:42:04 +0100
Message-ID: <871qmtvlkj.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Sat Feb 11 2023, Vladimir Oltean wrote:
> The MAC Merge layer (IEEE 802.3-2018 clause 99) does all the heavy
> lifting for Frame Preemption (IEEE 802.1Q-2018 clause 6.7.2), a TSN
> feature for minimizing latency.
>
> Preemptible traffic is different on the wire from normal traffic in
> incompatible ways. If we send a preemptible packet and the link partner
> doesn't support preemption, it will drop it as an error frame and we
> will never know. The MAC Merge layer has a control plane of its own,
> which can be manipulated (using ethtool) in order to negotiate this
> capability with the link partner (through LLDP).
>
> Actually the TLV format for LLDP solves this problem only partly,
> because both partners only advertise:
> - if they support preemption (RX and TX)
> - if they have enabled preemption (TX)
> so we cannot tell the link partner what to do - we cannot force it to
> enable reception of our preemptible packets.
>
> That is fully solved by the verification feature, where the local device
> generates some small probe frames which look like preemptible frames
> with no useful content, and the link partner is obliged to respond to
> them if it supports the standard. If the verification times out, we know
> that preemption isn't active in our TX direction on the link.
>
> Having clarified the definition, this selftest exercises the manual
> (ethtool) configuration path of 2 link partners (with and without
> verification), and the LLDP code path, using the openlldp project.
>
> This is not really a "forwarding" selftest, but I put it near the other
> "ethtool" selftests.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

Looks good to me. Is there any way to test this? I see mm support
implemented for enetc and Felix. However, I only have access to Intel
i225 NIC(s) which support frame preemption.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmPqIgwTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgoDaEACyF2GCliovq6k4HZ49L5jNh9f8CahV
c/mC8Jhy0AqblYleGS96FxmkhyU/rd8tA+Hri+TaQVvKRzwXyvx3H7X49RnBAn93
uwtevLXPtjTodCIQONmXLXhkuOeMR/mzDzsD8q/QYSPv6g/JB4A/B0KQGkj5J4Py
DW617Keo4ta52YuEsuufx8AMkj7xTDpx8zhbA/YNxR44giMwaWl90NRYgrmjA/pW
djylBDcpkdMsl74qAI24/Gs/6SnUxxMpV9ZTt6F0Vyi7SZTQx3C5bo6SHkRKpszC
i6tdf/NvhjNhb+U1A3uUkCM+FNkLhZxTstNE/FJ1v78JnP2AOgrvNYeOmniGLDmI
n750R6WkyNs2nUZmhELQrgkO7rkPxhTfUU+w0fQwHSKdoE7CW9xTfwfoypkP0d0K
cLnBGBHNBwDXpwvmlLNssYlZnYd5a+HhGFanbwu2Ym1C9cRML3x7hhZbeMGGSjet
bglzJ0MGns8neBc0eHDU2LoZGyuL0PwdGUvQaasOsshXEkiwCBCMQhzLRsWqA+YD
0Vy3FgMWlS4/cnCeoW87GNGbtaT5HWIsZPtownulP+0sngek+ag9DP2R/+WL2WmJ
nyFyOkr8ldGKcRXrSOsoritTFPZKOYaABdggcePFzOgzvz0e6L46pZ7dKHAicuwo
pSa9SGspnWxwtw==
=vm5f
-----END PGP SIGNATURE-----
--=-=-=--
