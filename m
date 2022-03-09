Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7800F4D256C
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 02:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbiCIBJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 20:09:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbiCIBJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 20:09:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7950614CC8E;
        Tue,  8 Mar 2022 16:51:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 133BB6131F;
        Wed,  9 Mar 2022 00:28:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F04C340EB;
        Wed,  9 Mar 2022 00:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646785683;
        bh=7ts5yK9dKmm0RkdfCHFJSloLAhqqU7Px2Yg0dWLSehQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ATv15O2qyedqsb3YuOb+pBi9rlcdHwsQyp5MYExREL36OJLhpjs0c/jingYsBhxOp
         LJE+8VdSlqsVvLTNVhILrTD80c0ttZ+b5qUAAQkqoYrO5TQ7achOli2LFW0qh2BfQo
         zjfSikWfy042N+t+s2LLzcWQ3wkENXY2gRPGmnj6yLTueKYz3ahBZxAWgfdLsvIXad
         t7zUVoK5dFhH05qJeyOmUQbXdeJBedmg3ZIubEWMYc9fyuv0x9ha4JySgJglhX7ahj
         W4VZeGq92x4nI014iRF6vWc1Aif/RNO4npy0YZYQpy1u0U8lde62YU46dzALdMvc6l
         MqQqIJ43/ygvw==
Date:   Tue, 8 Mar 2022 16:28:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Jeffrey Ji <jeffreyjilinux@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Brian Vazquez <brianvv@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Antoine Tenart <atenart@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        jeffreyji <jeffreyji@google.com>
Subject: Re: [PATCH v3 net-next] net-core: add rx_otherhost_dropped counter
Message-ID: <20220308162802.0ecec1bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iKvP-8VpOrf_ppVVgsd4kQtAEFWkBVxKW4BP+rtu_Egrw@mail.gmail.com>
References: <20220308212531.752215-1-jeffreyjilinux@gmail.com>
        <d1b25466-6f83-591e-39a6-8fdbd56846fb@kernel.org>
        <CANn89iKvP-8VpOrf_ppVVgsd4kQtAEFWkBVxKW4BP+rtu_Egrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Mar 2022 15:18:25 -0800 Eric Dumazet wrote:
> > that's an expensive packet counter for a common path (e.g., hosting
> > environments).  
> 
> This was the reason for the initial patch, using SNMP stat, being per cpu.
> 
> Adding per-device per-cpu data for this counter will increase cost of
> netdevice dismantle phase,
> and increase time for ndo_get_stats64(), especially on hosts with 256
> or 512 cpus.

Two ways to solve this:
 - make dev->pcpu_refcnt point to a structure which holds both
   refcnt and whatever stats
 - combine these stats into lstats, assuming the netdevs we care
   about spawning / destroying fast are sw devices anyway;
   struct rtnl_link_ops can indicate to the core if the driver
   wants lstats (or just put how many bytes it wants), otherwise 
   we'd only allocate enough mem for core's stats

Option three - both.
