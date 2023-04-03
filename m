Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1DFD6D52CD
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 22:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233511AbjDCUr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 16:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232249AbjDCUr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 16:47:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 593C3139;
        Mon,  3 Apr 2023 13:47:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D947062AEC;
        Mon,  3 Apr 2023 20:47:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0B8C433EF;
        Mon,  3 Apr 2023 20:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680554844;
        bh=QJCUCdp5PtM5gxyh82sgIsegU5ra4CtVc899W6CxcMs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CFnRupl4uvyl59il2ygB85xmBFNGZZ6dLBneuQ35YAeP/yq7NQbHEqLf/B+Cr1XOW
         Y7w03CTOnwdUrezsARAYyBIFI0WLTsi/m/gYMzgxfipdZmHziyFQPjPZ7zvemuRRdG
         whp8PGDM0lywebulIPA8d0oNxIVNrWPClBiFbZBNJMhnD2wJfrz9k6rH/66ytN3rzn
         AFi4zPyBeFMadsQWuWzszYc3kMvSgXjSPxRZRucWZKL1dDYpp+SGqJe2MOGqse5kWn
         89npsqZw7caxdRQLHfRK2smzbWiG+/hQxjGbAUEp+ccCBbN6MZrB9Ta2nXRqDNHANw
         EPGrX6RzdheNw==
Date:   Mon, 3 Apr 2023 13:47:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "zbr@ioremap.net" <zbr@ioremap.net>,
        "brauner@kernel.org" <brauner@kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 1/6] netlink: Reverse the patch which removed
 filtering
Message-ID: <20230403134722.4860160c@kernel.org>
In-Reply-To: <82F9EDF5-9D7E-4FFC-9150-A978A36F26B9@oracle.com>
References: <20230331235528.1106675-1-anjali.k.kulkarni@oracle.com>
        <20230331235528.1106675-2-anjali.k.kulkarni@oracle.com>
        <20230331210920.399e3483@kernel.org>
        <88FD5EFE-6946-42C4-881B-329C3FE01D26@oracle.com>
        <20230401121212.454abf11@kernel.org>
        <82F9EDF5-9D7E-4FFC-9150-A978A36F26B9@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 1 Apr 2023 19:58:31 +0000 Anjali Kulkarni wrote:
> > patch 5 looks a bit connector specific, no idea :S
> > patch 6 does seem to lift the NET_ADMIN for group 0
> >        and from &init_user_ns, CAP_NET_ADMIN to net->user_ns, CAP_NET_ADMIN
> >        whether that's right or not I have no idea :(  
> I can move this back to &init_user_ns, and will look at group 0 too. 

Just to be clear - I wasn't saying that it's incorrect, I simply don't
know :)
