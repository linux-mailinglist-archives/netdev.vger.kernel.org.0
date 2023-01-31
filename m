Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D14568254E
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 08:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbjAaHAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 02:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbjAaG7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 01:59:50 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2081.outbound.protection.outlook.com [40.107.243.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070301286B;
        Mon, 30 Jan 2023 22:59:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=klHirsZt/1Hj9dB9bB5DYSuGhlVyzzX/XJcMszvJHCC9XPEmUZCQdaFwx68TuYsl4v4BOVS7/50A8uienamDI5RBkNq9rfiioN95BUGwZM6lCVGDFDIJbc97hn0Hr9lzun0QT3C0ztvp5dxaq0Q2lp/FGfuRbQLmwW0VffWti/OSTKXOz7fsyOd3i2dGSsPh79sRdPy+7VvFh3tQmepBEyJ/zUTHGCIn3YxV6iPh25ngIBtyL3WYgV7sUxKnn+0rLb4xdqcD8T0BTWMg9s1a3yvhNE66/LWboBC/2B4s1vbn82soWaM+GCvUKYunJSWsMEdSKV4EtHhxGOELII9v5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BHn4qW+ZNoz5z/jEBJdq/JiEPSra6nAvfa2CcNicSYY=;
 b=UXdWNn3CCl37iv7Jb6CF3oH47g95wcvwM5JO7CZXa3Gv3cN4OQYEHO6l0nafCQOZ79Ao0rmyxH5iIiG40DGQCmhst7dknC8bA3/orj9C0a1hyd+F/Y61LXNocRKS0R2JHdPy9dq538MWGNQK6OUG9wJUWK4qNVQCs/4zayQZXJ5eoPrnbc76LF4TubfQAAbsD9LI9Jl/w/RS9o4V3+LH+CZWj7FttcO9xYJKBEsMapXphBtR6x4jEJtcd1xCEeQKNx9gLN9TU2SwHlhQrUS7CpzGxUnCTBiG7gKRZhqK3kq/5g16eqhqasao4Rj6/2XsjPZfVHDAsgS8vYDgauNH/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BHn4qW+ZNoz5z/jEBJdq/JiEPSra6nAvfa2CcNicSYY=;
 b=E3mm24OfpD6KRKYKF+gLyUqmoYJP5vO24Tgk8Akdoadurysyi6qJjozpjX7P2jTFTNk3XZ2dOGj1k1/H7JzqTD3nxlamevvxiU4fMq/mQhOEJDVbd1WCEEC0eWslModG+rSRCwBPIUsyyUQnrJlrUpToE2j4pehLig9FoSHXplZMY1zpwSRoAOr5rvtsHz0RTSf8F7wV/d2QIQ9vNIYE/xuEvZPViqxxQ6NqHjsqPNWOxi8sTMTXjFENid4hyyXGL1RQKBwkO8V1dT82erFyBU1Ywm8nym/gGloeRsWwxOOruILKBdYBxldxmCuYJ6nnEQ8Gx5OK2svhuM/wzJW5pQ==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by IA0PR12MB7674.namprd12.prod.outlook.com (2603:10b6:208:434::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Tue, 31 Jan
 2023 06:59:15 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7%2]) with mapi id 15.20.6043.036; Tue, 31 Jan 2023
 06:59:15 +0000
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
Subject: Re: [PATCH 18/23] io_uring: use bvec_set_page to initialize a bvec
Thread-Topic: [PATCH 18/23] io_uring: use bvec_set_page to initialize a bvec
Thread-Index: AQHZNIx87ZQi1+VBLUygvu+I8poiQq64GfUA
Date:   Tue, 31 Jan 2023 06:59:14 +0000
Message-ID: <6550de76-2910-495d-84cd-c80efb02c92d@nvidia.com>
References: <20230130092157.1759539-1-hch@lst.de>
 <20230130092157.1759539-19-hch@lst.de>
