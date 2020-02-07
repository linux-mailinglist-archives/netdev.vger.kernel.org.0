Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD6E156155
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 23:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgBGWib convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 7 Feb 2020 17:38:31 -0500
Received: from mga11.intel.com ([192.55.52.93]:34024 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727031AbgBGWib (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Feb 2020 17:38:31 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Feb 2020 14:38:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,415,1574150400"; 
   d="scan'208";a="432721170"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by fmsmga006.fm.intel.com with ESMTP; 07 Feb 2020 14:38:31 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 7 Feb 2020 14:38:31 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 7 Feb 2020 14:38:30 -0800
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82]) by
 fmsmsx602.amr.corp.intel.com ([10.18.126.82]) with mapi id 15.01.1713.004;
 Fri, 7 Feb 2020 14:38:30 -0800
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [Intel-wired-lan] [PATCH net] ice: Fix a couple off by one bugs
Thread-Topic: [Intel-wired-lan] [PATCH net] ice: Fix a couple off by one bugs
Thread-Index: AQHV1/L6QFkGydHjFE2oQ+RqQ75FIqgQXpFg
Date:   Fri, 7 Feb 2020 22:38:30 +0000
Message-ID: <4d2cb89e16e44f619e45d6470ce4b1c4@intel.com>
References: <20200131045658.ahliv7jvubpwoeru@kili.mountain>
In-Reply-To: <20200131045658.ahliv7jvubpwoeru@kili.mountain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNjU2MTVhMjktOWE0Yi00NjA5LWJkOTMtMWExNTk0ZTk2MWE1IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiRzhUc09tNkRiQmpLSWk4dDd4SjhLNVZxTGV3WStCdEtJRUdHSHZTNHpBZ1lkVGdwMlZiWjMwM2Vxc0xZSkY4OSJ9
dlp-reaction: no-action
dlp-version: 11.0.400.15
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan [mailto:intel-wired-lan-bounces@osuosl.org] On
> Behalf Of Dan Carpenter
> Sent: Thursday, January 30, 2020 8:57 PM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>
> Cc: netdev@vger.kernel.org; kernel-janitors@vger.kernel.org; intel-wired-
> lan@lists.osuosl.org; David S. Miller <davem@davemloft.net>
> Subject: [Intel-wired-lan] [PATCH net] ice: Fix a couple off by one bugs
> 
> The hw->blk[blk]->es.ref_count[] array has hw->blk[blk].es.count elements.
> It gets allocated in ice_init_hw_tbls().  So the > should be
> >= to prevent accessing one element beyond the end of the array.
> 
> Fixes: 2c61054c5fda ("ice: Optimize table usage")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_flex_pipe.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


