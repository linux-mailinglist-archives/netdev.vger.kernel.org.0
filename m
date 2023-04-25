Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05C136EDC15
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 09:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233366AbjDYHET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 03:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233357AbjDYHER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 03:04:17 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444B265B8;
        Tue, 25 Apr 2023 00:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682406256; x=1713942256;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version:content-transfer-encoding;
  bh=nf8JmmRb4rebb559bWsSBxbaVEi8TnSOSNRZ5CzQd9U=;
  b=VvQZM1EDi7aQt1+H4Q7KvlNRO4OCigSksvO8joM1+qi0B0trCJZZk9A6
   qb4dsplraJ8LPCMY7gre/5e2IxgNNvua1o4rke8J4AUusrvnVc6Buwa04
   hjsY5duHdz/o9qTi0GRuuM1QZHZIil+XnP9QQTuAN/B3mujXw637GS1fV
   R4DRjxbqY7GIGa9Fa7V7bkhPXT0hZ62fM0WV23/dBPP+PO+e0kNUkICvU
   mghU+yizhVg9aWkgv755jTSvz3s5tzrm6f7aSnSQe5ybNGvX37SsjZRSy
   QpvheYdy1VN5EgnxC23Wv3uAnuP/AVQ49dfYr9maFBybyU/ET1rsnMlii
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="348594613"
X-IronPort-AV: E=Sophos;i="5.99,224,1677571200"; 
   d="scan'208";a="348594613"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 00:03:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="837321357"
