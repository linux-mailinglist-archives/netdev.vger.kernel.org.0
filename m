Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 785FA4AC6A9
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343830AbiBGRAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:00:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391607AbiBGQrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 11:47:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22296C0401D1;
        Mon,  7 Feb 2022 08:47:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF19561008;
        Mon,  7 Feb 2022 16:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75E1C004E1;
        Mon,  7 Feb 2022 16:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644252439;
        bh=Wx0RkEWPBWn/lYOrF1atstKtid9/OeD5HZWiB5N2JuA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C1lkCrzlK83BC0G9RTlDkds82Ef7SJ7YSgnhMqQggT6eNw8M3mPvz88Cq0gS8kjiX
         7n6dJ5nECoTEH64Hos1TkbU0aD/wdFDxmatMSP6JmypOQ8cjGOu/zzjtK2KYzZw4St
         AYwt/Y2U8mV39/+YmI9OlWQmasvmAXZbJ0jw1OCZBv4exoQOm+ryXL17z4yYHsyZXJ
         ICv8Q2SlSp2e8plGqy7Ik8OQPEFF251JkeTRo78c9TsI5wySa/d6sZL5a9TCUsRa+S
         lWcVjsRVlYGPnhs81JqAr6KvNVl+U4rwZ4Gjmclbcl7IxmEiScJTrohj1mC/2PE+7F
         Wy5IE7MGttqPA==
Date:   Mon, 7 Feb 2022 08:47:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNl?= =?UTF-8?B?bg==?= 
        <toke@toke.dk>
Subject: Re: [PATCH net-next v2 2/3] net: dev: Makes sure netif_rx() can be
 invoked in any context.
Message-ID: <20220207084717.5b7126e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <Yf7ftf+6j52opu5w@linutronix.de>
References: <20220204201259.1095226-1-bigeasy@linutronix.de>
        <20220204201259.1095226-3-bigeasy@linutronix.de>
        <20220204201715.44f48f4f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <Yf7ftf+6j52opu5w@linutronix.de>
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

On Sat, 5 Feb 2022 21:36:05 +0100 Sebastian Andrzej Siewior wrote:
> On 2022-02-04 20:17:15 [-0800], Jakub Kicinski wrote:
> > On Fri,  4 Feb 2022 21:12:58 +0100 Sebastian Andrzej Siewior wrote:  
> > > +int __netif_rx(struct sk_buff *skb)
> > > +{
> > > +	int ret;
> > > +
> > > +	trace_netif_rx_entry(skb);
> > > +	ret = netif_rx_internal(skb);
> > > +	trace_netif_rx_exit(ret);
> > > +	return ret;
> > > +}  
> > 
> > Any reason this is not exported? I don't think there's anything wrong
> > with drivers calling this function, especially SW drivers which already
> > know to be in BH. I'd vote for roughly all of $(ls drivers/net/*.c) to
> > get the same treatment as loopback.  
> 
> Don't we end up in the same situation as netif_rx() vs netix_rx_ni()?

Sort of. TBH my understanding of the motivation is a bit vague.
IIUC you want to reduce the API duplication so drivers know what to
do[1]. I believe the quote from Eric you put in the commit message
pertains to HW devices, where using netif_rx() is quite anachronistic. 
But software devices like loopback, veth or tunnels may want to go via
backlog for good reasons. Would it make it better if we called
netif_rx() netif_rx_backlog() instead? Or am I missing the point?
