Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB776251BB
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 04:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiKKDfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 22:35:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbiKKDfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 22:35:04 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061.outbound.protection.outlook.com [40.107.92.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0F253FB97;
        Thu, 10 Nov 2022 19:35:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VYWRT2vltpF9n8LF9QKil8f5wsvuzSkkPG0w2wAOxJ//mXxsOoJy7z/wBX1vxcRKayCUogubkuLojCIqg8RUNMYM/ihOZPRnOEBsOho7X1E8YRSRi29pnwhCXN5bCiAuGCmLYqUa/WWI4FaM3T3AsjsJY36Piev6+K4E0dcYbR0Y7N5/QyLwyWFDfNndtOsTOQYgj7298ducuAUju309BLEN1X6rlg2d/OcNt6aSCF1sh5Ff3Ena2dHL+OGXo0VNxdsCPoMeAWyTiiUNBThSdsorz+Ec3bI/vsHuBlxuqNTZ6gvV030IIR89iES/1fRJuwWm02Yu4JkiRk1JjCF47Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YKBCJshRQtFFAzlR0+FZ+o7YDpCLTvLfMO0T4c4jmJQ=;
 b=PdzcAmIdsjnD9CEfvyEU/nO8/pFW5Dta4mIhMvVrfSkFRN6bbEcnPf6sF+6NXdgKntobN1vHd2sG6UJVk8DeuFseZXooPyB0UkE29ywItZ+Eq1fD9LoyQ6/FQXr8Z6oCHUhpL6D0i9XgzZqBWi5Fr06HgUAnT7cfHVCOMfrff10iQUd8Yuy6sUpqeuiZJUTOxz4dSUDRJn4YfBFF9CQkkxxwYAEk4AW/EFYpRQkaK6tGa5EVHHBS3DNs6WTO+7SwmsPeIMNqKUodXACEVGtBysWJtQCaytWt78LPQQC0WCCu4cFoYLfFR+oDx+aAF3i9vBrxgpYwdc1AihX90OPQxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YKBCJshRQtFFAzlR0+FZ+o7YDpCLTvLfMO0T4c4jmJQ=;
 b=BfuYXH+YCKxrSpkERXsfXbB8BO9WlioBgGgv2pSIWRSFTttRMpRUML6zRVNN+4gWSQFr18JDJdAYfh1EQYfyf/PTT7O389Ii+vKRE667EYmBlONVcCKGyiVhFDAZUNauPJ2ypmIings+WuQfD4E9bTdI6a6XacLuyLXqj24dARFoDQ7negRDmHKnPbOfiOppS88t/mxg377XV5p3Vwfq1rqZpn/ec7OIOW96fS+4iBsUx3jM6e08E7AP8DA2MF6nRensnPT7OFqdqNpbB9xvagQEdfK+Cd5aACozG4iT8vhLxRkipyyk81eM6yFdPoe2Ncx0hH3+VOKGwlU46FsFFg==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH7PR12MB6719.namprd12.prod.outlook.com (2603:10b6:510:1b2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Fri, 11 Nov
 2022 03:35:01 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::d756:c945:3194:629e]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::d756:c945:3194:629e%8]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 03:35:01 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Yanjun Zhu <yanjun.zhu@linux.dev>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "leon@kernel.org" <leon@kernel.org>,
        "zyjzyj2000@gmail.com" <zyjzyj2000@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     Zhu Yanjun <yanjun.zhu@intel.com>
Subject: RE: [PATCHv2 0/6] Fix the problem that rxe can not work in net
Thread-Topic: [PATCHv2 0/6] Fix the problem that rxe can not work in net
Thread-Index: AQHY2NgsxqGsQT8SNkWIqw44pMlMnK4V5FKAgCNW14CAAA/sEA==
Date:   Fri, 11 Nov 2022 03:35:01 +0000
Message-ID: <PH0PR12MB54811610FD9F157330606BB7DC009@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20221006085921.1323148-1-yanjun.zhu@linux.dev>
 <204f1ef4-77b1-7d4b-4953-00a99ce83be4@linux.dev>
 <25767d73-c7fc-4831-4a45-337764430fe7@linux.dev>
