Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D74A45F0D4D
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 16:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbiI3OUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 10:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231874AbiI3OT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 10:19:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2926B5301F
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 07:19:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB14BB82779
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 14:19:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD02C433C1;
        Fri, 30 Sep 2022 14:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664547592;
        bh=ggq1Y0UMiCsY7rxpYFsovaEEEqpSbLfHiUr1rHK9gnA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q0u3nFnYDiIbwpysqXZHBuinSOwbxFaLYnzxg3rGx5qHSti5NX+ucK3qE+MXcViAw
         xuLkDVdvb7L20oTlxSaq+DrW/lvY+OoCN9hufqEU7S7vRkoJO6//MbbwrdKZIItyPk
         p0z+tDWMVuhDt4+v8enOuJ7GlCBLg6udUxq+Pu9u6wDZGy8gAB2Nm+DzgnrxBkESXZ
         5TyokYpQmCPacTUN7ivvTM+NnlVRyB3tK6532E7u8AlyvcBKf0xYujCkExzGrMAe4m
         ie+QcOIKSx4pOW4+jlhnolRts92k5UERVFDr4sQjIMTCuNU4WQ6vYU8hQT/h3V+Q5M
         Ef/vJSIjQ4LPg==
Date:   Fri, 30 Sep 2022 07:19:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        habetsm.xilinx@gmail.com
Subject: Re: [PATCH v2 net-next 3/6] sfc: optional logging of TC offload
 errors
Message-ID: <20220930071951.61f81da6@kernel.org>
In-Reply-To: <16da471c-076b-90b3-3935-abd31c6ef4d3@gmail.com>
References: <cover.1664218348.git.ecree.xilinx@gmail.com>
        <a1ff1d57bcd5a8229dd5f2147b09c4b2b896ecc9.1664218348.git.ecree.xilinx@gmail.com>
        <20220928104426.1edd2fa2@kernel.org>
        <b4359f7e-2625-1662-0a78-9dd65bfc8078@gmail.com>
        <20220928113253.1823c7e1@kernel.org>
        <cd10c58a-5b82-10a3-8cf8-4c08f85f87e6@gmail.com>
        <20220928120754.5671c0d7@kernel.org>
        <bc338a78-a6da-78ad-ca70-d350e8e13422@gmail.com>
        <20220928181504.234644e3@kernel.org>
        <16da471c-076b-90b3-3935-abd31c6ef4d3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Sep 2022 10:03:01 +0100 Edward Cree wrote:
> On 29/09/2022 02:15, Jakub Kicinski wrote:
> > Hm. I wonder if throwing a tracepoint into the extack setting
> > machinery would be a reasonable stop gap for debugging.  
> 
> It has one (do_trace_netlink_extack()), but sadly that won't play
>  so well with formatted extacks since AIUI trace needs a constant
>  string (I'm just giving it the format string in my prototype).
> But yeah it's better than nothing.

We can add a new one which copies the data. Presumably we'd have a "set
an extack msg which needs to be freed" helper were we could place it?
It'd mean we cut off at a static length but good enough, I say.
