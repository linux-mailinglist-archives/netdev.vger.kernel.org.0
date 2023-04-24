Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEBBD6ED656
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 22:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232491AbjDXUuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 16:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232063AbjDXUuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 16:50:19 -0400
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021020.outbound.protection.outlook.com [52.101.57.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C790F559F;
        Mon, 24 Apr 2023 13:50:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IwwhDBQyS0ODFx0FWE2H2OOThbJxbEyxeshtMMGuIHLm+FuSBIy47/9zs5cNScnC13zeZuPPKBPEveXb+6MuOaVgJ8DwmXTgcVx4dicoEViagFV7uz8NYTJ7lNvgVG+GH3aZyIIeOpRHy8RafA8QnGrVEbY4tqTZ1Cl0Qbf/K62yV7h4NbbEHGJGik1u4bmEJ172B8Icnv2d4g3pt5z+IFDdQ3KLfNgATXvMlA/heM6oIrhDNtxcA9GHDuYDgBZIAsHW7aMHV5mWz1lQRszv8C/JyfaPnyNAp3RTeaPtzjbmgz6disQQtFCXWy3ZfXdQTwLIoNmV9yN1bNDbbBqagg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=itfiqOg2lkDkLOo5QDA12ieMGbTnmqbJlJiA9ZorQzk=;
 b=eBGAxp0Ks6tjeaEnndO1q2e0D8zpeEIlDA0vQjbj9pqpV+KMJwj+0ZrqGPQIXR7b8MgEumrVUET3ZwBTkh+DhlXwqpieRKOJZ7aISac3NfnLIXiDNt09Oqh4Q7SaGxHVbSH0yVcDuoGq3RMNDLyKLy8bb9wLvahd7ybs+pJHsHb21E6fPLcQ2M8Ymq3YUuFZZ5pX/Jul7F8t7/SCCZZn4ZT13A+FeTlXXcpjwmaL0ZYLp2XgK8Vju2Ps/b8x8am3Jgu0wA+SWLI3D+RIUUDh6wVcxtpOhslnNrr1ELzMSDoF2JKKiwqkgaU/GCpAlQmKvgTKO5JGFG4d1C11WRZH2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=itfiqOg2lkDkLOo5QDA12ieMGbTnmqbJlJiA9ZorQzk=;
 b=FVkg5uB0COj4+jPsve5lVmfaJOpC0tX7AN7mwMgrKJBkyP90UTp1tGhS7BMCo1W9z6SZwRhYyqNCAjl4cg48KOnnl8z6PxjaugYCv29Ja1pP39gjkc5G2jUixXrdFlXZHc/pqzCZuJVvOoz5/eNmWkcQsTv6HG7TS33vASM7lCA=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by DM4PR21MB3609.namprd21.prod.outlook.com (2603:10b6:8:b3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.19; Mon, 24 Apr
 2023 20:50:12 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::eeed:da40:85cb:503]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::eeed:da40:85cb:503%6]) with mapi id 15.20.6340.019; Mon, 24 Apr 2023
 20:50:12 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     "bhelgaas@google.com" <bhelgaas@google.com>,
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
        "helgaas@kernel.org" <helgaas@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jose Teuttli Carranco <josete@microsoft.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v3 6/6] PCI: hv: Use async probing to reduce boot time
Thread-Topic: [PATCH v3 6/6] PCI: hv: Use async probing to reduce boot time
Thread-Index: AQHZdhdndynY9JdEwE2LUDobn6ASSK868AWQ
Date:   Mon, 24 Apr 2023 20:50:12 +0000
Message-ID: <SA1PR21MB1335BE6CEF491596BCF62FC5BF679@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <20230420024037.5921-1-decui@microsoft.com>
 <20230420024037.5921-7-decui@microsoft.com> <ZEWCyaaq+wzyyQp+@corigine.com>
