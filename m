Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA196E1EE2
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 11:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjDNJAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 05:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjDNJAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 05:00:03 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD6ED7
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 02:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681462800; x=1712998800;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=K2eKT/wgwFqVT54R/kEOKmMQ4f93p1enaUO8BvAnMZk=;
  b=B4/kC/X43PNGS0RFhc5LQSd0DalrfNLcp7E7BtHBrNjRPGcyodI49Unk
   qflPTGuXR5XZRP01VeGBCz6TidjafwA808qCK6nHG7dbUbbnpvH5lF5q5
   15q9G+QCzDDpQTf+RocAJHQPGbWp0inIsOcSW1MGgKSTSUG8BX1lLccuA
   SiOjIhgLsHpYnPrAT8B39Qo7dW9IyMbZkLK1hup5BRMoYW3/6zPeeU/4w
   mrqYIwJwqzP0JBXSpaXlTPz2sjk3WrSVngaajoTCs4LgecZo8XTDEKckt
   Ahe/XMG+2aclYa+Mlfp0CcJMEq1nJUvfWTWDNkDLFDXhEym01tKmD+tCS
   Q==;
X-IronPort-AV: E=Sophos;i="5.99,195,1677567600"; 
   d="scan'208";a="147066042"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Apr 2023 01:59:59 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 14 Apr 2023 01:59:57 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 14 Apr 2023 01:59:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ckmi/2Lc9UgTAT4fK7ixx4a3FijzbHeiDjOg0ViEH4gj6MtyhgPVxXCtwK6GX6hJ9Q6yzR4spVnJWJ1BOiV2chLEV6Nw/mZkn9P8mAq7d5vHGUkeKTFmio54YR5yyeLiKW5u/YRYaO4flfSUOJ6V9z/beQwKp/WU/t2hbjq2QPp4MdM9E5hVDMvyMRH+oCDPSM+IrF0eB0hNUob0euw+6HYPunjOTHH5jVLB7pLFdzWcFNoypusG+wI2Hp7znLx0rGnfLz/6deHqWGqTANYAmriMtL+JugurthM9IcNrwjVfuhQMlYaUX7Q5M9PK3lPLZwfhaok3UkZGL5Iilqbpmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K2eKT/wgwFqVT54R/kEOKmMQ4f93p1enaUO8BvAnMZk=;
 b=jku+3LjKXOomDyN3BUKj3kvHo6DeSPYSZRQp5n9auq5fwQjgXJmhNl7hcm+YqZzNh3s1cR2Tos7C7toIsqJy3oz56dzj6UUqxhMH67k/toyMTkCl1DgYSLZ5tL0QUrZjn+r/KXqGBHJ8bBVuizinGJ9rPOOZ38Eb9zh429SKKV1euyp/XsiUc5am7qjqoXC11bzFNwiyE7BBvJW+KASgXjVsPUWfyX0MAZConZRGInjZ/lZO7MbBxaqAxkBdniAGVDNbx3YRV+wrp+G/SRcpNCAw0xtzL3Vb62B4DIbgqJQdvwCQ7pRP+LriRSXM5ncdVpO4f9ycjpILQu/vqpuEAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K2eKT/wgwFqVT54R/kEOKmMQ4f93p1enaUO8BvAnMZk=;
 b=qL8odoMP3Hxi7OxE3ggyT9mM/V18DHJFGNWROBoBrPJFNB5E1fgrkoxAyPyv+dwsbJ52p506u3sa8a3i1jG9v9AX8L4aIPr/1bs/bygxJ1zcF0Lmv4w3wvltbTwqJp/z/2J920Ix0yEtyE9Q2UbJD4MLJ678nNayr3gDisRb09s=