X-IronPort-AV: E=Sophos;i="5.99,224,1677571200"; 
   d="scan'208";a="837321357"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 25 Apr 2023 00:03:55 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 25 Apr 2023 00:03:55 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 25 Apr 2023 00:03:53 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 25 Apr 2023 00:03:53 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 25 Apr 2023 00:03:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SH49jiPTSjGxvSYayIJG10jaG1UAB3ez7fsr8pwMxNsb33M7UzqrbS1OIwVxN9mpB0GKEIrvg5aKfuYA9bK5uoEsb5Eb7lP+CIfv4EuxbwKYVOyt7XA0shpd1YGyRNk8hYxJjqcNbDLQQPfgY8uV+xUc3aIUaE/fCg9KB8YzCcXfoWMy7Hp4sTUduJvN1dkyBRf0lkyAUWwcw7atvVKm85I/xtcAEaLRU/8KXgqZp5n5GdedbmDvyxI3H57MGyam2SQszTaxRDbGZ4s+zASv8hqZ5ZeDg7MkjkzUzAmGbHX/YGrzoCBqDSGsBbrVMT8Ajq/b36JzPndRWL9KzIzhrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jSoVZm+XxHgfL6LhwM3ZStmq+QpEMQ0tWcsLG/7QSmQ=;
 b=O3RMWHAOFpAmzwjUR4QJUmIw9szHqrfGpnTr1RZTVO51jw8ojSFgDdTlHTDTXSqJuUMswkacpVD7RL1z7EvWXzQSTvwTGcCvhzSD4TJul+sQ6SRoTTZcBXexigwZpRdzs3Rcyp1rt3pTZK4+hnjmMqhNHbSkN4acRC9RCgOon3bzNudOAxAsiZAjrq1NPfnJjwpwTHZDDJim8V0Mx3hQI0dNH/RbfAncOBr8RyxqgANJ1kEXhm9utc4TV+Tp+htIhfOSds9K3ZZwY8ipyilh8/6xUXanpRYii9qBfElP+Vuj6aXUEXnYfMcul+5a923JkPLqhqJqlybDVG0O6e4gQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SN7PR11MB6996.namprd11.prod.outlook.com (2603:10b6:806:2af::17)
 by MN0PR11MB5961.namprd11.prod.outlook.com (2603:10b6:208:370::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Tue, 25 Apr
 2023 07:03:51 +0000
Received: from SN7PR11MB6996.namprd11.prod.outlook.com
 ([fe80::338b:763a:ac40:d509]) by SN7PR11MB6996.namprd11.prod.outlook.com
 ([fe80::338b:763a:ac40:d509%7]) with mapi id 15.20.6319.033; Tue, 25 Apr 2023
 07:03:51 +0000
From:   "Stern, Avraham" <avraham.stern@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "Greenman, Gregory" <gregory.greenman@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: pull-request: wireless-next-2023-03-30
Thread-Topic: pull-request: wireless-next-2023-03-30
Thread-Index: AQHZbbjNzP9gzb4bwEuw1qGhSN1B8K8xGe8AgAJ/PgCABVt224ACIUqAgAA5hgCAAFSOMA==
Date:   Tue, 25 Apr 2023 07:03:50 +0000
Message-ID: <SN7PR11MB6996324EBF976C507D382C3AFF649@SN7PR11MB6996.namprd11.prod.outlook.com>
References: <20230330205612.921134-1-johannes@sipsolutions.net>
 <20230331000648.543f2a54@kernel.org> <ZCtXGpqnCUL58Xzu@localhost>
 <ZDd4Hg6bEv22Pxi9@hoboy.vegasvil.org>
 <ccc046c7e7db68915447c05726dd90654a7a8ffc.camel@intel.com>
 <ZEC08ivL3ngWFQBH@hoboy.vegasvil.org>
 <SN7PR11MB6996329FFC32ECCBE4509531FF669@SN7PR11MB6996.namprd11.prod.outlook.com>
 <ZEb81aNUlmpKsJ6C@hoboy.vegasvil.org> <ZEctFm4ZreZ5ToP9@hoboy.vegasvil.org>
In-Reply-To: <ZEctFm4ZreZ5ToP9@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR11MB6996:EE_|MN0PR11MB5961:EE_
x-ms-office365-filtering-correlation-id: 0d113366-c9a9-4909-6559-08db455b393c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gq8vHyoSU8DRTxDkoQ1ZkSXtLxJpriXcr/+HaJiYGap1gL1AV+gk+yDNFgj9uMAfYcyiITk1l/moAjCrsfshKR0vG213CONsVpmxKDUa938rf/PxpH/F9kYlyiTeuwIMLbqjlkmvzFke6bLLSus7kVN/RYIji5eF0TMI69tURCgz8AcyjPrLNKzBqaYTwdY9LhnkawahMcbZT2FiytJtnUfqZ25jgrEpiSVx8/QfSKm8D5PyqHhh9S6ol5Q35mQx7h2OQHVKF0Efa4Ty5BAXWtbMF2LRrLfNEy6NDWtGNPStuKviMhaZN0Y6lD61OlpEOki4LLA/0qfySadEdjfrHLmzsG8RDPQTwT/CoMnBqDA4ojzgEElt6/MX8SY6FBXZJEhSS4GK3CMM4c4Ryjjj/tHOJNVk+KYLs0oG5AltKzhq5o1t2eP6XCdthCoVnBrKLBWOJFZrpbsKHh61VExphS0ayRAmFPfqWG4PxMgeAe47k+cEydkf5C1cPUkC3ARFkKhdSo727hsHPmA0jVTggbf2Ook8ZGjqtxQ4jhsGBAOsAXBurT+99+8/cwvZrqdrDEyQgRiBd7dgZTcCAzoBvVjbpAcfPU8ZVDpS25Sw4RaBtKe+QPlGDGtqV1vs5ATz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB6996.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199021)(54906003)(38070700005)(478600001)(76116006)(82960400001)(316002)(6916009)(4326008)(66446008)(66476007)(66556008)(55016003)(66946007)(64756008)(122000001)(41300700001)(2906002)(8936002)(8676002)(52536014)(5660300002)(38100700002)(86362001)(186003)(6506007)(26005)(9686003)(33656002)(7696005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ti/TCkXxqsMB+y3m/UpneGMjw/ZNsZXYE9QnOAmzaIRGqIYU+9HCInL9R8Uy?=
 =?us-ascii?Q?erGJ6/S9eGnQhVXd4xvsZyKjdfhvYIfz4MnfUq5caBbnewGm7jcgvQn1lbEZ?=
 =?us-ascii?Q?ItusBZzdlssKKtbyG5EVrkagxj99kEcGyjX78VFfo7O/SrcDuNCQ0MGypRof?=
 =?us-ascii?Q?5A2cg63tELKmKM5vVq91MYQpGV+imM6suTHtuAmJB/BE92CCf8KF9Ysq5Vgh?=
 =?us-ascii?Q?l9s67787PSO1DrfRhw61/59MuHf4E4GhIho9OvONLvcujybr89d2UM+db0sF?=
 =?us-ascii?Q?h8Ov+74aEZn/EUlJD7Ao5ybQAYY+R/xvw3czi26CwUnQtw0NWHt7cN3Cm9B+?=
 =?us-ascii?Q?P8cwDopE0ZRAip/PKiKHgmv5J9rGGI11bzx988Iy6EXhBaa7llCu0HzveW+8?=
 =?us-ascii?Q?0Fe2li4MU2MojD2dUlB7Wd46cudVItIslfKWDtyPHpvFTNBWoEAYVCCKY5Zk?=
 =?us-ascii?Q?/CkPt3pui463A4sg6Rzr4CJ9/QhwUmWb679fZ5C53Uv7mTjD7EeNnU/ppIXC?=
 =?us-ascii?Q?KNyT5LD88iNLkk7aqvaBnF6NRbFZXLbDZcAewPsMDFL0ne6FGzgWjysI8D22?=
 =?us-ascii?Q?gIkx49luojC5Jdi7zsd//geW+Ph6eoDTKJzKuG8sptQa/k5+G3KX7AZvyxcF?=
 =?us-ascii?Q?hGrKAA8o3S6OubsKW6dqvbhG0Ecg9hkOzNe/ARLdKH0MfrR87MdPGPU0l0hx?=
 =?us-ascii?Q?53T25L15Fk/24KKwtJHAizXzja9hauzLmabtX94fSCjPUm3X74hDNWybV1EF?=
 =?us-ascii?Q?0P3fsuv73YT5r2YbB/o3HtYmUQzPD0ugtxaONYNZRotQXJyLrWqbGpxNIayg?=
 =?us-ascii?Q?2FVOjBx7p+Xb+x2xP3n9atvaf1h1E0Uin35Vbav9QLDoEB7O0hySRXbdj5Q+?=
 =?us-ascii?Q?v7gP2ljj5s1i9Hly4rgTNVZxF3dTYwdkCfHE0mz5S18pGrfO595vyhWY8lUy?=
 =?us-ascii?Q?rd9Vze8MIAr2IQqx6AnTjRoAP2AP4ltb/DOleHMThdjJh8u4TFKynUFnKyMU?=
 =?us-ascii?Q?YlHIswDpdlwx9WUvlnxitfA/Qqi+9CpmA/R+D4xPw8/2pIr4QkC/5Gor5HRy?=
 =?us-ascii?Q?xL+TeNaDiVHz3Wnv/aUuR8qp/Gd51AAtReTwOuRbZC3IKR8myl/8BF7TeU7m?=
 =?us-ascii?Q?Sy2pCxT3D0KZhT7IIQbJUQQFExJIrnFzEkV19bfzYv9MaXhqTrRdB63VW7M8?=
 =?us-ascii?Q?gBA/ep7C31Jm9Uzc9rOcWp7OrzQ31MESqKzPnYdXJO7U+2oPuE2Po3dKwAnh?=
 =?us-ascii?Q?orSqmVpxBtXjr4ba/OsXPSNL2VR47Mei5gPeaH1vf7PVTZZvdm+mstwjo40q?=
 =?us-ascii?Q?hiWsltYxcVwHnsXVleOSTuMhYae7MaIObzcVeL5316qFYk3Nitn/Y/6/vE3s?=
 =?us-ascii?Q?Tk70C/XWJ81+yOFSRqF3gMlcjpHAhJ6yv/x/l2+Em8tbWQgTh1Rw/PfYFLFn?=
 =?us-ascii?Q?TuPT4RO1hugAlidEUS0zCMpriYvODb393o5+7Fq57oPbMAtJMYt90tYriD8P?=
 =?us-ascii?Q?Le/gUFx+5j35wvNiRXENnhqB78Knu5dQRdZeIuCJLOZ8b10akk91PtEoBqp5?=
 =?us-ascii?Q?bN4aKM1y+D+m/+AjspY9pdjGNCjJmjiJOJcLDkKh?=
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB6996.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d113366-c9a9-4909-6559-08db455b393c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2023 07:03:50.7170
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MEvFTCfghItlMEIPmJikHbKZ/d9RvXBK/1aIfMLB8o55ytij08OBNqD1I5IHuZa58W3lQeGsO9A7pvCNPyqgXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB5961
X-OriginatorOrg: intel.com
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Mon, Apr 24, 2023 at 03:04:07PM -0700, Richard Cochran wrote:
> > On Sun, Apr 23, 2023 at 01:33:19PM +0000, Stern, Avraham wrote:

> > So obviously for ptp4l to support time sync over wifi, it will need =

> > to implement the FTM protocol (sending FTM frames via nl80211
> > socket) and use the kernel APIs added here

> "obviously" ?

> In the past, I made quite some thougts about how to best implement PTP ov=
er Wifi.  I may have even written something about it.

Sorry, of course nothing goes into ptp4l without your approval.
I was not aware about what you previously wrote on this subject.

> In any case, "implement the FTM protocol (sending FTM frames via
> nl80211 socket)" was definitely NOT one of the approaches.

My understanding was that 1588-2019 and 8021AS-2020 mandate the usage of TM=
/FTM for PTP over wifi. Since FTM offload (as it is today) is not reporting=
 the raw timestamps (only the calculated range) and also doesn't support ad=
ding the needed vendor IEs, it didn't seem to fit.
Can you please explain what I am missing?

> Wouldn't it have great to start a discussion before plowing ahead and hac=
king something into the kernel?

> Oh well.

Having the timestamps of the frames seemed like a basic capability that use=
rspace will need to implement ptp over wifi, regardless of the selected app=
roach.
Apparently you had other ways in mind, so I would love to have that discuss=
ion and hear about it.  =


Thanks,
Avi.
---------------------------------------------------------------------
A member of the Intel Corporation group of companies

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

