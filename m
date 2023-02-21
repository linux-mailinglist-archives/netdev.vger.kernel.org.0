Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E27369DA22
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 05:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbjBUEiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 23:38:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232682AbjBUEiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 23:38:02 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8F35FD3;
        Mon, 20 Feb 2023 20:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676954278; x=1708490278;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=QjCS3SmEUlXMY8N2tciPEExVLg+PgN8zGTWwKPSwybc=;
  b=2AAyxrLO7h6rBAjIhlVLDMadRM5nz3vdVmtlIt4YPs5H7cbJdS7ggF9t
   KzbXZQqB1vmskcEiX7p+sHsZbxTDOo5faHFtj+WsqQZlFGzrXXERocvBm
   +DlyjuEVJZ0UHWYXVKmaKR1D6zTPVwHTWO6/mFMjPNetJAv8O15HksyTB
   TLVujLOT9JZvZ3fFrPMLV2048ODAZICa3r8hqYd+lYH9cQJHRzD70s2nJ
   rwCSdxlGg8kdbDHBMss2uMKsb9FRJX7P/OvN73/n3sKyBsFZKegSLVffd
   AcaBgvu3k/gWJvpyGG9DIWuXoeVlVFHxegVrK/jsHa0+hwbaZ5hzCR6S/
   g==;
X-IronPort-AV: E=Sophos;i="5.97,314,1669100400"; 
   d="scan'208";a="201530519"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Feb 2023 21:37:56 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 20 Feb 2023 21:37:56 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 20 Feb 2023 21:37:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HKnDrn9MLBEJpPI6JjJXK85iom5xLTlxB5UgBeimzYGgxueV3ftIJVujsfpDzxmZacgZPszEHztyG8pB4AnSEu0s9aj2FvkMTYS9BVXj8PH3bLFUPMemNeJh5bjYOVCOeREcNay/47p9Uy9frEF8Ay/ucOVb/UNCQ6WDA5APOkxsBs2NUnI+HpL5pZepZQPfXjtC2Nn0PaUjXdu5gjrY56B2kfPP8tuDYREwRn8a8rSxOlACfyIrW0uzxt3o2XVQnIKCnH+apSPTfhgoTt3m8VNyXjlRVMnkXrQSTkjQ6sWt2JTo/GTPACVE4zDZJL0emGaZ8xypcq3lZtVKLCnLWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QjCS3SmEUlXMY8N2tciPEExVLg+PgN8zGTWwKPSwybc=;
 b=MdDiTISnbVnP402EVOjtYfevt4+m57XkeXs7oze1HJJ+ktCFW+Sj28DHt6568yPueh4R5Qj8GTYa+8QfSBXAwUfN7b/9nv/usTu0463aOy7/OBGFeZwYbS2pVyBYfGeLbIDOXo992xiuBPUMg9PG2LoeuvYUHv/sRtHuowJEiLiIigxVIfR+zLBTuwwWd8VnN6QtD+n0jXaFftffUsFy+RKGh605ol4qWekOgGJi0mOPDiU01L4CL6edxtehlFGk9YYu4D7gV76ezNMugl1ywgESq5au1I4l1VHzYmAkDd0bnDrCCpQqfD1O7iSvSjaQtZKh5K/Y5k3hpd8qu+TnRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QjCS3SmEUlXMY8N2tciPEExVLg+PgN8zGTWwKPSwybc=;
 b=eYATvWsgGy9WozH70xsDxrenErMdL1afgoyNHzhyix8z1Z0ZiykxSxDlxUYWQrBZRidr6DGQeHtgpF7vj3sQrC9qPUHE4Y4Avmlu7fy9VgMCMGvZMPPyz0bp+m8PHrLM7qqA0P15lDePgQDEIeykvc7m0Q7af2MixYSrFlsjfvA=
