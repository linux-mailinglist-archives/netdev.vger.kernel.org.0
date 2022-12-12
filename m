Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7EAE64AB87
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 00:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233935AbiLLXYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 18:24:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiLLXYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 18:24:31 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B60413DCB
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 15:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670887470; x=1702423470;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=BjSGq3K0r9Fnf+6yMSCAlKGt4n/4aL7zGIl8FQRHS4A=;
  b=XLWcgPEnp4rj0HSEbn09VcoTMS6GgugbCYLf3aFnl5gKeQe4X58F3tcN
   FClkVFZPP9a5qEf4aLIk6PcTTWZ/xwSEXkzLQZGlfZViYvABTmvBjJNwG
   9i/p9wOI9nIh+velmTENW8WvjnpmKXpDhA7y4J3SLf76YPp/T1YzCL0Fy
   61SEhGoFopEIUba+g2PQhZ9VEcTZRp+DyWisbBiFBUSLqaokaNdyRnGXf
   5sc0/AUhCs0JZ8F+ke0sWqwB7+3PkgNtFWTwKuVZWdErWF8Pv/ztUAt+z
   cb295Htvkg9fN3ekHrKVsLOfBUP337MAmLg6q/PAGyH6H5oNdFtjvzg4f
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="315622665"
X-IronPort-AV: E=Sophos;i="5.96,239,1665471600"; 
   d="scan'208";a="315622665"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 15:24:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="755146400"
