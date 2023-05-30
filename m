Return-Path: <netdev+bounces-6600-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 24E66717111
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 00:54:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7FC061C20D54
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 22:54:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7D2134CC4;
	Tue, 30 May 2023 22:54:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5504A927
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 22:54:32 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DDB2E5A
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 15:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685487241; x=1717023241;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/okbZF9v9Hulk8G9ch/HPfMaLiA5MR+yst+oeqBonqk=;
  b=gdLBrsrxeDwwBapcJU7MyYPy1hAJ5+7zxB2cjDErn8Ri/LW89nq9ly09
   UQx7CWnsPqivGDgpQn524NdmZMSDxyZ3lLSeUW7WT0dvObWNlTJ4GcfFP
   EeeSckz078VZ7Qno9I+jHSmn9/oLzFnAwGmhNMNurMmNCK1FJ3V8pou1Z
   z87aOLXY4BC+8SqFHbqkyuQ8cXL7sAEY3pCfHLoakWXu8s+MCyxmTK8lR
   hWvrj627lMFuPh7uwWwuSURDqJIw7KgWnzLoqA8sJ3aEdy4yto4460KwM
   bLUbqeXqVVx/5ac65hucnMrVtNEzhxeCu3FX7s75YCpertLUfzuKuHxyQ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="358326072"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="358326072"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 15:53:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="739679668"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="739679668"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 30 May 2023 15:53:31 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 15:53:31 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 15:53:30 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 30 May 2023 15:53:30 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 30 May 2023 15:53:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mMJkbpR832aA/5vcwTCJr35t0WSIySeZAlkgpt4IP4qYvHMAf64Rqk3hU3wJJYJIkM/bIYqB5grAVOAZ+RWEfGSodryT/O5ev5t75+LPTO+6ZAiuESgqYwX6qIvAD42fIA+/DBVmF65qKy4MXRqJuDYgFcYgMciLcZbKa5RC9ogrf7iihJN6yX1sU1sLBckkksOGgaRzM47SUkCtEfgD7YUSmdQ3+AVzooxfOq9dSztfTJ1yhUMepiBYbDDn74YJF6q0sZFmOwxR/ydYdeE4MwCRA0BHwsZAFdBsVap/w/EN2GIYWoQ5dcF1vDTZ1wQEd5whswElsEeJ7pUIjxNhqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mFZGjKd81KZ/oAG0b1QaFpucJsA/gkZom0SGeciwTyA=;
 b=aEeqxJ/YA3bwyq7u5RTRn8Of1gIJ+JNL92JDkrJzWd+e9gW3kHQlpSYLcAT++GZllpfjDM7PKgtzZD+3kL6+CwaRnDQlzuJun/IbPBtx05QY/P01qsppgBQexcC1YoAw5PcITzO/WV+fz7jvaX/cwflUJ5PBFlagRhjtn34XX1DvxYfBX6CSFR6+C9N5f2fprAOgWnWLE+6n9y//UtfcnFoei5hdomyiN19cDkpfYJtcJ4QFRUiM+SXFfGjc7UwjfCLVpRPyVE84r4xPs2QYpBBsDlVsDcln+hVwqruCWp97H4mS9OsV4Mc2+iBL9Ht1XfU328HWYkzuujs+yHZAIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5911.namprd11.prod.outlook.com (2603:10b6:303:16b::16)
 by BL1PR11MB5301.namprd11.prod.outlook.com (2603:10b6:208:309::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Tue, 30 May
 2023 22:53:28 +0000
Received: from MW4PR11MB5911.namprd11.prod.outlook.com
 ([fe80::d06:5841:d0e0:68b8]) by MW4PR11MB5911.namprd11.prod.outlook.com
 ([fe80::d06:5841:d0e0:68b8%4]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 22:53:27 +0000
From: "Singh, Krishneil K" <krishneil.k.singh@intel.com>
To: "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC: "willemb@google.com" <willemb@google.com>, "pabeni@redhat.com"
	<pabeni@redhat.com>, "Bhatnagar, Shailendra"
	<shailendra.bhatnagar@intel.com>, "leon@kernel.org" <leon@kernel.org>,
	"mst@redhat.com" <mst@redhat.com>, "simon.horman@corigine.com"
	<simon.horman@corigine.com>, "Brandeburg, Jesse"
	<jesse.brandeburg@intel.com>, "stephen@networkplumber.org"
	<stephen@networkplumber.org>, "edumazet@google.com" <edumazet@google.com>,
	"Nguyen, Anthony L" <anthony.l.nguyen@intel.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "kuba@kernel.org" <kuba@kernel.org>, "Burra, Phani
 R" <phani.r.burra@intel.com>, "decot@google.com" <decot@google.com>,
	"davem@davemloft.net" <davem@davemloft.net>, "shannon.nelson@amd.com"
	<shannon.nelson@amd.com>
Subject: RE: [Intel-wired-lan] [PATCH iwl-next v6 05/15] idpf: add create
 vport and netdev configuration
Thread-Topic: [Intel-wired-lan] [PATCH iwl-next v6 05/15] idpf: add create
 vport and netdev configuration
Thread-Index: AQHZjQ1VAarNlICYCkuqtVigVJe4zq9zeK+Q
Date: Tue, 30 May 2023 22:53:27 +0000
Message-ID: <MW4PR11MB591122D57A8B6C7BE127D693BA4B9@MW4PR11MB5911.namprd11.prod.outlook.com>
References: <20230523002252.26124-1-pavan.kumar.linga@intel.com>
 <20230523002252.26124-6-pavan.kumar.linga@intel.com>
In-Reply-To: <20230523002252.26124-6-pavan.kumar.linga@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5911:EE_|BL1PR11MB5301:EE_
x-ms-office365-filtering-correlation-id: 68552b38-f1ab-4ed3-52ab-08db6160aeba
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k/dJ5UYlWF2ypSFo9JSnWi7OUExrE/002MeC4l+7Oo4Jg3+lpAS997qBGlsBQAuTXftYq/RDgdlC3e3YHq5eGVstQB7Xe6WD2201m2PXsQ8PuhFnGJaTPcATQhpG9WW0kxMiVrJ+XaVvHOHe0/tMH092Ka6b9ilyGP0dWjWVwbFw6pAcV0Uv+dbXGVvFeGqtPuGasNVOL2aOrpLpCMFgrHB8jTPNpj3awitAagzTUnQ1CL0I11QyIJJUEdBfLt/aYx6s9n3yZijM5OzT81fIBu8W25Hhrnt98Kns4PGYr5c3iACwNTcrEJIh/nVLESh4mCAdro7BV+8686mi/UL9w9qWivtdqMla08X265xl88aZj8WikKdT8sBn7/zG++sf68IbD1abnEyHh4YZpg55BUTEtzv4AnLbQ5ZT/DhZ2ttCLaf9O81OpkMzee5tnSHstS+c01J288r5UXOoCEo5rL3iFZtROOhBXHQUWjTRMgxvgz3UQBMNIqW46KcyXw2fZTtHnVaVnf5hrEG/U3NGgHnVCjqYJlTwSeVuIbkac4Gb7iddtW1/DLN464a9JeqkL+CVDjlsFdGzlov5OZtFuJGjwpFCIIP0zhCrjqx44R08vGXIoNBmm7x0TjRwn+mw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5911.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(376002)(39860400002)(346002)(136003)(451199021)(66946007)(478600001)(83380400001)(4326008)(76116006)(66556008)(38100700002)(66476007)(41300700001)(64756008)(66446008)(71200400001)(55016003)(38070700005)(122000001)(110136005)(82960400001)(54906003)(316002)(8936002)(8676002)(5660300002)(26005)(6506007)(9686003)(53546011)(52536014)(33656002)(86362001)(2906002)(186003)(7696005)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SXhiZ8qFU4NsAJsM3iPascN6V5jiYvp6qg26FdGVEW61SVLn36Ns5zzzPAu4?=
 =?us-ascii?Q?opaeTl3DdkO+8Y7AFMErcBntKGtAkNARF4l6A0rG/fFkY2sXma8zI+1zGt8X?=
 =?us-ascii?Q?cbo5w50B/msye/DBQzBbKdbUT/ePQCZrc9R4l/yjyb0mmEUygo261faM1XXU?=
 =?us-ascii?Q?Wso3uBzfGwKmOdQZOnIqGLeXIGKI44+UmfFpebVYIjMRFEn3Ps062FYkuysz?=
 =?us-ascii?Q?sk/cREaB9pV97/L7TGxleJYlwZVL9ztzJ1dTntwP/5ZxazXZ6MGKKM1I1tE0?=
 =?us-ascii?Q?wMk74WrYTldR2+bCx4nVGowUi9axIEHT3shoAQPFGi7Hi2+K1MiFdODtH+Ux?=
 =?us-ascii?Q?I606YDWOtwYRselVrbyG9aJWESjEQb6yufKtzFbl1PtM08xg2UTTFSaT8Gez?=
 =?us-ascii?Q?6FhZxDng9u/bYoiiaFWfvajVrsUuIyBttRJs41CUhJvVrfRGKMMl9h3tjxsI?=
 =?us-ascii?Q?hWr9e+38nyIFxMG9Sg0a9atrxpxGlBfLc25zmyRad4tovEtUGPJ0Lx9ZOkJR?=
 =?us-ascii?Q?t5e/T8BuxXL5sX46OpWA+T/Zlb2XBH65qT5R6COasphMMiqXqG0n11vJklK8?=
 =?us-ascii?Q?7mYRLbq1k1mtOT7QeV6ZjTaRgDk7FpROyY4N0eJ5VaiahhxfvQnY59wztpuv?=
 =?us-ascii?Q?BRlKl4l9GE8H74VVC5BjV7Gono6bpAea6akrVBn1OVqI7YfOTOqOJMviPGso?=
 =?us-ascii?Q?okbyDT0PhT6YqX9UrTfN5we5x6oXE2eyiEeTUUW+CUUJRDE3cK/Hz0GgWNAh?=
 =?us-ascii?Q?CgmCEPrMU/g5gxvCSj00kO9edBzmPrz3EM3X+Kn8p6iCjRdUP7VubofVYxRI?=
 =?us-ascii?Q?5KdswPgrfcFPBctvsXBbMkTfCTLLArGtNK6/fBu/cUgo8S6BVOzD4tsMfm4w?=
 =?us-ascii?Q?c93XUXxKIFXkJQCgSlX210b+qa4U1wpCg1ge1E/WEV2jWATHIm1sG7zv36su?=
 =?us-ascii?Q?EgMJ6qz2aTx2STSFpsNeAe6wJNZk70tD98cSWiUGdOZsn7z0I3YEqS4Cnvkr?=
 =?us-ascii?Q?/QtWJvIfZofepVMZfr0ZSTH+nRjyUVFaeHwrwstJQz5iNetda+QB1ITIY18A?=
 =?us-ascii?Q?qkdmUEwMX5vt0NC54bEgjedagn+lt4qjN2m9wbtl/2nI6VXQEcB6tPFY33u4?=
 =?us-ascii?Q?7t7Tp4bbISHbgwVjkv9u4du1AE7GStCjMzgSQflRthRSKNY/UVQoVenLge+/?=
 =?us-ascii?Q?Yr1F/t89bPQlBqExlxkBvAzP4P6v5g/zdOZGFIp1ZsVWrEwX/0geVyZBarhI?=
 =?us-ascii?Q?kIM1M++6ivZHwji23UybFeBtXiDXhc/XbIuM8aW+KFoSOM+JXg104ARFQRcM?=
 =?us-ascii?Q?eWiQyfSqDKVBLkvoXHlMxtwzRVBV0+GQ69AN+q3OHVDmp0A4VxkM9QPU3kxc?=
 =?us-ascii?Q?yYePl0M9tG5EdmTl4nly6tdirfgDyt3zCSL49auBP6ofxXn7uwkZgppRxUHJ?=
 =?us-ascii?Q?rBve2UzPgf3QI8S2nZ+/JVflMZ7guno9fTbc6+EWBU6JVEM1KmUnDKgSBnaE?=
 =?us-ascii?Q?8gthMidA7T4dOPMf2HeWdx8GN4pKpNbssWLXyxt8p3/G4Qr97AhFsRd1pkf7?=
 =?us-ascii?Q?3xvDC0/es6LSYE/bbuOlDfsXMJsksB0SG3McVZ7wutrDd7wSXujs97Kj8g5e?=
 =?us-ascii?Q?6A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5911.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68552b38-f1ab-4ed3-52ab-08db6160aeba
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2023 22:53:27.9112
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 75b8d2fBbR4JRA9Id0Z0ox95E8CXkJHMHP7/nFRWm/HFIaGJmY3IGEGFmZIOt0UYd4FZ9Xi1CXVDW3/qwminpzTQnYjCHfGgthypDLvyQiM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5301
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Pavan Kumar Linga
> Sent: Monday, May 22, 2023 5:23 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: willemb@google.com; pabeni@redhat.com; Bhatnagar, Shailendra
> <shailendra.bhatnagar@intel.com>; leon@kernel.org; mst@redhat.com;
> simon.horman@corigine.com; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; stephen@networkplumber.org;
> edumazet@google.com; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; netdev@vger.kernel.org; kuba@kernel.org;
> Burra, Phani R <phani.r.burra@intel.com>; decot@google.com;
> davem@davemloft.net; shannon.nelson@amd.com
> Subject: [Intel-wired-lan] [PATCH iwl-next v6 05/15] idpf: add create vpo=
rt
> and netdev configuration
>=20
> Add the required support to create a vport by spawning
> the init task. Once the vport is created, initialize and
> allocate the resources needed for it. Configure and register
> a netdev for each vport with all the features supported
> by the device based on the capabilities received from the
> device Control Plane. Spawn the init task till all the default
> vports are created.
>=20
> Co-developed-by: Alan Brady <alan.brady@intel.com>
> Signed-off-by: Alan Brady <alan.brady@intel.com>
> Co-developed-by: Joshua Hay <joshua.a.hay@intel.com>
> Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
> Co-developed-by: Madhu Chittim <madhu.chittim@intel.com>
> Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
> Co-developed-by: Phani Burra <phani.r.burra@intel.com>
> Signed-off-by: Phani Burra <phani.r.burra@intel.com>
> Co-developed-by: Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>
> Signed-off-by: Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>
> Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> Reviewed-by: Willem de Bruijn <willemb@google.com>
> ---
>  drivers/net/ethernet/intel/idpf/Makefile      |   1 +
>  drivers/net/ethernet/intel/idpf/idpf.h        | 247 ++++++++
>  drivers/net/ethernet/intel/idpf/idpf_lib.c    | 418 ++++++++++++++
>  drivers/net/ethernet/intel/idpf/idpf_main.c   |  50 ++
>  drivers/net/ethernet/intel/idpf/idpf_txrx.c   | 182 ++++++
>  drivers/net/ethernet/intel/idpf/idpf_txrx.h   |  52 ++
>  .../net/ethernet/intel/idpf/idpf_virtchnl.c   | 528 +++++++++++++++++-
>  7 files changed, 1466 insertions(+), 12 deletions(-)
>  create mode 100644 drivers/net/ethernet/intel/idpf/idpf_txrx.c
>=20

Tested-by: Krishneil Singh  <krishneil.k.singh@intel.com>