Received: from MN0PR11MB6088.namprd11.prod.outlook.com (2603:10b6:208:3cc::9)
 by BN9PR11MB5291.namprd11.prod.outlook.com (2603:10b6:408:118::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Tue, 21 Feb
 2023 04:37:55 +0000
Received: from MN0PR11MB6088.namprd11.prod.outlook.com
 ([fe80::6be3:1fbb:d008:387e]) by MN0PR11MB6088.namprd11.prod.outlook.com
 ([fe80::6be3:1fbb:d008:387e%8]) with mapi id 15.20.6111.019; Tue, 21 Feb 2023
 04:37:54 +0000
From:   <Rakesh.Sankaranarayanan@microchip.com>
To:     <aleksander.lobakin@intel.com>
CC:     <andrew@lunn.ch>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <Thangaraj.S@microchip.com>, <Woojung.Huh@microchip.com>,
        <linux-kernel@vger.kernel.org>, <pabeni@redhat.com>,
        <f.fainelli@gmail.com>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <edumazet@google.com>,
        <kuba@kernel.org>
Subject: Re: [PATCH v2 net-next 1/5] net: dsa: microchip: add rmon grouping
 for ethtool statistics
Thread-Topic: [PATCH v2 net-next 1/5] net: dsa: microchip: add rmon grouping
 for ethtool statistics
Thread-Index: AQHZQr9J/veRNAG2l0aNi9udgtLRKa7TO0sAgAWcEYA=
Date:   Tue, 21 Feb 2023 04:37:54 +0000
Message-ID: <d514e373b9e299b5e59bab2f6246236ecf59c77e.camel@microchip.com>
References: <20230217110211.433505-1-rakesh.sankaranarayanan@microchip.com>
         <20230217110211.433505-2-rakesh.sankaranarayanan@microchip.com>
         <03dedec9-2383-b0bd-eb2e-4d3b334e8c0b@intel.com>
In-Reply-To: <03dedec9-2383-b0bd-eb2e-4d3b334e8c0b@intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB6088:EE_|BN9PR11MB5291:EE_
x-ms-office365-filtering-correlation-id: d9ad8302-77df-4692-4b4f-08db13c56636
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1BEFDlrBF7PMLRQKktHqhDKlZQ4IdJyZnkcCqBvLz/E8VyMYfn4pRoIEAngnnB1SqrAKKKNsGqUgj+LMRuO4lXqgPXT7BcJov1YO2fMA6aoynQssvL30xrT/DdQIgW1N8TGPWdxMglALHECoLORKpo78jPyWv6d3rjm2CrAmdkYf6kmpz7r58f1AZky8zrtYoAV1LqtUKDpFEp5W7uBK6kyNWHzdyekW9OVqKckElYeDTFEQFjaoRxSX248jSwW8phdK258i4z5Kv+yXWgj6juY3sx/JaZ612usqMa+SjIrsqbFFg70hGRion6C2kVNyoPJ+vZm5B9noKVShZR3rrfL5e6HXDGBklrnAo2STFZYT73ZcAZnIYa3ASdKm+2xBty5X0xCkPho/d2T4B7LqoZDl5275iptIfLKzyND0ocWOik/PVMdd9/6BrN0iN9xOym7Uhfd6+HPxZhNchee2pEa9NGU0aWBkhX9swTVR0NmItbLEMmKMCdoODrF+jejz4Y/syuThjl7kSqfeJDZbc2fzWkkKjWVk7LBdz3+cHkp6D8ScuafWv8LtS2kjPqWrAtl0p2eklf/Zdw8EbDM2rA7Iykf1ELyKpiVo36pWkyBhS8QY+gHzLNp/pLZJYr2o5BChRTgg4oONSKaGvjYxQwNeWENnsiSrmD+muJ9nvuuKoPp0fA+iemcX7MH8oc86RXv140qnx7WC7KSZMZ+MLg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6088.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(376002)(136003)(366004)(346002)(451199018)(8676002)(66446008)(122000001)(66476007)(64756008)(66946007)(6916009)(66556008)(91956017)(316002)(41300700001)(76116006)(4326008)(5660300002)(86362001)(2616005)(83380400001)(186003)(6512007)(26005)(6506007)(6486002)(966005)(54906003)(71200400001)(2906002)(36756003)(38070700005)(38100700002)(478600001)(8936002)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cmFQM1ZHRXNCUEgwYkEvQWNYcSt4SFVMS3lnN01KcjFzMzFYSEhNRW1xTmND?=
 =?utf-8?B?elA2d2VxQVdmQmhaNHN3bWx4Q0JxRlVacDBvd1FJMUtWQ3krSzR0cGFvTkxQ?=
 =?utf-8?B?eXVwQlNqSzlVci9vK2M2QitZcXpVTngvTTBjZS8vMUFLdHcxQkNzT0lFQTEz?=
 =?utf-8?B?aGRJZVVVY3lSQjBoSzM4UmNXbzhxTVAzN2hodlVRS2w4ZitzL2lMdVI2KytN?=
 =?utf-8?B?RUhmWDZRK05yNW5lbDZ4VTRzOTdkajViam4vbXdIUVNEdjQ2SVJ6ZUJtRmVZ?=
 =?utf-8?B?Q3JMeU9QZ3IxSlpnVHdMdkJYSjVKbFJIV3I2dHBFWjhCbFY1YXNzdTMyOWlq?=
 =?utf-8?B?TVgzOTNYd0dlaDQ4Zm1rRjhWVXllSVI2dHdobW14ZWVudEYzTUxrcXdmNFBu?=
 =?utf-8?B?VFNERkVDTFRieEMwL2VvblZWZEpsakdLTkE5OW9CNlJFVXQ0YzJCMUgxeVhX?=
 =?utf-8?B?ZEFQcHIxeFZzbXYzT1NKakNieXl0Y3FYTDRPRFNNSlhKN3ZtU2w0Z3F0WHlC?=
 =?utf-8?B?ejJxOXpUQytjZmgrT3Myb2tvU3E3MHk5cUVXMWZ1L2lvNmo5NnVqdGRybU5o?=
 =?utf-8?B?TTlmeWxJTDIweHJQZjZOWTZxNVEvKzZRcWhPSnc2UStYUW1SVFd1ckRacFBp?=
 =?utf-8?B?S05aN0tmQUtRb291UCtueThXVXdGOFc3cUhxeTUzV3NEMlZGNktCb3UxbEZL?=
 =?utf-8?B?RmJnM0drWU9ZS1RUM2hNTzJsYXVkRGVIcmxRODk1cUZEUmpUanJWcDhNcWZU?=
 =?utf-8?B?RWs4elhiczlqWnN0S0pwS25oQnFqQVhYdTlTaUM5STdKT0lvYWtkWjEzY3NP?=
 =?utf-8?B?Y29pVzVQN3RmYXVLSGxxekNlMGZFdTlsWEJERW5CTkVBR3Y4SVZpZGxmWkVZ?=
 =?utf-8?B?QnBXWXliUXFWWDN1R1Zuem1BWEYydlBjN1h6SmxpaWJTNXM3WXRhMDlCRWha?=
 =?utf-8?B?Ym5hQWIrRVJRVkdWSys3WFNOSlo0QnhNR2VoVnZOOFo4TTlxK1NaYXFRbE1W?=
 =?utf-8?B?b21JOGR4TjFvSkJTR3hqZGxBVTFmenBuTUcyS0VCVUxKT0V1aXl4eUpZc1FO?=
 =?utf-8?B?NE5GK2xDTDNMQ3FFdDRweFdiUHJaa1BqaFI0MmloUXVKZE1MVnRndERzVFNC?=
 =?utf-8?B?Sk9hSU41Qi85VTZmcjlGSWdJc1pVNXZCNnI1UUtYQXk1MzR2OUs5YjB4OU1I?=
 =?utf-8?B?T0NCL0NBdnNiaWozN0puUTVqdXh5amMzdkpiV3doc0h2Unc1a1RlTWZQV0tT?=
 =?utf-8?B?NjVFK3ltUHovZlA3c0tFL0tNRzI5d20wWmpBZTVGNlBNcmVGZ2pwNTBVU3V5?=
 =?utf-8?B?ZzhyaGFhd0lyNkhhL1d4YzF6TTExeTFZR2w4MWJuajhHNk1RN01JUW0vSURo?=
 =?utf-8?B?aCtrUkRDTExsanNIaWo5Tkc5dzNYdEg3WjdyTE9mQkwvM0MzYUNnT2dlTFJ3?=
 =?utf-8?B?cUNaREQxOVpPMjBPdW1lU0p2WFNCbU9RejA2MFo4OW5ZTzlOL04yZjNHL2Mw?=
 =?utf-8?B?OU9SenEveGgvOVpLVno3VzQxb3JtY3k1cmZ1TFBxTWlzV0pqbzJJMFJ5Mm44?=
 =?utf-8?B?TmNIVVBZZ2d1Q0ZzcklyeFZQbjB0QkFXY2o2SHgwVVhtdVd6TFlyd1M0ZS9l?=
 =?utf-8?B?elFnWVlvYk44QjVIbmd2Nm1rVzRPYUUwV3ozTEdjdHN1QXRjdXpqcUtVajQz?=
 =?utf-8?B?dC8yeWZ1QkpsUy9DNHpWRVA2bCtzZHhPSnY5ZVJxTFhLakw0L3k4VmhBSDBR?=
 =?utf-8?B?REt2UHhqM2QwakMydkd4Z1hRU0Q2ekRwZUxwR2NuYUxYbGRRM2UvaURLV0FF?=
 =?utf-8?B?eG1RQjNkMU9aQkZlNkNXTjkzV0I5ZHJ2TkVNdVgvNGhkd0RBeWpyaW95dWxK?=
 =?utf-8?B?RHorbEZVdTFuazJuT1d4bG1KOWhXUzFTTC9QWVVVeXJoREdrLzdIRU1pbTVG?=
 =?utf-8?B?QngzZEVmY2MvaDNNZkJrbUtadnZ5V05MS0V4bFdWWkVVOHdGQ0E1VEh2WW9s?=
 =?utf-8?B?VEh4ak5xWXJKQ0E1Q0dtNXFWcXFzZjhoTmpVY1FraWdPeFQ1ay9zbUJjMWhs?=
 =?utf-8?B?ZEVJaVFFaEI3dWNiOFJtbjJMN3BJYlM1d2dlMEJrV0VHRkxIV0M2WnRmNW92?=
 =?utf-8?B?TmY1NitockFyU2MxKy95QWl2VC9JcG56VjJYMGQ1MS9yaWJkdmJVdHI3RHIr?=
 =?utf-8?Q?3qNqT3rsAZkQf/G0FYwr4l54r9aE4reOGCBDO0IQnr3w?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AFD406100D0EB64E84FB56D620FCAEF3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6088.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9ad8302-77df-4692-4b4f-08db13c56636
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2023 04:37:54.6908
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b2M4lJlHu6DE93h4gyjqF9ZNDFK2m1CBYsCeivStQ8hVm3AmMU7hvi4cln8v1dzcR3utV3+gk92pp6lGImMwHOW7JMYZRfkycTk8QgkW78e8822ShtRWh/FT/GrCDYaE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5291
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIzLTAyLTE3IGF0IDE1OjU5ICswMTAwLCBBbGV4YW5kZXIgTG9iYWtpbiB3cm90
ZToKPiBbU29tZSBwZW9wbGUgd2hvIHJlY2VpdmVkIHRoaXMgbWVzc2FnZSBkb24ndCBvZnRlbiBn
ZXQgZW1haWwgZnJvbQo+IGFsZWtzYW5kZXIubG9iYWtpbkBpbnRlbC5jb20uIExlYXJuIHdoeSB0
aGlzIGlzIGltcG9ydGFudCBhdAo+IGh0dHBzOi8vYWthLm1zL0xlYXJuQWJvdXRTZW5kZXJJZGVu
dGlmaWNhdGlvbsKgXQo+IAo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91Cj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlCj4g
Cj4gRnJvbTogUmFrZXNoIFNhbmthcmFuYXJheWFuYW4gPHJha2VzaC5zYW5rYXJhbmFyYXlhbmFu
QG1pY3JvY2hpcC5jb20+Cj4gRGF0ZTogRnJpLCAxNyBGZWIgMjAyMyAxNjozMjowNyArMDUzMAo+
IAo+ID4gwqDCoMKgIEFkZCBzdXBwb3J0IGZvciBldGh0b29sIHN0YW5kYXJkIGRldmljZSBzdGF0
aXN0aWNzIGdyb3VwaW5nLgo+ID4gU3VwcG9ydCBybW9uCj4gPiDCoMKgwqAgc3RhdGlzdGljcyBn
cm91cGluZyB1c2luZyBybW9uIGdyb3VwcyBwYXJhbWV0ZXIgaW4gZXRodG9vbAo+ID4gY29tbWFu
ZC4gcm1vbgo+ID4gwqDCoMKgIHByb3ZpZGVzIHBhY2tldCBzaXplIGJhc2VkIHJhbmdlIGdyb3Vw
aW5nLiBDb21tb24gbWliCj4gPiBwYXJhbWV0ZXJzIGFyZSB1c2VkCj4gPiDCoMKgwqAgYWNyb3Nz
IGFsbCBLU1ogc2VyaWVzIHN3dGNoZXMgZm9yIHBhY2tldCBzaXplIHN0YXRpc3RpY3MsCj4gPiBl
eGNlcHQgZm9yCj4gPiDCoMKgwqAgS1NaODgzMC4gS1NaIHNlcmllcyBoYXZlIG1pYiBjb3VudGVy
cyBmb3IgcGFja2V0cyB3aXRoIHNpemU6Cj4gCj4gWy4uLl0KPiAKPiA+ICt2b2lkIGtzejhfZ2V0
X3Jtb25fc3RhdHMoc3RydWN0IGtzel9kZXZpY2UgKmRldiwgaW50IHBvcnQsCj4gPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN0cnVjdCBldGh0b29sX3Jtb25f
c3RhdHMgKnJtb25fc3RhdHMsCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIGNvbnN0IHN0cnVjdCBldGh0b29sX3Jtb25faGlzdF9yYW5nZQo+ID4gKipyYW5n
ZXMpCj4gPiArewo+ID4gK8KgwqDCoMKgIHN0cnVjdCBrc3pfcG9ydF9taWIgKm1pYjsKPiA+ICvC
oMKgwqDCoCB1NjQgKmNudDsKPiAKPiBOaXQ6IEkgZ3Vlc3MgaXQgY2FuIGJlIGNvbnN0IHNpbmNl
IHlvdSBvbmx5IHJlYWQgaXQgKGluIGV2ZXJ5IHN1Y2gKPiBjYWxsYmFjayk/ClRoaXMgdmFyaWFi
bGUgaXMgZ2V0dGluZyB1cGRhdGVkIG9uIGV2ZXJ5IGNhbGwgYmFjayBhZnRlciByZWFkaW5nIGZy
b20KcmVnaXN0ZXJzLCBzbyB3ZSBjYW5ub3QgaGF2ZSBpdCBhcyBjb25zdGFudC4KCj4gCj4gPiAr
wqDCoMKgwqAgdTggaTsKPiA+ICsKPiA+ICvCoMKgwqDCoCBtaWIgPSAmZGV2LT5wb3J0c1twb3J0
XS5taWI7Cj4gPiArCj4gPiArwqDCoMKgwqAgbXV0ZXhfbG9jaygmbWliLT5jbnRfbXV0ZXgpOwo+
ID4gKwo+ID4gK8KgwqDCoMKgIGNudCA9ICZtaWItPmNvdW50ZXJzW0tTWjhfUlhfVU5ERVJTSVpF
XTsKPiA+ICvCoMKgwqDCoCBkZXYtPmRldl9vcHMtPnJfbWliX3BrdChkZXYsIHBvcnQsIEtTWjhf
UlhfVU5ERVJTSVpFLCBOVUxMLAo+ID4gY250KTsKPiA+ICvCoMKgwqDCoCBybW9uX3N0YXRzLT51
bmRlcnNpemVfcGt0cyA9ICpjbnQ7Cj4gPiArCj4gPiArwqDCoMKgwqAgY250ID0gJm1pYi0+Y291
bnRlcnNbS1NaOF9SWF9PVkVSU0laRV07Cj4gPiArwqDCoMKgwqAgZGV2LT5kZXZfb3BzLT5yX21p
Yl9wa3QoZGV2LCBwb3J0LCBLU1o4X1JYX09WRVJTSVpFLCBOVUxMLAo+ID4gY250KTsKPiA+ICvC
oMKgwqDCoCBybW9uX3N0YXRzLT5vdmVyc2l6ZV9wa3RzID0gKmNudDsKPiA+ICsKPiA+ICvCoMKg
wqDCoCBjbnQgPSAmbWliLT5jb3VudGVyc1tLU1o4X1JYX0ZSQUdNRU5UU107Cj4gPiArwqDCoMKg
wqAgZGV2LT5kZXZfb3BzLT5yX21pYl9wa3QoZGV2LCBwb3J0LCBLU1o4X1JYX0ZSQUdNRU5UUywg
TlVMTCwKPiA+IGNudCk7Cj4gPiArwqDCoMKgwqAgcm1vbl9zdGF0cy0+ZnJhZ21lbnRzID0gKmNu
dDsKPiA+ICsKPiA+ICvCoMKgwqDCoCBjbnQgPSAmbWliLT5jb3VudGVyc1tLU1o4X1JYX0pBQkJF
UlNdOwo+ID4gK8KgwqDCoMKgIGRldi0+ZGV2X29wcy0+cl9taWJfcGt0KGRldiwgcG9ydCwgS1Na
OF9SWF9KQUJCRVJTLCBOVUxMLAo+ID4gY250KTsKPiA+ICvCoMKgwqDCoCBybW9uX3N0YXRzLT5q
YWJiZXJzID0gKmNudDsKPiA+ICsKPiA+ICvCoMKgwqDCoCBmb3IgKGkgPSAwOyBpIDwgS1NaOF9I
SVNUX0xFTjsgaSsrKSB7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNudCA9ICZtaWIt
PmNvdW50ZXJzW0tTWjhfUlhfNjRfT1JfTEVTUyArIGldOwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBkZXYtPmRldl9vcHMtPnJfbWliX3BrdChkZXYsIHBvcnQsCj4gPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKEtTWjhfUlhf
NjRfT1JfTEVTUyArIGkpLCBOVUxMLCBjbnQpOwo+IAo+IFdlaXJkIGxpbmV3cmFwLiBQbGVhc2Ug
YWxpZ24gdGhlIGZvbGxvd2luZyBsaW5lcyB3aXRoIHRoZSBvcGVuaW5nCj4gYnJhY2UKPiBvZiB0
aGUgZmlyc3Qgb25lLCBlLmcuCj4gCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRl
di0+ZGV2X29wcy0+cl9taWJfcGt0KGRldiwgcG9ydCwKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
S1NaOF9SWF82NF9PUl9MRVNTICsgaSwgTlVMTCwKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY250
KTsKPiAKPiBCVVQgSSBkb24ndCBzZWUgd2h5IHlvdSBuZWVkIHRob3NlIGJyYWNlcyBhcm91bmQg
YG1hY3JvICsgaWAgYW5kCj4gd2l0aG91dAo+IHRoZW0geW91IGNhbsKgZml0IGl0IGludG8gdGhl
IHByZXZpb3VzIGxpbmUgSSBiZWxpZXZlLgpXaWxsIHVwZGF0ZSBpdCBpbiBuZXh0IHJldmlzaW9u
Cj4gCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJtb25fc3RhdHMtPmhpc3RbaV0gPSAq
Y250Owo+ID4gK8KgwqDCoMKgIH0KPiA+ICsKPiA+ICvCoMKgwqDCoCBtdXRleF91bmxvY2soJm1p
Yi0+Y250X211dGV4KTsKPiA+ICsKPiA+ICvCoMKgwqDCoCAqcmFuZ2VzID0ga3N6X3Jtb25fcmFu
Z2VzOwo+ID4gK30KPiA+ICsKPiA+ICt2b2lkIGtzejk0NzdfZ2V0X3Jtb25fc3RhdHMoc3RydWN0
IGtzel9kZXZpY2UgKmRldiwgaW50IHBvcnQsCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN0cnVjdCBldGh0b29sX3Jtb25fc3RhdHMgKnJtb25f
c3RhdHMsCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIGNvbnN0IHN0cnVjdCBldGh0b29sX3Jtb25faGlzdF9yYW5nZQo+ID4gKipyYW5nZXMpCj4g
PiArewo+ID4gK8KgwqDCoMKgIHN0cnVjdCBrc3pfcG9ydF9taWIgKm1pYjsKPiA+ICvCoMKgwqDC
oCB1NjQgKmNudDsKPiA+ICvCoMKgwqDCoCB1OCBpOwo+ID4gKwo+ID4gK8KgwqDCoMKgIG1pYiA9
ICZkZXYtPnBvcnRzW3BvcnRdLm1pYjsKPiA+ICsKPiA+ICvCoMKgwqDCoCBtdXRleF9sb2NrKCZt
aWItPmNudF9tdXRleCk7Cj4gPiArCj4gPiArwqDCoMKgwqAgY250ID0gJm1pYi0+Y291bnRlcnNb
S1NaOTQ3N19SWF9VTkRFUlNJWkVdOwo+ID4gK8KgwqDCoMKgIGRldi0+ZGV2X29wcy0+cl9taWJf
cGt0KGRldiwgcG9ydCwgS1NaOTQ3N19SWF9VTkRFUlNJWkUsCj4gPiBOVUxMLCBjbnQpOwo+ID4g
K8KgwqDCoMKgIHJtb25fc3RhdHMtPnVuZGVyc2l6ZV9wa3RzID0gKmNudDsKPiA+ICsKPiA+ICvC
oMKgwqDCoCBjbnQgPSAmbWliLT5jb3VudGVyc1tLU1o5NDc3X1JYX09WRVJTSVpFXTsKPiA+ICvC
oMKgwqDCoCBkZXYtPmRldl9vcHMtPnJfbWliX3BrdChkZXYsIHBvcnQsIEtTWjk0NzdfUlhfT1ZF
UlNJWkUsIE5VTEwsCj4gPiBjbnQpOwo+ID4gK8KgwqDCoMKgIHJtb25fc3RhdHMtPm92ZXJzaXpl
X3BrdHMgPSAqY250Owo+ID4gKwo+ID4gK8KgwqDCoMKgIGNudCA9ICZtaWItPmNvdW50ZXJzW0tT
Wjk0NzdfUlhfRlJBR01FTlRTXTsKPiA+ICvCoMKgwqDCoCBkZXYtPmRldl9vcHMtPnJfbWliX3Br
dChkZXYsIHBvcnQsIEtTWjk0NzdfUlhfRlJBR01FTlRTLAo+ID4gTlVMTCwgY250KTsKPiA+ICvC
oMKgwqDCoCBybW9uX3N0YXRzLT5mcmFnbWVudHMgPSAqY250Owo+ID4gKwo+ID4gK8KgwqDCoMKg
IGNudCA9ICZtaWItPmNvdW50ZXJzW0tTWjk0NzdfUlhfSkFCQkVSU107Cj4gPiArwqDCoMKgwqAg
ZGV2LT5kZXZfb3BzLT5yX21pYl9wa3QoZGV2LCBwb3J0LCBLU1o5NDc3X1JYX0pBQkJFUlMsIE5V
TEwsCj4gPiBjbnQpOwo+ID4gK8KgwqDCoMKgIHJtb25fc3RhdHMtPmphYmJlcnMgPSAqY250Owo+
ID4gKwo+ID4gK8KgwqDCoMKgIGZvciAoaSA9IDA7IGkgPCBLU1o5NDc3X0hJU1RfTEVOOyBpKysp
IHsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY250ID0gJm1pYi0+Y291bnRlcnNbS1Na
OTQ3N19SWF82NF9PUl9MRVNTICsgaV07Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRl
di0+ZGV2X29wcy0+cl9taWJfcGt0KGRldiwgcG9ydCwKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAoS1NaOTQ3N19SWF82NF9PUl9M
RVNTICsgaSksIE5VTEwsCj4gPiBjbnQpOwo+IAo+IChzYW1lLCBhbmQgcGxlYXNlIGNoZWNrIGFs
bCBvdGhlciBwbGFjZXMgaW4gdGhlIHNlcmllcykKc3VyZSwgd2lsbCB1cGRhdGUgaW4gbmV4dCB2
ZXJzaW9uLgo+IAo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBybW9uX3N0YXRzLT5oaXN0
W2ldID0gKmNudDsKPiA+ICvCoMKgwqDCoCB9Cj4gPiArCj4gPiArwqDCoMKgwqAgbXV0ZXhfdW5s
b2NrKCZtaWItPmNudF9tdXRleCk7Cj4gPiArCj4gPiArwqDCoMKgwqAgKnJhbmdlcyA9IGtzel9y
bW9uX3JhbmdlczsKPiA+ICt9Cj4gWy4uLl0KPiAKPiBUaGFua3MsCj4gT2xlawo=
