Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9959C1C1F7F
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 23:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgEAVX1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 1 May 2020 17:23:27 -0400
Received: from mga05.intel.com ([192.55.52.43]:4179 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgEAVX1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 17:23:27 -0400
IronPort-SDR: m9pEoAWKFO2iYcXBtR4CXIXV3tWHZTgbDZCaGB65PP99rqJrPctBghUCjJqxs68oY36ScV6/GS
 pcalKh49W6aA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2020 14:23:26 -0700
IronPort-SDR: hj7RSLjOG32khw5kDjksKV12Cy5KRo+ohanKyzQGvAFIc1fJQXg30XtBN9Si8rbXIvvrcpE5Hq
 3WjfRGwNzXmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,341,1583222400"; 
   d="scan'208";a="294922313"
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by orsmga008.jf.intel.com with ESMTP; 01 May 2020 14:23:26 -0700
Received: from orsmsx162.amr.corp.intel.com (10.22.240.85) by
 ORSMSX104.amr.corp.intel.com (10.22.225.131) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 1 May 2020 14:23:26 -0700
Received: from orsmsx151.amr.corp.intel.com ([169.254.7.25]) by
 ORSMSX162.amr.corp.intel.com ([169.254.3.2]) with mapi id 14.03.0439.000;
 Fri, 1 May 2020 14:23:25 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>
Subject: RE: [PATCH net-next v2] devlink: let kernel allocate region
 snapshot id
Thread-Topic: [PATCH net-next v2] devlink: let kernel allocate region
 snapshot id
Thread-Index: AQHWHn9F6pFmAiLS4kGfEjS5pJHLy6iRjt6AgAIxcNA=
Date:   Fri, 1 May 2020 21:23:25 +0000
Message-ID: <02874ECE860811409154E81DA85FBB58C0771750@ORSMSX151.amr.corp.intel.com>
References: <20200429233813.1137428-1-kuba@kernel.org>
 <20200430045315.GF6581@nanopsycho.orion>
In-Reply-To: <20200430045315.GF6581@nanopsycho.orion>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Wednesday, April 29, 2020 9:53 PM
> To: Jakub Kicinski <kuba@kernel.org>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; kernel-team@fb.com;
> Keller, Jacob E <jacob.e.keller@intel.com>
> Subject: Re: [PATCH net-next v2] devlink: let kernel allocate region snapshot id
> 
> Thu, Apr 30, 2020 at 01:38:13AM CEST, kuba@kernel.org wrote:
> >-	snapshot_id = nla_get_u32(info-
> >attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]);
> >+	snapshot_id_attr = info->attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID];
> >+	if (snapshot_id_attr) {
> >+		snapshot_id = nla_get_u32(snapshot_id_attr);
> >
> >-	if (devlink_region_snapshot_get_by_id(region, snapshot_id)) {
> >-		NL_SET_ERR_MSG_MOD(info->extack, "The requested snapshot
> id is already in use");
> >-		return -EEXIST;
> >-	}
> >+		if (devlink_region_snapshot_get_by_id(region, snapshot_id)) {
> >+			NL_SET_ERR_MSG_MOD(info->extack, "The requested
> snapshot id is already in use");
> >+			return -EEXIST;
> >+		}
> >
> >-	err = __devlink_snapshot_id_insert(devlink, snapshot_id);
> >-	if (err)
> >-		return err;
> >+		err = __devlink_snapshot_id_insert(devlink, snapshot_id);
> >+		if (err)
> >+			return err;
> >+	} else {
> >+		err = devlink_nl_alloc_snapshot_id(devlink, info,
> >+						   region, &snapshot_id);
> >+		if (err)
> >+			return err;
> >+	}
> 
> Could you please send the snapshot id just before you return 0 in this
> function, as you offered in v1? I think it would be great to do it like
> that.
> 
> Thanks!


Also: Does it make sense to send the snapshot id regardless of whether it was auto-generated or not?

Thanks,
Jake

