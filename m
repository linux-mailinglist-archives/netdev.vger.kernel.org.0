Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56E511BC64A
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 19:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbgD1RRS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 28 Apr 2020 13:17:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:16627 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgD1RRS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 13:17:18 -0400
IronPort-SDR: ihxiwgMtrMOs04hH552qLZan0XgXrC6kWMxjBE28nyUNlT1BIUK5a2UKtI6p05PMc9R1aFP5ra
 kKWDx6FQ4EHQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2020 10:17:17 -0700
IronPort-SDR: nv2KLuWrc5agkM9+ECZoINjiniBaQjUpYhKSK/O8P4HNwsibRsqaB27EFHtTmUfef/InmbIpYi
 5MBvCeXdOnQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,328,1583222400"; 
   d="scan'208";a="282215021"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by fmsmga004.fm.intel.com with ESMTP; 28 Apr 2020 10:17:17 -0700
Received: from fmsmsx102.amr.corp.intel.com ([169.254.10.190]) by
 FMSMSX108.amr.corp.intel.com ([169.254.9.13]) with mapi id 14.03.0439.000;
 Tue, 28 Apr 2020 10:17:17 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [iproute2] devlink: add support for DEVLINK_CMD_REGION_NEW
Thread-Topic: [iproute2] devlink: add support for DEVLINK_CMD_REGION_NEW
Thread-Index: AQHWHQGASnpeL50kxEqVmpaXNrFOHqiOey+AgABMeSA=
Date:   Tue, 28 Apr 2020 17:17:17 +0000
Message-ID: <02874ECE860811409154E81DA85FBB58B6CF63CB@FMSMSX102.amr.corp.intel.com>
References: <20200428020512.1099264-1-jacob.e.keller@intel.com>
 <20200428054321.GZ6581@nanopsycho.orion>
In-Reply-To: <20200428054321.GZ6581@nanopsycho.orion>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.106]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Jiri Pirko
> Sent: Monday, April 27, 2020 10:43 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org; Jakub Kicinski <kuba@kernel.org>
> Subject: Re: [iproute2] devlink: add support for DEVLINK_CMD_REGION_NEW
> 
> Tue, Apr 28, 2020 at 04:05:12AM CEST, jacob.e.keller@intel.com wrote:
> >Add support to request that a new snapshot be taken immediately for
> >a devlink region. To avoid confusion, the desired snapshot id must be
> >provided.
> >
> >Note that if a region does not support snapshots on demand, the kernel
> >will reject the request with -EOPNOTSUP.
> >
> >Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> >---
> > devlink/devlink.c | 20 ++++++++++++++++++++
> > 1 file changed, 20 insertions(+)
> >
> >diff --git a/devlink/devlink.c b/devlink/devlink.c
> >index 67e6e64181f9..c750ee1ec6d3 100644
> >--- a/devlink/devlink.c
> >+++ b/devlink/devlink.c
> >@@ -6362,10 +6362,27 @@ static int cmd_region_read(struct dl *dl)
> > 	return err;
> > }
> >
> >+static int cmd_region_snapshot_new(struct dl *dl)
> >+{
> >+	struct nlmsghdr *nlh;
> >+	int err;
> >+
> >+	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_REGION_NEW,
> >+			NLM_F_REQUEST | NLM_F_ACK);
> >+
> >+	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE_REGION |
> >+				DL_OPT_REGION_SNAPSHOT_ID, 0);
> >+	if (err)
> >+		return err;
> >+
> >+	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
> >+}
> >+
> > static void cmd_region_help(void)
> > {
> > 	pr_err("Usage: devlink region show [ DEV/REGION ]\n");
> > 	pr_err("       devlink region del DEV/REGION snapshot SNAPSHOT_ID\n");
> >+	pr_err("       devlink region new DEV/REGION [snapshot
> SNAPSHOT_ID]\n");
> 
> Same as for "del", snapshot id is mandatory. You should not have it in "[]".
> 

Ah, right!

> 
> > 	pr_err("       devlink region dump DEV/REGION [ snapshot SNAPSHOT_ID
> ]\n");
> > 	pr_err("       devlink region read DEV/REGION [ snapshot SNAPSHOT_ID ]
> address ADDRESS length LENGTH\n");
> > }
> >@@ -6389,6 +6406,9 @@ static int cmd_region(struct dl *dl)
> > 	} else if (dl_argv_match(dl, "read")) {
> > 		dl_arg_inc(dl);
> > 		return cmd_region_read(dl);
> >+	} else if (dl_argv_match(dl, "new")) {
> >+		dl_arg_inc(dl);
> >+		return cmd_region_snapshot_new(dl);
> > 	}
> > 	pr_err("Command \"%s\" not found\n", dl_argv(dl));
> > 	return -ENOENT;
> >--
> >2.25.2
> >
