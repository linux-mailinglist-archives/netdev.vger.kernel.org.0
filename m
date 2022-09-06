Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A42915AF661
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 22:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbiIFU4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 16:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiIFU4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 16:56:10 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C054F883FB
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 13:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662497768; x=1694033768;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tSh/rti0VfFfEnCCiNJYpFUUxbYIvUjltjC6B2940iU=;
  b=kyY+1vJwKOw63HMq2soY+u1NLhV+S8YSmE493e1USGgOlt5M/KQXjYUf
   eNrResNSk76v3RFwzdLKhrE1KlFpQ5ym/NlkY3e2K34ogOyFCeunYuOXl
   1wj3R/Ec2lpHcdGgxN0R22DSAQeSiOsFzKFUfRAwwCMjYkKm3d6THX94p
   bl3PB42NDsbZ2UNg/9GbShir9Iv9OjZBG+n15Gu8RXrs8qOXsvp69LHD3
   1BCKdUuauv2i/Uh+T7x16NIWUlys08SfS4hLEL8v2PMWzXpjQ3S7ORxPO
   DGn4zq7xZTZMFkwCsUn+/mDCF+JJZCzF2VD8kqwQCvqeZBhu4+dlc2v5O
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="295438292"
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="295438292"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 13:56:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="682546532"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 06 Sep 2022 13:56:08 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 6 Sep 2022 13:56:08 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 6 Sep 2022 13:56:07 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 6 Sep 2022 13:56:07 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 6 Sep 2022 13:56:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RUwMN+7wNcks9DjBNwTbcKFc0pZQ+3iHg0yFNpL1o+YdzwgsgWUmjQh2XREraYBHsfl5vh9YxdddwgHkA4kp0RN1LJVYj2iTkzcCMOoqSiqxFVEWNw9HAIjsMfbMQ3cdqULCISffh/vCtvm5kSVv1g9QHrrQ9wBxEbBRkMTkzSCOzMtE5T6Rv0d3FlFXLua6blaLgTl1C7y/pepxUSt/GJD5OoWUvYLwSGmuGFpARwsnhsVXiaShnEWZIwBwp7sz1Rqjqjfy29fZMwHwa14elbe/gAu8MRqSIzBhLp2fhshjjPTBxJT7mSSuOzvu60YaGiubL/aHKm5PNqasGBUfnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gr06DMjwmUORfE3KqMqR0LjFVsGA3+nodUm9dxNBpQM=;
 b=K7dQ2MVljRM54RQKFNceKC6Ezlkx4MRsMEHZLHf3+GyrjbIFkG/V7P+Y8oCE9o//FhmtRioGOoTeN1ImPr1EZLaNYiNNiCUqKsTJG2Fulg9gfdDCdGbq1MWPG9pNVci5hk8roZ9cmezdPxzZkVA9YLa0pAa9nyzhXrgAZ1MwENiYtmQtFRiWWjAPx4+iCnO3nXIGoMzox5z0K2yRPFR1R76ooRdJvW6rUtfw0Qp71pUzeRa4yAIaeEmPCzP92iGnjMFQ7Gledd488zSsj1CQdkXcE1fnF/ejnLfJ+5giQ1/pqfPRUtUXtkFdgR8X94Mr27DXobWO43x+elDi8PhZGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR11MB4177.namprd11.prod.outlook.com (2603:10b6:405:83::31)
 by BYAPR11MB3080.namprd11.prod.outlook.com (2603:10b6:a03:8c::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.11; Tue, 6 Sep
 2022 20:56:00 +0000
Received: from BN6PR11MB4177.namprd11.prod.outlook.com
 ([fe80::f3ab:ab2c:fa82:efa9]) by BN6PR11MB4177.namprd11.prod.outlook.com
 ([fe80::f3ab:ab2c:fa82:efa9%5]) with mapi id 15.20.5612.012; Tue, 6 Sep 2022
 20:55:59 +0000
From:   "Michalik, Michal" <michal.michalik@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "G, GurucharanX" <gurucharanx.g@intel.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Johan Hovold <johan@kernel.org>
Subject: RE: [PATCH net 3/3] ice: Add set_termios tty operations handle to
 GNSS
Thread-Topic: [PATCH net 3/3] ice: Add set_termios tty operations handle to
 GNSS
Thread-Index: AQHYu/L55I/9qMiXWE+dtrk9hjKUpa3JkKOAgACDzYCABy4K0IAAtccAgADy/KA=
Date:   Tue, 6 Sep 2022 20:55:59 +0000
Message-ID: <BN6PR11MB4177F526AA1726DC0EF95E62E37E9@BN6PR11MB4177.namprd11.prod.outlook.com>
References: <20220829220049.333434-1-anthony.l.nguyen@intel.com>
 <20220829220049.333434-4-anthony.l.nguyen@intel.com>
 <20220831145439.2f268c34@kernel.org> <YxBHL6YzF2dAWf3q@kroah.com>
 <BN6PR11MB417756CED7AE9DF7C3FA88DCE37F9@BN6PR11MB4177.namprd11.prod.outlook.com>
 <YxbliLlS9YU6eKMn@kroah.com>
In-Reply-To: <YxbliLlS9YU6eKMn@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR11MB4177:EE_|BYAPR11MB3080:EE_
x-ms-office365-filtering-correlation-id: 380c060a-3f07-4b9e-3277-08da904a33c9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ud3lKCXqXFVlU90cOdH6HPj9iuE8Lbw2MQM4yP5cD5xVfqjAl8bvkQkOEKWmQX0Z7f/lIVSXuzirAtS47QhLAPvtTq+7+P+e+ZKaOkfgnjJrhoqjV5gxR31hPi3eC1r6bNOsNTrd89374S85FCcu++sckSmiIzdH8tyemXdzR2Qj358Gj+nMaTFVdRMFPa3DK8/vsO+Ypi364fBhWfILSMIBG/y3xQdrYRMHReP5qA7eNKXWn8VU8RZ1pr8QE6UGQ+bN11D6E77Uqd4c52ODVeGmdy6/DL6peG8oHperTP+MfqraoI7i+2/OVswgjgVv/sKRr+FEWRvYKXnvwS9RoSSEuBGF43zl3wUHLqjgGD6HFAw8FGSJMn8QJOzBntsM/1D2NZ25nz8ECQTZTfbr8htld2J6FBEAmtYdPcmlIjW7lcy/Cfx8mSj6R4Z3CxVx8UhwbpyURmaBTAW5I3Ip8OAlrsUmtSEXjfEcIFQBEcZylE0ndl80bPN86TNgcPhB9h8Z0fQUBK+ZZ/vU+SwX6A7zjJUwolyRVWYa7gLSnAmnvTYHphCnlmW+a5COkBFtjFsra57fCylFSvHZ41jT3Eg62naBHuKgMHGimHg+WnCVIoCJxffSnNutwzNFIFnl8VNeZ4gllUbjLjucblFJoKTUhfY/1d80+qep2/AsxKLTkas4pmcBYB2RgpBa1xhAVgg7notkFP5ZrcyWEomsbjHZq00uD60xhy34zzkm5vq1ju0R+Bm17eUJ7W8TisWEZ17GyP3PCMKy+jWqaRzJMw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB4177.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39860400002)(366004)(136003)(346002)(396003)(316002)(83380400001)(82960400001)(8936002)(52536014)(122000001)(38100700002)(38070700005)(6916009)(6506007)(66946007)(33656002)(66476007)(4326008)(66446008)(66556008)(8676002)(53546011)(26005)(5660300002)(54906003)(64756008)(86362001)(55016003)(7696005)(9686003)(71200400001)(41300700001)(76116006)(186003)(2906002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0wvglwaScTwcjN41+Rtj4ImhsQn4isn7phoPAPlzzeJq9TUfUdbuxgP5ngtr?=
 =?us-ascii?Q?wiXDBweEvwYjRe7i6f0Sp4oN/zRQwymDoIqf/vNqQ4b/n6pbuRJ/XDTbQ6jM?=
 =?us-ascii?Q?m7UwnSmxuEuEfmBh4Shzn7PCdtV6qDN4I+lgYHSWqomYSQZYfH2AJ5tAhiS9?=
 =?us-ascii?Q?diXFxrapsul5KQWSMyZ+BiTcTuZbtj0EtvxT4Eqt6nC+Szr35kkfTauS57m3?=
 =?us-ascii?Q?4E8NroBMl7d706Aj6ilOdnFb1M32I2DnTwfg5zizxw62mdYXySfpDBcmhAiM?=
 =?us-ascii?Q?oVeedM0RYrIF9Mw5ZRX7ez5h2GfkFVmETgqxbaldvYAbiJ7FizHvD1u+hdXA?=
 =?us-ascii?Q?R86O99FL9eFFTvVVOxopIfeqMoHbYovFnMqYVazNwnAa2WjIBM+/WDh5jvVc?=
 =?us-ascii?Q?1q1X2idRJOS74JEuOdaW9akRbkNjJW097JD2rgKBOnQ90n3ZaZBxhE+7MrA7?=
 =?us-ascii?Q?ow1M6XT6GH0UIm0Z7bMTJcOCiGdikHXzDJZyy/pKzqPZvS9y/gQcNkmXBh80?=
 =?us-ascii?Q?qDcvZvESdSgqHGIiQhZAojCxaosXRdD4ROwtDYTUUYjCMAJKLNmbrD+z44Uc?=
 =?us-ascii?Q?/lwKeL/fSNt8zuBJuLwje0hhrzKwiWPKXSBuqQCMA1ysJO2fgr+wSzy9yUR2?=
 =?us-ascii?Q?/+XMibGoF+SVcqjOSozJVyU0A0CUX5O3OkNK+dBwQpPp1nF6m8SOC92qoAhx?=
 =?us-ascii?Q?gbZbqC4B8tGnjcMkh6ZsaiLonmtO0ujm3sJt9b/kfFjw/XwNRXHydArcxvtN?=
 =?us-ascii?Q?TyOTDo+kch25SjsMLN+fLOnFLhsDC8a8uW31546bEfPI1BXPDUI46TIhGqLo?=
 =?us-ascii?Q?xuTWF8rbcV6Prn+9UxFXWaWKO4PCwnKvQD8lxsoZWdKN++vZdGk/Hx4uxQV0?=
 =?us-ascii?Q?2etn4QsWdjtXCSzOKorS4s71PTgPrWV+0xs61iYYOTXc0oDwgMG4tyvTR+5X?=
 =?us-ascii?Q?sCfIR6dR1po3q9k9t1uLey6YJ0ff9iWQmjuTQjavmWcxGbo8k91lhjwsqtk+?=
 =?us-ascii?Q?u5SsZC10FzhYbLtZMOKYIbhZTt3Wc/yEqEpiOyvSpCfB6Tpizbo49fHV8Bp+?=
 =?us-ascii?Q?2Qt/wn38tpX6ENFHyt7tkqjGLyKu4eHWSapI4iKWekiWlSlUcEFOCyBKcul+?=
 =?us-ascii?Q?OKEErngCbSrUyhKpSzhpIIJBxnKboS2JJNRHtivI5VRGUMAgymC6dMNQMn5A?=
 =?us-ascii?Q?GttUzuz//s9Pm8IFbjZnCQF5OnjJ/WradeTLCXjf+PuO7mzDcCLWaYIAbPU+?=
 =?us-ascii?Q?7FVFeXIbdv4J5j5vRDLlti3bVjkU7+BSJqtnhkzAMU7Mu5u2a/6LCxf+lHJz?=
 =?us-ascii?Q?1A5meTjbcrQbffZlrQa8QJ/yg9P50G4pKdHWs0ClJxeGVg7e6GMxN0A0NeoN?=
 =?us-ascii?Q?ZmC/eo/re1GY7KVy6KV5DCo5PsIN3/4uMdFV9WdzHAt6d6HDXayzTNCGWG9C?=
 =?us-ascii?Q?ple4H5sUpzizefRXoUxRIShcLnETXQNLksXyMO5WJ5YjzZ8q/qlUxtyuPODu?=
 =?us-ascii?Q?CcMk48Ai+SC1hIuId+0arjGDKheihePcDKLtvkM3se4R6gyfrJDTwl5nLHQ2?=
 =?us-ascii?Q?1QSrUmhpKWc1M6NNFWcqTf87G2aGnrACmsfEI/43SEH6naHv6xiBadKGd9xO?=
 =?us-ascii?Q?Dw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB4177.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 380c060a-3f07-4b9e-3277-08da904a33c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2022 20:55:59.6681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BthTIwJjBegX137TOXibX95jaqL02LFazBouxFP79Sw1JupKZJor+tKNBnbSe+eW1iioQDvVM3G3QNZZ/krbuJ91zK0MhHl1H+ffXT643uQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3080
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greg,

Thanks - answer inline.

BR,
M^2

>=20
> -----Original Message-----
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>=20
> Sent: Tuesday, September 6, 2022 8:16 AM
> To: Michalik, Michal <michal.michalik@intel.com>
> Cc: Jakub Kicinski <kuba@kernel.org>; Nguyen, Anthony L <anthony.l.nguyen=
@intel.com>; davem@davemloft.net; pabeni@redhat.com; edumazet@google.com; n=
etdev@vger.kernel.org; richardcochran@gmail.com; G, GurucharanX <gurucharan=
x.g@intel.com>; Jiri Slaby <jirislaby@kernel.org>; Johan Hovold <johan@kern=
el.org>
> Subject: Re: [PATCH net 3/3] ice: Add set_termios tty operations handle t=
o GNSS
>=20
> On Mon, Sep 05, 2022 at 07:32:44PM +0000, Michalik, Michal wrote:
> > Hello Greg,
> >=20
> > Much thanks for a feedback. Please excuse me for delayed answer, we tri=
ed to collect all
> > the required information before returning to you - but we are still wor=
king on it.
> >=20
> > Best regards,
> > M^2
> >=20
> > >=20
> > > -----Original Message-----
> > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>=20
> > > Sent: Thursday, September 1, 2022 7:46 AM
> > > To: Jakub Kicinski <kuba@kernel.org>
> > > Cc: Nguyen, Anthony L <anthony.l.nguyen@intel.com>; davem@davemloft.n=
et; pabeni@redhat.com; edumazet@google.com; Michalik, Michal <michal.michal=
ik@intel.com>; netdev@vger.kernel.org; richardcochran@gmail.com; G, Gurucha=
ranX <gurucharanx.g@intel.com>; Jiri Slaby <jirislaby@kernel.org>; Johan Ho=
vold <johan@kernel.org>
> > > Subject: Re: [PATCH net 3/3] ice: Add set_termios tty operations hand=
le to GNSS
> > >=20
> > > On Wed, Aug 31, 2022 at 02:54:39PM -0700, Jakub Kicinski wrote:
> > > > On Mon, 29 Aug 2022 15:00:49 -0700 Tony Nguyen wrote:
> > > > > From: Michal Michalik <michal.michalik@intel.com>
> > > > >=20
> > > > > Some third party tools (ex. ubxtool) try to change GNSS TTY param=
eters
> > > > > (ex. speed). While being optional implementation, without set_ter=
mios
> > > > > handle this operation fails and prevents those third party tools =
from
> > > > > working.
> > >=20
> > > What tools are "blocked" by this?  And what is the problem they have
> > > with just the default happening here?  You are now doing nothing, whi=
le
> > > if you do not have the callback, at least a basic "yes, we accepted
> > > these values" happens which was intended for userspace to not know th=
at
> > > there was a problem here.
> > >=20
> >=20
> > As I stated in the commit message, the example tool is ubxtool - while =
trying to
> > connect to the GPS module the error appreared:
> > Traceback (most recent call last):
> >=20
> > 	  File "/usr/local/bin/ubxtool", line 378, in <module>
> > 		io_handle =3D gps.gps_io(
> > 	  File "/usr/local/lib/python3.9/site-packages/gps/gps.py", line 309, =
in __init__
> > 		self.ser =3D Serial.Serial(
> > 	  File "/usr/local/lib/python3.9/site-packages/serial/serialutil.py", =
line 244, in __init__
> > 		self.open()
> > 	  File "/usr/local/lib/python3.9/site-packages/serial/serialposix.py",=
 line 332, in open
> > 		self._reconfigure_port(force_update=3DTrue)
> > 	  File "/usr/local/lib/python3.9/site-packages/serial/serialposix.py",=
 line 517, in _reconfigure_port
> > 		termios.tcsetattr(
> > 	termios.error: (22, 'Invalid argument')
> > =09
> > Adding this empty function solved the problem.
>=20
> That seems very wrong, please work to fix this by NOT having an empty
> function like this as it should not be required.
>=20

Thanks for sharing the feedback - I love the possibility to learn from you =
and
other community members, because I'm really new in here.

I don't get one thing, though. You are saying, it "seem" wrong and that
"should not" be required but I observe different behavior. I have prepared
a very simple code to reproduce the issue:
	#include <termios.h>
	#include <unistd.h>
	#include <stdio.h>
	#include <fcntl.h>
	#include <errno.h>

	int main()
	{
		struct termios tty;
		int fd;
	=09
		fd =3D open("/dev/ttyGNSS_0300", O_RDWR | O_NOCTTY | O_SYNC);

		if (fd < 0) {
				printf("Error - TTY not open.\n");
				return -1;
		}
			=09
		if (tcgetattr (fd, &tty) !=3D 0) {
			printf("Error on get - errno=3D%i\n", errno);
			return -1;
		}
		tty.c_cflag |=3D CS8; // try to set 8 data bits=20
		if (tcsetattr(fd, TCSANOW, &tty) !=3D 0) {
			printf("Error on set - errno=3D%i\n", errno);
			return -1;
		}

		close(fd);
		printf("Done.\n");
	}

In this case, when I don't satisfy this API, I get an errno 22. If add this
empty function and therefore implement the full API it works as expected (n=
o
error). In our case no action is needed, therefore we have an empty functio=
n.
At the moment, I'm not sure how I should fix it other way - since no action
on HW is neccessary.

Of course in the meantime we are working on investigating if we can easily
align to existing GNSS interface accroding to community suggestions. Still,
we believe that this fix is solving the problem at the moment.=20

> thanks,
>=20
> greg k-h
>
