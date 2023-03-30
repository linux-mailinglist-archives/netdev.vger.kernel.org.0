Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07EBF6CF999
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 05:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbjC3Ddf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 23:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjC3Ddd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 23:33:33 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238AA4C09
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 20:33:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kJK1uh5iW+Sz4PuKmKRgjwcN8SklbYqAnIF4omAzd/L22SRMvc+4sGtKbk8h4x4abk2TBUzWLN5bxNMgmkEqNoHICyt3hsOgWgRkf6+wrfhhmDEaCvw9C2BTytMPL+lZNxv5m273TsXYXWUHUDBx7tf/fnaucaguhH/wc2Bfzrd5xF0yZbJpYCVDL5/QnAkkxITDMyGwlZXeK2Wl0w9I99oWvU+ewTIWUu5IICrkf9ffNQDOedfv76Woqoqpx7DQgfgxJIqd8nQr674dpOvAqPnIa4LFjPIgXK2XRGQTsWZSZCWJxmZm4lBAWQGTLzc7GfF7dK3RlBu62gu+TGIUew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IW9ldGOak6ZwTzteZsTmvH+V03eEVu0YTeCM4vpkUS4=;
 b=VlhDsIv6Q9WXZPG6DHEzT4j9tgiBIxCwGDSa/WUrBlK964HgllEkzQXouVWuJIanIA2V6ANprwuiEeOg484K9ttlqIStrzaj/HhAFyHdqahqskyXuMvWDRqVn3fV2jGoDYYLwjxgQ+HhKR3hhLqfCY3WMAVufA0M4UZJm7yQmhQt0FotJjNar0znHZ1J/077K6xDEKuh5RLYmxubI1vNYCo3bQQ0NXba8ahtpiUP4e2LSwpJn5eogrlICj7aT6iw0gH5GJLdUXBderbJfwyt3VxdBjD3QZTMzfsUZWVn2ZXLNjkI8KAZnOEsRDeFEd+AneBUV1vjtUY5PaKB7vzLtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IW9ldGOak6ZwTzteZsTmvH+V03eEVu0YTeCM4vpkUS4=;
 b=OPSEXCGlDLpyaRrTmDqwuBK4zaG9AbZszJ77HN4D/7P7A8D7gV4a97XS64modZRpfAWEgDXFf/ZttTR7E7jLOW9b4NRHtt5CqWIQb13piBOTp68pMk3YLWZ43Hao/FJ88vIyNLKbIKracZ4sbwcKsfdlBgN2iVYaW/5nVnLKX98=
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by DS0PR13MB6305.namprd13.prod.outlook.com (2603:10b6:8:127::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Thu, 30 Mar
 2023 03:33:30 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::8795:a7ba:c526:3be6]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::8795:a7ba:c526:3be6%9]) with mapi id 15.20.6222.035; Thu, 30 Mar 2023
 03:33:30 +0000
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Louis Peens <louis.peens@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [PATCH net-next 2/2] nfp: separate the port's upper state with
 lower phy state
Thread-Topic: [PATCH net-next 2/2] nfp: separate the port's upper state with
 lower phy state
Thread-Index: AQHZYk07XTN/U7MQDkW8TxKgBUt5LK8SI4YAgABrcdCAAA6tAIAAA8MQgAAE5YCAAAReIA==
Date:   Thu, 30 Mar 2023 03:33:30 +0000
Message-ID: <DM6PR13MB37058BF030C43EAFA45DE4CAFC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20230329144548.66708-1-louis.peens@corigine.com>
        <20230329144548.66708-3-louis.peens@corigine.com>
        <20230329122422.52f305f5@kernel.org>
        <DM6PR13MB37057AA65195F85CC16E34BCFC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
        <20230329194126.268ffd61@kernel.org>
        <DM6PR13MB3705B02A219219A4897A66C5FC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
 <20230329201225.421e2a84@kernel.org>
