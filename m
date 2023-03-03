Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7396E6A9D04
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 18:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbjCCRTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 12:19:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbjCCRTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 12:19:21 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C9432E65;
        Fri,  3 Mar 2023 09:19:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677863959; x=1709399959;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rfWg8EBZeYQlit+nTZqVzypIT0/XNIwZbJmgev2Lay0=;
  b=VImm+up9YpSVsLiJDBh/XWbcT7cVIaCLcfEOgQ8Ks/6NgZ+pskra65Am
   jn73360/TjYiTrTt/erfg59mE+ZfTEL/GuimwU/yGrmTlPLkTIvxwHsk+
   Q0Z6sWgD4PCDzxxaT47e0mEsUdJNP6abcrOigCX2vZ7EDoUnNNeUkfCZU
   f76NJB/DEgxJ3SscZ32Nst+G/aGoszfeBWPNLiz7N5tgC8MiRQrlaXiG7
   uQ4lTf1G4mDrov8WitwRAcUCQheaofqGZtj6DX0syV0FtglPfwHBxden4
   xDGfxdPLEeOqJR1k/8qpWlp2hotN5SSGDspXPcadmN2sRDV1vwfjpnaAq
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="397685639"
X-IronPort-AV: E=Sophos;i="5.98,231,1673942400"; 
   d="scan'208";a="397685639"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2023 09:19:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="677713875"
X-IronPort-AV: E=Sophos;i="5.98,231,1673942400"; 
   d="scan'208";a="677713875"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 03 Mar 2023 09:19:19 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 3 Mar 2023 09:19:19 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 3 Mar 2023 09:19:19 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 3 Mar 2023 09:19:19 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 3 Mar 2023 09:19:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SrGDCJNIPY2oKDA1Vp5UYDRVNuV0K5unpbepnlxYFkgdAavwi0h/eJ6Wx5pw1D/DT44hgy9lzqQjfWwESkSNBAaMPFiFeqK7CYTksVaN6/vXgnx2n6LLu378lDXsSOxIY7RWxcw/igfkWCY+lRtn9NVVOOL6QRaUnuRtA0ps7EjZa4nZ3hUDXsTcZjYnqFi/mHmMJn33A4gs3/PJpj4iKSIrV5JTeDSLaLG/JZsZ5d0359ikmuHhBA5RV8lXhfmxLfYpamxaxQ2AXDTwSMHw/NKAfPHLqEzLGAEuQ+v2fYhMScpR0BCWj+0tfk5ly7+Qr1ApVduGl23wSwbO/HrobA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rfWg8EBZeYQlit+nTZqVzypIT0/XNIwZbJmgev2Lay0=;
 b=Rk5HSX1h8/mgJWGhtPjiRslu2ZD8W6Ejk6JT/BkFxQ203hKA1DUTFA8juikCDM3XQaw+qKqPkbY++nhfvI8HHbh/RCmvwuEDKdVic+s3I6I802sUtJ5oEMt850Bvafu/yFaYZ51Llf8uFl2IXEVZD+Kz9AsQsuZmGFtxCoHnvhY3GUEHhjjL8ps7bqLy0meKk9gZK9G7j6ha1zoj2Llu7pdkm48T5EE3TLXV6YT75yOdm6u5R/Rjz91DOaiqGyMJqfa8RnwWuWbPRoeHZbv+SHfZJExoSOJPgV5e4RwcJNDxELrjUiOwT3o9koRE+4b4nkf4Im6ht5/fmZSCcFSVUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB4045.namprd11.prod.outlook.com (2603:10b6:208:135::27)
 by IA0PR11MB7883.namprd11.prod.outlook.com (2603:10b6:208:3de::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.22; Fri, 3 Mar
 2023 17:19:15 +0000
Received: from MN2PR11MB4045.namprd11.prod.outlook.com
 ([fe80::6b67:1c73:161e:9444]) by MN2PR11MB4045.namprd11.prod.outlook.com
 ([fe80::6b67:1c73:161e:9444%7]) with mapi id 15.20.6156.018; Fri, 3 Mar 2023
 17:19:15 +0000
From:   "Rout, ChandanX" <chandanx.rout@intel.com>
To:     "Sarkar, Tirthendu" <tirthendu.sarkar@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Kuruvinakunnel, George" <george.kuruvinakunnel@intel.com>,
        "Nagaraju, Shwetha" <shwetha.nagaraju@intel.com>,
        "Nagraj, Shravan" <shravan.nagraj@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH intel-next v6 1/8] i40e: consolidate
 maximum frame size calculation for vsi
