Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C82E06F14E4
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 12:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345802AbjD1KBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 06:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346031AbjD1KBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 06:01:25 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77A95FEE;
        Fri, 28 Apr 2023 03:01:03 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33S8a47n015730;
        Fri, 28 Apr 2023 03:00:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=jUl0bTLZiCItuwysh9t2pl0jMmNADjo+XKjKw6HWV2w=;
 b=MrpdgMjGP/lA2gqQEnTJMSamAfbOEyrboAl2lSBzNEellR1y4fcgAwFAcTOCdCAUbTwY
 IXq6MooDCwYd0k/WcUclWrcwUm8daGPm53R+ScHZj8w9texx9GyvfShVrlG1pJ11lLKv
 gAhIALJ2D0NYXhBXFY3Km51eIduQnoSav8FL5c7JgY+At8/N7LK78lihMqf8y7V49hLo
 cEaCIdahMiBWXq+y7qZN577ub+jXfzeXDgdJBG/N/rmTOJ7WNyra2eMsf+WAwP/DhLgj
 v52XQ6Y4O6DGMTWMHPAUZ089QUXqYeff3DvoB9HRO8f+B9XbYqFQnoB2ytMORup5Vlyn TA== 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2174.outbound.protection.outlook.com [104.47.73.174])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3q8as18f63-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Apr 2023 03:00:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aEUu8YtKNzTvolGjl8e7gjiWCV2+6uW5nvO0B9pvr8Bc5j4rEyufAP67eLGOOD6p/T0vlSe/ZX/xVhuKXsI+rznteRwCnlwOJNPb6MLY2P2bxU6rji7Kf1q8vJXcaxYihnbEyBRbSQkx/jJ0nnuckK5njLK/th1WMx96f6GLSRQWYnGbOpD/t6uzo/YxKURgTwSkI+9r9QIJR7VDFizP516uaSxLLr3mK9gnP7vdx7Su5dz2Xd4QjPi1xoDu971jgjYyUX31gW2C3S5DbEQ942/KQtpZZ7VtiUB3Dn9AIKrSqIPrOhjqX+fVmh77/95Gf7xbwr0uZPyHiYWlmu6ZCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jUl0bTLZiCItuwysh9t2pl0jMmNADjo+XKjKw6HWV2w=;
 b=I7h2YqCsQLlCP12Fps1d9nChuG/wfGGuC2nAvDTShmHlRWLIhoD8yyXasb5XgmRGKdP2qWukbCzxZ4S1Rm2vpoYuclU3GiCaBY6ppcz1+ASFGZobmjIBsWscaj+yrN2WENk1bcq69+EijUOOo1UJeH6Cj/X3mfEXRAo75rq4L9uVi+zxRR5gidlNocwCcEHuyzzbiJAVAjdT2dI92bxOuA5RyXiRNYxYzTrav/yZYLpFqynEwhiTy7roG/EMb7crcJrZ49dNtPyAo6dwf2k0XvJNRfw9iE7x/cS/BpBqvt2+HVtOck8o+jGX1onu/CFy6GQMiar6A7GvFu59eBE40g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from BLAPR15MB3874.namprd15.prod.outlook.com (2603:10b6:208:272::10)
 by SJ0PR15MB4726.namprd15.prod.outlook.com (2603:10b6:a03:37b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.24; Fri, 28 Apr
 2023 10:00:45 +0000
Received: from BLAPR15MB3874.namprd15.prod.outlook.com
 ([fe80::afc1:3e52:2227:fbba]) by BLAPR15MB3874.namprd15.prod.outlook.com
 ([fe80::afc1:3e52:2227:fbba%5]) with mapi id 15.20.6319.022; Fri, 28 Apr 2023
 10:00:44 +0000
From:   Vadim Fedorenko <vadfed@meta.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Milena Olech <milena.olech@intel.com>,
        Michal Michalik <michal.michalik@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "poros@redhat.com" <poros@redhat.com>,
        "mschmidt@redhat.com" <mschmidt@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        Vadim Fedorenko <vadim.fedoreko@linux.dev>
Subject: Re: [RFC PATCH v7 7/8] netdev: expose DPLL pin handle for netdevice
Thread-Topic: [RFC PATCH v7 7/8] netdev: expose DPLL pin handle for netdevice
Thread-Index: AQHZeXoxFr+o6A0/p0SGI2L+OirTf69AfaKA
Date:   Fri, 28 Apr 2023 10:00:44 +0000
Message-ID: <05bdbb70-b151-5823-01c8-e5f594817049@meta.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <20230428002009.2948020-8-vadfed@meta.com>
 <20230427193610.6d620434@hermes.local>
In-Reply-To: <20230427193610.6d620434@hermes.local>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR15MB3874:EE_|SJ0PR15MB4726:EE_
x-ms-office365-filtering-correlation-id: a59e917d-33ce-4dec-521a-08db47cf6ece
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yAFzZnibx/Q/1AK4pyMMGe2zSYtm2VSNzhkmLfeeu6ko833AnhiJYMhL+o1FSPxikTse86xAlmCpRawPCCVnv1jQzKWjYLqaAqiB/L+mt9k+tQRuVfdC1QJ3ev9C+Zbc9bqJBTGbzhsIa8QrDcWR88JQ7P/LanFkw7P82Qn97ew+y5BnSMypMnbzUEv0UJMiiI6dXixdRVTBOmtG3aMPKE0ibLbu/h4IgbCsAxX4qtGUBMej9QUbLO1wVjg7dyfTXxduzLet/NmqvYF1Wa42hSlLISeFvwWbU6MlPDpz2lk6mrr97ZcouhnwgEdHpLZMDfnn0sQ/lpnxGV8kRQqDLM0x2WoNvB8vVH85UY3lAdHQJCBpDaXPYdsB3pCMv/Qh5KD92r4itrCk12INAYMfW272bdC3afG9FkwLSv7YZg32miqRW6oG+LprH4Pky/sfbDhpJhqQH4zqTomCeHLccMoOPGdK5yxstKjw6tigMmILIXl+ThLxlpN1m9IiUz3MYQopn9NVhBJIvOtgrYvroSWYAgVD8XDYyPI+Ni4/sfgjMuv6i+eSJNcp02nfESVFMRaI4wg5P3eOPmEivxMYil7YNmAKkyvHGjHdv6fKIuAZEBbdzxPQr89EjeKMlzM3GVPeD6e/jHpDglkhxqypLA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR15MB3874.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(136003)(39860400002)(366004)(376002)(451199021)(8936002)(122000001)(8676002)(7416002)(41300700001)(316002)(4744005)(2906002)(76116006)(66476007)(66446008)(38100700002)(66556008)(5660300002)(31686004)(6916009)(4326008)(64756008)(66946007)(91956017)(83380400001)(2616005)(38070700005)(6486002)(54906003)(186003)(31696002)(86362001)(36756003)(71200400001)(6512007)(6506007)(478600001)(26005)(53546011)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eDQycU1GK2g5Ums4bEI4bDZtL04zTTl0Rld4aGl2RXVMSzF5YStmMDVjWE9o?=
 =?utf-8?B?NlJYUy92alZTaGhvS2hZMWpmRHl3ZXhkU2xpVy8zY1ViNysvQ2dxQ0lSQlJL?=
 =?utf-8?B?YXhiaG1DclFoZW1wb0dXa2VWbFRNWWFsRTFYc3B2UmhOVCtSTkp4TENiZm1Q?=
 =?utf-8?B?ZDY3bGw5dTRjSmN3UHRzWjU0SzJNaGRCcGJQZWxJempUQ3U3U0NPR0JtNE5L?=
 =?utf-8?B?MkJkalJOcytXbkt3Ulh3UFVOWVpKNXZ5WUJvdWErbkFzQmgrS2Z0YS9PeVhl?=
 =?utf-8?B?NTN0SXlHMUt1R0JmSlBVNzZLeW83cFNkcS9pQjMyOFR4T1NReng2QVZ4STds?=
 =?utf-8?B?WDlaT20zZlNrS2tQMktRTEpwMVNLcllIUkNlK2l3VWRSWVVzQ0dBOS9EUDZK?=
 =?utf-8?B?WVRpQjNNZklvdmVrOFNkUFA2Wmx2a0pJcDJNbDhvaW5CUDJ4MVVCNE1xOVps?=
 =?utf-8?B?RmNYZ1d5ZXRnRDdhdVpBVEFMdk80RG9CenBhMjU2TXVoeDZNdEhXRjcxa1ZJ?=
 =?utf-8?B?UVJlYVQyYTM1L05RZklzcWNGK2NyRGlsRXFBMXRMSDZPeXl6VkpubzU0a0ZL?=
 =?utf-8?B?SnpQeUpPclUrNE5TRXFHT3JBK1E2ampUbCtmOThpSDBvdFdkZ0FtU3VZUlVK?=
 =?utf-8?B?NGNKQ2NUOHlqTW02Y1VOTk9NYnNkeXZoUm1PT2hJMmpUWHRuWjJxam45Q2da?=
 =?utf-8?B?akNEdFJURG90VitrcjYycXR3Q0ZtSHV3Mk5qeWJpNVlURmliR2ovNUxzYllu?=
 =?utf-8?B?UTk1TGdhUi9lbkNwRHdPcHNMaHdzUEZCM2pvbThUOEIwN1dFMld1a0NyL1FY?=
 =?utf-8?B?Vlp3Nlg4Nkt2TDFIRmZXbks1Z0dOM1QvY01LSTMxK08zNG1oM2VJa0NtUUs3?=
 =?utf-8?B?bCtMQlluYXE3SW9vZTBzVThxRjFhSmIvMWNiMGN2VVZYT3JHZUpmdUdteXJI?=
 =?utf-8?B?NDVyRU1DM0FtMkZsd0xwT3VWZExZNFZab2JQRmc4c25tUHhCR2tHWTNTN2xk?=
 =?utf-8?B?WVNLbk14TzlJTW8rdk5kVyt3ZjFCMU1GcERoOHcxR1hqRVNTazFTd0Ezdkc1?=
 =?utf-8?B?UnNobkl4Mmk2WDNTRFhVV09xNFpJRlhRZGtBYWdlQk5XZUtobjdqbHBQVDJW?=
 =?utf-8?B?VHZBSGdRckw0cWhCbDI5TXkzNDFaWmRDRzdEOG9wTFdhei91MVZId3MzNCtN?=
 =?utf-8?B?NXd1N0xTUjFYRm00eGxwNDJyT1FJSE0zS0VYcHlXbUdnYlhGanhhOSs4Z3Ji?=
 =?utf-8?B?Y3YwSmk2MHRlWnFyU01uMTJ3cVpkSy9VUWRxYnNXQnYzOVdMVVRaSUJLWWhY?=
 =?utf-8?B?cko1Z2Fvcm9kVDhhSy9ZR0liWExtck1wNXNPelZFK3ZFaDUrR0hsdUVLWVZH?=
 =?utf-8?B?ajIvZlBnWElhcTQ4dEp5WFQvWnNyMFNBaE9mcEh1YktGM0xnUjBUTWY5SDZ0?=
 =?utf-8?B?dWF3S0FZM1VJVUpvOEZKMk1QdWswdEFPS0RMeGlTb1pQOEFuM3JUUGZUV2lY?=
 =?utf-8?B?dlcyeTliQ0lGV3QyckVVNzlnY3RSY0dqQjFuWEhFRlN0dzE1NVRhdWtrR1cx?=
 =?utf-8?B?YlBQQ1cxRVJMYlpuclBYZDRURFA0ZlF5MW85S3VhQ2RjaDhhcC9GajlYU3dh?=
 =?utf-8?B?ZWhxeVl0TURPOHpRWDFaN2hDMm5uWk8zQ2xQUGFGL3pVQmt4T2RPYkNmM0Jh?=
 =?utf-8?B?VmZrUlg4eXd1ZlVzYisrdjJWZXFPS3BSUFZhL0xGaFVPTTlpcG1kN1g1aDBr?=
 =?utf-8?B?V29Peko1R0dMWXFDZ1hHcThRMWdNVHVyYmlETXhvQVlnNlo0OXV3NFpoVitX?=
 =?utf-8?B?Z1RWZzlaWFM2S2lKMStJVlM4eDY2bEgvK2xRL3dlaEtlSC9Mb1hrUWZmbDFF?=
 =?utf-8?B?eVdkTEFBK3g0WnY0U2x0WFp3MWdoZUdVWHR1RHZOZTZQRXVKeUlkbisyYnlP?=
 =?utf-8?B?WG1JQ3hvZzVWUHVBSXFqRXFFanV0RVhmRWFwanNYVGZXL21LMUtEYjgrN2VI?=
 =?utf-8?B?WGorcjZJS2FNNThiWjA0NzhJWm9mOVN6dXk4N1I2c2dwSFBiSDdXWkJ4T0w5?=
 =?utf-8?B?L0l2SmorakFpV2FaUlJwbUo4RlVnMDVxalhSK214TWFGcE9SWW5ab0VHTVhs?=
 =?utf-8?Q?SoG0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1B665810F4463043B07FF73D83C4CDB2@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR15MB3874.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a59e917d-33ce-4dec-521a-08db47cf6ece
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2023 10:00:44.5507
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cGFVFghzH7ANZy1w/srwS+wsKIMHYdw/9bDWfrNcu64jH326Ju4rp4hOKLSg37iR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4726
X-Proofpoint-GUID: TtFAg63ZOq51hjeEyDBq1o72Bidtm-xW
X-Proofpoint-ORIG-GUID: TtFAg63ZOq51hjeEyDBq1o72Bidtm-xW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-28_04,2023-04-27_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjgvMDQvMjAyMyAwMzozNiwgU3RlcGhlbiBIZW1taW5nZXIgd3JvdGU6DQo+IE9uIFRodSwg
MjcgQXByIDIwMjMgMTc6MjA6MDggLTA3MDANCj4gVmFkaW0gRmVkb3JlbmtvIDx2YWRmZWRAbWV0
YS5jb20+IHdyb3RlOg0KPiANCj4+ICtzaXplX3QgZHBsbF9tc2dfcGluX2hhbmRsZV9zaXplKHN0
cnVjdCBkcGxsX3BpbiAqcGluKQ0KPj4gK3sNCj4+ICsJLy8gVE1QLSBUSEUgSEFORExFIElTIEdP
SU5HIFRPIENIQU5HRSBUTyBEUklWRVJOQU1FL0NMT0NLSUQvUElOX0lOREVYDQo+PiArCS8vIExF
QVZJTkcgT1JJRyBIQU5ETEUgTk9XIEFTIFBVVCBJTiBUSEUgTEFTVCBSRkMgVkVSU0lPTg0KPiAN
Cj4gUGxlYXNlIGRvbid0IHVzZSBDKysgc3R5bGUgY29tbWVudHMNCg0KU3VyZSwgdGhlc2UgY29t
bWVudHMgd2VyZSBwdXQgaW4gYXMgYSBwbGFjZWhvbGRlciBmb3IgUkZDIHBhdGNoZXMsIHdpbGwN
CmJlIGRlZmluaXRlbHkgcmVtb3ZlZCBmb3IgdGhlIG5leHQgdmVyc2lvbiB3aGljaCBJIGhvcGUg
d2lsbCBiZSByZWFkeSB0bw0KbWVyZ2UuDQoNCg==