In-Reply-To: <ZEWCyaaq+wzyyQp+@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=509f0bd5-4407-43dd-bf22-a1883c6b0e55;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-04-24T20:48:19Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|DM4PR21MB3609:EE_
x-ms-office365-filtering-correlation-id: 957ab6c9-182e-4cd4-4ad3-08db45057ffd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lZiE3VCxzqa183zMHu+ciEzs33Ic+OHugcJ6RR3MXpNc/0Is9G6b67Rl/nsbPGiGkFbkkIEiILHwZbZHBlZjKErAk619V0gQ5ZrGKhdd6ALuJVYQLLEdQU9AlEOs7RKPIwBaPyQpjub2O6Xkr+T2XMotnaCLErXYVRbuTPULUJDhiStW8RlHZl4pIsrf5uCFCtX7B6mbd1rInL/PiuoGMrVeMU/Li59S9PEs2AgcQoCtfnwI9W3kS2u0MTvju/Y3XDzGo9NRCgYFx/9v0XOqJRMiWm2injLBH+7D8kvpaZKPitb3I/X40qPykC4vBHZxPR8OUiR1oTp5EYZNgRlUmOMUNq9Vyrk3v5GGMazK4rlkAIOTojr+Knmzwc3Yjk9w40ogS+Rtf7t3WyGi0Avq6oetmvhuPMeFU8Py8AeLZFTh25fKHHG9PqAhNFMsND2NJ4wDxjFgwM/tt8yzFM8Fejjw08Yt5VQeClphA5N+iaLt8qJtPiI9rb+Ux0E5+NIHf5JsZRmyf72WJt0pU5eiwUbZrfvlr0Rjl0k3bftNoL3gBWvkwXNgHunqFN7pUCjPRyN9H8p/iPsc2Fn8GQiEU0cqWuIQNKC2pXnhlL4Etb2GfHpCyHHQJKY0LUvmozdJL8QiWFyp7TQl4GdOqSdUY9u68TxZKuajIKKQhCShe+0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(451199021)(54906003)(8990500004)(38070700005)(478600001)(10290500003)(82960400001)(82950400001)(76116006)(316002)(786003)(66946007)(6916009)(64756008)(55016003)(66446008)(66476007)(66556008)(122000001)(7416002)(4326008)(41300700001)(4744005)(2906002)(8936002)(8676002)(52536014)(5660300002)(38100700002)(186003)(86362001)(26005)(33656002)(6506007)(9686003)(53546011)(7696005)(71200400001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VApy4rqtsJdbNZP/lMDGUGAcVicV2ECeJ3PGXiSYdWDJq7fHsL7PusSvBOFI?=
 =?us-ascii?Q?MfHz1j45iHst4jTCTa8oS6Ym0ph7HeBTqiY+yS419CSrwwAReM53np37solI?=
 =?us-ascii?Q?O1oM53rfL9ZUjQeuCLepVb272s0iBP9U74ajqHo9NLu0B6o+3IIlxCLuHI3i?=
 =?us-ascii?Q?7Wp66aMgVAbxWsHAd3oG8wLWnISB7rQIOcKPLvIAU/HP1e2YlAFKyfRgNKnS?=
 =?us-ascii?Q?vOdrxyZ/OHORpnyQUQx5BKjxUltoqo01QTEROn6/08P/zwkxZxKT0yGcmrSg?=
 =?us-ascii?Q?9nG6CbYaomqgDvZdvzWCIiWgF1Gywo0vm0zinJ1vJP1b+3EzxgBZ2pMGGw2k?=
 =?us-ascii?Q?/4H84QmeoeXG/NQ27VDGTVYwilh/gqmDewPFuxyVfkvBFEpaUW84ny7+n7Tt?=
 =?us-ascii?Q?oiNLWV/cg9W1TskOCCSHrWGMxopwmqA2tYOT/vn/7cC+iOV+SUYYHDlhp2y+?=
 =?us-ascii?Q?uKEPd2hVlQ1K9rrlxMhzrJiBt1eWk4Wh3/vmo/wwlc/1GMmD9aKBLjmj+Z3K?=
 =?us-ascii?Q?He5PaNM2ubaQNUOXf1NAD/xDgUv0wK2I8PUOxmAZahQ9XpcyV9LGgv97eCPm?=
 =?us-ascii?Q?AyFj2jFq1iD+qanPqn8PEysEVUkmdqQXy0AzlGe64NByfHH/kg7BaKBrBKII?=
 =?us-ascii?Q?Kzp6FalF5ppiW6uGDIueicuy5flWZb9PwJ32xFBxnl7UqQbawU2G8sQH+J0J?=
 =?us-ascii?Q?cqs6Al0lqVFC2ErLQtV3Wc3NlVOp/juhgSxvED28X6mDu5Xv3FcEmFe37ypk?=
 =?us-ascii?Q?EffEFYYaGPIp322GkV9P+nPUvNaZ7geOsUclCrN8Hhr92MIoauW+lZY6uV42?=
 =?us-ascii?Q?pOzmGZDh/bWNTFbefIgletM+LIV/QQ75g3MRmgdAmJ0MmOB+9SaDax4JI9Kv?=
 =?us-ascii?Q?g0vZtSdBCH0wnvU7tqyeJ6yx9ffATR04upbIIwELDJt7dokKKxQFQje21Jre?=
 =?us-ascii?Q?jlJoaP9421/fYnjMFXRJBT8EQX1/EVCBhPkinlBYPu1WMMRfgchsKnHPPfuz?=
 =?us-ascii?Q?ldzhroFQpfPo4KTExByKxUCEAunERRwD26Kyp4Szz7IHIRLRDDgs8PSDJjGM?=
 =?us-ascii?Q?nTmeH8uaoqr0UkTKeR4gkFRHfiu6lBcDyhUFBCc+obj4ec4qgN2to/LJs7Ex?=
 =?us-ascii?Q?LEQWWCTlfhCC839EDXXeRQqGD+A243E5Sd0JZwRvYpJhSZpIzovmhOSo+Ovy?=
 =?us-ascii?Q?TGMVQy/d58PglQLZOGNpVfFdyoAEwQcmoNXBXaTxF8/EvYlbv92JDXd/jJmJ?=
 =?us-ascii?Q?TSkKlXpjSAK8BkW5MkdQKv7xtIFJVNdBi2xs4Ct/w9m59JlGSgyiRceurYf9?=
 =?us-ascii?Q?NL4MIhG8pylwlxnSZ3y5+JA+ijRyf+WRLhL2Dpnr4pCclq5iuG9zJtAcJo8m?=
 =?us-ascii?Q?bTXduePpF0GRxF/400byg1ggxjRAVsI98pybtkASK5q5DAiDF+cobZ8MC/2x?=
 =?us-ascii?Q?DVRdhc3M9plPc9yXNisNqXeIldt0I7Gk8op6+HLabmCB9HhCARdY7TwlEqx+?=
 =?us-ascii?Q?478rJUi0O6CiYRQJWyEm3BCwe7Pt2qxZzf+Y2fm9CjNsjtXrNJnN5W77v7eE?=
 =?us-ascii?Q?gRtxp+/8+kWhoRqLoDJQpyK0+PiyAmDv7Cc+c53i?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 957ab6c9-182e-4cd4-4ad3-08db45057ffd
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2023 20:50:12.7497
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FIUiLNLcArDuyU+h8icPUbynlM91VX1Ck4KkZwQOGu2xpnczpsATfsJvV7MyOCYoJIx+hRwvaunDe9RFv/XRSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3609
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Simon Horman <simon.horman@corigine.com>
> Sent: Sunday, April 23, 2023 12:11 PM
> To: Dexuan Cui <decui@microsoft.com>
> ...
> On Wed, Apr 19, 2023 at 07:40:37PM -0700, Dexuan Cui wrote:
> > Commit 414428c5da1c ("PCI: hv: Lock PCI bus on device eject") added
> > pci_lock_rescan_remove() and pci_unlock_rescan_remove() in
> > create_root_hv_pci_bus() and in hv_eject_device_work() to address the
> > race between create_root_hv_pci_bus() and hv_eject_device_work(), but i=
t
> > turns that grabing the pci_rescan_remove_lock mutex is not enough:
>=20
> nit: s/grabing/grabbing/g
Thanks for spotting this! I suppose the maintainer(s) would help fix this.
