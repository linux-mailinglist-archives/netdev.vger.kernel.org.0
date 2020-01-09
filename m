Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 181C41350C7
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 02:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbgAIBBH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 8 Jan 2020 20:01:07 -0500
Received: from mga05.intel.com ([192.55.52.43]:19165 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726930AbgAIBBG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 20:01:06 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2020 17:01:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,412,1571727600"; 
   d="scan'208";a="233869969"
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by orsmga002.jf.intel.com with ESMTP; 08 Jan 2020 17:01:05 -0800
Received: from orsmsx103.amr.corp.intel.com ([169.254.5.250]) by
 ORSMSX110.amr.corp.intel.com ([169.254.10.84]) with mapi id 14.03.0439.000;
 Wed, 8 Jan 2020 17:01:05 -0800
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: intel: e1000e: fix possible
 sleep-in-atomic-context bugs in e1000e_get_hw_semaphore()
Thread-Topic: [PATCH] net: intel: e1000e: fix possible
 sleep-in-atomic-context bugs in e1000e_get_hw_semaphore()
Thread-Index: AQHVta3aFEjLZ+EvHEi0p4CGcL5CcqfhpOxw
Date:   Thu, 9 Jan 2020 01:01:05 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B971A925B@ORSMSX103.amr.corp.intel.com>
References: <20191218141656.12416-1-baijiaju1990@gmail.com>
In-Reply-To: <20191218141656.12416-1-baijiaju1990@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYjlkZmI1NDAtYjM2NC00MTIwLWI2MjgtZjQ3ZTk4Y2IyZDM1IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiWGdFY0pPWVVaVjZhVkNlSlhkVDZtdDlJdXc2V2EwUEs4ZEI3ZUtEa2xSRnEyU20ybEZcL2tySzlwWEM0UHVcL1A4In0=
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org>
> On Behalf Of Jia-Ju Bai
> Sent: Wednesday, December 18, 2019 6:17 AM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; davem@davemloft.net
> Cc: intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Jia-Ju Bai <baijiaju1990@gmail.com>
> Subject: [PATCH] net: intel: e1000e: fix possible sleep-in-atomic-context bugs
> in e1000e_get_hw_semaphore()
> 
> The driver may sleep while holding a spinlock.
> The function call path (from bottom to top) in Linux 4.19 is:
> 
> drivers/net/ethernet/intel/e1000e/mac.c, 1366:
> 	usleep_range in e1000e_get_hw_semaphore
> drivers/net/ethernet/intel/e1000e/80003es2lan.c, 322:
> 	e1000e_get_hw_semaphore in
> e1000_release_swfw_sync_80003es2lan
> drivers/net/ethernet/intel/e1000e/80003es2lan.c, 197:
> 	e1000_release_swfw_sync_80003es2lan in
> e1000_release_phy_80003es2lan
> drivers/net/ethernet/intel/e1000e/netdev.c, 4883:
> 	(FUNC_PTR) e1000_release_phy_80003es2lan in
> e1000e_update_phy_stats
> drivers/net/ethernet/intel/e1000e/netdev.c, 4917:
> 	e1000e_update_phy_stats in e1000e_update_stats
> drivers/net/ethernet/intel/e1000e/netdev.c, 5945:
> 	e1000e_update_stats in e1000e_get_stats64
> drivers/net/ethernet/intel/e1000e/netdev.c, 5944:
> 	spin_lock in e1000e_get_stats64
> 
> drivers/net/ethernet/intel/e1000e/mac.c, 1384:
> 	usleep_range in e1000e_get_hw_semaphore
> drivers/net/ethernet/intel/e1000e/80003es2lan.c, 322:
> 	e1000e_get_hw_semaphore in
> e1000_release_swfw_sync_80003es2lan
> drivers/net/ethernet/intel/e1000e/80003es2lan.c, 197:
> 	e1000_release_swfw_sync_80003es2lan in
> e1000_release_phy_80003es2lan
> drivers/net/ethernet/intel/e1000e/netdev.c, 4883:
> 	(FUNC_PTR) e1000_release_phy_80003es2lan in
> e1000e_update_phy_stats
> drivers/net/ethernet/intel/e1000e/netdev.c, 4917:
> 	e1000e_update_phy_stats in e1000e_update_stats
> drivers/net/ethernet/intel/e1000e/netdev.c, 5945:
> 	e1000e_update_stats in e1000e_get_stats64
> drivers/net/ethernet/intel/e1000e/netdev.c, 5944:
> 	spin_lock in e1000e_get_stats64
> 
> (FUNC_PTR) means a function pointer is called.
> 
> To fix these bugs, usleep_range() is replaced with udelay().
> 
> These bugs are found by a static analysis tool STCheck written by myself.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>  drivers/net/ethernet/intel/e1000e/mac.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Tested-by: Aaron Brown <aaron.f.brown@intel.com>

