Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF38064A098
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 14:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbiLLN1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 08:27:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232470AbiLLN1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 08:27:04 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 267852DD3;
        Mon, 12 Dec 2022 05:27:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670851621; x=1702387621;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hDsU5IN6VkcIjBtk+RonKJtWbFRs/wXi4j4+YP5A3jA=;
  b=uVsAW7tvVxMDzQkibYEGBdDoCIMAhVR4gD0mYvMv4lPW9U0LtJ8uZxMT
   rIj5jopymg8l5kPhOIzBOKv5dW//mxyej57XwBrFf/doKTvz819KRMUg9
   4J0vTnoyfZ/A6tqGl9/Cx26g9Sqk0HDtsp0z0UNyL7OvnQJ5HDowlsnFq
   suk8Hal937Fr7uOIhD+/TxR7kfC/mR3ZF5B8I4L1AEJ64iXB+ZvqZ5b1n
   ijT1GZHgunh6n+NEzKWVLZ9xVOjMg3tvixYzApmS4OmTMisZUIk6s6df1
   wpUD3w8yvk45VCPmSIm+k59VZ0KqEQ87rBbbhggfUHaYN7nh7vf5Ae1IV
   A==;
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="191228106"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Dec 2022 06:27:01 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 12 Dec 2022 06:26:56 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Mon, 12 Dec 2022 06:26:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FhjslzxW3cIt4oURL2rjemnCx9hPnKq4lqUGoffYXue7Zy38iczSDm7UHCT4QtRrwCM1r3zov1aR91v7aUOZzn5hBN7ejFdLwM8ii1Zo4tZs5BTrY3wbDFdEEwr496scffM1nzJTQC8+DahRbRGP+P883GEYCLjqYe6rgB9yEW04FHpSm3V9QWcJJ0Gp15j+VTs4QI4+AfBzloZW7HszJ7QwNTvZxjS6h2weAJUkjRp0zFREkUnRx4I9JEWDJWKVKgme6nHk02RYLhwGSSpjMNvZ7YlGLYo5r31NNOMPJB0PnfpfrL5NPtFH6qQrlyOlYPsrMDvY1P6Zs96Nn3uanw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hDsU5IN6VkcIjBtk+RonKJtWbFRs/wXi4j4+YP5A3jA=;
 b=OPTpn/6sI1/VD3zFscJog0W8pa5EoQJd7TcpgUbGuhLv4P2ZTrHaDw96/8aoa4XfOKBn6b2d7F72aD+Qtbq0GVEp77pL+ZP6UTjc1k7T3r7W/R98RNcyIaWgDsSLZQf5sLZYT2nTjZ6xeRh9Q9310jXP71BNGLUk2HXhWqIKWzsW+CkaoY/6eSbd6orLbhdxT2qPUx3NT2miYQPvHSfNgfGCoZfZQweTtDkhdYTgm6IOh9ddIpWY740oznVORYXl4hRpT4HsLoIJ1nSLQCbid4038FMsDC3OkRSbJUU6FAfhSMajNIHPkNJzDlIUkcP1YOdFxasj83CdZUXhsAHqsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hDsU5IN6VkcIjBtk+RonKJtWbFRs/wXi4j4+YP5A3jA=;
 b=vcWVPtoiIaGddYwc/17YPEyHFD7zBbgLoytXShYiRcBcEopJz6WBfC4CvF/0fpSRdWFeeyivyrVFpnfhePc3YcMfDZHEtL2Z68cgHWjQVnTSC2Dk4mMAfcZlZE4eCmz2kGoegMkze8o0xCJrEu6QYK+SZfvqXymSl9Czh4cetU0=
Received: from BN6PR11MB1953.namprd11.prod.outlook.com (2603:10b6:404:105::14)
 by PH8PR11MB6927.namprd11.prod.outlook.com (2603:10b6:510:225::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 13:26:55 +0000
Received: from BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::98f6:c9d1:bb68:1c15]) by BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::98f6:c9d1:bb68:1c15%10]) with mapi id 15.20.5880.019; Mon, 12 Dec
 2022 13:26:54 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <linux@armlinux.org.uk>