Received: from SJ0PR11MB7154.namprd11.prod.outlook.com (2603:10b6:a03:48d::9)
 by PH7PR11MB7515.namprd11.prod.outlook.com (2603:10b6:510:278::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Fri, 14 Apr
 2023 08:59:54 +0000
Received: from SJ0PR11MB7154.namprd11.prod.outlook.com
 ([fe80::8052:da5b:3a4d:45a]) by SJ0PR11MB7154.namprd11.prod.outlook.com
 ([fe80::8052:da5b:3a4d:45a%6]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 08:59:54 +0000
From:   <Nicolas.Ferre@microchip.com>
To:     <Daire.McNamara@microchip.com>, <Claudiu.Beznea@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <Conor.Dooley@microchip.com>, <Nicolas.Ferre@microchip.com>
CC:     <harini.katakam@amd.com>, <michal.simek@amd.com>,
        <roman.gushchin@linux.dev>, <jacob.e.keller@intel.com>
Subject: Re: [PATCH v1 1/1] net: macb: Shorten max_tx_len to 4KiB - 56 on mpfs
Thread-Topic: [PATCH v1 1/1] net: macb: Shorten max_tx_len to 4KiB - 56 on
 mpfs
Thread-Index: AQHZbq97UUOfzCCfV0i+nM5QqZ11ZQ==
Date:   Fri, 14 Apr 2023 08:59:54 +0000
Message-ID: <fb680e8f-4385-f54d-5827-6f2e3034703c@microchip.com>
References: <20230413180337.1399614-1-daire.mcnamara@microchip.com>
 <20230413180337.1399614-2-daire.mcnamara@microchip.com>
In-Reply-To: <20230413180337.1399614-2-daire.mcnamara@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB7154:EE_|PH7PR11MB7515:EE_
x-ms-office365-filtering-correlation-id: 0c3ddd4a-d6a8-43fe-a399-08db3cc69d91
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kz6DttkFBxXF28EH0DIYzgHzSua4LGU+AnVNQyRRZhnr7AdOvBWas8Nke4qGCY412dYhBfA7+fIlew+Rp79Aa5auTu246pNbvCQoqEV1VsoMtCI6WYajzJvQMZJiMfIhEJOVqWot7IqX8sUGrC8fP2nZCoPpMaWjhoM68WGJfoEaZhEY+ZhCYFHTf26dBPnpcVIe76e2/61fgT8KEG/I5c3GrWNvdqGCcGbrlRf3TTZtaXgXSUNihdaIYOQG2gmpuiHZogemxxYxtRwyxtCq2UGwaw5XRm+k9IDcgsmgd812eh3GE4kijbflcIdeauJuKPXEMCdzc8qXvBSLhM5VzmAvhTNsK5nKb0+iwHhcpQampaLJLnoGTsBngEyJI+N5Ar+q9csEPOOkIPVPTbUw4Tl2betXT5/SCHX66H8m7NIPs9ZEroH73L8hqzqXVAaIhJSVGFHNDPRTgqfQvJM2za4AlKeJ9W8Zv3I0Zm8SzCAJgwFQm7/8m5YY+TmVkpLSBtOtYINbPU2Xp787JTG4F8q6zZbWeLruljChwLnl1EMKMw3QnNpR9qV8aSZnxnyxTeqQ+diPLh5PUKLLnux33Jqthsc0z8BwE3dtr1oo0VBF1iiiU5P9onCoJzo9YP4YzcoPOpDnxWXVz29RiIb1SLkaVedBygds6WA3I0Ndjv/SMaF1T3OQP/P30xGQU+ok
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB7154.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(376002)(366004)(396003)(136003)(451199021)(8676002)(76116006)(83380400001)(91956017)(110136005)(54906003)(2616005)(478600001)(71200400001)(6486002)(6506007)(26005)(6512007)(53546011)(186003)(2906002)(38070700005)(38100700002)(36756003)(5660300002)(316002)(4326008)(122000001)(66476007)(66556008)(64756008)(41300700001)(66946007)(66446008)(86362001)(8936002)(31696002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WmlGMWxHUjNYR2EwaWNBM3paN1hkRUkyWjVrQXNRTUJlZGhIRFZyOXZDMUph?=
 =?utf-8?B?NmhERWhwMFdtNHlpb0pLUzIwNVhJMFEzZElYb2JrOVQwSDI5SmN3dnBYcE1V?=
 =?utf-8?B?QjRWWDRPSVZFOTM0OXRXT3NTY3BPVXBKT2xzK21xaHlsR3pWdFRGT092TUJs?=
 =?utf-8?B?UC90cS9XL24wWTVqUXR4Q3Y5emhuNzVZZDhyZ0x2RHRPdEVrTEdTN3Mrckd3?=
 =?utf-8?B?VUhwT29sd0ZXOHNUTXJGWXdHTXBVajZ5SUJQZlllc3lwQi96eTAxQW8yQjVN?=
 =?utf-8?B?am9HL2ZHQXN4dVpxczdyalNhUEtrUHRaeTh3Y1pka2ZSdU83QnI1d0NucUU5?=
 =?utf-8?B?YktPempCWEU1R3RiM29YT1RVQnVRWE1SSG1hd1owWGMraWg1ak1waUZMb3Fh?=
 =?utf-8?B?R3dScnZQcFhOem1jSi84cGgzRUlSWnl4QklJamtmVU1IbmVOSW90RlVqczk4?=
 =?utf-8?B?a2V1VnhsTzFraVpCcGhIbWx3ZTdTSUxOdUttOXBNZWpPR3U5aFdFdFVmRUF6?=
 =?utf-8?B?dDc3eWtUTENGZE9KWTNkMmQvMlN6RElMazduL040RFFrN3dLdXk1NGI0eTdG?=
 =?utf-8?B?MVFpMVg1eDd5aG1xdGYxVm4vNXdjTHpjWk05KzN6VFZQNFlDMHJUcHBBeHlx?=
 =?utf-8?B?azBMakZGZE9aVmFJeWJhWURNcWZEdUJjWTFPYlAyRUpvdVhPNkE4UElvOHJP?=
 =?utf-8?B?bEhjZk4yUGRIb1AzUEs2WGcwUzlJZXZ3WGtlMHpVSS9kdHNERnE1NllpTkpK?=
 =?utf-8?B?R2Nvbnh0Z3FEU2JNdlRIRXV1RGlMV0Frem5lNExnK3FPdDJpdzZaL3ZsREdV?=
 =?utf-8?B?Q20wbk1HOSsrSjU3cGtTNDJIM0pIUG9UZzhWSEp1TnJMcm4wU0E5aEVWZFpT?=
 =?utf-8?B?NEtrRWZYN2JpRSt4Tm5TZ1ZRa2R5eEhjL0NybTB6NTdmRGU0c2JnbnRQT0xT?=
 =?utf-8?B?TUc5UmdneDRvKys5RG82bGczeDFKdnp4bGNEcmJJR2dwSjhaWW1XQ0ZwazBD?=
 =?utf-8?B?QWNwTWJTSGYyTGhGWVlpZ1pUK2JKK3JpK29aRFAyU293TnNOcW1rREhBY09y?=
 =?utf-8?B?cnF1c3BKMUwyZ2ZxUGdSa3FIeDk5T2o5Wjh6TjEwNTF5cFRiS1F1bVZpcUcw?=
 =?utf-8?B?R2VmS0NWWlBWcDJZejQxTURob0ZnMnJsOVRqeEhQcXhZWVNzbDVWWjh2eE1O?=
 =?utf-8?B?QUZ0aVhUdEl6V1RDRFBydVUyTnUxaUZDQTJ4RlR6eWxQcjZEUHEvYWR1THNG?=
 =?utf-8?B?OEdHc2xiV0NGM2hzK0IyU2NzRDEvRythdlpaTTVCQjB3bWhmZzNJUmRSVDNM?=
 =?utf-8?B?RmIwWHVZSzg1b2s4R1dGaWNBQlBBWFc4MXV4a1RMQkVNTkJhMklTZk94WDR3?=
 =?utf-8?B?b2c1d1dERUJnL0JSRS9tYXVpbVRaRVVLUENoamQ5Tk5hZ2pOSEF1eFFlMFpU?=
 =?utf-8?B?dmlVMjdndkZIRXpkRzJOV0FuOWhDSzdBNDd1V3RuK2psdUI5UDNXeCtEVEc2?=
 =?utf-8?B?YWJhNUlHOCtCQ0ZTdHltWTBqRkhQNUpnd1p5elhWd0F4WkVWbFdwQnZuV3BH?=
 =?utf-8?B?bEwyTHFUYkZkTXFSZ2VwVzJqM1BPdjlLMlJLai9HUGcvRXZjaDhCemFSQytm?=
 =?utf-8?B?RG9hTU5wUWNxS3FTRGhqQmpobllMenozMitETGxVVkpnRGpySzR3QUVpck5U?=
 =?utf-8?B?d1N6TDhEZHV2dCsvb3BQazQ2TE1QWVcxVGVZNHBpSlU4cDZFaGVIV3JlWnFj?=
 =?utf-8?B?TVRrTDVjdExmVGh6ZXY4dGRHS0NFYU41RzBYaGNhSllHTnZWWUx4K0F0Mm5H?=
 =?utf-8?B?ZnZmcjNtYWJuMXpVWVA4OXdkV29Mc3k0blUzendCUFVnd2hHdi9aN1V0TG1Z?=
 =?utf-8?B?V3dxMXRGTy9WdlU0dWx4cmROM2ZaVUhmU3ZjcWdVT251OFlpZlA0U1NHWlE3?=
 =?utf-8?B?bkVjSkVFN2VWcmFzL21oMmlCRUxVcHl0RU9FM1QwVTA1UnFMbGNkTmV3WHRi?=
 =?utf-8?B?YlpVbkhpM2p3UTlVRitmem1QV08xZm4yMlZ3UmZQSkRTTDFUUi90MDhIMjNP?=
 =?utf-8?B?SW1UZ1dnTXNhTWNQYUJMbHRRTUhXMklKTGtYRW5sRHVFa0tNbDFaakxwMGxP?=
 =?utf-8?Q?1PMg0RkItf6Ef7+PLCJKT+3kr?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <23D77118F84C7F48A202E5C8E6C28248@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB7154.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c3ddd4a-d6a8-43fe-a399-08db3cc69d91
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2023 08:59:54.7374
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OVCtjmD06+sKrwOZJIdzWzyN9X8QJRX9JVUj2RxObVkSnv3TtvIM0KWaHXJ3NLQ/ZJOdmDHGNuhGijrvsFXaC2mEua5a8Z0yWEGkW4Tvsqw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7515
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTMvMDQvMjAyMyBhdCAyMDowMywgZGFpcmUubWNuYW1hcmFAbWljcm9jaGlwLmNvbSB3cm90
ZToNCj4gRnJvbTogRGFpcmUgTWNOYW1hcmEgPGRhaXJlLm1jbmFtYXJhQG1pY3JvY2hpcC5jb20+
DQo+IA0KPiBPbiBtcGZzLCB3aXRoIFNSQU0gY29uZmlndXJlZCBmb3IgNCBxdWV1ZXMsIHNldHRp
bmcgbWF4X3R4X2xlbg0KPiB0byBHRU1fVFhfTUFYX0xFTj0weDNmMCByZXN1bHRzIG11bHRpcGxl
IEFNQkEgZXJyb3JzLg0KPiBTZXR0aW5nIG1heF90eF9sZW4gdG8gKDRLaUIgLSA1NikgcmVtb3Zl
cyB0aG9zZSBlcnJvcnMuDQo+IA0KPiBUaGUgZGV0YWlscyBhcmUgZGVzY3JpYmVkIGluIGVycmF0
dW0gMTY4NiBieSBDYWRlbmNlDQo+IA0KPiBUaGUgbWF4IGp1bWJvIGZyYW1lIHNpemUgaXMgYWxz
byByZWR1Y2VkIGZvciBtcGZzIHRvICg0S2lCIC0gNTYpLg0KPiANCj4gU2lnbmVkLW9mZi1ieTog
RGFpcmUgTWNOYW1hcmEgPGRhaXJlLm1jbmFtYXJhQG1pY3JvY2hpcC5jb20+DQoNCkxvb2tzIGdv
b2QgdG8gbWU6DQpBY2tlZC1ieTogTmljb2xhcyBGZXJyZSA8bmljb2xhcy5mZXJyZUBtaWNyb2No
aXAuY29tPg0KDQpCZXN0IHJlZ2FyZHMsDQogICBOaWNvbGFzDQoNCj4gLS0tDQo+ICAgZHJpdmVy
cy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiLmggICAgICB8ICAxICsNCj4gICBkcml2ZXJzL25l
dC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jIHwgMTYgKysrKysrKysrKysrLS0tLQ0KPiAg
IDIgZmlsZXMgY2hhbmdlZCwgMTMgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4gDQo+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2IuaCBiL2RyaXZl
cnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYi5oDQo+IGluZGV4IDE0ZGZlYzRkYjhmOS4uOTg5
ZTdjNWRiOWI5IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21h
Y2IuaA0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2IuaA0KPiBAQCAt
MTE3NSw2ICsxMTc1LDcgQEAgc3RydWN0IG1hY2JfY29uZmlnIHsNCj4gICAJCQkgICAgc3RydWN0
IGNsayAqKmhjbGssIHN0cnVjdCBjbGsgKip0eF9jbGssDQo+ICAgCQkJICAgIHN0cnVjdCBjbGsg
KipyeF9jbGssIHN0cnVjdCBjbGsgKip0c3VfY2xrKTsNCj4gICAJaW50CSgqaW5pdCkoc3RydWN0
IHBsYXRmb3JtX2RldmljZSAqcGRldik7DQo+ICsJdW5zaWduZWQgaW50CQltYXhfdHhfbGVuZ3Ro
Ow0KPiAgIAlpbnQJanVtYm9fbWF4X2xlbjsNCj4gICAJY29uc3Qgc3RydWN0IG1hY2JfdXNyaW9f
Y29uZmlnICp1c3JpbzsNCj4gICB9Ow0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvY2FkZW5jZS9tYWNiX21haW4uYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFj
Yl9tYWluLmMNCj4gaW5kZXggNjZlMzA1NjE1NjllLi4xZjM2MmJiYzM2MGYgMTAwNjQ0DQo+IC0t
LSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4gKysrIGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPiBAQCAtNDA5NSwxNCArNDA5
NSwxMiBAQCBzdGF0aWMgaW50IG1hY2JfaW5pdChzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2
KQ0KPiAgIA0KPiAgIAkvKiBzZXR1cCBhcHByb3ByaWF0ZWQgcm91dGluZXMgYWNjb3JkaW5nIHRv
IGFkYXB0ZXIgdHlwZSAqLw0KPiAgIAlpZiAobWFjYl9pc19nZW0oYnApKSB7DQo+IC0JCWJwLT5t
YXhfdHhfbGVuZ3RoID0gR0VNX01BWF9UWF9MRU47DQo+ICAgCQlicC0+bWFjYmdlbV9vcHMubW9n
X2FsbG9jX3J4X2J1ZmZlcnMgPSBnZW1fYWxsb2NfcnhfYnVmZmVyczsNCj4gICAJCWJwLT5tYWNi
Z2VtX29wcy5tb2dfZnJlZV9yeF9idWZmZXJzID0gZ2VtX2ZyZWVfcnhfYnVmZmVyczsNCj4gICAJ
CWJwLT5tYWNiZ2VtX29wcy5tb2dfaW5pdF9yaW5ncyA9IGdlbV9pbml0X3JpbmdzOw0KPiAgIAkJ
YnAtPm1hY2JnZW1fb3BzLm1vZ19yeCA9IGdlbV9yeDsNCj4gICAJCWRldi0+ZXRodG9vbF9vcHMg
PSAmZ2VtX2V0aHRvb2xfb3BzOw0KPiAgIAl9IGVsc2Ugew0KPiAtCQlicC0+bWF4X3R4X2xlbmd0
aCA9IE1BQ0JfTUFYX1RYX0xFTjsNCj4gICAJCWJwLT5tYWNiZ2VtX29wcy5tb2dfYWxsb2Nfcnhf
YnVmZmVycyA9IG1hY2JfYWxsb2NfcnhfYnVmZmVyczsNCj4gICAJCWJwLT5tYWNiZ2VtX29wcy5t
b2dfZnJlZV9yeF9idWZmZXJzID0gbWFjYl9mcmVlX3J4X2J1ZmZlcnM7DQo+ICAgCQlicC0+bWFj
YmdlbV9vcHMubW9nX2luaXRfcmluZ3MgPSBtYWNiX2luaXRfcmluZ3M7DQo+IEBAIC00ODM5LDcg
KzQ4MzcsOCBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IG1hY2JfY29uZmlnIG1wZnNfY29uZmlnID0g
ew0KPiAgIAkuY2xrX2luaXQgPSBtYWNiX2Nsa19pbml0LA0KPiAgIAkuaW5pdCA9IGluaXRfcmVz
ZXRfb3B0aW9uYWwsDQo+ICAgCS51c3JpbyA9ICZtYWNiX2RlZmF1bHRfdXNyaW8sDQo+IC0JLmp1
bWJvX21heF9sZW4gPSAxMDI0MCwNCj4gKwkubWF4X3R4X2xlbmd0aCA9IDQwNDAsIC8qIENhZGVu
Y2UgRXJyYXR1bSAxNjg2ICovDQo+ICsJLmp1bWJvX21heF9sZW4gPSA0MDQwLA0KPiAgIH07DQo+
ICAgDQo+ICAgc3RhdGljIGNvbnN0IHN0cnVjdCBtYWNiX2NvbmZpZyBzYW1hN2c1X2dlbV9jb25m
aWcgPSB7DQo+IEBAIC00OTg2LDggKzQ5ODUsMTcgQEAgc3RhdGljIGludCBtYWNiX3Byb2JlKHN0
cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ICAgCWJwLT50eF9jbGsgPSB0eF9jbGs7DQo+
ICAgCWJwLT5yeF9jbGsgPSByeF9jbGs7DQo+ICAgCWJwLT50c3VfY2xrID0gdHN1X2NsazsNCj4g
LQlpZiAobWFjYl9jb25maWcpDQo+ICsJaWYgKG1hY2JfY29uZmlnKSB7DQo+ICsJCWlmIChtYWNi
X2lzX2dlbShicCkpIHsNCj4gKwkJCWlmIChtYWNiX2NvbmZpZy0+bWF4X3R4X2xlbmd0aCkNCj4g
KwkJCQlicC0+bWF4X3R4X2xlbmd0aCA9IG1hY2JfY29uZmlnLT5tYXhfdHhfbGVuZ3RoOw0KPiAr
CQkJZWxzZQ0KPiArCQkJCWJwLT5tYXhfdHhfbGVuZ3RoID0gR0VNX01BWF9UWF9MRU47DQo+ICsJ
CX0gZWxzZSB7DQo+ICsJCQlicC0+bWF4X3R4X2xlbmd0aCA9IE1BQ0JfTUFYX1RYX0xFTjsNCj4g
KwkJfQ0KPiAgIAkJYnAtPmp1bWJvX21heF9sZW4gPSBtYWNiX2NvbmZpZy0+anVtYm9fbWF4X2xl
bjsNCj4gKwl9DQo+ICAgDQo+ICAgCWJwLT53b2wgPSAwOw0KPiAgIAlpZiAob2ZfcHJvcGVydHlf
cmVhZF9ib29sKG5wLCAibWFnaWMtcGFja2V0IikpDQoNCi0tIA0KTmljb2xhcyBGZXJyZQ0KDQo=
