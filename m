Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF36F67AFC0
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 11:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235528AbjAYKeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 05:34:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235339AbjAYKeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 05:34:14 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E7424482;
        Wed, 25 Jan 2023 02:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674642852; x=1706178852;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xU4q9VuJ0R13sKTfxvSqQPJgKGhHEKq8ZROXN17voIo=;
  b=GPD201ihLQaPv+H5TapE0DyuVUQvcTeHIOEr6dROtHH/5xHTeiX7lAYM
   tZ8LS0Cwz7cYOASeRjw7plZJFQ4SI/f3pRzaOgVtpiSUBLFK3pLFEu1X/
   G4UJltEwjLpcv5O77K8BBEsU+mEb+YFZCGoRHxT8B7TcT+WtZrPOJWgN8
   ACthGd7ZhsAzi6Bo1eAn6tTeGYFvZw4za1zSEoM7tajxXKdOWlj9KNfUQ
   S8QvnM1pWf5aPOwp/aqIorJJ1J14hkGwlfUvlzAJ+OkWGu9nkHT+5U7Nm
   bes56MQ9BLJvuLGnQFckk8sHxkcQeM1uFjP6jHXRF+2p6v6PNsgiZ/R3t
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="306188236"
X-IronPort-AV: E=Sophos;i="5.97,245,1669104000"; 
   d="scan'208";a="306188236"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 02:34:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="770676371"
X-IronPort-AV: E=Sophos;i="5.97,245,1669104000"; 
   d="scan'208";a="770676371"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 25 Jan 2023 02:34:12 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 25 Jan 2023 02:34:12 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 25 Jan 2023 02:34:11 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 25 Jan 2023 02:34:11 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 25 Jan 2023 02:34:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MKi9tJbXB57PFYHBqKlzt8NH3HOn27dgbZE/8Vrk5L0ePGw60HxIl13EDG7go9UP/ym/4jpuA95tzXCUZWlcEufJSYtVwK+cfmnTW/hLRAu/Aj6OzIWbVimiuSrx98YrhCiAf3RyDCde5DecLVj51oCBhlzSMkQ1AQUCLsWE0+HB8Cx4aIzCQaRmaRPdbSHVC6f4SuHk9S9UxLm5W5FVdt7YbkvKE6Hf30Duk7KmqQkBmfMEoFe6F9yBa05lWoumwPCt9davOzOCjhj3yb/o+F8gecpGoTdL7IdD4U0/i93+yX/fmTtr36CBzgxjRNEhuPtxIrUhXaIR2aQMPZPniA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UzR2F6rJAJWzhFic58ukBeVwm2chD5lF/jUVkDvcfEc=;
 b=DnnykhPaXK8lP5gs2G18r9/BNGo7bmN4ogypVqVM24jWgr39AUKIUcUXbExxeapYDsM5m1mM2A72VgG+2IsCjoLxvtA7ndQ480VTPVTR5D51n2lSZwjb+41OmFF3b8+Yvy4WQdu3vhfRteXEpOuwGIPWRS3jcy/iKBQ+TgkXWhSXa74fb1qrdqwetL3Q/qglntr6/MBBlF2nsvcOcM07yAmF6F1nVtOh6+DM9iLOlOJIJhoiImLjxcMNSmX7rdPn/0ADC6f++djdjZd38IHXNQkktCvaXr0OQJVAaZBvlb0yxxDY7+BnINMbgtSAh4babX4tQd4Z6NTXErjB9h4CMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by MN0PR11MB6109.namprd11.prod.outlook.com (2603:10b6:208:3cf::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 25 Jan
 2023 10:34:08 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::86b7:ffac:438a:5f44]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::86b7:ffac:438a:5f44%4]) with mapi id 15.20.6002.033; Wed, 25 Jan 2023
 10:34:07 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH 4/9] i40e: Remove redundant
 pci_enable_pcie_error_reporting()
Thread-Topic: [Intel-wired-lan] [PATCH 4/9] i40e: Remove redundant
 pci_enable_pcie_error_reporting()
Thread-Index: AQHZK5c6m/p3pIPkpUKNgjAW8gdLRK6u+ciw
Date:   Wed, 25 Jan 2023 10:34:06 +0000
Message-ID: <BYAPR11MB3367BD0B7644182528FC599BFCCE9@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20230118234612.272916-1-helgaas@kernel.org>
 <20230118234612.272916-5-helgaas@kernel.org>
