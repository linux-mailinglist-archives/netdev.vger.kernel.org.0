Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686201AC66C
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 16:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394411AbgDPOjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 10:39:20 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:23063 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2409593AbgDPOCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 10:02:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587045727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ompQzSPLF05tcBnPen8IhB9uW78gGYPuZMj8nYtKz90=;
        b=evcAn45O46J9NJc9/NfRw0xaQkugHFdWYx48Sa7lebv84DHdj8rQZCCMhLmHT/zh2M4AAp
        akc7TTXv50nPmd2r08ctw3Ds4kOvOSAnDybU89eiGcPLw58WoxnFfsRwG78wfFENwDQVf0
        kFxD5wfSon6G8iXpLbtc9Xj/z7CSUMI=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-iz8tm95EP_yojsjeMo89vw-1; Thu, 16 Apr 2020 10:02:02 -0400
X-MC-Unique: iz8tm95EP_yojsjeMo89vw-1
Received: by mail-lf1-f72.google.com with SMTP id l28so2322142lfp.8
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 07:02:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ompQzSPLF05tcBnPen8IhB9uW78gGYPuZMj8nYtKz90=;
        b=n2BAt6EfwiKacwQydzumDjYjjhU4f62EvQrHSvCtB60EzRk2pnWktUGYWbXEJ+COv0
         9qrJ8IO11vWX3QCYvp6TCgz+8ypcNo6WYxa28WsG0RNg+fkK1QhbXYp3lCgSgjQX+Xoa
         Su60DEMkklTziEP9k7jIAWU4/O0iuoETNEmbBDNghxCxaU87P/b+VlSGbrezA+8MbX5x
         lxNdpSx5B4AzdIThUDbxv+xkHGfh4CL1Li/k7Swzi8EpOaJg7r0FQccf233RjKalM6sc
         Tjmzsls4pB937hSRHTIMFWFaIfUOaiy9BxeeV5gjNkmWaTE9vBtXCLA0bpos5Zi7q5dv
         FIrw==
X-Gm-Message-State: AGi0PuZVRPSpIAdc4V6/PnOPAx5DGf/M6stq9+xZ46+PMGbqe5bM7Wbp
        Rt77GWnzrF7Fc/Om4MFsaGokbLDbLCfKHcc8vhWP+qGP4WRr2JCxLjsVSSg6goImb8sUPxKMGWD
        kSllZdzUGWx9NxBvP
X-Received: by 2002:a2e:b162:: with SMTP id a2mr6590522ljm.25.1587045720863;
        Thu, 16 Apr 2020 07:02:00 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ0/CG4RiPNUWxf05I6tBiZl61O3GFDEc+kBap4zUibnD1v/RdcWyGKDtfU4wGlRdqzO0Tq5Q==
X-Received: by 2002:a2e:b162:: with SMTP id a2mr6590498ljm.25.1587045720498;
        Thu, 16 Apr 2020 07:02:00 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id n9sm13887980ljo.89.2020.04.16.07.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 07:01:59 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3DD21181587; Thu, 16 Apr 2020 16:01:59 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH RFC-v5 bpf-next 02/12] net: Add BPF_XDP_EGRESS as a bpf_attach_type
In-Reply-To: <20200413171801.54406-3-dsahern@kernel.org>
References: <20200413171801.54406-1-dsahern@kernel.org> <20200413171801.54406-3-dsahern@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 16 Apr 2020 16:01:59 +0200
Message-ID: <87k12fleaw.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@kernel.org> writes:

> From: David Ahern <dahern@digitalocean.com>
>
> Add new bpf_attach_type, BPF_XDP_EGRESS, for BPF programs attached
> at the XDP layer, but the egress path.
>
> Since egress path will not have ingress_ifindex and rx_queue_index
> set, update xdp_is_valid_access to block access to these entries in
> the xdp context when a program is attached to egress path.
>
> Update dev_change_xdp_fd to verify expected_attach_type for a program
> is BPF_XDP_EGRESS if egress argument is set.
>
> The next patch adds support for the egress ifindex.
>
> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
> Signed-off-by: David Ahern <dahern@digitalocean.com>
> ---
>  include/uapi/linux/bpf.h       | 1 +
>  net/core/dev.c                 | 6 ++++++
>  net/core/filter.c              | 8 ++++++++
>  tools/include/uapi/linux/bpf.h | 1 +
>  4 files changed, 16 insertions(+)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 2e29a671d67e..a9d384998e8b 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -215,6 +215,7 @@ enum bpf_attach_type {
>  	BPF_TRACE_FEXIT,
>  	BPF_MODIFY_RETURN,
>  	BPF_LSM_MAC,
> +	BPF_XDP_EGRESS,
>  	__MAX_BPF_ATTACH_TYPE
>  };
>  
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 06e0872ecdae..e763b6cea8ff 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -8731,6 +8731,12 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
>  		if (IS_ERR(prog))
>  			return PTR_ERR(prog);
>  
> +		if (egress && prog->expected_attach_type != BPF_XDP_EGRESS) {
> +			NL_SET_ERR_MSG(extack, "XDP program in Tx path must use BPF_XDP_EGRESS attach type");
> +			bpf_prog_put(prog);
> +			return -EINVAL;
> +		}
> +
>  		if (!offload && bpf_prog_is_dev_bound(prog->aux)) {
>  			NL_SET_ERR_MSG(extack, "using device-bound program without HW_MODE flag is not supported");
>  			bpf_prog_put(prog);
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 7628b947dbc3..c4e0e044722f 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -6935,6 +6935,14 @@ static bool xdp_is_valid_access(int off, int size,
>  				const struct bpf_prog *prog,
>  				struct bpf_insn_access_aux *info)
>  {
> +	if (prog->expected_attach_type == BPF_XDP_EGRESS) {
> +		switch (off) {
> +		case offsetof(struct xdp_md, ingress_ifindex):
> +		case offsetof(struct xdp_md, rx_queue_index):
> +			return false;
> +		}
> +	}
> +

How will this be handled for freplace programs - will they also
"inherit" the expected_attach_type of the programs they attach to?

-Toke

