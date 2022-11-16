Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47BF962C4B8
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 17:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbiKPQhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 11:37:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238934AbiKPQhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 11:37:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A711F57B69
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 08:31:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5454DB81DEB
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 16:30:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4F9C43470;
        Wed, 16 Nov 2022 16:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668616258;
        bh=5azFllHSUSUn4NWi7UcEfS7c9hqGwaKjLr6GUiK9Qhs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tR1TUXzYIYGeZZENWur2aGmf0Gu3/fc82b9CBw5qV72nutxm18l7UTD0NCjji+3yD
         xm1H4JsWRGhnT3BrAOShykBrl31GAwRnM3mBtfhS3Jyqb/06AYtyju0zrCDAss2FUl
         H3Qx5/Hw8mbP0Al6qki6ovpNcz5TxejU3hob566BjB5nNXq5L/dwz1a1GKrey7vGI9
         FbWmIqN8xvCwv/wwBmD5GHwfS/xk2+RU2DuIhziz2dHCNWRPxwG72uBldwTnqsMwqc
         q3rbYy/dCBInXE0SG7r3vGy/jTEOiOJ7dTN66uqbryIxrogerTCziJEvMnYXXm2F7r
         8HOvpBhn4q6/g==
Date:   Wed, 16 Nov 2022 08:30:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>,
        David Thompson <davthompson@nvidia.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        cai.huoqing@linux.dev, brgl@bgdev.pl, limings@nvidia.com,
        chenhao288@hisilicon.com, huangguangbin2@huawei.com,
        Asmaa Mnebhi <asmaa@nvidia.com>
Subject: Re: [PATCH net-next v2 3/4] mlxbf_gige: add BlueField-3 Serdes
 configuration
Message-ID: <20221116083056.016e3107@kernel.org>
In-Reply-To: <20221114171305.6af508be@kernel.org>
References: <20221109224752.17664-1-davthompson@nvidia.com>
        <20221109224752.17664-4-davthompson@nvidia.com>
        <Y2z9u4qCsLmx507g@lunn.ch>
        <20221111213418.6ad3b8e7@kernel.org>
        <Y29s74Qt6z56lcLB@x130.lan>
        <20221114165046.43d4afbf@kernel.org>
        <Y3LmC7r4YP++q8fa@lunn.ch>
        <20221114171305.6af508be@kernel.org>
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

On Mon, 14 Nov 2022 17:13:05 -0800 Jakub Kicinski wrote:
> On Tue, 15 Nov 2022 02:06:19 +0100 Andrew Lunn wrote:
> > > I don't feel particularly strongly but seems like something worth
> > > exploring. A minor advantage is that once the init is done the tables
> > > can be discarded from memory.    
> > 
> > I wondered about that, but i'm not sure initdata works for modules,
> > and for hot pluggable devices like PCIe, you never know when another
> > one might appear and you need the tables.  
> 
> Right, I meant that the request_firmware() version can discard 
> the tables. I shouldn't have said tables :)

Saeed, David, are you looking into this? The problem come up again 
in a Realtek USB conversation.

The task is so small and well defined I'm pretty sure I can get some
aspiring kernel developer at Meta to knock it off in a few days.

FWIW the structure of a file I had in mind would be something like this:

# Section 0 - strings (must be section 0)
 # header
 u32 type:   1   # string section
 u32 length: n   # length excluding header and pads
 u32 name:   0   # offset to the name in str section
 u32 pad:    0   # align to 8B
 # data
 .str\0table_abc\0table_def\0some_other_string\0
 # pad, align to 8B
 \0\0\0\0\0\0\0

# Section 1 - table_abc
 # header
 u32 type:   2   # 32b/32b table
 u32 length: 64  # length excluding header and pads
 u32 name:   5   # offset to the name in str section
 u32 pad:    0
 # data
 [ 0x210, 0xc00ff ]
 [ 0x214, 0xffeee ]
 [ 0x218, 0xdeaddd ]
 [ 0x21c, 0xc4ee5e ]
 [ 0x220, 0xc00ff ]
 [ 0x224, 0xffeee ]
 [ 0x228, 0xdeaddd ]
 [ 0x22c, 0xc4ee5e ]

etc.

Use:
	struct fw_table32 *abc, *def;

	fw = request_firmware("whatever_name.ftb");
	
	abc = fw_table_get(fw, "table_abc");
	/* use abc */

	def = fw_table_get(fw, "table_def");
	/* use def */

	release_firmware(fw)
