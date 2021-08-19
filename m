Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 899E13F1677
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 11:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237680AbhHSJot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 05:44:49 -0400
Received: from mga18.intel.com ([134.134.136.126]:30218 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237757AbhHSJo1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 05:44:27 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10080"; a="203668373"
X-IronPort-AV: E=Sophos;i="5.84,334,1620716400"; 
   d="scan'208";a="203668373"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 02:43:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,334,1620716400"; 
   d="scan'208";a="679255110"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga006.fm.intel.com with ESMTP; 19 Aug 2021 02:43:49 -0700
Date:   Thu, 19 Aug 2021 11:28:49 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: Re: [PATCH bpf-next v2 12/16] selftests: xsk: remove cleanup at end
 of program
Message-ID: <20210819092849.GB32204@ranger.igk.intel.com>
References: <20210817092729.433-1-magnus.karlsson@gmail.com>
 <20210817092729.433-13-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210817092729.433-13-magnus.karlsson@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 17, 2021 at 11:27:25AM +0200, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Remove the cleanup right before the program/process exits as this will
> trigger the cleanup without us having to write or maintain any
> code. The application is not a library, so let us benefit from that.

Not a fan of that, I'd rather keep things tidy, but you're right that
dropping this logic won't hurt us.

> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  tools/testing/selftests/bpf/xdpxceiver.c | 29 +++++-------------------
>  1 file changed, 6 insertions(+), 23 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
> index 8ff24472ef1e..c1bb03e0ca07 100644
> --- a/tools/testing/selftests/bpf/xdpxceiver.c
> +++ b/tools/testing/selftests/bpf/xdpxceiver.c
> @@ -1041,28 +1041,24 @@ static void run_pkt_test(int mode, int type)
>  int main(int argc, char **argv)
>  {
>  	struct rlimit _rlim = { RLIM_INFINITY, RLIM_INFINITY };
> -	bool failure = false;
>  	int i, j;
>  
>  	if (setrlimit(RLIMIT_MEMLOCK, &_rlim))
>  		exit_with_error(errno);
>  
> -	for (int i = 0; i < MAX_INTERFACES; i++) {
> +	for (i = 0; i < MAX_INTERFACES; i++) {
>  		ifdict[i] = malloc(sizeof(struct ifobject));
>  		if (!ifdict[i])
>  			exit_with_error(errno);
>  
>  		ifdict[i]->ifdict_index = i;
>  		ifdict[i]->xsk_arr = calloc(2, sizeof(struct xsk_socket_info *));
> -		if (!ifdict[i]->xsk_arr) {
> -			failure = true;
> -			goto cleanup;
> -		}
> +		if (!ifdict[i]->xsk_arr)
> +			exit_with_error(errno);
> +
>  		ifdict[i]->umem_arr = calloc(2, sizeof(struct xsk_umem_info *));
> -		if (!ifdict[i]->umem_arr) {
> -			failure = true;
> -			goto cleanup;
> -		}
> +		if (!ifdict[i]->umem_arr)
> +			exit_with_error(errno);
>  	}
>  
>  	setlocale(LC_ALL, "");
> @@ -1081,19 +1077,6 @@ int main(int argc, char **argv)
>  		}
>  	}
>  
> -cleanup:
> -	for (int i = 0; i < MAX_INTERFACES; i++) {
> -		if (ifdict[i]->ns_fd != -1)
> -			close(ifdict[i]->ns_fd);
> -		free(ifdict[i]->xsk_arr);
> -		free(ifdict[i]->umem_arr);
> -		free(ifdict[i]);
> -	}
> -
> -	if (failure)
> -		exit_with_error(errno);
> -
>  	ksft_exit_pass();
> -
>  	return 0;
>  }
> -- 
> 2.29.0
> 
