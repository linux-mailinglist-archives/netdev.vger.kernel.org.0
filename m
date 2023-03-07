Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 747826AE616
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 17:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjCGQQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 11:16:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCGQQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 11:16:32 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02hn2239.outbound.protection.outlook.com [52.100.201.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 354226B5FC;
        Tue,  7 Mar 2023 08:16:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l+0X2WfBCuGMRSAJBueAj4U7UjJIcKo53YXg3W2MHAw=;
 b=kocCyicpbiEXrSGbOWA11KT4HTKm51ImDvKz3+MwhOrvDOo14+ZriNxwSBTvv1icmU2GyehkG41DP/CgqiHPKgGs1wVxOdqHnD3Obu2dY28RnQzRO1SMXFxGLrLe4AHr31A3pwkLV5vJpb61pjy7XfOdKH1m/8T39X5+aoujFd1XNQZ7LNxCwMzplFeV11YifGmB32HYLll0H/SfmwkQhaO2YycWDAgFF2Zslgn0vEnnJjeBWK1R67bWHi6hDEJIkVdW6IUgw/HBYaKw8FyqJuAdK/6ZW6JK40EuN/jvfza6+Vh41vHQZA0J3kbPLiTuF7Tng1muEo/VqapGqF4Q+w==
Received: from FR0P281CA0073.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1e::13)
 by PAVPR03MB9137.eurprd03.prod.outlook.com (2603:10a6:102:328::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 16:16:26 +0000
Received: from VI1EUR05FT062.eop-eur05.prod.protection.outlook.com
 (2603:10a6:d10:1e:cafe::24) by FR0P281CA0073.outlook.office365.com
 (2603:10a6:d10:1e::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.15 via Frontend
 Transport; Tue, 7 Mar 2023 16:16:26 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 20.160.56.80)
 smtp.mailfrom=seco.com; dkim=pass (signature was verified)
 header.d=seco.com;dmarc=pass action=none header.from=seco.com;
Received-SPF: Fail (protection.outlook.com: domain of seco.com does not
 designate 20.160.56.80 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.160.56.80; helo=inpost-eu.tmcas.trendmicro.com;
Received: from inpost-eu.tmcas.trendmicro.com (20.160.56.80) by
 VI1EUR05FT062.mail.protection.outlook.com (10.233.243.189) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.16 via Frontend Transport; Tue, 7 Mar 2023 16:16:26 +0000
Received: from outmta (unknown [192.168.82.133])
        by inpost-eu.tmcas.trendmicro.com (Trend Micro CAS) with ESMTP id 3A5522008026E;
        Tue,  7 Mar 2023 16:16:26 +0000 (UTC)
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (unknown [104.47.51.176])
        by repre.tmcas.trendmicro.com (Trend Micro CAS) with ESMTPS id 1E3AC20080075;
        Tue,  7 Mar 2023 16:08:04 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JZep7mKQ8nF1RUyXZJ/rIRkTyopz8UvYNTMaChxg0UEIXZB/aaJK/VbZlWX8U2j6aMHxp6WOrMe3W0f4PH7rnOtmWx4Up+TcnXXNqcENkqW3AujN8gngCmJcaftmSDGqX7oYWEjqJVA2SlA32+bttk1fHWVisADOHMtHv2X15LskPzGTM3TMsKBnhKGRxJcbLJ82ACQQ3nBWNAc8pGaCX++2P9mGpUSRYSpT7iEJ+7IepBN1zFyD/b1noeE+TmxAwPbzZ+tXh28oUqcuMUcsr/Ei9Oq94bN2YNnA44W9rESOQQ8I6Mv1ZEA8POdwxmZGp+a9RhjCkYq5VEzgiw2NnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l+0X2WfBCuGMRSAJBueAj4U7UjJIcKo53YXg3W2MHAw=;
 b=d2fIpL/69fNEcoW7jGSlHcjaYIM4dzwfo7P3HlF3WSeMc6yC6QiZLreu9RavzepPqbGoy6DqJ7U9R0yx6Fakcr4wqmo3slt8nfOrMnuaHAOJafGFK+A6Ekh5XxthntJ4YGbzXIS4OAVXZRmiWgbGRTlHYILX9GeO74I16T5+RLcwhg5ZICn5P1yNHDj+qlqkHIZHEC3yiSawlfaLSTb3sPDkWF0fot1AbPDjTu02qKfRYXnzs74enxWEX8UUsp1mxKub1rRR+rKIbUZHxaQcsZ/L2PIVQoWWwW38qwSUcbKisdC4E3K9RSyeJS4uL4dD6CctV8exFCXA1hV4zznI4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l+0X2WfBCuGMRSAJBueAj4U7UjJIcKo53YXg3W2MHAw=;
 b=kocCyicpbiEXrSGbOWA11KT4HTKm51ImDvKz3+MwhOrvDOo14+ZriNxwSBTvv1icmU2GyehkG41DP/CgqiHPKgGs1wVxOdqHnD3Obu2dY28RnQzRO1SMXFxGLrLe4AHr31A3pwkLV5vJpb61pjy7XfOdKH1m/8T39X5+aoujFd1XNQZ7LNxCwMzplFeV11YifGmB32HYLll0H/SfmwkQhaO2YycWDAgFF2Zslgn0vEnnJjeBWK1R67bWHi6hDEJIkVdW6IUgw/HBYaKw8FyqJuAdK/6ZW6JK40EuN/jvfza6+Vh41vHQZA0J3kbPLiTuF7Tng1muEo/VqapGqF4Q+w==
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by PA4PR03MB7423.eurprd03.prod.outlook.com (2603:10a6:102:10c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 16:16:16 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::dbcf:1089:3242:614e]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::dbcf:1089:3242:614e%5]) with mapi id 15.20.6156.027; Tue, 7 Mar 2023
 16:16:16 +0000
