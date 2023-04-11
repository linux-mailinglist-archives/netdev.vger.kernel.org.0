Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58B5A6DE285
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 19:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjDKRb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 13:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDKRbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 13:31:25 -0400
Received: from BN3PR00CU001.outbound.protection.outlook.com (mail-eastus2azon11020019.outbound.protection.outlook.com [52.101.56.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7090B5BB5;
        Tue, 11 Apr 2023 10:31:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mOLujY7HIeYRD1wYkpNlFYPlNeOHjU6Q6fTUW8ux+vTd6PKgYPrgi0T6Il4PKdKUJfkPDDqTotQMsfwK7M7KB8x4Vm9/vjCNlui01nIo0CzF9m6YUrahJLEYs/j5e36eQZZkd2skDKFtsN2zydVdcbpRUfDQlaG+Fb7jJPnnwomqbUUnaNnGc7Ip7rKdgsb1hpjx5cwHMqbcFp3ck/+8ius7C68ZwHwjjlYKbfdW4Wbgr+TkrjMAToG+v2YlI6lMRk0PwlQ/CNSyXQek1/vEzAemjFjkDZoOoEVaFtCZ8M9Dx/zAfwwlPb5XuWAzjG7pYrUcllN/LtgmlN7o0EMykg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=srzIySN1kkvZcHqxyUMKsLLFBBMcduHViz5FvXaoD3Y=;
 b=cnCUE+PU1u8HpA1eOMHJrp69gYCJ1z/A1y/7tAEzvNhWNbpwkP5YrCoCgMAD/rTUjjRmZb4XJBPoLovToasUh4Q8+KJ07+GoAhaEEedNaltwviq4JRCoFx2RtWc7/FktCskR++cdkd78XuGSnnk7frQ8RcX+Dw5TzuQYpBJmQnLkBKwFiXzvcELY7TltThlXob5WjsfUfZz9FtTBpYLDStcNc8MYfzTrLXKKDJXP16hgNRbztVhuY1hxq0kqIk+Ot18FBrezKBFVvhUNiZGSINQKjOj0hZnklLD6/Xofic4IkggB+8pNfQZ+jBRUqpj5vb1f4NzGiF2PwN+NviikQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=srzIySN1kkvZcHqxyUMKsLLFBBMcduHViz5FvXaoD3Y=;
 b=X2TAOTeHkctncW6nOF3VDstcDTU/fwBWC1kNOHdGVOlPu60B85VpmGPR35u55LPHvnXGC8RJ8zLCOf3VIHq9Nde/3wxobdB3IDHuUSgKO973lFKEukfRV/+5UAWF9QTXZiEv+95ivx/1YZHxQFcLNPwj9ZjEAGFWM87Uqvc9lnA=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by SN6PR2101MB1327.namprd21.prod.outlook.com (2603:10b6:805:107::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.3; Tue, 11 Apr
 2023 17:31:21 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::4d56:4d4b:3785:a1ca]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::4d56:4d4b:3785:a1ca%4]) with mapi id 15.20.6319.003; Tue, 11 Apr 2023
 17:31:21 +0000
From:   Long Li <longli@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jake Oshins <jakeo@microsoft.com>,
        "kuba@kernel.org" <kuba@kernel.org>, "kw@linux.com" <kw@linux.com>,
        KY Srinivasan <kys@microsoft.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh@kernel.org" <robh@kernel.org>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "boqun.feng@gmail.com" <boqun.feng@gmail.com>,
        Saurabh Singh Sengar <ssengar@microsoft.com>,
        "helgaas@kernel.org" <helgaas@kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2 6/6] PCI: hv: Use async probing to reduce boot time
Thread-Topic: [PATCH v2 6/6] PCI: hv: Use async probing to reduce boot time
Thread-Index: AQHZZposLyPmEnK8/0ezLJ7cpG8SzK8gCgaAgAAA2gCAAIiLAIAF1f/A
Date:   Tue, 11 Apr 2023 17:31:21 +0000
Message-ID: <PH7PR21MB326385AE4EBCB897DD4959DDCE9A9@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <20230404020545.32359-1-decui@microsoft.com>
 <20230404020545.32359-7-decui@microsoft.com>
 <BYAPR21MB168842E38534BD00CB1D27ABD7969@BYAPR21MB1688.namprd21.prod.outlook.com>
 <BYAPR21MB168864316A9E2523BD74F270D7969@BYAPR21MB1688.namprd21.prod.outlook.com>
 <SA1PR21MB1335E6B2D4D01649712FBF96BF979@SA1PR21MB1335.namprd21.prod.outlook.com>
