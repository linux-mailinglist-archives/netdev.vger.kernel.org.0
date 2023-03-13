Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 532156B6DF6
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 04:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjCMD1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 23:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCMD1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 23:27:31 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072A13772F;
        Sun, 12 Mar 2023 20:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678678050; x=1710214050;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ofbhP8Ns0txw1o+agyXGcAHFA7P40RTw8vyxgKcrDuI=;
  b=mQsCqpUA1F3DF3O9sMIDxvESz1w0/3o53vTYA+MfyGWCUsQFUIA2Aqjl
   BHOqM56WcCELYP8o3NiAWPiLKfA/2bFM6ocal7Hsutz0YRSSMmQR/bpOS
   bKAjCF0+QmV4BOdjdObvex+628CK2IoWfUed9zRxmeUZmk25jjOdNsyoU
   iW/Mw25t3/aLQvmhsi8YIosgh79rBijs0OALq5kkfpqI7XYADIUUmGm9G
   Z8R08lmoU2KBDIlRqqfzuzw+tHY3T3JbzKE74d5eZYTE6d7Fxu4n5tyz2
   seM3/8pI48ES8QgcQ6wtBdsp6SKKRWhc5HwVt17R9Gaj/NVZArwY1LAEP
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="423316643"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="423316643"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 20:27:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="852600184"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="852600184"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 12 Mar 2023 20:27:18 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 12 Mar 2023 20:27:17 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 12 Mar 2023 20:27:17 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Sun, 12 Mar 2023 20:27:17 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Sun, 12 Mar 2023 20:27:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lfUyj6ItJEfzK92dAf9ysByB26wLWqZs0X2KQ+N6AELEB0GUuYLVKJJUMLKLrr0a0iSpgI6qeSw1zc8OzRnchlC8l8EYSclW23VQJzdkvctGIJPewGkkWoKwBWcbt/POI479Ebxsf3N8IAYNqGKTHp5aNAUwCRqygZ+9Sp/11djSvVrkE0wCdcgkZJwKqtfQKA23niEo65h+LmFhbXBX5Q0vkdMkjdWCd9gC7eQlXGvbf1d06+DEkdJ7p3pCTIY5IaIdqgOAxvqID3M8LtjWGf2iw374Q5lJGXKY5U0AjdHJAm6MyCbMEiUfhhcXBzdSb8l9faHYB90IBjiKLeCR+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dn87tkO/9/ayPX8gDdIhM649HzPCzQn5jQokhYPWj7c=;
 b=V1SPfqQXR8RPv1MiGIlGKw3DP3QZ8v7FBfZaxb8yeoFuXHepsLchgQPD5ZhwXyZNfYtOiBCozXgN6hkSfIpKgMuSOZ+4VmURkzKqgo8cBcyGT7cZf62E25PjAoXHjuaPPZBr3coXJaXzW2Fs9epGLnH+OGXTMUNXdyeQcjgQpT030dhd14u3kZ9wDWhAO2PnNoFn9nDVbb76nptMeQb9R3e23qn/X2sw0eqOv/RwfXyzsirWiZZKRtBhSn1CBgX5/S9IGYufsHP7CzUUTVUsgwerdbwqguFQw5W+439R7mGma0WnaNCzN2Cus3LRKj/A9J2d7z5hVJpHZLAzxONUvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB4045.namprd11.prod.outlook.com (2603:10b6:208:135::27)
 by PH0PR11MB4935.namprd11.prod.outlook.com (2603:10b6:510:35::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Mon, 13 Mar
 2023 03:27:14 +0000
Received: from MN2PR11MB4045.namprd11.prod.outlook.com
 ([fe80::6515:e7bf:629c:e141]) by MN2PR11MB4045.namprd11.prod.outlook.com
 ([fe80::6515:e7bf:629c:e141%3]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 03:27:14 +0000
From:   "Rout, ChandanX" <chandanx.rout@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Kuruvinakunnel, George" <george.kuruvinakunnel@intel.com>,
        "Nagaraju, Shwetha" <shwetha.nagaraju@intel.com>,
        "Nagraj, Shravan" <shravan.nagraj@intel.com>,
        "Sanigani, SarithaX" <sarithax.sanigani@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH intel-net] ice: xsk: disable txq irq
 before flushing hw
Thread-Topic: [Intel-wired-lan] [PATCH intel-net] ice: xsk: disable txq irq
 before flushing hw
Thread-Index: AQHZQgJJhbwLfDw9FUyX83ekMkkjFa74MrmQ
Date:   Mon, 13 Mar 2023 03:27:13 +0000
Message-ID: <MN2PR11MB4045E5FC83D6D3EFC35A0AD6EAB99@MN2PR11MB4045.namprd11.prod.outlook.com>
References: <20230216122839.6878-1-maciej.fijalkowski@intel.com>
In-Reply-To: <20230216122839.6878-1-maciej.fijalkowski@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB4045:EE_|PH0PR11MB4935:EE_
x-ms-office365-filtering-correlation-id: 4670c36f-c081-4031-5acd-08db2372d6cb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9xqMiuPArcbXoHOC2T5UhTa29J87pio9iZAh8C5m34caV9wkpI9G/S1lOUue0ezJWEs3ffT1Eg2/ZJNHa1GZFyVgX9xaqMZrFx2uZq4shEVWNCnfOT6VsgUFHoLmp8YDXyr82IrP9EHiYW+5gJ7PTy+Z6mFP3Q4FAJxPZ3SrM2YsPmBqaHB77H4ACf1+UsKbIqnDAOYCdb+UUfUzC2wC2eOzb8GzWbxxmbrJdKr02i0raC1rK73MEPle+HuYAt2C1E4G0x0LwLrQBgvVvhbmtuuA8v8gL0jbfhrzTX7i7Gep6QNFtmj0x8fsZmlu71d8hC0E2tYXK+6/fpkcbq1dXhYNk9CQWGf/V4VaL/cbQty6YAmZiRRsF9PdwCfEgmjYaJp9a0+YRVXNi9OFlFmpzpo89XbB4+9uCUayzObeE3yRlRkzKrJbCA2l2n24zF+QcORalZfqW6a5ouJpnhsSM+v7PjmuTeAyXtsfY0kx+2446MSrPH5i0mFuOJ9HGCjOfsJUqdy8ZDDg3qApexRAJnBmmDeTJY3o86tDi9P3t45mG2nb2griGje4WUZ/M6jfy+cWhYcNnPzKNnQslNzScUsZ7ib0+eWTfM7xFC0iR+pK9N8mXp3b44lQjIQm4SOcOKT+tMp4C+ShrULJZuIloc8aOJ4BsIPpDWHp9bnP70Lh82zZT7ZJNxXGMIkauJr3WEhZYjmvU+D6FfLDI8/Rpw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4045.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(39860400002)(376002)(366004)(396003)(451199018)(38070700005)(316002)(8676002)(5660300002)(26005)(2906002)(71200400001)(52536014)(8936002)(110136005)(76116006)(66446008)(55016003)(4326008)(33656002)(64756008)(54906003)(86362001)(478600001)(41300700001)(66556008)(7696005)(38100700002)(122000001)(66946007)(6506007)(107886003)(55236004)(66476007)(9686003)(82960400001)(186003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sPpfj4v9CoIX5zXnohrk6EHC6BciY7VqEyugQR8yGwead2/vQ/as6zwo3KPD?=
 =?us-ascii?Q?WzBEp3I60uy6PNFbC0wEfZ1qcd1H/rVEylD0PXAOVRghK9WVXl0mooWXif5i?=
 =?us-ascii?Q?c2gZW7GKHgyfLLJCKIDr0TP83UsXfQiht+XZOf09BpeC3+knNDHiJWIK37NX?=
 =?us-ascii?Q?boIzOkGOl7knuxiSpS2BonavPMnbWJ5VV7CyMnCT0gvaKEI/P0FmdoDJa2Mh?=
 =?us-ascii?Q?DYSCvKJ532Dbfi3nPavjGKrvTWHni8h/GdhLdropp70aOWuPrNi3DV8Y22ju?=
 =?us-ascii?Q?60XEWN0UEbZ46jfrmVwpUo4mg0y/eRRTzZ4e5A+nwPpb3Bf6ed91cfZfI0JA?=
 =?us-ascii?Q?2IqNcaBzQvrhZwPlcT/MGrHhdRsD9pU4M+wEScpyTSGY9JqvKH1sLf9mCt3z?=
 =?us-ascii?Q?BK97ijOJx2tmaLkiWVOLyjauaTBmifrCzD4c8Hw93eeSKhDEsu20ZS7GagGr?=
 =?us-ascii?Q?aXAD0PN4PqoRXLHbYJj1pJk+GGHiPR13BGf235Z/JPjkc1ZRtKd6+SMEBGqv?=
 =?us-ascii?Q?L8KCAaP1cXLpQhj000fZX2hB5biG1pFJzTf2GSrexKDSaYqadySxcTv/QXRQ?=
 =?us-ascii?Q?A9RmcDuC9NVRp+ukxCm5ePa2bHc5+AtkDZNZqRtTYHDn3v0jQ0CNL+QAez/q?=
 =?us-ascii?Q?qQKLEedfLLOegYF+ha5PEmbE3MOC+6eVaK/G2TJgXjA7GRlWojNihaqyDdnd?=
 =?us-ascii?Q?8jtam0eUKxhNF0xA01WSbwFfdor4Yr6qyDpsQ7BfwZfnXcolb/WLXRHmqMEt?=
 =?us-ascii?Q?jzfZFsszIxzFyNH60zVfsxqqWGerOD93zDeTmOOUpsambMk+9iGW0ZVuJX9F?=
 =?us-ascii?Q?uBHlvacA13jGlBf9loA4637Qhlgnc59cDlIc9lP52wLacZqcWprX96IuNkfY?=
 =?us-ascii?Q?kobXF1k9eLDvV6KZFa33+g+7SJIVddFHWt+LtIH999iLzm2b5u/9ZWOTiQDZ?=
 =?us-ascii?Q?LFNxJbHVi3e+QVuAlY6JcSC93DGUPBG2AIONE95NYrJRs2V2c22T/oc+lczg?=
 =?us-ascii?Q?GvKsDMny620vnqUOaKrGva+hXp9Mq3GnixX5s3uTLMMdscjGOGtBKvf7jjx3?=
 =?us-ascii?Q?/RkbjfwGTUtfqOZWxabmjGLJ8QsziLlY3RBgTsDcTYibH0dXKdl95C3ro95I?=
 =?us-ascii?Q?FShhdsNIMkTpStnZl2bwcp67LeG+NMk3t3EItIb9ZkcrcSUT/VvX10mF+8jg?=
 =?us-ascii?Q?laM6/9g5pUNE5ErzRXIMzNVoSSRSdM1+CrHVDhXFwsBDiDdcALfrHsMTZ5fD?=
 =?us-ascii?Q?CDD7pMYRgcev2V3iQ8cS7/nGUpUIdHO+rz/1jzBUV/Rr/kXu2QoOKWwO5p5w?=
 =?us-ascii?Q?p2XxgoQj6f2ZY4dr5mMkNkx6beGWf/TplCcQfi+YOCQeztBADLwTEpPTt3UX?=
 =?us-ascii?Q?lUiQ+qiJYxj3/BwmEVgiDP/EWO4h0b/ZHdImOabRYAuRlvsm9C1IYXfsfM9E?=
 =?us-ascii?Q?Fz4Xt0Vr1bhUdnU0wfwRaAtSYBSXZGQ/vtLYhy+69nJNDDodoMsJx4Jk3XXk?=
 =?us-ascii?Q?a4hWHztZOw8BFZtAr6PZMEm8ZHcTlSINbV6L94LVBv1ZPCrxM9wjvpqZ6+jK?=
 =?us-ascii?Q?CMZDwqBbkjlpQEzv7voQrJ1rBivzOmTzR51WCe6w?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4045.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4670c36f-c081-4031-5acd-08db2372d6cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2023 03:27:13.9327
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h9HRIkkfh2l7/B6C+O64m/hmGwRg/WR/u6noDvDn4KeGxmb4368DBrqMCPndz+Zzc5fbGmbqnZV+1sYkT1E/0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4935
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
>Fijalkowski, Maciej
>Sent: 16 February 2023 17:59
>To: intel-wired-lan@lists.osuosl.org
>Cc: netdev@vger.kernel.org; bpf@vger.kernel.org; Nguyen, Anthony L
><anthony.l.nguyen@intel.com>; Karlsson, Magnus
><magnus.karlsson@intel.com>
>Subject: [Intel-wired-lan] [PATCH intel-net] ice: xsk: disable txq irq bef=
ore
>flushing hw
>
>ice_qp_dis() intends to stop a given queue pair that is a target of xsk po=
ol
>attach/detach. One of the steps is to disable interrupts on these queues. =
It
>currently is broken in a way that txq irq is turned off
>*after* HW flush which in turn takes no effect.
>
>ice_qp_dis():
>-> ice_qvec_dis_irq()
>--> disable rxq irq
>--> flush hw
>-> ice_vsi_stop_tx_ring()
>-->disable txq irq
>
>Below splat can be triggered by following steps:
>- start xdpsock WITHOUT loading xdp prog
>- run xdp_rxq_info with XDP_TX action on this interface
>- start traffic
>- terminate xdpsock
>
>[  256.312485] BUG: kernel NULL pointer dereference, address:
>0000000000000018 [  256.319560] #PF: supervisor read access in kernel mode=
 [
>256.324775] #PF: error_code(0x0000) - not-present page [  256.329994] PGD =
0
>P4D 0 [  256.332574] Oops: 0000 [#1] PREEMPT SMP NOPTI
>[  256.337006] CPU: 3 PID: 32 Comm: ksoftirqd/3 Tainted: G           OE   =
   6.2.0-
>rc5+ #51
>[  256.345218] Hardware name: Intel Corporation S2600WFT/S2600WFT, BIOS
>SE5C620.86B.02.01.0008.031920191559 03/19/2019 [  256.355807] RIP:
>0010:ice_clean_rx_irq_zc+0x9c/0x7d0 [ice] [  256.361423] Code: b7 8f 8a 00=
 00
>00 66 39 ca 0f 84 f1 04 00 00 49 8b 47 40 4c 8b 24 d0 41 0f b7 45 04 66 25=
 ff 3f 66
>89 04 24 0f 84 85 02 00 00 <49> 8b 44 24 18 0f b7 14 24 48 05 00 01 00 00 =
49 89 04
>24 49 89 44 [  256.380463] RSP: 0018:ffffc900088bfd20 EFLAGS: 00010206 [
>256.385765] RAX: 000000000000003c RBX: 0000000000000035 RCX:
>000000000000067f [  256.393012] RDX: 0000000000000775 RSI:
>0000000000000000 RDI: ffff8881deb3ac80 [  256.400256] RBP:
>000000000000003c R08: ffff889847982710 R09: 0000000000010000 [
>256.407500] R10: ffffffff82c060c0 R11: 0000000000000004 R12:
>0000000000000000 [  256.414746] R13: ffff88811165eea0 R14: ffffc9000d25500=
0
>R15: ffff888119b37600 [  256.421990] FS:  0000000000000000(0000)
>GS:ffff8897e0cc0000(0000) knlGS:0000000000000000 [  256.430207] CS:  0010
>DS: 0000 ES: 0000 CR0: 0000000080050033 [  256.436036] CR2:
>0000000000000018 CR3: 0000000005c0a006 CR4: 00000000007706e0 [
>256.443283] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>0000000000000000 [  256.450527] DR3: 0000000000000000 DR6:
>00000000fffe0ff0 DR7: 0000000000000400 [  256.457770] PKRU: 55555554 [
>256.460529] Call Trace:
>[  256.463015]  <TASK>
>[  256.465157]  ? ice_xmit_zc+0x6e/0x150 [ice] [  256.469437]
>ice_napi_poll+0x46d/0x680 [ice] [  256.473815]  ?
>_raw_spin_unlock_irqrestore+0x1b/0x40
>[  256.478863]  __napi_poll+0x29/0x160
>[  256.482409]  net_rx_action+0x136/0x260 [  256.486222]
>__do_softirq+0xe8/0x2e5 [  256.489853]  ? smpboot_thread_fn+0x2c/0x270 [
>256.494108]  run_ksoftirqd+0x2a/0x50 [  256.497747]
>smpboot_thread_fn+0x1c1/0x270 [  256.501907]  ?
>__pfx_smpboot_thread_fn+0x10/0x10 [  256.506594]  kthread+0xea/0x120 [
>256.509785]  ? __pfx_kthread+0x10/0x10 [  256.513597]
>ret_from_fork+0x29/0x50 [  256.517238]  </TASK>
>
>In fact, irqs were not disabled and napi managed to be scheduled and run
>while xsk_pool pointer was still valid, but SW ring of xdp_buff pointers w=
as
>already freed.
>
>To fix this, call ice_qvec_dis_irq() after ice_vsi_stop_tx_ring(). Also wh=
ile at it,
>remove redundant ice_clean_rx_ring() call - this is handled in
>ice_qp_clean_rings().
>
>Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
>Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>---
> drivers/net/ethernet/intel/ice/ice_xsk.c | 5 ++---
> 1 file changed, 2 insertions(+), 3 deletions(-)
>

Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worke=
r at Intel)
