Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 241CDCF488
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 10:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730500AbfJHIFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 04:05:53 -0400
Received: from mga05.intel.com ([192.55.52.43]:1677 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730414AbfJHIFw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 04:05:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 01:05:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,270,1566889200"; 
   d="scan'208";a="199747125"
Received: from iannetti-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.56.81])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Oct 2019 01:05:49 -0700
Subject: Re: [PATCH bpf-next 3/4] libbpf: handle AF_XDP sockets created with
 XDP_DIRECT bind flag.
To:     Sridhar Samudrala <sridhar.samudrala@intel.com>,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        maciej.fijalkowski@intel.com, tom.herbert@intel.com
References: <1570515415-45593-1-git-send-email-sridhar.samudrala@intel.com>
 <1570515415-45593-4-git-send-email-sridhar.samudrala@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <8a71dd88-43d0-e1fd-3a08-ecf431e36954@intel.com>
Date:   Tue, 8 Oct 2019 10:05:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1570515415-45593-4-git-send-email-sridhar.samudrala@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-10-08 08:16, Sridhar Samudrala wrote:
> Don't allow an AF_XDP socket trying to bind with XDP_DIRECT bind
> flag when a normal XDP program is already attached to the device,
> 
> Don't attach the default XDP program when AF_XDP socket is created
> with XDP_DIRECT bind flag.
>

I'd like this to be default for xsk.c, and if not supported fall back to 
old code.


> Signed-off-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> ---
>   tools/lib/bpf/xsk.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index d5f4900e5c54..953b479040cd 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -454,6 +454,9 @@ static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
>   		return err;
>   
>   	if (!prog_id) {
> +		if (xsk->config.bind_flags & XDP_DIRECT)
> +			return 0;
> +
>   		err = xsk_create_bpf_maps(xsk);
>   		if (err)
>   			return err;
> @@ -464,6 +467,9 @@ static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
>   			return err;
>   		}
>   	} else {
> +		if (xsk->config.bind_flags & XDP_DIRECT)
> +			return -EEXIST;
> +
>   		xsk->prog_fd = bpf_prog_get_fd_by_id(prog_id);
>   		err = xsk_lookup_bpf_maps(xsk);
>   		if (err) {
> 
