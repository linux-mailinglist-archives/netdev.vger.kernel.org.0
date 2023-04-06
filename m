Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 349D06D9C83
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 17:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239786AbjDFPh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 11:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238842AbjDFPhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 11:37:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071F57EDC;
        Thu,  6 Apr 2023 08:37:23 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 336FUjAB005418;
        Thu, 6 Apr 2023 15:36:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : date :
 message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version : subject; s=pp1;
 bh=L3SVa8SqTWJ5UKVO4GIS7FMD0+DdR4PQnT93FtyD864=;
 b=pgaut+xIq1hrpXRF0e+88GcQxgENKifbCcYrpxXN/KCSt1+OuOrlsZJD+EFqdjufxVVH
 mRPdoDkqjYeRyIX4L72zViylMc3nlE1bRlXU8b+bPhv18JAwLxbR814XBBsOz0kfCaxh
 UEobkEVSGdHBec/QEJs3YgFjvlJ0MfO5Ai4j3P2uzqmHmeMn01c+/qbbcmB7/BObjVLH
 ne1KV2KuRFrf6YnwEWjeAo20UlS1OqQfhLlWwn8woVct/9GB90qqyKQbnp7cBOtM41LL
 gc58ljdbTzuxD+QaA7RHmuJNTlBaMc4BKHp7y3T4X1mJgku72PTxiG1GbfUHD6Abu9BZ pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3psajnyt3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Apr 2023 15:36:51 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 336FVDR7009295;
        Thu, 6 Apr 2023 15:36:51 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3psajnyt24-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Apr 2023 15:36:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nABTcdPL3G5wwoPZBwoCv321SkgnrqpDWuDLpK6cPU/e59yXjMGf7N+yY4hZVje8RPQMkJwBZvLdZzSX+ab/JGi22EV/B/Co+5806oEtqFb/ME9Ab9CNTFp/8r3cl389jOdNc0mxiIItXNIKtkBy45Q7+AIs2oV9JzCuw7EE+mm46CEDEtjaJXqs0sItfVn727VhimBBFl5o2PBKFXu7BUrMzMVmRfApGXfHk8NX5Xa0z0l9ag/yw/AqAuw1qFxF0FBGZhxX9RNmPRYBP1pc32DeM03B1b/vp8M30NwnPS6XeIgC6XC18sCWslvp6aGnXYrzAEkZFTE1H4QDK+bwJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L3SVa8SqTWJ5UKVO4GIS7FMD0+DdR4PQnT93FtyD864=;
 b=RqmF9KqbKKDpPMQTbfnxH+0fKFASFl/r/nOnHHUjiQLZeJUgmTyH6NAW1jS8ai3SRB47angVvd0l/vw/CyDwZZ/1G1yMKp7VKScUEm71pXX62BajmRi3GYxY2+K1W3ampaOtTlhLs4xzkBQ3MDEagGcI6zlqW0fEUSUjxsZ8mDJpnzGFJqCFQZVxgUETeR92k3Q2/8NvJp9v7qdh4pauK9BExfwhNomBRB411QA84PF6Otw+8gESUSr1EGQNcvNg+2ZjI6TqGDo3xYsdf+2ONQtWCrciHgR4tLkY1l3nZxA+sKi+GSP62VBmhhHlDqyu6jK3OETQ8gGkTWK+3H3g0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=zurich.ibm.com; dmarc=pass action=none
 header.from=zurich.ibm.com; dkim=pass header.d=zurich.ibm.com; arc=none
Received: from SA0PR15MB3919.namprd15.prod.outlook.com (2603:10b6:806:91::20)
 by DS0PR15MB5622.namprd15.prod.outlook.com (2603:10b6:8:11d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.30; Thu, 6 Apr
 2023 15:36:47 +0000
Received: from SA0PR15MB3919.namprd15.prod.outlook.com
 ([fe80::4746:c32d:b4d2:ad88]) by SA0PR15MB3919.namprd15.prod.outlook.com
 ([fe80::4746:c32d:b4d2:ad88%5]) with mapi id 15.20.6277.031; Thu, 6 Apr 2023
 15:36:47 +0000
From:   Bernard Metzler <BMT@zurich.ibm.com>
To:     David Howells <dhowells@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>, Tom Talpey <tom@talpey.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH net-next v5 11/19] siw: Inline
 do_tcp_sendpages()