CC:     <Nicolas.Ferre@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <Sergiu.Moga@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] net: phylink: init phydev on phylink_resume()
Thread-Topic: [PATCH v2 1/2] net: phylink: init phydev on phylink_resume()
Thread-Index: AQHZDi1m7Ud0JRMn7kuNEljgFbkyXQ==
Date:   Mon, 12 Dec 2022 13:26:54 +0000
Message-ID: <b2f0994c-432f-9ac8-485e-ac9388619674@microchip.com>
References: <20221212112845.73290-1-claudiu.beznea@microchip.com>
 <20221212112845.73290-2-claudiu.beznea@microchip.com>
 <Y5cizXwsEnJ3fX0y@shell.armlinux.org.uk>
In-Reply-To: <Y5cizXwsEnJ3fX0y@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR11MB1953:EE_|PH8PR11MB6927:EE_
x-ms-office365-filtering-correlation-id: 083c7561-64d2-42f2-8620-08dadc448979
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7rmHUB2mfDjjzFpu2IzrRbpNoldq+tZADhnvMPEvGvSws0Xe1sCfH5FEQaWQvfBbp/Y3sP/18ePNJWgHCVZ35c+hJE38f2XDAJ3utPW6ZhILfPfS63SImMvk8PvpFF9fsqAZdc6JV9z0AmxJV8VsLhfeTTytFpsoYuvJ9Ll/kEyACrHQV6cDsucWzlDGbIVzIDXl05FYUA4mByldlb/YF1kFRcbAyopPbSe+z13odoso0W79GCzfIHLcvL1LKCm9gp6rHGhZGBk4VybSelffvRsPhqoP4T/FYbOnhV918063xYn6bHLDplSankW5v5kuggIqqu2vso48t1Zoc/njQEekBEltrFmFzAdU113jMuFNk2HCofqCQXEkCZu9Sgim/Jqt0j4SjuUjeKIQKNXHl9jCzCerXh7Bc9xMnql3375O8hhhJSmPq0xTVu3q3TB5qSxnzEs/GGqwt82gkPLcs5MI0wGKSRVsw4Ney3j100iU31Mty6FbO7dFkzcXRtXQ382TADOG46H9Fdq5G31Er5Muc+Qn9jAkSlj6B3AQS+84R7bj5ksd1DS8wqqj4GM+OXVma8T4yuaBSGJwjB2ndSfAiEykl2zm4SdxjeAaOZglfLwhKHO46Rca13XV4CaQfe+hWK4gzxkJAyEBs6iYT3QQaUekgGZeUQ7S/BVcKOiKRWWAG26Li0YC5UYOqin0SdbiqJmOmmpMs8Nn0h/5pU5N/ij0yQ5y54RmD/p9m63vLGODiVlpHs8W76AsSsA3ld81pN65pXW5RFly3cNJmVhpQ2PKI8h+Ph0z77WSwzKqVcMnw4D5IP7ETYY/lkarRS1yCeiyolrHkuyaW7n5Og==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1953.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(366004)(136003)(346002)(396003)(451199015)(38100700002)(122000001)(86362001)(8936002)(478600001)(31696002)(966005)(71200400001)(6486002)(66476007)(91956017)(66446008)(66556008)(66946007)(76116006)(54906003)(186003)(6916009)(8676002)(64756008)(4326008)(2906002)(53546011)(6506007)(6512007)(316002)(83380400001)(26005)(2616005)(41300700001)(31686004)(5660300002)(38070700005)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QWVKUXRFK012VEMvbmxqeCszMVh0N3prTVdLUmJ4aHZhSnA2S0d3a2p6QXFW?=
 =?utf-8?B?NFJ3Tk9lcDluTlZ4SnFYMC9wYTZ6aHhjUVhaOVBjWUlZN3RseFJwQ084S2Ey?=
 =?utf-8?B?b0IxdkdZSGpzL05vL0xjZlg0bjhZTVhxWHdaUWcrZzZvK1BUWlNDbnoxQUpG?=
 =?utf-8?B?K0dXdjd0OFgzMDVxcSs1TW5RZTZpMWxacmpYMjN3ckd2a2pvdkFjdU10dm9Z?=
 =?utf-8?B?bUliZzRqV3U2OURwWWc5WFpZYnRxNWdkanlBSEZ6VTl3WUEyNWN1dzcrWndi?=
 =?utf-8?B?TXY2Yjl0ZTlka055OCt4aXQralpNcFExR0JEWEp4dUFRdTUrRnhpLzdkWE8y?=
 =?utf-8?B?bDM2cWdBaDBzOHFzTUFnS0cwUkJrRWZCSjNneFhvdE9hU1BTQktJTXZRZXBW?=
 =?utf-8?B?M05tSnBFOUdqVkExTUFkMUswOFk1Z1JtakI0YkxraWRDQ0haQ1R1RmZiWTNt?=
 =?utf-8?B?MXF3Q3Z6cEx1a2VOakYyWnBrTUNPZUV6ek9sY3Q2Q1dBOXhwQ2o0YVYvd3FF?=
 =?utf-8?B?UUxCM0gvb3BKUWVjTDJweVdvY1JjTEJTUTRwd1hJcjZaYlBZTUdhN29WQ0NO?=
 =?utf-8?B?b0dqMjlmL0RMZXdHdUJ3RVFIYTJMaGZ4UGVYSjExcmVWMkVhaFpLOWUyZ04r?=
 =?utf-8?B?YzVyNFY5aGdHNVcxQWlCTXg3czN3S0o2V1Q5RDJtVVZLT3pPS05RMzFoK3Np?=
 =?utf-8?B?RytYTFdxRlY1L09oQmdwaURqSVdwckNtcGkxbTRwUkY5b3g3cHcrZGFYN3cz?=
 =?utf-8?B?c0crSGV1Z3VGQ3hBSFgxa05ETlo5ZzNnN1ZiMCt0bUs4S21ySUtIcFF3eW9r?=
 =?utf-8?B?TktRUllTUm9qS3hhaEVQeE9PeW1JT3RRa0VXSHdpWVNyTjlSczkvaUxsclhs?=
 =?utf-8?B?aEVIRFFSc05NdDNzSDJ4Z0twdmRaa2l6aDUwRklWSFM2ZHNBeGtuNWRqN0dj?=
 =?utf-8?B?ZllQV2g1aUdxSUJ3K1hoMVFFdnowWkJ5Zjlvc2FRZW55WEhOYzdPZEJNSG43?=
 =?utf-8?B?SzBESE1TMnVMcXBaSzNIZ213ck11U3R2TkdFODdheHBZS0Q4MkJqNkhVdFZs?=
 =?utf-8?B?SXU5Wkg3SE9VMzVIS2RlTmxPQjh1TW02QUpyRm5DTlBLWHdzcmJEYWxQNFlx?=
 =?utf-8?B?dE10NWJhZkwrTEF5VGFNdmdOanM3UWNSN0ZydElWenFNays2akVybENxOTZw?=
 =?utf-8?B?RmhGdFBCeVFsTnlQMEFSMWFZZTZQeVByZVpYWFR2NzF6T3g3cFhVY1Fkajlt?=
 =?utf-8?B?ek9DaXVoWjJzUTJrWFY5b1c4Q0owT0JoNCtFbnpOSmFhYjFtT0g3UWxFMm50?=
 =?utf-8?B?SkcwcHUyVkJld2tBK3lnOTFUTkpMREJ4S2pVV04wRXpDMWxQTFVUYXpRLyty?=
 =?utf-8?B?UVBQcjljWU15Y0xGVGhTNzFBbzQ3SGQxYWpHK0E4V1h6TCt0YXcwd3UzRytl?=
 =?utf-8?B?bjhYMFppd1hwWVNaOTZKZjk5YXI0d09HZ1VzcHJVQlQvVmtMWmJDSjdVdnRR?=
 =?utf-8?B?WWZGT0h0OHZtSmtVM2xVRDNsRytNSVFJSUhIU3RydFNWR3p2OC9TOWR6TlZR?=
 =?utf-8?B?SUJyWE1DbnNic1Frb0x1czdsT2FVdEtnblhLdE0yYWs3am9uSUx6dmszZ0FK?=
 =?utf-8?B?bVlhT1VOYWZwbEwrM2gra0Nld01qZ3A3YXdGLzZ1ck5uVFJLVkJ0NDdmeW5Y?=
 =?utf-8?B?cENEcFp6azI2SDhDSm1KV2tiM01wUW9laEFRTkRUOUpWdHBsUm9LT0M2a0No?=
 =?utf-8?B?elhCS1lrTTlyMnJ2TVEvb2RvV3pVMS9FZTNZVDJvbmNKTzdsRWdJRldBck5D?=
 =?utf-8?B?VlRxZ0pUbVo1YUl4T0x3N1RubFVXZjY1WEpEWmdGdTNwZmdOVnd2b0Ezb2FH?=
 =?utf-8?B?Z2VDaCt2ZUlnbXUvM1JXcXJ2cThMWFNsNWdUMU1oOGxSbEtUdTdOd255bFp6?=
 =?utf-8?B?dVl3R2RrenE0UDdFcTBncmFabFZ0b0ZrTkVYV3FTSFF2YTZCKytDZUVwQ1pz?=
 =?utf-8?B?dkhmV1RvUkVHWFNjL2JOeGdFVVYrTmkwR0ZFa2d5WVhQYU5NK2YyVmFBSlV0?=
 =?utf-8?B?RW9wWUdKYjF3aCtkMXlHdmc0TGZ0MHNmSEZ3M1lsWlJTNjMyZUt3MXEyRkdE?=
 =?utf-8?B?Ky9FY2V6SHFDUEtBU2dVUjNRU0NUYmpKeEQzeDNQOStVeUVENGpzcDlpNGJh?=
 =?utf-8?B?VFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0E1E71C5CAB6F248BE3DA3048EA882A5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1953.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 083c7561-64d2-42f2-8620-08dadc448979
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2022 13:26:54.8051
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 89TJ2lcdRSc2vLgGW5aK5ST47H6hI/T1718m+Bv3B+iHV1+hHNl7xmeA/CO7qUQPK1cNijufsTbQbFagXz9DKPokPpewwWUWbTr5LVyv+JA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6927
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTIuMTIuMjAyMiAxNDo0NywgUnVzc2VsbCBLaW5nIChPcmFjbGUpIHdyb3RlOg0KPiBFWFRF
Uk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNz
IHlvdSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IE9uIE1vbiwgRGVjIDEyLCAyMDIy
IGF0IDAxOjI4OjQ0UE0gKzAyMDAsIENsYXVkaXUgQmV6bmVhIHdyb3RlOg0KPj4gVGhlcmUgYXJl
IHNjZW5hcmlvcyB3aGVyZSBQSFkgcG93ZXIgaXMgY3V0IG9mZiBvbiBzeXN0ZW0gc3VzcGVuZC4N
Cj4+IFRoZXJlIGFyZSBhbHNvIE1BQyBkcml2ZXJzIHdoaWNoIGhhbmRsZXMgdGhlbXNlbHZlcyB0
aGUgUEhZIG9uDQo+PiBzdXNwZW5kL3Jlc3VtZSBwYXRoLiBGb3Igc3VjaCBkcml2ZXJzIHRoZQ0K
Pj4gc3RydWN0IHBoeV9kZXZpY2U6Om1hY19tYW5hZ2VkX3BoeSBpcyBzZXQgdG8gdHJ1ZSBhbmQg
dGh1cyB0aGUNCj4+IG1kaW9fYnVzX3BoeV9zdXNwZW5kKCkvbWRpb19idXNfcGh5X3Jlc3VtZSgp
IHdvdWxkbid0IGRvIHRoZQ0KPj4gcHJvcGVyIFBIWSBzdXNwZW5kL3Jlc3VtZS4gRm9yIHN1Y2gg
c2NlbmFyaW9zIGNhbGwgcGh5X2luaXRfaHcoKQ0KPj4gZnJvbSBwaHlsaW5rX3Jlc3VtZSgpLg0K
Pj4NCj4+IFN1Z2dlc3RlZC1ieTogUnVzc2VsbCBLaW5nIChPcmFjbGUpIDxsaW51eEBhcm1saW51
eC5vcmcudWs+DQo+PiBTaWduZWQtb2ZmLWJ5OiBDbGF1ZGl1IEJlem5lYSA8Y2xhdWRpdS5iZXpu
ZWFAbWljcm9jaGlwLmNvbT4NCj4+IC0tLQ0KPj4NCj4+IEhpLCBSdXNzZWwsDQo+Pg0KPj4gSSBs
ZXQgcGh5X2luaXRfaHcoKSB0byBleGVjdXRlIGZvciBhbGwgZGV2aWNlcy4gSSBjYW4gcmVzdHJp
Y3QgaXQgb25seQ0KPj4gZm9yIFBIWXMgdGhhdCBoYXMgc3RydWN0IHBoeV9kZXZpY2U6Om1hY19t
YW5hZ2VkX3BoeSA9IHRydWUuDQo+Pg0KPj4gUGxlYXNlIGxldCBtZSBrbm93IHdoYXQgeW91IHRo
aW5rLg0KPiANCj4gSSB0aGluayBpdCB3b3VsZCBiZSBiZXR0ZXIgdG8gb25seSBkbyB0aGlzIGlu
IHRoZSBwYXRoIHdoZXJlIHdlIGNhbGwNCj4gcGh5X3N0YXJ0KCkgLSBpZiB3ZSBkbyBpdCBpbiB0
aGUgV29MIHBhdGggKHdoZXJlIHRoZSBQSFkgcmVtYWlucw0KPiBydW5uaW5nKSwgdGhlbiB0aGVy
ZSBpcyBubyBwaHlfc3RhcnQoKSBjYWxsLCBzbyBwaHlfaW5pdF9odygpIGNvdWxkDQo+IHJlc3Vs
dCBpbiB0aGUgUEhZIG5vdCB3b3JraW5nIGFmdGVyIGEgc3VzcGVuZC9yZXN1bWUgZXZlbnQuDQoN
ClRoaXMgd2lsbCBub3Qgd29yayBhbGwgdGhlIHRpbWUgZm9yIE1BQ0IgdXNhZ2Ugb24gQVQ5MSBk
ZXZpY2VzLg0KDQpBcyBleHBsYWluZWQgaGVyZSBbMV0gdGhlIHNjZW5hcmlvIHdoZXJlOg0KLSBN
QUNCIGlzIGNvbmZpZ3VyZWQgdG8gaGFuZGxlIFdvTA0KLSB0aGUgc3lzdGVtIGdvZXMgdG8gYSBz
dXNwZW5kIG1vZGUgKG5hbWVkIGJhY2t1cCBhbmQgc2VsZi1yZWZyZXNoIChCU1IpIGluDQogIG91
ciBjYXNlKSB3aXRoIHBvd2VyIGN1dCBvZmYgb24gUEhZIGFuZCBsaW1pdGVkIHdha2UtdXAgc291
cmNlIChmZXcgcGlucw0KICBhbmQgUlRDIGFsYXJtcykNCg0KaXMgc3RpbGwgdmFsaWQuIEluIHRo
aXMgY2FzZSBNQUMgSVAgYW5kIE1BQyBQSFkgYXJlIG5vdCBwb3dlcmVkLiBBbmQgaW4NCnRob3Nl
IGNhc2VzIHBoeWxpbmtfcmVzdW1lKCkgd2lsbCBub3QgaGl0IHBoeV9zdGFydCgpLg0KDQoNCkp1
c3QgbXkgZmVlbGluZyBhYm91dCB0aGlzOiBhZnRlciBsb29raW5nIHRvIHBoeWxpbmtfcmVzdW1l
KCkgaXQgbG9va3MgdG8NCm1lIHRoYXQgKGF0IGxlYXN0IGZvciBNQUNCIG9uIEFUOTEpIGl0IGlz
IGJldHRlciB0byBoYXZlIHRoZSBQSFkgaGFuZGxpbmcNCnN0aWxsIGluIHRoZSBNQUMgZHJpdmVy
IChjYWxsaW5nIHBoeV9pbml0X2h3KCkgZnJvbSBkcml2ZXIgaXRzZWxmKSBhcyB0aGlzDQp3YXMg
dGhlIGludGVudCAoSSB0aGluaykgb2Ygc3RydWN0IHBoeV9kZXZpY2U6Om1hY19tYW5hZ2VkX3Bo
eS4gQnV0IHRoaXMgaXMNCm5vdCBiYXNlZCBvbiBhbnkgdGVjaG5pY2FsIGFyZ3VtZW50IGF0IHRo
ZSBtb21lbnQuDQoNClRoYW5rIHlvdSwNCkNsYXVkaXUgQmV6bmVhDQoNClsxXQ0KaHR0cHM6Ly9s
b3JlLmtlcm5lbC5vcmcvYWxsLzQzNzVkNzMzLWVkNDktODY5Yy02MzVmLTBmMGJhNzMwNDI4M0Bt
aWNyb2NoaXAuY29tLw0KDQo+IA0KPiAtLQ0KPiBSTUsncyBQYXRjaCBzeXN0ZW06IGh0dHBzOi8v
d3d3LmFybWxpbnV4Lm9yZy51ay9kZXZlbG9wZXIvcGF0Y2hlcy8NCj4gRlRUUCBpcyBoZXJlISA0
ME1icHMgZG93biAxME1icHMgdXAuIERlY2VudCBjb25uZWN0aXZpdHkgYXQgbGFzdCENCg0K
