Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9552E5805D9
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 22:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237142AbiGYUkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 16:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235916AbiGYUkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 16:40:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D96634A
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 13:40:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7807EB810FE
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 20:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B91D5C341C6;
        Mon, 25 Jul 2022 20:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658781643;
        bh=y98d2asDGgu/4UwCHX+TzcRCdrmMJf8/HiTCqG/TtJA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G1NvAwuV7ARml7hP/GVfsfKdf1WMO2xiZtP7uYTu/mrbXNgEDTI5tGtEDMWL1ljdO
         JSN30wQTUsXW30iBGBDZFGQXc9yI/1aJ7VDto72CScSumnV4O0+68G1DV66SAWIdgh
         EuDkm4HW0Dfg3w+ILSgcyJv0/L5Cfq8vV/wZFh/0yPhjZ6R5pxppFfGM8KSZ3nq2b7
         UwCcf1Rni8DuxXBMBJVU51Y3yigr0AIegfPPf2vtN8E2uveW+va72Vc0yk70ofLwg6
         W8UTvA1IV/dsJkQXrRRd57GaKUqmZY/X92YUiflfAPzr0eYYHQhBL2e4Ixivwk2D7q
         sT8UEYtmzxctw==
Date:   Mon, 25 Jul 2022 13:40:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Brian Hutchinson <b.hutchman@gmail.com>
Subject: Re: [PATCH net] net: dsa: fix bonding with ARP monitoring by
 updating trans_start manually
Message-ID: <20220725134041.0c21902e@kernel.org>
In-Reply-To: <20220725203125.kaxokkhyrb4aerp5@skbuf>
References: <20220715232641.952532-1-vladimir.oltean@nxp.com>
        <20220715170042.4e6e2a32@kernel.org>
        <20220716001443.aooyf5kpbpfjzqgn@skbuf>
        <20220715171959.22e118d7@kernel.org>
        <20220716002612.rd6ir65njzc2g3cc@skbuf>
        <20220715175516.6770c863@kernel.org>
        <20220716133009.eaqthcfyz4bcbjbd@skbuf>
        <20220716163338.189738a4@kernel.org>
        <20220725203125.kaxokkhyrb4aerp5@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jul 2022 20:31:25 +0000 Vladimir Oltean wrote:
> How are your sensibilities feeling about this change?

The code seems fine but I'd suggest we state clearly in the comment
that the entire procedure is a workaround for bonding depending on 
an antiquated/incorrect semantics of the field. And we doing this
because we don't know why and therefore how to fix it.