Message-ID: <f947e5e2-770e-4b12-67ae-8abf5866e250@seco.com>
Date:   Tue, 7 Mar 2023 11:16:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next] net: mdio: Add netlink interface
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20230306204517.1953122-1-sean.anderson@seco.com>
 <7a02294e-bf50-4399-9e68-1235ba24a381@lunn.ch>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <7a02294e-bf50-4399-9e68-1235ba24a381@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0222.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::17) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|PA4PR03MB7423:EE_|VI1EUR05FT062:EE_|PAVPR03MB9137:EE_
X-MS-Office365-Filtering-Correlation-Id: 0951d575-0e1d-48c3-a4a7-08db1f274d73
X-TrendMicro-CAS-OUT-LOOP-IDENTIFIER: 656f966764b7fb185830381c646b41a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: BxM/zSz9uyD+FQ1E4i+L5PmMHJXH1esybroYvvTf5Wop7n+IYrCklDkZCNoI/aaXMPrWa8ZCH28+IXzjpBqBGOZGhkhIJN0s6ew+2nsuqmxhoyFA8oVW8wiuV6n6zUF3e6vn/bz8XexWyYHxar9fuo+/K5hCgxjHCO65i1EHj6RiyDj3JSIWxV8n960JbqETyfnyz4L/X6v6KVyIARvqnNFsNX5aJihGCcQ1ABDLeKPu0E0B+SoFboCcmGk2jjbgF4zrHnhjWCFhg6XhE11XyfWEwhTFRKFodChpncm4PAdVfHc96XC/TdvmKDHiRKb10V4Fcow4PXag08bcVx8EEK9kpkEXjDvbYMeUV6BJ2Fw3l2HjizZfjf6jgeRJBDh6PpxVUm2/83LO6ASLGpebEIRSa3fEwlyrVPH1ScYC/Cn23CwxHIx8Fc3+TtUn39ngeWHz/XFziYp+a4+ittoiPxy0QWSSwrW64tnYGZYX5Q15WYFdHluX6lev3cdzGYRLD/BCHxfmT0tymF69tuwMDvImvAUhoPhcSj0U3NG7dAZDdsD6uPzQdhEI7K7jKuufOvqkS6fuguFA+1nZrFFaJ0KCj22zFKxdVEYmNYenfm6c2LjH4Oq/ux6XZmEEyT70EgN2GGM3Btvf6wQ/zzuqmZxWxC+zQIF7UUCCSgeKsPXpOvIsPUI9c3OshzfdpsYiTMuWfNVm0KxZr7v0KjqxUjEwdeTE1TDxCx5MaN9CQXoZEsMCMyc6NzFiPTinZTW3f6tLxSLCRMQ2oOYtD7hB+Q==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(136003)(376002)(39850400004)(366004)(346002)(451199018)(31686004)(2906002)(2616005)(83380400001)(44832011)(26005)(4326008)(66556008)(66946007)(66476007)(8676002)(6916009)(7416002)(5660300002)(186003)(6512007)(41300700001)(6506007)(53546011)(36756003)(6666004)(38100700002)(38350700002)(8936002)(478600001)(6486002)(52116002)(31696002)(54906003)(86362001)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB7423
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VI1EUR05FT062.eop-eur05.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 0a83d339-e9fc-4a95-ca9f-08db1f274752
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zpTaXNT33aYcI3SvdBRKO1nAlknaMURgqjNtJA4MuF8kFyUhYK5LA7WGr95auL4h6aaKM/tT9NliTDD+DaNokxpppOx/QxBHKEVk8zjotxL35mR9E/TXxgMFN/VQoLv540cktvfxEashp2VsFPEFWfp8wWcl9A2zpj9PEWXj3Jlb7FagWC/sEwodjUZbJRVXuxy++cn3Hab5D9qZE5nS1VG0hoSp/AE41esVqSKQt3AsaNn9WU+LURnogl1na2mIhYslUaLBg+iOf82HA9USk1fcJHygVvjLVMgvEkP535tFACqnAN/V/uwXylmyUSceQhNoSrdx+HYnEWE+CykhRGYpWmei+IINiy0sDzWGkQGPqcMVT0QPwUf6ginuxaS28gi4gjUpG/NkTMSc377xDqYKCowXoJ+KHeRjdLcTvRiajh805FeGps0phBlLUwVoIz7+WT+po+Zj8hTZsrMKOFPrAwgin3o3HZ06YDSrZC7xfx7B4GAHpPX2KMkPqavgaTgy1G1TNxjzC52+FmRhPPAwhCFCvGYi2iBS1dN+0Rgbn3on+1HcB6zSnFR53by2jtf4wf7KFMY83JFwA+rJ5zS1ZqiY8gjNtWEO5wgwA+qz+tmDXBGXQhZFowTKk7rOCSKVgHpN85Hhe42PmgrwF4pyWwbKgz/a5Mt4uh8sUimwdrtAPzP4XFSs3sKXrPeBrjHWcHtib0CSsTRx/0Tt8bCe0+ypyS7Z9g1lE9Q81U1j98gClBCyqplE8PVWpDYNkr34y5vKrvnNCR9FiPbDmHnldtgKVECtWzH7qaAhliuSYHaY1Os0zBxAs6nn+Opi2fComOM3of9D4Zte627UP0Ma19IKqxAD0CaGWGSbGM0=
X-Forefront-Antispam-Report: CIP:20.160.56.80;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:inpost-eu.tmcas.trendmicro.com;PTR:inpost-eu.tmcas.trendmicro.com;CAT:NONE;SFS:(13230025)(136003)(376002)(39850400004)(396003)(346002)(5400799012)(451199018)(36840700001)(40470700004)(46966006)(36860700001)(34070700002)(7596003)(34020700004)(7636003)(86362001)(31696002)(356005)(70206006)(5660300002)(6666004)(36756003)(7416002)(44832011)(2906002)(82740400003)(4326008)(6916009)(8676002)(8936002)(70586007)(41300700001)(40480700001)(82310400005)(40460700003)(2616005)(26005)(53546011)(336012)(186003)(83380400001)(47076005)(316002)(6512007)(54906003)(6506007)(478600001)(31686004)(6486002)(43740500002)(45980500001)(12100799021);DIR:OUT;SFP:1501;
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 16:16:26.5729
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0951d575-0e1d-48c3-a4a7-08db1f274d73
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bebe97c3-6438-442e-ade3-ff17aa50e733;Ip=[20.160.56.80];Helo=[inpost-eu.tmcas.trendmicro.com]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR05FT062.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR03MB9137
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/7/23 09:22, Andrew Lunn wrote:
>> To prevent userspace phy drivers, writes are disabled by default, and can
>> only be enabled by editing the source. This is the same strategy used by
>> regmap for debugfs writes. Unfortunately, this disallows several useful
>> features, including
>> 
>> - Register writes (obviously)
>> - C45-over-C22
> 
> You could add C45-over-C22 as another op.
> 
> This tool is dangerous, even in its read only mode, just like the
> IOCTL interface. Interrupt status registers are often clear on read,
> so you can loose interrupts. Statistics counters are sometimes clear
> on read. BMSR link bit is also latching, so a read of it could mean
> you miss link events, etc. Adding C45-over-C22 is just as dangerous,
> you can mess up MDIO switches which use the registers for other
> things, but by deciding to use this tool you have decided to take the
> risk of blowing your foot off.

