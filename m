Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED0364AE605
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 01:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239861AbiBIA1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 19:27:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237906AbiBIA1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 19:27:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A148BC061576;
        Tue,  8 Feb 2022 16:27:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D46461827;
        Wed,  9 Feb 2022 00:27:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64535C004E1;
        Wed,  9 Feb 2022 00:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644366450;
        bh=DOgHT7IypYPcEzB2cyqFOeqBxjv+zi17vi6+cGA2ltE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Nqd41M3obBvnPKwbaBCPjq91MTVykmhnHBw7axREl7vJFMenD/ol0SXTUODmtB2Uj
         DK4FGG7sGbKCAn1coIkQmufTBBJBMQcTBRmCj50sYqeFyHhq4fnXQHS1Ai4p/SEdSu
         hb6c49gjGv0r6DtOkOpxTKQMtImOevWD/GRxSTs6v/Ofiq9YfpShRvAGzLzmOuQEtp
         IMtTx4dZJzFr4D/AWZR33DQciXT1xXBbZgiWXPRvsjzLZkXbPyaN9KH/7B7s/Oyej9
         JB50IJsuZ40RaCKMxvNo7BIWAu+Bjf5AkNQNep34s+ElaHsoR+QllQuwPn40dWOleW
         rhYEmEWf+8BsA==
Date:   Tue, 8 Feb 2022 16:27:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, rostedt@goodmis.org, mingo@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dev: introduce netdev_drop_inc()
Message-ID: <20220208162729.41b62ae7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220208064318.1075849-1-yajun.deng@linux.dev>
References: <20220208064318.1075849-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Feb 2022 14:43:18 +0800 Yajun Deng wrote:
> We will use 'sudo perf record -g -a -e skb:kfree_skb' command to trace
> the dropped packets when dropped increase in the output of ifconfig.
> But there are two cases, one is only called kfree_skb(), another is
> increasing the dropped and called kfree_skb(). The latter is what
> we need. So we need to separate these two cases.
> 
> From the other side, the dropped packet came from the core network and
> the driver, we also need to separate these two cases.
> 
> Add netdev_drop_inc() and add a tracepoint for the core network dropped
> packets. use 'sudo perf record -g -a -e net:netdev_drop' and 'sudo perf
>  script' will recored the dropped packets by the core network.
> 
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>

Have you seen the work that's being done around kfree_skb_reason()?
