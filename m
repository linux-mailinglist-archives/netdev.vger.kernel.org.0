Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2FEC6DB7C8
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 02:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjDHAXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 20:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjDHAXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 20:23:20 -0400
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021016.outbound.protection.outlook.com [52.101.57.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB81E1BA;
        Fri,  7 Apr 2023 17:23:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iwrHZPOdQ5yXONRw8F7b39LI9cbE0SrtbRvqkXeTSvCFklJUuJGJJ4ikIrYqhJPzUzQFaS1zQfj8JphxAsuFdrkYG6Qpe4ySq2oGmyXLZC3PjdwLexiX3gD3nvG5OHJJ91mguW2jtN23ATj/3X3qXccNuj7W1Y6ADdYPO47XPznRxRb+YxYxdhEa9NcaNst+of9fnO+WppFIy8XtJX+vulw7bb2EMwOOe/GNQ4FK8kIePt4FEwZXLV4rZj7Nu+BWQ/9gWYboXLnMWnD6gKbwWjS5T1Ajs6si5t5aGIWrfu02PVtLNoohYwiWi8/BvnVklEenpEBcy0Djr9e73qO96w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M7Fkc1nW+SxfhQTKVlWKyLTbqz1zzTzXZNIsSZddz98=;
 b=JgR/i/WdTDksk4XSxLsLmDoI9fAW+sRnixuZFCr1vex00GDI6HCjkKmZWdgzWyCyXgLcLNBS5xkYNFTjYdY1mWivx2DTGTRnuyRm6cHH6AF7zenCQSgJGfQ7P8QLSIu7V8nzVgOr4coeR1RwRe9EAesmLsN/r1sng/1LSN4xVzOHGnGuxzLfWJff8eYjno56I488V3tI9y+BeUriruN8C/Vu3HLPqbyXrMRaUH+Dmk7KT1PAeK0wm/GlOfJc6x7fpViYP5S8j1yGRgzOMNUIuyNvEycIAxFXsIgfnEw1IPgHTijIkon4gD81F0QdW2A+3fMFRmxYZHxvUZ9AXA9ajQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M7Fkc1nW+SxfhQTKVlWKyLTbqz1zzTzXZNIsSZddz98=;
 b=MW7Oxvs/vIExF2RQuWDELGNWMRgJkVR0A60ihK9DmWAWdGbncKpJnLgmH1QmejB7poI3KN7VzrMFPlCVXy3JsrBCGzVqHDISvZbVau0oQcL135Ca5hfaMqOrlcw6fbKap9KOYIMonViQwwOoecNetc7JT5o3pUH3SOZf18+QMak=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by SA1PR21MB2033.namprd21.prod.outlook.com (2603:10b6:806:1b4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.20; Sat, 8 Apr
 2023 00:23:16 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::2e52:d6aa:9a99:500a]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::2e52:d6aa:9a99:500a%5]) with mapi id 15.20.6298.018; Sat, 8 Apr 2023
 00:23:16 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
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
        Long Li <longli@microsoft.com>,
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
Thread-Index: AQHZZposgluJ48qtKkybpggwYjZPaq8gCcZggAAAu1CAAIgYgA==
Date:   Sat, 8 Apr 2023 00:23:16 +0000
Message-ID: <SA1PR21MB1335E6B2D4D01649712FBF96BF979@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <20230404020545.32359-1-decui@microsoft.com>
 <20230404020545.32359-7-decui@microsoft.com>
 <BYAPR21MB168842E38534BD00CB1D27ABD7969@BYAPR21MB1688.namprd21.prod.outlook.com>
 <BYAPR21MB168864316A9E2523BD74F270D7969@BYAPR21MB1688.namprd21.prod.outlook.com>
