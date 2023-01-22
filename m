Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47A47677126
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 18:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbjAVRom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 12:44:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjAVRol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 12:44:41 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A81BB94;
        Sun, 22 Jan 2023 09:44:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674409479; x=1705945479;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vOiGmKUpYIpCa8sMlgq4Z+6cesss1H7IXCujIj4hJGo=;
  b=L0cNAErGnpcHHTh2tYdLEZPMiZPT+WdaWnPy1LmF+XF2+8SWBQqY0kYj
   bALF6dNrYIyf/Upn/ZUWx7otZNx7ii+pqQXJ/dwKxz7JV097oTPTZCTBd
   uc/GD6IER2AhCyFZzQjpozgdnJv8UtehVIaPjiYYjWwPhF2c3lxZMq10q
   Pmpowv1DUV3KgzVUQ4vo5u0s2+aG2Lhktm897oVxeOPU8xMPw01fezTTS
   Pju6wUvDht5BR8GWbG86zVMGuBNy6HSnKNzDnMsexhEVv3q7QFi/iu7w6
   wpeHV2COc3dNq+/G8/co5ieFnf2z73G3JCWpu8V3InIZSgmGK/6oqfM6M
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10598"; a="323608184"
X-IronPort-AV: E=Sophos;i="5.97,237,1669104000"; 
   d="scan'208";a="323608184"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2023 09:44:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10598"; a="729930189"
X-IronPort-AV: E=Sophos;i="5.97,237,1669104000"; 
   d="scan'208";a="729930189"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 22 Jan 2023 09:44:39 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 22 Jan 2023 09:44:38 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 22 Jan 2023 09:44:38 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 22 Jan 2023 09:44:38 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 22 Jan 2023 09:44:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B0qFh68ElKYv/rKEyF5mH+VdIN0v1fCiSerrUI1dKkYNF1zYUNX4tZ+7l/qgy/hIyiHfwQodIOCdONPDkfgqq3hpPew/GAgiDfAVg3hHJdT/oEoRWuD1UG14Oe5WMgqtqUkpqUHJN5hC+mdFORIsMwX5zTsKKNDew5YpQtHLapjsu1m6zjeDfN2cETISzJo9xIhM8trHgWvLo7i9LFLZE+P+9p3rY95kLPryUhLBZEPO3UjmX528pcC8z3C5fEJOxXJeQDUrJLUEhcRJHxluE/vKYjLA0L2uUaHt792odjGFc9ZHwTiStTX+CzxHIGVTZLP7czIa+stHs6/zmAAEkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vOiGmKUpYIpCa8sMlgq4Z+6cesss1H7IXCujIj4hJGo=;
 b=JyWZ/J1KBOaPKKEukM0UNbEAKNcLO9Gc8XM0z+Fe2Y5TXIuaovmN6qTbyPiZhW39iwOB5xFzVboDvXjQ8FWyN2hbQbB+tysmOBaz6WXS8vTV6XzYa5yyjEHVenO9FlhjHF+htvZV9FO6Dk4XeMFvzUHPU1Ib+NYbcCbCviCfRuq8M7n2ahfbGCfLK3SqKoPHi557vtFiuCJTAMBFYuyWIwcrDFZbPFXTmLz1G5NDNRM2/fB5mfH7LIwk2govCCw0ssoaBH8tl5dXNQj3q8RJLZF4Fyc10A53Bwl6QO2jXlieJJVagtkxjuC+G6B768ujjd/V6QZQnyEa3znJV22xuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5962.namprd11.prod.outlook.com (2603:10b6:208:371::18)
 by MN0PR11MB6086.namprd11.prod.outlook.com (2603:10b6:208:3ce::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27; Sun, 22 Jan
 2023 17:44:36 +0000
Received: from MN0PR11MB5962.namprd11.prod.outlook.com
 ([fe80::b9d1:78a:e878:90c4]) by MN0PR11MB5962.namprd11.prod.outlook.com
 ([fe80::b9d1:78a:e878:90c4%5]) with mapi id 15.20.6002.028; Sun, 22 Jan 2023
 17:44:35 +0000
From:   "D H, Siddaraju" <siddaraju.dh@intel.com>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        Daniel Vacek <neelx@redhat.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "Kolacinski, Karol" <karol.kolacinski@intel.com>,
        "Michalik, Michal" <michal.michalik@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH] ice/ptp: fix the PTP worker retrying
 indefinitely if the link went down
