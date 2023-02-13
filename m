Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA936695342
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 22:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjBMVky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 16:40:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjBMVkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 16:40:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F922BDD9
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 13:40:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3ED061303
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 21:40:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3497C4339E;
        Mon, 13 Feb 2023 21:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676324405;
        bh=KSgFVtOjOf4kDSpMzvVMHv1yD6fJY8z5YWHPZm247is=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j0HUZQSEvlr0ehMXVKt2TXN/jGfYGZnqZN0sw1qf0USDtwH4TNvZY89o7cNszCxRj
         DVZ+LO+fm9nvYtQVqrF8tpe6VIwPtcJr+I3mF/cSXSpzXQnKWgXvqpNlogayfn2jGh
         MmOWnUm2rbMhK+THu3dEk19QpxZ2cYM3n79NJ4ZrCMSpSVnw5BGxUr2lFzPPVgZ0h8
         aFxeOlvTiPjG8sF2WS/SC8svGMkxb1rfzFtKEiCrhu5IvOMLo6EYxH4EzPtpDZwEtg
         3WDIfsISga6zN5M7nVJhYsdXO9zMLJHRWUPk74oEu7G1a1gn+BGz27U5mCF/HBrNB2
         GzVZiJHc5YGmg==
Date:   Mon, 13 Feb 2023 13:40:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "hare@suse.com" <hare@suse.com>,
        David Howells <dhowells@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        "jmeneghi@redhat.com" <jmeneghi@redhat.com>
Subject: Re: [PATCH v3 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Message-ID: <20230213134004.228040e2@kernel.org>
In-Reply-To: <4FBAAB34-1FCA-4DB8-BA3E-7625E4F74973@oracle.com>
References: <167580444939.5328.5412964147692077675.stgit@91.116.238.104.host.secureserver.net>
        <167580607317.5328.2575913180270613320.stgit@91.116.238.104.host.secureserver.net>
        <20230208220025.0c3e6591@kernel.org>
        <5D62859B-76AD-431C-AC93-C42A32EC2B69@oracle.com>
        <20230209180727.0ec328dd@kernel.org>
        <EB241BE0-8829-4719-99EC-2C3E74384FA9@oracle.com>
        <20230210100915.3fde31dd@kernel.org>
        <1B1298B2-C884-48BA-A4E8-BBB95C42786B@oracle.com>
        <20230210134416.0391f272@kernel.org>
        <4FBAAB34-1FCA-4DB8-BA3E-7625E4F74973@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 11 Feb 2023 20:55:58 +0000 Chuck Lever III wrote:
> Based on this reply I was unsure whether you wanted an English
> spec (similar to an Internet Draft) or a machine-readable one.

I meant machine-readable.

> But now that I look at these, I think I get it: you'd like a
> YAML file that can be used with tools to either generate a
> parser or maybe do some correctness analysis.
> 
> I think others will benefit as more security protocols come
> to this party, so it's a good thing to do for extensibility.

Yup, it's great for parsers and we also plan to add syzbot metadata 
to it with semantics of the fields.

> I will look into this for v5 definitely and maybe v4. v4
> already has significant churn...