In-Reply-To: <SA1PR21MB1335E6B2D4D01649712FBF96BF979@SA1PR21MB1335.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=4268d2ca-a28f-4b1b-ac19-612f0da0821a;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-04-07T16:10:36Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3263:EE_|SN6PR2101MB1327:EE_
x-ms-office365-filtering-correlation-id: 0f98c61b-338f-4e0e-f227-08db3ab290cc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ue+y3GlYW2j9vq6xGDEKkndHrp8dmoEnprnULBh48CRED5cVVkOIhuB4ozyKVj3hhdGo7VPuZIVqSkV/FqmaUSPwb6HYZtE/f9v/UoQ7rbpkRAwVxncN6w/d61iAC+pons/bJKNCteg/ZuJNSgid8QyMx4e96et6kdXV6Mo3M7YgGXoQKMMQzjE7KDaSP75NaHd9lhV1lkP9I959Jcbc2BewpkqvNfEodMHWXaADLX6G3gf01DPortVvTbFBmjpA4yBYqDvHQNPq771RW2g3xWTCKcMvXlN4mtCjg8ZycdRBul9hoefUxlf8OMYfpDf9qb8B9bvf7LodI8v7Qlul9w7DiZzEG2vuuMCNIwxYjOvEDnFxPljKCMC/xjhfDuaFM8zrO550FfCLBi447vOjM2fuatGHebUnUR0T6q2FKMrcKuxL3eKRkN+i0slvW8Xydi1Mh/9SvbtG/erMXMK+y7aTTp0xenE+XUFEOOG4iEPL5F7TUSA545wAIoxQG6HZMUJvv9JkdaRDQggjifORS4JXYDEN2yLn+S0tJBGMBtdP11dkUb53JmT9rBfiQVfSZuySC35s7kOmv9S3ryWrqqMsQPur65THX4tUIFz0nYy0C+eV0I30XIBcsyL/m0riy9tMLzbBgyMJhligPL1EdQRzH9tTRNJgmUabqIHfqOgMGHoVTJeeeB4f82yC5/JN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:cs;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(366004)(136003)(396003)(376002)(451199021)(8990500004)(2906002)(5660300002)(52536014)(7416002)(8936002)(41300700001)(64756008)(66446008)(66476007)(66556008)(33656002)(83380400001)(4326008)(8676002)(76116006)(66946007)(10290500003)(71200400001)(316002)(786003)(7696005)(478600001)(54906003)(110136005)(4744005)(921005)(186003)(38070700005)(38100700002)(55016003)(122000001)(86362001)(26005)(6506007)(9686003)(82950400001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?U7axgaDQzR9WOI7CAHIe05VUK/q3yZzUtCmJfbQXQgfWq3che6DRiKrkj0k1?=
 =?us-ascii?Q?u4yAuBjQax+NBOsm12KDk8ZUCs4AKGFHkqNLjjVPP/oRe8LBKTxaXl4Y1M8g?=
 =?us-ascii?Q?TicqnUnoe5mUCsTNuz/YQCQ33P91+Acbx9LKQ/rFGjIhWNIgaD4SrmxqD5ik?=
 =?us-ascii?Q?c3L3lr8tf2vqY0S/6l7wqc1T6NBi7XbufTJQg1dvI1SRw4AAlLebytkacI3U?=
 =?us-ascii?Q?u29plfsjzmXEGJUjDswHxigOuIt83tDhuALYrwXsmS+Chp6xloFbFeQhS/cQ?=
 =?us-ascii?Q?RhbtUv7lVDRXjvuItCLTX6YX5BZ9TiFncXOdTwiZ6W+PKU5jJ2yn5zS8kq0P?=
 =?us-ascii?Q?dqUZzJPyutY2O7bbkUzL10h/sU5VO4i6W75IgQhFQsPiUfcDodW8RiII+pGG?=
 =?us-ascii?Q?siAj8VQosGFF4lEFHhCYDDWrA/lCAb6cUi8zZqqzyTPR/O3cU3Pfb395GHQO?=
 =?us-ascii?Q?RNjFbttmbBQ5Qm3d4NA8eEwDVCSt6Ia+2yxtRQ2f4z+kMekf+iuC6RYTvSs3?=
 =?us-ascii?Q?o1WevULdcr2Yh+howIyv0W+WwKO4nKsVPSH0noVlsi1b23Bf4B68JIpycAJP?=
 =?us-ascii?Q?Rr6pEFc15IESVU91OsLWMgI3fJhqUFqFuNEHO1PofivDOhRBcOcQ4wqVx4Yq?=
 =?us-ascii?Q?cSdgwA3ygj4cuWR6Pf20Dpk06pjaxjoJPtgMvV48xlefFp5kVpfaMG+d1h8D?=
 =?us-ascii?Q?+j9gBfZRQWvYV7gnav5cLIHjN/7ZuslNAWrGAZY4psUN+ARBUBfcpdkSN0xA?=
 =?us-ascii?Q?ikElVAktNszF5iPsSSWExmJVIYF1uQGhg7aEQIz3kDnV88+BewEqWvxDuWTE?=
 =?us-ascii?Q?VqPOYJMNL8i74TqzwCk8/muEScoSOEcDujSFvgTHlqVsCDqSdKpC68eVY+Um?=
 =?us-ascii?Q?zvFJR5U5LLIItNNgXjw0iT6BZwwW5GAkZc0iy7g+hXTTlGqlQwrcjPup3Q/P?=
 =?us-ascii?Q?qAAMDjf4seOhzudy2OsmUMIzTkI/dCJcRa+cMHbwAeK11MS7esxPirE6Qviy?=
 =?us-ascii?Q?n2JyG0YTJlgW92O0EcFelZ6NnjJ3m7ZiQfRejOp4fmZ5kzMkquTFbViRshiW?=
 =?us-ascii?Q?asVjeOp9vIeCbzY28kWKEdzjZFXosDgOjNMIyz9YFKLa05uipsDk0/2gzRnJ?=
 =?us-ascii?Q?fvAI+hFVfTNCZFjPjEH9j0HlvVUszah+qBrKrx4HQoqYv6re1ENsEoqxNoIY?=
 =?us-ascii?Q?p+4NjVo7uxJ8EUfPwR2omahXtKLWesvHi0TJFOm5a9AUeaZ6oR/GKeA2yYii?=
 =?us-ascii?Q?BbiEdqvW1ydtT2p/2v94oQr5vorRmWyotPICfzVX+aNo/N+OSpqLgK7ulQVM?=
 =?us-ascii?Q?t74LdWvWrEFy75QcZXZPPC580gIaCUj/yccIa3oW1M+yf8rlySonrhcIq4a+?=
 =?us-ascii?Q?3lVAMytGpJAwgtuu5Dw1wZsMs/jLrSvg/Eu1/D3l9/dlnTmG7ogQM7i3yGUN?=
 =?us-ascii?Q?RavuBHEFd7eosUI+yprSojpuSAW5BJ9OWUereS7imb9b0r2ocpBbAybJ0bMs?=
 =?us-ascii?Q?uTHbqJfxYOqAICsr/w8vwof2NLCNlNac7skUSujdIZHVP37y75md5nAoOAT7?=
 =?us-ascii?Q?w6Wl/D9Lmkf9+UHNxrA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f98c61b-338f-4e0e-f227-08db3ab290cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2023 17:31:21.0536
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CUYwWOyFm+TuNO5stPYAFHHdS0OFt6TAjFSdO5JdZJtk54slnKhNqJSXfkSZGEYPY3C7RIJ+XfUCzkRQqeBZlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR2101MB1327
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: RE: [PATCH v2 6/6] PCI: hv: Use async probing to reduce boot tim=
e
>=20
> > From: Michael Kelley (LINUX) <mikelley@microsoft.com>
> > Sent: Friday, April 7, 2023 9:15 AM
> > ...
> > > > Commit 414428c5da1c ("PCI: hv: Lock PCI bus on device eject")
> > > > added
> > > > pci_lock_rescan_remove() and pci_unlock_rescan_remove() in
> > > > create_root_hv_pci_bus() and in hv_eject_device_work() to address
> > > > the race between create_root_hv_pci_bus() and
> > > > hv_eject_device_work(), but it turns that grubing the
> pci_rescan_remove_lock mutex is not enough:
> >
> > There's some kind of spelling error or typo above.  Should "grubing"
> > be "grabbing"?  Or did you intend something else?
> >
> > Michael
>=20
> Sorry, it's a typo. The "grubing" should be "grabbing".
> I suppose the PCI maintainers can help fix this. Let me know if v3 is nee=
ded.

Other than the typo,

Reviewed-by: Long Li <longli@microsoft.com>