Thread-Topic: [Intel-wired-lan] [PATCH] ice/ptp: fix the PTP worker retrying
 indefinitely if the link went down
Thread-Index: AQHZKqP/DfkgVYUDCk2u4R2vGmANSK6qu+oA
Date:   Sun, 22 Jan 2023 17:44:35 +0000
Message-ID: <MN0PR11MB596276E45C799F69943010D99ACB9@MN0PR11MB5962.namprd11.prod.outlook.com>
References: <20230117181533.2350335-1-neelx@redhat.com>
 <2bdeb975-6d45-67bb-3017-f19df62fe7af@intel.com>
In-Reply-To: <2bdeb975-6d45-67bb-3017-f19df62fe7af@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5962:EE_|MN0PR11MB6086:EE_
x-ms-office365-filtering-correlation-id: 1833f323-58bb-4744-398f-08dafca053de
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JqILfzgtn4sSkOdLQ9rW6VOjraho+KgcAAaT6KG7CDxXL6hG4Xg+7nXhhUfyXN6tG12xNBMXQqemxiZHwyOrZh7YLteiXAaDOhyXeeOoZCAH6Gerk5d1isrfrlIP4giltGcQYzfnUvZZrY3bQp0la+1hp2IUf4IJhshoQWAoJ7l62e6xVuDz+IyxsigcXMezg4gd2ODQExBFotnvAlnDWC0IsOFtdLPiERXbjohi3AXBeUZuq2CRADx6THUfkdeZ5HDL/tSd+V43xNK6MgC+62lmbq4a8CeennNJS8A73htWatZlOSMn6EXhlHHkHK4uH3e8z3XbpUIh7RwuX3uDlr5bjQLR4A7ixp8CwzkV56ilWlkgjIrVklcjbOgzF1n5A6rtUj916NKH5IazFlA2l3tr9TsaL4EpyFCR9jC4lh4CpLBextAvhz/LuI1Elwg2fovvR5mYQAk1J7P91njKCjVTi2e3xWK6NxVK2jRzFjNC2TEu9kcApShNQkPtG8AbrAFt9N80ENL1ZoKTvztKwcb+DXexFRDY8upX6y5MEoWouSECHkNgLjj/yruCyXNA3S2I9cIACU0bg7n2rXuJjBnnrVn4Ai1VgwAubUWFxAR7wyrNp+t8t9xlCDKBbp48nwKlce6NEikQqiWdvvfS9cZHBGXagbjkrJ7FLd+LajoKxmWcoot3EXdN64FHv2wcse79lYvY1zxLgoLisD+bUXRv6Dq2xSB9A0MLPbFmPTA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5962.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(366004)(396003)(346002)(376002)(451199015)(52536014)(5660300002)(8936002)(4326008)(71200400001)(66476007)(8676002)(66446008)(66556008)(66946007)(64756008)(76116006)(6636002)(9686003)(38100700002)(122000001)(478600001)(54906003)(186003)(6506007)(26005)(110136005)(2906002)(7696005)(316002)(53546011)(83380400001)(82960400001)(41300700001)(38070700005)(86362001)(55016003)(921005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bzYxc2NOUFpjMG5QdjY3TVFxcVl5dDF6MUhpZ0dVWFlGRnk1WXRBek16aWsw?=
 =?utf-8?B?OTRPazZBWHJrNC80NkZNZkd4MGJxTXJjU3dJazREZXU1ODZKUGh3MUozME1z?=
 =?utf-8?B?U2ExUjJueDlUNGt5WTVHa25MOFN4VGhhNjZDQ0ZxYXpTUjkrZ3hmSzZ4TzNP?=
 =?utf-8?B?UHVqbGQyMHVUbjVDMlZxR0VHQWZOMWFQaTlMMHpoMk4vNEFsUUtndW5Bb282?=
 =?utf-8?B?Z3kwTmZVYXFCalg2cStmS0F5SkVmbEMrZEFXem14ajhtdkErQ0pSVkJVMzJk?=
 =?utf-8?B?c2JLc0FydTQrSlYrMW00L2dkUStibnlQR2xBRXFpR21mWUlGZURESi83Y3NP?=
 =?utf-8?B?SEJ2enpOVG8rM080bnQyS29iRmIyU1c5RHFVcDBsd3FNNXZRbExsSVJabnNr?=
 =?utf-8?B?VnVUMkhGZmRWSFlNMGRuaUd5YnJjNGVsWFlPejFjU0lTYTRWS0tJS1hKZDkv?=
 =?utf-8?B?bzdEKzkyaFNITmJoU3VaS3B0ak9TU1FtcFZ1SXVubVdIMStFKzJ1TUNDdEpT?=
 =?utf-8?B?T3RWa3U4Vmk1blVyZ2JjK2RhN205UkFkMTdjSU5kVTltU2h2R0g1Y0lqOXFo?=
 =?utf-8?B?VUowUHNBdWwzWDBJWUY2RnVkQktPRDNSS01wQTg5UklUaGs3WmhGUEJQWk9u?=
 =?utf-8?B?WVJZNnZFSlJPSUNlVmxJcHdIaFZiN0JYSWFuR3dWOTczUlBLdWdXWUJrbEZU?=
 =?utf-8?B?ODIxZlo2c2RZcGlHQ3UwbHZvS3hrZm1hcnRoK0M0L2h0ZkE5SkpyTzBoeWlS?=
 =?utf-8?B?Y1RkbzduOURoVDNKbmVUaEZpM2xFVjM1VFM2ZmhlSHBJc0dCM3A2QTdxd096?=
 =?utf-8?B?SG5POE9pQ2dmNk14RklHNU1TWFp0eG5NTjR1ZWZieDMvNGVDcWpXUEVoWThH?=
 =?utf-8?B?RHdVcGpJTHdxUGhwazJIVFFlZFhqdStibXdMTVNQZVZ0Z05iSWZFMmF1SStG?=
 =?utf-8?B?aHg5ODJrK3B0NXRGY1g3dTY5WUJTQTUrRkNzZE93cWd1T3RpY1BXNnJic2Z2?=
 =?utf-8?B?Z0JQRHcxWGx6VzhiSEpqeU14cWljNWZCcjFxRjlVSDMvdzRvdjhLaVpFdFo2?=
 =?utf-8?B?TjBEbE8yRWpZSkw1T3JUY2VlN0Z4ZCtzZGExOVZ0VXFETlRVQ1paMFVYOTZj?=
 =?utf-8?B?ZUtiWVhsSk9ubFpVMW5UbzZrQXpObDFTMENHbERxd3A2bWFIemxNMkJtZXdw?=
 =?utf-8?B?M0o3ZU85bVh5OWxCd2l6bkY1WmQyc2xpWDlsS3k1b0JkWmRjNkt6dVc4eFFK?=
 =?utf-8?B?MFNEQTNrUEhDSlFvVVI5WVM1UDdOMkx4WS9Ea1EvUjY5eXV5WDFtc2d2ajYz?=
 =?utf-8?B?R1h4Tll1TzBoU2JHZHJCL0dVQ1Fxb2c2TGhYZmhZdWZHWHpYUWY1YVlSbitt?=
 =?utf-8?B?QUFjcHhPKzdlSW9BSEQrTktObHRoSGVGZlJldEJTNmFtM1lhdVFDS3E4UlB4?=
 =?utf-8?B?d0ZFeE9FOElUZ2xueDRITjhsUDB3cFV6T1NLaHVKNWdkU2dVYmtYSWRrWWxZ?=
 =?utf-8?B?RkNxM09Hb1FlU1pyWnNKNWRxYnVwakJ2RVpicExuYm1VV2ZWSWMzMTlXdUY5?=
 =?utf-8?B?bTAzVTNrOTZWUGhlWXIwc0xtUWhzR1N3QVhyNFFIeHJYekFndG1nejZZQUJj?=
 =?utf-8?B?bGFIT1BpSFNUejlNVHBzTWl4UlgzL1p0V1NDKzBxbEdSTFlIL3NvQ2JVSkdI?=
 =?utf-8?B?RFJWb2daRTE5a1ZZeGlrSEIwU3U3L1NGUEZOcUJaT2lwcjdvZ1k1Q2tLUE5h?=
 =?utf-8?B?VGdUU29MaE9jL0xmdFZUTDBDdjdDb3M0MEdMZnR5VVB1NTdVR0REZTNKd3M2?=
 =?utf-8?B?SGw4WFF3Y2s5S1R5emRiN1B0MnNJZXNrSG9JYzV1b1BVUmtkS003cEdHWjJk?=
 =?utf-8?B?NzlDS1lONXo4N1puR1NibHBZZlZDM2trR0drazM3Q3B1T1RhSVBjSjN3VkJG?=
 =?utf-8?B?MWZYaGpaVUp6OXplRUNsUEthS0lnMUh1ZXZXdk04Q1NiTEFjT3BsdTZXVXhm?=
 =?utf-8?B?dXF1L29KaEVTcDZpalBvTVZINm4wcXprdTdJaGNacmZzaU8vcEJFTU5qYVJV?=
 =?utf-8?B?N1BBYUg4NFN4QmFzcEFFSk5GR1ZpazVXTnZnYVlrUi9QL01BZHU0blhVcm5C?=
 =?utf-8?Q?OPLTPUdB80JcHdeTbhSMQ+l5v?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5962.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1833f323-58bb-4744-398f-08dafca053de
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2023 17:44:35.8074
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rwyh3/Ubx3a/R4ejrF6pz1P9Hvkbh0yOlIe4CiCAWmhADN1x8rMac5bMXCOE+Orp4XRJRe2GmKgIaetdmZjTzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6086
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

WWVzIEpha2UsIElDRSBkcml2ZXIgcmVpbml0aWFsaXplcyBQVFAgdGltZXJzIG9uIGxpbmsgVVAg
KGVzcGVjaWFsbHkgZm9yIEU4MngpLg0KaWNlX3B0cC5jLT4gaWNlX3B0cF9saW5rX2NoYW5nZS0+
IGljZV9wdHBfcG9ydF9waHlfcmVzdGFydC0+IGljZV9zdGFydF9waHlfdGltZXJfZTgyMg0KDQot
U2lkZGFyYWp1IEQgSA0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogS2VsbGVy
LCBKYWNvYiBFIDxqYWNvYi5lLmtlbGxlckBpbnRlbC5jb20+IA0KU2VudDogV2VkbmVzZGF5LCBK
YW51YXJ5IDE4LCAyMDIzIDEyOjE2IEFNDQpUbzogRGFuaWVsIFZhY2VrIDxuZWVseEByZWRoYXQu
Y29tPjsgQnJhbmRlYnVyZywgSmVzc2UgPGplc3NlLmJyYW5kZWJ1cmdAaW50ZWwuY29tPjsgTmd1
eWVuLCBBbnRob255IEwgPGFudGhvbnkubC5uZ3V5ZW5AaW50ZWwuY29tPjsgRGF2aWQgUy4gTWls
bGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgRXJpYyBEdW1hemV0IDxlZHVtYXpldEBnb29nbGUu
Y29tPjsgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47IFBhb2xvIEFiZW5pIDxwYWJl
bmlAcmVkaGF0LmNvbT47IFJpY2hhcmQgQ29jaHJhbiA8cmljaGFyZGNvY2hyYW5AZ21haWwuY29t
PjsgS29sYWNpbnNraSwgS2Fyb2wgPGthcm9sLmtvbGFjaW5za2lAaW50ZWwuY29tPjsgRCBILCBT
aWRkYXJhanUgPHNpZGRhcmFqdS5kaEBpbnRlbC5jb20+OyBNaWNoYWxpaywgTWljaGFsIDxtaWNo
YWwubWljaGFsaWtAaW50ZWwuY29tPg0KQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGludGVs
LXdpcmVkLWxhbkBsaXN0cy5vc3Vvc2wub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3Jn
DQpTdWJqZWN0OiBSZTogW0ludGVsLXdpcmVkLWxhbl0gW1BBVENIXSBpY2UvcHRwOiBmaXggdGhl
IFBUUCB3b3JrZXIgcmV0cnlpbmcgaW5kZWZpbml0ZWx5IGlmIHRoZSBsaW5rIHdlbnQgZG93bg0K
DQoNCg0KT24gMS8xNy8yMDIzIDEwOjE1IEFNLCBEYW5pZWwgVmFjZWsgd3JvdGU6DQo+IFdoZW4g
dGhlIGxpbmsgZ29lcyBkb3duIHRoZSBpY2VfcHRwX3R4X3RzdGFtcF93b3JrKCkgbWF5IGxvb3Ag
Zm9yZXZlciANCj4gdHJ5aW5nIHRvIHByb2Nlc3MgdGhlIHBhY2tldHMuIEluIHRoaXMgY2FzZSBp
dCBtYWtlcyBzZW5zZSB0byBqdXN0IGRyb3AgdGhlbS4NCj4gDQoNCkhpLA0KDQpEbyB5b3UgaGF2
ZSBzb21lIG1vcmUgZGV0YWlscyBvbiB3aGF0IHNpdHVhdGlvbiBjYXVzZWQgdGhpcyBzdGF0ZT8g
T3IgaXMgdGhpcyBqdXN0IGJhc2VkIG9uIGNvZGUgcmV2aWV3Pw0KDQpJdCB3b24ndCBsb29wIGZv
cmV2ZXIgYmVjYXVzZSBpZiBsaW5rIGlzIGRvd24gZm9yIG1vcmUgdGhhbiAyIHNlY29uZHMgd2Un
bGwgZGlzY2FyZCB0aGUgb2xkIHRpbWVzdGFtcHMgd2hpY2ggd2UgYXNzdW1lIGFyZSBub3QgZ29p
bmcgdG8gYXJyaXZlLg0KDQpUaGUgdHJvdWJsZSBpcyB0aGF0IGlmIGEgdGltZXN0YW1wICpkb2Vz
KiBhcnJpdmUgbGF0ZSwgd2UgbmVlZCB0byBlbnN1cmUgdGhhdCB3ZSBuZXZlciBhc3NpZ24gdGhl
IGNhcHR1cmVkIHRpbWUgdG8gdGhlIHdyb25nIHBhY2tldCwgYW5kIHRoYXQgZm9yDQpFODIyIGRl
dmljZXMgd2UgYWx3YXlzIHJlYWQgdGhlIGNvcnJlY3QgbnVtYmVyIG9mIHRpbWVzdGFtcHMgKG90
aGVyd2lzZSB3ZSBjYW4gZ2V0IHRoZSBsb2dpYyBmb3IgdGltZXN0YW1wIGludGVycnVwdCBnZW5l
cmF0aW9uIGJyb2tlbikuDQoNCkNvbnNpZGVyIGZvciBleGFtcGxlIHRoaXMgZmxvdyBmb3IgZTgx
MDoNCg0KMSkgYSB0eCBwYWNrZXQgd2l0aCBhIHRpbWVzdGFtcCByZXF1ZXN0IGlzIHNjaGVkdWxl
ZCB0byBodw0KMikgdGhlIHBhY2tldCBiZWdpbnMgYmVpbmcgdHJhbnNtaXR0ZWQNCjMpIGxpbmsg
Z29lcyBkb3duDQo0KSBpbnRlcnJ1cHQgdHJpZ2dlcnMsIGljZV9wdHBfdHhfdHN0YW1wIGlzIHJ1
bg0KNSkgbGluayBpcyBkb3duLCBzbyB3ZSBza2lwIHJlYWRpbmcgdGhpcyB0aW1lc3RhbXAuIFNp
bmNlIHdlIGRvbid0IHJlYWQgdGhlIHRpbWVzdGFtcCwgd2UganVzdCBkaXNjYXJkIHRoZSBza2Ig
YW5kIHdlIGRvbid0IHVwZGF0ZSB0aGUgY2FjaGVkIHR4IHRpbWVzdGFtcCB2YWx1ZQ0KNikgbGlu
ayBnb2VzIHVwDQo3KSAyIHR4IHBhY2tldHMgd2l0aCBhIHRpbWVzdGFtcCByZXF1ZXN0IGFyZSBz
ZW50IGFuZCBvbmUgb2YgdGhlbSBpcyBvbiB0aGUgc2FtZSBpbmRleCBhcyB0aGUgcGFja2V0IGlu
ICgxKQ0KOCkgdGhlIG90aGVyIHR4IHBhY2tldCBjb21wbGV0ZXMgYW5kIHdlIGdldCBhbiBpbnRl
cnJ1cHQNCjkpIHRoZSBsb29wIHJlYWRzIGJvdGggdGltZXN0YW1wcy4gU2luY2UgdGhlIHR4IHBh
Y2tldCBpbiBzbG90ICgxKSBkb2Vzbid0IG1hdGNoIGl0cyBjYWNoZWQgdmFsdWUgaXQgbG9va3Mg
Im5ldyIgc28gdGhlIGZ1bmN0aW9uIHJlcG9ydHMgdGhlIG9sZCB0aW1lc3RhbXAgdG8gdGhlIHdy
b25nIHBhY2tldC4NCg0KQ29uc2lkZXIgdGhpcyBmbG93IGZvciBlODIyOg0KDQoxKSAyIHR4IHBh
Y2tldHMgd2l0aCBhIHRpbWVzdGFtcCByZXF1ZXN0IGFyZSBzY2hlZHVsZWQgdG8gaHcNCjIpIHRo
ZSBwYWNrZXRzIGJlZ2luIGJlaW5nIHRyYW5zbWl0dGVkDQozKSBsaW5rIGdvZXMgZG93bg0KNCkg
YW4gaW50ZXJydXB0IGZvciB0aGUgVHggdGltZXN0YW1wIGlzIHRyaWdnZXJlZCwgYnV0IHdlIGRv
bid0IHJlYWQgdGhlIHRpbWVzdGFtcHMgYmVjYXVzZSB3ZSBoYXZlIGxpbmsgZG93biBhbmQgd2Ug
c2tpcHBlZCB0aGUgdHNfcmVhZC4NCjUpIHRoZSBpbnRlcm5hbCBlODIyIGhhcmR3YXJlIGNvdW50
ZXIgaXMgbm90IGRlY3JlbWVudGVkIGR1ZSB0byBubyByZWFkcw0KNikgbm8gbW9yZSB0aW1lc3Rh
bXAgaW50ZXJydXB0cyB3aWxsIGJlIHRyaWdnZXJlZCBieSBoYXJkd2FyZSB1bnRpbCB3ZSByZWFk
IHRoZSBhcHByb3ByaWF0ZSBudW1iZXIgb2YgdGltZXN0YW1wcw0KDQpJIGFtIG5vdCBzdXJlIGlm
IGxpbmsgZ29pbmcgdXAgd2lsbCBwcm9wZXJseSByZXNldCBhbmQgcmUtaW5pdGlhbGl6ZSB0aGUg
VHggdGltZXN0YW1wIGJsb2NrIGJ1dCBJIHN1c3BlY3QgaXQgZG9lcyBub3QuIEBLYXJvbCwgQFNp
ZGRhcmFqdSwgQE1pY2hhbCwgZG8geW91IHJlY2FsbCBtb3JlIGRldGFpbHMgb24gdGhpcz8NCg0K
SSB1bmRlcnN0YW5kIHRoZSBkZXNpcmUgdG8gYXZvaWQgcG9sbGluZyB3aGVuIHVubmVjZXNzYXJ5
LCBidXQgSSBhbSB3b3JyaWVkIGJlY2F1c2UgdGhlIGhhcmR3YXJlIGFuZCBmaXJtd2FyZSBpbnRl
cmFjdGlvbnMgaGVyZSBhcmUgcHJldHR5IGNvbXBsZXggYW5kIGl0cyBlYXN5IHRvIGdldCB0aGlz
IHdyb25nLiAoc2VlOiBhbGwgb2YgdGhlIHByZXZpb3VzIHBhdGNoZXMgYW5kIGJ1ZyBmaXhlcyB3
ZSd2ZSBiZWVuIHdvcmtpbmcgb24uLi4gd2UgZ290IHRoaXMgd3JvbmcgYSBMT1QNCmFscmVhZHku
Li4pDQoNCldpdGhvdXQgYSBtb3JlIGNvbmNyZXRlIGV4cGxhbmF0aW9uIG9mIHdoYXQgdGhpcyBm
aXhlcyBJJ20gd29ycmllZCBhYm91dCB0aGlzIGNoYW5nZSA6KA0KDQpBdCBhIG1pbmltdW0gSSB0
aGluayBJIHdvdWxkIG9ubHkgc2V0IGRyb3BfdHMgYnV0IG5vdCBub3QgZ290byBza2lwX3RzX3Jl
YWQuDQoNClRoYXQgd2F5IGlmIHdlIGhhcHBlbiB0byBoYXZlIGEgcmVhZHkgdGltZXN0YW1wIChm
b3IgRTgyMikgd2UnbGwgc3RpbGwgcmVhZCBpdCBhbmQgYXZvaWQgdGhlIG1pc2NvdW50aW5nIGZy
b20gbm90IHJlYWRpbmcgYSBjb21wbGV0ZWQgdGltZXN0YW1wLg0KDQpUaGlzIGFsc28gZW5zdXJl
cyB0aGF0IG9uIGU4MTAgdGhlIGNhY2hlZCB0aW1lc3RhbXAgdmFsdWUgaXMgdXBkYXRlZCBhbmQg
dGhhdCB3ZSBhdm9pZCB0aGUgb3RoZXIgc2l0dWF0aW9uLg0KDQpJJ2Qgc3RpbGwgcHJlZmVyIGlm
IHlvdSBoYXZlIGEgYnVnIHJlcG9ydCBvciBtb3JlIGRldGFpbHMgb24gdGhlIGZhaWx1cmUgY2Fz
ZS4gSSBiZWxpZXZlIGV2ZW4gaWYgd2UgcG9sbCBpdCBzaG91bGQgYmUgbm8gbW9yZSB0aGFuIDIg
c2Vjb25kcyBmb3IgYW4gb2xkIHRpbWVzdGFtcCB0aGF0IG5ldmVyIGdvdCBzZW50IHRvIGJlIGRp
c2NhcmRlZC4NCg0KPiBTaWduZWQtb2ZmLWJ5OiBEYW5pZWwgVmFjZWsgPG5lZWx4QHJlZGhhdC5j
b20+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9wdHAuYyB8
IDkgKysrKysrKysrDQo+ICAxIGZpbGUgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspDQo+IA0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9wdHAuYyANCj4g
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX3B0cC5jDQo+IGluZGV4IGQ2MzE2
MWQ3M2ViMTYuLmMzMTMxNzdiYTY2NzYgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2ludGVsL2ljZS9pY2VfcHRwLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50
ZWwvaWNlL2ljZV9wdHAuYw0KPiBAQCAtNjgwLDYgKzY4MCw3IEBAIHN0YXRpYyBib29sIGljZV9w
dHBfdHhfdHN0YW1wKHN0cnVjdCBpY2VfcHRwX3R4ICp0eCkNCj4gIAlzdHJ1Y3QgaWNlX3BmICpw
ZjsNCj4gIAlzdHJ1Y3QgaWNlX2h3ICpodzsNCj4gIAl1NjQgdHN0YW1wX3JlYWR5Ow0KPiArCWJv
b2wgbGlua191cDsNCj4gIAlpbnQgZXJyOw0KPiAgCXU4IGlkeDsNCj4gIA0KPiBAQCAtNjk1LDYg
KzY5Niw4IEBAIHN0YXRpYyBib29sIGljZV9wdHBfdHhfdHN0YW1wKHN0cnVjdCBpY2VfcHRwX3R4
ICp0eCkNCj4gIAlpZiAoZXJyKQ0KPiAgCQlyZXR1cm4gZmFsc2U7DQo+ICANCj4gKwlsaW5rX3Vw
ID0gaHctPnBvcnRfaW5mby0+cGh5LmxpbmtfaW5mby5saW5rX2luZm8gJiBJQ0VfQVFfTElOS19V
UDsNCj4gKw0KPiAgCWZvcl9lYWNoX3NldF9iaXQoaWR4LCB0eC0+aW5fdXNlLCB0eC0+bGVuKSB7
DQo+ICAJCXN0cnVjdCBza2Jfc2hhcmVkX2h3dHN0YW1wcyBzaGh3dHN0YW1wcyA9IHt9Ow0KPiAg
CQl1OCBwaHlfaWR4ID0gaWR4ICsgdHgtPm9mZnNldDsNCj4gQEAgLTcwMiw2ICs3MDUsMTIgQEAg
c3RhdGljIGJvb2wgaWNlX3B0cF90eF90c3RhbXAoc3RydWN0IGljZV9wdHBfdHggKnR4KQ0KPiAg
CQlib29sIGRyb3BfdHMgPSBmYWxzZTsNCj4gIAkJc3RydWN0IHNrX2J1ZmYgKnNrYjsNCj4gIA0K
PiArCQkvKiBEcm9wIHBhY2tldHMgaWYgdGhlIGxpbmsgd2VudCBkb3duICovDQo+ICsJCWlmICgh
bGlua191cCkgew0KPiArCQkJZHJvcF90cyA9IHRydWU7DQo+ICsJCQlnb3RvIHNraXBfdHNfcmVh
ZDsNCj4gKwkJfQ0KPiArDQo+ICAJCS8qIERyb3AgcGFja2V0cyB3aGljaCBoYXZlIHdhaXRlZCBm
b3IgbW9yZSB0aGFuIDIgc2Vjb25kcyAqLw0KPiAgCQlpZiAodGltZV9pc19iZWZvcmVfamlmZmll
cyh0eC0+dHN0YW1wc1tpZHhdLnN0YXJ0ICsgMiAqIEhaKSkgew0KPiAgCQkJZHJvcF90cyA9IHRy
dWU7DQo=
