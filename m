Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D2D1D40D1
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 00:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbgENWWn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 14 May 2020 18:22:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:31164 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728347AbgENWWn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 18:22:43 -0400
IronPort-SDR: SUP9u0negCUQKfybd87EZTUbN649Ud09iAMoGz+wnz+jqdC0NsURPsw0FD7mj8+foMJC/Yyohd
 dfQc/elicz4Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2020 15:22:43 -0700
IronPort-SDR: N5KLIza8p7ENVSiwgBKzDcD2g9KCnHYZ7aazClHTUYfy+9qgOc4ofaIn7kRlHVYkRGpvP6g5Vw
 SrsJuUXYHDJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,392,1583222400"; 
   d="scan'208";a="298195015"
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by fmsmga002.fm.intel.com with ESMTP; 14 May 2020 15:22:42 -0700
Received: from orsmsx158.amr.corp.intel.com (10.22.240.20) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 14 May 2020 15:22:42 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.248]) by
 ORSMSX158.amr.corp.intel.com ([169.254.10.56]) with mapi id 14.03.0439.000;
 Thu, 14 May 2020 15:22:42 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     David Miller <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>, lkp <lkp@intel.com>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "Brown, Aaron F" <aaron.f.brown@intel.com>
Subject: RE: [net-next v2 3/9] igc: add support to eeprom, registers and
 link self-tests
Thread-Topic: [net-next v2 3/9] igc: add support to eeprom, registers and
 link self-tests
Thread-Index: AQHWKjcFHwvVQ2tCN06F8ziBFkGnP6iolMuAgAAEVgD//42nAA==
Date:   Thu, 14 May 2020 22:22:42 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D940449869BC15@ORSMSX112.amr.corp.intel.com>
References: <20200514213117.4099065-1-jeffrey.t.kirsher@intel.com>
        <20200514213117.4099065-4-jeffrey.t.kirsher@intel.com>
        <20200514145219.58484d4b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200514.150750.17841471129931986.davem@davemloft.net>
In-Reply-To: <20200514.150750.17841471129931986.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Thursday, May 14, 2020 15:08
> To: kuba@kernel.org
> Cc: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; Lifshits, Vitaly
> <vitaly.lifshits@intel.com>; netdev@vger.kernel.org; nhorman@redhat.com;
> sassmann@redhat.com; lkp <lkp@intel.com>; dan.carpenter@oracle.com;
> Brown, Aaron F <aaron.f.brown@intel.com>
> Subject: Re: [net-next v2 3/9] igc: add support to eeprom, registers and link
> self-tests
> 
> From: Jakub Kicinski <kuba@kernel.org>
> Date: Thu, 14 May 2020 14:52:19 -0700
> 
> > On Thu, 14 May 2020 14:31:11 -0700 Jeff Kirsher wrote:
> >> diff --git a/drivers/net/ethernet/intel/igc/igc_diag.c
> >> b/drivers/net/ethernet/intel/igc/igc_diag.c
> >> new file mode 100644
> >> index 000000000000..1c4536105e56
> >> --- /dev/null
> >> +++ b/drivers/net/ethernet/intel/igc/igc_diag.c
> >> @@ -0,0 +1,186 @@
> >> +// SPDX-License-Identifier: GPL-2.0
> >> +/* Copyright (c)  2020 Intel Corporation */
> >> +
> >> +#include "igc.h"
> >> +#include "igc_diag.h"
> >> +
> >> +struct igc_reg_test reg_test[] = {
> >> +	{ IGC_FCAL,	1,	PATTERN_TEST,	0xFFFFFFFF,	0xFFFFFFFF },
> >> +	{ IGC_FCAH,	1,	PATTERN_TEST,	0x0000FFFF,	0xFFFFFFFF },
> >> +	{ IGC_FCT,	1,	PATTERN_TEST,	0x0000FFFF,	0xFFFFFFFF },
> >> +	{ IGC_RDBAH(0), 4,	PATTERN_TEST,	0xFFFFFFFF,	0xFFFFFFFF },
> >
> > drivers/net/ethernet/intel/igc/igc_diag.c:7:21: warning: symbol 'reg_test' was
> not declared. Should it be static?
> 
> Jeff, you might want to start checking this kind of stuff internally since Jakub is
> going to catch it within minutes of you posting your changes :-)))
[Kirsher, Jeffrey T] 

Ugh, I have been compile testing.  Since moving to Fedora 32, kernel compiles are now littered with warnings that were not showing up on the older GCC version which is no excuse,  I need to work on parsing the logs better.
