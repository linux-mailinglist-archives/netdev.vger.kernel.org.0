Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73C6967CC5D
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 14:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236936AbjAZNij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 08:38:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236904AbjAZNih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 08:38:37 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B284442E4
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 05:38:36 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1674740314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wqbZYDsLnTQX59ii+GcgrE3IHMjcdxvzvw3AZNSiyjs=;
        b=zU/ZI3yNlcb8INfewTOq/sPPYkMN7v9KhE9LHINsmg/HVs0JneBTnfrfThP00ZfnkhyrWB
        arak8N9jIPdwiXp1LWNvnMqUfMSjPsH1a4JY+7Sr0sJqM6og2dimKOnUWT78QQyhrzrFis
        g6uRCy1onc505tpwgK4MEbNFwvF2DTaaw1Nlj+2cYyupS2ccWO+aHQgVKxNXWGa21VDAo0
        9Xu67XiCcmhscDNEAwG6SJQQ9Zmx/ocRyofJMYkjbsBGn9wvEDemhDE4cwWv03ezYvLgGR
        EOMXUk/5BaLCVkgfnf1GsG03b70jOCZT3Ix617PSmh1493SyFn2xrFd8/XsuVA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1674740314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wqbZYDsLnTQX59ii+GcgrE3IHMjcdxvzvw3AZNSiyjs=;
        b=dpdU83WaWnv3gp6BAdtjO05ndKOo9FZUzzO7LR/9yeaP9P9yJRmmDrPp3CNUNeynk9bSYL
        5guxgHCgOS1t8aAQ==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Roger Quadros <rogerq@kernel.org>
Subject: Re: [PATCH v2 net-next 15/15] net/sched: taprio: only calculate
 gate mask per TXQ for igc, stmmac and tsnep
In-Reply-To: <20230126125308.1199404-16-vladimir.oltean@nxp.com>
References: <20230126125308.1199404-1-vladimir.oltean@nxp.com>
 <20230126125308.1199404-16-vladimir.oltean@nxp.com>
Date:   Thu, 26 Jan 2023 14:38:31 +0100
Message-ID: <87v8ktza94.fsf@kurt>
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

On Thu Jan 26 2023, Vladimir Oltean wrote:
> There are 2 classes of in-tree drivers currently:
>
> - those who act upon struct tc_taprio_sched_entry :: gate_mask as if it
>   holds a bit mask of TXQs
>
> - those who act upon the gate_mask as if it holds a bit mask of TCs
>
> When it comes to the standard, IEEE 802.1Q-2018 does say this in the
> second paragraph of section 8.6.8.4 Enhancements for scheduled traffic:
>
> | A gate control list associated with each Port contains an ordered list
> | of gate operations. Each gate operation changes the transmission gate
> | state for the gate associated with each of the Port's traffic class
> | queues and allows associated control operations to be scheduled.
>
> In typically obtuse language, it refers to a "traffic class queue"
> rather than a "traffic class" or a "queue". But careful reading of
> 802.1Q clarifies that "traffic class" and "queue" are in fact
> synonymous (see 8.6.6 Queuing frames):
>
> | A queue in this context is not necessarily a single FIFO data structure.
> | A queue is a record of all frames of a given traffic class awaiting
> | transmission on a given Bridge Port. The structure of this record is not
> | specified.
>
> i.o.w. their definition of "queue" isn't the Linux TX queue.
>
> The gate_mask really is input into taprio via its UAPI as a mask of
> traffic classes, but taprio_sched_to_offload() converts it into a TXQ
> mask.
>
> The breakdown of drivers which handle TC_SETUP_QDISC_TAPRIO is:
>
> - hellcreek, felix, sja1105: these are DSA switches, it's not even very
>   clear what TXQs correspond to, other than purely software constructs.
>   For felix and sja1105, I can confirm that only the mqprio
>   configuration with 8 TCs and 1 TXQ per TC makes sense. So it's fine to
>   convert these to a gate mask per TC.

Same for hellcreek. It has 8 TCs and the 1:1 mapping is used. So,

Acked-by: Kurt Kanzenbach <kurt@linutronix.de> # hellcreek

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmPSglcTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgjpTD/482AFY3PdxYRml4mWNHMFF3RjcurMU
3EETrEUiys0fA3UBG2nbb2qZkN/BfIrOez23bL7MR8lz2EkGWnhNKOzXK+fSvq79
qPkuDxngPFaExYAh3JIBkOGhLqt/fYVvGnpwSZfMs3iL6dTykX6RySnEnDrDx7NC
6S/hseWQQ3jLpgUFupmkKErAKpKSWP/ft0WhbpqBcW/q8Hxin4/eQzStkrMAQfvi
gCVsX6mW+NPidgAhDHGZ6Lg5LRlYlH2r/Bc6IF6/RL0CmYudtVHYpPu6I8ygYRy/
jJI27k334luPZc4sfK/NMWEuo0QEfc9R0myy57Fp1SSt3Q81OLaBq+Crr9ksqA2Z
iUiwIUpMICFk0dG46I2UlFieAKENln3Fzu1KVyVy419Zv/e24CcIWVvupam+B71+
CcpjNIv5TtWjT8uS2n9tO07epFxDWNlYGx2cMxr0dlFE9zwPr7Q1DgD1cD1QDeR7
kwoFJgEhgF3qgOSAhf+etGYE1+nyLchItfW6yiXzemZkvL5Enq+wcNunuuC8M6pH
10jhyQrGZWf3krrmJbtkwOHbSVq7avQXtfPoOYHfDZ4LDcd4CFU8jhIMrlPhaZ04
iU5kUG61mp9exxYh369RxMCxmqyJ1xyvW/g7/+YGAQqkFjns7mVpF/kGoEOKS2+F
g846JzdqOsb19A==
=ABTh
-----END PGP SIGNATURE-----
--=-=-=--
