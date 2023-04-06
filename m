Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5896D9B87
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 17:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239398AbjDFPCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 11:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbjDFPCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 11:02:07 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2048.outbound.protection.outlook.com [40.107.21.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1FE171E
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 08:02:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vuz583O4LIQPb1FjPC2rh46ZQorUVvEcGPaKFSrHELhb0V5VF9upHFispdGKSWKKDi4/HCXfNDQDXbfSavj70o9X7gC21Vq/XfvPV01rG9ah6D/gBQA0w3DDeOeIRWck1HwtnacoJg4BYXGbOe78C/jrA516Qn5NA05HOIa7GA+KiGSiqaeZxs7fJ6oaiOHxtSwTQqHQh7TRedm4E661/EswE3TTcHNlxJ2v1j1fH8VvRamr+2gQqmeIac6ZCrztaAllbpdylaL0x6OAsJGy48Z0a4ODVPBdoCiFltHHntn+l8ds7bNHGDJfhdjtOcGQh2yJiu+ZnwfuUGm3IbRbTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YAkRzKUHsrr+OmU3nuSlv7+Yqsd2FNWOhJBsAi2nIvQ=;
 b=Dz4TjFt/l8O/kjq3c5f/bDLpRX/f1ql3kk9OlTBGVBWwYreCNi00WpQqDSI2RSDRVzUJQoo93hA5XXxamY85YwxqkeCfChYFIAwQ1q5aQX6cLcfSR6s4GzeyEtGlR250zFwMc9sjbbFJNHFjwBpJ1fYWHMLW6RT2msMTO72NFsKR/MDdQ5ZlHUtx3BRAkiEm3yPmAfiMPforCGGzwC13kR4YIIkAklCthxhxBqMaq1LQkLuZIzDV/dJNLPTZMh6ndA+PbPqS4kzpc9OERXAJqdOu8cZnSODuO0puh+DjqcJDUXn+wq5TMYU5muz91YmlOlZdco987UYHPl9gXq2Psg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YAkRzKUHsrr+OmU3nuSlv7+Yqsd2FNWOhJBsAi2nIvQ=;
 b=D9fNttwajbtR03OxAz493irw6p5ZUF1kSlGzR1WQwgwvTgUp45abn0ueaz8X3KbskTsIwzEBwxTYyEpbFMiDrgBFyJhK9nxzHJOgrAWT4oIdgmeGri1X3qUTqFDYAvkIF3BnRwtqeUNq8xg2RR/Y0rfg6lyvImlfNTLAL5HEkuk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com (2603:10a6:10:103::19)
 by AM7PR04MB6792.eurprd04.prod.outlook.com (2603:10a6:20b:dc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Thu, 6 Apr
 2023 15:02:03 +0000
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::e555:cc9e:b278:15d9]) by DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::e555:cc9e:b278:15d9%7]) with mapi id 15.20.6254.035; Thu, 6 Apr 2023
 15:02:03 +0000
Date:   Thu, 6 Apr 2023 18:01:57 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Max Georgiev <glipus@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, kory.maincent@bootlin.com,
        netdev@vger.kernel.org, maxime.chevallier@bootlin.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com
Subject: Re: [RFC PATCH v3 3/5] Add ndo_hwtstamp_get/set support to vlan code
 path
Message-ID: <20230406150157.rwpmghgao77lkdny@skbuf>
References: <20230405063323.36270-1-glipus@gmail.com>
 <20230405094210.32c013a7@kernel.org>
 <20230405170322.epknfkxdupctg6um@skbuf>
 <20230405101323.067a5542@kernel.org>
 <20230405172840.onxjhr34l7jruofs@skbuf>
 <20230405104253.23a3f5de@kernel.org>
 <20230405180121.cefhbjlejuisywhk@skbuf>
 <20230405170010.1c989a8f@kernel.org>
 <CAP5jrPGzrzMYmBBT+B6U5Oh6v_Tcie1rj0KqsWOEZOBR7JBoXA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP5jrPGzrzMYmBBT+B6U5Oh6v_Tcie1rj0KqsWOEZOBR7JBoXA@mail.gmail.com>
