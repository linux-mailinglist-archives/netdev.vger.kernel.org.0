Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 686BF647AE4
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiLIAnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:43:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiLIAn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:43:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C1F4B764;
        Thu,  8 Dec 2022 16:43:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41D0EB826C6;
        Fri,  9 Dec 2022 00:43:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9353C433D2;
        Fri,  9 Dec 2022 00:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670546606;
        bh=vrPxe7KssgRD/xhRf28dxVhsg2dY84xoV7mINaDDfZQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q/7x8dCmOblP9/BRiq2PMfG2SwQKLl2wkxAvSAgnOhQSCkh09gF9ezE4CN7gBBNbU
         xY03rO5c9RUUdupNM4C3ocbjTqrnscSnj7N1PW6jVghYr5EIqafcgjJaAII94gWjbd
         cdu4cXTLd8fUafFG4aJiI2pxSXsJZ84TgUNkjdJTkdUS9hn6+KdGpm5skgyiIr2DBt
         Rv840O1mRuyyuOelRMaay+xQQuxwvNCeopR+Rt44CTripk9mq2T2Y42Q7ySIwdmjrC
         4q2qlpXkwSDt6HxCP1zWyrCxl6ycSYytBlAwjHH/XP+ZSWGky7+yGUbQqN5Hm6H4fY
         BOgHlvcOl6iwA==
Date:   Thu, 8 Dec 2022 16:43:24 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com
Subject: Re: [PATCH net-next v2 3/6] tsnep: Support XDP BPF program setup
Message-ID: <Y5KErK9c3Nafn45V@x130>
References: <20221208054045.3600-1-gerhard@engleder-embedded.com>
 <20221208054045.3600-4-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221208054045.3600-4-gerhard@engleder-embedded.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08 Dec 06:40, Gerhard Engleder wrote:
>Implement setup of BPF programs for XDP RX path with command
>XDP_SETUP_PROG of ndo_bpf(). This is prework for XDP RX path support.
>
>Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>

[ ... ]

>+int tsnep_xdp_setup_prog(struct tsnep_adapter *adapter, struct bpf_prog *prog,
>+			 struct netlink_ext_ack *extack)
>+{
>+	struct net_device *dev = adapter->netdev;
>+	bool if_running = netif_running(dev);
>+	struct bpf_prog *old_prog;
>+
>+	if (if_running)
>+		tsnep_netdev_close(dev);
>+
>+	old_prog = xchg(&adapter->xdp_prog, prog);
>+	if (old_prog)
>+		bpf_prog_put(old_prog);
>+
>+	if (if_running)
>+		tsnep_netdev_open(dev);

this could fail silently, and then cause double free, when close ndo 
will be called, the stack won't be aware of the closed state.. 

