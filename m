Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43EE0633837
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 10:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbiKVJUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 04:20:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbiKVJUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 04:20:53 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85BFA2494F
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 01:20:52 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669108851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a3sQ0dHSYoC9wkBZAsmhwQnIAnFR2p9YNDWLxW/kDmg=;
        b=tjIo0Ph/nOAf7lUjyiOG49u84oTy22oxxhmnnT/j6GqBDpt9psfRMxoYe5BuaZ+xhY/x9T
        57okk7jeN62Xo6gNXGyN9wqL19i4zxk5c9kebqzdC1fGHzcIrdKE0BjZO3q/uiuaREmGzb
        Hx3IdmR2lOosnumt8C0xF2ml42ns6PvvGxEEYi1aTBDL7G/xQpG+L1E3svY4Z5Hz42EEH3
        2JCe0vPbnhr0kLM1QQPk2sKzZdSkaWsZbajOQvhG0q/K8uMx2jstPlZNg8z02kJN0dqzI8
        N4QDU1O9+R7BkYUojYmCiX2ilSRwPCEI/cphT3tr8luu9li+y+GR10if5T0BUQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669108851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a3sQ0dHSYoC9wkBZAsmhwQnIAnFR2p9YNDWLxW/kDmg=;
        b=PvSiDk9xccWTq1Gp4wymcpK541W/TIYOFgI0puw2lRAfSKMF3ZfQ1tIlXqm9yHQrBcGR98
        TRNYqlFBBJ2QKVAg==
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH v2 net 7/7] hsr: Use a single struct for self_node.
In-Reply-To: <20221121174605.2456845-8-bigeasy@linutronix.de>
References: <20221121174605.2456845-1-bigeasy@linutronix.de>
 <20221121174605.2456845-8-bigeasy@linutronix.de>
Date:   Tue, 22 Nov 2022 10:20:49 +0100
Message-ID: <87sfib9wge.fsf@kurt>
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

On Mon Nov 21 2022, Sebastian Andrzej Siewior wrote:
> self_node_db is a list_head with one entry of struct hsr_node. The
> purpose is to hold the two MAC addresses of the node itself.
> It is convenient to recycle the structure. However having a list_head
> and fetching always the first entry is not really optimal.
>
> Created a new data strucure contaning the two MAC addresses named
> hsr_self_node. Access that structured like an RCU protected pointer so
                             ^ structure

> it can be replaced on the fly withou blocking the reader.
                               ^ without

>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Lacks a Fixes tag. Looks rather like an optimization than a bugfix? So,
maybe this one should go to net-next instead.

[snip]

> +struct hsr_self_node {
> +	unsigned char	macaddress_A[6];
                                    ^ ETH_ALEN

> +	unsigned char	macaddress_B[6];
                                    ^ ETH_ALEN
> +	struct rcu_head	rcu_head;
> +};
> +

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmN8lHETHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgjSrD/9oMTFrdV9rhVlqozsP6WRmdAVvaubV
okmek1J2pzA5/uFDxKeZjzQX79ieqctwV4xZTBzzjNIKwsurRhGSUc5g5MnJ0cY1
sY0Z8s6Mg28u/fOvz7ZUylB/oUH+zCR6jX+5rTAxcXNFgOTLuOmXUbPx3sR4JeQ0
JnXArHjZIwMtm7JxF7oLNZSLlBPEC4RzvhdRn41qd7/xPE6xMy545MEXaDCWyXcJ
bkdqbrNa7WoUicmQXPAZqCbznsh7WzVP6LuB3XccO3e4mSKs2HAY3sISGskNarNE
R2msnptQEAkegRQnJPeir118TyZZujs7Y/oCIihkSbCsHZl0dYH7k0eNZPO1u9di
kbUk5UUbZvozjQKC+zH2IYuNU8A28A6257EogRd1kTYO47TEC0KYt/4EVZiECZoc
D6/oc2as+e91sq8DhnGsCjJAAEpCmc6WHl254ZqVRQB5WVuchV4m56ajCNnMbQM/
EIiSNlJhoA91yfahlNaE/+tXjc0C55tYu69VJXjOpLvE6rXFwtxBqh3IWg6OlM2o
KJTV/ajlkYQbvaS2Ph+qudQD2KuzB1QuqNKTLe+2hqPJsei4NSDdSEKEChjtWr9x
UnUSKplylCarMDKpnEAYB6T/It5B3ZI6VfcIEbogzmlshaoBfWooQXjuZwBC/2Bf
J7bPFle6NhFqKw==
=Vbfi
-----END PGP SIGNATURE-----
--=-=-=--