In-Reply-To: <20230118234612.272916-5-helgaas@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3367:EE_|MN0PR11MB6109:EE_
x-ms-office365-filtering-correlation-id: 388ad12d-6754-4cb2-161a-08dafebfafa9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /OJUzm5XwCPxUT558knqU/psljlfIASfFj8hMHrGoh8uSivqLOGZDsenzO8RnIpCkze3a0vw0Llt8YowDUUFNfbTlj3gEr+IJF3gpPcbofdwC1SCsN7L4lKonasEp/0M4TUlUJeXkdqTjb28ZZGOd+LuYSsRmi9AN7t/wZ1pcAi70ImrEuhmfzl6eI8+VMEkFQlybjQaW2qkDzBwFuCpY9imCZjxLUq0C6bwwQncmokYjtLvz+FkoTs7bmnGO4UeITMyqTb1UL90hZ7R22ux36QJMXcc3mB4kvCPF+/nKxKQSzPNYe24wGZNbaiehty6fkzy16EdBOzvZ/W6QLdIEYp5Ga4TgRYgvyr4sLKWMfjNnRPqZnRkXp6UH3AMsCMDM/LkAAmuzIyd7H0EwN5MjaOwV/sqv+15JwJa4YudPuTSzkUgxJPF0NNORWlj1f4U1XLVKPObmQLQLwsM8VW9xRu3Mey5bNMT1ZEpiwGGoyfXO0TQtqVxCr9tfF5R/aCYi4Hl+MnP29X5S//0pFp/4ZK2251WVeePCPqw+2JRRGT5xlUbi9BXh3qPPKYy4TmQTLbNZ/TlZjg3oXLJhkY1NgFLkarzQm6N9ll0NhX9V5T9XrjhZn0XDLf1TzfEzoebXcTAeOpJQ7Yr20xwgKgj7i4aR95YzUTR4T+ADFhXE550L4CNDhbLkhf1arAKjmR7V0o4KaeiOD0l0V2AZTH04g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(346002)(366004)(376002)(136003)(451199018)(54906003)(86362001)(122000001)(52536014)(66446008)(26005)(66556008)(38100700002)(82960400001)(9686003)(53546011)(71200400001)(83380400001)(38070700005)(8676002)(4326008)(186003)(5660300002)(316002)(66946007)(6506007)(55016003)(107886003)(110136005)(33656002)(478600001)(2906002)(8936002)(41300700001)(66476007)(64756008)(76116006)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JZ+ycHHKGxeQHDNrhoxNjyq1vBQ0mbk9B9nTTxIUdijBa+NgdbFZtci3bHIP?=
 =?us-ascii?Q?fDWn5GOn4xSLEd33xODTVFkt2WpAabd3RwAup1Lpb2avUHZ7fdy+e4+wxXaU?=
 =?us-ascii?Q?hVyo9iwyKE5A83eOUrcSoW+HJHap22OLcI7d25DRPyPPOntIPQoIuy1wvepo?=
 =?us-ascii?Q?z9iG/T6zObnwLvn3rbws9yovVaAJkZjeEXEiB52IHP5V2JN2vhJTzSwGCtIy?=
 =?us-ascii?Q?eB4oYCrgf7JaKelRaPV7E0TyGiCMbRCL15QrwORKl1L+L+itZScM7wvIVrQV?=
 =?us-ascii?Q?ZWrb0Xw2ddfYc9iPSUpEmQT7MyKTXKMeGZ1kuV6UkLm3rCKqsDlmY3CE8fE1?=
 =?us-ascii?Q?CKGLXe9qTlSiHuH1Y8/eOx1SoOpLXavzCJ/WzPLSMYOlC/ExD5f7+VatqkOv?=
 =?us-ascii?Q?A6sQNaV6oHXFGkTQmJfD/t/R+mV10Zkb+e7mQRv5FOZbhgmGZ350/L8prZjX?=
 =?us-ascii?Q?sHR8L+GHkMwiIp4idrJ9LATYpfCXwmUX4k9EULDFXqIZbHxrm/C8rl4GV/pn?=
 =?us-ascii?Q?sqwlDGfrNIKbHTOe4RIpI0QNEpkShDjvlPwYK1jKdrwsco4mya0V07SUhvCt?=
 =?us-ascii?Q?jXu9e3TUdbbZG4rT6Ed19kZ/tl5DPB2E+ZY3d+0cO2a0/2BGjvz6Bo2Yd/rZ?=
 =?us-ascii?Q?aOCeb08Fs69ShDaHCVPzV4YVu/rlFYpF5rAZ4YeVD5OWt2zUYF618TJL3LS9?=
 =?us-ascii?Q?CknZtxERXHlUdm3ppNY5KysRxXrR/P6G7bDJ2Hm2JZfw6FoyxkWkp3zvj2i/?=
 =?us-ascii?Q?KHKwCD3jh26LrUWUr/4TdKJgFbcxixwCNQ8hAjiel9y/8UnQcz9pFuTD+4Z0?=
 =?us-ascii?Q?jdUHb1HRTZ/QwzOLCslp6QwZBfnDrPtwlrCPHEj3ZxCH9z2p+Oez9E3dqV31?=
 =?us-ascii?Q?JkXJtyRnGl2nQ/1N998n1F8braypssdAVXpDYr3BCsmLMucPhSVMi0dSoAK2?=
 =?us-ascii?Q?lnGhcSIKsoUW6GFWr8yBDMbynR/JvQ/d3Jt0Hrz5zhGEuf9CyMzdhB+lvU6l?=
 =?us-ascii?Q?gEDaOOr7EnAdBjrxBHFMaH19+SgJE58KfsuvOCkeqFI2oAcKUhch1tY57QXW?=
 =?us-ascii?Q?BfULXd1yA0EoIe6kZ0hIDqvESMOyUp0bqMEpeLOKyfoAnni9pFAQokeFJzUh?=
 =?us-ascii?Q?ZwP/GzEsJg19t/8PT3CRUXMZVfyjSyoe1idqtn3hlBjjfh3abv//nmABGIo4?=
 =?us-ascii?Q?YIzpak2T0ZsdYkigcMhPZL8xxClDbNcbRMU5c++EuVxJQ0eAmRH9ahnAQ+2t?=
 =?us-ascii?Q?aEY1uZ9OX+g/oPiGn1JaQrFy0YXwWB/WcyfxvHz8atd5lk5Yuhjb2cqHar9h?=
 =?us-ascii?Q?Yk3I/Mgqf327L1m0IX4IPU1MLYBanzmPWx4PYkvvmb9nJzAacI5+Eb3LQuiT?=
 =?us-ascii?Q?ZQ1r4Lz4r5Kkvm2t8eL0OzDXTsIovIEnzBAcDRKlzyLBoXk3Nl6CVznusraZ?=
 =?us-ascii?Q?4EkhODRYEgK5A1NiFdMxqqSIpHoug7sxUDWPTcU1LuKU+MNorHinVo92EMHN?=
 =?us-ascii?Q?Od+62p41wrk49FKj/bs5QXjPCaMpfz5g1WX3SU7TiR3i0yvVJHJ31Rwx6fkd?=
 =?us-ascii?Q?gDL2rM8qmGLYCR/STe0ObwtapFjSXwsAqnatglOy?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 388ad12d-6754-4cb2-161a-08dafebfafa9
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2023 10:34:06.5180
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gCBNyDpP9SzVqibk/AKJ7lJg9aGnUhtT5m9ivCErBJ9cqRYd+6mqv7sdYLYGSkq4Q1x3PlK9nVW/h7TvruAZIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6109
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Bjorn Helgaas
> Sent: Thursday, January 19, 2023 5:16 AM
> To: linux-pci@vger.kernel.org
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Brandeburg,
> Jesse <jesse.brandeburg@intel.com>; intel-wired-lan@lists.osuosl.org; Bjo=
rn
> Helgaas <bhelgaas@google.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>
> Subject: [Intel-wired-lan] [PATCH 4/9] i40e: Remove redundant
> pci_enable_pcie_error_reporting()
>=20
> From: Bjorn Helgaas <bhelgaas@google.com>
>=20
> pci_enable_pcie_error_reporting() enables the device to send ERR_*
> Messages.  Since f26e58bf6f54 ("PCI/AER: Enable error reporting when AER =
is
> native"), the PCI core does this for all devices during enumeration.
>=20
> Remove the redundant pci_enable_pcie_error_reporting() call from the
> driver.  Also remove the corresponding pci_disable_pcie_error_reporting()
> from the driver .remove() path.
>=20
> Note that this doesn't control interrupt generation by the Root Port; tha=
t is
> controlled by the AER Root Error Command register, which is managed by th=
e
> AER service driver.
>=20
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
> Cc: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org
> ---
>  drivers/net/ethernet/intel/i40e/i40e_main.c | 4 ----
>  1 file changed, 4 deletions(-)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
