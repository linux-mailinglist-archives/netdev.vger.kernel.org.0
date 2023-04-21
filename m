Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 178CD6EA16D
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 04:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbjDUCEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 22:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232030AbjDUCET (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 22:04:19 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E481F10DA;
        Thu, 20 Apr 2023 19:04:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IEvuigAy++k4/smNuEJvRRa/bixzqn/8daEbIr3C+1pXvUAT+BWvusqIP5CdjYAZO91x018YSytUQXqXnkEvmsat+A9oZHTQ/gLUit/mBuGboT5mmts0e/NSbNs8cW9kL4r5ftmyHKRAg2Fn8yE3dlWqEHChCmYC/qHmp6MjWo277c5h46n1f/YDnakQQYQoabFw6b8yz6iQS2OSyurrl9/pqGVwsc1IPCTSnL1GS3VHmSljYTPZHfAQcBy7R2zF9CjnxhCqGHPmdjSgoLK8NAK53L45aoCvbWR/TNfcncfcs/p5lkRv4g0sswW9ssYE1xaZ4ecJlY8V2ivsLNU3vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5+nzZG29L8vulClMaRmLUwt5TdB/xM+hmKwwDGjCTxg=;
 b=hQg8bdhnj+W95jR11Fnnd9XA0l06ZT8inPsWMyIbXI+KHrgunzkv1TIHZptvwZjLDApxxNkQ2j+m/wOY6J7EYfqM8+xd27Zu4pkxwSRyqTfN3Gxkfu6isJz/0Es1Ek6dUxwAwvgmSzTkCetDm5IK0flk8pa/zjfddn11BmFQJXtLu7QwlgkE/5NaPt+dMv0t99JXauOluPO3PQoTGXfK5H/M3OE+P/rGDrbm1nwfLlp6w3WqETtCw7oJIPWwBclZG5Lah+P3x3ae9CZ0hxQACYW8ThAI9HNATO1oQhMGgbYUV/xxpI7DVMVg2eLOx9mzmVcQShV8jrUUYLrPJnc7dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5+nzZG29L8vulClMaRmLUwt5TdB/xM+hmKwwDGjCTxg=;
 b=D7vezaUZs6INlowJEAJk4HX9G4/uw8N5NH96wW3QwDHFBQqhcEZP+PHCpKcw0CpOjrLoze8cAa1LAcyr32CrbgYUDg3uiJ6MZzJiOigYn6thYUjnyZiCTLmRG2gXLk1FTSx9SLpmsPChMj+ejlmDCTqIdjN9dYVToDkjmlS65uc=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by CY5PR21MB3492.namprd21.prod.outlook.com (2603:10b6:930:f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.9; Fri, 21 Apr
 2023 02:04:15 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::eeec:fa96:3e20:d13]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::eeec:fa96:3e20:d13%6]) with mapi id 15.20.6340.009; Fri, 21 Apr 2023
 02:04:15 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     "bhelgaas@google.com" <bhelgaas@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jake Oshins <jakeo@microsoft.com>,
        "kuba@kernel.org" <kuba@kernel.org>, "kw@linux.com" <kw@linux.com>,
        KY Srinivasan <kys@microsoft.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh@kernel.org" <robh@kernel.org>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Long Li <longli@microsoft.com>,
        "boqun.feng@gmail.com" <boqun.feng@gmail.com>,
        Saurabh Singh Sengar <ssengar@microsoft.com>,
        "helgaas@kernel.org" <helgaas@kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jose Teuttli Carranco <josete@microsoft.com>
Subject: RE: [PATCH v3 0/6] pci-hyper: Fix race condition bugs for fast device
 hotplug
Thread-Topic: [PATCH v3 0/6] pci-hyper: Fix race condition bugs for fast
 device hotplug
