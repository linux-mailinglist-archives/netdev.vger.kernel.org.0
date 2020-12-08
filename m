Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5DD62D2917
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 11:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728988AbgLHKk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 05:40:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38198 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726226AbgLHKk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 05:40:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607423971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cihcwc3y/hSrH/hmszj3lRZIwEUJKio61G1apuK23x8=;
        b=PLDtd4me4Si49wYWfNBt68I+k5+nsZlmy+10Gydx5CFkhXSbpCJlyV/Bc5wEgg0MiezJ3G
        vbiQfVGlmd9Ck4jSbXbYqniEfddPMOw64/iP46QEU5OIRH4LcMm8cTKSgQwP163UdA0Wd4
        cxG5DfsWQGSeO3LMREtGIpXiq/qBH2A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-XUHcCGL4NyW_0ctGNaAlhg-1; Tue, 08 Dec 2020 05:39:28 -0500
X-MC-Unique: XUHcCGL4NyW_0ctGNaAlhg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E71C196632C;
        Tue,  8 Dec 2020 10:39:18 +0000 (UTC)
Received: from carbon (unknown [10.36.110.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF6146EF55;
        Tue,  8 Dec 2020 10:39:15 +0000 (UTC)
Date:   Tue, 8 Dec 2020 11:39:14 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        brouer@redhat.com
Subject: Re: [PATCHv3 bpf-next] samples/bpf: add xdp program on egress for
 xdp_redirect_map
Message-ID: <20201208113914.7fe9e291@carbon>
In-Reply-To: <20201208081856.1627657-1-liuhangbin@gmail.com>
References: <20201126084325.477470-1-liuhangbin@gmail.com>
        <20201208081856.1627657-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Dec 2020 16:18:56 +0800
Hangbin Liu <liuhangbin@gmail.com> wrote:

> This patch add a xdp program on egress to show that we can modify
> the packet on egress. In this sample we will set the pkt's src
> mac to egress's mac address. The xdp_prog will be attached when
> -X option supplied.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
> v3:
> a) modify the src mac address based on egress mac
> 
> v2:
> a) use pkt counter instead of IP ttl modification on egress program
> b) make the egress program selectable by option -X
> ---
>  samples/bpf/xdp_redirect_map_kern.c |  60 ++++++++++-
>  samples/bpf/xdp_redirect_map_user.c | 153 ++++++++++++++++++++--------
>  2 files changed, 168 insertions(+), 45 deletions(-)
> 

[...]
> diff --git a/samples/bpf/xdp_redirect_map_user.c b/samples/bpf/xdp_redirect_map_user.c
> index 31131b6e7782..19636045c8dc 100644
> --- a/samples/bpf/xdp_redirect_map_user.c
> +++ b/samples/bpf/xdp_redirect_map_user.c
> @@ -14,6 +14,10 @@
>  #include <unistd.h>
>  #include <libgen.h>
>  #include <sys/resource.h>
> +#include <sys/ioctl.h>
> +#include <sys/types.h>
> +#include <sys/socket.h>
> +#include <netinet/in.h>
>  
>  #include "bpf_util.h"
>  #include <bpf/bpf.h>
> @@ -21,7 +25,8 @@
>  
>  static int ifindex_in;
>  static int ifindex_out;
> -static bool ifindex_out_xdp_dummy_attached = true;
> +static bool ifindex_out_xdp_dummy_attached = false;
> +static bool xdp_devmap_attached = false;
>  static __u32 prog_id;
>  static __u32 dummy_prog_id;
>  
> @@ -83,6 +88,29 @@ static void poll_stats(int interval, int ifindex)
>  	}
>  }
>  
> +static int get_mac_addr(unsigned int ifindex_out, void *mac_addr)
> +{
> +	struct ifreq ifr;
> +	char ifname[IF_NAMESIZE];
> +	int fd = socket(PF_INET, SOCK_DGRAM, IPPROTO_IP);

I would have expected (like ethtool):
 fd = socket(AF_INET, SOCK_DGRAM, 0);

> +	if (fd < 0)
> +		return -1;
> +
> +	if (!if_indextoname(ifindex_out, ifname))
> +		return -1;
> +
> +	strcpy(ifr.ifr_name, ifname);
> +
> +	if (ioctl(fd, SIOCGIFHWADDR, &ifr) != 0)
> +		return -1;
> +
> +	memcpy(mac_addr, ifr.ifr_hwaddr.sa_data, 6 * sizeof(char));
> +	close(fd);
> +
> +	return 0;
> +}
[...]

