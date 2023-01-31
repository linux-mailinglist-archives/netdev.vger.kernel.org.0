Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272576824FB
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 07:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjAaGzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 01:55:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbjAaGzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 01:55:33 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2073.outbound.protection.outlook.com [40.107.243.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9C82884D;
        Mon, 30 Jan 2023 22:55:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KGL50DQ+1aFidIUQ86WDRWizse8rhxloenIkvdOJduew/Ay/KY0vuvRvbwZTBlORqdhv07kEumgzaEp8UlO9YTvDV9WhCsxuoVE6zgb2a45alZzEGB3t4AybeMDszBcai9ErS14bCotdQv5Gcaa9W76WfcKgIRLlQ3zNdFWKOr7WMKcOy+ct8aSTinrlHQc/MuZ9zYaqorfvhobDWE+srPNozkZ8yiK0MBDVlonLXjxVg3ZrlYiYfKLIGBZC11RQT5ftZ12Hlb2zwMwVKNVt+Jwv/rD0ib8Ag/iDId/vAkmjH4FzL86JtZxSZvlvL4zEj4GIL6M+mOc18BLvgKypyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9qhXp+Vdx8rt0vjOk91HJoBeEf8j8VK/l+K5GcluMLk=;
 b=h9ggdfnsFOdDCRQWQljbW/AMJzNZ/3SCVi2wVhBf28yEc1YbcRNHAeYPwDoA1z82ZWLjqpsBHDBwyb+PxGvJ/10ExRIAtOABNQzmPQI3zdIyfcGZ3VoHFg8B8r9p+hMzYZUgx2g134GRfQaTkY13aHp1BoGz0BMtzXK9ZoKa3H/wflqH+m7PvgPf2mYZ+mK6RixCHkRm0t3k/ORvPX+r+49FMz2GL5sXErdzcGuwJHxLwN0cqaBjf4IFM3/bqX2rEWxTccdVJkXtEtvgp1Tk/r88q9zyqrvypnFYtnK2769yOtnZZUfEnCSG7Eihq8ZfhSCuk8xi0ogxHeqUmpIm+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9qhXp+Vdx8rt0vjOk91HJoBeEf8j8VK/l+K5GcluMLk=;
 b=YEILJkxeWqt5TAzFyen911Ti67K4Z7DPNpYpFTibFp2oxosE7R8bii7reiJIVB5rLTegpOPBEi69BHKr70eYijWKiRj23YKMqW9i8YWT2DzKDdHfA5zvHmXMQnoRn6324whVAV8r9hXQJ74Se8zI+SpD073wwBcgHqD2bZS8wU1g0AdYPtkNYaNkYOMuct9BuIcnImt3ge3p2FV4986XeC6Gq4DuCxlppvknLwGYvEnffCVdBxSjSFAj05w2tdTg37gR36Nlsl54z/SkhowNGzsHS9v84I+hSfzia0Qt6Cu7WrN0qnCRNTT+tytYfVtQeaSFubjuUOUfA3hrkj+FBA==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by IA0PR12MB7674.namprd12.prod.outlook.com (2603:10b6:208:434::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Tue, 31 Jan
 2023 06:55:24 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7%2]) with mapi id 15.20.6043.036; Tue, 31 Jan 2023
 06:55:23 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     Ilya Dryomov <idryomov@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Xiubo Li <xiubli@redhat.com>, Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Mike Marshall <hubcap@omnibond.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "devel@lists.orangefs.org" <devel@lists.orangefs.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 02/23] block: add a bvec_set_folio helper
Thread-Topic: [PATCH 02/23] block: add a bvec_set_folio helper
Thread-Index: AQHZNIxeh/gfUAK4JkCEUdJ/EBv35q64GOKA
Date:   Tue, 31 Jan 2023 06:55:23 +0000
Message-ID: <c21fffa0-9012-78d4-f24f-684acea3de81@nvidia.com>
References: <20230130092157.1759539-1-hch@lst.de>
 <20230130092157.1759539-3-hch@lst.de>
