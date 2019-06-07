Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5DA039323
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 19:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731360AbfFGR1K convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 7 Jun 2019 13:27:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:31798 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728876AbfFGR1J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 13:27:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jun 2019 10:27:08 -0700
X-ExtLoop1: 1
Received: from orsmsx107.amr.corp.intel.com ([10.22.240.5])
  by fmsmga004.fm.intel.com with ESMTP; 07 Jun 2019 10:27:08 -0700
Received: from orsmsx121.amr.corp.intel.com ([169.254.10.133]) by
 ORSMSX107.amr.corp.intel.com ([169.254.1.123]) with mapi id 14.03.0415.000;
 Fri, 7 Jun 2019 10:27:08 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
Subject: RE: [net-next 06/15] ixgbe: fix PTP SDP pin setup on X540 hardware
Thread-Topic: [net-next 06/15] ixgbe: fix PTP SDP pin setup on X540 hardware
Thread-Index: AQHVG9yW/TezwgfQ60mS3GcVgIS18KaOa00AgACrTtCAAOrnAIAAcy5A
Date:   Fri, 7 Jun 2019 17:27:07 +0000
Message-ID: <02874ECE860811409154E81DA85FBB589674E83E@ORSMSX121.amr.corp.intel.com>
References: <20190605202358.2767-1-jeffrey.t.kirsher@intel.com>
 <20190605202358.2767-7-jeffrey.t.kirsher@intel.com>
 <20190606032050.4uwzcc7rdx3dkw5x@localhost>
 <02874ECE860811409154E81DA85FBB5896745E05@ORSMSX121.amr.corp.intel.com>
 <20190607033442.t3d5gpddvne2m27k@localhost>
In-Reply-To: <20190607033442.t3d5gpddvne2m27k@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNThjZWEzMDgtMDc1NS00NDRkLWJmYzgtYjJlMDVkYWVkZjI4IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiR0ZzM044dzZCbTNXZlJTYStBY2JkSnBEWEpwUFBzR3hxVjJuVUl5ZXJhNjVMUnNmQ0l6ZGV3Wm13R1JiNFltQSJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
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
> From: netdev-owner@vger.kernel.org [mailto:netdev-owner@vger.kernel.org] On
> Behalf Of Richard Cochran
> Sent: Thursday, June 06, 2019 8:35 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; davem@davemloft.net;
> netdev@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com; Bowers,
> AndrewX <andrewx.bowers@intel.com>
> Subject: Re: [net-next 06/15] ixgbe: fix PTP SDP pin setup on X540 hardware
> 
> On Thu, Jun 06, 2019 at 08:37:59PM +0000, Keller, Jacob E wrote:
> > No. We use the timecounter to track the time offset, not the
> > frequency. That is, our hardware can't represent 64bits of time, but
> > it can adjust frequency. The time counter is used to track the
> > adjustments from adjtime and set time, but not adjfreq.
> 
> Ah, okay.  Never mind then... carry on!
> 
> Thanks,
> Richard

Thanks for the review!

Regards,
Jake