In-Reply-To: <25767d73-c7fc-4831-4a45-337764430fe7@linux.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|PH7PR12MB6719:EE_
x-ms-office365-filtering-correlation-id: 8a3d7957-b8c2-49f1-3c10-08dac395b706
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6bT8eWLYWWX83aLkJR6V3vgq2tQ2NtpwwqiHALs8zd7vKyTwb23YUYPl8zD/3BvhSkEfXSJWEJQOUd61ATqeabYHXiH56serxUVDy260D6j724dRmOnD1x/vPXZPHqhZ2psmdLKbrJatCwbMe1eaDkLPywZ2wQnfEwNVhZEEMpNU6iPpwVc82gosDVWL8kkNENiO2jANIE/0+MgYgx8v5tXRWeEyB47f1DBF7SDLYgGoCcLoL45ECgNq5v8l12l3QdeTU3v/z5bigSK5m/UznUFy5uvEKzp5fa/AcLHpgVQiWLWKJ5EF4eNBxo36ZnrZ9fFUs+HU66JkcRe6LUWbc//Y6/4+9+thpNLmtgxwI7eQ2EfUrMpOBOKu/m6WHIhisR1X25LUa7vyHpMgpeeIAg08QkjwLNpdr9tFUgidWbdeq0+5KWUh8Li4ewqc+ql6lubYCfy6zd0bD6Q7y066a1rSloXyThFON65ocMI+EF+3Dnhdl6MeSq+PKVFxE+BqAE5ECblAxGn39bm80lTvGRPU1eZ4E7R5d9vkll7qNgu8oklRabhLhH6F5U8y6zNunumprnvqhS1S2/i5y6ZrdXvwsB3+/gu6cH/ajN3j3NgIIlwTOJDnOiAqQYN+tVw5AXz8UE7LntjLYONooQ1vNOm/kxFag5ktMZv7zVhvvNn7h012VRTW1n7bPKci8Sz/lMxlWGMDnZ+wC3B/eWR08BjXUeLOjPDaVcF38NuLob7NvDxwys3GyjvPcdu8CqpIQyPuhROXsvqd+/7sgIwmBg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(346002)(366004)(376002)(84040400005)(451199015)(52536014)(86362001)(2906002)(8936002)(26005)(33656002)(76116006)(186003)(316002)(66946007)(558084003)(55016003)(5660300002)(38100700002)(110136005)(478600001)(38070700005)(64756008)(4326008)(66446008)(9686003)(41300700001)(7696005)(66476007)(71200400001)(122000001)(6506007)(66556008)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZlB2Q3hlcDVtZkVQRWRXU3hESEJmWmJIZlQ3Y2JxK0pERktMZmxLRTY0anRq?=
 =?utf-8?B?M002QnVTNGxFbVhNNWM0bkN5SGZzQXlIVlVUNi9XSEQ5NERwTEFxeElhUzNR?=
 =?utf-8?B?ZlBnemVtQ1pvVlpOcXRWcldFdG5jcUJMM093cnNaOEhkUGRBS25aYlA1T0lq?=
 =?utf-8?B?dnYycXA1ZkhUVlNqdm5HT0tYUnc0elk3c1gzeUc1NUt5cGRraThyRG5pNmVj?=
 =?utf-8?B?SXhZRG9uclZQbnZsQlFnSTJMamVaaEt3MThFWTMzKy9HNDNWU2lHMm5BMnQy?=
 =?utf-8?B?eEdIbExOYkd5d05STVIrYjJjZGV1cVZXQ0h6eHR6Q0dzdHhTNnJBWTErY0xh?=
 =?utf-8?B?QjFPVGZjUlVKbEVINGNiOEhnMUdnT0FGb2Zla25sUVlZK0JsVVZjbEZpZXRu?=
 =?utf-8?B?TzViNWFiSEhpY0xMZzUvU2RtaUsrSFczV0lCMExlT1ZFOVBEdnFYQmN3bnY0?=
 =?utf-8?B?U0VIVHhnWXVUU3c3a1RuYmkzYzYwc2g5WG9JREFtaXAvd0VzcU1WQlVON25j?=
 =?utf-8?B?TDUvVjN0UDVERU42N2laakdKQ3A2NTY3OFJGRXZzaTZJR2c5Y2VmZ3EyU3l4?=
 =?utf-8?B?bDJOczF0SUExZWZSdmwxbzJxRjA5VWFIcTd6eUZMU3BoWDBOellMS1F1SFJM?=
 =?utf-8?B?K0tmT1hxZjVUeDQwQWs5L0FncEp5QjJaS0xwdG9lVUVSbkZISzNHTmxjRGY4?=
 =?utf-8?B?bDR1TzN1TWR5ODRUTEZlcTlOS1E2b1VqWGN6NXpER1JubVdmd1VjcVN3YzA5?=
 =?utf-8?B?eDNrZXZYN1BHTkgwREpud25TTXRpblJsalUxREpoVm5hOUFZME52c2NIa1VQ?=
 =?utf-8?B?dUlhVjJhSVdlT0p3VW4xbUV2VEMyVG5hWTFkZThKaVRHY1VuTmhMMGgyL2lt?=
 =?utf-8?B?WlluYmV0VjNTM1FJb1pyVVlIcElpbWt6UUdwb0NEQVdYWmVFaUdmakhlWDI2?=
 =?utf-8?B?WFA1V1h1ZFF6eTJGbDFjamt2TzlJYnF2enNRYnVWdmJhNVhKMjBYSWthN05L?=
 =?utf-8?B?ajQ2R3kvVmtyWVdheTVya21meWgybys0K3hWZFBjRjdQN3Npa055TTZUc2Jl?=
 =?utf-8?B?RXVVRGVUU3U4eXIwa1M3ODNaRERBcWY2MDJPMUs4bHNCTEF4MzZZcjhxNE1z?=
 =?utf-8?B?bVFUOGpBY3NtNWFLVEp3Q0RkQzVVelExZjAxTjRmWFBpYXhwWWlQa2hLZHpa?=
 =?utf-8?B?ZzZrc1hMQ2I3Vk5qUkIxb29yd1BNVHpEN05uQU9sVHZEWVhxR3diUnFmNzR0?=
 =?utf-8?B?NjlkK1NnZXBzcXhIS29TeEdxNGYxZUZaSDJ1dnFtZ0JrMVpOOG9jbURNYWVB?=
 =?utf-8?B?cHpBemsvTjc0NFdzbmVKNDAycXIraWRKRVlBTHRSeUp0NkhPNDNidTNzRmVa?=
 =?utf-8?B?ZnZRR3NpNWpIeFNFY0RhNmI5U01CR2tVaGV0UFpqYzQwbXBCWk5vSnE1YmZE?=
 =?utf-8?B?ZVpRS2VtUUN3WGV1RTRrZzNaN0NQNXg0K0FJYjF6YzY1NFZLdjQ5Zyt0bExn?=
 =?utf-8?B?TUtTTDcxMm4xcXJtZ25SdE13OEhqTWdQQmRTbTdVVjRHOWxaazg1NWhKTFdR?=
 =?utf-8?B?REU4Y0dYVHQ4ajN4MzNRMHk0N0dBZU5GS09IaGRUN1p1S3ppRkMyY0prcFNG?=
 =?utf-8?B?T2JHczZ4VjlwT1hLdmJmMDZ4dmtYaWZlcHQwdFZBV1lVdHNVU0pqeWN6SjNM?=
 =?utf-8?B?cHJVMGtCU2F5SVFGM1YxQ1NTWXArcFRXRmFBbTgxQVdXamZKcWZtMWluWHV4?=
 =?utf-8?B?TkIxRHhlakpaTzlhMXV4RnlnY2lDNVl5aThxUDcxNGR5ZUFYTUxrZUNzWDcr?=
 =?utf-8?B?My9BTklJWm5haFRIQ0J2NW1NaG1wSko5U0x4b3lJbC9kdElRNkUxdlA1bHlk?=
 =?utf-8?B?QzQwdUlDajkzVHZhbmQwK0FqSmdpRWlCNEdaSE1ibkxmdWV5RVhNTURoeFhn?=
 =?utf-8?B?RnJ0YlByVlR0bzE2NWxuVU1EK3NBdFpQR0lEOU04TTZvL3ZFYWpsZjVxNzFW?=
 =?utf-8?B?R0ZGMkhORU1XSk1nakpXSjdLUUxNS2QycDFyY0VZdXpPb0V3bHpuVTVIakxD?=
 =?utf-8?B?Y3lzUzVrNW92ZzZuUXVsYXdRaTZGRkNtN1h3L3dyeGtsYk0rVjVmUzFjb1VD?=
 =?utf-8?Q?Jkjg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a3d7957-b8c2-49f1-3c10-08dac395b706
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2022 03:35:01.4215
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FwUuT3/SJmcZVQBRP5juv8KA64P2zJjVROikRjdbhP9snTA9DTePyNVf/sc5OeyUkPOrGWR5JTWG7gXe5Jjqhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6719
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IFlhbmp1biBaaHUgPHlhbmp1bi56aHVAbGludXguZGV2Pg0KPiBTZW50OiBUaHVy
c2RheSwgTm92ZW1iZXIgMTAsIDIwMjIgOTozNyBQTQ0KDQoNCj4gQ2FuIHlvdSBoZWxwIHRvIHJl
dmlldyB0aGVzZSBwYXRjaGVzPw0KSSB3aWxsIHRyeSB0byByZXZpZXcgaXQgYmVmb3JlIDEzdGgu
DQo=