> -	/* Loading dummy XDP prog on out-device */
> -	if (bpf_set_link_xdp_fd(ifindex_out, dummy_prog_fd,
> -			    (xdp_flags | XDP_FLAGS_UPDATE_IF_NOEXIST)) < 0) {
> -		printf("WARN: link set xdp fd failed on %d\n", ifindex_out);
> -		ifindex_out_xdp_dummy_attached = false;
> -	}
> +	/* If -X supplied, load 2nd xdp prog on egress.
> +	 * If not, just load dummy prog on egress.
> +	 */

The dummy prog need to be loaded, regardless of 2nd xdp prog on egress.


> +	if (xdp_devmap_attached) {
> +		unsigned char mac_addr[6];
>  
> -	memset(&info, 0, sizeof(info));
> -	ret = bpf_obj_get_info_by_fd(dummy_prog_fd, &info, &info_len);
> -	if (ret) {
> -		printf("can't get prog info - %s\n", strerror(errno));
> -		return ret;
> +		devmap_prog = bpf_object__find_program_by_title(obj, "xdp_devmap/map_prog");
> +		if (!devmap_prog) {
> +			printf("finding devmap_prog in obj file failed\n");
> +			goto out;
> +		}
> +		devmap_prog_fd = bpf_program__fd(devmap_prog);
> +		if (devmap_prog_fd < 0) {
> +			printf("finding devmap_prog fd failed\n");
> +			goto out;
> +		}
> +
> +		if (get_mac_addr(ifindex_out, mac_addr) < 0) {
> +			printf("get interface %d mac failed\n", ifindex_out);
> +			goto out;
> +		}
> +
> +		ret = bpf_map_update_elem(tx_mac_map_fd, &key, mac_addr, 0);
> +		if (ret) {
> +			perror("bpf_update_elem tx_mac_map_fd");
> +			goto out;
> +		}
> +	} else if (ifindex_in != ifindex_out) {
> +		dummy_prog = bpf_object__find_program_by_title(obj, "xdp_redirect_dummy");
> +		if (!dummy_prog) {
> +			printf("finding dummy_prog in obj file failed\n");
> +			goto out;
> +		}
> +
> +		dummy_prog_fd = bpf_program__fd(dummy_prog);
> +		if (dummy_prog_fd < 0) {
> +			printf("find dummy_prog fd failed\n");
> +			goto out;
> +		}
> +
> +		if (bpf_set_link_xdp_fd(ifindex_out, dummy_prog_fd,
> +					(xdp_flags | XDP_FLAGS_UPDATE_IF_NOEXIST)) == 0) {
> +			ifindex_out_xdp_dummy_attached = true;
> +		} else {
> +			printf("WARN: link set xdp fd failed on %d\n", ifindex_out);
> +		}
> +
> +		memset(&info, 0, sizeof(info));
> +		ret = bpf_obj_get_info_by_fd(dummy_prog_fd, &info, &info_len);
> +		if (ret) {
> +			printf("can't get prog info - %s\n", strerror(errno));
> +		}
> +		dummy_prog_id = info.id;
>  	}
> -	dummy_prog_id = info.id;
>  
>  	signal(SIGINT, int_exit);
>  	signal(SIGTERM, int_exit);
>  
> -	/* populate virtual to physical port map */
> -	ret = bpf_map_update_elem(tx_port_map_fd, &key, &ifindex_out, 0);
> +	devmap_val.ifindex = ifindex_out;
> +	devmap_val.bpf_prog.fd = devmap_prog_fd;
> +	ret = bpf_map_update_elem(tx_port_map_fd, &key, &devmap_val, 0);
>  	if (ret) {
> -		perror("bpf_update_elem");
> +		perror("bpf_update_elem tx_port_map_fd");
>  		goto out;
>  	}
>  
>  	poll_stats(2, ifindex_out);
>  
>  out:
> -	return 0;
> +	bpf_object__close(obj);
> +	return 1;
>  }



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