X-ClientProxiedBy: FR2P281CA0139.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9e::10) To DB8PR04MB6459.eurprd04.prod.outlook.com
 (2603:10a6:10:103::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8PR04MB6459:EE_|AM7PR04MB6792:EE_
X-MS-Office365-Filtering-Correlation-Id: e31bd596-54b3-429e-bb43-08db36afe12a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HHP0a0uM4aQe2rKpYkW6tlm4g3dai8Q7egRC/gAlwzCP4vzacpgwrbU/LfghxMNxcn02jRHKWyN/EB/3gP5k+XNS8ggfifoFk0dbmh9J5id5DO19YWrSqsWd2PuJlj/Yrny+rzRfD/J397HNm7l64EQkeoo73X5dU38dOF7ZVaA4NSvvBuM1M7hHbybAsKrpLHH9yYdaQTrtjSSpV5gIticI87tyBvtGolJ2v/ubjauIkCcOcCp1TGn8sLPDesrYnY6YzvZCLCYHZ/Z9fksu9lQ2P8v7hklFZ8ADnJ8i6EBo1Zb5ymUw32aBVWLRdmpZ17Wkc/CJdRpOrP6uH/biHz+wzMqOAFUybgpjoJKXu6mNTkGTPUCzwJzOAf5MkepZgwDF0OsnnjxmARJTZ627ihGKaAwL9iP/cP0cDmaEjqWqzbq7z+uv7gUc2sQPnkcHiV9pOba1bHyejnCLz6sXhqP9xF68Q7WfTKb7/AyQV7MpY+pEwY2Pwu8FTRgnePHpowxH05BBkM3OojgNq8peZohTNZoibeLNdsLuKD6G2xRwKv//g/JdIkHC9hoz9e56
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6459.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(39860400002)(346002)(136003)(376002)(366004)(396003)(451199021)(6512007)(83380400001)(9686003)(316002)(478600001)(186003)(26005)(6666004)(1076003)(6486002)(6506007)(6916009)(44832011)(5660300002)(4326008)(38100700002)(2906002)(41300700001)(66476007)(8676002)(33716001)(86362001)(8936002)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vBIdtyCAINSMvMGnzZu1V5W7ruPogQ79iovnRAJ3iW+/Da58GdokTATfOndG?=
 =?us-ascii?Q?KZhIkmk6L7FyKpE7DPYqiqfEGRNZ/l0Pr5x5XeMyWNHUXU6ROGRHKd4Nh+oN?=
 =?us-ascii?Q?QgRB9JMxOH30jeYhdrse0MKb8QCpI9fQnhJ5IBGbPs1ZZvohZHHyd2z6tHvi?=
 =?us-ascii?Q?smKSvPGGuGz2rsXjkuLbtSNu8+zKM93Bn5IqoNhCFtkhqi0oVGCSxqR53z2U?=
 =?us-ascii?Q?/WFPP3g9HDxnG8RHItHXlCbH6qwRmokgWRjONnvca4GhwfpNKAyl1rtw26nL?=
 =?us-ascii?Q?fRfXM9VxQRSHW+q83B2q4haXxOy8CX39I3R5JauXVykEmScYFhEzctrKWTCA?=
 =?us-ascii?Q?DaGHZ+/JZinh7bmaK8jBA+Gx/6vpPrOmWKJ7g/vun4z1PRwsnRAC34BirmET?=
 =?us-ascii?Q?ECKWqyDXyXzNcFzlpSRQlf7ES9HZN8ksqIX9qSmm2Hzin7MInoAyJTo7e4Io?=
 =?us-ascii?Q?E/Q1WKygDqnh+kU0vqL66eQfiBmwMVDFMGQLorfkRMoviiZu0NdC0N7/XblQ?=
 =?us-ascii?Q?ktlWHiB/LMhd4tuDIn55p1Al801/FhzY7HiAOpzsY6ses+sm/d8blak2Ioll?=
 =?us-ascii?Q?Big76EGj7Y6MN1TnOGsvm8jtjeqLfnfLn/iVPb5XRUxkBKSoUDA3oVEoxe1e?=
 =?us-ascii?Q?BRG5a7PLbB/IyMYBq3bQysl6PmTlKUl/QE/c2gmZL39ZGt5T4duZPpdqgPxi?=
 =?us-ascii?Q?XSNRlmccaIHbQjKL/foHDyg/BOiBGPhzG6OyYW9KI9m23VodZKQ6V8kPm+BD?=
 =?us-ascii?Q?vnMNiEo0N4K7Z6AOP6BuC4p5W30f9bN+s8ve93KqIdY/PR6tg7u86uwWCOg9?=
 =?us-ascii?Q?6e3yZqCd4SR7Y11oB58/657wD/agJsBImYiNbwz063gO9NB6kWBFwPo3eKys?=
 =?us-ascii?Q?ho0/XeKe6aWm5PrLALsuFoBuqlyXFttUdcLDJtyvwCJM7HxaaM8d/bYRINPz?=
 =?us-ascii?Q?ajDGcfu71cdggWFGFr8SaHM7ZfPUIRS2Kd3Qzpyuxx1n2d8J2GWwmpdi+Fbg?=
 =?us-ascii?Q?sYeip00aLTq1U3gcsEwjC2l5ij3M3WKSHz44ccoYncaKHeUsFBKwgXSgxBJF?=
 =?us-ascii?Q?Q3LQj0I723qorG0DsbF7WhdchSimQbyccBmInVasrl+DRuUDPWygJ0iUnbTr?=
 =?us-ascii?Q?Mxw5pD1BF3+Lfl/JSRCE3N+EBtRQuwxOK/xXtKf3zSMUQiSq8OENJe6TXQzl?=
 =?us-ascii?Q?0CH3OcwoyGWeFL8LvEgTbr2aVGnBsAY9ojwEMuQmhKQnnFYe1hlT8+MmPzJa?=
 =?us-ascii?Q?Ce5Mwtepc7ZoWA4v3LMutIQhPURh7o7OPISOWfhiwC3IKMMmVQv1PO4eImmb?=
 =?us-ascii?Q?I+72PieDPfTwiUZm/DN2NefyiLfoAWwPpw/SdOurI4nC3e9QmBnoXXbTc7A9?=
 =?us-ascii?Q?Gf6vau9vj55clKBNWThw/tgAXBFQKhtfER8544/pIQ2iyrfZbsLlmi+Z1gSQ?=
 =?us-ascii?Q?WrHDQjXNbMRxGd+BABUia0ZYcLoZyla5E8cfW/HsN3F5n4M1kCOM9L8hjLCr?=
 =?us-ascii?Q?gnzAXrrFfNWTWZ7J1y1ISt91O2u6gRUipSairzL3iJ19Z39GQN7Jd/8igeRs?=
 =?us-ascii?Q?SBxlLuXtub9vZsuhEc3p9opjmJi+rpLAl9Fldz57Oq2df/r2jaFzPxUoJN0B?=
 =?us-ascii?Q?Iw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e31bd596-54b3-429e-bb43-08db36afe12a
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6459.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 15:02:02.9524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2bI8srFhi4gLdQDFD1N7XdKlmJsz4XakPIVo8/3hXLT99rUB6kd6leBIwVqUXWXW5CMqAPP+xYKgyf/3jJO0pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6792
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 12:21:37AM -0600, Max Georgiev wrote:
> I tried my best to follow the discussion, and convert it to compilable code.
> Here is what I have in mind for generic_hwtstamp_get_lower():
> 
> int generic_hwtstamp_get_lower(struct net_dev *dev,
>                            struct kernel_hwtstamp_config *kernel_cfg,
>                            struct netlink_ext_ack *extack)
> {
>         const struct net_device_ops *ops = dev->netdev_ops;
>         struct hwtstamp_config cfg;
>         int err;
> 
>         if (!netif_device_present(dev))
>                 return -ENODEV;
> 
>         if (ops->ndo_hwtstamp_get)
>                 return ops->ndo_hwtstamp_get(dev, cfg, extack);
> 
>         if (!cfg->ifr)
>                 return -EOPNOTSUPP;
> 
>         err = dev_eth_ioctl(dev, cfg->ifr, SIOCGHWTSTAMP);
>         if (err)
>             return err;
> 
>         if (copy_from_user(&cfg, cfg->ifr->ifr_data, sizeof(cfg)))
>                 return -EFAULT;
> 
>         hwtstamp_config_to_kernel(kernel_cfg, &cfg);
> 
>         return 0;
> }

Side note, it doesn't look like this code is particularly compilable
either - "cfg" is used in some places instead of "kernel_cfg".

> 
> It looks like there is a possibility that the returned hwtstamp_config structure
> will be copied twice to ifr and copied once from ifr on the return path
> in case if the underlying driver does not implement ndo_hwtstamp_get():
> - the underlying driver calls copy_to_user() inside its ndo_eth_ioctl()
>   implementation to return the data to generic_hwtstamp_get_lower();
> - then generic_hwtstamp_get_lower() calls copy_from_user() to copy it
>   back out of the ifr to kernel_hwtstamp_config structure;
> - then dev_get_hwtstamp() calls copy_to_user() again to update
>   the same ifr with the same data the ifr already contains.
> 
> Should we consider this acceptable?

Thanks for laying this out. I guess with a table it's going to be
clearer, so to summarize, I believe this is the status:

Assuming we convert *vlan to ndo_hwtstamp_set():

===================

If the vlan driver is converted to ndo_hwtstamp_set() and the real_dev
driver uses ndo_eth_ioctl(), we have:
- one copy_from_user() in dev_set_hwtstamp()
- one copy_from_user() in the real_dev's ndo_eth_ioctl()
- one copy_to_user() in the real_dev's ndo_eth_ioctl()
- one copy_from_user() in generic_hwtstamp_get_lower()
- one copy_to_user() in dev_set_hwtstamp()

If the vlan driver is converted to ndo_hwtstamp_set() and the real_dev
is converted too, we have:
- one copy_from_user() in dev_set_hwtstamp()
- one copy_to_user() in dev_set_hwtstamp()

===================

Assuming we don't convert *vlan to ndo_hwtstamp_set():

===================

If the vlan driver isn't converted to ndo_hwtstamp_set() and the
real_dev driver isn't converted either, we have:
- one copy_from_user() in dev_set_hwtstamp()
- one copy_from_user() in the real_dev's ndo_eth_ioctl()
- one copy_to_user() in the real_dev's ndo_eth_ioctl()

If the vlan driver isn't converted to ndo_hwtstamp_set(), but the
real_dev driver is, we have:
- one copy_from_user() in dev_set_hwtstamp()
- one copy_from_user() in the vlan's ndo_eth_ioctl()
- one copy_to_user() in the vlan's ndo_eth_ioctl()

===================

So between converting and not converting the *vlans to ndo_hwtstamp_set(),
the worst case is going to be worse (with a mix of new API in *vlan and
old API in real_dev) and the best case is going to be better (with new
API in both *vlan and real_dev). OTOH, with old API in *vlan, the number
of copies to/from the user buffer is going to be constant at 3, which is
not the best, not the worst.

I guess the data indicates that we should convert the *vlans to
ndo_hwtstamp_set() at the very end of the process, and for now, just
make them compatible with a real_dev that uses the new API?

Note that I haven't done the math for the "get" operation yet, but I
believe it to be similar.
