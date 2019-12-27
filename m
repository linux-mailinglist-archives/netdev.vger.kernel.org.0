Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E81212B52D
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 15:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfL0O2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 09:28:12 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:28909 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726053AbfL0O2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 09:28:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577456890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dlbDdFvvMF/CVyvyB3gztoa1q7HLWt6zjqVesg+LEQE=;
        b=M5VHHiyAKAgxpx3wxeAEReyEqKmFYq3otIKpcGCC5xIJCEzuX1N63yEoTpzCqGQUBZRHjz
        NC7z0vzA4D9gFbryiec9KrzUAl1KcikgMTBMRKLhWFS+qQvj+AdFnX8Zu/TcIYPfOFHlG1
        ERaFnftvb9K9j+wBPRUl612zrWL75vw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-178-SAla8A8fOIWA25lA_SunJw-1; Fri, 27 Dec 2019 09:28:06 -0500
X-MC-Unique: SAla8A8fOIWA25lA_SunJw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E0D88024D2;
        Fri, 27 Dec 2019 14:28:04 +0000 (UTC)
Received: from carbon (ovpn-200-18.brq.redhat.com [10.40.200.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 90C535C28F;
        Fri, 27 Dec 2019 14:27:56 +0000 (UTC)
Date:   Fri, 27 Dec 2019 15:27:52 +0100
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
To:     Prashant Bhole <prashantbhole.linux@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        David Ahern <dahern@digitalocean.com>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org
Subject: Re: [RFC v2 net-next 01/12] net: introduce BPF_XDP_EGRESS attach
 type for XDP
Message-ID: <20191227152752.6b04c562@carbon>
In-Reply-To: <20191226023200.21389-2-prashantbhole.linux@gmail.com>
References: <20191226023200.21389-1-prashantbhole.linux@gmail.com>
        <20191226023200.21389-2-prashantbhole.linux@gmail.com>
Organization: Red Hat Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Dec 2019 11:31:49 +0900
Prashant Bhole <prashantbhole.linux@gmail.com> wrote:

> This patch introduces a new bpf attach type BPF_XDP_EGRESS. Programs
> having this attach type will be allowed to run in the tx path. It is
> because we need to prevent the programs from accessing rxq info when
> they are running in tx path. Verifier can reject the programs those
> have this attach type and trying to access rxq info.
> 
> Patch also introduces a new netlink attribute IFLA_XDP_TX which can
> be used for setting XDP program in tx path and to get information of
> such programs.
> 
> Drivers those want to support tx path XDP needs to handle
> XDP_SETUP_PROG_TX and XDP_QUERY_PROG_TX cases in their ndo_bpf.

Why do you keep the "TX" names, when you introduce the "EGRESS"
attachment type?

Netlink attribute IFLA_XDP_TX is particularly confusing.

I personally like that this is called "*_XDP_EGRESS" to avoid confusing
with XDP_TX action.

BTW, should the XDP_EGRESS program also inspect XDP_TX packets?


> Signed-off-by: David Ahern <dahern@digitalocean.com>
> Co-developed-by: Prashant Bhole <prashantbhole.linux@gmail.com>
> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
> ---
>  include/linux/netdevice.h      |   4 +-
>  include/uapi/linux/bpf.h       |   1 +
>  include/uapi/linux/if_link.h   |   1 +
>  net/core/dev.c                 |  34 +++++++---
>  net/core/filter.c              |   8 +++
>  net/core/rtnetlink.c           | 112 ++++++++++++++++++++++++++++++++-
>  tools/include/uapi/linux/bpf.h |   1 +
>  7 files changed, 150 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 469a297b58c0..ac3e88d86581 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -865,8 +865,10 @@ enum bpf_netdev_command {
>  	 */
>  	XDP_SETUP_PROG,
>  	XDP_SETUP_PROG_HW,
> +	XDP_SETUP_PROG_TX,
>  	XDP_QUERY_PROG,
>  	XDP_QUERY_PROG_HW,
> +	XDP_QUERY_PROG_TX,
>  	/* BPF program for offload callbacks, invoked at program load time. */
>  	BPF_OFFLOAD_MAP_ALLOC,
>  	BPF_OFFLOAD_MAP_FREE,
> @@ -3725,7 +3727,7 @@ struct sk_buff *dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev,
>  
>  typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
>  int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
> -		      int fd, u32 flags);
> +		      int fd, u32 flags, bool tx);
>  u32 __dev_xdp_query(struct net_device *dev, bpf_op_t xdp_op,
>  		    enum bpf_netdev_command cmd);
>  int xdp_umem_query(struct net_device *dev, u16 queue_id);
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index dbbcf0b02970..23c1841c8086 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -203,6 +203,7 @@ enum bpf_attach_type {
>  	BPF_TRACE_RAW_TP,
>  	BPF_TRACE_FENTRY,
>  	BPF_TRACE_FEXIT,
> +	BPF_XDP_EGRESS,
>  	__MAX_BPF_ATTACH_TYPE
>  };
>  
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 1d69f637c5d6..be97c9787140 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -170,6 +170,7 @@ enum {
>  	IFLA_PROP_LIST,
>  	IFLA_ALT_IFNAME, /* Alternative ifname */
>  	IFLA_PERM_ADDRESS,
> +	IFLA_XDP_TX,
>  	__IFLA_MAX
>  };



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