Thread-Index: AQHZczGRNBEm3wYLi0mCVhJUsObBRK81ANQg
Date:   Fri, 21 Apr 2023 02:04:14 +0000
Message-ID: <SA1PR21MB1335B7E8FFBE1C03E9B0FDE2BF609@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <20230420024037.5921-1-decui@microsoft.com>
In-Reply-To: <20230420024037.5921-1-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=4e85d79e-2b8e-4358-9752-9918b95e1f18;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-04-21T01:50:11Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|CY5PR21MB3492:EE_
x-ms-office365-filtering-correlation-id: 2475bd77-9985-4021-bdf7-08db420cb536
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EtWQanI1F4FV5knvFx0BZms7tDc/OtTsjzcqyagyBASqxe2nD30XMXJiVSuH7PLtVo/EmIdE9Am+C4oegG5RIqEFVbiIcNjl7/CWffzKi4c9fLq0vGsxw9reF24j0RnM4Qoq522iESkKj2nxMxNyDj+uFLsjhJWzasXBRynPk68AvU9N/DKkZruMo+s1NBqRZFM9hxcyYYfC5xLHN3YZzxlGfLBIfVViHYQm9dOoCFu7vNwyk77SrVVTE+AWrMgb/Jt3HSDypkf5vbgQZV6ti2Wye67jn7+EfROQmQZGzMQVU5l9R38F+e/Jl7lb3XkkXmN9eGtmtaLVmT7g8cDqDkZRp6vs11jyuQXahjlMfwVPObvD5bsR0jDlmxWcVb4EYeZ2yk8j6akwDtaez+BV77+Cc8BhESjSwRe/9tMB2Z9g8iHV9nnpy+NQ8i6fbSjpspVDMxE+5MjMp9eGRTilwQtl6VYMvgnVx2ARby9cbbTa3YQjFUeF74cY8e90EGLT+pB7tcibbWN/4D2ELUvMrADguiwInE6ZE1+8F4eFZZ4Umy/YVhEhzzfjBciSQymmhHfI9zm5gsx1wS66RF/n+uJ08t5f2Fme3hRjV91Q/KlQC0t6sbCyCfzIo/t3L+uG5Y7XhkaGdGw6j1cc0el1CSC9dQXgjZmeSwUZj8tI79M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(39860400002)(136003)(346002)(376002)(451199021)(8676002)(41300700001)(8936002)(55016003)(2906002)(966005)(38070700005)(8990500004)(52536014)(5660300002)(7416002)(83380400001)(921005)(86362001)(122000001)(54906003)(110136005)(478600001)(6506007)(26005)(9686003)(7696005)(107886003)(38100700002)(186003)(33656002)(82960400001)(82950400001)(71200400001)(10290500003)(316002)(786003)(4326008)(66946007)(66476007)(64756008)(66556008)(66446008)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dGwqsgHJTh8he0S7Onb2deAtJz+Oj14JCjlwTodKbYRmZsFWIoQfMyYMHlh2?=
 =?us-ascii?Q?h5B2VtZKENQ3IrjQmqfvTAljJek9djoB4yS/1Qr18QYllorLXZev/9RscjXc?=
 =?us-ascii?Q?2jENAmu2JYbdfZjN2O94zX1QyBBtuvoRCVnUXm3f7Cr+VYoRZcQ8rgmKGLFm?=
 =?us-ascii?Q?yOJMLIVv630VTggXty5oAOOQLGS4BY6FbCVm6BKAJqk3S7bYzEzj4xx1SHam?=
 =?us-ascii?Q?r19TmtntCyFgA439nzbWoRzCYI5Hp3zvUOYTHY3UHVEKLXrHTp/3O5sHrjZA?=
 =?us-ascii?Q?eI7zZJwnK1ikKQltpycZh2KXd/v7EZwsXT/ZHx0FU+JGtI9jMA6ffsoFM+02?=
 =?us-ascii?Q?w8M/GGiR/96D6d+pjZvQ8BwgPaApL43FgHYmzFtmjMh8QP58J4R0D+1YrOpu?=
 =?us-ascii?Q?P6udxKxfBmT0ME2SIbrqgqGrEtL5iASJ49WAq0xMhSTLo0rmkpBkzln0EDqb?=
 =?us-ascii?Q?MQ32gBkXbn8rKIxLItGhqb03lw4u8AsVM7uA17HUcjOVpA0udhwF7upPTX0s?=
 =?us-ascii?Q?1STKS+QCosbPS628avYcj63OHPj3/R9OIB5c+RWW6UWH4yUEsx1lDrWtUjA8?=
 =?us-ascii?Q?MOvs0K/HNzS8upejjt6xe/YnQ9EwMnB4sfc6Et0jaycc1ANaTtOugOKcPwLK?=
 =?us-ascii?Q?Il9+LUniHbfi8qciVdEhg0P7SRrGFv3Bayr07KhoKDqrGU/pWH3vLtQe6Akw?=
 =?us-ascii?Q?3kXmzYta/4cjnu9Nnq198iv7nZlhIIft5IbH9lPQgjRKxj/aEm+9+Ft3IdWI?=
 =?us-ascii?Q?Zn+Bhb1QuMkNe26tzT9NraQqZvr7oShGjikamIe2MccGhYJdH6PNXRRJf6ED?=
 =?us-ascii?Q?UtobistWPdbRPryVvRZB87GuZh9Ng/F2IXu+LEVjxWp13vHR3jFQxSHpHBhv?=
 =?us-ascii?Q?hpR94dk8v7LIi7kqHtjCmkDaLgnY0YLzZdFEULmcLSnt4w7SalVJuzjqHq66?=
 =?us-ascii?Q?omtAyera1gjpE0zfbR/LiouET1Wp24A7LpAc08ztN1onMoXHomAQeuYyF08/?=
 =?us-ascii?Q?j3Nmu58Qmy7ZkUL081jHqcrAnFH59DaQjIJISIPYetidVXn4skGHJt8CCCUy?=
 =?us-ascii?Q?u7rrF5RK7Fr+wyydzzWRpg04Am40+P3mrvASD5Q49RcmDlPRcGQMDJpKMqs1?=
 =?us-ascii?Q?RqC2G34lcTPef3zEnqvKuAETNVB56wo+RRmU8ESTzFpCLUTYVIjOYAz1KBKQ?=
 =?us-ascii?Q?SZhISShKUWWZ7PkKmHiH5QLH6zbfSfvjpICjGc/UP7jI9UNXHcMD8yuFTo5K?=
 =?us-ascii?Q?olzHSHgPHadUsa0GTe4BKLCqIt8zuKSIzoMNsBf1TaUivvTXKQh1p70NiXh5?=
 =?us-ascii?Q?TPBW0hAIc7wO/op+Oq8/KiC+zhTipVElII5xpUWN9XIkE4M7vma1dIGFBFxj?=
 =?us-ascii?Q?4l/figzH5vtWjaQVO38P+hc8wz4oUkD/l5BCUFKBr7HUtgqmFivoXBcziy90?=
 =?us-ascii?Q?qmxsI1teCfgxLAXgHjkEH/6Yx5uSTvDJhDYYtjbh2iEhTiiFJdv3xcPhm0xf?=
 =?us-ascii?Q?EPGi087NPY19lBQdStVis1npYs9BZ3EunUqfzfzuCFLRfAYr16oDDWdBmnyo?=
 =?us-ascii?Q?nD7m7ZKsm+R81Sq9nxRbqK4K72+ZVus4KDNfsahH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2475bd77-9985-4021-bdf7-08db420cb536
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2023 02:04:15.0093
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dWsxn/ofWogrx8PfoMGOFX+5RqfdKCuinyIlW4M5e41z5KLnZxyVWxpIWjrNvtp5dSVK/r7kZvP5pXHH1x1yow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR21MB3492
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Dexuan Cui <decui@microsoft.com>
> Sent: Wednesday, April 19, 2023 7:41 PM
> ...
> Before the guest finishes probing a device, the host may be already start=
ing
> to remove the device. Currently there are multiple race condition bugs in=
 the
