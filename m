Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDB166300F
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 20:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237369AbjAITNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 14:13:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237638AbjAITNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 14:13:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEDAE64E9
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 11:13:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BEA0B80DAA
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 19:13:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3FC8C433EF;
        Mon,  9 Jan 2023 19:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673291622;
        bh=A32hJPZTjcS6V9/fkGWrSp6oy5mzm2PrVuQaN2oUKVs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hbaKR+mxGX/Dk1DiMgQODh2hkkoqw8O1zHFm7tfpGbhbHOarO1MwhF2iI0RlI29m4
         RlVjuOFieMI2POCoW5U4+GxV3KOOeJqx0qhEk2dXzhtGdlMFHwvrDOvdjhKPeIo08n
         xMNESfEuhAZDNqKuUEx9ZbVDISedlBg5gA9Jl1agXryNFOjgsFDDMBlnu6JWrjJU4M
         evg7TzRf+6sk7P49fq27cmhADWA6k3QxH3RcqymmPiLnl0d+KiMDeIxtpQblqtlxpl
         7wGRe89+wCM5dlzKRfCzy1UChzcg+x0Tr8yZx8Vs61noVS8qp4o5ZzjRtQ6pil/JaK
         CQwOQi0RuryNg==
Date:   Mon, 9 Jan 2023 11:13:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH ethtool-next v4 2/2] netlink: add netlink handler for
 get rss (-x)
Message-ID: <20230109111340.73567a60@kernel.org>
In-Reply-To: <IA1PR11MB62667E12E921F5D2D56637DBE4FE9@IA1PR11MB6266.namprd11.prod.outlook.com>
References: <20221229011243.1527945-1-sudheer.mogilappagari@intel.com>
        <20221229011243.1527945-3-sudheer.mogilappagari@intel.com>
        <20230102163326.4b982650@kernel.org>
        <IA1PR11MB62668007BA5BA017F5B46708E4FB9@IA1PR11MB6266.namprd11.prod.outlook.com>
        <20230106134133.75f76043@kernel.org>
        <IA1PR11MB62667E12E921F5D2D56637DBE4FE9@IA1PR11MB6266.namprd11.prod.outlook.com>
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

On Mon, 9 Jan 2023 18:07:45 +0000 Mogilappagari, Sudheer wrote:
> > > Are you suggesting we need to use ioctl for fetching ring info to
> > > avoid mix-up. Is there alternative way to do it ?  
> > 
> > No no, look how the strings for hfunc names are fetched - they are
> > fetched over a different socket, right?  
> 
> global_stringset is using nlctx->ethnl2_socket. Are you suggesting use
> of it for fetching channels info too ? 
> 
> ret = netlink_init_ethnl2_socket(nlctx);
> ...
> hash_funcs = global_stringset(ETH_SS_RSS_HASH_FUNCS, nlctx->ethnl2_socket);

Yessir.
