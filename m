Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA6D21BE224
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 17:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgD2PLG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 29 Apr 2020 11:11:06 -0400
Received: from mga12.intel.com ([192.55.52.136]:57762 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726913AbgD2PLF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 11:11:05 -0400
IronPort-SDR: b8Ey3uWXnL/LSenj/FmHTbBayhNY36IQmEHmN7IQqwNlzOapn2aAibXp2PhPbr6XXJfIXJAlBX
 8J+fcbV545pQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2020 08:11:05 -0700
IronPort-SDR: c1aaJR3YlH0pfERh/WYCF3kBAUi7GvCF1tw2LHjtvA7ao5xkYvr4Y64tNtO5OyylwxUilfYYpx
 okQ6k45+mfiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,332,1583222400"; 
   d="scan'208";a="336983797"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga001.jf.intel.com with ESMTP; 29 Apr 2020 08:11:04 -0700
Received: from fmsmsx120.amr.corp.intel.com (10.18.124.208) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 29 Apr 2020 08:11:04 -0700
Received: from fmsmsx102.amr.corp.intel.com ([169.254.10.190]) by
 fmsmsx120.amr.corp.intel.com ([169.254.15.148]) with mapi id 14.03.0439.000;
 Wed, 29 Apr 2020 08:11:04 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "parav@mellanox.com" <parav@mellanox.com>
Subject: RE: [PATCH net] devlink: fix return value after hitting end in
 region read
Thread-Topic: [PATCH net] devlink: fix return value after hitting end in
 region read
Thread-Index: AQHWHcovNdj5JNUa9E+uq7LFd8B5BqiQNOXQ
Date:   Wed, 29 Apr 2020 15:11:03 +0000
Message-ID: <02874ECE860811409154E81DA85FBB58B6CF7A86@FMSMSX102.amr.corp.intel.com>
References: <20200429020158.988886-1-kuba@kernel.org>
In-Reply-To: <20200429020158.988886-1-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.108]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, April 28, 2020 7:02 PM
> To: davem@davemloft.net
> Cc: netdev@vger.kernel.org; kernel-team@fb.com; jiri@resnulli.us; Keller, Jacob
> E <jacob.e.keller@intel.com>; parav@mellanox.com; Jakub Kicinski
> <kuba@kernel.org>
> Subject: [PATCH net] devlink: fix return value after hitting end in region read
> 
> Commit d5b90e99e1d5 ("devlink: report 0 after hitting end in region read")
> fixed region dump, but region read still returns a spurious error:
> 
> $ devlink region read netdevsim/netdevsim1/dummy snapshot 0 addr 0 len 128
> 0000000000000000 a6 f4 c4 1c 21 35 95 a6 9d 34 c3 5b 87 5b 35 79
> 0000000000000010 f3 a0 d7 ee 4f 2f 82 7f c6 dd c4 f6 a5 c3 1b ae
> 0000000000000020 a4 fd c8 62 07 59 48 03 70 3b c7 09 86 88 7f 68
> 0000000000000030 6f 45 5d 6d 7d 0e 16 38 a9 d0 7a 4b 1e 1e 2e a6
> 0000000000000040 e6 1d ae 06 d6 18 00 85 ca 62 e8 7e 11 7e f6 0f
> 0000000000000050 79 7e f7 0f f3 94 68 bd e6 40 22 85 b6 be 6f b1
> 0000000000000060 af db ef 5e 34 f0 98 4b 62 9a e3 1b 8b 93 fc 17
> devlink answers: Invalid argument
> 0000000000000070 61 e8 11 11 66 10 a5 f7 b1 ea 8d 40 60 53 ed 12
> 
> This is a minimal fix, I'll follow up with a restructuring
> so we don't have two checks for the same condition.
> 

Makes sense.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> Fixes: fdd41ec21e15 ("devlink: Return right error code in case of errors for region
> read")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/core/devlink.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 80f97722f31f..1ec2e9fd8898 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -4283,6 +4283,11 @@ static int devlink_nl_cmd_region_read_dumpit(struct
> sk_buff *skb,
>  		end_offset =
> nla_get_u64(attrs[DEVLINK_ATTR_REGION_CHUNK_ADDR]);
>  		end_offset +=
> nla_get_u64(attrs[DEVLINK_ATTR_REGION_CHUNK_LEN]);
>  		dump = false;
> +
> +		if (start_offset == end_offset) {
> +			err = 0;
> +			goto nla_put_failure;
> +		}
>  	}
> 
>  	err = devlink_nl_region_read_snapshot_fill(skb, devlink,
> --
> 2.25.4

