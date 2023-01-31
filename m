Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6807682537
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 07:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbjAaG7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 01:59:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbjAaG7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 01:59:07 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061a.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::61a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4076E83;
        Mon, 30 Jan 2023 22:58:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FKcAAqmgtWBnoC//BIOA2FFCZTc1R22mvNOIap0sE2ZfNciseaoiISSzFQXWoPLmjPF3khIzNAlfMGyXBW+icNs6Bn9opcsF0/Y/1lUM5Yi9Psl3pm8eEPW5Zq03WVZEwa48SlX2yV5ynJPuEicn393um8QxRuXhzvumPDAGCuK8jHOMnOcccvS19Ey2nw6Dzpxcdz5Cmu2+FWyORQhM0rEDVPKvFfjZ9nV+WRWdGijyV+r0N5J5qhyx5Riqoe/22EoypuS6atdlMmNW/Eq+HY0blDi0gIMfpg6NxT9BTthX664o5QD8mkJctk8FcQIvvzD/8TWMAZZqJQjR9XWC1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xiSXn7W6BKl+9MgK1+6308Sa+v8yfTX1IoGCT9b0PEk=;
 b=Vtq6Xld9Zp8ncmtdV3pJj3Cf5O9pGtv+u73XEpiUjZXoEvmo78it+jRAa5UHgi0BiG+Bfax2w7ybZngidScdqoIJXjdbtuQcqWD/IKjbMJuAQ0Ahc2XULU0xWbMdca086H7+VIeEVUreLpWBvkjNjRJBkKrwxcc2uyqCrQnEdZcWx8b9lW5VjAVRLPUFhqVrth981dC6u0TQK3pQWpPxzF/afMB1Tb7xke3Gd+ufK2+pwt9/1ZVSw1+GN2nPIqoMFHl3ia+Fh6cBkG9Skl5eUdiC+DsW2FaSt3QGjHkN5P9IOQ83vgfNZ397KKeQ2BNJekH1Ks6MQmKgYWyxXd8f3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xiSXn7W6BKl+9MgK1+6308Sa+v8yfTX1IoGCT9b0PEk=;
 b=omWoA2jKKcvhjHzW0LMy9c+43nOPJih7L9h/xsbozUllxWkhnUERmf0mExctr8dCUp/oA8yOyNAGaD6zbByrGLzrpkohuwJuFbmcbBbwGDsTvA10hQuhw7NBAYKAWX4eWRXviKSrRWLRUkFDxeBhV8lWKT5DU41VPd3qH7hLNvLW6uG+PHazDc+no7f4doJm2N2B8r0Tf6Md585mIZbA6gG3wM+si7jS8Wqo2As0JjtHz8ojAYV1zzy3d37XNBdwxXWR0/PXVSzJOrixa/DM+72OVnz9iS1MHM3EseDwrMcw9iVjiwm0iwL/p4/Gg0qc54WrKP1nANFliKjGgGZKqQ==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by IA0PR12MB7674.namprd12.prod.outlook.com (2603:10b6:208:434::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Tue, 31 Jan
 2023 06:58:25 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7%2]) with mapi id 15.20.6043.036; Tue, 31 Jan 2023
 06:58:25 +0000
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
Subject: Re: [PATCH 07/23] nvme: use bvec_set_virt to initialize special_vec
Thread-Topic: [PATCH 07/23] nvme: use bvec_set_virt to initialize special_vec
Thread-Index: AQHZNIxnRJmxQESeWUqXWKADEe8RVK64GbqA
Date:   Tue, 31 Jan 2023 06:58:25 +0000
Message-ID: <162441bc-8335-2cb2-7d21-d17ef762133c@nvidia.com>
References: <20230130092157.1759539-1-hch@lst.de>
 <20230130092157.1759539-8-hch@lst.de>
