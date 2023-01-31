Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46BA56824EE
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 07:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjAaGzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 01:55:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbjAaGzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 01:55:16 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2066.outbound.protection.outlook.com [40.107.243.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE0B29E37;
        Mon, 30 Jan 2023 22:55:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=elyT5+kwAMCuQQOTxAElDDLiPKaI0xS7cuJezWphyzUXUA/b4KF5nBPZjnB5/cpd3QB5yFNeYlZOBcens4suEpnEroDh5OWSDVyXPYrN9e8rfWAbunsQq1XCUmckj3RhDTZzxgP/JxmteVKRgdR7kCEl2TwwKHQqHZxR81C57+GBnNHk4OQ8gzTVbGdZDteLiWCR39jqBgaAF1RHKAzWOuiXC6IjjUIoco7V3MeWAwEfhnTEdkLhWwajfkCobV7Y/nTwFjiClyMfv0hJwzVUVgjZUhTxMRHj8R3p2R0/8H4YhEl7V9PIWwjU8POHNRco1IqPofHQYqg1AAD/aubvqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=miB3y97PJsydrR4G7Y73XYehBABnBQrCrP70vFTRVqc=;
 b=Ow++nJ9LUHBHn4OV9uKPiT6vJSKTNE4YeZZgVr6IxpJsIh6b+VWkdPqPa2JqkFYOxmwMfVCho8h+WPv6YKZfpmt3GepBjBVQUHV4SP+5ve1QIW5P3KvbTLv/vi6tGb605yyhUkDzKaMBQrDAsflzDEWcAEJQCubK0nI6lag/shxOIKoUVK6FWyGCQzYLYoV/oOLWfngbS06d3hco+OWYFn115KNIOlSv7LaSyEaLPAxpuF+aRpviPoS5YfWU6S4k4pTraQpwTpjFSFD40duXPh2wGNKlNXJBRzUDQ2TxKe8sF7QTR6NNt2PfksXAaBE3Wg1KhErDdefIF/DXRiFhTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=miB3y97PJsydrR4G7Y73XYehBABnBQrCrP70vFTRVqc=;
 b=uRqsTuBoyXIRnrMXo3kMdYxr2MNZQZnyobYVlHa2IDFh+KfFx0QlHvjTdJVYVvtbn1YDKiF/zW+ThQmIih98ux8nAvIFc6wgybD2gXSByStE98ydgJX1JMkaeKz28MLbCJ1DoF8XJYEwRV8jHSVt7yhPWomgwF8vo/kwj6AJ+5NJOHrCqVpO9jB9e/5MfFyw53nJfTiWxbvMQk/P2mocqhMwn2N2+VP+ZIeslBA10zAfUfN++5MT+09krxr97Q2HaHI54CS+aGdUVOTaor1NLdiXKjLD+6TACRstqaxRB29S23mk9EnyeY52CIoBgKT8r4JN+3GAzh2JWfhY1STaTw==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by IA0PR12MB7674.namprd12.prod.outlook.com (2603:10b6:208:434::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Tue, 31 Jan
 2023 06:55:09 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7%2]) with mapi id 15.20.6043.036; Tue, 31 Jan 2023
 06:55:09 +0000
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
Subject: Re: [PATCH 01/23] block: factor out a bvec_set_page helper
Thread-Topic: [PATCH 01/23] block: factor out a bvec_set_page helper
Thread-Index: AQHZNIxdpbYkT/F1XUe/QrKqMdEyyq64GNAA
Date:   Tue, 31 Jan 2023 06:55:08 +0000
Message-ID: <3ca88dba-8675-08cd-6547-ce7a0e382b7a@nvidia.com>
References: <20230130092157.1759539-1-hch@lst.de>
 <20230130092157.1759539-2-hch@lst.de>
