Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 622A91AE6BA
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 22:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730963AbgDQUXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 16:23:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730903AbgDQUXj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 16:23:39 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75B59206D9;
        Fri, 17 Apr 2020 20:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587155018;
        bh=7InnLoOqPzrRtVKlgKzPQocXznm4UXG6H8+0gsMEbv0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u0vRdwAOg4/PwTB0GGa0GexdDqH+hFRbjNfLaLUdijVtMM49H3mVlqAxlobC5wjof
         JH+9WLfusZepVd2WGw08sbTrwCZeTCaPJLzMS2uvANMnwsFNfdObOtF51lONzmRBAi
         2exD2/+NdkgYIvdYZo5M4mvzZtzkYqfRCXmRCXEI=
Date:   Fri, 17 Apr 2020 23:23:32 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     gregkh@linuxfoundation.org, jgg@ziepe.ca,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [RFC PATCH v5 07/16] RDMA/irdma: Add connection manager
Message-ID: <20200417202332.GG3083@unreal>
References: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
 <20200417171251.1533371-8-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417171251.1533371-8-jeffrey.t.kirsher@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 10:12:42AM -0700, Jeff Kirsher wrote:
> From: Mustafa Ismail <mustafa.ismail@intel.com>
>
> Add connection management (CM) implementation for
> iWARP including accept, reject, connect, create_listen,
> destroy_listen and CM utility functions
>
> Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> ---
>  drivers/infiniband/hw/irdma/cm.c | 4499 ++++++++++++++++++++++++++++++
>  drivers/infiniband/hw/irdma/cm.h |  413 +++
>  2 files changed, 4912 insertions(+)
>  create mode 100644 drivers/infiniband/hw/irdma/cm.c
>  create mode 100644 drivers/infiniband/hw/irdma/cm.h
>
> diff --git a/drivers/infiniband/hw/irdma/cm.c b/drivers/infiniband/hw/irdma/cm.c
> new file mode 100644
> index 000000000000..87d6300fee35
> --- /dev/null
> +++ b/drivers/infiniband/hw/irdma/cm.c
> @@ -0,0 +1,4499 @@
> +// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
> +/* Copyright (c) 2015 - 2019 Intel Corporation */
> +#include <linux/highmem.h>
> +#include <net/addrconf.h>
> +#include <net/ip6_route.h>
> +#include <net/flow.h>
> +#include <net/secure_seq.h>
> +
> +#include "main.h"
> +#include "trace.h"
> +
> +static void irdma_rem_ref_cm_node(struct irdma_cm_node *);
> +static void irdma_cm_post_event(struct irdma_cm_event *event);
> +static void irdma_disconnect_worker(struct work_struct *work);
> +
> +/**
> + * irdma_free_sqbuf - put back puda buffer if refcount is 0
> + * @vsi: The VSI structure of the device
> + * @bufp: puda buffer to free
> + */
> +void irdma_free_sqbuf(struct irdma_sc_vsi *vsi, void *bufp)
> +{
> +	struct irdma_puda_buf *buf = bufp;
> +	struct irdma_puda_rsrc *ilq = vsi->ilq;
> +
> +	if (refcount_dec_and_test(&buf->refcount))
> +		irdma_puda_ret_bufpool(ilq, buf);
> +}
> +
> +/**
> + * irdma_derive_hw_ird_setting - Calculate IRD
> + * @cm_ird: IRD of connection's node
> + *
> + * The ird from the connection is rounded to a supported HW
> + * setting (2,8,32,64,128) and then encoded for ird_size field
> + * of qp_ctx
> + */
> +u8 irdma_derive_hw_ird_setting(u16 cm_ird)
> +{
> +	/* ird_size field is encoded in qp_ctx */
> +	switch (cm_ird ? roundup_pow_of_two(cm_ird) : 0) {
> +	case IRDMA_HW_IRD_SETTING_128:
> +		return 4;
> +	case IRDMA_HW_IRD_SETTING_64:
> +		return 3;
> +	case IRDMA_HW_IRD_SETTING_32:
> +	case IRDMA_HW_IRD_SETTING_16:
> +		return 2;
> +	case IRDMA_HW_IRD_SETTING_8:
> +	case IRDMA_HW_IRD_SETTING_4:
> +		return 1;
> +	case IRDMA_HW_IRD_SETTING_2:
> +	default:
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * irdma_record_ird_ord - Record IRD/ORD passed in
> + * @cm_node: connection's node
> + * @conn_ird: connection IRD
> + * @conn_ord: connection ORD
> + */
> +static void irdma_record_ird_ord(struct irdma_cm_node *cm_node, u32 conn_ird,
> +				 u32 conn_ord)
> +{
> +	if (conn_ird > cm_node->dev->hw_attrs.max_hw_ird)
> +		conn_ird = cm_node->dev->hw_attrs.max_hw_ird;
> +
> +	if (conn_ord > cm_node->dev->hw_attrs.max_hw_ord)
> +		conn_ord = cm_node->dev->hw_attrs.max_hw_ord;
> +	else if (!conn_ord && cm_node->send_rdma0_op == SEND_RDMA_READ_ZERO)
> +		conn_ord = 1;
> +	cm_node->ird_size = conn_ird;
> +	cm_node->ord_size = conn_ord;
> +}
> +
> +/**
> + * irdma_copy_ip_ntohl - copy IP address from  network to host
> + * @dst: IP address in host order
> + * @src: IP address in network order (big endian)
> + */
> +void irdma_copy_ip_ntohl(u32 *dst, __be32 *src)
> +{
> +	*dst++ = ntohl(*src++);
> +	*dst++ = ntohl(*src++);
> +	*dst++ = ntohl(*src++);
> +	*dst = ntohl(*src);
> +}
> +
> +/**
> + * irdma_copy_ip_htonl - copy IP address from host to network order
> + * @dst: IP address in network order (big endian)
> + * @src: IP address in host order
> + */
> +void irdma_copy_ip_htonl(__be32 *dst, u32 *src)
> +{
> +	*dst++ = htonl(*src++);
> +	*dst++ = htonl(*src++);
> +	*dst++ = htonl(*src++);
> +	*dst = htonl(*src);
> +}

It is strange that we don't have in the kernel some generic function to
do it.

> +
> +/**
> + * irdma_get_addr_info
> + * @cm_node: contains ip/tcp info
> + * @cm_info: to get a copy of the cm_node ip/tcp info
> + */
> +static void irdma_get_addr_info(struct irdma_cm_node *cm_node,
> +				struct irdma_cm_info *cm_info)
> +{
> +	memset(cm_info, 0, sizeof(*cm_info));
> +	cm_info->ipv4 = cm_node->ipv4;
> +	cm_info->vlan_id = cm_node->vlan_id;
> +	memcpy(cm_info->loc_addr, cm_node->loc_addr, sizeof(cm_info->loc_addr));
> +	memcpy(cm_info->rem_addr, cm_node->rem_addr, sizeof(cm_info->rem_addr));
> +	cm_info->loc_port = cm_node->loc_port;
> +	cm_info->rem_port = cm_node->rem_port;
> +}
> +
> +/**
> + * irdma_fill_sockaddr4 - fill in addr info for IPv4 connection
> + * @cm_node: connection's node
> + * @event: upper layer's cm event
> + */
> +static inline void irdma_fill_sockaddr4(struct irdma_cm_node *cm_node,
> +					struct iw_cm_event *event)
> +{
> +	struct sockaddr_in *laddr = (struct sockaddr_in *)&event->local_addr;
> +	struct sockaddr_in *raddr = (struct sockaddr_in *)&event->remote_addr;
> +
> +	laddr->sin_family = AF_INET;
> +	raddr->sin_family = AF_INET;
> +
> +	laddr->sin_port = htons(cm_node->loc_port);
> +	raddr->sin_port = htons(cm_node->rem_port);
> +
> +	laddr->sin_addr.s_addr = htonl(cm_node->loc_addr[0]);
> +	raddr->sin_addr.s_addr = htonl(cm_node->rem_addr[0]);
> +}
> +
> +/**
> + * irdma_fill_sockaddr6 - fill in addr info for IPv6 connection
> + * @cm_node: connection's node
> + * @event: upper layer's cm event
> + */
> +static inline void irdma_fill_sockaddr6(struct irdma_cm_node *cm_node,
> +					struct iw_cm_event *event)
> +{
> +	struct sockaddr_in6 *laddr6 = (struct sockaddr_in6 *)&event->local_addr;
> +	struct sockaddr_in6 *raddr6 = (struct sockaddr_in6 *)&event->remote_addr;
> +
> +	laddr6->sin6_family = AF_INET6;
> +	raddr6->sin6_family = AF_INET6;
> +
> +	laddr6->sin6_port = htons(cm_node->loc_port);
> +	raddr6->sin6_port = htons(cm_node->rem_port);
> +
> +	irdma_copy_ip_htonl(laddr6->sin6_addr.in6_u.u6_addr32,
> +			    cm_node->loc_addr);
> +	irdma_copy_ip_htonl(raddr6->sin6_addr.in6_u.u6_addr32,
> +			    cm_node->rem_addr);
> +}
> +
> +/**
> + * irdma_get_cmevent_info - for cm event upcall
> + * @cm_node: connection's node
> + * @cm_id: upper layers cm struct for the event
> + * @event: upper layer's cm event
> + */
> +static inline void irdma_get_cmevent_info(struct irdma_cm_node *cm_node,
> +					  struct iw_cm_id *cm_id,
> +					  struct iw_cm_event *event)
> +{
> +	memcpy(&event->local_addr, &cm_id->m_local_addr,
> +	       sizeof(event->local_addr));
> +	memcpy(&event->remote_addr, &cm_id->m_remote_addr,
> +	       sizeof(event->remote_addr));
> +	if (cm_node) {
> +		event->private_data = cm_node->pdata_buf;
> +		event->private_data_len = (u8)cm_node->pdata.size;
> +		event->ird = cm_node->ird_size;
> +		event->ord = cm_node->ord_size;
> +	}
> +}
> +
> +/**
> + * irdma_send_cm_event - upcall cm's event handler
> + * @cm_node: connection's node
> + * @cm_id: upper layer's cm info struct
> + * @type: Event type to indicate
> + * @status: status for the event type
> + */
> +static int irdma_send_cm_event(struct irdma_cm_node *cm_node,
> +			       struct iw_cm_id *cm_id,
> +			       enum iw_cm_event_type type, int status)
> +{
> +	struct iw_cm_event event = {};
> +
> +	event.event = type;
> +	event.status = status;
> +	switch (type) {
> +	case IW_CM_EVENT_CONNECT_REQUEST:
> +		trace_irdma_send_cm_event(cm_node, cm_id, type, status,
> +					  __builtin_return_address(0));
> +		if (cm_node->ipv4)
> +			irdma_fill_sockaddr4(cm_node, &event);
> +		else
> +			irdma_fill_sockaddr6(cm_node, &event);
> +		event.provider_data = cm_node;
> +		event.private_data = cm_node->pdata_buf;
> +		event.private_data_len = (u8)cm_node->pdata.size;
> +		event.ird = cm_node->ird_size;
> +		break;
> +	case IW_CM_EVENT_CONNECT_REPLY:
> +		trace_irdma_send_cm_event(cm_node, cm_id, type, status,
> +					  __builtin_return_address(0));
> +		irdma_get_cmevent_info(cm_node, cm_id, &event);
> +		break;
> +	case IW_CM_EVENT_ESTABLISHED:
> +		trace_irdma_send_cm_event(cm_node, cm_id, type, status,
> +					  __builtin_return_address(0));
> +		event.ird = cm_node->ird_size;
> +		event.ord = cm_node->ord_size;
> +		break;
> +	case IW_CM_EVENT_DISCONNECT:
> +		trace_irdma_send_cm_event_no_node(cm_id, type, status,
> +						  __builtin_return_address(0));
> +		break;
> +	case IW_CM_EVENT_CLOSE:
> +		trace_irdma_send_cm_event_no_node(cm_id, type, status,
> +						  __builtin_return_address(0));
> +		break;
> +	default:
> +		ibdev_dbg(to_ibdev(cm_node->iwdev),
> +			  "CM: Unsupported event type received type = %d\n",
> +			  type);
> +		return -1;

How are these trace events different from existing in IB/core and why
should driver implement CM event handler? Is it iWARP specific?

I'm really worried to see CM code in the driver.

Thanks
