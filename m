Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6144A03A3
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 23:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350761AbiA1W1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 17:27:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350536AbiA1W1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 17:27:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04116C061714
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 14:27:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9601F61EEC
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 22:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE005C340E7;
        Fri, 28 Jan 2022 22:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643408850;
        bh=Z8J6tCJHXF6KBwsM+cOOQLmAwDGseOsjNc84tgYgD60=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AuZdk8HVasx/nO8LUl3YmDZqegeelk6joAOAyVHYzoRrLzfZX/xUJhGScV3n5TtxH
         /Ym8EsH0smJDfjV+9lx6XW+Sz44vlb9kVunV2Fd7tdgbkWQrdV9OqA9FXRLB1eo6bL
         whuEQlDxcJ2C81dkBVLtbnsjF1oYhesfxRH60dWDoqje8ZaASt23XSemRbczLEHsD8
         VtvPioj3GnvGvg57kYcXQA70OHkQlhnJeLXvrZoSw5mgGXCK1lbgTPz2+RBrIM1LRb
         tasrdmA85nuffwgLIeSqtGIZX10M7vsZK7r3LFmj5WiPwp7TQ9GYSrun5j3MrJZoKU
         WMXYXeFtnIhwg==
Date:   Fri, 28 Jan 2022 14:27:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?w43DsWlnbw==?= Huguet <ihuguet@redhat.com>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] sfc: default config to 1 channel/core in
 local NUMA node only
Message-ID: <20220128142728.0df3707e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220128151922.1016841-2-ihuguet@redhat.com>
References: <20220128151922.1016841-1-ihuguet@redhat.com>
        <20220128151922.1016841-2-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jan 2022 16:19:21 +0100 =C3=8D=C3=B1igo Huguet wrote:
> Handling channels from CPUs in different NUMA node can penalize
> performance, so better configure only one channel per core in the same
> NUMA node than the NIC, and not per each core in the system.
>=20
> Fallback to all other online cores if there are not online CPUs in local
> NUMA node.

I think we should make netif_get_num_default_rss_queues() do a similar
thing. Instead of min(8, num_online_cpus()) we should default to
num_cores / 2 (that's physical cores, not threads). From what I've seen
this appears to strike a good balance between wasting resources on
pointless queues per hyperthread, and scaling up for CPUs which have
many wimpy cores.