In-Reply-To: <20230130092157.1759539-2-hch@lst.de>
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
x-ms-office365-filtering-correlation-id: 300a9d4a-6285-45e9-0d56-08db03581792
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sIT6qjAYqcvouXXDMYk1l8rTCINAGKIRqxz5OI62CZdxdvupACErkbqSfi/miK/z/t3J85lquIK8N+5wr4as49ZmgvbLZorue0d4TA/C1x/1bMA5S/+dfn2MyNs3NSTgW7JpCHTEpm/lonutLWsn5YQnajh/L7ufo3iAbD2SD/cEn5ZWZV3iLzn1SNtCJ/LYxRnwkbewdL1xy7VHQlkufxDPpkMSxA6rOKXuqEqFnCiVuaDHgf03vXXCHar3wk44N18nEAg7i197EPoJaSZrc8HKIQ1OzuMSW+ej6sM9P5wFE+aQnhdxIPCB2AEDy4FwDp6A4C226Eted6HnUgW1GUkIAvBlIMuW7Tzm48V65ZsrIjMq2X4tmEDo0lt0guxrgWLNN0RxXOddYCy9XgQiilkuk9pYudg0aK5MNOmyhN/C6c7YMXMmmLx45z8j+KUf4U/APaCv+/+Nxd3R3O7loFp+2zl1VasRcyT3i5T8MzZU0kT23rWNLadDRxxvSebYP4Ru0YG68bKtep9r+s5ZGJW83/GOSw2f833fl1Sf6ONuX7zjwEkPZpLMOjmNcjVVV4TcEjU87Nl412DKxsIqQe1rRwlfMqxdfPv9yLeX3MqmucDQUkANpO1eCWsFs8gCqC+teI/CSiVsnjkvslTeQe1CuO88e+Ha/Kn1WJCeHME4tG48QV6gfol8H07uGYu3rwLv3GwNvxZ10COA2aBoPb/DREj8Ie6PVQ8CIBiGiMEhC8HfAv35IM+57LXWI9RVPYiYJNkUpCfBcknNuqDX0g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199018)(31686004)(7416002)(7406005)(5660300002)(8936002)(2906002)(41300700001)(2616005)(8676002)(38070700005)(122000001)(54906003)(66476007)(66556008)(66446008)(478600001)(36756003)(316002)(4326008)(38100700002)(6486002)(64756008)(71200400001)(110136005)(86362001)(6512007)(186003)(31696002)(53546011)(6506007)(558084003)(91956017)(66946007)(76116006)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YjVpRHlOZjZwekczdC9GNE1tVkg2SUhUL1lTL0p5dnVmUlE3UUdWQzR5bXdm?=
 =?utf-8?B?SFc3Z0hJTU12UU5SSVJHWHhKdTJJRkRmSkhsTWx0OHh0YWkwdVcxQVlyVnBq?=
 =?utf-8?B?SENlNytFdk5CMDFzZjVRQlBEZWNGWDE1aGJpSEgvODBSa2NldWpEWGptRjBL?=
 =?utf-8?B?cVl1QW85U3JjNzlJbmRuZFE4TndSWTh3VDV5WXJFMXVaMjNGUytNYU1XK3FX?=
 =?utf-8?B?RG5ocnphTEc3Uk9VNzQwdllSK2lVUlc5UDd4eGNCdG9QVHNEWVFZbGI2aUhY?=
 =?utf-8?B?MFBKaDEva2MxZXQrbTVyaDZDTnRpc2hXRWFPOFJEOWkyWGxhS3FtRlRxY0RK?=
 =?utf-8?B?YXVaRDZOdjVtTk1XOFhyT29jMmRETTc0R0xvd2tQRVh5SzVSODhONE9raXlm?=
 =?utf-8?B?b0RSU0pGZXVNTVIxZTdQMjBYcklPQmdaZzJscGoxenZtcFJMVDFIQXd4cFQ3?=
 =?utf-8?B?YVZjR0ZGaDUrZ3ZDd0MycnpXNFNjS1d3aDJpSExSN0ZURHZWR2xNR25wZmQ3?=
 =?utf-8?B?cStUUUFnVVVaeEJtVk43MVQzb2NtRnRpaGZNMlgvOTIxbWJGUDArWUlGZzh1?=
 =?utf-8?B?WXdOMEc1Z1JEbXpEVlR6NU1pMWN2UlhCOWNSV0NRaS8xd3lyZE5XaHNhZEc0?=
 =?utf-8?B?dXdkK2ZocXJZWmI2KzM2L3g3dkdKOGJQbjNOK1IvQmZWaG5aL1F4VWsxT3pP?=
 =?utf-8?B?NVl5WFhPb3hiUE1pM3YwY21kQlB1c0pldXg1M3paZkxVdE1Fc0grWG1ma05i?=
 =?utf-8?B?K2JENk1JWTdoRTgvd2o1bmlKY2dsUTNHUlp5QjBKbUIzbllzQ0lsVTJRUzBm?=
 =?utf-8?B?UEduZFgyd1Vxb0ZVZnVMUXl3azRtbnpkVnNQb3FEaXc0M3pVNExFdXRyYTl5?=
 =?utf-8?B?MEdTUVZYVEZndkxEa2RnODFqRkxFbllhSXZwczMyK21wbHNsc0d4OTlmS2U2?=
 =?utf-8?B?ZS8vWm53elVWTXo5VTM0YzVMWWhtVUFYMlczV2EwR1U2YmhrQ3hxSDJxbWdD?=
 =?utf-8?B?QkYyRXNHRjJ5ZzVmeWJKay9oc3h0YXRKNzJNY29TRko4QTk3MHZMZ1A0NWxO?=
 =?utf-8?B?RUtCbDJUUXhBVTlZZkdrZzEvSmRMM2ZJYWNEbEJYVGU0WHB5U25LMkJjV0s1?=
 =?utf-8?B?V3ZaaW9mVTlDRVpwc3dndkJoVEdvVG5NRUZneGJuK1QrcDVMVWZSallXV1g5?=
 =?utf-8?B?T2MrUkltOTYvYjllUXVpd1NXZWdzaUd2aDBpU0IyVFdxTTRZQ29Bd1hsTTJF?=
 =?utf-8?B?SURVejBMM3FydGVORy9Sdy8vd3EwTUg3TitQUEtaOVM1eVIwRUhmV21UcTRn?=
 =?utf-8?B?MlEwL21JbHpTRE1uT3VFTGNOVllyTTZJNW9nOXdldDU2aFdnQjc2SUJvSTRa?=
 =?utf-8?B?ZnhTU3ptVnBrQ0xMVGVVeFgyMGNBcWhjdnlJUmFOVVFKUzVEMUJFMDF5TjZL?=
 =?utf-8?B?MldlZjNDbjQzdXRVcWdEVjRQQ0llRXVWSmxWMitSVXJ3UnRVRU5Ecm4vK3hp?=
 =?utf-8?B?YnU5WXVod0l6dTJSWTUveFQ2dUxFNk0vbkZRSGVEc2JlK0Q5cVhtai9TVjBs?=
 =?utf-8?B?L1libjZuYTlneGJKSFk3alc0WVBpekxxTTZEVjViR2tuNUtBN1VZajFmNWFr?=
 =?utf-8?B?WDU4YlNxcHRxUmE1b0ZFTXBESi81S0hnNlhMRS9YRGplWisvRGdtQnFuL3Ax?=
 =?utf-8?B?SjVHWkV1TlBFeGp5b2FzMy9EL3poNmFPY0VPV0pBZ0l6UHNDb2NpYTlSVkVW?=
 =?utf-8?B?bDYvUjJxL2RyalJtSkllaVZPWDkyS3VDRUdtaFN2SEFDM0VwYitZUnN0bmFq?=
 =?utf-8?B?R0NSYnpFUlE2Q2xNNTZXS3RLRXF1SFducGxIY2NsYnVLa1E2ZVhXV21TM0xh?=
 =?utf-8?B?Z3pTaWN6MXRMalBqZUwzVGNnZ0NlRnpwazA0K3dJOHExMzlJK1JISXQwYktE?=
 =?utf-8?B?WXJaOTVVeEl0WFVZNjRxeXlKZnVwcW9tQktuRm54Y29xWEZSRDBtMEJtQ3NS?=
 =?utf-8?B?K1NOWGxZSndMMklGdVhwVVVvZlNXUk9mMzRqek11NEowcWlXV1laL0FibnRM?=
 =?utf-8?B?ZXFFL2ROb0dqaUZpWmZ2N0tKZ1N1YXF1SWFZbHJZS0lUcmpuUncvUFVCOWZ4?=
 =?utf-8?B?OGh3OEl5cXBRSmRjazFaN3k4amdDZmhRVFl0WXRzak1NUWZFd1k1QXdJTVhS?=
 =?utf-8?B?VWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <33EEDD8BA6BCEF4A8E8B4E864348AC1F@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 300a9d4a-6285-45e9-0d56-08db03581792
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2023 06:55:09.0041
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oXf3NWwfFjr2PaiHz4J7q7SLTLY7Oa1Lj4A3rM5WkBBMgDMBPM5PrP1QoG+yUtGgWlD1Yw9XcBSdmxVImbXnVA==
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

T24gMS8zMC8yMyAwMToyMSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEFkZCBhIGhlbHBl
ciB0byBpbml0aWFsaXplIGEgYnZlYyBiYXNlZCBvZiBhIHBhZ2UgcG9pbnRlci4gIFRoaXMgd2ls
bCBoZWxwDQo+IHJlbW92aW5nIHZhcmlvdXMgb3BlbiBjb2RlIGJ2ZWMgaW5pdGlhbGl6YXRpb25z
Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQo+
IC0tLQ0KDQpMb29rcyBnb29kLg0KDQpSZXZpZXdlZC1ieTogQ2hhaXRhbnlhIEt1bGthcm5pIDxr
Y2hAbnZpZGlhLmNvbT4NCg0KLWNrDQoNCg==