Yes, and I should probably have commented on this in the commit message.
IMO the things you listed are... iffy but unlikely to cause a
malfunction. Tainting on read would be fine, since it is certainly
possible to imagine hardware which would malfunction on read. I suppose
regmap gets away with this by sticking the whole thing in debugfs.

>> - Atomic access to paged registers
>> - Better MDIO emulation for e.g. QEMU
>> 
>> However, the read-only interface remains broadly useful for debugging.
> 
> I would say it is broadly useful for PHYs. But not Ethernet switches,
> when in read only mode. 
> 
>> +static int mdio_nl_open(struct mdio_nl_xfer *xfer);
>> +static int mdio_nl_close(struct mdio_nl_xfer *xfer, bool last, int xerr);
> 
> I guess i never did a proper review of this code before, due to not
> liking the concept....
> 
> Move the code around so these are not needed, unless there are
> functions which are mutually recursive.

They do indeed call each other (although by my analysis no recursion
results). The forward declaration of mdio_nl_open is unnecessary, so I
will rearrange things to avoid that.

>> +static inline u16 *__arg_r(u32 arg, u16 *regs)
>> +{
>> +	WARN_ON_ONCE(arg >> 16 != MDIO_NL_ARG_REG);
>> +
>> +	return &regs[arg & 0x7];
>> +}
> 
> No inline functions in C files. Leave the compiler to decide.