Thread-Topic: [Intel-wired-lan] [PATCH intel-next v6 1/8] i40e: consolidate
 maximum frame size calculation for vsi
Thread-Index: AQHZQwnngSxUViXYCUuWwnneSfziUK7pYjdQ
Date:   Fri, 3 Mar 2023 17:19:15 +0000
Message-ID: <MN2PR11MB4045CDD47A49E82E7673D1F7EAB39@MN2PR11MB4045.namprd11.prod.outlook.com>
References: <20230217191515.166819-1-tirthendu.sarkar@intel.com>
 <20230217191515.166819-2-tirthendu.sarkar@intel.com>
In-Reply-To: <20230217191515.166819-2-tirthendu.sarkar@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB4045:EE_|IA0PR11MB7883:EE_
x-ms-office365-filtering-correlation-id: 56fb2c8e-66fd-455a-7556-08db1c0b6a1c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K3u1YoKq67W/UiQITAwqqrzRHeLuKMnoY+LQks+S9hHIpfdjLkUk+oRXat40yW+pPdIhlzjNR2jM/Glq3Tgya0MQ/KV7pyyvJLYg2mN/EnDUg2xFMqppEm4PSZjPWBhSkeWEk9JnxZ9mO5ZzSAdou//UTK2xpfgFbQtQyQk/pRDXMXHz2U35rAybQYPqQRSpD0/ffuxVnhqVHyqFRbk640cjx++skJS516LJEGQ4TiwUi/TnpVK955oJa03PoE9jOcByNa+WIb7lXTgNc+h24zTS/Ejhiy+Tge/Gcv6Gl4Bf5BhZDNaJGxBPCcXiEuL3KCvCPRHv3Dryd2WszxPUTjLSBPtiKyVNCa3LtdXsI7SnZw0h2o+tbe2bCVleSRX38aXqKlYuY/alo02/av1smil4kIH2b5z/J8az35ckTa7wAO5bKMDMgMK8mvhRiuAECda/6dXVOjuW7xKE2EFsWJtjm6a0TA7Sk7SEdiphTAMkvSdjboWXDzsmaRkm0OVjcSRUpNsbS1KFDlYCzVdTuhGqCyjDuR3d9dWENycv672CIMFj39wxiw+pcHh3XmDyktSTR0Yhv7sx9ni2//yQqVUh/JbKz0QWKwj5lfcZfhACc1cPuZPBTfNDtAuEr+M4TM9/ZRhbna9mOTG+LrD/MWxyPsdNd8Aa2R5OlROokAUHxwNM+oeZbLuxs9ahz4oZxQTAaG38jm5/P2IEWN3+AQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4045.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(376002)(366004)(136003)(346002)(451199018)(7696005)(186003)(26005)(71200400001)(9686003)(478600001)(8676002)(4326008)(64756008)(54906003)(66946007)(76116006)(66476007)(66556008)(66446008)(55236004)(107886003)(110136005)(6506007)(83380400001)(316002)(41300700001)(52536014)(8936002)(5660300002)(4744005)(122000001)(82960400001)(38100700002)(2906002)(55016003)(86362001)(38070700005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/wBxIZ3ealiqWDENcdMFExXsPgyj/l9AsOOaD37Z6/ujT/O1jKQMp4ps7Nh3?=
 =?us-ascii?Q?8Nfag9I1RqyZMQ7rOV2GDbqN2PdXIOUfBrN5hVT0ETsLMzbP/vxc5UGOECpD?=
 =?us-ascii?Q?4rxuprHC+0gCyzpYpqMeltL3qH+Uwaub0oxJf13p9TAKYVK+4ga9mxjRRUSA?=
 =?us-ascii?Q?L+lAEczEZSRHtf2NjpkOflaHIiISjRX1V+i8C5RqHZJJFpXDO+7WlMobUp/O?=
 =?us-ascii?Q?Dr2etGybQRM2E+NOTtIAU/BAUUaCR8f9pFm6ULibZSj1kv+xDL2D3DXynv2x?=
 =?us-ascii?Q?wsUZWNAQN3nYruVS//gwKMlsY7krNqenuWjCLb7iGXaJJ68Mg9vP7hjrr23i?=
 =?us-ascii?Q?kbXVh51yaAjpC0lYICxBxYX/5Hxtw0mABcRKtv2K+n2D6FiSQH5adaAaYuZ/?=
 =?us-ascii?Q?RbBZ4bDUBL7fVFIpB6jkYtpZePNcygglvgpPHKjetuUIltm1+iJEodIB/Yex?=
 =?us-ascii?Q?C4YnJ0tNwDJGBR1cBKbax2Jq2T5iPuceEUHlhVDeac1nkNKabW21ktD2NS8E?=
 =?us-ascii?Q?f4rDJVWRbWU52du88oGVv6l9yvssqKwDor8ZiBvBIOtb/X/IFGK5sC51sRmZ?=
 =?us-ascii?Q?YwVRwzwoRfxNa7jXJQdK66GUs5/ec3kUflXaG3+1l2lUyviu61yLbOIDinH1?=
 =?us-ascii?Q?m0CdPDyvK+b0S0IjY2ckrJ4h0VmCNH8PNrVKYBT2t5y2IqT/gzH1jLDHWvPl?=
 =?us-ascii?Q?UxjJ4hrttoGPvhflt+m9OHuTYU3HrqU5AT+VKNDTYbeOn+WAAkUqVoLzbkMu?=
 =?us-ascii?Q?fxJcUuMRvTbMY6FbX4q399iThzaJ/tq3ExESyhpTN2xboKmPRKktHAHjylZ9?=
 =?us-ascii?Q?QVuIhBSr0x7UB+nvLtaewmu39UCBp5hz+X5zb3Svv1REtF1RWxxmgtH4YW47?=
 =?us-ascii?Q?91BrmJVDvM/Bt8wxSnksKYGd7VbpFqnGetmkqMae7Z8svfuFETxMqcS5WDpy?=
 =?us-ascii?Q?6FHbZLAfAW7vljY9xkxG1WvHL/8qTay3ig+2q8kgOYugK7BjbC+bQr5Mh7US?=
 =?us-ascii?Q?c/O5+A3izo6LqQul+H96UyCu7nloi3eGARCHOTtZpyQzBaYjh6Zixqkd1IWm?=
 =?us-ascii?Q?W1/cEpuUBbX80hDPpHq0A8YKuxqfHZrYSM1+mckdodOkVZ7lH+NmukMytKk4?=
 =?us-ascii?Q?tdWVvh65PkMiQshioGELE62qwKnzEfFot+9wyk2rJLvWPf5wZ13vDmOt+0TP?=
 =?us-ascii?Q?8CmCbRqkYGG8piGP+l1OjXnhZQrqZ0elcFXk7RzxYdHgSYtDAeeWybvCophy?=
 =?us-ascii?Q?paPQMFwQjP0WZvQmCUjqzdlvBEqsH9y/1SKBU3MInLbZFXe4Jbxtp7WH1ZGF?=
 =?us-ascii?Q?HYzw8ZMTatzKv/XsofrJrlmJepDawLKetKnbuKWpdIe9vxe+O998IkvjqNP/?=
 =?us-ascii?Q?O63jOof98ChXS3+E8OzMav6eAGCSC3aiF09BwFA9bhM189MdMvugd5mbPAeM?=
 =?us-ascii?Q?M0f30E3x94VZsPanfZHDs6mL9Rgf2wA1YSZ1bZFcoXNFWgtt/znkrbu+NB5x?=
 =?us-ascii?Q?PQjE+pjmIUqVoZqz93ngfffsgreTHzV4yAmDRPrsli/NiGhnumLZi0nWSGH4?=
 =?us-ascii?Q?TTP7nzrH9ZaK+BHdLYSBDCk7nv+z1NipUXMG9cRN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4045.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56fb2c8e-66fd-455a-7556-08db1c0b6a1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2023 17:19:15.3056
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hfgMGDjsByjvQFcEemT+uB2agPkvL+yKGffglyd6fNLv6ATM3U8a7rTtR7JXeuy0YbqCftkmCYvtOoqpZKSwDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7883
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>-----Original Message-----
>From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
>Sarkar, Tirthendu
>Sent: 18 February 2023 00:45
>To: intel-wired-lan@lists.osuosl.org
>Cc: Sarkar, Tirthendu <tirthendu.sarkar@intel.com>; netdev@vger.kernel.org=
;
>Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
><anthony.l.nguyen@intel.com>; bpf@vger.kernel.org; Karlsson, Magnus
><magnus.karlsson@intel.com>
>Subject: [Intel-wired-lan] [PATCH intel-next v6 1/8] i40e: consolidate
>maximum frame size calculation for vsi
>
>Introduce new helper function to calculate max frame size for validating a=
nd
>setting of vsi frame size. This is used while configuring vsi, changing th=
e MTU
>and attaching an XDP program to the vsi.
>
>This is in preparation of the legacy rx and multi-buffer changes to be
>introduced in later patches.
>
>Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
>---
> drivers/net/ethernet/intel/i40e/i40e_main.c | 71 +++++++++++----------
> 1 file changed, 38 insertions(+), 33 deletions(-)
>

Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worke=
r at Intel)
