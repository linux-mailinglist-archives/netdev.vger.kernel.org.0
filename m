Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A90914BC26A
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 23:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240066AbiBRWBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 17:01:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239006AbiBRWBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 17:01:33 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45257E08F
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 14:01:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645221675; x=1676757675;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=yoj2cJ+h3eeZ10PdWp2Vuwnyy8wgTnEnKiC0cVg/P/k=;
  b=jTmsLLzdNBNlriiYq5E9q6jLd8zEdtSK8dkz6fY26Nn6E+NUsl/x1ye6
   2EEFB+c3lVAY2hI+nzIZSHTA7bci/7G/W2+t3jtjt6GcbQdfgnc9y6eaD
   +PfpC+lh+h1KG8bZ0hskcl8zAqIjIfzoAhYlNveDDq44ZGgiaKiNaQBOc
   kBNDynkg0dD5KVJBGpGDp4ZEDKTvVSO5U4XQLVLauSKe3NLEbFdNFo7/p
   JjGBcPbI+TP+Miw09Ocd7jJpyy5Ho2MjBIxbb7Qa0x65LSAcq2SHe8r9u
   SRUwspBn7xIdWuzYjkkLwMk78Z1PpOtwulOGCSnBduoTTO9ymWDpWKOcA
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10262"; a="311977555"
X-IronPort-AV: E=Sophos;i="5.88,379,1635231600"; 
   d="scan'208";a="311977555"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2022 14:00:54 -0800
X-IronPort-AV: E=Sophos;i="5.88,379,1635231600"; 
   d="scan'208";a="489799830"
Received: from yungjihy-mobl1.amr.corp.intel.com ([10.209.64.253])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2022 14:00:54 -0800
Date:   Fri, 18 Feb 2022 14:00:54 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        geliang.tang@suse.com, mptcp@lists.linux.dev
Subject: Re: [PATCH net 6/7] selftests: mptcp: more robust signal race test
In-Reply-To: <20220218213544.70285-7-mathew.j.martineau@linux.intel.com>
Message-ID: <b536d171-11c-407b-4236-39fb592b571a@linux.intel.com>
References: <20220218213544.70285-1-mathew.j.martineau@linux.intel.com> <20220218213544.70285-7-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Feb 2022, Mat Martineau wrote:

> From: Paolo Abeni <pabeni@redhat.com>
>
> The in kernel MPTCP PM implementation can process a single
> incoming add address option at any given time. In the
> mentioned test the server can surpass such limit. Let the
> setup cope with that allowing a faster add_addr retransmission.
>

Jakub / David -

A heads-up, this patch will give a trivial merge conflict in the hunk 
below when merging net/master to net-next/master. It's only due to changes 
in the preceeding context (those "ip netns exec" lines), so conflict 
resolution will be obvious.


> diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
> index 10b3bd805ac6..0d6a71e7bb59 100755
> --- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
> +++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh

...

> @@ -1158,7 +1164,10 @@ signal_address_tests()
> 	ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags signal
> 	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags signal
> 	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags signal
> -	run_tests $ns1 $ns2 10.0.1.1
> +
> +	# the peer could possibly miss some addr notification, allow retransmission
> +	ip netns exec $ns1 sysctl -q net.mptcp.add_addr_timeout=1
> +	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
> 	chk_join_nr "signal addresses race test" 3 3 3
>
> 	# the server will not signal the address terminating
> -- 
> 2.35.1
>
>

--
Mat Martineau
Intel
