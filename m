Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7519F6523CD
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 16:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbiLTPlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 10:41:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiLTPl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 10:41:29 -0500
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F057110045;
        Tue, 20 Dec 2022 07:41:27 -0800 (PST)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 4DB3535200;
        Tue, 20 Dec 2022 17:41:27 +0200 (EET)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id 6BCB435183;
        Tue, 20 Dec 2022 17:41:25 +0200 (EET)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id C441F3C07CC;
        Tue, 20 Dec 2022 17:41:22 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.16.1) with ESMTP id 2BKFfKDx068357;
        Tue, 20 Dec 2022 17:41:20 +0200
Date:   Tue, 20 Dec 2022 17:41:20 +0200 (EET)
From:   Julian Anastasov <ja@ssi.bg>
To:     Paolo Abeni <pabeni@redhat.com>
cc:     Jon Maxwell <jmaxwell37@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next] ipv6: fix routing cache overflow for raw sockets
In-Reply-To: <9f145202ca6a59b48d4430ed26a7ab0fe4c5dfaf.camel@redhat.com>
Message-ID: <98a8f9b6-36d1-d184-d860-e07a2e24fc9c@ssi.bg>
References: <20221218234801.579114-1-jmaxwell37@gmail.com> <9f145202ca6a59b48d4430ed26a7ab0fe4c5dfaf.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Tue, 20 Dec 2022, Paolo Abeni wrote:

> Are other FLOWI_FLAG_KNOWN_NH users affected, too? e.g. nf_dup_ipv6,
> ipvs, seg6?

	I forgot to mention one thing: IPVS can cache such routes in
its own storage, one per backend server, it still calls dst->ops->check
for them. So, such route can live for long time, that is why they were 
created as uncached. So, IPVS requests one route, remembers it and then 
can attach it to multiple packets for this backend server with
skb_dst_set_noref. So, IPVS have to use 4096 backend servers to
hit this limit.

	It does not look correct in this patch to invalidate the
FLOWI_FLAG_KNOWN_NH flag with a FLOWI_FLAG_SKIP_RAW flag. The
same thing would be to not set FLOWI_FLAG_KNOWN_NH which is
wrong for the hdrincl case.

Regards

--
Julian Anastasov <ja@ssi.bg>

