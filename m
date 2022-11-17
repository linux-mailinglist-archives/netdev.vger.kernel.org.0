Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 230E362D36A
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 07:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbiKQGXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 01:23:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232139AbiKQGXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 01:23:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A9E66C92
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 22:23:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28A98B81E98
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 06:23:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50342C433D6;
        Thu, 17 Nov 2022 06:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668666220;
        bh=g9eIEzUFE89nD2L4HV9h4CCgBqOD+8vb/oqUGWv2YSM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m2KoyNTh0Vx/aitK8yQVleX0lIetgLNQc3W/QsN8e1J5Vevo7aa2ujN8MdSIXOxab
         iwDnx9gYkSHEzKLoQjXmo0ZWrVdnz1j9LaFngYfXp0XCOGhHqMKlJyTecbt0XVZa81
         2BQoljzCLwCHf4BECN/2JCLh8rigM0JbNnfuu6F/jiIR2G2v3voi43mpob67g5Ti7W
         f6xFvmiptH0xS9uI0xqjcJRU0I9WzYah61Uqz0ZUMrL03bHyj4Y0Y4HvM6cGCrKpzz
         8SYUyflEBmhxrEFRYD5TCdOGDZMeV4688NFEKyDdP6UCzuscCAuu2+fis+MPZK6PTI
         a1kza+fsYhHHA==
Date:   Wed, 16 Nov 2022 22:23:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     David Thompson <davthompson@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        cai.huoqing@linux.dev, brgl@bgdev.pl, limings@nvidia.com,
        chenhao288@hisilicon.com, huangguangbin2@huawei.com,
        Asmaa Mnebhi <asmaa@nvidia.com>
Subject: Re: [PATCH net-next v2 3/4] mlxbf_gige: add BlueField-3 Serdes
 configuration
Message-ID: <20221116222339.54052a83@kernel.org>
In-Reply-To: <Y3WWBcCwif7bADY4@x130.lan>
References: <20221109224752.17664-1-davthompson@nvidia.com>
        <20221109224752.17664-4-davthompson@nvidia.com>
        <Y2z9u4qCsLmx507g@lunn.ch>
        <20221111213418.6ad3b8e7@kernel.org>
        <Y29s74Qt6z56lcLB@x130.lan>
        <20221114165046.43d4afbf@kernel.org>
        <Y3LmC7r4YP++q8fa@lunn.ch>
        <20221114171305.6af508be@kernel.org>
        <20221116083056.016e3107@kernel.org>
        <Y3WWBcCwif7bADY4@x130.lan>
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

On Wed, 16 Nov 2022 18:01:41 -0800 Saeed Mahameed wrote:
> >	fw = request_firmware("whatever_name.ftb");
> >	
> >	abc = fw_table_get(fw, "table_abc");
> >	/* use abc */
> >  
> 
> abc is just a byte buffer ? right ?

pointer to const struct fw_table32, which is just;

struct fw_table32 {
	u32 addr;
	u32 value;
};

Actually we need the length as well, so perhaps this is better:

struct fw_table32 {
	u32 addr;
	u32 val;
};

struct fw_table_result {
	uint cnt;
	union {
		const struct fw_table32 *tb32;
	};
};

User:

	struct fw_table_result tab;

	fw = request_firmware("whatever_name.ftb");
	if (!fw)
		...

	err = fw_table_get(fw, "table_abc", &tab);
	if (err)
		...
	for (i = 0; i < tab.cnt; i++) /* use abc */
		write_or_whatever(hw, tab.tb32[i].addr, tab.tb32[i].val);

	def = fw_table_get(fw, "table_def");
	if (err)
		...
	for (i = 0; i < tab.cnt; i++) /* use def */
		write_or_whatever(hw, tab.tb32[i].addr, tab.tb32[i].val);

	release_firmware(fw)

> >	def = fw_table_get(fw, "table_def");
> >	/* use def */
> >  
> 
> And what goes here? any constraints on how the driver must interpret
> and handle abc/def blobs ? 

In the example I assumed a typical buffer with addr / value pairs.
But we can define more table types as needed.

> >	release_firmware(fw)  
> 
> What if the same abc blob structure/table format is used to setup dynamic link
> properties, say via ethtool -s ? Then the whole request firmware will be
> redundant since "struct abc {};" must be defined in the driver src code.

No complex structures, we'd be only targeting register init 
and small FW blobs (IOW { u32 addr; u32 val; } and { u8 val; }).
Stuff which Windows? drivers tend to put into the code as static array.

> I like the idea, i am just trying to figure how we are going to define it
> and how developers will differentiate between when to use this or when to
> use standard APIs to setup their devices.