In-Reply-To: <20230130092157.1759539-3-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|IA0PR12MB7674:EE_
x-ms-office365-filtering-correlation-id: 2178956f-05f5-4986-1f5f-08db03582066
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tB/fQSrc0GmbjGspGj7WfOaCqxSiSQoBWoF0/TKUDNZHveXO3MTeQI30bKuoQE8Wo+KE9I2weO85SaF1mtPfzil30Kw3V0P3FNi6AfCtwW0M46HhDAM6015Hz/KBqN1BiqKkZxf//GL+yDTgUtiA+orA/6Hkg/kEZoZlJS7c7d286HD6/IP5s/h4fUMZLP/InGPCkdXkFHeiplNkCKF+j4K0AnZi1S89o808fGH5Tuxc+10RXwAqt35N1cFss/KWHjnkIaks1y4Ce886JhC3dc1wCSGVRhS/Wi6X0XAL5IXU3i724h4y44R6eXmRPuY4iTisNGv90FB2zFbDqmBWCgnZW4Ywy9mVGXEIwsyzgJuLs2y7Dzc351b7IejxdRuemtZLS3SA+z3tEMrzRTTZb40L/zHsM345aU2fabqnIHN8E011cI4wPPkXba7aoo11S3njiWOOdGN47gjaiC9zvMTiyyBUw91yz60cm21NjOCXLjID1gomFm1sDllUED5ptig66ZfHKyKIddylaia9xgJpL+DV8WOLYyY7cVbVWcynkeAzd2HzmfWlUH2bgOwT8uKJpBFoKcVBM4bpBwWscqeGheh5wjX2/LQ8yMTyPecCHFgEx3vUcT/D9PQ9XKYPfAZctJfxOd/PrTV9H7fs22U7Oc742IAI6bTE1FQ2QSeTs7sokbUDS+MFAKfuQRkJVqj/CqB+O5EWDQFzHeY48IeBDuqza58mRbacI1pr3zliiqZFjpjVozHnzhZLEH54bX5aa0DqAng7Ob1mKHWy3A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199018)(4744005)(31686004)(7416002)(7406005)(5660300002)(8936002)(2906002)(41300700001)(2616005)(8676002)(38070700005)(122000001)(54906003)(66476007)(66556008)(66446008)(478600001)(36756003)(316002)(4326008)(38100700002)(6486002)(64756008)(71200400001)(110136005)(86362001)(6512007)(186003)(31696002)(53546011)(6506007)(91956017)(66946007)(76116006)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TWZxRHYwM0tmZzJFUWZlOXN1YmNvU2k0WFVOeGovazh6MnE5U1dnaDZjNWVv?=
 =?utf-8?B?VGdCdlJuZ1dJeDN5SWFwQ2NtdWtXK0NYZHpid1k3ZUxUVWNtOEdUd3hsREF2?=
 =?utf-8?B?QmlhUElkSzNHc3NSUTN0UERHRFVqZ3lMcnhVRnRZZmR3U3NzM1pDYUNoY1E4?=
 =?utf-8?B?TmVSMTVETzJyem5BRUVDSW01TWR6NTVYK3h5Vm1ESVl0TjBrZ3lYTm9ISFNK?=
 =?utf-8?B?cW5Ec0l6c2FNSjhCaWZDYWYvVXdCTlVsVUNWTjM0Tk80V1p4YW1TWndFMUVy?=
 =?utf-8?B?WEk4ZjNiN0FEdk1GeHlIb3ozVzN6S0pZbGljUG1JVzJuNTU4L3hCVGZFWTR0?=
 =?utf-8?B?QXIvQUpsQ3F4bEY4b0tRTnFOZjZEa29OeWgxYzJ1dVMzYXNlZzZCOWM1cm9W?=
 =?utf-8?B?WXhXVHdGRGVtREx2TUpGZ2VUa2pOdkc4MGw5UDIwaTJjUzlhOVRpUTlBellY?=
 =?utf-8?B?Yld4KzJCM1d3d1J6TlhiZzV5NUt1RVRsNENKWkEzRFR4c20zb2liWFk4eE5B?=
 =?utf-8?B?NE5QSmZSaFh6emhYMDF0MU9hSjF5UTR1NWR6TlJaaUxMbThzOE1EN1N5SGM5?=
 =?utf-8?B?TXFVOVQ1SGZXbU93M2w1bEdiRzE5OE55VGNwV0NqRGZSeExwYU8reWx1S3Y2?=
 =?utf-8?B?eGZvRktFTmdsSDkxMHhadW5DMVoycEJxMTVGcVFRTS84aFJCSzYyKzNESXAx?=
 =?utf-8?B?dElEd0pRS3JaTllxUjRnQWFvZFFGSTBkdnFEaWZyL2RCOU5GUCtKelRwcmpO?=
 =?utf-8?B?LzQyaGMvTDNldVFtTGd5SjlhSEVTQ2V0TzlmcURQY1UyN053d3RhbFd6Q1ZM?=
 =?utf-8?B?VGxiT1JKZS9nL2t0WTdXWTlJUkZvZHhKL3hZOXorVExnWnl3M2ZoMmdTM3Jk?=
 =?utf-8?B?cmtsaldCbDFGbE5tbFc1dk5LWDNhZmR5aFJSWnQ0RWg2dy9FRlB2YjUrTFZ0?=
 =?utf-8?B?V3gwOFJuNm1IdWRqVE93SVJqak9HVlI0MG9JRHRwY3Q2N0tIQzhzb3B2ajdG?=
 =?utf-8?B?TnZ0RC9DS2lkdk1NanVaZEpQVkdvLzFvekh6dlJJdHJ0c20wS0xpdkJWdE4x?=
 =?utf-8?B?ZW5BaHVBak5EWVZTOFNEMXdlUW92eTJuNU1sUEFPUllzZ3hGNDYzUE5BMmFr?=
 =?utf-8?B?U2ZWVEE2aXdrN0Z1U3V3ZERkVjNSYXNTTmRCOTZiY3B5RElsNHF0ai9uUnVD?=
 =?utf-8?B?QmNoMWtXdWpaUld6M3ZkMXFZS01oeC8vVy9XcFROdWdVZ2tXYWtwWjVwdE02?=
 =?utf-8?B?SThEUVRoUW1JUEQ0bnpsZVBVWjFuQ2ZiYXQxKzErQk1UVi9XTzdWQVczK0da?=
 =?utf-8?B?SXloc240Y0ZhQ0xLcnA5R3hsWDFZM29HaHZlVG4wSHZ6R1gzWEtNekRXTDg2?=
 =?utf-8?B?SHM4b1dCdlk3WnJFL01pWVhnYkl1eVVwMVoxWTBRWlA4NldYMGVVSzFORHRh?=
 =?utf-8?B?RHJXdFNhMWlKalNucGNvSFBZWFN5M1drRDRxTVlsbXlsVC9XVng3dlRjSVJ3?=
 =?utf-8?B?MWMzNnkzR2FFamlMQjFaUUQ2NnluYTg4UDJVMlF3QkxFVkZ6dG94eU16SXdJ?=
 =?utf-8?B?a0ltNWVZYlp4ZVYyaHNDZ3ZMcVNYbzJkQTFaY2JnVFg5ZzY1V0JpdXdXNm1U?=
 =?utf-8?B?RHk3U3VFaVhBaHBYL0lEU2pBdy94ZEpwSzRsei9JSGRkZndxeHBGSDVaOFZO?=
 =?utf-8?B?dnZsNk1Gb2xGWXFWYTh6eFlrQjNkdzY2S0xEamxGTkN0eWNPNnJxY3FMSkla?=
 =?utf-8?B?NThHSzJGTVNKaXZLcCt2SkxEZ3VxRHduRTZGV09EM3ZnUkJ2QzgwTVdOaGVC?=
 =?utf-8?B?VmVZL1ZneFg5UC9SUGs4TTI2eVphRlQrZzh5U2dtYkhkWFV1RWJtYXVHV1Qr?=
 =?utf-8?B?Y084K3MrRjhqSWVYOG9oekhIMks2SHZDWDBoeFdyT29WaGVabW4yaXVuL2FL?=
 =?utf-8?B?MWJKMzB0ZC9nMmc4RkJjaVBESWhzMnZaWGJYakdKWUJ5SUFDWEdyTTNFSG56?=
 =?utf-8?B?OUFuNVJxcXZ6R1BKL0dydUkrK00rbWRrdEdyS2c4MlFYM3N5UE1pY1FERG44?=
 =?utf-8?B?clhqcXErai9BeXBmMDI4U3VXbnFMTVo1NEVDVFVOMFZpZXJYWmhFVTY3VHJa?=
 =?utf-8?B?TnFiWlYrS2dvZGRJZlh0L29GYi9qOHVtdHB5RGRMd3VEZzF1L3JzL2g4bXpi?=
 =?utf-8?B?bnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <18FA83D0D62140409E8C7D3931DA62AE@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2178956f-05f5-4986-1f5f-08db03582066
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2023 06:55:23.8157
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KyZenUMdsjkbevSFt4TdTYfR0NDlhMCjdcfd52+PEsr9gAHL7ZBbmSF2XoW6shD7m3Z2eHiEBnPb2xbZTw3OAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7674
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMS8zMC8yMyAwMToyMSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEEgc21hbGxlciB3
cmFwcGVyIGFyb3VuZCBidmVjX3NldF9wYWdlIHRoYXQgdGFrZXMgYSBmb2xpbyBpbnN0ZWFkLg0K
PiBUaGVyZSBhcmUgb25seSB0d28gcG90ZW50aWFsIHVzZXJzIGZvciB0aGlzIGluIHRoZSB0cmVl
LCBidXQgdGhlIG51bWJlcg0KPiB3aWxsIGdyb3cgaW4gdGhlIGZ1dHVyZS4NCj4gDQo+IFNpZ25l
ZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiAtLS0NCg0KTG9va3Mg
Z29vZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5jb20+
DQoNCi1jaw0KDQo=