> pci-hyperv driver, which can cause the guest to panic.  The patchset fixe=
s
> the crashes.
>=20
> The patchset also does some cleanup work: patch 3 removes the useless
> hv_pcichild_state, and patch 4 reverts an old patch which is not really
> useful (without patch 4, it would be hard to make patch 5 clean).
>=20
> Patch 6 removes the use of a global mutex lock, and enables async-probing
> to allow concurrent device probing for faster boot.
>=20
> v3 is based on v6.3-rc5. No code change since v2. I just added Michael's
> and Long Li's Reviewed-by.
> ...
>=20
> Dexuan Cui (6):
>   PCI: hv: Fix a race condition bug in hv_pci_query_relations()
>   PCI: hv: Fix a race condition in hv_irq_unmask() that can cause panic
>   PCI: hv: Remove the useless hv_pcichild_state from struct hv_pci_dev
>   Revert "PCI: hv: Fix a timing issue which causes kdump to fail
>     occasionally"
>   PCI: hv: Add a per-bus mutex state_lock
>   PCI: hv: Use async probing to reduce boot time
>=20
>  drivers/pci/controller/pci-hyperv.c | 145 +++++++++++++++++-----------
>  1 file changed, 86 insertions(+), 59 deletions(-)

Hi Bjorn, Lorenzo, since basically this patchset is Hyper-V stuff, I would
like it to go through the hyper-v tree if you have no objection.

The hyper-v tree already has one big PCI patch from Michael:
https://git.kernel.org/pub/scm/linux/kernel/git/hyperv/linux.git/commit/?h=
=3Dhyperv-next&id=3D2c6ba4216844ca7918289b49ed5f3f7138ee2402

Thanks,
Dexuan