In-Reply-To: <BYAPR21MB168864316A9E2523BD74F270D7969@BYAPR21MB1688.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=4268d2ca-a28f-4b1b-ac19-612f0da0821a;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-04-07T16:10:36Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|SA1PR21MB2033:EE_
x-ms-office365-filtering-correlation-id: 4485effe-2601-41f3-ca0d-08db37c7729b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V6ZdMI+cB/BeZl2xr3JNQTKSa6Lo7gGOtaKuU1Kbvt+cRFxucuSrYqkjh/cC1ZTiYovkiYYLsUIhgp9b64IxqeZKTS5FMH70PG6ek8FATL+TKW0mjYLQjxkYZ3OVA9yarh/Lx2bDbonrb7BCdUeuDGlTJ9tPyeb+pJhACt5AfkIox8okaMYHHMaxLnNVEjgSYCes7vbApi3iylVw65eo3jtBuyjEZ0qE43T3CUDMEo1SkOSPXsOWvAzgwCaD94FDsKtM+f9rjR1L0jJT0hXyc7pv96QigNLHNERoRJGSLOuLStx6II+iWGsC+BH4bEEZFA8KvcVXcRAbB4sVIwgH1oc8xck1+uDWBYyci+c/zngliZcs8cj1hDDFkUJs9TeUN4fAz2awe0/aKJBs23l3lTuxFFQ9+lgX9n/7WjJp/hqoGbRseiIzIfJXN6c2QxCGZ6yzE7Zak6r/0u+cZsgyCSrMLMfBNnvnMW2LTeZslbfJtjUlLEJ6TGHt90M6QPSydYcx34d5aVrRD0/TYcuSfwnea4azxBsXMTQQYDdoarWG01uW2AOFVjjY9sfr2XCnVFdKb2TiPQkI4DDGWmmOomLV6EnQBgOdFCg5JdnQmMc5+4vtIx4topzXUtU/wMrjNdJFjKBRVo94XY1AVbbqOtXyx0E4IBKg0aikWiiZonRovTWY59cJnx5S3r+L6c3d
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:cs;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(451199021)(66946007)(66476007)(7696005)(478600001)(8676002)(66446008)(64756008)(4326008)(71200400001)(54906003)(66556008)(41300700001)(786003)(316002)(110136005)(76116006)(33656002)(86362001)(83380400001)(9686003)(6506007)(8936002)(5660300002)(2906002)(7416002)(10290500003)(8990500004)(52536014)(55016003)(82960400001)(38100700002)(82950400001)(921005)(186003)(38070700005)(122000001)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YIxaLLhX85RYOXUIKVgSiQP6t4zuDiRRwTolufbvT+qsXcTdNaazF+PcyWRg?=
 =?us-ascii?Q?peuiPDK23QODCKoP3zkHNm1gBH3P+QXP6DBlb/1H+/ZIytY7TxGb4onpU8eB?=
 =?us-ascii?Q?fUFY5sXBX4WIkE3BdbnSWegwwWomxLYGikbO1aVaMPwHcf0rWE6+Lr/B/L6I?=
 =?us-ascii?Q?eoNYkVQB+CM6Vx4XbpzN4JWeC3NEp+uiHQ+4RqZfMmgxk+1pNwXJH3BielF9?=
 =?us-ascii?Q?49mv+ZQot0ZE3+Ld8PXhQGlGSCpqL0iSCVpH7a/zGlEY4JLyWtJFCLbD3NZe?=
 =?us-ascii?Q?P0LIrPIqJxUlcRa4eBageGCHg8gKbfTVDuPpdafHM+9eTbeSx1NKh94CjVah?=
 =?us-ascii?Q?19T+S2gp29qPeWmu0ihTKNZCEWsGRAKwg19X/KGmL+k+UM6OjxLkGGcZAVt3?=
 =?us-ascii?Q?nwU1I33yAU7t//8Fo3IvoxT+y8XvFJMi4GyAtJtZRShafduHQkd7WJJemsmz?=
 =?us-ascii?Q?EELT5jkiD1cwYUhYaEVqy//dkPy8XR3/mtUyd+j1w50yjLuixglmj8IgRGAe?=
 =?us-ascii?Q?+nC2HQyyWfQovYmPvS4lvUPQE/L22geivpF8pI9As9CobuBHp8JHEIFzXFiV?=
 =?us-ascii?Q?LlGbKUF7oM8+LL0v0+43/KPZff1o8xtFS+OYgozYEsP8yymeGJMiy4fhElqV?=
 =?us-ascii?Q?NQSidBbTIB6VT1Sx9bB/q4ibc2B5B8UsmrIUNqENBxY6bjD8y3QuhMuI4TK3?=
 =?us-ascii?Q?fSD1WXvZRbOw/DMIeNjz/eiYt8AiFR18HJBU+ogSY5SS0Vli1P5ok9th8uZd?=
 =?us-ascii?Q?xs9UJj4FIOEZOHVf+96xUG/zNyHeNHrwmofISncJljSPT5rjvIp+RVddwJKR?=
 =?us-ascii?Q?eoSGWmu5woQKx4V9Ts6hES4kGVT7zQNRO6708ieHIgf4/Z3IK4wJSgXkkduF?=
 =?us-ascii?Q?ygI8CVOEzsqExGjZI39pwckjGRwZZgMFd9hTRIDy7kyhgSjPG2JmlqgUQoXE?=
 =?us-ascii?Q?pEQfXb711o6GoaYlqG+ejEPYtN0jOhHOR+UPr8q+4az/wbxdo2pcxB+mZTtj?=
 =?us-ascii?Q?XeXFGxFDmjSlq84tarpmrA8tKxkG7qx1jLN0N5+rktLmVafOuFSMktXVhqyT?=
 =?us-ascii?Q?WCjOp88zm0y3ufMv5qLgiBwZGoh47N+/b9hDGMY1oOHxlgFkRY76SsWZ0knf?=
 =?us-ascii?Q?O2A2Ktbwjyo2DIwf+lafkoUUTwHuv3Pqk8KnOTjSb3jbshWnSNBEZ4D8dVcl?=
 =?us-ascii?Q?S7GOi5APVlcbmgv0/KhL6oh251DDfxUGlrtwO38SVbYsVRJVrtHAgogV2/c/?=
 =?us-ascii?Q?9/ahgKI4MoTxcR0uWBb2mxCjmvEU+tdkwpNkccNjWJi58z/h8Y5p4IrD95Xw?=
 =?us-ascii?Q?nGo3dy82gA11SgQwtK9P75fO0pTlIRaw5AJGlxxdp5ADoxGQzbj1q8MwFSz6?=
 =?us-ascii?Q?adVjy4gO+ovQn8Rmo+uqB0ne2ob3meykVBJr3dtkl72jE/qLIXFaru/6zVBb?=
 =?us-ascii?Q?fM/5ajUq4PmZsXAFQzlh6Z2UWWxk08QCD+wkBjDYql8llBUO2lt5Fdhsx58N?=
 =?us-ascii?Q?5jfCb7npvpYr/Ya9y5mON4LJv+sVM4G2SYHxowlYtbBIYvVT4vRHur2i8Ghx?=
 =?us-ascii?Q?B1PCM2Bly3RccYDs54oiHW3Toepd5SWZsDGipGpCE9K9ZoMNSvJbY2c4fkp3?=
 =?us-ascii?Q?7ls3n9kVXr7kkv2uhRU9xXI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4485effe-2601-41f3-ca0d-08db37c7729b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2023 00:23:16.3766
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X1zspvVjFWzsPBETOukweE4lhuEW066TQhneXWMP5WLZRpix+p2tlb1iRGFuNIl95fo1xL4QtxpYvTNMX7wPeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR21MB2033
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Michael Kelley (LINUX) <mikelley@microsoft.com>
> Sent: Friday, April 7, 2023 9:15 AM
> ...
> > > Commit 414428c5da1c ("PCI: hv: Lock PCI bus on device eject") added
> > > pci_lock_rescan_remove() and pci_unlock_rescan_remove() in
> > > create_root_hv_pci_bus() and in hv_eject_device_work() to address the
> > > race between create_root_hv_pci_bus() and hv_eject_device_work(), but
> > > it turns that grubing the pci_rescan_remove_lock mutex is not enough:
>=20
> There's some kind of spelling error or typo above.  Should "grubing" be
> "grabbing"?  Or did you intend something else?
>=20
> Michael

Sorry, it's a typo. The "grubing" should be "grabbing".
I suppose the PCI maintainers can help fix this. Let me know if v3 is neede=
d.