In-Reply-To: <20230130092157.1759539-19-hch@lst.de>
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
x-ms-office365-filtering-correlation-id: ff7be5fc-1e43-48fa-9b16-08db0358aa2b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EEz9odlhDJrdRbJOU0xZIwLQ1ZAWjpMvSLVEFF/fUayhniCWTyzNaxt20JC1yDfGgWcUBZe0jRvg6onroqhsvQVYhVz4FMD06Gd8MZP6zROszfHtzV0i4QQuMhPqo5k+YvDXokSju3bfFH1BISSjmQsKIlcHmumwXjCdbpQbQoXnrT4C/LAZ9M5+jB2rc6FRvrAxeDXuJsYEqupp8kCI7u3xspzV68TKr8qfj3Cz6XYIQLlf9j425qnkZsqtoNfpcPzB7jBs9mQdjyQ5TFVXPVB5lJRSJ9Vzx/BfETFk956wtofGDi5oPviTuNa7eMlAeyoTzuYq0eWSbzwl+ZR7vFNMOAUoiLnLWcah/04ew033BPKtdczG5BvzUTOV7GC/X/NL+rsNP+Xcujt0H9el/YYEcGzRyDZo9LUrN0cbG7VVfoFuxUlUgMQzIM8AJcfBRjjw/sohEL0Tm17zH+kkUXTxfNo7/zPm9p5FKRtVilBVQAtbzbZWLjh4fPqJqG8BbWDdDLmUqkm2YS4KcNNLQ0OuaToBWJOOM+ZjE2hq0I515luj+b1aWIafM8MRi03emEjrYZWp8nKTpFT2N19W0H6Jj6Sm4mYjDUBjoOOJ8C6Q9oJ83KkieunGOINab4HYYE2bThSfE/yj0yD7PoVsC1wun/AWmOxSXyXcKrjco4LDORizQbQ8BPVrEG2FXn7qMrf7y+VeXjdDnGuYgEIfK0D9RgaSuox2aKCUSdnnpnJV5KDguMHVEo3xCv3ADfYr9aS+9bQO9zWY44MBfp8tyg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199018)(31686004)(7416002)(7406005)(5660300002)(8936002)(2906002)(41300700001)(2616005)(8676002)(38070700005)(122000001)(54906003)(66476007)(66556008)(66446008)(478600001)(36756003)(316002)(4326008)(38100700002)(6486002)(64756008)(71200400001)(110136005)(86362001)(6512007)(186003)(31696002)(53546011)(6506007)(558084003)(91956017)(66946007)(76116006)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UWh3WmpTT0g0VzFxNHg5WmtmMkV6dVVTaUd0ZlN5R1FmSk9UNFdKMjFRSzAx?=
 =?utf-8?B?Y2E2TTVhdkhLQ21TdHUwb3pWZ2RNRWZjdVRQRVJPbjJteXUwQ3RYY1p6c2tN?=
 =?utf-8?B?dVJjTmtZaElRUDU1UXp0cTJuZ3AxenBhMlFxYkhNc2xDS2lsdmY1SkFGT1lL?=
 =?utf-8?B?eGpOZ0FmMUo0dFBBY1hpdCtCM2hzMlVjUjd1RDU5RTR5bFNDSjdOdWZSdVYx?=
 =?utf-8?B?OUZrUHJUZytERXNaOHdpNktaNjRhWE5CNzNoRWpHK2xMejNTYmVyREtmeGtO?=
 =?utf-8?B?dG8vMHcyU21LU1Zwbk5iMTJKWlYvY3RDVHJWWHY0RUI3T1BvSGVyaDJkeFhp?=
 =?utf-8?B?OEVNTWhlNFlHaDNtaEp0VWtCWkRNV0JwaGFUUHV0eStFeTBZQ0wvTHY0a1hy?=
 =?utf-8?B?UitFVnRnK1hnRDIrVUNOdG5ZOVFvWnZTU2RXNzZCdm5tSXczTTI3bTQ2WURY?=
 =?utf-8?B?V3RNeDh5YWVqMXRzaHdrZWd2OXVlNUlSbDFjS0o4UU4yVFc5ZVZrV040MHRL?=
 =?utf-8?B?blFyL2JoenZVTVR6OFhnRDZiM05ORnkzMUlzNGExRDhaS2JlMGFqbHNWM2p3?=
 =?utf-8?B?TVVDUnIyWTIxKzVOemRFZTZsb3hMRnEzMldtdWxyOVZ1Rlc4MFlTSkpycmZS?=
 =?utf-8?B?a1NiMnhHN2gwdjNpWUlISFhSZWJlZXNDVnZ0VXVMaC9PeUY5U0dkYzFEOEZW?=
 =?utf-8?B?YkE4eSs0RzhGVkI2RXRoSmxDSnhvYXd6L3FrdE9PY3ZEeWdLc2tJTGg4VHMw?=
 =?utf-8?B?d0czYU5NeUdFSU5TeFQ1ZEViU2FneGNQcjNRS1loU3RPL25DYy80ZElsbDk5?=
 =?utf-8?B?VEd3aXdSZ3hta1E0QzgxdEhRU2ZuMEYrRlJlcVhqTEVDS0pBQVNsaExyYWs4?=
 =?utf-8?B?Q1lsYmlBZUJscEx3Qnd1V3NTV3hkRDUyQk5KcEFnMlJCSnZFNU5LNkUzVVQ4?=
 =?utf-8?B?K1FPdGtBNzF3Q2ZJdWRPYldzVS9ONE45NnhYbW5weFZBNmRxSUlWc0tVZzhw?=
 =?utf-8?B?RXFDZmJwMXZHR3BVQ2xtbzF5TEdrc09FaFkrZzdCSUdFcmhsdktjWnpGcVVW?=
 =?utf-8?B?Y3BYNVZWdkpNWnNpbytVeUduaXVVVGtZbWUrTnRmUG83RkJUbEpHd1MyUno0?=
 =?utf-8?B?TWhWYTNTaUJGQWxqS3grUGxjMkdSU1daVzRiblo4Z3diczlJK20rbUlMZFh2?=
 =?utf-8?B?YmhFK2NNRzdzSE5rL3grYUgvME1GRFFTVld6d291cE5xZnRjbEV0TUxvNEdv?=
 =?utf-8?B?cGFwd0xuSmRqT3lWRlZsQTdkdVdkSjY2bzNxRXR2ZnRKaE5jTFNHSXlVc2gw?=
 =?utf-8?B?UjdKa1hPZmE4b0hYa1ZXVElrQVNIek5oTit4SEJCNFBuellzMnVkWlpMc2hi?=
 =?utf-8?B?dkZPbTB2czEwUWFNSFRFbDVMVTA5bHRuOUIvckFvVFJNclJrbHdVT1ZlRVAr?=
 =?utf-8?B?ZFNUN0lVaGFQazFld0w4OFJ2cC8wbmYrRElTVGluSzEyeGlYY2lVblZQMUhI?=
 =?utf-8?B?bi9MMTVGb2VWZGQrOFJ4N3ZWaGp1Y0tMMzVMd1QvTzZpd2Rlck4vZ0xaUzlY?=
 =?utf-8?B?WitVanhIb0tGTjZzZTE4NzhMKzYxbjd2NUhTZmJaOW9vemc0YjhFcFc2dXBk?=
 =?utf-8?B?WnNQWkthLzJEZkxGQkdhQXZoQ0ZkNUtySkNoeFpKUzhBT3J3anVNaGVLRkpD?=
 =?utf-8?B?clN6bTlUeTZDMGgvbmxMWVc4WldycmJXOXVZNUJLYklPak82ZitUUTE4dzRj?=
 =?utf-8?B?UnEwUC9Yc2MyZ0t0cGJlRXFqN0tZcWJaamxaenhqbG9wMkc2RVo1cUtCYm1j?=
 =?utf-8?B?RFNVeSs2cWx1dUhCT1R5VTllMWJQNnhSdVBJZXZQZW9UQkRiTFVsY21YTllp?=
 =?utf-8?B?VUYrRHE1eTM5bnp4VUVEYysrYkQwZUt3K3R5MmVtdUkyQ3Z2TjNUcjMxL0NP?=
 =?utf-8?B?dkxLNWlxRnUrNHhVSVMybDFrNGxUTDJKV2lkNGF2dCt5dDE0VnFDazhqYVR2?=
 =?utf-8?B?MTV5cllQSDlOZ1U4c1llM1RmU2ZGU2dqcnpDOUEwVWkxckFELzJtTThFSm15?=
 =?utf-8?B?dU1hSm43RWlLUUlXZUhrd3owRGxsSEZDdit6M2daQjd4YnZkRk1hdHZKY3kw?=
 =?utf-8?B?WVFLbjZnNkZjUmpMa1JUdmpXcHZtUnRzVnpkVm5LZy9FUDFKalYwbkZLK0Jo?=
 =?utf-8?B?NVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <98CFD6EF766E04419589C1931ECDC425@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff7be5fc-1e43-48fa-9b16-08db0358aa2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2023 06:59:14.9890
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t/p6zDd9LXaemJvRo4jEDfX5L6ntCX1L+eUiYhLr5pU5LbBDCpa1y+HcZsUq46vspp4qSy11bcDCrnFvqIHa/w==
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

T24gMS8zMC8yMyAwMToyMSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFVzZSB0aGUgYnZl
Y19zZXRfcGFnZSBoZWxwZXIgdG8gaW5pdGlhbGl6ZSBhIGJ2ZWMuDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCj4NCg0KTG9va3MgZ29vZC4NCg0K
UmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5jb20+DQoNCi1jaw0K
DQo=
