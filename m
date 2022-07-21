Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6787357C63A
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 10:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbiGUI0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 04:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232118AbiGUI0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 04:26:40 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C161AF2F;
        Thu, 21 Jul 2022 01:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658392000; x=1689928000;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tvUAJN/zq5E+W7LPG3gZ+rqzaKyNxmfHDfyyml7I/rg=;
  b=L4G+RWAsBlt1LglVg1ob3QfPbPnvhMMd10ZLCyLT3V4MlR2w4Pmm49QX
   jI+MGvAneokCFvI7g+0IOY4NG1tZTStGeVdK1F0lUYhCcWfCh9k/ykKGO
   E7Q+QV5VpOtfSX9MaQGmhXCC6olr5AxDV5ZX6uGJk3kK8OO0+0/EDm+lB
   kHHKJZQT32YnQs3BZ286yI5EIWxaaLe1rvzE0ra9VR077EIVzpTKa3Gmb
   pvur8modgOxRhcBpaHoDAcfCPg5fqU5yg+evlMGKoQb87E4mBk2NVbI8B
   ZpnQ2BZqVNGIQFulbbUHeoJBiZ7nHXrCNnU6T4yRKpQZLkEv87ScPaRYV
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10414"; a="312695665"
X-IronPort-AV: E=Sophos;i="5.92,289,1650956400"; 
   d="scan'208";a="312695665"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 01:26:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,289,1650956400"; 
   d="scan'208";a="701189182"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 21 Jul 2022 01:26:39 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 21 Jul 2022 01:26:39 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 21 Jul 2022 01:26:39 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 21 Jul 2022 01:26:39 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 21 Jul 2022 01:26:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bYe85cYxWRD5PbGfUvUJkRJzPjZ3KthU1mJjfnu1Mgq5JZ2CFrzUsiXYDs5/KWOwjXGj09S2E8Hw76qmUxl0Xoq4Sq3RP1ZH0tPNEIytTl+ITTGWgI6jj2b3yMeOnp0czBOr614kaCe9H+jDFfgMqu13txmgcpePpvsTAOJKTqAReibd+0PfI/FVZARei1kMhG7fVnB5SMZPs/NpIEWQAWRrXg+wiyA94nk9hmfbbZYguOvGyYchH2n10KyeCQKlH28EloumWCoDNxyooQuW9uTHvHOxxpTx5IcRMCU0PNjpQvFF414wmxiSuItnvICKHxPUILGk5lT9wtT+SdB8+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tvUAJN/zq5E+W7LPG3gZ+rqzaKyNxmfHDfyyml7I/rg=;
 b=EDJNJYu2goZh4G8kDyn4XQFqcQLGfsNi16LCOFBDzSBSowLa+yBdV7Rs9CigVk3HBgaEe9T+3g6yzvQz204R0xksVwe4UWeVQzDcjOWsHVqP/ahpm1NETaYLiid0C9MzxRBhZ7Siuun2MbIhNbYEwwHLFpJ63kU7jukKr4Au1VphpSH3znjqMWFP061mpRjDbZp7eQOe0CaygIacwiJlOq2SpZhIRXr4S4XiABjuodw4r0oEPmEr9Ex9bvvYhnKebK6FRGsg+BFRNdD36hUjJazCOolDozCKuYA4B6Gg3bq9PpCCKHSRdsg0tveDgXwPE+Vrjr/YobAQ8vX2a8aXKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN2PR11MB3856.namprd11.prod.outlook.com (2603:10b6:208:ef::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Thu, 21 Jul
 2022 08:26:37 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5438.023; Thu, 21 Jul 2022
 08:26:37 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Yishai Hadas <yishaih@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: RE: [PATCH V2 vfio 00/11] Add device DMA logging support for mlx5
 driver
Thread-Topic: [PATCH V2 vfio 00/11] Add device DMA logging support for mlx5
 driver
Thread-Index: AQHYl1nHkgN+MuOKWkK0dY1M0rnAFq2IiDOw
Date:   Thu, 21 Jul 2022 08:26:36 +0000
Message-ID: <BN9PR11MB5276425A5FC37EEA1324A4318C919@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
In-Reply-To: <20220714081251.240584-1-yishaih@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e5b0653a-579a-4eab-31cb-08da6af2ba7c
x-ms-traffictypediagnostic: MN2PR11MB3856:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f0ApIiVkzjxsId/NlBr/8HzT/MC3SBo+jUJ/rZ6EOEJvdWWx1McGjHiKxQGtJsB9JFqXkvwniuhBnd6xfn2Ox21jlwjkAe3UBw38d4ulF0gweSrecKlshG98amRUmOB71UP+ALWM1Vv3OzJgKcseGjacpWEDDVVJRzmQtOdWXMsuZ2MJ1ULe5JJ4f+4QgveUCjFDtcX+6Sj7ps7Lpdatq1bVNtCHd7XCTO2ZBd6VSwTkklNbZfDa4MbVvsndMYcIRPSKDN6mzJcw4uCimqqEsQ9c1amhCnAYxR919FYC8QMAxLNoR/OeEzoSP4vpJ3EqXDLKlZx3hPOg+3LOOet5Kv9KJjVDOHkfKpbwlMqjdJaom+E3mxPR0Hmm0t8yTKM4Fp9TxgOwveOTmJ8rFZsArFgpm+dbGXYtKwVuOzCVczZQpfkwlWkX6VKLu1Yu2nBBoXWYjjTraWqfG8TpYedilHW8WyfpOW0CR9WPGGCM504/W6vFUHV0s08FUUF3mSb8N5GvMGLvYZuJv9p0g+0GQzDcwgyxW4wGUWH+EuL9Gzrf5OVJK246e/K55CgkOMPyuFhFHVqjmpqMRC/X7tvI+ppeQUGuCQDCVtNIviHobKnXkCEVbxu2jhFAZ/QhvAunFKfBfXgOtk6xj3eTW/FItEB2DQXl4DYhxOx39mWJCz27g+LsZbYrj5UGXHMJH+cqZ0cj5w38GlryJklvWWg7nxO21ebqj3DkeR42vbDQhP1dVOsXVJ3mANQof0zhtviuktebvgHYHT+j1HFBCD7s/U7ROx2EWX6Q4SgXCGt8p2s4HEv1jvTwCgre2PTtkfjT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(396003)(366004)(136003)(376002)(2906002)(71200400001)(38100700002)(7696005)(6506007)(122000001)(76116006)(66446008)(66556008)(86362001)(33656002)(26005)(66476007)(64756008)(55016003)(66946007)(8676002)(4326008)(9686003)(38070700005)(8936002)(5660300002)(110136005)(52536014)(316002)(54906003)(41300700001)(478600001)(7416002)(82960400001)(4744005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7cNTthFQbUKvDlO/oi90LN1RltsstatPh8U9ZGeK1fCKcmTHnvpWcMXrSuDS?=
 =?us-ascii?Q?9lO/Atxpde3EmxvCkh2ec0hKLj2aqc4Ut/A56jwNNaK5HlfcOggftnGra3VC?=
 =?us-ascii?Q?Vl9cHSdpHnyB+7mn2UxKIpEUaDbGEWDGP5Y1I0J0ydgnUPCC53kGMOiDGsCq?=
 =?us-ascii?Q?/eRkzos0j7Ofx4B45YNMqMecyioBrol4HioRZrKbbTp7JwWFSti7E4cKZylA?=
 =?us-ascii?Q?Em1aht2k5I2uX8KzNZ1FdN129TxwYsfJq2ymPy6wAcariD/Ntc82ndbaHZby?=
 =?us-ascii?Q?AQr5UxBjrq3e4elS7ochwsBBOcmtGRgsZBhrQsqe6bU+8o0la0zGZwhIDHoH?=
 =?us-ascii?Q?RYq14CLUSb9WszviX8Kpk4UDSflZ+zT6DYeimsoTS2ymQYlaAFzux6ukPFWU?=
 =?us-ascii?Q?mgP1s1upCR5Do9YO7Axel5I8OM5J2s2RKzJD09No+SEaZCJl9iVeLUk+ADkt?=
 =?us-ascii?Q?VRI8jHlbAXeWbskNxxrDtcFK0dVkUSmHWVfFQMhl83L+eHcNSNRics9PbDyl?=
 =?us-ascii?Q?+yS5PNFTDLGwnRcsCxWA1KYe1XFfY/MwUszIpfEAbAPrrqZSDYJmb8Re0Trs?=
 =?us-ascii?Q?mDVOVmZfpTj342XICuKf5p1gQhhSs/Xy18dV4sp1RbgpxBwfH33hy9mCRqPH?=
 =?us-ascii?Q?iuilvR2vMv7zDVpAuPc2huPvq4WCYlYb5VexsxCLzJIWRMMTVhquS+bnpST9?=
 =?us-ascii?Q?JQjZMNG7ZucdIXyJRG5zrm+m1C9RSKQcwYNVHFhU5t80ScND2PTApGgoTwAx?=
 =?us-ascii?Q?+LviKjd3F8JdDHUnD6pMa3LJAz3xh+Q13XAUFBUpF1pqWbQl4QhHpYHW+c7O?=
 =?us-ascii?Q?3HdPCpBXaxrBAxunDJD1BidnONHnyWWejoRh8ilAxqSOc688cd3lP+vtVd88?=
 =?us-ascii?Q?nvYFR/WniPCnclXomXzajSNoQ8dGp4KixGtce9Bzca+LGucIKSI1F0FCf/Hb?=
 =?us-ascii?Q?BiU32ElxVnyaDJpCaST9BRTcgGFPXC7ToUCfKooJEyp7wUN8k6r7NQdkOGVt?=
 =?us-ascii?Q?iAnobWApSgU56ZBya7xnJlowzEK37DmglUOJuZsP2pkIuG83lYi+QnjciBle?=
 =?us-ascii?Q?4acjnWyppvyfrInnQP//oVpKQYSoBjzvVeyJFthnh70dU8/VPrsIVjm/UKfh?=
 =?us-ascii?Q?25OeXSEU/93CypciWdPqoBGiCGTpT92ZEYfpz0EAI0aB2j3U7xWkoTYLaENP?=
 =?us-ascii?Q?lIOXx0DrjdupVim/2TYVIj9K0k2tvPbCXvAa0/m/RzK5YRq0X+3Tkgt1x7a7?=
 =?us-ascii?Q?i3dlbSMzyymHduoXlQrOFv2pWzKCdSU4hOUGv/TkRozK5W1FC7FzrW1fsBLa?=
 =?us-ascii?Q?lP96uSOkfd5LI+6rLGDeAJWazwbaiee+PlpfTHev4tcbVWK21bJXp9+iJvoj?=
 =?us-ascii?Q?WSpZYNb+sLEhJWS4kVZkks/X7M+jhx7D5ZCn7q7xHJjygStKtLPDwOhHfHXv?=
 =?us-ascii?Q?u5u03gQHol8bxRV5TQXhN4eQxygvY/MH69RkNKd+fHHBqxSzCqgZbt3+WMLL?=
 =?us-ascii?Q?5gL+fzGXd4C8B4uXgSZwn12tQgCX1Nqu64DS1mbjgo2iLUhgkLziKg8ct/bq?=
 =?us-ascii?Q?QJsNKHBaiCp1cNVz42v16eve3Yd77WqOYZq/jjUH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5b0653a-579a-4eab-31cb-08da6af2ba7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 08:26:36.9365
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YNqxtHtiA4PTWAoIj8TWJsfLvNAls8dOhtiYmnIoXdZ4gs4KgBJiFKBKX4W3RzZFO+0BdAWtgbrvqZ2ZQEj2NQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3856
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Yishai Hadas <yishaih@nvidia.com>
> Sent: Thursday, July 14, 2022 4:13 PM
>=20
> It abstracts how an IOVA range is represented in a bitmap that is
> granulated by a given page_size. So it translates all the lifting of
> dealing with user pointers into its corresponding kernel addresses
> backing said user memory into doing finally the bitmap ops to change
> various bits.
>=20

Don't quite understand the last sentence...
