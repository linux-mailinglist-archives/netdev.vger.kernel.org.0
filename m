Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B64E75B680B
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 08:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbiIMGlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 02:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbiIMGlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 02:41:06 -0400
X-Greylist: delayed 64 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 12 Sep 2022 23:41:02 PDT
Received: from mailout41.telekom.de (mailout41.telekom.de [194.25.225.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B824F53023
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 23:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=telekom.de; i=@telekom.de; q=dns/txt; s=dtag1;
  t=1663051263; x=1694587263;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hAXQuFr9TOFBkO80ofDbSo51VP9/jvdCzHSFhSkYKLU=;
  b=hDxLs1VJf42tyCvJ9EET0MAT8+l/CcrIrw2m/hsr3Cpxtz9d8/JJ3H1I
   to9O38cugHvS8rOf03H1q1AJx95SycLc3c6m+QZxtIwk3/F4Q3mZO9Ta5
   +9vJsEPYQfXgDWdf5rkFfdZGqpMtS5st13sWeUtFX2G2twwLS72CFZ7lM
   MKxxo6I2cO3iqSz1d66KMdsUT7oCm+lG4yqU+5MotLg48l2qLdfawuKDF
   LTdCKsBcxQc6bHmzDw6HD+V5EnhDXEcURsfLJzt1YZqleT5iIXKNCtuOn
   83trKGifP9Q6DR6KAgmzvLcV6/2AqVf+cN5v47H6/3wceVcax2v3jUkbi
   w==;
Received: from qde8e4.de.t-internal.com ([10.171.255.33])
  by mailout41.dmznet.de.t-internal.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Sep 2022 08:39:56 +0200
IronPort-SDR: MEcA98jP+PhahcVqs+y2K5Jer6P7CcAVIg5I7QA22xBBqlZKamLU8729YIdSzLbqlYwLLd8Vih
 zBQS1vMguPiXreq3e1Z1/iXXu7X6UwSWM=
X-IronPort-AV: E=Sophos;i="5.93,312,1654552800"; 
   d="scan'208";a="1278229038"
X-MGA-submission: =?us-ascii?q?MDEPnaEPqCmxZ7CX0/006pWIHLN8PoMhfwmb/I?=
 =?us-ascii?q?SdoXAvVCn/ZN8HESCi+jHbIhkSMBVwadZX+B0WuI7nfG1cvVhaz95PXh?=
 =?us-ascii?q?HJQE2KLVfkdR2JwIOTd77TtbC8oeQFR/01hIk2GRUI+ZRRogwfcgosGo?=
 =?us-ascii?q?ePINnDl8nqPge4M9ovz6hAsw=3D=3D?=
Received: from he199745.emea1.cds.t-internal.com ([10.169.119.53])
  by QDE8PP.de.t-internal.com with ESMTP/TLS/ECDHE-RSA-AES128-SHA256; 13 Sep 2022 08:39:55 +0200
Received: from HE199745.EMEA1.cds.t-internal.com (10.169.119.53) by
 HE199745.emea1.cds.t-internal.com (10.169.119.53) with Microsoft SMTP Server
 (TLS) id 15.0.1497.38; Tue, 13 Sep 2022 08:39:55 +0200
Received: from HE100181.emea1.cds.t-internal.com (10.171.40.15) by
 HE199745.EMEA1.cds.t-internal.com (10.169.119.53) with Microsoft SMTP Server
 (TLS) id 15.0.1497.38 via Frontend Transport; Tue, 13 Sep 2022 08:39:55 +0200
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (104.47.11.174)
 by O365mail02.telekom.de (172.30.0.235) with Microsoft SMTP Server (TLS) id
 15.0.1497.36; Tue, 13 Sep 2022 08:39:38 +0200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IoL3zHSot+3YZKRTVquVDbJcSkgtREWnpYjRqQo1Ctbj7iTnVBDcHhgYG0xFwi/6qF1pWS6DM5aDHCLxu9x7VsWoL+8t9X1tz1W7rrLiA5K1GFtu+Rs6xdlIXm1EzNILhKgj9lbTY3StxN+FJUoUQHlHKwOq1jfKQLy0ZYlLsheQYYEdv8G0kj0nYXcE8zPNycZttxnKN9zxcmgh4iZM7RS7981dA7i0A+kIRCJmHw+eTf/l+n2jFH6hD7v5ftXE9707MCUWZ9qH8US7mam/pRMp2DHBnCGNMUpyd8o6v72XkArGRQOdOuO75WTzjVy2YApLWtCejNVPnZkKH/Zqpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hAXQuFr9TOFBkO80ofDbSo51VP9/jvdCzHSFhSkYKLU=;
 b=JHjbGUzW1/J2dG6sdOeOXEloML9bxXjBFPywJGlVAZWqfBzFsTxtXQG0tBFYTa65cWTaKdE/O4iZgKNV4hPEJM8ojtIA7F1caxlzG2YJEDbXfrtqJVg7FsrAsYJU69TRSzh9G+IkSRNQEjByrRPS75gBE7esozraUmmplEvADtNUu9JZkFcdXmwG6UlNjeYYXOf3apUCNYZ5hlHKKVIujdGI1jeX2WtJOHWJWGvVZvtrb+3t8yNZ90qklDQlfJ+JWkuZghR2HUZ/cW9ZyFc671GNLJ52FcBMoEi0zpQDcpqrIr2UAdmtiVnQjkg092RjIl4r/mTPqkowm8guMGIDew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=telekom.de; dmarc=pass action=none header.from=telekom.de;
 dkim=pass header.d=telekom.de; arc=none
Received: from FR2P281MB2959.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:63::14)
 by FR2P281MB1606.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:89::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.12; Tue, 13 Sep
 2022 06:39:38 +0000
Received: from FR2P281MB2959.DEUP281.PROD.OUTLOOK.COM
 ([fe80::e162:6b68:dba0:a8af]) by FR2P281MB2959.DEUP281.PROD.OUTLOOK.COM
 ([fe80::e162:6b68:dba0:a8af%7]) with mapi id 15.20.5632.012; Tue, 13 Sep 2022
 06:39:38 +0000
From:   <Haye.Haehne@telekom.de>
To:     <t.glaser@tarent.de>, <ryazanov.s.a@gmail.com>
CC:     <netdev@vger.kernel.org>
Subject: AW: RFH, where did I go wrong?
Thread-Topic: RFH, where did I go wrong?
Thread-Index: AQHYxW8rd4tXFixoM0inmyOQQbkI1q3c6rmg
Date:   Tue, 13 Sep 2022 06:39:38 +0000
Message-ID: <FR2P281MB29597303CA232BBEF6E328DF90479@FR2P281MB2959.DEUP281.PROD.OUTLOOK.COM>
References: <FR2P281MB2959684780DC911876D2465590419@FR2P281MB2959.DEUP281.PROD.OUTLOOK.COM>
 <FR2P281MB2959EBC7E6CE9A1A8D01A01F90419@FR2P281MB2959.DEUP281.PROD.OUTLOOK.COM>
 <42776059-242c-cf49-c3ed-31e311b91f1c@tarent.de>
 <CAHNKnsQGwV9Z9dSrKusLV7qE+Xw_4eqEDtHKTVJxuuy6H+pWRA@mail.gmail.com>
 <cd3867e0-b645-c6cd-3464-29ffb142de5e@tarent.de>
In-Reply-To: <cd3867e0-b645-c6cd-3464-29ffb142de5e@tarent.de>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=telekom.de;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: FR2P281MB2959:EE_|FR2P281MB1606:EE_
x-ms-office365-filtering-correlation-id: 9b7bc7f5-34ce-4477-7034-08da9552badd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ELcZ2RbjS7SgjFQDpp+YoP1yoJe9weXdC91qDtCfpkynnqcPwR1iY6IlC+fyriLjak72tBu+6ISc7FwVaYhe7fTDwZL56BHHm40H9HH4vZnMlHGhXITN4BfdjhS6wZnhd0znt4DZHh1FlYa9quyxM9lX7sWS0cJA2eMw+P8z+stdsSHCeK8JPxMNC8bpzUTklY/65zZ+vunh3HDFCOAYWK4zvWgY5VdCioVtyOyZT7Of70EWuvTorSwl1IY98R8CYsce5R6vVUMFGDNekPMnc6/QC+84en2euHZv0PVjuXJBxnKRBBse1exxIdcVv61x7Ssc3AJtmaxgzIZIAPJy0cuTuk+jxtt2vpsATHkYr7atsxl0UGVIdsTQxVZaR/565Uf6Hd3YfucrMK+yXIeVr5OrSLNdaHf9YakWX2re5CpyiSPKPkWOU+CvJp5h8JdCAPEj6NUJ8O7TF0jIb5sfO8AYO0X4wuxGZvlR4IVDiQ4gBgJqoj8amC8PW0PF2/Fe9eVCO30u/jxThfdi1j+RmTtwiMwr+OYPinqPx9AIE+q5vXlOdmEJQ1vb/xwtCf2oCK/EdELUWDEIDaBfc26p0314u8FzQvzjuMqmza0RvhOu3tldHv5JwBY9IPkMe+eKSuJ1OIIf0RrYkIAmGIwdNvX2ZoHua2zLfSDrVSt9JnzX9jYWJ6iV04ZIPKfRZjJ68cNgs8vykRpjf3sqMuGlayONX3wxWDPa5G+7u33SjJlJ8M4VYJCbvd+c2UN/fPiU1m2GeHlsoeY+Fs7VCajKZ4Rzc8yzVQoRVSEV4pfQkDb8wcAU/JaBC8CnavpAmItaCxvzCmDVBByeMwmLDRG7eQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FR2P281MB2959.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(396003)(346002)(366004)(1590799012)(451199015)(52536014)(38070700005)(122000001)(64756008)(66476007)(478600001)(66556008)(8676002)(110136005)(66574015)(4326008)(9686003)(2906002)(7696005)(966005)(6506007)(26005)(5660300002)(66446008)(86362001)(186003)(82960400001)(316002)(38100700002)(41300700001)(71200400001)(83380400001)(8936002)(85202003)(76116006)(85182001)(66946007)(55016003)(33656002)(1580799009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OC9GQzE4OGdNNnVxUHJwTjJvRXR6Z0diTHhhQ2JSUUpOT1JoTmJnZ1liRWdm?=
 =?utf-8?B?S0Z1WDl5Vk1IMDkzZlo5a0pXUlU2amgxQmtLSzFaSmRBcVRRZE56S0h0R2o2?=
 =?utf-8?B?T0p3RHdjR1U2UWpxWGJPQkZzNkJtTnl1aGJGMms0QU9LeUNNbjI1VDhsQkV0?=
 =?utf-8?B?MXdpOWV3ZjgvNlhPYVBnYmpzUTF4eXJNemVwallydDRSNG1zTDlPMTFaajJQ?=
 =?utf-8?B?ZWtwU1VyeE54UXhCRSt3Yitodm5UOE53K216bys5SmlRZTBnYTg4WlFWRDVZ?=
 =?utf-8?B?WmhhcjVQd3NaSGFBY0ZneWtHQTdITVhuNzh3LytoRU1NRW9wazBRR1lTVmlw?=
 =?utf-8?B?Mm1XNGJxbzZKWmRXb1A5K1dPeFAwU2RrT3VFNnV4UkNnM0lDVjZKa1kyaG0z?=
 =?utf-8?B?SjlWQ3g4NXMwdWV3MXBQTEFDVUliODMzakpRS25ITUxSb1JHSFBSbkpXVW9I?=
 =?utf-8?B?ZEhEQkpTVEhUNWpQa1pBNEhYalpuZDlRejc1TUNlbUMvVW0vRGFGVEFGMGQv?=
 =?utf-8?B?clpIVjBzZ2F4cjJwSVJaNm4yRWRGeXVRZHNzY2ZTWlo4dk9LRzdRWm5mTkVt?=
 =?utf-8?B?RXNRZnRTOUVtem51eHhkcjRpZFh1QWsvN0N0Z3R1NTRhYUZ5ZGVqdDJBeXhJ?=
 =?utf-8?B?SGhJOURLQ2VjYkhpM0lmdThSd1pCeUJndHBTK3g1VDdGenZQYS81UmpsSEdZ?=
 =?utf-8?B?NW85QlhHT01MMUs2N0FDMG8zc212MUJ1Z3RuTWhZSGJuZUtvTThSUE1kMUxM?=
 =?utf-8?B?Y3YzV1ZrOC80YXJuWDdPQTMzQ2d6bUxYeVgra3NSVFQxSEtBWW9mcEJNSFdX?=
 =?utf-8?B?M0tmQ2NnQnlJcmY1aWJnUjhCQW13YU5ZMWZpY205dGJKRjZ1ZG04bEdkajdz?=
 =?utf-8?B?QlQ4cy91TDhJSDM0UFhjamZwaWMrLy95T3NSSjV0VjBadGowV3F5RkwyaXh4?=
 =?utf-8?B?MEdkTkdLKzBURklkQ3BibEU5K2Q2WjNnVXVaWk9Eb1hGd054ZjlvT0RweHAx?=
 =?utf-8?B?aDRnTmhzaHdsKytBTE9XM1RvRjA1amtCV0pKRkl2ZFpRdjhlV21tQVI4VWhV?=
 =?utf-8?B?VE1uOHJ1SFRwdG9aOFhtR09YV3lMeFdKZE5UK0p5cEpBaVJsZ2pyZTVJWXNn?=
 =?utf-8?B?N2N4eXdtQTVJa0FwRk13SFdtMVowcGRCZG9SS3hkaEFlcnlhNVFzb0wrNDJJ?=
 =?utf-8?B?QWgzZ2J1eUwwQVY4Y0pVblNLdTFaeVhhMzZMbXFzYmgwcG5hOFhjc3l4OGo1?=
 =?utf-8?B?QTMzMktVczRyYkM4eUJ0KzVQL1BHVFlxWlFraFpmTlRlM2FydTZaNkF3SzM2?=
 =?utf-8?B?cE9hK1doR0RtSS9hdnR0ZXJqVngreEUzNXhEVEJXdkN6eHhmcERDVEQ4bG5I?=
 =?utf-8?B?elhoK3ZOTyswRXlQUVlqSEZhbmZBaGlQQnI5VWhHMlFXSzN0cEd2VHN2UGVI?=
 =?utf-8?B?NlJIN2lxWWxwSmRFVmIwOXc2Z0xEeThwTndhSFNiVFNmNDI5SHRBMTYwWita?=
 =?utf-8?B?MTFwaXFkak5WZlVwRDVsSHFweXAxMnV2ZGJNU043UENJVkxCQVVRaDcwSklH?=
 =?utf-8?B?aXg0MU9id2JDb3BtQnlpK3k4SkRmYzA0cUN1MzlzZW5zaUVxd3hvcVVoVEpG?=
 =?utf-8?B?aDgyQUhObGhjcjlISEVhWG5XcU9tQTBEOGlwWnVtYm5DSEpRWHkxck1rQTg5?=
 =?utf-8?B?cm5ST05qWHJHbGF4TTZPQnYvV29JQlVveHNhckJNWnBqSnkzT1d3L2hweENx?=
 =?utf-8?B?c0ZxYW9zTTBqK3NROGxKOHhtUllCREdlUlJ5ZUl4VGVUZ0N6Wmp0cjJnS0h0?=
 =?utf-8?B?NFdyb1A4V0JZdkZNZmY5SXl1UnZUYXhFQlgyWHByMjNvNm5hOGduaGhldXJx?=
 =?utf-8?B?OGFHb0xxV1liTm5qK2FDSXFhK0pUVnRtemx2OEV2dVZvc2FTVlJ1dnVXVnl3?=
 =?utf-8?B?bDNEd0VUNmlMTm4wVDZkaHVmME5qcVhqeHh5TzJXN2xWTTVFUkU4T1dabFlX?=
 =?utf-8?B?RkNyNnU1QlE5aE1BQk42alphWDVLTW8xVnJzeG10L0tmRmdFY2w2eUllN3py?=
 =?utf-8?B?cGowSE9vblE5YXdPVVhWNTIyQmFsN3AwNDBpaGF3OEVZZWx3cStvd2RJTXRC?=
 =?utf-8?Q?7MgXnJ5AfUIJGksYu3oypnleb?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR2P281MB1606
X-OriginatorOrg: telekom.de
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQpJIGNvdWxkIHJldGVzdCB0aGUgY3Jhc2ggc2NlbmFyaW8gb2YgdGhlIHFkaXNjLCBpdCBv
Y2N1cnMgaW4gdGhlIGNvbnRleHQgb2YgdGMgY2hhbmdlIC9yZWNvbmZpZ3VyYXRpb24uDQpXaGVu
IEkgZGVmaW5lIGEgc3RhdGljIHFkaXNjIHNldHVwLCB0aGUgaXBlcmYgdWRwIHN0cmVhbSB3aXRo
IDUwTSAocWRpc2MgcmF0ZSAyME0pIGlzIHN0YWJsZS4NClNvIHlvdSBzaG91bGQgaW5kZWVkIHRh
a2UgYSBkZWVwZXIgbG9vayBpbnRvIHRoZSBwcm9jZXNzaW5nIGR1cmluZyByZWNvbmZpZ3VyYXRp
b24uDQpLaW5kIHJlZ2FyZHMsIEhheWUNCg0KLS0tLS1VcnNwcsO8bmdsaWNoZSBOYWNocmljaHQt
LS0tLQ0KVm9uOiBUaG9yc3RlbiBHbGFzZXIgPHQuZ2xhc2VyQHRhcmVudC5kZT4gDQpHZXNlbmRl
dDogU29ubnRhZywgMTEuIFNlcHRlbWJlciAyMDIyIDAxOjQ0DQpBbjogSMOkaG5lLCBIYXllIDxI
YXllLkhhZWhuZUB0ZWxla29tLmRlPjsgU2VyZ2V5IFJ5YXphbm92IDxyeWF6YW5vdi5zLmFAZ21h
aWwuY29tPg0KQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCkJldHJlZmY6IFJlOiBSRkgsIHdo
ZXJlIGRpZCBJIGdvIHdyb25nPw0KDQpIaSBTZXJnZXksDQoNCj4gQlRXLCB0aGUgc3RhY2sgYmFj
a3RyYWNlIGNvbnRhaW5zIG9ubHkgUlROTCByZWxhdGVkIGZ1bmN0aW9ucy4gRG9lcyANCj4gdGhp
cyB3YXJuaW5nIGFwcGVhciB3aGVuIHRyeWluZyB0byByZWNvbmZpZ3VyZSB0aGUgcWRpc2M/IElm
IHNvLCB0aGVuIA0KPiB0aGUgZXJyb3IgaXMgcHJvYmFibHkgc29tZXdoZXJlIGluIHRoZSBxZGlz
YyBjb25maWd1cmF0aW9uIGNvZGUuIFN1Y2gNCg0KZ29vZCBwb2ludC4gVGhlIHFkaXNjIGlzIHVz
ZWQgaW4gYSBtb2RlIHdoZXJlIGl04oCZcyByZWNvbmZpZ3VyZWQgbXVsdGlwbGUgdGltZXMgcGVy
IHNlY29uZCwgYWx0aG91Z2ggSSBkbyBub3Qga25vdyBpZiBteSBjb2xsZWFndWUgdXNlZCBpdCBs
aWtlIHRoaXMgb3IgaWYgdGhlIGlzc3VlIGFsc28gaGFwcGVucyB3aGVuIHN0YXRpY2FsbHkgY29u
ZmlndXJpbmcuDQoNCkBIYXllOiBkb2VzIGl0IGFsc28gY3Jhc2ggZm9yIHlvdSBpZiB5b3UgZG9u
4oCZdCBydW4gdGhlIHBsYXlsaXN0IGJ1dCBqdXN0IGNvbmZpZ3VyZSB0aGUgcWRpc2Mgd2l0aCBq
dXN0IHRoZSB0YyBxZGlzYyBhZGQg4oCmIHJhdGUgMjBtIGNvbW1hbmQ/DQoNCkkgZGlkIG5vdCBo
YXZlIGFjY2VzcyB0byBteSB0ZXN0IFZNIHVudGlsIHRvZGF5LCBzbyBJ4oCZbGwgYmUgYWJsZSB0
byBsb29rIGludG8gdGhpcyBtb3JlIG5leHQgd2Vlay4NCg0KVGhhbmtzLA0KLy9taXJhYmlsb3MN
Ci0tDQpJbmZyYXN0cnVrdHVyZXhwZXJ0ZSDigKIgdGFyZW50IHNvbHV0aW9ucyBHbWJIIEFtIERp
Y2tvYnNrcmV1eiAxMCwgRC01MzEyMSBCb25uIOKAoiBodHRwOi8vd3d3LnRhcmVudC5kZS8gVGVs
ZXBob24gKzQ5IDIyOCA1NDg4MS0zOTMg4oCiIEZheDogKzQ5IDIyOCA1NDg4MS0yMzUgSFJCIEFH
IEJvbm4gNTE2OCDigKIgVVN0LUlEIChWQVQpOiBERTEyMjI2NDk0MQ0KR2VzY2jDpGZ0c2bDvGhy
ZXI6IERyLiBTdGVmYW4gQmFydGgsIEthaSBFYmVucmV0dCwgQm9yaXMgRXNzZXIsIEFsZXhhbmRl
ciBTdGVlZw0KDQogICAgICAgICAgICAgICAgICAgICAgICAqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqDQov4oGAXCBUaGUgVVRGLTggUmliYm9uDQri
lbLCoOKVsSBDYW1wYWlnbiBhZ2FpbnN0ICAgICAgTWl0IGRlbSB0YXJlbnQtTmV3c2xldHRlciBu
aWNodHMgbWVociB2ZXJwYXNzZW46DQrCoOKVs8KgIEhUTUwgZU1haWwhIEFsc28sICAgICBodHRw
czovL3d3dy50YXJlbnQuZGUvbmV3c2xldHRlcg0K4pWxwqDilbIgaGVhZGVyIGVuY3J5cHRpb24h
DQogICAgICAgICAgICAgICAgICAgICAgICAqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqDQo=