In-Reply-To: <20230130092157.1759539-8-hch@lst.de>
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
x-ms-office365-filtering-correlation-id: 1a90fdc7-da2a-4aba-5a88-08db03588cad
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pVKZSfUIA1eTDZqdwFE8g1uNd8Sur6edF6CyotBqUUsylxGqkMHhKonThDNf8uWA5fn7urPB2uyG0eRF9yOJ6CY++LDNKzaRFS5KJ+jnv+00gjKQxIB/m/oN9djspUkIWmebCgWBEzcGPkW/hn3ORyyNFsfp5ExqYqNLoImkIoEFhHXqlLAEKl9u+IcG/yUZw3HTfE+uYc7TlDQlyrQ0qE/vUoi2h/B4bWa7m6ENKLcBaHhXwpdcWFZKHPE61l0jgfLXpERQwaHTHH2K5O38Vnx21AV/BlPcmIGLDoM7OWTXlex5FEiKDLCcOxSRewlUdCwqDRzZ6fqXr4+CJBvhPiLP82CdhSsKeMoLZIjfcg5O4hTydaXkFPQ1ATlR6kXsafOhfrab8fr3OxJG5t9t9Grnu71+W5p9JL3euGHmtd1eN1OSd/yN51BbkFLqKftyk9tkvYY2Sq5A00SWspCoYIvSLdurAbLWXHn26hKRQynOt7NmBPd1+IhPgx2zO2C5P13fNpYXv2QcB/GFfb5Bpje0LavK+YO5aoIrGrhUIhmIce9yMhm4zkUyU+iWrPR9/touZwrWYQkxUMpWhzYMAleOvYiUeXA3evtYpz2sq4ebHbwZBgScoYUrImd/a1uUhXSmU5PMgYRgs3+v78lST6YyJilpTKmo9ErMF69CaoMf/RshEgQOA/a7dUtPZ4q3L9G3OUAiDuH+Qp8Cn4LT9pwLWZM8FmWAda/P2RH2YP6ayJrHtcVfug3MA+Rc623uH+1XDUnULe5GjMxWd011jQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199018)(31686004)(7416002)(7406005)(5660300002)(8936002)(2906002)(41300700001)(2616005)(8676002)(38070700005)(122000001)(54906003)(66476007)(66556008)(66446008)(478600001)(36756003)(316002)(4326008)(38100700002)(6486002)(64756008)(71200400001)(110136005)(86362001)(6512007)(186003)(31696002)(53546011)(6506007)(558084003)(91956017)(66946007)(76116006)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TGRLYXpSM2JNeFM5bDFGeHVwL0liUjYvei9uWkFuY0loVUN6a0J6dG5IN0xr?=
 =?utf-8?B?a3NoTC9tcE44N0tsNDVQWCtYbkJPWXlWVFhpMjI3NzIxWkpTcHpMUUp3Qi9T?=
 =?utf-8?B?c2ZmamtyNjc4bDFtNnZkQzNHUGl2a3poQzdDWEIrY1EzZHd0Wm92bXdOTk5Z?=
 =?utf-8?B?VHpsSTEzUm9jQzdnRm1VNm9DTUV1TEc2VGM0bWNadWlVOU1oVWtvUndZUUhh?=
 =?utf-8?B?U05GVytzYytnZlBTdGxEVGtoeHNJcTUrTDNsbExBOUQ5SE14RDhaUGxqU1lM?=
 =?utf-8?B?WG1QNlAzMDRPN1k3cEJDanUrMDJyOVJuRXdIUTFGZTJJQXloRndHSXA3YXlw?=
 =?utf-8?B?bEpFRlo0aHpCOEF0OUd6a3ZzQlcxcktZaTUrZFhRRUpOKy9uZUNsdTcwczFx?=
 =?utf-8?B?YXpHTFAwMUhNWDB2TElkMVJLeGlLUlRpeUNJTHVOc2U1L1FldlJsa1J4Ykdw?=
 =?utf-8?B?V2Mrd1B1TVRGWFNsTzlWKzJKcjR6Y2dRUTBNaHVvZnM3R1g2blIrc3JZM2xQ?=
 =?utf-8?B?SDdPVGRwUjhoMmg0SnpuZDNBa3FRQ2l3Rmxtcnd3ZVlvRWRiNW9rSkEvK2po?=
 =?utf-8?B?ZDMyc3dRbUtWbG1MY2tmSlBGbGtPZVBzcjNwZ0N0eE83WGw1SWdENUMxYXlT?=
 =?utf-8?B?Q1g3dGdDN3JaOWE0UjdvNUhaQ004NDdDNDBSMFpmZEZ2Rnlic20zZ1Z2RmZj?=
 =?utf-8?B?Y1RpOEhTcHp6TEUyMTJqNjJBMzNPVmlVaGdLdXNTUElRZy9OMDZ0RFB4UEdM?=
 =?utf-8?B?TlhYRHZ6ZU1HRUFDS0Y0ZXpUK0tSL2xwVUgydVQwK1BHY28yM0xob2JIL3FE?=
 =?utf-8?B?anlCSlB2SlE2K2t6YXRraHFPalFHZlR6V0MydVRBRU9SWERxY2J2d05YZWNR?=
 =?utf-8?B?TjBQVkhsR2JTMlpYdlZMMGNTanBOVkd6TjhYT1RQalRzNS9LRDhyanUyR3ps?=
 =?utf-8?B?UHVqcjVSUmxQSjVieXlhRHZxTm9iVkkzOWY5cFhUKzBMMGcveU51UzMzZXhY?=
 =?utf-8?B?NlNtb1VwVkowN0xPb0VMVFRYSDhaTU5kS1EvbDR0aU1YNzQxZ1d4eTNMQnB4?=
 =?utf-8?B?NjM1d0RZOEh0cUhpaFJuMVNrWnkybmlHU0JoQURtL0tqaE9qbnU1UGJJaUdq?=
 =?utf-8?B?VkpEU3ppK3k1QW41L1o3QW1wcUQ1eVQyd1AycEV1WG5DZERQOEE3ZVNzalhJ?=
 =?utf-8?B?Z0VBOGtFN2JiSytRbDhrZi9abWhXdGJ6YWY3WW9DM0RLaGlpbVpYUk5BeDBt?=
 =?utf-8?B?dFEycnc1YUdrZTYyUEUyQ0tEVWxWbmlmNTFlRjJmSnZOWUVXWHBpSVJGSTB6?=
 =?utf-8?B?cjFDcW03MHVhN2U4amt5QWNoLzJzWlR1V2ZpY2Z4VStmeGpaTXpMOGxXK0tw?=
 =?utf-8?B?MFpXSTRrTktQRVFDVlFvVlFvQzh6Znl4TTdiOExpbk42TlAraEFzeXdtcDNz?=
 =?utf-8?B?eVVVVEg4L3NoWkVLWGIya2pUMWFIZXljRzRVMlhkb3k2bEYvUmhpa0svS1NI?=
 =?utf-8?B?VmZBdHY3czR2Q1hnYzR4bnEydHF6UzdGcnVBWXZDTDJ6eUVyR1pkM3RiaVF5?=
 =?utf-8?B?ZjFUY0VZT0dqZ3I1b2VlcDJYTksrT0ZGUDBKK2hYcXBRMU5zckFJVjBGT2tP?=
 =?utf-8?B?eUZuRmRkemdIeDhsbWpseHgzb1pWdVlMMlRwK0cyVWM2Tk50NDFWY1l1UHJQ?=
 =?utf-8?B?emUwbjJxSTZ2MFJkcmMxak5kdmc4U3JuWkhJZHl4cTczRm9abXhISWtKUFdq?=
 =?utf-8?B?NHlWWGNUd3l1WTFQV1VRektJWUhqUUllUnZrbEp1REdYMlNEcXREL1dNRjZ6?=
 =?utf-8?B?RWRSSFRUbmw2bmhDT2pQWlExcElOQW95dmFkZVBVT2I2c1ZxQTN6TGJRRGFh?=
 =?utf-8?B?OS90Znd0ZE55OUFkVDhPajJKSVQxeWx0amdXaXUwdXFrWUx4UERFUzRtTU4z?=
 =?utf-8?B?QndSTmt6RHBRQVJ3QitveE1oaWIrQmgzYmFiNzRVMjh4Mmg0RElYTkRrTlZk?=
 =?utf-8?B?QjRRMWNUMGxXUktJWGMyUUZ2UXdJZWJtbk9pMVJ0d2ZsbWl6Y25Bb25zd0FX?=
 =?utf-8?B?K2QxUkw5NVR1RE8xcFpSb0w1ZWV0QWlJTE1JcXVSbVM4dUM2aVN4Zm9DYXh6?=
 =?utf-8?B?TDZydmp5T21ySCtucEUycmF5ckdWTE1Hcit2cjRDYzlibFQ5Vy9UamYzdjFT?=
 =?utf-8?B?TGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <06AF3BFDB5AE8743B815CFC291E89BE2@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a90fdc7-da2a-4aba-5a88-08db03588cad
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2023 06:58:25.4921
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j/YgnURjoBKGocwHQSTUR6w+U7WSYj4kEHtlO4IqRTN92aQ4JARM3X623KRq8FyjY4TUN523LB24WxN/J4208g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7674
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMS8zMC8yMyAwMToyMSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFVzZSB0aGUgYnZl
Y19zZXRfdmlydCBoZWxwZXIgdG8gaW5pdGlhbGl6ZSB0aGUgc3BlY2lhbF92ZWMuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCj4gLS0tDQoNCkxv
b2tzIGdvb2QuDQoNClJldmlld2VkLWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEu
Y29tPg0KDQotY2sNCg0K
