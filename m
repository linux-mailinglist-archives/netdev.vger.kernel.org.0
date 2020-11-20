Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75A992B9F76
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 01:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgKTAzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 19:55:03 -0500
Received: from mga03.intel.com ([134.134.136.65]:16581 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726295AbgKTAzC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 19:55:02 -0500
IronPort-SDR: AIEUK3Uz0+YQnhQLTCmDWydm2v0MlcEIH/aGNC4Um6cqneWNxt5WFTHRk90zi2JOXv5hC4sQLg
 NINcRnvczD9A==
X-IronPort-AV: E=McAfee;i="6000,8403,9810"; a="171489869"
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="171489869"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2020 16:55:01 -0800
IronPort-SDR: yH/mGMbyzmBXVNXde9t9SLdOUiWuXSjKfqCQWprvyRiWvhQEyY7Znmgr1TEiNoVC0adRuTgk+n
 feoOVE6Ee27g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="331130778"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga006.jf.intel.com with ESMTP; 19 Nov 2020 16:54:59 -0800
Date:   Fri, 20 Nov 2020 01:46:24 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 4/6] libbpf: add kernel module BTF support for
 CO-RE relocations
Message-ID: <20201120004624.GA25728@ranger.igk.intel.com>
References: <20201119232244.2776720-1-andrii@kernel.org>
 <20201119232244.2776720-5-andrii@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119232244.2776720-5-andrii@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 03:22:42PM -0800, Andrii Nakryiko wrote:
> Teach libbpf to search for candidate types for CO-RE relocations across kernel
> modules BTFs, in addition to vmlinux BTF. If at least one candidate type is
> found in vmlinux BTF, kernel module BTFs are not iterated. If vmlinux BTF has
> no matching candidates, then find all kernel module BTFs and search for all
> matching candidates across all of them.
> 
> Kernel's support for module BTFs are inferred from the support for BTF name
> pointer in BPF UAPI.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>  tools/lib/bpf/libbpf.c | 185 ++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 172 insertions(+), 13 deletions(-)
> 

[...]

> +static int probe_module_btf(void)
> +{
> +	static const char strs[] = "\0int";
> +	__u32 types[] = {
> +		/* int */
> +		BTF_TYPE_INT_ENC(1, BTF_INT_SIGNED, 0, 32, 4),
> +	};
> +	struct bpf_btf_info info;
> +	__u32 len = sizeof(info);
> +	char name[16];
> +	int fd, err;
> +
> +	fd = libbpf__load_raw_btf((char *)types, sizeof(types), strs, sizeof(strs));
> +	if (fd < 0)
> +		return 0; /* BTF not supported at all */
> +
> +	len = sizeof(info);

nit: reinit of len

> +	memset(&info, 0, sizeof(info));

use len in memset

> +	info.name = ptr_to_u64(name);
> +	info.name_len = sizeof(name);
> +
> +	/* check that BPF_OBJ_GET_INFO_BY_FD supports specifying name pointer;
> +	 * kernel's module BTF support coincides with support for
> +	 * name/name_len fields in struct bpf_btf_info.
> +	 */
> +	err = bpf_obj_get_info_by_fd(fd, &info, &len);
> +	close(fd);
> +	return !err;
> +}

[...]
