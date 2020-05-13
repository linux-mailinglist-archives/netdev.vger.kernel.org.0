Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32511D2070
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 22:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgEMU4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 16:56:41 -0400
Received: from mga14.intel.com ([192.55.52.115]:23180 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgEMU4l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 16:56:41 -0400
IronPort-SDR: +U43l9e9BNKtYjXMPRlzPx1OM6nA7MbCC/CJQLeY96sLWudgw7A/BnA4kyWc/Km/IOXMvCt39+
 4WuZz3+TYZOw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2020 13:56:40 -0700
IronPort-SDR: EeVj3Tyxs9ezMaMhfOgA0CzTd11tjfOyYfmvPDCy+O+sVo6GtbixxYQ5gynDZQLwkFOw3Z4p7S
 touSzmWHEjXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,389,1583222400"; 
   d="scan'208";a="409826693"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.2.144]) ([10.209.2.144])
  by orsmga004.jf.intel.com with ESMTP; 13 May 2020 13:56:40 -0700
Subject: Re: [PATCH net-next] devlink: refactor end checks in
 devlink_nl_cmd_region_read_dumpit
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     jiri@resnulli.us, netdev@vger.kernel.org, kernel-team@fb.com
References: <20200513172822.2663102-1-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <022f15a5-92b2-1531-a1cc-8fe007bfcdda@intel.com>
Date:   Wed, 13 May 2020 13:56:40 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200513172822.2663102-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/13/2020 10:28 AM, Jakub Kicinski wrote:
> Clean up after recent fixes, move address calculations
> around and change the variable init, so that we can have
> just one start_offset == end_offset check.
> 
> Make the check a little stricter to preserve the -EINVAL
> error if requested start offset is larger than the region
> itself.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/core/devlink.c                            | 41 ++++++++-----------
>  .../drivers/net/netdevsim/devlink.sh          | 15 +++++++
>  2 files changed, 31 insertions(+), 25 deletions(-)
> 
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 20f935fa29f5..7b76e5fffc10 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -4215,7 +4215,6 @@ static int devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
>  						struct nlattr **attrs,
>  						u64 start_offset,
>  						u64 end_offset,
> -						bool dump,
>  						u64 *new_offset)
>  {
>  	struct devlink_snapshot *snapshot;
> @@ -4230,9 +4229,6 @@ static int devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
>  	if (!snapshot)
>  		return -EINVAL;
>  
> -	if (end_offset > region->size || dump)
> -		end_offset = region->size;
> -

Yea I saw this back when I was looking at enabling region dump without a
snapshot. At this point, it doesn't seem necessary, because the snapshot
time is relatively low, and the changes to make snapshot id a bit easier
to use in scripts (i.e. dynamic generation and saving) mean that it
isn't that useful.

Good to see this cleaned up!

>  	while (curr_offset < end_offset) {
>  		u32 data_size;
>  		u8 *data;
> @@ -4260,13 +4256,12 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
>  					     struct netlink_callback *cb)
>  {
>  	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
> -	u64 ret_offset, start_offset, end_offset = 0;
> +	u64 ret_offset, start_offset, end_offset = U64_MAX;
>  	struct nlattr **attrs = info->attrs;
>  	struct devlink_region *region;
>  	struct nlattr *chunks_attr;
>  	const char *region_name;
>  	struct devlink *devlink;
> -	bool dump = true;
>  	void *hdr;
>  	int err;
>  
> @@ -4294,8 +4289,21 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
>  		goto out_unlock;
>  	}
>  
> +	if (attrs[DEVLINK_ATTR_REGION_CHUNK_ADDR] &&
> +	    attrs[DEVLINK_ATTR_REGION_CHUNK_LEN]) {
> +		if (!start_offset)
> +			start_offset =
> +				nla_get_u64(attrs[DEVLINK_ATTR_REGION_CHUNK_ADDR]);
> +
> +		end_offset = nla_get_u64(attrs[DEVLINK_ATTR_REGION_CHUNK_ADDR]);

At  first, reading this confused me a bit, but it makes sense. The end
is always "beginning + length".

If the start_offset is set before, this simply means that we needed to
read over multiple buffers. Ok.

> +		end_offset += nla_get_u64(attrs[DEVLINK_ATTR_REGION_CHUNK_LEN]);
> +	}
> +
> +	if (end_offset > region->size)
> +		end_offset = region->size;
> +
>  	/* return 0 if there is no further data to read */
> -	if (start_offset >= region->size) {
> +	if (start_offset == end_offset) {

Why change this to ==? isn't it possible to specify a start_offset that
is out of bounds? I think this should still be >=

>  		err = 0;
>  		goto out_unlock;
>  	}
> @@ -4322,27 +4330,10 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
>  		goto nla_put_failure;
>  	}
>  
> -	if (attrs[DEVLINK_ATTR_REGION_CHUNK_ADDR] &&
> -	    attrs[DEVLINK_ATTR_REGION_CHUNK_LEN]) {
> -		if (!start_offset)
> -			start_offset =
> -				nla_get_u64(attrs[DEVLINK_ATTR_REGION_CHUNK_ADDR]);
> -
> -		end_offset = nla_get_u64(attrs[DEVLINK_ATTR_REGION_CHUNK_ADDR]);
> -		end_offset += nla_get_u64(attrs[DEVLINK_ATTR_REGION_CHUNK_LEN]);
> -		dump = false;
> -
> -		if (start_offset == end_offset) {
> -			err = 0;
> -			goto nla_put_failure;
> -		}
> -	}
> -
>  	err = devlink_nl_region_read_snapshot_fill(skb, devlink,
>  						   region, attrs,
>  						   start_offset,
> -						   end_offset, dump,
> -						   &ret_offset);
> +						   end_offset, &ret_offset);
>  
>  	if (err && err != -EMSGSIZE)
>  		goto nla_put_failure;
> diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
> index ad539eccddcb..de4b32fc4223 100755
> --- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
> +++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
> @@ -146,6 +146,21 @@ regions_test()
>  
>  	check_region_snapshot_count dummy post-first-request 3
>  
> +	devlink region dump $DL_HANDLE/dummy snapshot 25 >> /dev/null
> +	check_err $? "Failed to dump snapshot with id 25"
> +
> +	devlink region read $DL_HANDLE/dummy snapshot 25 addr 0 len 1 >> /dev/null
> +	check_err $? "Failed to read snapshot with id 25 (1 byte)"
> +
> +	devlink region read $DL_HANDLE/dummy snapshot 25 addr 128 len 128 >> /dev/null
> +	check_err $? "Failed to read snapshot with id 25 (128 bytes)"
> +
> +	devlink region read $DL_HANDLE/dummy snapshot 25 addr 128 len $((1<<32)) >> /dev/null
> +	check_err $? "Failed to read snapshot with id 25 (oversized)"
> +
> +	devlink region read $DL_HANDLE/dummy snapshot 25 addr $((1<<32)) len 128 >> /dev/null 2>&1
> +	check_fail $? "Bad read of snapshot with id 25 did not fail"
> +
>  	devlink region del $DL_HANDLE/dummy snapshot 25
>  	check_err $? "Failed to delete snapshot with id 25"
>  
> 
