Return-Path: <netdev+bounces-6602-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CAD4717118
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 00:56:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23ADB281388
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 22:56:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17C4D34CCC;
	Tue, 30 May 2023 22:56:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A190A927
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 22:56:24 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D675612A
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 15:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685487370; x=1717023370;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IgReLy1ADzwDVVzvGQDjl46bx+ub05f50rYGa2SrBNk=;
  b=JV90/caDXDGcqOljQhQ3QTOOl8Vbs1LYT2br+6aeFFY0M2qa6uy6IP7u
   Y1cTlKnsQZWcBeMA3eq2dswhnL+ayzW0uCg7RM/x0P/8Rbk/681tNsmNR
   gc+AGBaAIyTpbc+4PikDqJsatARN8T1cEir0kEUKD2+hopG/wAMrwT6O8
   cQ6vdqBceIxO+imozjgrtm9JeaEpaUYnSGZ6XQxEaBAQY3acSmnTFZC9m
   KwakyEpLN4aecP1EG+Adma9TLqMBqvtBb64KiHBEJGCkXfrfyHltVEJcC
   w/6SJLD3PhLvPX6anyeu9ISUXZdrI38RBIsdRBbMz7FxRt+1R7nWHfSYl
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="357454993"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="357454993"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 15:56:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="700824648"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="700824648"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 30 May 2023 15:56:08 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 15:56:08 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 15:56:08 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 30 May 2023 15:56:08 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 30 May 2023 15:56:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oUu07gltcGd+2JhPZr6Tvyd/0fdj7Q1tHOQtIefq6gS97/IpX+VzYgU8lHeyL6TX7m6bplj51qEoV/HPAlGFAmIqpRiGLgH/YMue4YqJo2dDfMA2Th5rp07hD3yvB0VlgV23Zll9QkmU/lVtoQfLn64S7Nn/LoS0XJ7Z1yCWfVhec2iNW7Q5T+aLSWihVWU6707fNpB0F8rk8uWTMJcQuubA3AcsvFoFH/IVa16NGjVZmCQF36OE24Earbz3OTn/r5wV5lkP9iUAl8UtL/rnAmmrHmi6VckTv00Cfo9Y/Inj1YLG938TtAY5r2FFkLujVzLfRiGFvcC8ZBjJiLalKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hHN3WTJq2QY+BmsmibMhy0ApXC2JIwg+uPx7+REqICQ=;
 b=XU7x0x1iuzSRDuzKAqTgWfF4rkhjBw/j09ZSxY+3ze/KbKj0ygEvb6CCKcbkn2ouzcbyJI8bRO21uZZ/7/NGL4THTS5P6zKTGBNfEoIudrXtUGzZ/rWm5KFrAIh45rgro26qG5vYLLglIQ8056n+DqEHYrg2N+I8phdXdWC+DuuJnsrGPW13mItCEIR7z6FM8KsosmtgXQufwJcVB/hxG8AQhSAJfmsyQIGowPrramiO3FsZUxV8Mrsvs0ORDDUDuh8cgbGMA4fMl0uUjPxeC8CA8Fu16NKiPUYb2+3bRISwRPznj49ghxIzmqT1dmPhHalhFF8FChUtri77cKxbew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5911.namprd11.prod.outlook.com (2603:10b6:303:16b::16)
 by PH0PR11MB5174.namprd11.prod.outlook.com (2603:10b6:510:3b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 22:56:05 +0000
Received: from MW4PR11MB5911.namprd11.prod.outlook.com
 ([fe80::d06:5841:d0e0:68b8]) by MW4PR11MB5911.namprd11.prod.outlook.com
 ([fe80::d06:5841:d0e0:68b8%4]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 22:56:05 +0000
From: "Singh, Krishneil K" <krishneil.k.singh@intel.com>
To: "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC: "willemb@google.com" <willemb@google.com>, "pabeni@redhat.com"
	<pabeni@redhat.com>, "leon@kernel.org" <leon@kernel.org>, "mst@redhat.com"
	<mst@redhat.com>, "simon.horman@corigine.com" <simon.horman@corigine.com>,
	"Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
	"stephen@networkplumber.org" <stephen@networkplumber.org>,
	"edumazet@google.com" <edumazet@google.com>, "Nguyen, Anthony L"
	<anthony.l.nguyen@intel.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "kuba@kernel.org" <kuba@kernel.org>, "Burra, Phani
 R" <phani.r.burra@intel.com>, "decot@google.com" <decot@google.com>,
	"davem@davemloft.net" <davem@davemloft.net>, "shannon.nelson@amd.com"
	<shannon.nelson@amd.com>
Subject: RE: [Intel-wired-lan] [PATCH iwl-next v6 07/15] idpf: configure
 resources for TX queues
Thread-Topic: [Intel-wired-lan] [PATCH iwl-next v6 07/15] idpf: configure
 resources for TX queues
Thread-Index: AQHZjQ1SmC171qXPw063lp+UHZq1cK9zeY3A
Date: Tue, 30 May 2023 22:56:05 +0000
Message-ID: <MW4PR11MB5911630B6E39F863C9BBDD8FBA4B9@MW4PR11MB5911.namprd11.prod.outlook.com>
References: <20230523002252.26124-1-pavan.kumar.linga@intel.com>
 <20230523002252.26124-8-pavan.kumar.linga@intel.com>
In-Reply-To: <20230523002252.26124-8-pavan.kumar.linga@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5911:EE_|PH0PR11MB5174:EE_
x-ms-office365-filtering-correlation-id: 19ab91ef-63b2-4330-39cb-08db61610cba
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R0Bfx2nfT/1AkpjaXgOxtZ+TuLP8xAD7ESTf1bkv3ijUSGOnz/WkogoTRavHcXQyNhoN6yh3aobqbXy7RRFu6NQ/4+p3kiMC/LeC/OdmSe/MaUnU4VHEsxpn6CCypUCwJeWpC0TsOet77Yx4Fv1w3bJntkA9VaSTgumrMjFxycCE3aUXMSLDP6o/sO0RjPMmKvQO+Amc9CIziDVJBTrs9ude9TplxWCUqijEFUUUIaL9B9cYUK2kqfply87GpD+FLg/NqwhBy6KMpyw+V5tXN7T0M4Q6KloJ0tLbauAAG+a/htdJ/JyH6Dsr8bTxkqVHniQLAU+i8Lygi+0r223qDqAP6B9qQWWybo/H29m9YH9XrXBx04vIlF+FAdWIGw6Z1ek0iO6X8Sk4j4dJ7q3WaHU1+7GxkYFnNxG/GJ+sA2C2iIdzAbF3UGvm2TkG5AbP9jFOkNi5VThM5S/CFhmU0enJuK0GMuGIkD322/RyO6UpKJ9ABJwqX5GTDtKkvok43KD/O6wMUM0bP9C6a5aMOHhu8u1J7XOFZq6Mz6k/CV7Y8PEv1GeFj2wZgW7fpivPLabmRFeEQXCu2OdS3vGMhFFstZhf28+zeIjOuoaV5zubo1L9OQJ480M3ENkz1og0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5911.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(396003)(366004)(376002)(136003)(451199021)(83380400001)(38100700002)(41300700001)(186003)(6506007)(26005)(9686003)(53546011)(7696005)(478600001)(71200400001)(110136005)(54906003)(64756008)(66556008)(66946007)(66446008)(82960400001)(66476007)(76116006)(4326008)(55016003)(316002)(122000001)(8676002)(7416002)(5660300002)(8936002)(52536014)(2906002)(33656002)(86362001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kZ4l/hs6pCXlK29HY2Qko5txGf5ZkZu63IZMcS0ghswojbZlmWTUJmk4YXzA?=
 =?us-ascii?Q?Vs9JdzFXit899bkElvAMK463EIRul3i8M6ciTPEOIF/2SjRAFPV2i2EAUkfY?=
 =?us-ascii?Q?z/dG1gc5h2iTnOk2LC2fkXv4rDdLUlUSANGxcmga76O9/P+WoJXA4oNoykOQ?=
 =?us-ascii?Q?mpgPFr+Wk58+IS6scVyko164IhUxVDtcYuKYI5hUFZWZr0Qrj/Cz0gImSPZs?=
 =?us-ascii?Q?lNm7L/Zf+XxdEy+7jxlyNGj4pHciPVnr3nbQ4PRTEctO8s4kwIBjDs6Qb/jP?=
 =?us-ascii?Q?uDMs53plqfIuLQS8ipKhb8rhRoqzKWrMNgGSERb8mFU6XUQ5f3hNNEneFmn6?=
 =?us-ascii?Q?oDjxv+kMlJq/72GhuWIr/dGT4+b9QXaWeXaIc1kWQNwaSmMsxbchiPwHpqjC?=
 =?us-ascii?Q?2S440f6v50V2NDGzVa+cPKGR8PqUMzx9gOon475Ec8YwviLIfp5//S5L2Biy?=
 =?us-ascii?Q?5zDOWQFD2OMpadpOk1XOzQRbURyrkQROlhzrY1BhVVyLuON+PpcB5ojk/hBm?=
 =?us-ascii?Q?V9FM0ItYhqEpQLybtYWiTkVjA/B3VyS3C0z6CM+1pvkbEIkuUM4lJmsmvafL?=
 =?us-ascii?Q?MwIQsFdsMMtffv3C2xJHArsDac2X8eU3nqvExjPBt2VY8PNZXKJA3VQCokqp?=
 =?us-ascii?Q?FDsi5Z/iAYhLChy4lSu+5VKor0JN1hgjIncphxg04wVlqwJqRRV6qVT7ucKP?=
 =?us-ascii?Q?p/4+D2lAL4b/N4bZahjv1GKKvgMeuKLJleprBuf9y2kXcwj9ZxSIeWfQAKau?=
 =?us-ascii?Q?FV7veXU6djPCaBJt6po4zhZTvUUI2xW+eYdJFmpC0nQ3XASV4ClOj7D+y6ZV?=
 =?us-ascii?Q?CYzhpCGK6/ah/JE8o66ckl6ddKOGohYuZ0P6IsO/t/e5bvCbdXsVfcsNddjR?=
 =?us-ascii?Q?SnmIyi4MKVie5wIqoqENJ0w71yt7qssYDRQBONk9bpvrepIPbMxxuxbkDNIK?=
 =?us-ascii?Q?N9f3d6k/xIPADyVB2r2OuzARX7bbPOHwvwwn0eNSjq7+lPKXDQbQ3YcGhZTZ?=
 =?us-ascii?Q?4SiM3nhl1FNew9gtCF9RX3FNBzRvj3CSu4Ch5UdfrF/Np3qPESNdejUkOdOa?=
 =?us-ascii?Q?IAQQLNt+GWLbIPj2vAc6ur8dZyQXq8B0N/Q55wJcdVNkNfwj3P4K/WbPUN7Q?=
 =?us-ascii?Q?r92haw16i82c+7tiiVKZPx6bu5z8t9kRwwARJ1v6kXzWaiAjny8gIH9AIEQG?=
 =?us-ascii?Q?5bbJQy3Rws8Fm5BJ5YskTUPB6Nf8vNDDmtdJCQaQNvP7EsF//wISH0K9pLqc?=
 =?us-ascii?Q?pL4mkbsRKtnFW/GHVfix+9Jew+Vvt/FZacXkgQNKa8m7B+RWn+c35Ef9iZC/?=
 =?us-ascii?Q?4iat3hBHAPy7nhSqntEC/VmmFvWBkUKkFzuQPz8EVGR/ASiHNIDG2FyqXdql?=
 =?us-ascii?Q?lAbYQIqVlTsBUjfygOheeFKnLoAaEn/PwrgMqezBdKQLWP3bocIjWb7ABo0Z?=
 =?us-ascii?Q?BzU2aqL20ZLgZYgcnTxYtfw4J8Nt6eL94aUsgwB4y9bL8QSosjbkZqfwuIMi?=
 =?us-ascii?Q?0R0lUhpiLakC9PQHazjlHgf5x4sKmHadULku+lon0yZAM15whKYbAf8Q+d3y?=
 =?us-ascii?Q?91nubtINe8SuRyZj7P4UtTh7fMDbVLE+gugExRNT2OLm+Xka/TI1hg0U3AcC?=
 =?us-ascii?Q?5g=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 19ab91ef-63b2-4330-39cb-08db61610cba
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2023 22:56:05.5691
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: urehO3I7brQn9VByN5VYjwkpu4HIFomoLUFXsl24WLxRVL4ZYfla+8kdgohn3yKVVAxLwoHs0qTeKmsFjFuwuu1ZB7//iCzSm7k0FIM8uks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5174
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Pavan Kumar Linga
> Sent: Monday, May 22, 2023 5:23 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: willemb@google.com; pabeni@redhat.com; leon@kernel.org;
> mst@redhat.com; simon.horman@corigine.com; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; stephen@networkplumber.org;
> edumazet@google.com; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; netdev@vger.kernel.org; kuba@kernel.org;
> Burra, Phani R <phani.r.burra@intel.com>; decot@google.com;
> davem@davemloft.net; shannon.nelson@amd.com
> Subject: [Intel-wired-lan] [PATCH iwl-next v6 07/15] idpf: configure reso=
urces
> for TX queues
>=20
> From: Alan Brady <alan.brady@intel.com>
>=20
> IDPF supports two queue models i.e. single queue which is a traditional
> queueing model as well as split queue model. In single queue model,
> the same descriptor queue is used by SW to post descriptors to the HW,
> HW to post completed descriptors to SW. In split queue model, "TX Queues"
> are used to pass buffers from SW to HW and "TX Completion Queues"
> are used to post descriptor completions from HW to SW. Device supports
> asymmetric ratio of TX queues to TX completion queues. Considering
> this, queue group mechanism is used i.e. some TX queues are grouped
> together which will be serviced by only one TX completion queue
> per TX queue group.
>=20
> Add all the resources required for the TX queues initialization.
> To start with, allocate memory for the TX queue groups, TX queues and
> TX completion queues. Then, allocate the descriptors for both TX and
> TX completion queues, and bookkeeping buffers for TX queues alone.
> Also, allocate queue vectors for the vport and initialize the TX queue
> related fields for each queue vector.
>=20
> Initialize the queue parameters such as q_id, q_type and tail register
> offset with the info received from the device control plane (CP).
> Once all the TX queues are configured, send config TX queue virtchnl
> message to the CP with all the TX queue context information.
>=20
> Signed-off-by: Alan Brady <alan.brady@intel.com>
> Co-developed-by: Alice Michael <alice.michael@intel.com>
> Signed-off-by: Alice Michael <alice.michael@intel.com>
> Co-developed-by: Joshua Hay <joshua.a.hay@intel.com>
> Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
> Co-developed-by: Phani Burra <phani.r.burra@intel.com>
> Signed-off-by: Phani Burra <phani.r.burra@intel.com>
> Co-developed-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> Reviewed-by: Willem de Bruijn <willemb@google.com>
> ---
>  drivers/net/ethernet/intel/idpf/idpf.h        |  51 ++
>  .../net/ethernet/intel/idpf/idpf_lan_txrx.h   |  25 +
>  drivers/net/ethernet/intel/idpf/idpf_lib.c    | 150 +++++
>  drivers/net/ethernet/intel/idpf/idpf_txrx.c   | 541 ++++++++++++++++++
>  drivers/net/ethernet/intel/idpf/idpf_txrx.h   | 176 ++++++
>  .../net/ethernet/intel/idpf/idpf_virtchnl.c   | 402 +++++++++++++
>  6 files changed, 1345 insertions(+)
>  create mode 100644 drivers/net/ethernet/intel/idpf/idpf_lan_txrx.h
>=20

Tested-by: Krishneil Singh  <krishneil.k.singh@intel.com>