Thread-Index: AQHZaGxBf42EhczWC0WoN7vVhCUiCq8eakHQ
Date:   Thu, 6 Apr 2023 15:36:47 +0000
Message-ID: <SA0PR15MB3919B83A4591FE06F6572EA899919@SA0PR15MB3919.namprd15.prod.outlook.com>
References: <20230406094245.3633290-1-dhowells@redhat.com>
 <20230406094245.3633290-12-dhowells@redhat.com>
In-Reply-To: <20230406094245.3633290-12-dhowells@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA0PR15MB3919:EE_|DS0PR15MB5622:EE_
x-ms-office365-filtering-correlation-id: 3b8a736c-60f4-44b7-5403-08db36b4bbe0
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R8dZMVocaRBBDkxzvLMUrgxN8Qr/Cab0ILf1hry8q+rrv8dD3In6G9vcgWqylWSJtHjYBuS/EtNZrrc9MpWzWn8ttbQ827KG50srWiWXYQC5vX42jJgJmuz6HwqAebjV25eOnSUaPYhZacOlBreG4u8nMREMkUMn363LApbgXTjeADi0Q9Qghi33Y5QU55t9wegxymeUFJU54hzGDY3MKCMBmmQ59kfEEEqcRK+OlPF6qOOKZjXfWMBFnkGlDrXSD7+kcFs1TKfcMesdKCnXFiCuLBTVlCpnEaPrkY+K3qqAXeGZeMk2LtHnL+cJMqmSeFPaH02NCKrmNeh6q2jlLOkpcaY9lDLgIKW938xYgZm+jRyVbnVqTCIJmetn7BJrKoFJQ05OFTdns4KNBbYcHKzhbAsOlXKk9OhNleKX23jWSGhn773mftxp7m8sbH+zC57UZT7aYjMfOzKHMYmbthVvrd/WiRBpPrA+pSXw6vK0HcozHsa4d8qXqzV8wQJe/M5bWRI0Gywt2orX7+Oj+FsWqR5uJZrh/L573cIgBCif7K3LSfSGwpamhD1a1AeyeQr1s0JDN1VySEnx5Jf0iL4U6iTv1z+RjVsUw4IdnfXOfXAa4klQlZQwDRXz1wwp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR15MB3919.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(346002)(396003)(366004)(39860400002)(451199021)(83380400001)(71200400001)(66476007)(33656002)(7696005)(66556008)(55016003)(7416002)(38100700002)(66946007)(66446008)(4326008)(8676002)(5660300002)(64756008)(76116006)(38070700005)(52536014)(122000001)(8936002)(41300700001)(2906002)(478600001)(54906003)(86362001)(110136005)(186003)(316002)(53546011)(9686003)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dDlYUjV3aE4vNlhtMnNSMFVIaXlOVjJOemRkcGlKNGtHWnlJUHJ2eXFrbTdU?=
 =?utf-8?B?dHpXZHN3aGdkUEJMZXdEZzVxck5QbjBiWHp6MndrMTJ1ZXFoZ3BrUnJJTCtT?=
 =?utf-8?B?VS9jd1pHN3dRTW1BaWRsRGNNdDZFSXJXa0RXU2ErbHd4VmhmLzg3Rk5rVHZ2?=
 =?utf-8?B?bjB4MHEraU1zQWN6OHZFQytYRG9XRGJScVphNnQ0WktzU1dVTHVkYkZEa25m?=
 =?utf-8?B?TWJ0a05wMm9GNkJYRHZnYWtrK0lZUEN3MXRMeEJMaVpRWTVaNVA1QXc5em9k?=
 =?utf-8?B?STRoaCtyYS90UkdNbmc1V05ha0NRK3A0RHRJbEpSNElFa1lodEFhQ3hoREhL?=
 =?utf-8?B?ZG42VG00dG5CQ3E1V3A0ZC9PZmx0bS85TlIzSFplL0tDcFE3Y2c2WnJHYVAy?=
 =?utf-8?B?V1NnMEdVb3NTbG13c2dEVjZkczhEZXdsT1pwR3EzTFBpK2pFZVk4dnRyWHRR?=
 =?utf-8?B?bmV3ZmlzbjNxOW1GNzU0WmhVTGRDUWlPQlFrVHJnKzliY0FjQkFMRlUvYXpM?=
 =?utf-8?B?aEZNRlExcGdjR2tuSUlCTVFjWFJXc2hpTjBoa2YxT2VCQmJuWEE3M1VrN2hS?=
 =?utf-8?B?MjgwMVlMMDlJcUg4d09HNWNreEhvcitGZEx4L2pmVWl1bG55b09zWHYzYXpt?=
 =?utf-8?B?RXdybEJUWmtITWNzWGF1bnl5Yi9jZVMxZEFKeVd3dWdHQ09xUm1WbzR3KzAz?=
 =?utf-8?B?S1FtUGtVVWZXMFFoYkpyUFZWbU1LTHB1S2JmbURuZVZkbXUzN0VYMmlXcGZO?=
 =?utf-8?B?YVhSUGd5TzRld1g4VnJkckp5WlFRY1gzTWpMOUNQbUNhZ0U2ZTNRTjdFM1dN?=
 =?utf-8?B?NWg1RnByVThsOGVEZCs5eG9Rai9pQ3hxUUs4ZXUrM2U2RGREZWpvYjZkRGwv?=
 =?utf-8?B?VTByeGViNUtOcHhLQlA3TTl4bVpNU3VyRUM2ZlRVRDQ1Z3NCZjVMMnJQQlpw?=
 =?utf-8?B?L3pyYjIwOUt2SFNZWmxPQ0RBcnVCTXNpNHpSdFN6eE9VOHlDWFV4bVFOZ1pS?=
 =?utf-8?B?Z0xENmsrVTloQU5rYlI5SmFzUmt2UUJtL2FYN0xldVdRTExIOTI0a0xIVlgz?=
 =?utf-8?B?R1ROMTREUEF1eHBHbUNnakJVeDkzL0RBTUtneGw5YVJKK0dqTGExVHAyK0ps?=
 =?utf-8?B?UVlhWCsvOHNyTDArNE5kdktzOExzYW1ibU80WWFCeTlJNnRlL1E1ZzZqVXl5?=
 =?utf-8?B?K25IRTAzVjRhUmY0dnpuL0NNYUVNSDhVSXp5WDZmQXJSb1E5V3owRG9uTnpL?=
 =?utf-8?B?TE5JYXVuR1cySHNKM1A5WERDU3pBRU51UysrNk92WXJHdDc0U2hnYVhWYkM5?=
 =?utf-8?B?T05hOENWVmR6UXkzbC95YXFDMSt1d0k1UGRTY0xaMkxEdVl0OWxCYkNlbndT?=
 =?utf-8?B?MThnNyswOEp0alBGSXdKQUJsK01CR282L3JHSGd3ZXVOTnJxZ2JxTEVWQ2VL?=
 =?utf-8?B?Zk5JNDRJRVV0NXkzbnU1N042TkRLOHVxVXZKQjdWaDBXVmxsWUpBRVZSUWlP?=
 =?utf-8?B?N1AvTFR0ZWovNSsrS2pvSHJ2bkZwSFdXcERHTkM0dnRIZUpFSk1BdWtIUk02?=
 =?utf-8?B?dXFJdGV2SmNSM0puL0JIQWhrOGJnZmpubElQL2NkZTIwZlJTNEZsWUplYThm?=
 =?utf-8?B?RnVBdFkrUlBJRm42Y21LNEZaQ2JRL2drbDQ1M0Z0cXRNZnVZYmJFYVIxcGNK?=
 =?utf-8?B?Mm1NYTRvaisxRGlvRHZvZ0ZOenZBMFJXNzBsTEVmUTFnako2Z3J6R2lHYjZr?=
 =?utf-8?B?b21mbmQ1MDJWa015dWtNU3BHQU9Rakg1Z3dDS24vdUN3L3BhZVlFNXZqdUVF?=
 =?utf-8?B?SVdWLzJTam0wR1EyY2FNM29WclZicTRqUVpaUTdlendOWmhvTWRoNHl2WWw4?=
 =?utf-8?B?UERlZ21ISlZoTE5KVlQvOTlRV04yUlhNSVk4dFM5MEpPUUhtVXdwS2l0TVg0?=
 =?utf-8?B?VWs5R005blBQQ0VxYjdHanJaUk90andaRW5DUVJuc1FzZ3lnaXI3QnRDRmZY?=
 =?utf-8?B?YWxFSUwvYXJjV2NZMmlMTG00UkdQY3F5bmg1SnF0MzBaUXRZUFBscnJSQXBo?=
 =?utf-8?B?YXhCUFkzSXU5SW5WaHlrcnRjaDY2WlQwcmZIdE9kMUV4UGhGbHpEKzN1VnpC?=
 =?utf-8?B?T2gzZm1GQnZzVTB6NTN2NnFtbzJzSVpuekZqQllsR2xlanJIb3hSM3ZUQldM?=
 =?utf-8?Q?M2AOXR+6XkhvClWemoaH5Hg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Zurich.ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR15MB3919.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b8a736c-60f4-44b7-5403-08db36b4bbe0
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2023 15:36:47.6953
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N+t8UTu3kUasILVr564AdNqQtw0YC90Y8eM0h7GeB3YNmcaGOtmc6fE7zoE2jWdCkimh4vOBU2rY817z6C2Lxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR15MB5622
X-Proofpoint-ORIG-GUID: ZUb25h3_lur6-dKjmUUr1g_8u-b4EkJz
X-Proofpoint-GUID: o9oBUpMXhTgz7fvW_GwOZRf5dJNRVtoK
Subject: RE:  [PATCH net-next v5 11/19] siw: Inline do_tcp_sendpages()
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-06_08,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304060134
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRGF2aWQgSG93ZWxscyA8
ZGhvd2VsbHNAcmVkaGF0LmNvbT4NCj4gU2VudDogVGh1cnNkYXksIDYgQXByaWwgMjAyMyAxMTo0
Mw0KPiBUbzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBDYzogRGF2aWQgSG93ZWxscyA8ZGhv
d2VsbHNAcmVkaGF0LmNvbT47IERhdmlkIFMuIE1pbGxlcg0KPiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5l
dD47IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT47IEpha3ViIEtpY2luc2tpDQo+
IDxrdWJhQGtlcm5lbC5vcmc+OyBQYW9sbyBBYmVuaSA8cGFiZW5pQHJlZGhhdC5jb20+OyBXaWxs
ZW0gZGUgQnJ1aWpuDQo+IDx3aWxsZW1kZWJydWlqbi5rZXJuZWxAZ21haWwuY29tPjsgTWF0dGhl
dyBXaWxjb3ggPHdpbGx5QGluZnJhZGVhZC5vcmc+OyBBbA0KPiBWaXJvIDx2aXJvQHplbml2Lmxp
bnV4Lm9yZy51az47IENocmlzdG9waCBIZWxsd2lnIDxoY2hAaW5mcmFkZWFkLm9yZz47IEplbnMN
Cj4gQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz47IEplZmYgTGF5dG9uIDxqbGF5dG9uQGtlcm5lbC5v
cmc+OyBDaHJpc3RpYW4NCj4gQnJhdW5lciA8YnJhdW5lckBrZXJuZWwub3JnPjsgQ2h1Y2sgTGV2
ZXIgSUlJIDxjaHVjay5sZXZlckBvcmFjbGUuY29tPjsNCj4gTGludXMgVG9ydmFsZHMgPHRvcnZh
bGRzQGxpbnV4LWZvdW5kYXRpb24ub3JnPjsgbGludXgtDQo+IGZzZGV2ZWxAdmdlci5rZXJuZWwu
b3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC1tbUBrdmFjay5vcmc7DQo+
IEJlcm5hcmQgTWV0emxlciA8Qk1UQHp1cmljaC5pYm0uY29tPjsgSmFzb24gR3VudGhvcnBlIDxq
Z2dAemllcGUuY2E+OyBMZW9uDQo+IFJvbWFub3Zza3kgPGxlb25Aa2VybmVsLm9yZz47IFRvbSBU
YWxwZXkgPHRvbUB0YWxwZXkuY29tPjsgbGludXgtDQo+IHJkbWFAdmdlci5rZXJuZWwub3JnDQo+
IFN1YmplY3Q6IFtFWFRFUk5BTF0gW1BBVENIIG5ldC1uZXh0IHY1IDExLzE5XSBzaXc6IElubGlu
ZQ0KPiBkb190Y3Bfc2VuZHBhZ2VzKCkNCj4gDQo+IGRvX3RjcF9zZW5kcGFnZXMoKSBpcyBub3cg
anVzdCBhIHNtYWxsIHdyYXBwZXIgYXJvdW5kIHRjcF9zZW5kbXNnX2xvY2tlZCgpLA0KPiBzbyBp
bmxpbmUgaXQsIGFsbG93aW5nIGRvX3RjcF9zZW5kcGFnZXMoKSB0byBiZSByZW1vdmVkLiAgVGhp
cyBpcyBwYXJ0IG9mDQo+IHJlcGxhY2luZyAtPnNlbmRwYWdlKCkgd2l0aCBhIGNhbGwgdG8gc2Vu
ZG1zZygpIHdpdGggTVNHX1NQTElDRV9QQUdFUyBzZXQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBE
YXZpZCBIb3dlbGxzIDxkaG93ZWxsc0ByZWRoYXQuY29tPg0KPiBjYzogQmVybmFyZCBNZXR6bGVy
IDxibXRAenVyaWNoLmlibS5jb20+DQo+IGNjOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0B6aWVwZS5j
YT4NCj4gY2M6IExlb24gUm9tYW5vdnNreSA8bGVvbkBrZXJuZWwub3JnPg0KPiBjYzogVG9tIFRh
bHBleSA8dG9tQHRhbHBleS5jb20+DQo+IGNjOiAiRGF2aWQgUy4gTWlsbGVyIiA8ZGF2ZW1AZGF2
ZW1sb2Z0Lm5ldD4NCj4gY2M6IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT4NCj4g
Y2M6IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+DQo+IGNjOiBQYW9sbyBBYmVuaSA8
cGFiZW5pQHJlZGhhdC5jb20+DQo+IGNjOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+DQo+
IGNjOiBNYXR0aGV3IFdpbGNveCA8d2lsbHlAaW5mcmFkZWFkLm9yZz4NCj4gY2M6IGxpbnV4LXJk
bWFAdmdlci5rZXJuZWwub3JnDQo+IGNjOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IC0tLQ0K
PiAgZHJpdmVycy9pbmZpbmliYW5kL3N3L3Npdy9zaXdfcXBfdHguYyB8IDE3ICsrKysrKysrKysr
Ky0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMo
LSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2luZmluaWJhbmQvc3cvc2l3L3Npd19xcF90
eC5jDQo+IGIvZHJpdmVycy9pbmZpbmliYW5kL3N3L3Npdy9zaXdfcXBfdHguYw0KPiBpbmRleCAw
NTA1MmI0OTEwN2YuLmZhNWRlNDBkODVkNSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9pbmZpbmli
YW5kL3N3L3Npdy9zaXdfcXBfdHguYw0KPiArKysgYi9kcml2ZXJzL2luZmluaWJhbmQvc3cvc2l3
L3Npd19xcF90eC5jDQo+IEBAIC0zMTMsNyArMzEzLDcgQEAgc3RhdGljIGludCBzaXdfdHhfY3Ry
bChzdHJ1Y3Qgc2l3X2l3YXJwX3R4ICpjX3R4LA0KPiBzdHJ1Y3Qgc29ja2V0ICpzLA0KPiAgfQ0K
PiANCj4gIC8qDQo+IC0gKiAwY29weSBUQ1AgdHJhbnNtaXQgaW50ZXJmYWNlOiBVc2UgZG9fdGNw
X3NlbmRwYWdlcy4NCj4gKyAqIDBjb3B5IFRDUCB0cmFuc21pdCBpbnRlcmZhY2U6IFVzZSBNU0df
U1BMSUNFX1BBR0VTLg0KPiAgICoNCj4gICAqIFVzaW5nIHNlbmRwYWdlIHRvIHB1c2ggcGFnZSBi
eSBwYWdlIGFwcGVhcnMgdG8gYmUgbGVzcyBlZmZpY2llbnQNCj4gICAqIHRoYW4gdXNpbmcgc2Vu
ZG1zZywgZXZlbiBpZiBkYXRhIGFyZSBjb3BpZWQuDQo+IEBAIC0zMjQsMjAgKzMyNCwyNyBAQCBz
dGF0aWMgaW50IHNpd190eF9jdHJsKHN0cnVjdCBzaXdfaXdhcnBfdHggKmNfdHgsDQo+IHN0cnVj
dCBzb2NrZXQgKnMsDQo+ICBzdGF0aWMgaW50IHNpd190Y3Bfc2VuZHBhZ2VzKHN0cnVjdCBzb2Nr
ZXQgKnMsIHN0cnVjdCBwYWdlICoqcGFnZSwgaW50DQo+IG9mZnNldCwNCj4gIAkJCSAgICAgc2l6
ZV90IHNpemUpDQo+ICB7DQo+ICsJc3RydWN0IGJpb192ZWMgYnZlYzsNCj4gKwlzdHJ1Y3QgbXNn
aGRyIG1zZyA9IHsNCj4gKwkJLm1zZ19mbGFncyA9IChNU0dfTU9SRSB8IE1TR19ET05UV0FJVCB8
IE1TR19TRU5EUEFHRV9OT1RMQVNUIHwNCj4gKwkJCSAgICAgIE1TR19TUExJQ0VfUEFHRVMpLA0K
PiArCX07DQo+ICAJc3RydWN0IHNvY2sgKnNrID0gcy0+c2s7DQo+IC0JaW50IGkgPSAwLCBydiA9
IDAsIHNlbnQgPSAwLA0KPiAtCSAgICBmbGFncyA9IE1TR19NT1JFIHwgTVNHX0RPTlRXQUlUIHwg
TVNHX1NFTkRQQUdFX05PVExBU1Q7DQo+ICsJaW50IGkgPSAwLCBydiA9IDAsIHNlbnQgPSAwOw0K
PiANCj4gIAl3aGlsZSAoc2l6ZSkgew0KPiAgCQlzaXplX3QgYnl0ZXMgPSBtaW5fdChzaXplX3Qs
IFBBR0VfU0laRSAtIG9mZnNldCwgc2l6ZSk7DQo+IA0KPiAgCQlpZiAoc2l6ZSArIG9mZnNldCA8
PSBQQUdFX1NJWkUpDQo+IC0JCQlmbGFncyA9IE1TR19NT1JFIHwgTVNHX0RPTlRXQUlUOw0KPiAr
CQkJbXNnLm1zZ19mbGFncyA9IE1TR19NT1JFIHwgTVNHX0RPTlRXQUlUOw0KPiANCj4gIAkJdGNw
X3JhdGVfY2hlY2tfYXBwX2xpbWl0ZWQoc2spOw0KPiArCQlidmVjX3NldF9wYWdlKCZidmVjLCBw
YWdlW2ldLCBieXRlcywgb2Zmc2V0KTsNCj4gKwkJaW92X2l0ZXJfYnZlYygmbXNnLm1zZ19pdGVy
LCBJVEVSX1NPVVJDRSwgJmJ2ZWMsIDEsIHNpemUpOw0KPiArDQo+ICB0cnlfcGFnZV9hZ2FpbjoN
Cj4gIAkJbG9ja19zb2NrKHNrKTsNCj4gLQkJcnYgPSBkb190Y3Bfc2VuZHBhZ2VzKHNrLCBwYWdl
W2ldLCBvZmZzZXQsIGJ5dGVzLCBmbGFncyk7DQo+ICsJCXJ2ID0gdGNwX3NlbmRtc2dfbG9ja2Vk
KHNrLCAmbXNnLCBzaXplKTsNCj4gIAkJcmVsZWFzZV9zb2NrKHNrKTsNCj4gDQo+ICAJCWlmIChy
diA+IDApIHsNCg0KbGd0bS4NCg0KUmV2aWV3ZC1ieTogQmVybmFyZCBNZXR6bGVyIDxibXRAenVy
aWNoLmlibS5jb20+DQo=