In-Reply-To: <20230329201225.421e2a84@kernel.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR13MB3705:EE_|DS0PR13MB6305:EE_
x-ms-office365-filtering-correlation-id: 424d29a6-7a31-4539-d833-08db30cf87f5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tTAoz/i51qmSg109aTH8aIjOIyAjBbZcXSBtYsopsRTpfoPMxDzhwga5q5K0E5ZUn1c+rx1EZBWCaIPEdDV00kjrtF4SGMt3lpoILc8PheC4G1W2oNErXxK3YrDCniEeznz9IvTatc/abwFHMmL60ZqG61gR7cdgYw4Qqspncpu4mIskFI85hXFrqstZxkar42SOvG57PzhnsJbsoy3lGyR2ZbNJchflVe1gEXptAsvqYMWeqXG+D9zkrHr3iE5CW0n5CUmt4A9Jpk4qMGkErlAdATsAwSXwkEWlO3yJlYG1HWozeWkCye+LRfr3EE/RVbl5c06bJxkXowoQ3W7LfD/JZxg/DLiDbbaXe5cYwpmzxoSGsI11YJTrIg9Rp9qqk3nv0VMu52BTslkrhQAGEFYRRlfPKJz8a+cjGHZzo9qu+uMDcVzCFJcbyG+dRquxVsNTtvA9vLJ23lfLZdZLvbjPzEpDlLOgsbPxUUITqMGyaDbzejrpP2tw76VaoJL6+auvgQdNuy2ynQCOWvlthQAotMpKEHUNDE9ngHtAJDI28HGfnXB9wF/DmTSH1/AtFqhHEF0nClMAL7QjJuctLL86ztQYDZXZdgBIm2bFlgHTsk8IlH0aAT0lAZj8miljp6QoqU/FcwipXMALiVsgjJsFt9lyZipPc7qRFxmRmFrE6/tJI4WkUhQmZ2MnEyPx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(366004)(136003)(39840400004)(346002)(451199021)(316002)(478600001)(54906003)(52536014)(86362001)(5660300002)(122000001)(8936002)(38070700005)(4744005)(66556008)(4326008)(66446008)(44832011)(76116006)(38100700002)(66476007)(8676002)(2906002)(33656002)(6916009)(66946007)(64756008)(6506007)(41300700001)(186003)(107886003)(55016003)(9686003)(26005)(71200400001)(7696005)(20673002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FNvJepnQc7DEITYj37MROLtvXQYC/Tp3xumK4+nvg23nmAR2ru6DwwNdh6vS?=
 =?us-ascii?Q?fQ1cFGwQpcoOAxu9KldzQ1ZPCljHxUtlLEpJrNoHEESF/rgw3RaAEQhc3Ic/?=
 =?us-ascii?Q?cKfquC7zDv9gi1o+EG+R9CPL6O5UA8mv45uaFmBNpH8AeT3TkuaMJCyMnpV9?=
 =?us-ascii?Q?OHMob6csHdbTuqQkct8VSOcqgxYmJxW/F6QWpxRoc+VQDil3e78uMrd3F8k4?=
 =?us-ascii?Q?qh9hHlzC3OictpB7J70q5i4U7pdU00J3bRFdH15VdtHozGSOuz/fcz5aj8SC?=
 =?us-ascii?Q?EID+509pwWihmLy3BlYRUb6optAXLwX4aFdLpGXZotjtAvAgB9maGWIQpPci?=
 =?us-ascii?Q?BPilmvaEcpX2UMxE6wtxcXNkDrLMYwBoiw4FCaXb6lyyIF9/smFA4QtmLC/j?=
 =?us-ascii?Q?JhU+2NlTJK8llMGyttOXNDYGB7UELw+4Vuz18/Qt3jOatdM/HZE6bAB4YsE/?=
 =?us-ascii?Q?ck6H+ZrBzuTP+MB3LiKnK0TuVPym8eeL77V/tGPC4jW/X4zzIC65rRqFb0j1?=
 =?us-ascii?Q?EmB69qu44m0/VZVSePkwcL14/AZXPJWwUIT1+GdlDWR2l1Te6GfGGoDOOB66?=
 =?us-ascii?Q?qxVr43on9UxXAKnq+iDSGBx3Sjq1pGlhcuogbKLdDf5Qax1SkTVCSj6scged?=
 =?us-ascii?Q?aXPDLxy51k1CGYvQj/rIXRbysUp1vKb9g1J7qDmaEFCDsGjTh73T8bzCcKua?=
 =?us-ascii?Q?dLUM7W7WG0MUNP/Afb/NVU98BZmNAyUVlBCou+/YdGwRprBnQ6y6AFj2gXAj?=
 =?us-ascii?Q?v28phXL0t8UGwamzmhKz2WDtWraWAJU6kb7lOi6UVkRsd4oMfzOiyrEVyVZ9?=
 =?us-ascii?Q?w8SZ4QLRZiTaiQWjApMX/0bePZxnMUmH4X2kgQuXAOxCg28Gn9dfwXfrAWQL?=
 =?us-ascii?Q?91Z2mUW1+Ksy7783geJFav5PcAHbTDRiFS3hIG0e6qCO+6njgPgKa8dQ1qpe?=
 =?us-ascii?Q?janZ0+F06+7SMR79b2X98bp9MO5uLfkrHQQ/XCUcoNyA3BM9hHRQNatMVRVY?=
 =?us-ascii?Q?8su3JwsN9/DMBpjG026uNIlEv4tGt7Aft3lZ3Q44O3JCFk9EvpMO+ahVjCkB?=
 =?us-ascii?Q?7h2f4oOAQ9ONfVfIOSQEsQ2RzF1LsiPiW/roYpI1cfGwGbCgR2aw5wAAQfpd?=
 =?us-ascii?Q?aDNtG0OovIXNE3LM/1JCYmzvYal+4By1yXMmZeqiD36tdXunaBTUBFYOrIMk?=
 =?us-ascii?Q?Ad1a78tRhVQEsB6rrVlXjLAKWAh3UgcolkBMgiI2WMGvwQeAR29/umVjYZ93?=
 =?us-ascii?Q?5pHzM4TDD0EOcQ0rPXff+7gop+y7U4ABkeksl6Qy0VPfZ4uk8ZUTdhn8RTlR?=
 =?us-ascii?Q?3BEN+apweqPDNfOn0EyqJl2bYF0sGDFfn1+MoqYRi2gh8tfoXG3ZwiWWOmmw?=
 =?us-ascii?Q?ZW+sZxmLH717Uatp1YpI/vl6EuSQfxeqo1/86yMYEp2LPG2jFZE1VwkegTCv?=
 =?us-ascii?Q?MgI5e5Me+9d4cNtpBiNwmpndAS1dPPnckjmq02pJm/P/+Dvtirdz9TowCUDg?=
 =?us-ascii?Q?AxeYcdEGhvD+sB8kJaNnunNtMDpVZLBjaiIjrZvtGVD3Ixeo2K3BGwzFG1G7?=
 =?us-ascii?Q?Xojrnsm2pRu95CpL7t3KuA45fJAM4HeYeDfSsRqy?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 424d29a6-7a31-4539-d833-08db30cf87f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 03:33:30.0342
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gcDVUJTZzXo91Q0Esi9toV8Tmzs3G/te8d1d4Vcc4a7KhYKo3GltcqdC4vrCnQudmotfX8ua1m6uJ76ckKM53pm9QcB43wc3V1nuticatxs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR13MB6305
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Mar 2023 20:12:25 -0700, Jakub Kicinski wrote:
> On Thu, 30 Mar 2023 02:57:34 +0000 Yinjun Zhang wrote:
> > > What is "upper", in this context? grep the networking code for upper,
> > > is that what you mean?
> >
> > Sorry, it's not that meaning. I'll remove this "upper", use netdev stat=
e
> > instead.
>=20
> Alright, so legacy SR-IOV, no representors, and you just want to let
> the VFs talk to the world even when the PF netdev is ifdown'ed ?
>=20
> Why?

I have to say most of other vendors behave like this. It's more practical
and required by users.