OK

>> +static int mdio_nl_eval(struct mdio_nl_xfer *xfer)
>> +{
>> +	struct mdio_nl_insn *insn;
>> +	unsigned long timeout;
>> +	u16 regs[8] = { 0 };
>> +	int pc, ret = 0;
>> +	int phy_id, reg, prtad, devad, val;
>> +
>> +	timeout = jiffies + msecs_to_jiffies(xfer->timeout_ms);
>> +
>> +	mutex_lock(&xfer->mdio->mdio_lock);
> 
> Should timeout be set inside the lock, for when you have two
> applications running in parallel and each take a while?

That seems reasonable.

>> +
>> +	for (insn = xfer->prog, pc = 0;
>> +	     pc < xfer->prog_len;
>> +	     insn = &xfer->prog[++pc]) {
>> +		if (time_after(jiffies, timeout)) {
>> +			ret = -ETIMEDOUT;
>> +			break;
>> +		}
>> +
>> +		switch ((enum mdio_nl_op)insn->op) {
>> +		case MDIO_NL_OP_READ:
>> +			phy_id = __arg_ri(insn->arg0, regs);
>> +			prtad = mdio_phy_id_prtad(phy_id);
>> +			devad = mdio_phy_id_devad(phy_id);
>> +			reg = __arg_ri(insn->arg1, regs);
>> +
>> +			if (mdio_phy_id_is_c45(phy_id))
>> +				ret = __mdiobus_c45_read(xfer->mdio, prtad,
>> +							 devad, reg);
>> +			else
>> +				ret = __mdiobus_read(xfer->mdio, phy_id, reg);
> 
> The application should say if it want to do C22 or C45.

The phy_id comes from the application. So it sets MDIO_PHY_ID_C45 if it wants
to use C45.

> As you said in
> the cover note, the ioctl interface is limiting when there is no PHY,
> so you are artificially adding the same restriction here.

I don't follow.

> Also, you
> might want to do C45 on a C22 PHY, e.g. to access EEE registers. Plus
> you could consider adding C45 over C22 here.

As Russell noted, this is dangerous in the general case.

>> +
>> +			if (ret < 0)
>> +				goto exit;
>> +			*__arg_r(insn->arg2, regs) = ret;
>> +			ret = 0;
>> +			break;
>> +
>> +		case MDIO_NL_OP_WRITE:
>> +			phy_id = __arg_ri(insn->arg0, regs);
>> +			prtad = mdio_phy_id_prtad(phy_id);
>> +			devad = mdio_phy_id_devad(phy_id);
>> +			reg = __arg_ri(insn->arg1, regs);
>> +			val = __arg_ri(insn->arg2, regs);
>> +
>> +#ifdef MDIO_NETLINK_ALLOW_WRITE
>> +			add_taint(TAINT_USER, LOCKDEP_STILL_OK);
> 
> I don't know, but maybe taint on read as well.
> 
>> +			if (mdio_phy_id_is_c45(phy_id))
>> +				ret = __mdiobus_c45_write(xfer->mdio, prtad,
>> +							  devad, reg, val
>> +			else
>> +				ret = __mdiobus_write(xfer->mdio, dev, reg,
>> +						      val);
>> +#else
>> +			ret = -EPERM;
> 
> EPERM is odd, EOPNOTSUPP would be better. EPERM suggests you can run
> it as root and it should work.

Well, EPERM is what you get when trying to write a 444 file, which is
effectively what we're enforcing here.

--Sean