X-IronPort-AV: E=Sophos;i="5.96,239,1665471600"; 
   d="scan'208";a="755146400"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 12 Dec 2022 15:24:27 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 12 Dec 2022 15:24:26 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 12 Dec 2022 15:24:25 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 12 Dec 2022 15:24:25 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 12 Dec 2022 15:24:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WfVJIjsL3RLQx9DFpuKyqv0aC9YBEwyluTz4FiwLzPp2U6xAjZ2VK4rXOw2P0tlRgCHjC4ILfywCMFciAUCZzngKfVwznTM79rt8l/oKdWk2oaKC5pe+oRCFuWte96cdQCyGJnGuYFD35e/cOm0AXsbs5WbinXl9se7sWVAwZ6HFqvxu/TNYuuZ1wJYtUlMth5WeMIIz7YWRNeLlImxfMKz+cCksBTOlNwsaHvyZmIcCa4m0cl7DcEKAxA2fC+6sQcF6y4krRJg7bi+sUwFeqLFaQKTQq1n7ZnpFupp5rdslAbZ6SEETkdBknfoOTtENsX7sg3sWBj+mWpQhIY6llg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RivYLMiQ2FwJJVReSvLyvUO75bXtEQh9d9e5pz5/ZDg=;
 b=gWOgAvicDxiUkt6Mraccdi6I4MlmQeid+xBwANSrYidC9HInntp9M2O/KW4ZAMvx3POU5tDEXR6C+jkPpTpfSonestTM/mQeNhaE71t6/eIF2tTV3ALXXkhve2kh4O6F2cEdo9MuorXknosz4UjR06PXy38euqCFwMg1ztq2ukqAmnlQz4Dj7mCbfCXGx1Op2wviydsCLPhfIUNlntWDXpbO/Egr9QVkbx9iTexCUnEe+ewlwJZ9wZ/FQMN3lU89CE7ToQ8x8gCcC0IBhWyUGqfhyggMQRSJVigfqEI0U9psSwUdPWrY5NlOWTBnumLZ+iLlXkk/AD0oPu72qwMRVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5800.namprd11.prod.outlook.com (2603:10b6:303:186::21)
 by DM4PR11MB6480.namprd11.prod.outlook.com (2603:10b6:8:8d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 23:24:22 +0000
Received: from MW4PR11MB5800.namprd11.prod.outlook.com
 ([fe80::1bb4:f79c:3fe3:17eb]) by MW4PR11MB5800.namprd11.prod.outlook.com
 ([fe80::1bb4:f79c:3fe3:17eb%7]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 23:24:22 +0000
From:   "Kolacinski, Karol" <karol.kolacinski@intel.com>
To:     "richardcochran@gmail.com" <richardcochran@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "G, GurucharanX" <gurucharanx.g@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH net 1/4] ice: Create a separate kthread to handle ptp
 extts work
Thread-Topic: Re: [PATCH net 1/4] ice: Create a separate kthread to handle ptp
 extts work
Thread-Index: AdkOfyojp0caeL/iTkKHuFogyEtrIA==
Date:   Mon, 12 Dec 2022 23:24:22 +0000
Message-ID: <MW4PR11MB58009DD3EAA0A235BB8F347986E29@MW4PR11MB5800.namprd11.prod.outlook.com>
Accept-Language: pl-PL, en-US
Content-Language: pl-PL
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5800:EE_|DM4PR11MB6480:EE_
x-ms-office365-filtering-correlation-id: 827b17bc-253b-455c-4dd7-08dadc980061
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /cC+ZtQPhssvV6GZS6upZqAKyRQQZbAFyiR28z7713SWSFJSMhTNET2FLepxxuEnMi7E3E3fV9JXftpSGVumLwCO2AwpjNKG5UyXQZR5IK13fxH5JjJWtLGDRN10nHzuvmFH/LFCFQIOEhviqHdLTgTRysbIpBdNc/wEaSR5wCmNuO3aRX1eWHiVP92H+XKhy4rWxTlmSMtSi/uLl4vd1QstURobnHcAo8BUh2cd5HFsgQeBP2NnTABp4Kqp7j2U5IvlOohIaBMB2CW7MChS4kiOc8VAwaPWNx3bzfEC+I/XB6CDBqhvzyISTK7eSo08Ieb5s+9FoXRV5zmW3vQvmgUb3+Re5R0rfJMqG8wpdGd66Id4eIdNK2T8+zs4krCMEtQz0LJmzrrm2+2hcCp4KfiFFWqRoLJvugIO1pOf6JtLW9bRJSg/YcYgsTqBJtITyH1cndnMD4VUH9rxWPHm0i3uMb3n9spHfZ7ALk/kP2iWFGLwkZSqiOw5N3p/qm4iR0fRiQhrU+PixtzLR8ev2k7SVE4JtiAzVUqhwLSCDR9rh9PpARZTd5c4EtnxGrc+GW1q4p+f5PmRzf+kUi2b1LfYkEGHDb0ERZHa8x3DYHes1XwYRZfUlR/nyPNitJ8nL0yGReYXvkucJ8+Xu4U0aLkxTxhRiH3GYF+a9mtYXQ3r6NbgZan7pCVCu0y5iAs6qWXcC0Z5Miu5I0i3DAfZ2g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5800.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(136003)(396003)(39860400002)(366004)(451199015)(83380400001)(82960400001)(5660300002)(38100700002)(66946007)(76116006)(71200400001)(86362001)(478600001)(9686003)(52536014)(186003)(8936002)(66476007)(41300700001)(6506007)(7696005)(38070700005)(66446008)(4326008)(66556008)(8676002)(64756008)(6916009)(26005)(316002)(33656002)(54906003)(2906002)(122000001)(107886003)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mW+/Acz/jTX0ers1En8z30yPDT2YvEoPNljUVQakwanDAAdV8cXrOd/kKfUk?=
 =?us-ascii?Q?vJGIn5jZLaeBPFPRZe4Aq76CtDhKOg2LJRqPGDkzXcFmLR9labzSlV0fi2q6?=
 =?us-ascii?Q?UMtjfnWunj2Lr/+9By46zgmcmX41Wr7B9Av1HfWGAg7he7kK8PuzWHNI7F/b?=
 =?us-ascii?Q?e7MIU3MrQJJobwbe76r+zQXH+PSD8+B8lRhwsigddH4hZ+VYtkjO8NKwAwvQ?=
 =?us-ascii?Q?5TEaClKhRhyTdORCFrum47UNcWmSd+1U5b3nKIE+0p/H0proAkBpDUvq+BzV?=
 =?us-ascii?Q?xZDlThZ4kM0Cmqr2DJpYlkI+XJx/nlZPNmgpR3+jI5KqUL3RUBcltYrKTuKK?=
 =?us-ascii?Q?xfQdoJ+i6NCjBWXwJ40tB1brkXNG2fuvL7PEhvZzj0K5AcqIgoOBcoo79gXm?=
 =?us-ascii?Q?fUDRfm9qNwr9iah6yF2Id6FASWfS8CN7Wd5OdC/du+6MVqAWiaQCX516lphl?=
 =?us-ascii?Q?y160kNxwOc114iuGSZEn7QVkMPOz8BKCpE0ynkOlmsVZbD8E2OXhQ/Vx/5Dm?=
 =?us-ascii?Q?qayGvndSMtFDWSifz6GSCCsjO6wEb8seUxbE10rbjTnIVaFgEe6XqDDOE8yb?=
 =?us-ascii?Q?Q3XoXmxVx9RCMM/zE5dh8LO40PgSeQmRwXBDBqnPhGbC8EK9ZFwQBA1+TUB2?=
 =?us-ascii?Q?wx+C7SyFE6mxRrAyo5GQkup+wy6Ny7jzD0E88ywm05pzXlquawo+IHFN9Xls?=
 =?us-ascii?Q?A0JxoPYywobTdL45GOamKiEG+rYznUOMqXgioyzUD+Z9oAYBa/zj4INcTTfC?=
 =?us-ascii?Q?eOX+MzQRj66lmLffq8y/O/iwB2cgU1QeqPPH64tOHk8IWbkpYWD3ikwEovsE?=
 =?us-ascii?Q?O38+n59V9/7XBVY+lUyCas3MKaZ4ApmdHsId4n8EQjXaZfUvW+El/ztjYDwR?=
 =?us-ascii?Q?ifWQQ0Rh18cXZg06j7xQvqup7jIvW3mTqHK0KeiZ5gbtqHZNM8vnFbRSnpm9?=
 =?us-ascii?Q?sW5CWrhzdIftpBsbtBoVr14gWuspBxXD9iDZWSa36L9QhPGQwPat2yN4fIs/?=
 =?us-ascii?Q?im032pf7E6eH+q6Ae//KPQ88oS1NW1o9QNHIa+D7TsxQsBn1DAkJlDHj4hdC?=
 =?us-ascii?Q?/Fn1FXZ7txOT3CdJg5iYtDh0hrlJDtQfvRZqDfc9mYREyGJodCqSwAs2BUxX?=
 =?us-ascii?Q?b+XgO01x2w8NRlh+lGl7LdcY+2+wDUessjQcWS1KVBfgTxTjX/SGlZqAr7z3?=
 =?us-ascii?Q?9pBWHJQSPifZPpUGbBU3yXpnW3vgj+4Bv8jXKe0QHk3/LE1bM4K1s3I+2iSx?=
 =?us-ascii?Q?+UJvvrU3Z3YcXVz2V5C/zrRmz49y3dGl92Ep5efSAHhJiUrWKv/+6S0wfgSj?=
 =?us-ascii?Q?Phsu1+98KWImAchgjeR/Q8RPUHUw8bu0k6mHxLT3dlCaSOOJSGIsJQq4rVij?=
 =?us-ascii?Q?U3oPPERUbKe47byJOShCFBDLUweMyx+k2NxpAC2hE/pSJ5xWA3v0R/Rlu74U?=
 =?us-ascii?Q?rKFPYHlyQknTc6O1l3M9uiy8ItkInaHlZQZGHYJCLKDLs/msyCZueF0mbA/Q?=
 =?us-ascii?Q?ohkZBOkSvplPkVq5AXJejQzTL9TOATMaA0vPWWQYwoaVbDbTMHRQ1PTkByt7?=
 =?us-ascii?Q?UlHfOrOENKARfsnlXe/zriGpq6GH6LfsLw6sLdFo?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5800.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 827b17bc-253b-455c-4dd7-08dadc980061
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2022 23:24:22.5238
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KhRAcf/Z6jIFeAfovjaSH3vMqV5pi1u3u1hS0xCx6OcqNNdiScERheqpbc6eb0TdRNf+TwhsaayYSC1XpFDT49jisV5lVHwtg2+Ze9NBVxA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6480
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>On 12/7/2022 4:27 PM, Richard Cochran wrote:
>> On Wed, Dec 07, 2022 at 01:10:37PM -0800, Tony Nguyen wrote:
>>> From: Anatolii Gerasymenko anatolii.gerasymenko@intel.com
>>>
>>> ice_ptp_extts_work() and ice_ptp_periodic_work() are both scheduled on
>>> the same kthread_worker pf.ptp.kworker. But, ice_ptp_periodic_work()
>>> sends messages to AQ and waits for responses. This causes
>>> ice_ptp_extts_work() to be blocked while waiting to be scheduled. This
>>> causes problems with the reading of the incoming signal timestamps,
>>> which disrupts a 100 Hz signal.
>>>
>>> Create an additional kthread_worker pf.ptp.kworker_extts to service onl=
y
>>> ice_ptp_extts_work() as soon as possible.
>>=20
>> Looks like this driver isn't using the do_aux_work callback.  That
>> would provide a kthread worker for free.  Why not use that?

According to do_aux_work description, it is used to do 'auxiliary (periodic=
)
operations'.
ice_ptp_extts_work is not exactly periodic as the work is queued only when =
the
interrupt comes.

Thanks,
Karol
