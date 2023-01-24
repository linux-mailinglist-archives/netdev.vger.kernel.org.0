Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECD0967A36F
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 20:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233490AbjAXTzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 14:55:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbjAXTzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 14:55:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C3C4863A
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 11:55:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CA7661330
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 19:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5FCC4339B;
        Tue, 24 Jan 2023 19:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674590139;
        bh=dL0wPOOHKT8RcdklBV6JyrPollRkqdjcgKjRe8mmkeE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PHFQJBO6AwQpGd8EvWs2iNF9mKrYZ1ii5dG/HL8G3HnJDPQUlJbeUS2xQeCqQaCr2
         VgirbbKXzdL2nZ2dSRhnBDWRI53sNad/WeNiPqHCuds+2J7B8qyfjF/8t28fnWE3gG
         0+zKN/AeY5SK337kDuJiI0kizrpnOn5l9UZwb4A3UvD5nkW5wX/M3wfsg0H0w6C4C0
         XxZ5KKtLOBIlfhjDu+4JZI9YdwTGobkAc9LXwFSUGnVPeKi8QtupNWl+fQx0W7BVi3
         kVWBnkuXYhQAqC2u+8EgJAzB1hPL2+VHaEAQy5l/ZiHqEWBBiwHQELFW8kn+wScKf4
         mMGaB3KDH2zDA==
Date:   Tue, 24 Jan 2023 11:55:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aurelien Aptel <aaptel@nvidia.com>
Cc:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net,
        aurelien.aptel@gmail.com, smalin@nvidia.com, malin1024@gmail.com,
        ogerlitz@nvidia.com, yorayz@nvidia.com, borisp@nvidia.com
Subject: Re: [PATCH v9 03/25] net/ethtool: add ULP_DDP_{GET,SET} operations
 for caps and stats
Message-ID: <20230124115538.698f2712@kernel.org>
In-Reply-To: <253o7qouoen.fsf@mtr-vdi-124.i-did-not-set--mail-host-address--so-tickle-me>
References: <20230117153535.1945554-1-aaptel@nvidia.com>
        <20230117153535.1945554-4-aaptel@nvidia.com>
        <20230119184147.161a8ff4@kernel.org>
        <253o7qprtcq.fsf@mtr-vdi-124.i-did-not-set--mail-host-address--so-tickle-me>
        <20230123143830.60f436ef@kernel.org>
        <253o7qouoen.fsf@mtr-vdi-124.i-did-not-set--mail-host-address--so-tickle-me>
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

On Tue, 24 Jan 2023 14:07:12 +0200 Aurelien Aptel wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> > But this is not how they should be carried.
> >
> > The string set is retrieved by a separate command, then you request
> > a string based on the attribute ID (global_stringset() + get_string()
> > in ethtool CLI code).
> >
> > That way long running code or code dumping muliple interfaces can load
> > strings once and dumps are kept smaller.  
> 
> As far as I understand, this is what our code is doing, it is aligned
> with the feature bits implementation and its usage of bitsets.
> 
> Features use netlink bitsets which have a verbose (include literal
> strings) and compact form (use stringset ID).
> 
> Similarly our stats have a verbose (literal strings) and compact
> form (use implicit stringset ID).
> 
> In the compact form, since we always return the complete stats list the
> string id is implicit: the first stat is string id 0, next one string id
> 1, and so on. We just return the complete stat array as a blob under
> "COMPACT_VALUES".
> 
> In ethtool CLI we are using the compact form and calling
> global_stringset() + get_string() as you suggested:
> 
> 	stat_names = global_stringset(ETH_SS_ULP_DDP_STATS,
> 				      nlctx->ethnl2_socket);
> 
> Then later:
> 
> 	for (i = 0; i < results.stat_count; i++) {
> 		const char *name = get_string(stat_names, i);
> 		printf("%s: %lu\n", name, results.stats[i]);
> 	}
> 
> See
> https://github.com/aaptel/ethtool/blob/ulp-ddp-v9/netlink/ulp_ddp.c#L186-L189
> https://github.com/aaptel/ethtool/blob/ulp-ddp-v9/netlink/ulp_ddp.c#L154-L157
> 
> Should we remove the verbose form?

Yes, it just complicates the kernel code to no significant gain, IMO.
