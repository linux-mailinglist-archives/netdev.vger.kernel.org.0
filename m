Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00EB44AA661
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 05:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236746AbiBEEGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 23:06:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiBEEGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 23:06:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2235C061346
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 20:06:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84E86B83969
        for <netdev@vger.kernel.org>; Sat,  5 Feb 2022 04:06:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2920C340E8;
        Sat,  5 Feb 2022 04:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644034010;
        bh=oHwFolhoy8q2Ke10k64Qo+dj5HyuGczmRkt9kPfBmoM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nA0gNXL5W5qdY6UsmplxdHQLg1W6EVEKnQv2RfVSVPiZ1CX4HuNI8THOlE5A0kP15
         1BPsJ/gowo6VSzKiM4Ter39GIEe1kkXC1Mu3fe54ijWnQj4of6w2YlXj4ub4uOvVRf
         qTKZdaHgoNTGyWM7HdwOEyKD8ESC2av+XMbG53iqVuhqGksY3cIgbe4LXTevj3WpZ3
         2+osuyl+LrjCWe3XqLd7OYsV4jy5sHncifvTdb5PodJ/oCQtO+re9b0YfllTPs4K/L
         4RDvM5bJ6G2USjuftVU91269FyE451B+RU8LKSoLGPbd/bwbjNnD8XNyLCsT55xl3a
         jjkeFrPE9sjTA==
Date:   Fri, 4 Feb 2022 20:06:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Talal Ahmad <talalahmad@google.com>,
        Arjun Roy <arjunroy@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Subject: Re: [PATCH net] tcp: take care of mixed
 splice()/sendmsg(MSG_ZEROCOPY) case
Message-ID: <20220204200648.496c7963@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220203225547.665114-1-eric.dumazet@gmail.com>
References: <20220203225547.665114-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Feb 2022 14:55:47 -0800 Eric Dumazet wrote:
> +		if (!sk_wmem_schedule(sk, extra))
> +			return ENOMEM;

Let me make this negative when applying, looks like an inconsequential
typo with current callers.
